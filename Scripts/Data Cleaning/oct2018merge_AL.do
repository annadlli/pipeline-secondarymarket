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
global dirData "/Users/anna/Desktop/RA work/2018/oct/ind-1018"
global dirOutput "/Users/anna/Desktop/RA work/2018/oct/output"
cd "$dirData"
//find all files
ls
//copied and pasted into excel, where file id was extracted
//changed all " 2" to "_2"
//remember to use the newest version (ta2, the most revised version or the _2 version if exists) and ones that end in "10" being october records
//all jan records (not including the duplicates)
global records "i0371810	i1211810	iC0000201810	iC0000211810	iC0000391810	iC0000461810	iC0000471810	iC0000551810	iC0000601810	iC0000761810	iC0000841810	iC0000851810	iC0000861810_1	iC0000871810	iC0000881810	iC0000901810	iC0000911810	iC0000931810	iC0000941810	iC0000951810	iC0000951810_1	iC0000961810	iC0000971810	iC0001111810	iC0001181810	iC0001471810	iC0001601810	iC0001611810	iC0001901810	iC0002261810	iC0002291810	iC0002351810	iC0002361810	iC0002501810	iC0002511810	iC0002521810	iC0002531810	iC0002541810	iC0002551810	iC0003031810	iC0003061810	iC0003071810	iC0003081810	iC0003091810	iC0003101810	iC0003111810	iC0003681810	iC0003711810	iC0004121810	iC0004381810	iC0005111810	iC0005121810	iC0005131810	iC0005161810	iC0005171810	iC0005181810	iC0005441810	iC0005451810	iC0005811810	iC0005821810	iC0005831810	iC0005841810	iC0005901810	iC0005911810	iC0005921810	iC0005941810	iC0005961810	iC0005971810	iC0006231810	iC0006241810	iC0006251810	iC0006261810	iC0006271810	iC0006281810	iC0006541810	iC0008271810	iC0008301810	iC0008381810	iC0009621810	iC0009671810	iC0009781810	iC0009811810	iC0009851810	iC0009861810	iC0009951810	iC0010121810	iC0010131810	iC0010141810	iC0010231810	iC0010241810	iC0010311810	iC0010581810	iC0010851810	iC0010861810	iC0010871810	iC0010891810	iC0011331810	iC0011501810	iC0011541810	iC0011571810	iC0011991810	iC0012031810	iC0012091810	iC0012441810	iC0012621810	iC0012751810	iC0012941810	iC0013371810	iC0014371810	iC0014471810	iC0014791810	iC0014911810	iC0015061810	iC0015911810	iC0015931810	iC0016311810	iC0016851810	iC0017001810	iC0017061810	iC0017581810	iC0017591810	iC0017741810	iC0019131810	iC0019321810	iC0020381810	iC0020961810	iC0022981810	iC0023111810	iC0024431810	iC0025971810	iC0026891810	iC0030731810	iC0032281810	iC0033731810	iC0034091810	iC0035521810	iC0045581810	iC0046021810	iC0049231810	iC0051411810	iC0052741810	iC0052751810	iC0076881810	iI0014611810"
//multiple observation per company: 
/*
iC0005441807_2
*/
*****************************************************************
//Data cleaning (only need to be run once)

//fix files by converting from excel to txt so they run in loop
global convertexcel "iC0010121810 iC0010131810 iC0019131810 iC0020381810 iC0022981810 iC0052741810 iC0052751810 iC0003681810"
foreach i in $convertexcel{
clear
import excel "`i'.xlsx"
export delimited "`i'.txt", delimiter(tab) replace
}

clear
//modify files to ensure have 13 columns
//check which variables need more columns
foreach i in $records{
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
display "`i'"
di c(k)
clear
}

global needaddvars10to13 "iC0049231810"
global needaddvars11to13 "iC0008301810"
global needaddvars1213 "iC0000761810	iC0000971810	iC0001181810	iC0003031810	iC0003711810	iC0005161810	iC0005171810	iC0005181810	iC0005811810	iC0005821810	iC0005831810	iC0005841810	iC0006261810	iC0006271810	iC0006281810	iC0010121810	iC0010131810	iC0010861810	iC0011331810	iC0011571810	iC0011991810	iC0012441810	iC0014471810	iC0015061810	iC0016311810	iC0032281810	iC0046021810	iC0076881810"
global needaddvar13 "iC0000551810	iC0002541810	iC0005901810	iC0006251810	iC0008381810	iC0010231810	iC0012621810	iC0012941810	iC0013371810	iC0014371810	iC0015911810	iC0015931810	iC0016851810	iC0017001810	iC0017581810	iC0017591810	iC0017741810	iC0019321810	iC0020381810	iC0022981810	iC0023111810	iC0025971810	iC0026891810	iC0030731810	iC0033731810	iC0034091810	iC0052751810	iI0014611810"

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

