clear
capture log close
set more off
capture close
***************************************************************
//Author: Anna Li
//Task: Data Analysis
//Modification date: March 28, 2023
***************************************************************

*** Change working directory:
global dirData "/Users/anna/Desktop/RA work/2018/jan/ind-0118"
global dirOutput "/Users/anna/Desktop/RA work/2018/jan"
cd "$dirData"


use "/Users/anna/Desktop/RA work/2018/jan/output/jan2018merged_AL.dta", clear
save _temp, replace

//get unique number of contracts
use _temp, clear
drop strip*
duplicates drop companyid contractnum, force
//generate pipeline total capacity
bysort companyid: egen total_cap = total(numerical_trans_maxdquant)
//note: couple of companies such as i1311801 where total capacity = 0 as trans_maxdquant=0, while point data does have trans_quant existing
save unique_contract, replace

//get unique number of shippers/customers per pipeline
use _temp,clear
duplicates drop companyid shippername, force
save unique_shipper, replace

//generate unique shipper-firm pair
use _temp,clear
//add total capacity from pipeline info
merge m:1 companyid contractnum using unique_contract
drop _merge
//drop identical accounts of same contract per shipper-firm pair
duplicates drop companyid stripped_shippername contractnum, force
drop strip*
//count number of duplicates
bysort companyid shippername: gen dup= cond(_N==1,0,_n)
//generate shipper-pair firm id
egen pairid = group(companyid shippername)
//generate total capacity per firm-shipper pair
bysort pairid: egen pair_cap = total(numerical_trans_maxdquant)
duplicates drop pairid, force
drop dup

//generate fraction,  how much is allocated to a customer per pipeline
gen pair_fraction = pair_cap/total_cap

//generate duration
gen date_contract_effective =date(contract_effectivedate, "MDY")
gen date_contract_expir =date(contract_prim_expirdate, "MDY")
format date_contract*  %td
gen duration = date_contract_expir - date_contract_effective
save test, replace
save "$dirOutput/jan2018analysis.dta", replace

use test, clear
//summary statistics
//note: i0151801 had some negative observations which should've not existed; was present in original file 
sum duration, detail

//duration-> plot a histogram of duration
hist duration, title(overall) bin(10)
graph export "$dirOutput/overall.jpg", as(jpg) name("Graph") quality(90)
twoway scatter duration pair_frac
twoway scatter duration pair_cap

//replicated for different quantiles of 
sum pair_frac, detail
//lower 25% 
keep if pair_frac < .0002274   
hist duration, title(lower 25%) bin(10)
graph export "$dirOutput/low25.jpg", as(jpg) name("Graph") quality(90)

sum duration

//top 25%
use test, clear
keep if pair_frac >.015544   
hist duration, title(top 25%) bin(10)
graph export "$dirOutput/top25.jpg", as(jpg) name("Graph") quality(90)

sum duration

//low 10% 
use test, clear
keep if pair_frac < .0000375     
hist duration, title(lower 10%) bin(10)
graph export "$dirOutput/low10.jpg", as(jpg) name("Graph") quality(90)

sum duration

//top 10%
use test, clear
keep if pair_frac >.0544134           
hist duration, title(top 10%) bin(10)
graph export "$dirOutput/top10.jpg", as(jpg) name("Graph") quality(90)

sum duration

//Is their a relationship between duration and capacity?
//if exists, not obvious
************************************************************************************************
//Eliminating negative duration values
use test, clear
drop if duration<0
sum pair_frac, detail
save test2, replace
//lower 25% 
keep if pair_frac < .0002274   
hist duration, title(lower 25%) bin(10)
graph export "$dirOutput/filtered_low25.jpg", as(jpg) name("Graph") quality(90)

sum duration

//top 25%
use test2, clear
keep if pair_frac >.015544   
hist duration, title(top 25%) bin(10)
graph export "$dirOutput/filtered_top25.jpg", as(jpg) name("Graph") quality(90)

sum duration

//low 10% 
use test2, clear
keep if pair_frac < .0000375     
hist duration, title(lower 10%) bin(10)
graph export "$dirOutput/filtered_low10.jpg", as(jpg) name("Graph") quality(90)

sum duration

//top 10%
use test2, clear
keep if pair_frac >.0544134           
hist duration, title(top 10%) bin(10)
graph export "$dirOutput/filtered_top10.jpg", as(jpg) name("Graph") quality(90)

sum duration
//has higher max for top percentile, but min is also smaller in top percentile than in bottom percentile
