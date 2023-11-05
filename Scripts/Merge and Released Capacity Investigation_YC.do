                                  =
/*******************************************************************************
Program:     Merge and Released Capacity Investigation
Author:      Anna Li and YChen
Date:        August 2023
*******************************************************************************/

clear all 		
capture log close 
set type double
set more off

*global path    "/Users/anna/Desktop/RA summer 2023/pipeline data analysis/aug 20"
*global input   "$path/Input"
global path "C:\Users\Roy\OneDrive - University of Toronto\GasPipelineRA\Clean Data"
global input "C:\Users\Roy\OneDrive - University of Toronto\GasPipelineRA\Clean Data"
global output  "$path/Output"
global temp    "$path/Temp"
********************************************************************************
*Generate dummy variable for customer index
use "$input/IndexofCustomers_Clean",clear
sort Pipeline Shipper YearlyQuarter
//eliminate doublecounting the same contracts
duplicates drop Pipeline Shipper YearlyQuarter ContractNumber ContractStart ContractEnd quantity, force
//generate total quantity per pipeline releaser quarter
bysort Pipeline Shipper YearlyQuarter: egen totalind_quantity = total(quantity)
//limit to unique pipeline shipper yearly quarter combination
duplicates drop Pipeline Shipper YearlyQuarter,force

save "$temp/customer_index_dum.dta",replace
********************************************************************************
*Generate dummy variable for capacity release
use "$input/CapacityRelease_Clean_Namechange",clear
bysort Pipeline ReleaseShipper YearlyQuarter: egen totalrelease_quantity = total(Quantity)
bysort Pipeline ReleaseShipper ReplaceShipper YearlyQuarter: egen totalreplace_quantity = total(Quantity)

duplicates drop Pipeline ReleaseShipper ReplaceShipper YearlyQuarter,force
rename ReleaseShipper Shipper

save "$temp/capacity_dum.dta",replace

********************************************************************************
*MERGE WITH CAPACITY RELEASE DATA
use "$temp/customer_index_dum.dta",clear
merge 1:m Pipeline Shipper YearlyQuarter using "$temp/capacity_dum.dta"
save "$temp/merged.dta",replace

//Q1: Who will participate?
//investigate how many are in the market
use "$temp/merged.dta",clear
duplicates drop Pipeline Shipper YearlyQuarter, force
tab _merge
//15,077 matched, 26,388 cases where not in market
bysort Pipeline: tab _merge
bysort YearlyQuarter: tab _merge

********************************************************************************

//replicating calculations at pipeline-shipper level
use "$input/IndexofCustomers_Clean",clear
drop if quantity ==0 //to avoid the 0 observation (which is default first) from being saved in duplicates drop command
//eliminate doublecounting the same contracts
duplicates drop Pipeline Shipper YearlyQuarter ContractNumber ContractStart ContractEnd, force
//generate total quantity per pipeline releasershipper
bysort Pipeline Shipper: egen totalind_quantity = total(quantity)
//limit to unique pipeline shipper yearly quarter combination
duplicates drop Pipeline Shipper,force
save "$temp/customer_index_dum2.dta",replace

*Generate dummy variable for capacity release
use "$input/CapacityRelease_Clean_Namechange",clear
bysort Pipeline ReleaseShipper: egen totalrelease_quantity = total(Quantity)
bysort Pipeline ReleaseShipper ReplaceShipper: egen totalreplace_quantity = total(Quantity)

duplicates drop Pipeline ReleaseShipper ReplaceShipper,force
rename ReleaseShipper Shipper

save "$temp/capacity_dum2.dta",replace


use "$temp/customer_index_dum2.dta",clear
merge 1:m Pipeline Shipper using "$temp/capacity_dum2.dta"
save "$temp/merged2.dta",replace

//Q1: Who will participate?
//investigate how many are in the market
use "$temp/merged2.dta",clear
duplicates drop Pipeline Shipper,force
tab _merge

//373 matched, 555 cases where not in market
bysort Pipeline: tab _merge

*****************************************************************
* What is the quantity being released in the secondary market	*
*****************************************************************
* IOC data
use "$input/IndexofCustomers_Clean",clear
replace MaxDailyTransport = 0 if MaxDailyTransport == .
bysort Pipeline Shipper YearlyQuarter: egen total_IOC_quantity = total(MaxDailyTransport)
duplicates drop Pipeline Shipper YearlyQuarter,force
keep Pipeline Shipper YearlyQuarter total_IOC_quantity
save "$temp/IOC_quantity.dta",replace

* Capacity release data
use "$input/CapacityRelease_Clean_Namechange",clear
replace Quantity = 0 if Quantity == .
bysort Pipeline ReleaseShipper YearlyQuarter: egen totalrelease_quantity = total(Quantity)
duplicates drop Pipeline ReleaseShipper YearlyQuarter,force
rename ReleaseShipper Shipper
keep Pipeline Shipper YearlyQuarter totalrelease_quantity
save "$temp/Release_quantity.dta",replace

* merge two dataset
use "$temp/IOC_quantity.dta", clear
merge 1:1 Pipeline Shipper YearlyQuarter using "$temp/Release_quantity.dta"
save "$temp/merged_YC.dta",replace

keep if _merge == 3
gen release_proportion = totalrelease_quantity / total_IOC_quantity

tabstat release_proportion, stats(p25 p50 p75 mean max)
tabstat release_proportion, by(Pipeline) stats(p25 p50 p75 mean max)






