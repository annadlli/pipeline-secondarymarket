clear
capture log close
set more off
capture close
***************************************************************
//Author: Anna Li
//Task: Clean FERC data
//Modification date: March 14, 2023
***************************************************************

*** Change working directory:
global dirData "/Users/anna/Desktop/RA work/march data/2022/ind-2210"
global dirOutput "/Users/anna/Desktop/RA work/march data/2022/outputoct"
cd "$dirData"
//find all files
ls
//copied and pasted into excel, where file id was extracted
//changed all " 2" to "_2"
//remember to use the newest version (ta2, the most revised version or the _2 version if exists) and ones that end in "10" being october records
//all october records (not including the duplicates)
global records "IC0010312210	iC0000202210	iC0000212210	iC0000392210	iC0000402210	iC0000462210	iC0000472210	iC0000552210	iC0000602210	iC0000762210	iC0000842210	iC0000852210	iC0000862210	iC0000872210	iC0000882210	iC0000902210	iC0000912210	iC0000932210	iC0000942210	iC0000952210	iC0000962210	iC0000972210	iC0001112210	iC0001182210	iC0001472210	iC0001602210	iC0001612210	iC0001902210	iC0002262210	iC0002292210	iC0002312210	iC0002352210	iC0002362210	iC0002502210	iC0002512210	iC0002532210	iC0002542210	iC0002552210	iC0003032210	iC0003062210	iC0003072210	iC0003092210	iC0003102210	iC0003112210	iC0003712210	iC0003742210	iC0003772210	iC0004382210	iC0005112210	iC0005122210	iC0005132210	iC0005162210	iC0005172210	iC0005442210	iC0005452210	iC0005812210	iC0005822210	iC0005832210	iC0005842210	iC0005912210	iC0005922210	iC0005942210	iC0005962210	iC0005972210	iC0006232210	iC0006242210	iC0006252210	iC0006262210	iC0006272210	iC0006282210	iC0006402210	iC0006502210	iC0006512210	iC0006542210	iC0008272210	iC0008302210	iC0008382210	iC0009622210	iC0009672210	iC0009782210	iC0009812210	iC0009852210	iC0009862210	iC0009952210	iC0010122210	iC0010132210	iC0010142210	iC0010232210	iC0010242210	iC0010582210	iC0010852210	iC0010872210	iC0010882210	iC0010892210	iC0011332210	iC0011502210	iC0011542210	iC0011572210	iC0011992210	iC0012032210	iC0012092210	iC0012172210	iC0012442210	iC0012622210	iC0012942210	iC0013372210	iC0014372210	iC0014612210	iC0014792210	iC0014912210	iC0015062210	iC0015912210	iC0015932210	iC0016312210	iC0016832210	iC0016852210	iC0017002210	iC0017062210	iC0017582210	iC0017592210	iC0017742210	iC0019132210	iC0019322210	iC0020382210	iC0020962210	iC0022982210	iC0023112210	iC0024432210	iC0025972210	iC0026892210	iC0030732210	iC0031892210	iC0033552207	iC0033732210	iC0034092210	iC0035522210	iC0045582210	iC0046022210	iC0046862004	iC0049232210	iC0051412210	iC0052012210	iC0052742210	iC0052752210	iC0076882210	iC0088842210	iC0089262210	iC0102802210	iC0102842210	iC0103052210	iC0111702210	iC0113352210	iC0113642210	iCO104762210	iIC0004122210"

/*note multiple record companies, kept most recent; 
iC0006232207 ANR pipeline company
*/
*****************************************************************
//Data cleaning (only need to be run once)

//fix files by converting from excel to txt so they run in loop
global convertexcel "iC0052752210 iC0015062210 iC0019132210 iC0020382210 iC0022982210 iC0052742210 iC0076882210 iC0088842210"
foreach i in $convertexcel{
clear
import excel "`i'.xlsx"
export delimited "`i'.txt", delimiter(tab) replace
}

//modify files to ensure have 13 columns
//check which variables need more columns
foreach i in $records{
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
display "`i'"
di c(k)
clear
}


global needaddvars10to13 "iC0026892210 iC0049232210"
global needaddvars11to13 "iC0006272210"
global needaddvars1213 "iC0000402210	iC0000552210	iC0000762210	iC0000902210	iC0000972210	iC0102842210	iC0111702210	iC0113352210	iC0113642210	iCO104762210	iC0001182210	iC0002532210	iC0003032210	iC0003712210	iC0005162210	iC0005172210	iC0005812210	iC0005822210	iC0005832210	iC0005842210	iC0006282210	iC0006512210	iC0008272210	iC0008302210	iC0010122210	iC0010132210	iC0010232210	iC0010242210	iC0011332210	iC0012442210	iC0015062210	iC0016312210	iC0017002210	iC0024432210	iC0031892210	iC0046022210	iC0052012210	iC0076882210	iC0088842210	iC0102802210	iC0102842210	iC0111702210	iC0113352210	iC0113642210	iCO104762210"
global needaddvar13 "iC0002542210	iC0003742210	iC0005442210	iC0005452210	iC0005912210	iC0006242210	iC0006252210	iC0006502210	iC0008382210	iC0010852210	iC0011572210	iC0011992210	iC0012622210	iC0012942210	iC0013372210	iC0014372210	iC0014612210	iC0015912210	iC0015932210	iC0017582210	iC0017592210	iC0017742210	iC0019322210	iC0020382210	iC0023112210	iC0025972210	iC0030732210	iC0033732210	iC0034092210	iC0052752210	iC0103052210"

