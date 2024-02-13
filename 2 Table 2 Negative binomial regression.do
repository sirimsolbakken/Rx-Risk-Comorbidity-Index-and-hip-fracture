********************************************************************************
*					2 NEGATIVE BINOMIAL REGRESSION
********************************************************************************

*************Compare model fit: poisson vs nbreg****************
poisson hipfx_total rxriskscore sex birthyear calendar_year, exposure(person_time_total) irr
est store poisson
nbreg hipfx_total rxriskscore sex birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr
est store nbreg
est stat poisson nbreg					


*************RISK OF HIP FRACTURE PER 1 UNIT INCREASE IN RX-RISK****************
by sex, sort: nbreg hipfx_total rxriskscore birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr


*************INTERACTIONS***********************************

*Between rxriskscore and sex
nbreg hipfx_total c.rxriskscore##sex birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr	

*Between rxriskscore and birthyear
nbreg hipfx_total c.rxriskscore##c.birthyear sex calendar_year, dispersion(mean) exposure(person_time_total) irr	

*Between rxriskscore and calendar_year
nbreg hipfx_total c.rxriskscore##c.calendar_year sex  birthyear, dispersion(mean) exposure(person_time_total) irr 


*************TABLE 2 - IRR BY SEX AND RX-RISK SCORE CATEGORY*************************

*RxRisk categorized
gen rxcat=0 if rxriskscore<=0
replace rxcat=1 if rxriskscore >=1 & rxriskscore <=5
replace rxcat=2 if rxriskscore >=6 & rxriskscore <=10
replace rxcat=3 if rxriskscore >=11 & rxriskscore <=15
replace rxcat=4 if rxriskscore >=16 & rxriskscore <=20
replace rxcat=5 if rxriskscore >=21 & rxriskscore <=25
replace rxcat=6 if rxriskscore >=26
replace rxcat=7 if rxriskscore==.

*Number of hip fractures within each Rx-Risk category
total hipfx_total, over (sex rxcat)

*Number of person years within each Rx-Risk category
total person_time_total, over (sex rxcat)

*nbreg
by sex, sort: nbreg hipfx_total i.rxcat birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr





