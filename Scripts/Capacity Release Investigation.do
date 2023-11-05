/****************************************************************************
Program:     Shippers Market Share within Pipeline (Capacity Release)
Author:      Anna Li
Date:        October 2023
*******************************************************************************/

clear all 		
capture log close 
set type double
set more off

global input "C:\Users\chen1233\OneDrive - University of Toronto\GasPipelineRA\Clean Data"
global temp "C:\Users\chen1233\OneDrive - University of Toronto\GasPipelineRA\Clean Data\Temp"
*global path    "/Users/anna/Desktop/RA summer 2023/pipeline data analysis/aug 20"
*global input   "$path/Input"
********************************************************************************
*                 				Data Clean									   *
********************************************************************************
use "$input/CapacityRelease_Clean_Namechange.dta",clear

sort Pipeline ReleaseShipper ReplaceShipper ContractID
drop if Quantity == .

keep Pipeline ReleaseShipper ReplaceShipper Quantity

//generage total contract and quantity in each pipeline
bysort Pipeline: gen pipeline_totalcontract = _N
bysort Pipeline: egen pipeline_totalquant = total(Quantity)

*** Table 1 ***
tab Pipeline
unique ReleaseShipper, by(Pipeline)
unique ReplaceShipper, by(Pipeline)

by Pipeline: tab pipeline_totalquant
//generate total contracts and quantity held by each pipeline-shipper combo
bysort Pipeline ReleaseShipper: gen releasecontract = _N
bysort Pipeline ReleaseShipper : egen releasequant = total(Quantity)
bysort Pipeline ReplaceShipper: gen replacecontract = _N
bysort Pipeline ReplaceShipper : egen replacequant = total(Quantity)

save "$temp/capreleaseYC.dta",replace

********************************************************************************
*							Release Shipper									   *
********************************************************************************
use "$temp/capreleaseYC.dta", clear

//keep 1 obs per pipeline-shipper pair
duplicates drop Pipeline ReleaseShipper, force
drop ReplaceShipper Quantity _Unique replacecontract replacequant

//sort from largest to smallest by contract number
gsort Pipeline -releasecontract
by Pipeline: gen tot_releaser = _N
by Pipeline: gen releaser_rank_contracts = _n

//calcluate market share
by Pipeline: gen releaser_mks_contracts = releasecontract/pipeline_totalcontract

*QUANTITY LEVEL
//same calculations, but use quantity instead
gsort Pipeline -releasequant
by Pipeline: gen releaser_rank_quantity = _n 
by Pipeline: gen releaser_mks_quantity = releasequant/ pipeline_totalquant

brow if releaser_rank_quantity <= 10

********************************************************************************
*							Replace Shipper									   *
********************************************************************************
use "$temp/capreleaseYC.dta", clear

//keep 1 obs per pipeline-shipper pair
duplicates drop Pipeline ReplaceShipper, force
drop ReleaseShipper Quantity _Unique releasecontract releasequant

//sort from largest to smallest
gsort Pipeline -replacecontract
by Pipeline: gen tot_replacer = _N
by Pipeline: gen replacer_rank_contracts = _n

//calcluate market share
by Pipeline: gen replacer_mks_contracts = replacecontract/pipeline_totalcontract

*QUANTITY LEVEL
//same calculations, but use quantity instead
gsort Pipeline -replacequant
by Pipeline: gen replacer_rank_quantity = _n 
by Pipeline: gen replacer_mks_quantity = replacequant/ pipeline_totalquant

brow if replacer_rank_quantity <= 10




