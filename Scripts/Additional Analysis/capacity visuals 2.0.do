***************************************************************
/*

Author: Anna 
Date: August 2023
Description: Capacity release analysis revised
 ***************************************************************/

global data "/Users/anna/Desktop/RA summer 2023/Clean Data"
***************************************************************
//replicating figures for entire date range
use "$data/CapacityRelease_Clean.dta",clear

//for table 5-7, limit date range to december 2022 and march 9 2023 for ContractDate
gen date_month = month(ContractDate)
gen date_year = year(ContractDate)
gen date_day =day(ContractDate)

sort StartDate
save "$data/entiredata.dta",replace

//table 4: number of unique contracts released by pipeline
sort Pipeline ContractNumber
duplicates report Pipeline ContractNumber
//want unique contracts only
duplicates drop ContractNumber,force
save "$data/uniquecontracts.dta", replace
tab Pipeline

//table 5: number of unique contract releasers by pipeline
duplicates drop Pipeline ReleaseShipper,force
tab Pipeline


//table 6: number of unique contract holders by pipeline
use "$data/uniquecontracts.dta",clear
duplicates drop Pipeline ReplaceShipper, force
tab Pipeline

//table 7: distribution of entitlement contract duration (days)
use "$data/entiredata.dta",clear
//generate contract duration
gen ContractDuration = EndDate-StartDate
sum ContractDuration
sum ContractDuration,detail


//figures
//Figure 11: Distribution of Posting Date
//assume posting date is contract date

histogram ContractDate, bin(30) title("Histogram of Contract Date") xtitle("Posting Date") ytitle("Frequency")

//Figure 12: Distribution of Contract Duration (less than 1 year zoom)
hist ContractDuration if ContractDuration<360, title("Distribution of Contract Duration (less than 1 year zoom)") xtitle("Number of Days") xtick(0(20)360) xlabel(0(20)360)

//Figure 13: Distribution of Contract Duration (less than 2 months)
hist ContractDuration if ContractDuration<60, title("Distribution of Contract Duration (less than 2 months zoom)") xtitle("Number of Days") xtick(0(5)60) xlabel(0(5)60)

***************************************************************
//replicating figures for 2015-2023

//table 8: number of market participants by pipeline
//unique relations
use "$data/CapacityRelease_Clean.dta",clear
sort Pipeline ReleaseShipper ReplaceShipper ContractDate
gen year = year(ContractDate)
drop if year<2015
save "$data/CapacityRelease_2015.dta",replace

duplicates drop ContractNumber,force
save "$data/uniquecontracts.dta",replace
duplicates drop Pipeline ReleaseShipper ReplaceShipper, force

bysort Pipeline: gen relation_count = _N
collapse (count) relation_count, by(Pipeline)
save "$data/uniquerelations.dta", replace

//unique holders
use "$data/CapacityRelease_2015.dta",clear
duplicates drop Pipeline ReplaceShipper,force
bysort Pipeline: gen holder_count = _N
collapse (count) holder_count, by(Pipeline)
save "$data/uniqueholders.dta", replace

//unique releasers
use "$data/CapacityRelease_2015.dta",clear
duplicates drop Pipeline ReleaseShipper,force
bysort Pipeline: gen releaser_count = _N
collapse (count) releaser_count, by(Pipeline)
save "$data/uniquereleasers.dta", replace

//merge datasets
merge 1:1 Pipeline using "$data/uniqueholders.dta"
drop _merge
merge 1:1 Pipeline using "$data/uniquerelations.dta"
drop _merge
save "$data/marketparticipants.dta",replace

//table 9: unique contracts and quantity by pipeline
use "$data/CapacityRelease_2015.dta",clear
sort Pipeline ReleaseShipper ReplaceShipper ContractDate Quantity
duplicates drop ContractNumber,force
gen date_year = year(ContractDate)

bysort date_year Pipeline: gen contract_count = _N
bysort date_year Pipeline: egen total_quantity = sum(Quantity)

bysort date_year Pipeline: tab total_quant contract_count

//table 10: proportion of unique contracts in diff categories
//note: could not find the number that were biddable or permanent release
bysort date_year: gen total_contracts = _N
egen recall_count = total(Recall == "Y"), by(date_year )
egen reput_count = total(Reput == "Yes" | Reput == "Yes with Buyer Consent"), by(date_year)
egen rerelease_count = total(ReRelease == "Y"), by(date_year)

