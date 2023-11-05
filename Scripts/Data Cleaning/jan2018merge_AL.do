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
global dirData "/Users/anna/Desktop/RA work/2018/jan/ind-0118"
global dirOutput "/Users/anna/Desktop/RA work/2018/jan/output"
cd "$dirData"
//find all files
ls
//copied and pasted into excel, where file id was extracted
//changed all " 2" to "_2"
//remember to use the newest version (ta2, the most revised version or the _2 version if exists) and ones that end in "10" being october records
//all jan records (not including the duplicates)
global records "i0011801	i0151801	i0371801	i0531801	i0681801	i0971801	i1311801	i1611801	i1641801	i1651801	i1981801	i2211801	i2411801	i2481801	iC0000201801	iC0000211801	iC0000391801	iC0000461801	iC0000471801	iC0000601801	iC0000761801	iC0000841801	iC0000851801	iC0000861801	iC0000871801	iC0000881801	iC0000901801	iC0000911801	iC0000931801	iC0000941801	iC0000951801	iC0001111801	iC0001181801	iC0001471801	iC0001601801	iC0001611801	iC0001901801	iC0002261801	iC0002351801	iC0002361801	iC0002501801	iC0002511801	iC0002521801	iC0002531801	iC0002541801	iC0002551801	iC0003061801	iC0003071801	iC0003081801	iC0003091801_1	iC0003101801	iC0003111801	iC0003681801	iC0003711801	iC0003741801	iC0003771801	iC0004121801	iC0004381801	iC0005111801	iC0005121801	iC0005131801	iC0005161801	iC0005171801	iC0005181801	iC0005441801	iC0005451801	iC0005811801	iC0005821801	iC0005831801	iC0005841801	iC0005901801	iC0005911801	iC0005921801	iC0005961801	iC0006231801	iC0006241801	iC0006251801	iC0006261801	iC0006271801	iC0006281801	iC0006501801	iC0006541801	iC0008301801	iC0008381801	iC0009621801	iC0009671801	iC0009781801	iC0009811801	iC0009851801	iC0009861801	iC0009951801	iC0010121801	iC0010131801	iC0010141801	iC0010311801	iC0010581801	iC0010851801	iC0010861801	iC0010871801	iC0010881801	iC0010891801	iC0011331801	iC0011541801	iC0011571801	iC0011991801	iC0012031801	iC0012091801	iC0012171801	iC0012441801	iC0012621801	iC0012751801	iC0012941801	iC0013371801	iC0014371801	iC0014471801	iC0014791801	iC0014911801	iC0014921801	iC0015061801	iC0015911801	iC0015931801	iC0016311801	iC0016831801	iC0016851801	iC0017001801	iC0017061801	iC0017581801	iC0017591801	iC0017741712	iC0019131801	iC0019321801	iC0020961801	iC0022981801	iC0023111801	iC0024431801	iC0025971801	iC0026891801_1	iC0032281810	iC0033731801	iC0034091801	iC0035521801	iC0045581801	iC0046021801	iC0046861801	iC0049231801	iC0051411801	iC0052011801	iC0052741801	iC0052751801"


//took out multiple record of same company and kept the file that is reported in jan
/*iC0005911704 iC0005911710 iC0005911707 iC0001181704_1 iC0001181707_1 iC0001181710_1 iC0005911607 iC0005911610 iC0005911601 iC0005911701 iC0001181701_1 i0151710
*/

*****************************************************************
//Data cleaning (only need to be run once)

//fix files by converting from excel to txt so they run in loop
global convertexcel "iC0000761801 iC0003681801 iC0010121801 iC0010131801 iC0015061801 iC0019131801 iC0022981801 iC0052741801 iC0052751801"
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

