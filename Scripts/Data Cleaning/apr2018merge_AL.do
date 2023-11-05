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
global dirData "/Users/anna/Desktop/RA work/2018/apr/ind-0418"
global dirOutput "/Users/anna/Desktop/RA work/2018/apr/output"
cd "$dirData"
//find all files
ls
//copied and pasted into excel, where file id was extracted
//changed all " 2" to "_2"
//remember to use the newest version (ta2, the most revised version or the _2 version if exists) and ones that end in "10" being october records
//all jan records (not including the duplicates)
global records "i0371804		i1211804	i1821804	iC0000201804	iC0000211610_1	iC0000211704_1	iC0000211804	iC0000391804	iC0000461804	iC0000471804	iC0000551804	iC0000601804		iC0000841804	iC0000851804	iC0000861804	iC0000871804	iC0000881804	iC0000901804	iC0000911804	iC0000931804	iC0000941804	iC0000951804	iC0000961804	iC0000971804	iC0001111804	iC0001181804	iC0001471804	iC0001601804	iC0001611804	iC0001901804	iC0002261804	iC0002291804	iC0002351804	iC0002361804	iC0002501804	iC0002511804	iC0002521804	iC0002531804	iC0002541804	iC0002551804	iC0003031804	iC0003061804	iC0003071804	iC0003081804	iC0003091804	iC0003101804	iC0003111804		iC0003711804	iC0003741804	iC0003771804	iC0004121804	iC0004381804	iC0005061804	iC0005111804	iC0005131804	iC0005161804	iC0005171804	iC0005181804	iC0005441804	iC0005451804	iC0005811804	iC0005821804	iC0005831804	iC0005841804	iC0005901804	iC0005911804	iC0005921804	iC0005941804	iC0005961804	iC0005971804	iC0006231804	iC0006241804	iC0006251804	iC0006261804	iC0006271804	iC0006281804	iC0006401801	iC0006501804	iC0006511801	iC0006541804	iC0008301804	iC0008381804	iC0009621804	iC0009671804	iC0009781804	iC0009811804	iC0009851804	iC0009861804	iC0009951804	iC0010141804	iC0010231804	iC0010241804	iC0010311804	iC0010581804	iC0010851804	iC0010871804	iC0010881804	iC0010891804	iC0011331804	iC0011501804	iC0011541804	iC0011571804	iC0011991804	iC0012031804	iC0012091804	iC0012441804	iC0012621804	iC0012941804	iC0013371804	iC0014371804	iC0014471804	iC0014611804	iC0014791804	iC0014911804	iC0014921804	iC0015911804	iC0015931804	iC0016311804	iC0016831804	iC0016851804	iC0017001804	iC0017061804	iC0017581804	iC0017591804	iC0017741803	iC0019321804	iC0020961804	iC0024431804	iC0026891804	iC0030731710	iC0032281804	iC0033731804	iC0034091804	iC0035521804	iC0045581804	iC0046021804	iC0046861804	iC0049231804	iC0051411804	iC0052011804"

//took out multiple record of same company and kept the file that is reported in april
/*i1211801 iC0000211707_1 iC0000211801_1 iC0000971801 iC0000961801 iC0002291802 iC0005941802 iC0011501801 iC0032281610 iC0032281701 iC0005901801 iC0005971802 iC0005911801 iC0032281607 iC0032281710 iC0032281801 iC0046021801 iC0009621801 iC0005901710 iC0032281704
*/
//iC0000761804 iC0003681704 iC0005121804 iC0010121804 iC0010131804 iC0015061804 iC0019131804 iC0020381804, iC0022981804, iC0052751804 iC0052741804 shows up as unknown characters, also removed
//if none in april, then took most recent: iC0005901707 iC0032281707
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

