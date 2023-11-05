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
global dirData "/Users/anna/Desktop/RA work/march data/2022/ind-2207"
global dirOutput "/Users/anna/Desktop/RA work/march data/2022/outputjuly"
cd "$dirData"
//find all files
ls
//copied and pasted into excel, where file id was extracted
//remember to use the newest version (ta1, the most revised version or the _1 version if exists) and ones that end in "10" being october records
//all july records (not including the duplicates)
global records "iC0000202207	iC0000212207	iC0000392207	iC0000402207	iC0000462207	iC0000472207	iC0000552207	iC0000602207	iC0000762207	iC0000842207	iC0000852207	iC0000862207	iC0000872207	iC0000882207	iC0000902207	iC0000912207	iC0000932207	iC0000942207	iC0000952207	iC0000962207	iC0000972207	iC0001112207	iC0001182207	iC0001472207	iC0001602207	iC0001612207	iC0001902207	iC0002262207	iC0002292207	iC0002312207	iC0002352207	iC0002362207	iC0002502207	iC0002512207	iC0002532207	iC0002542207	iC0002552207	iC0003032207	iC0003062207	iC0003072207	iC0003092207_1	iC0003102207	iC0003112207	iC0003712207	iC0003742207	iC0003772207	iC0004382207	iC0005112207	iC0005122207	iC0005132207	iC0005162207	iC0005172207	iC0005182207	iC0005442207	iC0005452207	iC0005812207	iC0005822207	iC0005832207	iC0005842207 	iC0005912207	iC0005922207	iC0005942207	iC0005962207	iC0005972207	iC0006232204	iC0006242207	iC0006252207	iC0006262207	iC0006272207	iC0006402207	iC0006502207	iC0006512207	iC0006542207	iC0008272207	iC0008302207	iC0008382207	iC0009622207	iC0009672207	iC0009782207	iC0009812207	iC0009852207	iC0009862207	iC0009952207	iC0010122207	iC0010132207	iC0010142207	iC0010232207	iC0010242207	iC0010312207	iC0010582207	iC0010852207	iC0010872207	iC0010882207	iC0010892207	iC0011332207	iC0011502207	iC0011542207	iC0011572207	iC0011992207	iC0012032207	iC0012092207	iC0012172207	iC0012442207	iC0012622207	iC0012752207	iC0012942207	iC0013372207	iC0014372207	iC0014472207	iC0014612207	iC0014792207	iC0014912207	iC0015062207	iC0015912207	iC0015932207	iC0016312207	iC0016832207	iC0016852207		iC0017002207	iC0017062207	iC0017582207	iC0017592207	iC0017742207	iC0019132207	iC0019322204	iC0020382207	iC0020962207	iC0022982207	iC0023112207	iC0024432207	iC0025972207	iC0026892207	iC0030732207	iC0032282207	iC0033552204	iC0033732207	iC0034092207	iC0035522207	iC0045582207	iC0046022207	iC0046862207	iC0049232207	iC0051412207	iC0052012207	iC0052742207	iC0052752207	iC0076882207	iC0088842207	iC0089262207	iC0102802207	iC0102842207	iC0103052201	iC0104762207	iC0113352207	iC0113642207	iIC0004122207"

/*note multiple record companies, kept most recent; 
iC0000552204 Destin Pipeline Company 
iC0000902204 Ozark Gas Transmission
iC0006512204 WTG Hugoton, LP
iC0008272204 Chandeleur Pipe Line
iC0010232204 "BBT (AlaTenn)
iC0010242204 BBT (Midla)
iC0016312204 MoGas Pipeline
iC0017002204 BBT Trans-Union Interstate Pipeline
iC0035522204 Kinetica Energy Express
iC0113352204 ROARING FORK INTERSTATE GAS TRANSMISSION
*/
*****************************************************************
//Data cleaning (only need to be run once)

//fix files by converting from excel to txt so they run in loop
global convertexcel "iC0015062207 iC0019132207 iC0022982207 iC0020382207 iC0052742207 iC0052752207 iC0076882207 iC0088842207"
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
global needaddvars10to13 "iC0026892207 iC0051412207 iC0049232207"
global needaddvars11to13 "iC0006272207"
global needaddvars1213 "iC0008302207 iC0008272207 iC0006512207 iC0005172207 iC0005162207 iC0005182207 iC0005812207 iC0005822207 iC0005832207 iC0005842207 iC0010122207 iC0010132207 iC0010232207 iC0010242207 iC0011332207 iC0012442207 iC0015062207 iC0016312207 iC0017002207 iC0024432207 iC0032282207 iC0046862207 iC0052742207 iC0076882207 iC0088842207 iC0089262207 iC0102802207 iC0102842207 iC0113352207 iC0113642207 iC0000402207 iC0000552207 iC0000762207	iC0102842207	iC0113352207	iC0113642207	iC0001182207	iC0002532207	iC0003032207	iC0003712207	iC0052012207	iC0076882207	iC0088842207	iC0102802207	iC0089262207 iC0000902207 iC0000972207"
global needaddvar13 "iC0104762207 iC0103052201 iC0052752207 iC0008382207 iC0006502207 iC0005912207 iC0006242207 iC0006252207 iC0010852207 iC0011572207 iC0011992207 iC0012622207 iC0012942207 iC0013372207 iC0014372207 iC0014472207 iC0014612207 iC0015912207 iC0015932207 iC0017582207 iC0017742207 iC0019322204 iC0020382207 iC0023112207 iC0025972207 iC0030732207 iC0034092207 iC0046022207iC0000552201 iC0000552204 iC0002542207	iC0003742207	iC0046862207 iC0046022207 iC0033732207 iC0017592207"