foreach i in $needaddvars10to13{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
gen v10=.
gen v11 = .
gen v12 =.
gen v13 =.
export delimited "`i'.txt", delimiter(tab) novarnames replace
}
foreach i in $needaddvars11to13{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
gen v11 = .
gen v12 =.
gen v13 =.
export delimited "`i'.txt", delimiter(tab) novarnames replace
}
foreach i in $needaddvars1213{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
gen v12 =.
gen v13 =.
export delimited "`i'.txt", delimiter(tab) novarnames replace
}

foreach i in $needaddvar13{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
gen v13 =.
export delimited "`i'.txt", delimiter(tab) novarnames replace
}


*****************************************************************************************************************************
//Convert to dta
//clean data for 2022 oct
foreach i in $records{
display "`i'"
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
//drop an extra header row if it exists. Example, i0791401
drop if v1[1] =="v1" & _n==1
//drop extra excel header row that exists. Example, i0661401
drop if v1[1] == "A" & _n==1
//drop if 1st row is blank
drop if v1[1] == "" & _n==1
* find records that belong to the same customer (same "D")
gen fakeID = _n if v1 == "D" 
replace fakeID = fakeID[_n-1] if fakeID == .
* store company info
	gen pipelinename= v2[1]
	gen companyid = v3[1]
	gen monthreport = v6[1]
	gen unit_transport = v7[1]
	drop in 1 //drop the first observation
save _temp, replace

*** First, store customer info
	use _temp, clear
	keep if v1 == "D"
	drop v1
	drop v3
	rename (v2 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 ) ///
		(shippername shipper_affiliation ratesched contractnum ///
		contract_effectivedate contract_prim_expirdate days_nextexpir ///
		negotiated_rates_ind trans_maxdquant stor_maxdquant D_footnoteid)
	//drop v*
	save _temp_customer, replace
	
*** Second, store agent info
//AL: altering so we have unique fakeID
	use _temp, clear
	keep if v1 == "A"
	if _N !=0{ //added as for files like i0041401 there are no A at all
	egen num_agents = count(fakeID),by(fakeID) //counts total number of agents per customer
	bysort fakeID: gen agent_count = _n //increments in number of agents per customer, kept to doublecheck drop code
	duplicates drop fakeID, force
	}
	drop v1
	rename (v2 v3 v4) (agentname agent_affiliation A_footnoteid)
	//drop v*
	
	save _temp_agent, replace
	
*** Third, clean point record "P"
	use _temp, clear

	* clean point record
	keep if v1 == "P"
	drop v1
	rename (v2 v3 v4 v5 v6 v7 v8 v9) ///
		(point_identifier pointname point_loc_qualifier point_loc zone ///
		ptrans_maxdquant pstor_maxdquant P_footnoteid)
	
	destring ptrans_maxdquant, replace
	destring pstor_maxdquant, replace
	
	* add customer info and agent info to point record
	merge m:1 fakeID using _temp_customer
	drop _merge
	merge m:1 fakeID using _temp_agent //switched to m:1 after fixing fakeID unique identifier issue
	drop _merge
	
	drop fakeID
	drop v*
	erase _temp.dta 
	erase _temp_customer.dta 
	erase _temp_agent.dta 
	gen fileid = "`i'" //added so we know where blank pipelinename values are from
	save "$dirOutput/`i'_AL.dta", replace
}
******************************************************************
//append all files

cd "$dirOutput"

