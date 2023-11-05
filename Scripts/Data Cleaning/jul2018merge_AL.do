clear
capture log close
set more off
capture close
***************************************************************
//Author: Anna Li
//Task: Clean FERC data
//Modification date: March 20, 2023
***************************************************************

*** Change working directory:
global dirData "/Users/anna/Desktop/RA work/2018/jul/ind-0718"
global dirOutput "/Users/anna/Desktop/RA work/2018/jul/output"
cd "$dirData"
//find all files
ls
//copied and pasted into excel, where file id was extracted
//changed all " 2" to "_2"
//remember to use the newest version (ta2, the most revised version or the _2 version if exists) and ones that end in "10" being october records
//all jan records (not including the duplicates)
global records "iC0000201807	iC0000211807	iC0000391807	iC0000461807	iC0000471807	iC0000551807	iC0000601807	iC0000841807	iC0000851807	iC0000861807	iC0000871807	iC0000881807	iC0000901807	iC0000911807	iC0000931807	iC0000941807	iC0000951807	iC0000961807	iC0000971807	iC0001111807	iC0001181807	iC0001471807	iC0001601807	iC0001611807	iC0001901807	iC0002261807	iC0002291807	iC0002351807	iC0002361807	iC0002501807	iC0002511807	iC0002521807	iC0002531807	iC0002541807	iC0002551807	iC0003031807	iC0003061807	iC0003071807	iC0003081807	iC0003091807	iC0003101807	iC0003111807	iC0003711807	iC0003741807	iC0003771807	iC0004121807	iC0004381807	iC0005111807	iC0005121807	iC0005131807	iC0005161807	iC0005171807	iC0005181807	iC0005441807_1	iC0005451807	iC0005811807	iC0005821807	iC0005831807	iC0005841807	iC0005901807	iC0005911807	iC0005921807	iC0005941807	iC0005961807	iC0005971807	iC0006231807	iC0006241807	iC0006251807	iC0006261807	iC0006271807	iC0006281807	iC0006401804	iC0006501807	iC0006511807	iC0006541807	iC0006541807_1	iC0008271807	iC0008301807	iC0008381807	iC0009621807	iC0009671807	iC0009781807	iC0009811807	iC0009851807	iC0009861807	iC0009951807	iC0010141807	iC0010231807	iC0010241807	iC0010311807	iC0010581807	iC0010851807	iC0010861807	iC0010871807	iC0010881807	iC0010891807	iC0011331807	iC0011501807	iC0011541807	iC0011571807	iC0011991807	iC0012031807	iC0012091807	iC0012441807	iC0012621807	iC0012751807	iC0012941807	iC0013371807	iC0014371807	iC0014471804	iC0014611807_1	iC0014791807	iC0014911807	iC0015911807	iC0015931807	iC0016311807	iC0016831807	iC0016851807	iC0017001807	iC0017061807	iC0017581807	iC0017591807	iC0017741807	iC0019321807	iC0020961807	iC0023111807	iC0024431807	iC0025971807	iC0026891807	iC0030731807	iC0032281807	iC0033731807	iC0034091807	iC0035521807	iC0045581807	iC0046021807	iC0049231807	iC0051411807	iC0052011807"

//multiple files per company id, kept one that was july 2018
/* iC0005451804_1 iC0004121801_1 iC0004121804_1 iC0012751804_1 iC0035521804 iC0023111804 iC0008271804 iC0025971804 iC0005121804_1 iC0014611804_1 iC0008301804 iC0010861804_1 iC0030731804
*/

//multiple had reading errors, so deleted them: iC0022981807 iC0020381807 iC0019131807 iC0015061807 iC0010131807 iC0010121807 iC0003681707 iC0000761807
*****************************************************************
//Data cleaning (only need to be run once)

//fix files by converting from excel to txt so they run in loop
global convertexcel ""
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

