*File -> Change Working Directory
*cd "Z:\jrg363\Workshops FA24\Stata Class Workshops\AEM4110"

*Clear everythting
clear all

*Create log file. Keeps track of commands and results.  
log using "tracking.log", replace

*input data manually
input acc_rate spdlimit
4.58 55
1.86 60
1.61 .
end

*Stata can only be working with 1 dataset at a time.
clear
*file -> import -> Excel Spreadsheet
import excel "SampleData.xlsx", sheet("SalesOrders") firstrow clear

*Desscribe the data. 
*Data -> Describe Data
describe
codebook

*view/edit dataset
*Data -> Data Editor  -> 'Colors of variables and what they mean. '
browse
edit

*save dataset. file -> Save
save "Sample_data", replace

*re-open. File -> Open
use Sample_data, clear

*Bring up a sample dataset for summary stats
sysuse auto, clear
browse
*value labels. Colors of variables. 
describe

*sample stats

*numeric summary stats
*But first documentation from sytax. Includes sample code at bottom. 
help summarize

*options, if features
*Statistics -> Summaries, Tables, Tests
summarize
summarize mpg weight
summarize mpg weight if foreign
summarize mpg weight if foreign, detail

*tab command for frequency counts.
tab foreign

*2 way crosstabs
tab foreign rep78
tab foreign rep78, chi2

*table command. 
table foreign
table foreign, statistic(mean price mpg)
table foreign, statistic(mean price mpg) statistic(sd price mpg)


*tabstat command. 
tabstat price weight mpg rep78
tabstat price weight mpg rep78, by(foreign)
tabstat price weight mpg rep78, by(foreign) stat(mean sd min max)

*t-test
ttest mpg, by(foreign)

*OLS regression
*Statistics -> Linear Models and related -> Linear Regression
regress mpg weight length

*output explained and other sample code
*https://stats.oarc.ucla.edu/stata/output/regression-analysis/

*Attend my workshops how to make these results pretty. 
*https://socialsciences.cornell.edu/computing-and-data/workshops-and-training
*https://socialsciences.cornell.edu/computing-and-data/workshops-and-training

*close log file
log close
