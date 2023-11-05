                                  =
/*******************************************************************************
Program:     Investigating Customer_Clean
Author:      Anna Li
Date:        August 2023
*******************************************************************************/

clear all 		
capture log close 
set type double
set more off

global path    "/Users/anna/Desktop/RA summer 2023/pipeline data analysis/aug 20"
global input   "$path/Input"
global output  "$path/Output"
global temp    "$path/Temp"


********************************************************************************
*IMPORTING RAW DATA
********************************************************************************
use "$input/IndexofCustomers_Clean",clear
********************************************************************************
*BY PIPELINE
********************************************************************************
//generate summary statistics of contract length/duration
bysort Pipeline: sum ContractDur,d
histogram ContractDur, by(Pipeline) xtitle("Contract Duration in Days using Given Variable")
graph export "$temp/histogram_contractdurationdef1.png",replace 

//seems to be problems, as there are observations where Duration = 0, when it should not be if we use End-Start Date due to rounding issues
//recalculated results in:
gen contractstartdate = date(ContractStart, "MDY")
format contractstartdate %td
gen contractenddate = date(ContractEnd, "MDY")
format contractenddate %td
gen contractduration2 = contractenddate-contractstartdate

bysort Pipeline: sum contractduration2,d
histogram contractduration2, by(Pipeline) xtitle("Self-defined Contract Duration in Days")
graph export "$temp/histogram_contractdurationdef2days.png",replace 

gen contractduration2_months = contractduration2/30.5
bysort Pipeline: sum contractduration2_months,d
histogram contractduration2_months, by(Pipeline) xtitle("Self-defined Contract Duration in Months")
graph export "$temp/histogram_contractdurationdef2months.png",replace 

//trim extreme values (1 percent and 99 percent)
winsor2 contractduration2_months, trim by(Pipeline)
winsor2 contractduration2, trim by(Pipeline)
histogram contractduration2_months_tr, by(Pipeline) xtitle("Self-defined Contract Duration in Months, Trimmed")
graph export "$temp/histogram_contractdurationdef2monthstrim.png",replace 
histogram contractduration2_tr, by(Pipeline) xtitle("Self-defined Contract Duration in Days, Trimmed")
graph export "$temp/histogram_contractdurationdef2daystrim.png",replace 

//how many shippers they have?
by Pipeline: distinct Shipper
//El Paso: 246
// Natural Gas: 287
//Texas: 295
//Transwestern: 137
//how does number of shippers change over time
gen year = yofd(dofq(var1))
bysort Pipeline year: distinct Shipper
//will store output in excel