global appendingfiles "i1211810	iC0000201810	iC0000211810	iC0000391810	iC0000461810	iC0000471810	iC0000551810	iC0000601810	iC0000761810	iC0000841810	iC0000851810	iC0000861810_1	iC0000871810	iC0000881810	iC0000901810	iC0000911810	iC0000931810	iC0000941810	iC0000951810	iC0000951810_1	iC0000961810	iC0000971810	iC0001111810	iC0001181810	iC0001471810	iC0001601810	iC0001611810	iC0001901810	iC0002261810	iC0002291810	iC0002351810	iC0002361810	iC0002501810	iC0002511810	iC0002521810	iC0002531810	iC0002541810	iC0002551810	iC0003031810	iC0003061810	iC0003071810	iC0003081810	iC0003091810	iC0003101810	iC0003111810	iC0003681810	iC0003711810	iC0004121810	iC0004381810	iC0005111810	iC0005121810	iC0005131810	iC0005161810	iC0005171810	iC0005181810	iC0005441810	iC0005451810	iC0005811810	iC0005821810	iC0005831810	iC0005841810	iC0005901810	iC0005911810	iC0005921810	iC0005941810	iC0005961810	iC0005971810	iC0006231810	iC0006241810	iC0006251810	iC0006261810	iC0006271810	iC0006281810	iC0006541810	iC0008271810	iC0008301810	iC0008381810	iC0009621810	iC0009671810	iC0009781810	iC0009811810	iC0009851810	iC0009861810	iC0009951810	iC0010121810	iC0010131810	iC0010141810	iC0010231810	iC0010241810	iC0010311810	iC0010581810	iC0010851810	iC0010861810	iC0010871810	iC0010891810	iC0011331810	iC0011501810	iC0011541810	iC0011571810	iC0011991810	iC0012031810	iC0012091810	iC0012441810	iC0012621810	iC0012751810	iC0012941810	iC0013371810	iC0014371810	iC0014471810	iC0014791810	iC0014911810	iC0015061810	iC0015911810	iC0015931810	iC0016311810	iC0016851810	iC0017001810	iC0017061810	iC0017581810	iC0017591810	iC0017741810	iC0019131810	iC0019321810	iC0020381810	iC0020961810	iC0022981810	iC0023111810	iC0024431810	iC0025971810	iC0026891810	iC0030731810	iC0032281810	iC0033731810	iC0034091810	iC0035521810	iC0045581810	iC0046021810	iC0049231810	iC0051411810	iC0052741810	iC0052751810	iC0076881810	iI0014611810"



use i0371810_AL.dta, clear
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

save "$dirOutput/oct2018merged_AL.dta", replace

//45,580 observations total

**********************************************************************************************************************
//Checking data
use "$dirOutput/oct2018merged_AL.dta",clear
global variables_P "stripped_pointname point_identifier stripped_point_loc_qualifier stripped_point_loc stripped_zone stripped_P_footnoteid"
//manually adjusted iC0010311810, which had misaligned observations for P, D, and A

global variables_D1 "stripped_pipelinename stripped_companyid stripped_monthreport stripped_unit_transport" 


global variables_D2 "stripped_shippername stripped_shipper_affiliation stripped_ratesched stripped_contractnum stripped_contract_effectivedate stripped_contract_prim_expirdate stripped_days_nextexpir stripped_negotiated_rates_ind stripped_D_footnoteid"
//manually adjusted i1211810, where rate schedule and contract number not separated 
//manually adjusted iC0010241810 for mismatched obs
global variables_A "stripped_agentname stripped_agent_affiliation stripped_A_footnoteid" 
//manually adjusted iC0010311810, got ride of extra column


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
use "$dirOutput/oct2018merged_AL.dta",clear
keep if pipelinename == ""
tab fileid

