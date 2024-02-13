*****************************************************************************************************************
*			3 FIGURE 1 - INCIDENCE RATES AND IRR BY RX-RISK, SEX AND AGE GROUP
*****************************************************************************************************************

*Age groups
gen 	age=calendar_year-birthyear								//Age in the calendar year of Rx-Risk Score																
gen 	agegroup=1 if age >=50 & age <65							
replace agegroup=2 if age >=65 & age <80
replace agegroup=3 if age >=80

*Rx-Risk categories
gen 	rxcat=0 if rxriskscore<=0
replace rxcat=1 if rxriskscore >=1 & rxriskscore <=5
replace rxcat=2 if rxriskscore >=6 & rxriskscore <=10
replace rxcat=3 if rxriskscore >=11 & rxriskscore <=15
replace rxcat=4 if rxriskscore >=16 & rxriskscore <=20
replace rxcat=5 if rxriskscore >=21 & rxriskscore <=25
replace rxcat=6 if rxriskscore >=26
replace rxcat=7 if rxriskscore==.

***********Incidence rates by Rx-Risk category, sex and 15-year age group, adjusted for calendar year and birthyear**************
*Presented in Figure 1 and Supplementary Table 2

gen person_time_days= person_time_total*365.25					
replace person_time_days=round(person_time_days)

dstdize hipfx_total person_time_days birthyear calendar_year if sex == 2 & agegroup==1, by(rxcat) format(%10.0g)
dstdize hipfx_total person_time_days birthyear calendar_year if sex == 2 & agegroup==2, by(rxcat) format(%10.0g)
dstdize hipfx_total person_time_days birthyear calendar_year if sex == 2 & agegroup==3, by(rxcat) format(%10.0g)

dstdize hipfx_total person_time_days birthyear calendar_year if sex == 1 & agegroup==1, by(rxcat) format(%10.0g)
dstdize hipfx_total person_time_days birthyear calendar_year if sex == 1 & agegroup==2, by(rxcat) format(%10.0g)
dstdize hipfx_total person_time_days birthyear calendar_year if sex == 1 & agegroup==3, by(rxcat) format(%10.0g)


*Total number of hip fractures by category of sex, agegroup and rxriskscore
total (brudd_total), over (sex agegroup rxcat)



*************Figure 1: IRRs by agegroup and sex**************************
by sex agegroup, sort: nbreg hipfx_total i.rxcat birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr