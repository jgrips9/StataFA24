/*
*Objectives for learning
*Data Cleaning
missing values
removing special characters
convert string to numeric
Remove extra spaces
Split string varaibles by characters
Variable types
Remove outliers and other data
renaming variables. 
value labels

Collapsing dataset

basic summary stats. 

*Goal is to merge the datasets together. but need to clean the datasets so they are ready to be merged. And also cleaned and ready for analysis after merging.

*/
*step 1. Set directory to location of where data is stored. 
*cd "Z:\jrg363\Workshops FA24\pl532"

*step 2. create do file. Create log file.
log using "logfile.log", replace

*step 3. Import datasets. All of them and save it
import excel "SampleData.xlsx", sheet("SalesOrders") firstrow clear
*view dataset
browse
*save dataset
save sampleRegion_orig, replace

import excel "Region1.xlsx", sheet("Sheet1") firstrow clear
*view dataset
browse
*save dataset
save RegionStates, replace

import excel "Region2.xlsx", sheet("Sheet1") firstrow clear
*view dataset
browse
*save dataset
save RegionSchools, replace

*Want to merge all of these datasets together. Helps to save the datasets before meging them. 

*Now begin with cleaning the first dataset. 
*Step 4. Clean datasets with goal to merge datasets together. 
use sampleRegion_orig, clear

*cleaning steps.
*examine the variables
describe
codebook

preserve
*remove missing values. A few options to do this. 
*individual
drop if Rep == ""
drop if Units == .
restore

preserve
*Then attempting in a loop. Or with multiple. 
drop if Rep == "" | Units == .
restore

*remove duplicates. Across all variables. Full duplciates. 
duplicates drop *, force

*drop all missing
drop if Rep == "" | Units == . | Item == "" | UnitCost == ""

*UnitCost looks strange. Convert to numeric
gen unitcost_n = real( UnitCost )
drop unitcost_n
*subinstr command. 
gen unitcost_n = real(subinstr(UnitCost, "$", "", .))

*remove outliers from Total. Lets do 1.5 above and below median and IQR
su Total, d
drop if Total > `r(p50)' + 1.5*(`r(p75)' - `r(p25)')
su Total, d
drop if Total < `r(p50)' - 1.5*(`r(p75)' - `r(p25)')

save sampleRegion1, replace

*Preparing for the merge. This might have to go into part 2. Dpeends on how far we get in the first 50 minutes. 

*For region. Have it be consistent across all variables. Have it be 'East', 'Central', 'West' as shown in RegionStates
use RegionStates, clear
browse
clear

use RegionSchools, clear
gen Region = "East" if RegionI == "E"
replace Region = "Central" if RegionI == "C"
replace Region = "West" if RegionI == "W"
drop RegionI
save RegionSchools, replace


use sampleRegion1, clear
split Region, parse("-") gen(Region_s)
drop Region_s1 Region
rename Region_s2 Region
*Remove the leading spaces
replace Region = subinstr(Region, " ", "", .)
save sampleRegion1, replace
*Need to remove trailing spaces

*try the encode with the region? Thats another way to setup for merging. Goes by aphabetical order. 
use sampleRegion1, clear
encode Region, gen(reg_n)
save sampleRegion1, replace

use RegionSchools, clear
encode Region, gen(reg_n)
save RegionSchools, replace

use RegionStates, clear
encode Region, gen(reg_n)
save RegionStates, replace

*Step 5. Merge datasets together. 
*Then perform the merge. Horizontal combination of datasets
*Start with the states
use RegionStates, clear
merge 1:1 Region using RegionSchools
rename _merge _mergeSchools
merge 1:m Region using sampleRegion1

drop _mergeSchools _merge
sort Region
save merged_all, replace

*Attempt with the other merge. 
use RegionStates, clear
merge 1:1 reg_n using RegionSchools
rename _merge _mergeSchools
merge 1:m reg_n using sampleRegion1

drop _mergeSchools _merge
sort Region
save merged_all2, replace



*appending datasets. Vertical combination of datasets. 
import excel "SampleData2.xlsx", sheet("SalesOrders") firstrow clear
save sampleRegion2, replace
import excel "SampleData3.xlsx", sheet("SalesOrders") firstrow clear
save sampleRegion3, replace

use sampleRegion_orig, clear
append using sampleRegion2
append using sampleRegion3
tab year
browse
save sampleRegion21-23, replace

*random extras if time
/*
renaming variables. 
value labels
Collapsing dataset
basic summary stats.
*/

use merged_all, clear
*order the variables in datasets
order Region States Schools Description Rep Item Units Total unitcost_n
drop UnitCost
*individual rename
rename States State_Names
*rename all/list of variables by adding an additional string. 
foreach vari of varlist State_Names - year {
	rename `vari' `vari'_ren
}

*individual numeric 5 number summary.
su

*table of statistics
tabstat Units_ren unitcost_n_ren ,  by(Region) statistics(mean sd)

*TTest. 
ttest Units_ren if Region == "East" | Region == "Central", by(Region)

use sampleRegion21-23, clear
*Create text labels for numeric grouping variables
label define Yearn_name 2021 "Year 1" 2022 "Year 2" 2023 "Year 3"
label values year Yearn_name

collapse (mean) Units_mean = Units Total_mean = Total (sd) Units_sd = Units Total_sd = Total (median) Units_med = Units Total_med = Total, by(year)

log close

*could use sample sata merging stuff below.
*sample code below from this link
*https://libguides.princeton.edu/stata-merge-append


