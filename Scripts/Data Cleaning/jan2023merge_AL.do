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
global dirData "/Users/anna/Desktop/RA work/march data/2023/ind-0123"
global dirOutput "/Users/anna/Desktop/RA work/march data/2023/output"
cd "$dirData"
//find all files
ls
//copied and pasted into excel, where file id was extracted
//changed all " 2" to "_2"
//remember to use the newest version (ta2, the most revised version or the _2 version if exists) and ones that end in "10" being october records
//all jan records (not including the duplicates)
global records "iC0000202301	iC0000212301	iC0000392301	iC0000462301	iC0000472301	iC0000602301	iC0000762301_1	iC0000842301	iC0000852301	iC0000862301	iC0000872301	iC0000882301	iC0000912301	iC0000932301	iC0000942301	iC0000952301	iC0000962301	iC0000972301	iC0001112301	iC0001182301_1	iC0001472301	iC0001602301	iC0001612301	iC0001902301	iC0002262301	iC0002292301	iC0002312301	iC0002352301	iC0002362301	iC0002502301	iC0002512301	iC0002532301	iC0002542301	iC0002552301	iC0003032301	iC0003062301	iC0003072301	iC0003092301	iC0003102301	iC0003112301	iC0003712301	iC0003742301	iC0003772301	iC0004382301	iC0005112301	iC0005122301	iC0005132301	iC0005172301	iC0005182301	iC0005442301	iC0005452301	iC0005812301	iC0005822301	iC0005832301	iC0005912301	iC0005922301	iC0005942301	iC0005962301	iC0005972301	iC0006232301	iC0006242301	iC0006252301	iC0006262301_1	iC0006272301	iC0006282301_1	iC0006402301	iC0006502301	iC0006512301	iC0006542301	iC0008302301	iC0008382301	iC0009622301	iC0009672301	iC0009782301	iC0009812301	iC0009852301	iC0009862301	iC0009952301	iC0010122301	iC0010132301	iC0010142301	iC0010312301	iC0010582301	iC0010852301	iC0010872301	iC0010882301	iC0010892301	iC0011332210	iC0011502301	iC0011542301	iC0011572210	iC0011992301	iC0012032301	iC0012092301	iC0012172301	iC0012442301	iC0012622301	iC0012752210	iC0012942301	iC0013372301	iC0014372301	iC0014472301	iC0014612210	iC0014792301_1	iC0014912301	iC0015062301	iC0015912301	iC0015932301	iC0016832301	iC0016852301	iC0017062301	iC0017582301	iC0017592301	iC0017742301	iC0019132301	iC0020382212	iC0020962301	iC0022982301	iC0023112301	iC0024432301	iC0025972301	iC0026892301	iC0030732301	iC0033552301	iC0033732301	iC0034092301	iC0035522301	iC0045582301	iC0046022301	iC0046862004	iC0049232301	iC0051412301	iC0052012301	iC0052742301	iC0052752301	iC0076882301	iC0088842301	iC0089262301	iC0102802301	iC0102842301	iC0103052301	iC0104762301	iC0113352301	iC0113642301	iC0116062301_1	iIC0004122301"
*****************************************************************
//Data cleaning (only need to be run once)

//fix files by converting from excel to txt so they run in loop
global convertexcel "iC0014472301 iC0015062301 iC0019132301 iC0020382212 iC0022982301 iC0052742301 iC0052752301 iC0076882301 iC0088842301 iC0004382301"
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
//manually separated iC0004382301 using excel

global needaddvars10to13 "iC0010122301 iC0026892301 iC0049232301"
global needaddvars11to13 "iC0006272301"
global needaddvars1213 "iC0000762301_1 iC0000972301 iC0001182301_1 iC0003712301 iC0005172301 iC0005182301 iC0005812301 iC0005822301 iC0005832301 iC0006282301_1 iC0006512301 iC0008302301 iC0010132301 iC0011332210 iC0012442301 iC0024432301 iC0052012301 iC0088842301 iC0102802301 iC0102842301 iC0104762301 iC0113352301 iC0113642301 iC0003032301"
global needaddvar13 "iC0003742301 iC0005442301 iC0005452301 iC0005912301 iC0006502301 iC0008382301 iC0010852301 iC0011572210 iC0011992301 iC0012622301 iC0012942301 iC0014372301 iC0014612210 iC0015062301 iC0015912301 iC0015932301 iC0017582301 iC0017742301 iC0020382212 iC0023112301 iC0025972301 iC0030732301 iC0033732301 iC0034092301 iC0052752301 iC0076882301 iC0103052301 iC0017592301 iC0013372301"

