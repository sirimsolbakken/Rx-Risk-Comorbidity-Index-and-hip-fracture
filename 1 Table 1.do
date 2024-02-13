**************************************************************************************************************************************************
*				1 TABLE 1 -  Descriptive characteristics of individuals ≥51 years with and without hip fracture in 2012
**************************************************************************************************************************************************
*Total number of individuals during the whole time period
tab sex

*Total number of hip fractures during the whole time period
tab admission_year if admission_year<2018 	

*Total number of person years in 2012
gen 	enter_2012= mdy(01, 01, 2012) if birthyear <1962 					
format 	enter_2012 %td
gen 	person_time_2012=365.25 if birthyear <1962 
replace person_time_2012=registration_date_stata_stata-enter_2012 if registration_status==3 & registration_status_year==2012
replace person_time_2012=registration_date_stata_stata-enter_2012 if registration_status==5 & registration_status_year==2012 
replace person_time_2012=bruddato_1-enter_2012 if admission_year==2012
replace person_time_2012 =. if admission_year<2012														
replace person_time_2012 =. if registration_status_year<2012 & (registration_status==3 | registration_status==5)  
gen 	person_time_years_2012 = person_time_2012/365.25

*Generate variable for individuals contributing with person time in 2012, with and without hip fracture
gen hipfx2012=1 if admission_year==2012
replace hipfx2012=0 if hipfx2012==. & person_time_2012!=.
		
*Gen age groups
gen age_2012= 2012-birthyear if hipfx2012 !=. 	
gen 	agegroup_2012=1 if age_2012 >=51 & age_2012 <=65							
replace agegroup_2012=2 if age_2012 >=66 & age_2012 <=80
replace agegroup_2012=3 if age_2012 >80

*Number of individuals with and without hip fracture by 15-year age group 
by agegroup_2012, sort: tab sex hipfx2012 

*Total number of person years by sex, age group and hip fracture status
total  person_time_years_2012, over(sex agegroup_2012 hipfx2012) 

*Median age in 2012
by sex hipfx2012, sort: sum age_2012, detail

*Median RxRiskScore2011 by sex, age group and hip fracture status
by sex agegroup_2012 hipfx2012, sort: sum RxRiskScore2011, detail




	