global appendingfiles "iC0000202210	iC0000212210	iC0000392210	iC0000402210	iC0000462210	iC0000472210	iC0000552210	iC0000602210	iC0000762210	iC0000842210	iC0000852210	iC0000862210	iC0000872210	iC0000882210	iC0000902210	iC0000912210	iC0000932210	iC0000942210	iC0000952210	iC0000962210	iC0000972210	iC0001112210	iC0001182210	iC0001472210	iC0001602210	iC0001612210	iC0001902210	iC0002262210	iC0002292210	iC0002312210	iC0002352210	iC0002362210	iC0002502210	iC0002512210	iC0002532210	iC0002542210	iC0002552210	iC0003032210	iC0003062210	iC0003072210	iC0003092210	iC0003102210	iC0003112210	iC0003712210	iC0003742210	iC0003772210	iC0004382210	iC0005112210	iC0005122210	iC0005132210	iC0005162210	iC0005172210	iC0005442210	iC0005452210	iC0005812210	iC0005822210	iC0005832210	iC0005842210	iC0005912210	iC0005922210	iC0005942210	iC0005962210	iC0005972210	iC0006232210	iC0006242210	iC0006252210	iC0006262210	iC0006272210	iC0006282210	iC0006402210	iC0006502210	iC0006512210	iC0006542210	iC0008272210	iC0008302210	iC0008382210	iC0009622210	iC0009672210	iC0009782210	iC0009812210	iC0009852210	iC0009862210	iC0009952210	iC0010122210	iC0010132210	iC0010142210	iC0010232210	iC0010242210	iC0010582210	iC0010852210	iC0010872210	iC0010882210	iC0010892210	iC0011332210	iC0011502210	iC0011542210	iC0011572210	iC0011992210	iC0012032210	iC0012092210	iC0012172210	iC0012442210	iC0012622210	iC0012942210	iC0013372210	iC0014372210	iC0014612210	iC0014792210	iC0014912210	iC0015062210	iC0015912210	iC0015932210	iC0016312210	iC0016832210	iC0016852210	iC0017002210	iC0017062210	iC0017582210	iC0017592210	iC0017742210	iC0019132210	iC0019322210	iC0020382210	iC0020962210	iC0022982210	iC0023112210	iC0024432210	iC0025972210	iC0026892210	iC0030732210	iC0031892210	iC0033552207	iC0033732210	iC0034092210	iC0035522210	iC0045582210	iC0046022210	iC0046862004	iC0049232210	iC0051412210	iC0052012210	iC0052742210	iC0052752210	iC0076882210	iC0088842210	iC0089262210	iC0102802210	iC0102842210	iC0103052210	iC0111702210	iC0113352210	iC0113642210	iCO104762210	iIC0004122210"



use IC0010312210_AL.dta, clear
tostring D_footnoteid, replace
foreach i in $appendingfiles{
	append using "`i'_AL.dta",force
}
//checked format of all vars, switch to most appropriate format
describe 
//convert trans_maxdquant from string to numeric to match rest of its quantities measures
global tonum "companyid contractnum days_nextexpir trans_maxdquant"
foreach i in $tonum{
	di "`i'"
	destring `i', gen(numerical_`i') ignore(",")
}


//created versions of variable w/o the trailing/leading spaces
global strippedvars "pointname point_identifier point_loc_qualifier point_loc zone P_footnoteid pipelinename companyid monthreport unit_transport shippername shipper_affiliation ratesched contractnum contract_effectivedate contract_prim_expirdate days_nextexpir negotiated_rates_ind D_footnoteid agentname agent_affiliation A_footnoteid"

foreach i in $strippedvars{
	di "`i'"
	gen stripped_`i' = strtrim(`i')
}

save "$dirOutput/oct2022merged_AL.dta", replace

//47,502 observations total

**********************************************************************************************************************
//Checking data
use "$dirOutput/oct2022merged_AL.dta",clear
global variables_P "stripped_pointname point_identifier stripped_point_loc_qualifier stripped_point_loc stripped_zone stripped_P_footnoteid"
//iC0000872210 seems to have an observation as P that is supposed to be D (Tampa Electric Company); manually changed

global variables_D1 "stripped_pipelinename stripped_companyid stripped_monthreport stripped_unit_transport" 

global variables_D2 "stripped_shippername stripped_shipper_affiliation stripped_ratesched stripped_contractnum stripped_contract_effectivedate stripped_contract_prim_expirdate stripped_days_nextexpir stripped_negotiated_rates_ind stripped_D_footnoteid"
//iC0005452210 and iC0005442210 are not separated properly(use= to replace tabs and also to go onto the next line, ; too large datasets to do so manually
//manually separated iC0000402210 contract num and rate schedule

global variables_A "stripped_agentname stripped_agent_affiliation stripped_A_footnoteid" 
//two instances of double agent affiliation(N;N) and company records within 1 observation within 2 files of iC0000552210 iC0010242210
//manually got rid of iC0001182210 and iC0013372210 IC0010312210 which had extra numbers as a column instead of agent name/agent affiliation

global quantities "ptrans_maxdquant pstor_maxdquant stor_maxdquant"

//look at each unique obs of variables
foreach i in $variables_P{
	di "`i'"
	levelsof `i'
}
foreach i in $variables_D1{
	di "`i'"
	levelsof `i'
}
foreach i in $variables_D2{
	di "`i'"
	levelsof `i'
}
foreach i in $variables_A{
	di "`i'"
	levelsof `i'
}
foreach i in $quantities{
	di "`i'"
	sum `i'
}

//generate list of missing pipeline files, if exists
use "$dirOutput/oct2022merged_AL.dta",clear
keep if pipelinename == ""
tab fileid