global needaddvars10to13 "iC0049231804"
global needaddvars11to13 ""
global needaddvars1213 "i1821804	iC0000971804	iC0001181804	iC0003031804	iC0003711804	iC0005161804	iC0005171804	iC0005181804	iC0005811804	iC0005821804	iC0005831804	iC0005841804	iC0006261804	iC0006271804	iC0006511801	iC0011331804	iC0011571804	iC0011991804	iC0012441804	iC0014471804	iC0016311804	iC0032281804	iC0046021804	iC0052011804"
global needaddvar13 "iC0002541804	iC0003741804	iC0005901804	iC0006251804	iC0006501804	iC0008381804	iC0010231804	iC0012621804	iC0012941804	iC0013371804	iC0014371804	iC0014921804	iC0015911804	iC0015931804	iC0016851804	iC0017001804	iC0017581804	iC0017591804	iC0017741803	iC0019321804	iC0026891804	iC0030731710	iC0033731804	iC0034091804"

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

global appendingfiles "i1211804	i1821804	iC0000201804	iC0000211610_1	iC0000211704_1	iC0000211804	iC0000391804	iC0000461804	iC0000471804	iC0000551804	iC0000601804		iC0000841804	iC0000851804	iC0000861804	iC0000871804	iC0000881804	iC0000901804	iC0000911804	iC0000931804	iC0000941804	iC0000951804	iC0000961804	iC0000971804	iC0001111804	iC0001181804	iC0001471804	iC0001601804	iC0001611804	iC0001901804	iC0002261804	iC0002291804	iC0002351804	iC0002361804	iC0002501804	iC0002511804	iC0002521804	iC0002531804	iC0002541804	iC0002551804	iC0003031804	iC0003061804	iC0003071804	iC0003081804	iC0003091804	iC0003101804	iC0003111804		iC0003711804	iC0003741804	iC0003771804	iC0004121804	iC0004381804	iC0005061804	iC0005111804	iC0005131804	iC0005161804	iC0005171804	iC0005181804	iC0005441804	iC0005451804	iC0005811804	iC0005821804	iC0005831804	iC0005841804	iC0005901804	iC0005911804	iC0005921804	iC0005941804	iC0005961804	iC0005971804	iC0006231804	iC0006241804	iC0006251804	iC0006261804	iC0006271804	iC0006281804	iC0006401801	iC0006501804	iC0006511801	iC0006541804	iC0008301804	iC0008381804	iC0009621804	iC0009671804	iC0009781804	iC0009811804	iC0009851804	iC0009861804	iC0009951804	iC0010141804	iC0010231804	iC0010241804	iC0010311804	iC0010581804	iC0010851804	iC0010871804	iC0010881804	iC0010891804	iC0011331804	iC0011501804	iC0011541804	iC0011571804	iC0011991804	iC0012031804	iC0012091804	iC0012441804	iC0012621804	iC0012941804	iC0013371804	iC0014371804	iC0014471804	iC0014611804	iC0014791804	iC0014911804	iC0014921804	iC0015911804	iC0015931804	iC0016311804	iC0016831804	iC0016851804	iC0017001804	iC0017061804	iC0017581804	iC0017591804	iC0017741803	iC0019321804	iC0020961804	iC0024431804	iC0026891804	iC0030731710	iC0032281804	iC0033731804	iC0034091804	iC0035521804	iC0045581804	iC0046021804	iC0046861804	iC0049231804	iC0051411804	iC0052011804"


use i0371804_AL.dta, clear
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

save "$dirOutput/apr2018merged_AL.dta", replace

//48,598 observations total

**********************************************************************************************************************
//Checking data
use "$dirOutput/apr2018merged_AL.dta",clear
global variables_P "stripped_pointname point_identifier stripped_point_loc_qualifier stripped_point_loc stripped_zone stripped_P_footnoteid"


global variables_D1 "stripped_pipelinename stripped_companyid stripped_monthreport stripped_unit_transport" 
//manually adjusted i1211804

global variables_D2 "stripped_shippername stripped_shipper_affiliation stripped_ratesched stripped_contractnum stripped_contract_effectivedate stripped_contract_prim_expirdate stripped_days_nextexpir stripped_negotiated_rates_ind stripped_D_footnoteid"

global variables_A "stripped_agentname stripped_agent_affiliation stripped_A_footnoteid" 
//manually adjusted iC0010311804 to remove extra column


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
use "$dirOutput/apr2018merged_AL.dta",clear
keep if pipelinename == ""
tab fileid
clear
