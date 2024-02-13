*****************************************************************************************************************
*							SUPPLEMENTARY FIGURE 2: 3-AND 5-YEAR LATENCY ANALYSIS
*****************************************************************************************************************

*************RxRiskScore2007 as exposure and hip fractures in 2008 as outcome**********************

*Person time in 2008
gen enter_2008= mdy(01, 01, 2008) if birthyear <1958 
format enter_2008 %td
gen person_time_2008=365.25 if birthyear <1958 
replace person_time_2008=registration_date_stata-enter_2008 if registration_status==3 & registration_status_year==2008
replace person_time_2008=registration_date_stata-enter_2008 if registration_status==5 & registration_status_year==2008 
replace person_time_2008=admission_date-enter_2008 if admission_year==2008 
replace person_time_2008 =. if admission_year<2008														
replace person_time_2008 =. if registration_status_year<2008 & (registration_status==3 | registration_status==5)  
gen person_time_years_2008 = person_time_2008/365.25

gen hipfx_2008=1 if admission_year==2008
replace hipfx_2008=0 if hipfx_2008==.

collapse (sum) hipfx_2008 person_time_years_2008, by (RxRiskScore2007 sex birthyear)
drop if person_time_years_2008 == 0 		

*nbreg - IRR the following year
gen rxcat=0 if RxRiskScore2007<=0
replace rxcat=1 if RxRiskScore2007 >=1 & RxRiskScore2007 <=5
replace rxcat=2 if RxRiskScore2007 >=6 & RxRiskScore2007 <=10
replace rxcat=3 if RxRiskScore2007 >=11 & RxRiskScore2007 <=15
replace rxcat=4 if RxRiskScore2007 >15
replace rxcat=5 if RxRiskScore2007==.

by sex, sort: nbreg hipfx_2008 i.rxcat birthyear, dispersion(mean) exposure(person_time_years_2008) irr

*************3-year latency analysis: RxRiskScore2007 as exposure and hip fractures in 2010 as outcome**********************
*Person time in 2010
gen enter_2010= mdy(01, 01, 2010) if birthyear <1960
format enter_2010 %td
gen person_time_2010=365.25 if birthyear <1960
replace person_time_2010=registration_date_stata-enter_2010 if registration_status==3 & registration_status_year==2010
replace person_time_2010=registration_date_stata-enter_2010 if registration_status==5 & registration_status_year==2010 
replace person_time_2010=admission_date-enter_2010 if admission_year==2010
replace person_time_2010 =. if admission_year<2010														
replace person_time_2010 =. if registration_status_year<2010 & (registration_status==3 | registration_status==5)  
gen person_time_years_2010 = person_time_2010/365.25

gen hipfx_2010=1 if admission_year==2010
replace hipfx_2010=0 if hipfx_2010==.

collapse (sum) hipfx_2010 person_time_years_2010, by (RxRiskScore2007 sex birthyear)
drop if person_time_years_2010== 0 		

*nbreg - 3 year latency analysis
gen rxcat=0 if RxRiskScore2007<=0
replace rxcat=1 if RxRiskScore2007 >=1 & RxRiskScore2007 <=5
replace rxcat=2 if RxRiskScore2007 >=6 & RxRiskScore2007 <=10
replace rxcat=3 if RxRiskScore2007 >=11 & RxRiskScore2007 <=15
replace rxcat=4 if RxRiskScore2007 >15
replace rxcat=5 if RxRiskScore2007==.

by sex, sort: nbreg hipfx_2010 i.rxcat birthyear, dispersion(mean) exposure(person_time_years_2010) irr


*************5-year latency analysis: RxRiskScore2007 as exposure and hip fractures in 2012 as outcome**********************
*Person time in 2012
gen enter_2012= mdy(01, 01, 2012) if birthyear <1962 
format enter_2012 %td
gen person_time_2012=365.25 if birthyear <1962 
replace person_time_2012=registration_date_stata-enter_2012 if registration_status==3 & registration_status_year==2012
replace person_time_2012=registration_date_stata-enter_2012 if registration_status==5 & registration_status_year==2012 
replace person_time_2012=admission_date-enter_2012 if admission_year==2012
replace person_time_2012 =. if admission_year<2012														
replace person_time_2012 =. if registration_status_year<2012 & (registration_status==3 | registration_status==5)  
gen person_time_years_2012 = person_time_2012/365.25

gen hipfx_2012=1 if admission_year==2012
replace hipfx_2012=0 if hipfx_2012==.

collapse (sum) hipfx_2012 person_time_years_2012, by (RxRiskScore2007 sex birthyear)
drop if person_time_years_2012== 0 		

*nbreg - 5 year latency analysis
gen rxcat=0 if RxRiskScore2007<=0
replace rxcat=1 if RxRiskScore2007 >=1 & RxRiskScore2007 <=5
replace rxcat=2 if RxRiskScore2007 >=6 & RxRiskScore2007 <=10
replace rxcat=3 if RxRiskScore2007 >=11 & RxRiskScore2007 <=15
replace rxcat=4 if RxRiskScore2007 >15
replace rxcat=5 if RxRiskScore2007==.

by sex, sort: nbreg hipfx_2012 i.rxcat birthyear, dispersion(mean) exposure(person_time_years_2012) irr



*****************************************************************************************************************
*			SUPPLEMENTARY FIGURE 3. IRR IN WOMEN COMPARED TO MEN BY AGE GROUP AND RX-RISK SCORE CATEGORY
*****************************************************************************************************************

*Comparison of men and women by age group and Rx-Risk category
by rxcat agegroup, sort: nbreg hipfx_total sex birthyear calendar_year, dispersion(mean) exposure(person_time_total) irr