foreach i in $needaddvars10to13{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
di "`i'"
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
di "`i'"
gen v12 =.
gen v13 =.
export delimited "`i'.txt", delimiter(tab) novarnames replace
}

foreach i in $needaddvar13{
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
di "`i'"
gen v13 =.
export delimited "`i'.txt", delimiter(tab) novarnames replace
}
*****************************************************************************************************************************
//Convert to dta
//clean data for 2022 july
foreach i in $records{
display "`i'"
clear
import delimited "`i'.txt", delimiters(tab) varnames(nonames)
drop if v1[1] =="v1" & _n==1
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
	if _N !=0{ //added as for files where hav no A
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
	merge m:1 fakeID using _temp_agent 
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

global appendingfiles "iC0000212207	iC0000392207	iC0000402207	iC0000462207	iC0000472207	iC0000552207	iC0000602207	iC0000762207	iC0000842207	iC0000852207	iC0000862207	iC0000872207	iC0000882207	iC0000902207	iC0000912207	iC0000932207	iC0000942207	iC0000952207	iC0000962207	iC0000972207	iC0001112207	iC0001182207	iC0001472207	iC0001602207	iC0001612207	iC0001902207	iC0002262207	iC0002292207	iC0002312207	iC0002352207	iC0002362207	iC0002502207	iC0002512207	iC0002532207	iC0002542207	iC0002552207	iC0003032207	iC0003062207	iC0003072207	iC0003092207_1	iC0003102207	iC0003112207	iC0003712207	iC0003742207	iC0003772207	iC0004382207	iC0005112207	iC0005122207	iC0005132207	iC0005162207	iC0005172207	iC0005182207	iC0005442207	iC0005452207	iC0005812207	iC0005822207	iC0005832207	iC0005842207 	iC0005912207	iC0005922207	iC0005942207	iC0005962207	iC0005972207	iC0006232204	iC0006242207	iC0006252207	iC0006262207	iC0006272207	iC0006402207	iC0006502207	iC0006512207	iC0006542207	iC0008272207	iC0008302207	iC0008382207	iC0009622207	iC0009672207	iC0009782207	iC0009812207	iC0009852207	iC0009862207	iC0009952207	iC0010122207	iC0010132207	iC0010142207	iC0010232207	iC0010242207	iC0010312207	iC0010582207	iC0010852207	iC0010872207	iC0010882207	iC0010892207	iC0011332207	iC0011502207	iC0011542207	iC0011572207	iC0011992207	iC0012032207	iC0012092207	iC0012172207	iC0012442207	iC0012622207	iC0012752207	iC0012942207	iC0013372207	iC0014372207	iC0014472207	iC0014612207	iC0014792207	iC0014912207	iC0015062207	iC0015912207	iC0015932207	iC0016312207	iC0016832207	iC0016852207	iC0017002207	iC0017062207	iC0017582207	iC0017592207	iC0017742207	iC0019132207	iC0019322204	iC0020382207	iC0020962207	iC0022982207	iC0023112207	iC0024432207	iC0025972207	iC0026892207	iC0030732207	iC0032282207	iC0033552204	iC0033732207	iC0034092207	iC0035522207	iC0045582207	iC0046022207	iC0046862207	iC0049232207	iC0051412207	iC0052012207	iC0052742207	iC0052752207	iC0076882207	iC0088842207	iC0089262207	iC0102802207	iC0102842207	iC0103052201	iC0104762207	iC0113352207	iC0113642207	iIC0004122207"


use iC0000202207_AL.dta, clear
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

save "$dirOutput/jul2022merged_AL.dta", replace

//46,644 observations total

**********************************************************************************************************************
//Checking data
use "$dirOutput/jul2022merged_AL.dta",clear
global variables_P "stripped_pointname point_identifier stripped_point_loc_qualifier stripped_point_loc stripped_zone stripped_P_footnoteid"

global variables_D1 "stripped_pipelinename stripped_companyid stripped_monthreport stripped_unit_transport" 


global variables_D2 "stripped_shippername stripped_shipper_affiliation stripped_ratesched stripped_contractnum stripped_contract_effectivedate stripped_contract_prim_expirdate stripped_days_nextexpir stripped_negotiated_rates_ind stripped_D_footnoteid"
//manually separated iC0000402207 and iC0005912207


global variables_A "stripped_agentname stripped_agent_affiliation stripped_A_footnoteid" 
//manually deleted numbers that were in agentname column for iC0001182207
//manually adjusted agent affiliation iC0010312207 and iC0013372207
// has 2 companies on line with agent_affiliation being N;N : iC0000552207 and iC0010242207

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
use "$dirOutput/jul2022merged_AL.dta",clear
keep if pipelinename == ""
tab fileid

