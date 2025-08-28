*Create log file. Keeps track of commands and results.  
*Can use menu to File -> Log -> Begin. Pick location to save log file. 
capture log using "tracking.log", replace

*Open sample dataset. 
sysuse auto, clear
*Look at dataset
browse
*Look at details of dataset. 
describe
codebook

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

*2 way crosstabs to show frequency counts of variables. 
tab foreign rep78
tab foreign rep78, chi2

*Create new columns.
*constant column
gen tax = 0.08
*Create a new column based on other columns.  
gen price_with_tax = price + price*tax

*Create columns based on condition
gen expensive = 1 if price > 10000
*replace command to edit existing variable. 
replace expensive = 0 if price <= 10000

*generate a column 
egen price_group_total = total(price), by(rep78)
egen price_group_avg = mean(price), by(rep78)
egen price_group_sd = sd(price), by(rep78)

sort rep78
browse


tab expensive

*drop or keep rows based on conditions. 
preserve
drop if expensive == 1
drop if rep78 == .
*Same as above is included below, but with the keep option
*keep if expensive == 0
restore


*drop columns from dataset
drop expensive

*OLS regression
*Statistics -> Linear Models and related -> Linear Regression
regress mpg weight length


**********************************************************
*May not cover section below. 
*extras below
*create a table of statistics
table foreign
table foreign, statistic(mean price mpg)
table foreign, statistic(mean price mpg) statistic(sd price mpg)


*tabstat command. 
*similar to table commands above. 
tabstat price weight mpg rep78
tabstat price weight mpg rep78, by(foreign)
tabstat price weight mpg rep78, by(foreign) stat(mean sd min max)

*t-test compare mpg split by domestic and foreign vehicles. 
ttest mpg, by(foreign)

*restructuring dataset by group. 
collapse (sum) mpgtotal = mpg pricetotal = price (mean) mpgmean = mpg pricemean = price (sd) mpgsd = mpg pricesd = price, by(foreign)

*save dataset
save collapsed, replace

*export dataset to excel. 
export excel using "summarized_data.xlsx", replace