gen recall_prop = recall_count/total_contracts
gen reput_prop = reput_count/total_contracts
gen rerelease_prop = rerelease_count/total_contracts

collapse recall_prop reput_prop rerelease_prop, by(date_year)

save "$data/propincat.dta",replace

//table 11: proportion of biddable contracts by pipeline
//unknown, since do not know biddable variable

//figures
//figure 14: monthly aggregate quantity released
//used contract date
use "$data/CapacityRelease_2015.dta",clear
sort ContractDate
gen formatted_date = string(year(ContractDate)) + "m" + string(month(ContractDate))
gen nummonth = monthly(formatted_date, "YM")
format nummonth %tm
bysort nummonth: egen aggregate_quantity = sum(Quantity)

twoway (connected aggregate_quantity nummonth, msize(2-pt)), xlabel(#5, labsize(small)) tlabel (2015m10(12)2023m10)
save "$data/bymonth.dta",replace

//figure 15: number of contracts signed monthly
use "$data/bymonth.dta",clear
sort ContractDate
duplicates drop ContractNumber, force
bysort nummonth: gen total_contractsigned = _N

twoway (connected total_contractsigned nummonth, msize(2-pt)),xlabel(#20, labsize(small)) tlabel(2015m10(12)2023m10) ylabel(,angle(horizontal))

//figure 16: distribution of contract duration: all contracts
use "$data/CapacityRelease_2015.dta",clear
gen ContractDuration = EndDate-StartDate
graph twoway histogram ContractDuration,xlabel(#10)
summarize ContractDuration,detail

//trim 95%
use "$data/CapacityRelease_2015.dta",clear
gen ContractDuration = EndDate-StartDate
// Calculate the trimming values
summarize ContractDuration,detail
//limit to 95%
drop if ContractDuration >365
graph twoway histogram ContractDuration,xlabel(#10)



//figure 17: distribution of contract duration: contracts signed in october
use "$data/CapacityRelease_2015.dta",clear
gen ContractDuration = EndDate-StartDate
gen month = month(ContractDate)
keep if month ==10
graph twoway histogram ContractDuration,xlabel(#10)

//limit to 95%
drop if ContractDuration > 365
graph twoway histogram ContractDuration,xlabel(#10)

***************************************************************
//holder releaser relationships

//table 12: number of unique relationships and number of interactions 
//redefined Unique relationships//
// number of interactions-> number of contract numbers
use "$data/CapacityRelease_2015.dta",clear
duplicates drop Pipeline ReleaseShipper ReplaceShipper ContractNumber,force
bysort Pipeline ReleaseShipper ReplaceShipper: gen interaction_count = _N
tab interaction_count


//b) unique relations and same loc/del points
//use PointName as criteria
use "$data/CapacityRelease_2015.dta",clear
duplicates drop Pipeline ReleaseShipper ReplaceShipper ContractNumber,force
//count number of interactions
duplicates tag Pipeline ReleaseShipper ReplaceShipper PointName, gen(dup)
gen interaction = dup + 1
tab interaction

//table 13: number of contracts by number of interactions
use "$data/CapacityRelease_2015.dta",clear
duplicates drop Pipeline ReleaseShipper ReplaceShipper ContractNumber,force
bysort Pipeline ReleaseShipper ReplaceShipper: gen interaction_count = _N
tab interaction_count

//table 14: contract duration by number of interactions
use "$data/CapacityRelease_2015.dta",clear
duplicates drop Pipeline ReleaseShipper ReplaceShipper ContractNumber, force
bysort Pipeline ReleaseShipper ReplaceShipper: gen interaction_count = _N
gen duration = EndDate-StartDate
gen h_less5 = interaction_count<5
gen h_5in20 = interaction_count>=5 & interaction_count <20
gen h_20in30 = interaction_count>=20 & interaction_count <30
gen h_great30 = interaction_count>=30
summ duration if h_less5,detail
summ duration if h_5in20,detail
summ duration if h_20in30,detail
summ duration if h_great30,detail

//table 15: months contracts are signed by number of interactions
gen month = month(ContractDate)
tab month if h_less5
tab month if h_5in20
tab month if h_20in30
tab month if h_great30


//figure 18: number of holders per releasers
use "$data/uniquecontracts.dta",clear
duplicates drop Pipeline ReleaseShipper ReplaceShipper, force
bysort ReleaseShipper ReplaceShipper: gen unique_count = _n==1
bysort ReleaseShipper: egen holder_num = total(unique_count)
twoway histogram holder_num
//figure 19: number of releasers per holders
bysort ReplaceShipper: egen release_num = total(unique_count)
twoway histogram release_num


/*calculating market share:
1. market share:
summarize over releasers the total number of holders for entire dataset
calculate for each releaser their proportion

2.alternative
sum over total quantity of total dataset
know how many contracts a releaser has
sum over total quantity per releaser (over all their contracts) and use this as proportion by dividing by total
*/
//definition 1 figure 20 and figure 21
use "$data/uniquecontracts.dta",clear
duplicates drop Pipeline ReleaseShipper ReplaceShipper, force
bysort Pipeline ReleaseShipper ReplaceShipper: gen unique_count = _n==1
//summarize over releaser, total number of holders by pipeline
bysort Pipeline ReleaseShipper: egen holder_num = total(unique_count)
duplicates drop Pipeline ReleaseShipper, force
egen holder_total = total(holder_num)
save "$data/totalforreleaseshippers.dta",replace

use "$data/uniquecontracts.dta",clear
duplicates drop Pipeline ReleaseShipper ReplaceShipper, force
bysort Pipeline ReleaseShipper ReplaceShipper: gen unique_count = _n==1
//summarize over holder, total number of releasers
bysort Pipeline ReplaceShipper: egen release_num = total(unique_count)
duplicates drop Pipeline ReplaceShipper,force
egen release_total = total(release_num)

save "$data/totalforreplaceshippers.dta",replace

//holders per releasers
use "$data/totalforreleaseshippers.dta",clear

duplicates drop Pipeline ReleaseShipper,force
bysort Pipeline ReleaseShipper: gen holder_prop = holder_num/holder_total
bysort Pipeline: cumul holder_prop, gen(ecd_holder)
sort Pipeline ecd_holder
by Pipeline: gen unique_releaser_count = _n
keep Pipeline ReleaseShipper ReplaceShipper holder_prop ecd_holder unique_releaser_count
save "$data/releasers.dta",replace
export excel "$data/releasers.xlsx",replace

use "$data/totalforreplaceshippers.dta",clear
duplicates drop Pipeline ReplaceShipper, force
bysort Pipeline ReplaceShipper: gen release_prop = release_num/release_total
bysort Pipeline: cumul release_prop, gen(ecd_releaser)
sort Pipeline ecd_releaser
by Pipeline: gen unique_holder_count = _n
keep Pipeline ReleaseShipper ReplaceShipper release_prop ecd_releaser unique_holder_count
save "$data/holder.dta",replace
export excel "$data/holder.xlsx"

//option 2
/*.alternative
sum over total quantity of total dataset
know how many contracts a releaser has
sum over total quantity per releaser (over all their contracts) and use this as proportion by dividing by total*/
use "$data/CapacityRelease_2015",clear
bysort Pipeline: egen overall_quant = sum(Quantity)
drop if missing(Quantity)
bysort Pipeline ReleaseShipper: egen releasers_share = total(Quantity)
duplicates drop Pipeline ReleaseShipper, force
gen releaser_mktshare = releasers_share/overall_quant
keep Pipeline ReleaseShipper ReplaceShipper releaser_mktshare
sort Pipeline releaser_mktshare
by Pipeline: gen count = _n
save "$data/approach2release.dta",replace
export excel "$data/approach2.xlsx", sheet("releasers",replace) 

use "$data/CapacityRelease_2015",clear
bysort Pipeline: egen overall_quant = sum(Quantity)
bysort Pipeline ReplaceShipper: egen holders_share = total(Quantity)
drop if missing(Quantity)
duplicates drop Pipeline ReplaceShipper, force
gen holders_mktshare = holders_share/overall_quant
keep Pipeline ReleaseShipper ReplaceShipper holders_mktshare
sort Pipeline holders_mktshare 
by Pipeline: gen count = _n
save "$data/approach2holder.dta",replace
export excel "$data/approach2.xlsx", sheet("holders",replace)

****************************************************************

//new relationships

//figure 22: new relationships by year (never met before in sample)
use "$data/uniquecontracts.dta",clear
sort ContractDate
//go with alternate definition of unique relationship: first time release shipper & replace shipper have contract
duplicates drop Pipeline ReleaseShipper ReplaceShipper, force
duplicates drop ContractNumber,force
//number of new relationships by year
bysort year: gen contract_count = _N
collapse contract_count, by(year)
save "$data/newrel_year.dta",replace

//calculate fraction of contracts from new relationships
use "$data/uniquecontracts.dta",clear
bysort year: gen total_contract = _N
collapse total_contract, by(year)
save "$data/totalcontracts.dta",replace

merge 1:1 year using "$data/newrel_year.dta"
drop _merge
gen frac = contract_count/total_contract
twoway (connected contract_count year, msize(2-pt) lcolor(blue) yaxis(1)) (connected frac year, msize(2-pt) lcolor(orange) yaxis(2)), xlabel(#10,labsize(small)) legend(off)

//figure 23: new relationships by year (didn't meet >1 year)
use "$data/uniquecontracts.dta",clear
sort ContractDate
duplicates tag Pipeline ReleaseShipper ReplaceShipper, gen(dup_ind)
//drop contracts of same year
duplicates drop year Pipeline ReleaseShipper ReplaceShipper dup_ind,force
drop dup_ind
duplicates tag Pipeline ReleaseShipper ReplaceShipper, gen(dup_ind2)
gen lag_year = year-1

//drop contracts that occurred within 1 year
sort ContractDate
bysort Pipeline ReleaseShipper ReplaceShipper: drop if dup_ind2 > 0 & lag_year[_n] == year[_n-1] 
drop dup_ind2 
bysort year: gen new_rel = _N
collapse new_rel, by(year)
save "$data/newrel1year.dta",replace

merge 1:1 year using "$data/totalcontracts.dta"
drop _merge
gen frac = new_rel/total_contract
twoway (connected new_rel year, msize(2-pt) lcolor(blue) yaxis(1)) (connected frac year, msize(2-pt) lcolor(orange) yaxis(2)), xlabel(#10,labsize(small))

//table 17: new relationships by market share
//approach 1

use "$data/releasers.dta",clear
sum holder_prop, detail
gen flag_small_release = (holder_prop < 0.0008917 )
keep Pipeline ReleaseShipper flag_small_release
save "$data/classifyrelease.dta",replace
use "$data/holder.dta",clear
sum release_prop, detail
gen flag_small_replace = (release_prop < 0.0008917 )
keep Pipeline ReplaceShipper flag_small_replace
save "$data/classifyholder.dta",replace


use "$data/uniquecontracts.dta",clear
sort ContractDate
//go with alternate definition of unique relationship: first time release shipper & replace shipper have contract
duplicates drop Pipeline ReleaseShipper ReplaceShipper, force
duplicates drop ContractNumber,force
merge m:1 Pipeline ReleaseShipper using "$data/classifyrelease.dta"
drop _merge
merge m:1 Pipeline ReplaceShipper using"$data/classifyholder.dta"
drop _merge
save "$data/approach1relations.dta",replace
tabulate flag_small_release flag_small_replace

//approach 2
use "$data/approach2release.dta",clear
sum releaser_mktshare, detail
gen flag_small_release = (releaser_mktshare < 0.001062 )
keep Pipeline ReleaseShipper flag_small_release
save "$data/classifyrelease2.dta",replace

use "$data/approach2holder.dta",clear
sum holders_mktshare, detail
gen flag_small_replace = (holders_mktshare < 0.0004142  )
keep Pipeline ReplaceShipper flag_small_replace
save "$data/classifyholder2.dta",replace

use "$data/uniquecontracts.dta",clear
sort ContractDate
//go with alternate definition of unique relationship: first time release shipper & replace shipper have contract
duplicates drop Pipeline ReleaseShipper ReplaceShipper, force
duplicates drop ContractNumber,force
merge m:1 Pipeline ReleaseShipper using "$data/classifyrelease2.dta"
drop _merge
merge m:1 Pipeline ReplaceShipper using"$data/classifyholder2.dta"
drop _merge
save "$data/approach2relations.dta",replace
tabulate flag_small_release flag_small_replace


//table 20: capacity releasers that are also holders
//table 21: capacity holders that are also releasers

//unique holders
use "$data/CapacityRelease_2015.dta",clear
duplicates drop ReplaceShipper, force
keep ReplaceShipper
rename ReplaceShipper shippers
save "$data/replaceshipperlist.dta",replace
//364 holders

//unique releasers
use "$data/CapacityRelease_2015.dta",clear
duplicates drop ReleaseShipper, force
keep ReleaseShipper
rename ReleaseShipper shippers
save "$data/releaseshipperlist.dta",replace
//344 releasers

merge 1:1 shippers using "$data/replaceshipperlist.dta"
//154 total that are both holder& releasers


