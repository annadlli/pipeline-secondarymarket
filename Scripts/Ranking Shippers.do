/****************************************************************************
Program:     Shippers Market Share within Pipeline
Author:      Anna Li
Date:        October 2023
Revisions: Looked at ranking of capacity release, in depth investigation of contract holders
*******************************************************************************/

clear all 		
capture log close 
set type double
set more off

global path "/Users/anna/Desktop/RA work/pipeline data analysis/oct 14"
global input "/Users/anna/Desktop/RA work/pipeline data analysis/aug 20/Input"
global temp    "$path/Temp"

//old code
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

//generate total contracts and quantity held by each pipeline-shipper combo
bysort Pipeline ReleaseShipper: gen releasecontract = _N
bysort Pipeline ReleaseShipper : egen releasequant = total(Quantity)
bysort Pipeline ReplaceShipper: gen replacecontract = _N
bysort Pipeline ReplaceShipper : egen replacequant = total(Quantity)

********************************************************************************
//NEW CODE
//generate rank to classify as large player or not
by Pipeline: egen release_rank = rank(-releasequant), track
by Pipeline: egen replace_rank = rank(-replacequant), track
save "$temp/capreleaseYC.dta",replace

by Pipeline: sum release_rank replace_rank

//RELEASE SHIPPER ANALYSIS ************
//added sort command to each tab indiv later on to see largest replaceshipper partnership by contract frequency
//el paso
use "$temp/capreleaseYC.dta", clear
keep if Pipeline == "El Paso Natural Gas Company, L.L.C."
tab replace_rank if ReleaseShipper == "Kinder Morgan Texas PL"
tab replace_rank if ReleaseShipper == "Comisión Fed de Electricidad"
tab replace_rank if ReleaseShipper == "El Paso Marketing Co. L.L.C." 
tab replace_rank if ReleaseShipper == "Freeport Minerals Corp."
tab replace_rank if ReleaseShipper == "Pacific Gas and Electric Co."
tab replace_rank if ReleaseShipper == "Southwest Gas Corp."
tab replace_rank if ReleaseShipper == "Saavi Energy Solutions LLC"
tab replace_rank if ReleaseShipper == "Southern California Gas Co."
tab replace_rank if ReleaseShipper == "Mex Gas Supply SL"
tab replace_rank if ReleaseShipper == "Mexicana De Cobre S. A. De C."

gsort Pipeline ReleaseShipper -Quantity
drop  pipeline_totalcontract pipeline_totalquant releasecontract replacecontract replacequant release_rank
brow if ReleaseShipper == "Kinder Morgan Texas PL"
brow if ReleaseShipper == "Kinder Morgan Texas PL" & Quantity ==0
brow if ReleaseShipper == "Comisión Fed de Electricidad"
brow if ReleaseShipper == "El Paso Marketing Co. L.L.C." 
brow if ReleaseShipper == "Freeport Minerals Corp."
brow if ReleaseShipper == "Freeport Minerals Corp."& Quantity ==0
brow if ReleaseShipper == "Pacific Gas and Electric Co."
brow if ReleaseShipper == "Southwest Gas Corp."
brow if ReleaseShipper == "Southwest Gas Corp."& Quantity ==0
brow if ReleaseShipper == "Saavi Energy Solutions LLC"
brow if ReleaseShipper == "Southern California Gas Co."
brow if ReleaseShipper == "Mex Gas Supply SL"
brow if ReleaseShipper == "Mexicana De Cobre S. A. De C."

//ngpl
use "$temp/capreleaseYC.dta",clear
keep if Pipeline == "Natural Gas Pipeline Company of America LLC"
tab replace_rank if ReleaseShipper == "WSGP Gas Producing, LLC"
tab replace_rank if ReleaseShipper == "Antero Resources Corp."
tab replace_rank if ReleaseShipper == "CenterPoint Energy Resources"
tab replace_rank if ReleaseShipper == "AmerenIP"
tab replace_rank if ReleaseShipper == "Northern IN Public Svc Co. LLC"
tab replace_rank if ReleaseShipper == "Arkansas Electric Cooperative"
tab replace_rank if ReleaseShipper == "Northern Illinois Gas Co."
tab replace_rank if ReleaseShipper == "The Peoples Gas Light & Coke C"
tab replace_rank if ReleaseShipper == "FPLE Forney LLC"
tab replace_rank if ReleaseShipper == "Ameren Illinois"


gsort Pipeline ReleaseShipper -Quantity
drop  pipeline_totalcontract pipeline_totalquant releasecontract replacecontract replacequant release_rank
brow if ReleaseShipper == "WSGP Gas Producing, LLC"
brow if ReleaseShipper == "Antero Resources Corp."
brow if ReleaseShipper == "CenterPoint Energy Resources"
brow if ReleaseShipper == "AmerenIP"
brow if ReleaseShipper == "Northern IN Public Svc Co. LLC"
brow if ReleaseShipper == "Arkansas Electric Cooperative"
brow if ReleaseShipper == "Northern Illinois Gas Co."
brow if ReleaseShipper == "The Peoples Gas Light & Coke C"
brow if ReleaseShipper == "FPLE Forney LLC"
brow if ReleaseShipper == "Ameren Illinois"