global needaddvars10to13 "i2481801 iC0049231801"
global needaddvars1213 "iC0015061801 iC0010131801 iC0010121801 i0971801	i1311801	iC0000761801	iC0001181801	iC0003711801	iC0005161801	iC0005171801	iC0005181801	iC0005811801	iC0005821801	iC0005831801	iC0005841801	iC0006261801	iC0006271801	iC0010121801	iC0010131801	iC0010861801	iC0011331801	iC0011571801	iC0011991801	iC0012441801	iC0014471801	iC0015061801	iC0016311801	iC0032281810	iC0046021801	iC0052011801"
global needaddvar13 "iC0022981801 iC0052751801 iC0024431801 i0011801	i1641801	i2211801	i2411801	iC0002541801	iC0003741801	iC0005901801	iC0006251801	iC0006501801	iC0008381801	iC0012621801	iC0012941801	iC0013371801	iC0014371801	iC0014921801	iC0015911801	iC0015931801	iC0016851801	iC0017001801	iC0017581801	iC0017591801	iC0017741712	iC0019321801	iC0022981801	iC0023111801	iC0025971801	iC0026891801_1	iC0033731801	iC0034091801	iC0052751801"

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

global appendingfiles "i0151801	i0371801	i0531801	i0681801	i0971801	i1311801	i1611801	i1641801	i1651801	i1981801	i2211801	i2411801	i2481801	iC0000201801	iC0000211801	iC0000391801	iC0000461801	iC0000471801	iC0000601801	iC0000761801	iC0000841801	iC0000851801	iC0000861801	iC0000871801	iC0000881801	iC0000901801	iC0000911801	iC0000931801	iC0000941801	iC0000951801	iC0001111801	iC0001181801	iC0001471801	iC0001601801	iC0001611801	iC0001901801	iC0002261801	iC0002351801	iC0002361801	iC0002501801	iC0002511801	iC0002521801	iC0002531801	iC0002541801	iC0002551801	iC0003061801	iC0003071801	iC0003081801	iC0003091801_1	iC0003101801	iC0003111801	iC0003681801	iC0003711801	iC0003741801	iC0003771801	iC0004121801	iC0004381801	iC0005111801	iC0005121801	iC0005131801	iC0005161801	iC0005171801	iC0005181801	iC0005441801	iC0005451801	iC0005811801	iC0005821801	iC0005831801	iC0005841801	iC0005901801	iC0005911801	iC0005921801	iC0005961801	iC0006231801	iC0006241801	iC0006251801	iC0006261801	iC0006271801	iC0006281801	iC0006501801	iC0006541801	iC0008301801	iC0008381801	iC0009621801	iC0009671801	iC0009781801	iC0009811801	iC0009851801	iC0009861801	iC0009951801	iC0010121801	iC0010131801	iC0010141801	iC0010311801	iC0010581801	iC0010851801	iC0010861801	iC0010871801	iC0010881801	iC0010891801	iC0011331801	iC0011541801	iC0011571801	iC0011991801	iC0012031801	iC0012091801	iC0012171801	iC0012441801	iC0012621801	iC0012751801	iC0012941801	iC0013371801	iC0014371801	iC0014471801	iC0014791801	iC0014911801	iC0014921801	iC0015061801	iC0015911801	iC0015931801	iC0016311801	iC0016831801	iC0016851801	iC0017001801	iC0017061801	iC0017581801	iC0017591801	iC0017741712	iC0019131801	iC0019321801	iC0020961801	iC0022981801	iC0023111801	iC0024431801	iC0025971801	iC0026891801_1	iC0032281810	iC0033731801	iC0034091801	iC0035521801	iC0045581801	iC0046021801	iC0046861801	iC0049231801	iC0051411801	iC0052011801	iC0052741801	iC0052751801"



use i0011801_AL.dta, clear
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

save "$dirOutput/jan2018merged_AL.dta", replace

//46,773 observations total

**********************************************************************************************************************
//Checking data
use "$dirOutput/jan2018merged_AL.dta",clear
global variables_P "stripped_pointname point_identifier stripped_point_loc_qualifier stripped_point_loc stripped_zone stripped_P_footnoteid"
//manually fixed i1641801

global variables_D1 "stripped_pipelinename stripped_companyid stripped_monthreport stripped_unit_transport" 
//manually fixed one row of iC0001901801

global variables_D2 "stripped_shippername stripped_shipper_affiliation stripped_ratesched stripped_contractnum stripped_contract_effectivedate stripped_contract_prim_expirdate stripped_days_nextexpir stripped_negotiated_rates_ind stripped_D_footnoteid"

global variables_A "stripped_agentname stripped_agent_affiliation stripped_A_footnoteid" 
//manually adjusted iC0010311801 to remove extra column



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
use "$dirOutput/jan2018merged_AL.dta",clear
keep if pipelinename == ""
tab fileid






