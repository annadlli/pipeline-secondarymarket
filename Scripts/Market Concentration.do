/****************************************************************************
Program:     Shippers Market Share within Pipeline (Capacity Release)
Author:      Anna Li
Date:        October 2023
*******************************************************************************/

clear all 		
capture log close 
set type double
set more off

global path "/Users/anna/Desktop/RA work/pipeline data analysis/oct 7"
global input "/Users/anna/Desktop/RA work/pipeline data analysis/aug 20/Input"
********************************************************************************
use "$input/CapacityRelease_Clean_Namechange.dta",clear

duplicates drop Pipeline ReleaseShipper ReplaceShipper StartDate EndDate, force


keep Pipeline ReleaseShipper ReplaceShipper Quantity

//generage total contract and quantity in each pipeline
bysort Pipeline: gen pipeline_totalcontract = _N
bysort Pipeline: egen pipeline_totalquant = total(Quantity)

tab Pipeline
by Pipeline: tab pipeline_totalquant
//generate total contracts and quantity held by each pipeline-shipper combo
bysort Pipeline ReleaseShipper: gen releasecontract = _N
bysort Pipeline ReleaseShipper : egen releasequant = total(Quantity)
bysort Pipeline ReplaceShipper: gen replacecontract = _N
bysort Pipeline ReplaceShipper : egen replacequant = total(Quantity)

save "$path/caprelease.dta",replace
********************************************************************************

*CONTRACT LEVEL RELEASE SHIPPER

//sort from largest to smallest
gsort Pipeline -releasecontract

//keep 1 obs per pipeline-shipper pair
duplicates drop Pipeline ReleaseShipper, force


tab Pipeline

//calcluate market share
bysort Pipeline: gen contract_releaseshare = releasecontract/pipeline_totalcontract

//calculate CR1-10 for each Pipeline
forval i= 1/10{
bysort Pipeline: egen contract_release_CR`i' = total(contract_releaseshare) if _n<=`i'
}

//calc CR20, CR50, and CR100 separately
foreach i of numlist 20 50 100{
bysort Pipeline: egen contract_release_CR`i' = total(contract_releaseshare) if _n<=`i'
}

//calculate HHI for pipeline
bysort Pipeline: gen contract_release_market2 = contract_releaseshare^2
bysort Pipeline: egen contract_release_hhi = total(contract_release_market2)
drop contract_release_market2

*QUANTITY LEVEL
//same calculations, but use quantity instead

gsort Pipeline -releasequant

bysort Pipeline: gen quant_releaseshare = releasequant/ pipeline_totalquant

//calculate CR1-10 for each Pipeline
forval i= 1/10{
bysort Pipeline: egen quant_release_CR`i' = total(quant_releaseshare) if _n<=`i'
}
//calc CR20, CR50, and CR100 separately
foreach i of numlist 20 50 100{
bysort Pipeline: egen quant_release_CR`i' = total(quant_releaseshare) if _n<=`i'
}
//calculate HHI for pipeline
bysort Pipeline: gen quant_release_market2 = quant_releaseshare^2
bysort Pipeline: egen quant_hhi = total(quant_release_market2)

drop quant_release_market2

by Pipeline: sum contract_releaseshare quant_releaseshare

********************************************************************************

use "$path/caprelease.dta",clear

*CONTRACT LEVEL REPLACESHIPPER

//sort from largest to smallest
gsort Pipeline -replacecontract

//keep 1 obs per pipeline-shipper pair
duplicates drop Pipeline ReplaceShipper, force


tab Pipeline

//calcluate market share
bysort Pipeline: gen contract_replaceshare = replacecontract/pipeline_totalcontract

//calculate CR1-10 for each Pipeline
forval i= 1/10{
bysort Pipeline: egen contract_replace_CR`i' = total(contract_replaceshare) if _n<=`i'
}

//calc CR20, CR50, and CR100 separately
foreach i of numlist 20 50 100{
bysort Pipeline: egen contract_replace_CR`i' = total(contract_replaceshare) if _n<=`i'
}

//calculate HHI for pipeline
bysort Pipeline: gen contract_replace_market2 = contract_replaceshare^2
bysort Pipeline: egen contract_replace_hhi = total(contract_replace_market2)
drop contract_replace_market2

*QUANTITY LEVEL
//same calculations, but use quantity instead

gsort Pipeline -replacequant

bysort Pipeline: gen quant_replaceshare = replacequant/ pipeline_totalquant

//calculate CR1-10 for each Pipeline
forval i= 1/10{
bysort Pipeline: egen quant_replace_CR`i' = total(quant_replaceshare) if _n<=`i'
}
//calc CR20, CR50, and CR100 separately
foreach i of numlist 20 50 100{
bysort Pipeline: egen quant_replace_CR`i' = total(quant_replaceshare) if _n<=`i'
}
//calculate HHI for pipeline
bysort Pipeline: gen quant_replace_market2 = quant_replaceshare^2
bysort Pipeline: egen quant_hhi = total(quant_replace_market2)

drop quant_replace_market2

by Pipeline: sum contract_replaceshare quant_replaceshare