//texas eastern
use "$temp/capreleaseYC.dta",clear
keep if Pipeline == "Texas Eastern Transmission, LP"
tab replace_rank if ReleaseShipper == "Boston Gas Co."
tab replace_rank if ReleaseShipper == "NSTAR Gas Co."
tab replace_rank if ReleaseShipper == "Liberty Utilities Co."
tab replace_rank if ReleaseShipper == "PSEG Power LLC"
tab replace_rank if ReleaseShipper == "The Narragansett Electric Co."
tab replace_rank if ReleaseShipper == "UGI Utilities Inc."
tab replace_rank if ReleaseShipper == "NiSource Inc."
tab replace_rank if ReleaseShipper == "Colonial Gas Co."
tab replace_rank if ReleaseShipper == "Tauber Oil Company, Inc."
tab replace_rank if ReleaseShipper == "PECO Energy Co"


gsort Pipeline ReleaseShipper -Quantity
drop  pipeline_totalcontract pipeline_totalquant releasecontract replacecontract replacequant release_rank
brow if ReleaseShipper == "Boston Gas Co."
brow if ReleaseShipper == "NSTAR Gas Co."
brow if ReleaseShipper == "Liberty Utilities Co."
brow if ReleaseShipper == "PSEG Power LLC"
brow if ReleaseShipper == "The Narragansett Electric Co."
brow if ReleaseShipper == "UGI Utilities Inc."
brow if ReleaseShipper == "NiSource Inc."
brow if ReleaseShipper == "Colonial Gas Co."
brow if ReleaseShipper == "Tauber Oil Company, Inc."
brow if ReleaseShipper == "PECO Energy Co"



//transwestern
use "$temp/capreleaseYC.dta",clear
keep if Pipeline == "Transwestern Pipeline Company, LLC"
tab replace_rank if ReleaseShipper == "Atmos Energy Corp."
tab replace_rank if ReleaseShipper == "Lake Region Electric Cooperative, Inc."
tab replace_rank if ReleaseShipper == "Pacific Gas and Electric Co."
tab replace_rank if ReleaseShipper == "Southwest Gas Corp."
tab replace_rank if ReleaseShipper == "Targa Northern Delaware LLC"
tab replace_rank if ReleaseShipper == "SG Interests I, Ltd."
tab replace_rank if ReleaseShipper == "UNS Gas Inc."
tab replace_rank if ReleaseShipper == "Arizona Public Service Co."
tab replace_rank if ReleaseShipper == "Talen Energy Marketing, LLC"
tab replace_rank if ReleaseShipper == "Red Willow Production Co."


gsort Pipeline ReleaseShipper -Quantity
drop  pipeline_totalcontract pipeline_totalquant releasecontract replacecontract replacequant release_rank
brow if ReleaseShipper == "Atmos Energy Corp."
brow if ReleaseShipper == "Lake Region Electric Cooperative, Inc."
brow if ReleaseShipper == "Lake Region Electric Cooperative, Inc." & Quantity == 10000
brow if ReleaseShipper == "Pacific Gas and Electric Co."
brow if ReleaseShipper == "Southwest Gas Corp."
brow if ReleaseShipper == "Targa Northern Delaware LLC"
brow if ReleaseShipper == "SG Interests I, Ltd."
brow if ReleaseShipper == "UNS Gas Inc."
brow if ReleaseShipper == "Arizona Public Service Co."
brow if ReleaseShipper == "Talen Energy Marketing, LLC"
brow if ReleaseShipper == "Red Willow Production Co."

//REPLACE SHIPPER ANALYSIS ************************************
use "$temp/capreleaseYC.dta", clear
keep if Pipeline == "El Paso Natural Gas Company, L.L.C."
tab release_rank if ReplaceShipper == "ConocoPhillips Company"
tab release_rank if ReplaceShipper == "Tenaska Marketing Ventures, Inc."
tab release_rank if ReplaceShipper == "BP Energy Company, Inc."
tab release_rank if ReplaceShipper == "Sequent Energy Management, L.P."
tab release_rank if ReplaceShipper == "EDF Trading North America, LLC"
tab release_rank if ReplaceShipper == "Occidental Energy Marketing, Inc."
tab release_rank if ReplaceShipper == "MIECO LLC"
tab release_rank if ReplaceShipper == "Gila River Power LLC"
tab release_rank if ReplaceShipper == "Chevron Usa Products Inc"
tab release_rank if ReplaceShipper == "Spotlight Energy, Inc."