global needaddvars10to13 "iC0049231807"
global needaddvars11to13 "iC0008301807"
global needaddvars1213 "iC0000971807	iC0001181807	iC0003031807	iC0003711807	iC0005161807	iC0005171807	iC0005181807	iC0005811807	iC0005821807	iC0005831807	iC0005841807	iC0006261807	iC0006271807	iC0006281807	iC0006511807	iC0010861807	iC0011331807	iC0011571807	iC0011991807	iC0012441807	iC0014471804	iC0016311807	iC0032281807	iC0046021807	iC0052011807"
global needaddvar13 "iC0000551807	iC0002541807	iC0003741807	iC0005901807	iC0006251807	iC0006501807	iC0008381807	iC0010231807	iC0012621807	iC0012941807	iC0013371807	iC0014371807	iC0014611807_1	iC0015911807	iC0015931807	iC0016851807	iC0017001807	iC0017581807	iC0017591807	iC0017741807	iC0019321807	iC0023111807	iC0025971807	iC0026891807	iC0030731807	iC0033731807	iC0034091807"

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
clear
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

global appendingfiles "iC0000211807	iC0000391807	iC0000461807	iC0000471807	iC0000551807	iC0000601807	iC0000841807	iC0000851807	iC0000861807	iC0000871807	iC0000881807	iC0000901807	iC0000911807	iC0000931807	iC0000941807	iC0000951807	iC0000961807	iC0000971807	iC0001111807	iC0001181807	iC0001471807	iC0001601807	iC0001611807	iC0001901807	iC0002261807	iC0002291807	iC0002351807	iC0002361807	iC0002501807	iC0002511807	iC0002521807	iC0002531807	iC0002541807	iC0002551807	iC0003031807	iC0003061807	iC0003071807	iC0003081807	iC0003091807	iC0003101807	iC0003111807	iC0003711807	iC0003741807	iC0003771807	iC0004121807	iC0004381807	iC0005111807	iC0005121807	iC0005131807	iC0005161807	iC0005171807	iC0005181807	iC0005441807_1	iC0005451807	iC0005811807	iC0005821807	iC0005831807	iC0005841807	iC0005901807	iC0005911807	iC0005921807	iC0005941807	iC0005961807	iC0005971807	iC0006231807	iC0006241807	iC0006251807	iC0006261807	iC0006271807	iC0006281807	iC0006401804	iC0006501807	iC0006511807	iC0006541807	iC0006541807_1	iC0008271807	iC0008301807	iC0008381807	iC0009621807	iC0009671807	iC0009781807	iC0009811807	iC0009851807	iC0009861807	iC0009951807	iC0010141807	iC0010231807	iC0010241807	iC0010311807	iC0010581807	iC0010851807	iC0010861807	iC0010871807	iC0010881807	iC0010891807	iC0011331807	iC0011501807	iC0011541807	iC0011571807	iC0011991807	iC0012031807	iC0012091807	iC0012441807	iC0012621807	iC0012751807	iC0012941807	iC0013371807	iC0014371807	iC0014471804	iC0014611807_1	iC0014791807	iC0014911807	iC0015911807	iC0015931807	iC0016311807	iC0016831807	iC0016851807	iC0017001807	iC0017061807	iC0017581807	iC0017591807	iC0017741807	iC0019321807	iC0020961807	iC0023111807	iC0024431807	iC0025971807	iC0026891807	iC0030731807	iC0032281807	iC0033731807	iC0034091807	iC0035521807	iC0045581807	iC0046021807	iC0049231807	iC0051411807	iC0052011807"



use iC0000201807_AL.dta, clear
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

save "$dirOutput/jul2018merged_AL.dta", replace

//47,967 observations total

**********************************************************************************************************************
//Checking data
use "$dirOutput/jul2018merged_AL.dta",clear
global variables_P "stripped_pointname point_identifier stripped_point_loc_qualifier stripped_point_loc stripped_zone stripped_P_footnoteid"


global variables_D1 "stripped_pipelinename stripped_companyid stripped_monthreport stripped_unit_transport" 

global variables_D2 "stripped_shippername stripped_shipper_affiliation stripped_ratesched stripped_contractnum stripped_contract_effectivedate stripped_contract_prim_expirdate stripped_days_nextexpir stripped_negotiated_rates_ind stripped_D_footnoteid"

global variables_A "stripped_agentname stripped_agent_affiliation stripped_A_footnoteid" 

//manually adjusted iC0010311807 to get rid of extra column


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

clear
//generate list of missing pipeline files, if exists
use "$dirOutput/jul2018merged_AL.dta",clear
keep if pipelinename == ""
tab fileid

