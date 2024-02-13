
****************************************************************************************************************
*4 SENSITIVITY ANALYSIS: ASSIGNING THOSE <70 YEARS WITH MISSING RX-RISK SCORE TO THE REFERENCE CATEGORY
****************************************************************************************************************

gen age=calendar_year-birthyear
replace rxriskscore=0 if age<70 & rxriskscore==.

*Risk of hip fracture per 1 unit increase in Rx-Risk
by sex, sort: nbreg hipfx_total rxriskscore birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr

*RxRisk categorized
gen rxcat=0 if rxriskscore<=0
replace rxcat=1 if rxriskscore >=1 & rxriskscore <=5
replace rxcat=2 if rxriskscore >=6 & rxriskscore <=10
replace rxcat=3 if rxriskscore >=11 & rxriskscore <=15
replace rxcat=4 if rxriskscore >=16 & rxriskscore <=20
replace rxcat=5 if rxriskscore >=21 & rxriskscore <=25
replace rxcat=6 if rxriskscore >=26
replace rxcat=7 if rxriskscore==.

*IRR by sex and Rx-Risk category
by sex, sort: nbreg hipfx_total i.rxcat birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr




************************************************************************************
*4 SENSITIVITY ANALYSIS: EXCLUDING THOSE WITHOUT RX-RISK
************************************************************************************

drop if rxriskscore==.

*Risk of hip fracture per 1 unit increase in Rx-Risk
by sex, sort: nbreg hipfx_total rxriskscore birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr

*RxRisk categorized
gen rxcat=0 if rxriskscore<=0
replace rxcat=1 if rxriskscore >=1 & rxriskscore <=5
replace rxcat=2 if rxriskscore >=6 & rxriskscore <=10
replace rxcat=3 if rxriskscore >=11 & rxriskscore <=15
replace rxcat=4 if rxriskscore >=16 & rxriskscore <=20
replace rxcat=5 if rxriskscore >=21 & rxriskscore <=25
replace rxcat=6 if rxriskscore >=26

*IRR by sex and Rx-Risk category
by sex, sort: nbreg hipfx_total i.rxcat birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr
