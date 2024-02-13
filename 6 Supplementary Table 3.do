********************************************************************************
*					SUPPLEMENTARY TABLE 3 FOR SPECIFIC DISEASE CATEGORIES
********************************************************************************

*Prepare data file (adding specific disease categories for 2011)
merge m:1
drop if _merge!=3

*Total number of person years in 2012
gen 	enter_2012= mdy(01, 01, 2012) if birthyear <1962 					
format 	enter_2012 %td
gen 	person_time_2012=365.25 if birthyear <1962 
replace person_time_2012=registration_date_stata-enter_2012 if registration_status==3 & registration_status_year==2012
replace person_time_2012=registration_date_stata-enter_2012 if registration_status==5 & registration_status_year==2012 
replace person_time_2012=admission_date-enter_2012 if admission_year==2012
replace person_time_2012 =. if admission_year<2012														
replace person_time_2012 =. if registration_status_year<2012 & (registration_status==3 | registration_status==5)  
gen 	person_time_years_2012 = person_time_2012/365.25

*Generate variable for individuals contributing with person time in 2012, with and without hip fracture
gen hipfx2012=1 if admission_year==2012
replace hipfx2012=0 if hipfx2012==. & person_time_2012!=.


************************IRR for specific disease categories *********************

*by sex
by sex, sort: nbreg hipfx2012 cat0 cat1 cat2 cat3 cat4 cat5 cat6 cat7 cat8 cat9 cat10 cat11 cat12 cat13 cat14 cat15 cat16 cat17 cat18 cat19 cat20 cat21 cat22 cat23 cat24 cat25 cat26 cat27 cat28 cat29 cat30 cat31 cat32 cat33 cat34 cat35 cat36 cat37 cat38 cat39 cat40 cat41 cat42 cat43 cat44 cat45 cat46 birthyear, exposure(person_time_years_2012) irr 