//ngpl
use "$temp/capreleaseYC.dta",clear
keep if Pipeline == "Natural Gas Pipeline Company of America LLC"
tab release_rank if ReplaceShipper == "Tenaska Marketing Ventures, Inc."
tab release_rank if ReplaceShipper == "Southwest Energy, L.P."
tab release_rank if ReplaceShipper == "Sequent Energy Management, L.P."
tab release_rank if ReplaceShipper == "Macquarie Cook Energy, LLC"
tab release_rank if ReplaceShipper == "NextEra Energy Power Marketing, LLC"
tab release_rank if ReplaceShipper == "J.P. Morgan Ventures Energy Corporation"
tab release_rank if ReplaceShipper == "North Shore Gas Company"
tab release_rank if ReplaceShipper == "Nicor Enerchange L.L.C"
tab release_rank if ReplaceShipper == "Twin Eagle Resource Management, LLC"
tab release_rank if ReplaceShipper == "Illinois Power Fuels and Services Company"


//texas eastern
use "$temp/capreleaseYC.dta",clear
keep if Pipeline == "Texas Eastern Transmission, LP"
tab release_rank if ReplaceShipper == "Direct Energy Business Marketing, LLC"
tab release_rank if ReplaceShipper == "Merrill Lynch Commodities, Inc."
tab release_rank if ReplaceShipper == "PSEG Energy Resources & Trade LLC"
tab release_rank if ReplaceShipper == "Hess Corporation"
tab release_rank if ReplaceShipper == "Sprague Resources LP"
tab release_rank if ReplaceShipper == "Shell Energy North America (US), L.P."
tab release_rank if ReplaceShipper == "Twin Eagle Resource Management, LLC"
tab release_rank if ReplaceShipper == "Southwest Energy, L.P."
tab release_rank if ReplaceShipper == "Interconn Resources, Inc."
tab release_rank if ReplaceShipper == "Sequent Energy Management, L.P."

//transwestern
use "$temp/capreleaseYC.dta",clear
keep if Pipeline == "Transwestern Pipeline Company, LLC"
tab release_rank if ReplaceShipper == "BP Energy Company, Inc."
tab release_rank if ReplaceShipper == "ConocoPhillips Company"
tab release_rank if ReplaceShipper == "Hartree Partners, LP"
tab release_rank if ReplaceShipper == "Enbridge Marketing (U.S.) Inc."
tab release_rank if ReplaceShipper == "Sequent Energy Management, L.P."
tab release_rank if ReplaceShipper == "Tenaska Marketing Ventures, Inc."
tab release_rank if ReplaceShipper == "Targa Gas Marketing LLC"
tab release_rank if ReplaceShipper == "Tucson Electric Power Company"
tab release_rank if ReplaceShipper == "RBS Sempra Commodities LLP"
tab release_rank if ReplaceShipper == "EDF Trading North America, LLC"



********************************************************************************
//added investigation
//texas eastern
use "$temp/capreleaseYC.dta",clear
keep if Pipeline == "Texas Eastern Transmission, LP"

********************************************************************************

//INDEX OF CUSTOMERS INVESTIGATION
********************************************************************************

//old code
use "$input/IndexofCustomers_Clean",clear
duplicates drop Pipeline Shipper ContractStart ContractEnd, force
keep Pipeline Shipper MaxDailyTransport

//generage total contract in each pipeline
bysort Pipeline: gen pipeline_totalcontract = _N
bysort Pipeline: egen pipeline_totalquant = total(MaxDailyTransport)

tab Pipeline
by Pipeline: tab pipeline_totalquant

//generate total contracts and quantity held by each pipeline-shipper combo
bysort Pipeline Shipper: gen total_contract = _N
bysort Pipeline Shipper : egen totalpairquantity = total(MaxDailyTransport)

*CONTRACT LEVEL

//sort from largest to smallest
gsort Pipeline -total_contract

//keep 1 obs per pipeline-shipper pair
duplicates drop Pipeline Shipper, force


tab Pipeline

//calcluate market share
bysort Pipeline: gen shipper_contract_marketshare = total_contract/pipeline_totalcontract

********************************************************************************
//NEW CODE
by Pipeline: egen contract_rank = rank(-shipper_contract_marketshare), track
********************************************************************************
//old code
*QUANTITY LEVEL
//same calculations, but use quantity instead

gsort Pipeline -totalpairquantity

bysort Pipeline: gen shipper_quant_marketshare = totalpairquantity/ pipeline_totalquant

********************************************************************************
//NEW CODE
by Pipeline: egen quantity_rank = rank(-shipper_quant_marketshare), track

keep Pipeline Shipper shipper_contract_marketshare contract_rank  shipper_quant_marketshare quantity_rank
order Pipeline Shipper contract_rank shipper_contract_marketshare quantity_rank shipper_quant_marketshare

save "$temp/rankdata", replace
keep if Pipeline == "El Paso Natural Gas Company, L.L.C."
use "$temp/rankdata",clear
keep if Pipeline == "Natural Gas Pipeline Company of America LLC"
use "$temp/rankdata",clear
keep if Pipeline == "Texas Eastern Transmission, LP"
use "$temp/rankdata",clear
keep if Pipeline == "Transwestern Pipeline Company, LLC"
********************************************************************************