foreach i in $needaddvars10to13{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
gen v10=.
gen v11 = .
gen v12 =.
gen v13 =.
export delimited "`i'.txt", delimiter(tab) replace
}
foreach i in $needaddvars11to13{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
gen v11 = .
gen v12 =.
gen v13 =.
export delimited "`i'.txt", delimiter(tab) replace
}
foreach i in $needaddvars1213{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
gen v12 =.
gen v13 =.
export delimited "`i'.txt", delimiter(tab) replace
}

foreach i in $needaddvar13{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
gen v13 =.
export delimited "`i'.txt", delimiter(tab) replace
}

*****************************************************************************************************************************
//Convert to dta
//clean data for 2023 jan
//has extra header rows; eliminate them
cd "$dirData"

foreach i in $records{
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
drop if v1[1] =="v1" & _n==1
drop if v1[1] =="v1" & _n==1
export delimited "`i'.txt", delimiter(tab) novarnames replace
clear
}

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
	if _N !=0{ //added as for files where there are no A at all
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

global appendingfiles "iC0000212301	iC0000392301	iC0000462301	iC0000472301	iC0000602301	iC0000762301_1	iC0000842301	iC0000852301	iC0000862301	iC0000872301	iC0000882301	iC0000912301	iC0000932301	iC0000942301	iC0000952301	iC0000962301	iC0000972301	iC0001112301	iC0001182301_1	iC0001472301	iC0001602301	iC0001612301	iC0001902301	iC0002262301	iC0002292301	iC0002312301	iC0002352301	iC0002362301	iC0002502301	iC0002512301	iC0002532301	iC0002542301	iC0002552301	iC0003032301	iC0003062301	iC0003072301	iC0003092301	iC0003102301	iC0003112301	iC0003712301	iC0003742301	iC0003772301	iC0004382301	iC0005112301	iC0005122301	iC0005132301	iC0005172301	iC0005182301	iC0005442301	iC0005452301	iC0005812301	iC0005822301	iC0005832301	iC0005912301	iC0005922301	iC0005942301	iC0005962301	iC0005972301	iC0006232301	iC0006242301	iC0006252301	iC0006262301_1	iC0006272301	iC0006282301_1	iC0006402301	iC0006502301	iC0006512301	iC0006542301	iC0008302301	iC0008382301	iC0009622301	iC0009672301	iC0009782301	iC0009812301	iC0009852301	iC0009862301	iC0009952301	iC0010122301	iC0010132301	iC0010142301	iC0010312301	iC0010582301	iC0010852301	iC0010872301	iC0010882301	iC0010892301	iC0011332210	iC0011502301	iC0011542301	iC0011572210	iC0011992301	iC0012032301	iC0012092301	iC0012172301	iC0012442301	iC0012622301	iC0012752210	iC0012942301	iC0013372301	iC0014372301	iC0014472301	iC0014612210	iC0014792301_1	iC0014912301	iC0015062301	iC0015912301	iC0015932301	iC0016832301	iC0016852301	iC0017062301	iC0017582301	iC0017592301	iC0017742301	iC0019132301	iC0020382212	iC0020962301	iC0022982301	iC0023112301	iC0024432301	iC0025972301	iC0026892301	iC0030732301	iC0033552301	iC0033732301	iC0034092301	iC0035522301	iC0045582301	iC0046022301	iC0046862004	iC0049232301	iC0051412301	iC0052012301	iC0052742301	iC0052752301	iC0076882301	iC0088842301	iC0089262301	iC0102802301	iC0102842301	iC0103052301	iC0104762301	iC0113352301	iC0113642301	iC0116062301_1	iIC0004122301"



use iC0000202301_AL.dta, clear
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

save "$dirOutput/jan2023merged_AL.dta", replace

//47,578 observations total

**********************************************************************************************************************
//Checking data
use "$dirOutput/jan2023merged_AL.dta",clear
global variables_P "stripped_pointname point_identifier stripped_point_loc_qualifier stripped_point_loc stripped_zone stripped_P_footnoteid"


global variables_D1 "stripped_pipelinename stripped_companyid stripped_monthreport stripped_unit_transport" 
/*manually fixed (not completed) iC0005442301 iC0005452301 which had wrong tabs, and = to indicate line separations: too time consuming*/

global variables_D2 "stripped_shippername stripped_shipper_affiliation stripped_ratesched stripped_contractnum stripped_contract_effectivedate stripped_contract_prim_expirdate stripped_days_nextexpir stripped_negotiated_rates_ind stripped_D_footnoteid"
//manually adjusted iC0005442301 iC0076882301 iC0012752210 to have right matching obs

global variables_A "stripped_agentname stripped_agent_affiliation stripped_A_footnoteid" 
//manually adjusted iC0001182301_1 and iC0013372301 which had extra column of numbers in v1=="A"

//manually adjusted iC0010312301 to get rid of extra column


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
use "$dirOutput/jan2023merged_AL.dta",clear
keep if pipelinename == ""
tab fileid
//manually adjusted iC0010312301 as it was showing up as missing pipeline

