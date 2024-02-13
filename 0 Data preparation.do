************************************************************
*					0 DATA PREPARATION
************************************************************

drop if registration_status ==.				
drop if admission_year < 2006				

*************Registration dates and date of hip fracture******************************
*Registration status: 1 if alive, 3 if emigrated, 5 if dead

generate registration_date_stata = regstatdato - td(01jan1960)			
format registration_date_stata %td
gen registration_status_year = year( registration_date_stata)

drop if registration_status==3 & registration_status_year <2006
drop if registration_status==5 & registration_status_year <2006

gen hipfx_date= mdy(admission_month, 15, admission_year)			
format hipfx_date %td

drop if registration_date_stata < hipfx_date & norhip==1 & registration_status==3
drop if registration_date_stata < hipfx_date & norhip==1 & registration_status==5

*******************Age-individuals included from the year they turn 51*********************** 

drop if birthyear==1956 & registration_status_year< 2007 & (registration_status==3 | registration_status==5)			
drop if birthyear==1957 & registration_status_year< 2008 & (registration_status==3 | registration_status==5)			
drop if birthyear==1958 & registration_status_year< 2009 & (registration_status==3 | registration_status==5)
drop if birthyear==1959 & registration_status_year< 2010 & (registration_status==3 | registration_status==5)
drop if birthyear==1960 & registration_status_year< 2011 & (registration_status==3 | registration_status==5)
drop if birthyear==1961 & registration_status_year< 2012 & (registration_status==3 | registration_status==5)
drop if birthyear==1962 & registration_status_year< 2013 & (registration_status==3 | registration_status==5)
drop if birthyear==1963 & registration_status_year< 2014 & (registration_status==3 | registration_status==5)
drop if birthyear==1964 & registration_status_year< 2015 & (registration_status==3 | registration_status==5)
drop if birthyear==1965 & registration_status_year< 2016 & (registration_status==3 | registration_status==5)
drop if birthyear==1966 & registration_status_year< 2017 & (registration_status==3 | registration_status==5)

drop if birthyear == 1956 & admission_year<2007
drop if birthyear == 1957 & admission_year<2008
drop if birthyear == 1958 & admission_year<2009
drop if birthyear == 1959 & admission_year<2010
drop if birthyear == 1960 & admission_year<2011
drop if birthyear == 1961 & admission_year<2012
drop if birthyear == 1962 & admission_year<2013
drop if birthyear == 1963 & admission_year<2014
drop if birthyear == 1964 & admission_year<2015
drop if birthyear == 1965 & admission_year<2016
drop if birthyear == 1966 & admission_year<2017

****************Calculation of person time for each calendar year***********************************

****************2006********************
preserve

gen enter_2006= mdy(01, 01, 2006) if birthyear <1956 	
format enter_2006 %td
gen person_time_2006=365.25 if birthyear <1956 
replace person_time_2006=registration_date_stata-enter_2006 if registration_status==3 & registration_status_year==2006
replace person_time_2006=registration_date_stata-enter_2006 if registration_status==5 & registration_status_year==2006 
replace person_time_2006=hipfx_date-enter if admission_year==2006
gen person_time_years_2006 = person_time_2006/365.25

gen hipfx_2006=1 if admission_year==2006
replace hipfx_2006=0 if hipfx_2006==.

*Collapse number of hip fractures and person time by Rx-Risk category in 2006, sex, and birthyear 
collapse (sum) hipfx_2006 person_time_years_2006, by (RxRiskScore2005 sex birthyear)
rename RxRiskScore2005 rxriskscore
drop if person_time_years_2006==0	
gen calendar_year=2005			

*save file

****************2007*******************
restore, preserve

gen enter_2007= mdy(01, 01, 2007) if birthyear <1957 
format enter_2007 %td

gen person_time_2007=365.25 if birthyear <1957 
replace person_time_2007=registration_date_stata-enter_2007 if registration_status==3 & registration_status_year==2007
replace person_time_2007=registration_date_stata-enter_2007 if registration_status==5 & registration_status_year==2007 
replace person_time_2007=hipfx_date-enter_2007 if admission_year==2007 
replace person_time_2007 =. if admission_year<2007														
replace person_time_2007 =. if registration_status_year<2007 & (registration_status==3 | registration_status==5)  
gen person_time_years_2007 = person_time_2007/365.25

gen hipfx_2007=1 if admission_year==2007
replace hipfx_2007=0 if hipfx_2007==.

collapse (sum) hipfx_2007 person_time_years_2007, by (RxRiskScore2006 sex birthyear)
rename RxRiskScore2006 rxriskscore
drop if person_time_years_2007 == 0 		
gen calendar_year=2006

*save 

*****************2008*********************
restore, preserve

gen enter_2008= mdy(01, 01, 2008) if birthyear <1958 
format enter_2008 %td

gen person_time_2008=365.25 if birthyear <1958 
replace person_time_2008=registration_date_stata-enter_2008 if registration_status==3 & registration_status_year==2008
replace person_time_2008=registration_date_stata-enter_2008 if registration_status==5 & registration_status_year==2008 
replace person_time_2008=hipfx_date-enter_2008 if admission_year==2008 
replace person_time_2008 =. if admission_year<2008														
replace person_time_2008 =. if registration_status_year<2008 & (registration_status==3 | registration_status==5)  
gen person_time_years_2008 = person_time_2008/365.25

gen hipfx_2008=1 if admission_year==2008
replace hipfx_2008=0 if hipfx_2008==.

collapse (sum) hipfx_2008 person_time_years_2008, by (RxRiskScore2007 sex birthyear)
rename RxRiskScore2007 rxriskscore
drop if person_time_years_2008 == 0 		
gen calendar_year=2007

*save 

*************2009************************
restore, preserve

gen enter_2009= mdy(01, 01, 2009) if birthyear <1959 
format enter_2009 %td

gen person_time_2009=365.25 if birthyear <1959 
replace person_time_2009=registration_date_stata-enter_2009 if registration_status==3 & registration_status_year==2009
replace person_time_2009=registration_date_stata-enter_2009 if registration_status==5 & registration_status_year==2009 
replace person_time_2009=hipfx_date-enter_2009 if admission_year==2009 
replace person_time_2009 =. if admission_year<2009														
replace person_time_2009 =. if registration_status_year<2009 & (registration_status==3 | registration_status==5)  
gen person_time_years_2009 = person_time_2009/365.25

gen hipfx_2009=1 if admission_year==2009
replace hipfx_2009=0 if hipfx_2009==.

collapse (sum) hipfx_2009 person_time_years_2009, by (RxRiskScore2008 sex birthyear)
rename RxRiskScore2008 rxriskscore
drop if person_time_years_2009== 0 		
gen calendar_year=2008
*save

****************2010*********************
restore, preserve

gen enter_2010= mdy(01, 01, 2010) if birthyear <1960
format enter_2010 %td

gen person_time_2010=365.25 if birthyear <1960
replace person_time_2010=registration_date_stata-enter_2010 if registration_status==3 & registration_status_year==2010
replace person_time_2010=registration_date_stata-enter_2010 if registration_status==5 & registration_status_year==2010 
replace person_time_2010=hipfx_date-enter_2010 if admission_year==2010
replace person_time_2010 =. if admission_year<2010														
replace person_time_2010 =. if registration_status_year<2010 & (registration_status==3 | registration_status==5)  
gen person_time_years_2010 = person_time_2010/365.25

gen hipfx_2010=1 if admission_year==2010
replace hipfx_2010=0 if hipfx_2010==.

collapse (sum) hipfx_2010 person_time_years_2010, by (RxRiskScore2009 sex birthyear)
rename RxRiskScore2009 rxriskscore
drop if person_time_years_2010== 0 		
gen calendar_year=2009

*save 

**************2011***********************
restore, preserve

gen enter_2011= mdy(01, 01, 2011) if birthyear <1961 
format enter_2011 %td

gen person_time_2011=365.25 if birthyear <1961
replace person_time_2011=registration_date_stata-enter_2011 if registration_status==3 & registration_status_year==2011
replace person_time_2011=registration_date_stata-enter_2011 if registration_status==5 & registration_status_year==2011 
replace person_time_2011=hipfx_date-enter_2011 if admission_year==2011
replace person_time_2011 =. if admission_year<2011														
replace person_time_2011 =. if registration_status_year<2011 & (registration_status==3 | registration_status==5)  
gen person_time_years_2011 = person_time_2011/365.25

gen hipfx_2011=1 if admission_year==2011
replace hipfx_2011=0 if hipfx_2011==.

collapse (sum) hipfx_2011 person_time_years_2011, by (RxRiskScore2010 sex birthyear)
rename RxRiskScore2010 rxriskscore
drop if person_time_years_2011== 0 		
gen calendar_year=2010

*save 

**************2012**********************
restore, preserve

gen enter_2012= mdy(01, 01, 2012) if birthyear <1962 
format enter_2012 %td

gen person_time_2012=365.25 if birthyear <1962 
replace person_time_2012=registration_date_stata-enter_2012 if registration_status==3 & registration_status_year==2012
replace person_time_2012=registration_date_stata-enter_2012 if registration_status==5 & registration_status_year==2012 
replace person_time_2012=hipfx_date-enter_2012 if admission_year==2012
replace person_time_2012 =. if admission_year<2012														
replace person_time_2012 =. if registration_status_year<2012 & (registration_status==3 | registration_status==5)  
gen person_time_years_2012 = person_time_2012/365.25

gen hipfx_2012=1 if admission_year==2012
replace hipfx_2012=0 if hipfx_2012==.

collapse (sum) hipfx_2012 person_time_years_2012, by (RxRiskScore2011 sex birthyear)
rename RxRiskScore2011 rxriskscore
drop if person_time_years_2012== 0 		
gen calendar_year=2011

*save 

**************2013**********************
restore, preserve

gen enter_2013= mdy(01, 01, 2013) if birthyear <1963 
format enter_2013 %td

gen person_time_2013=365.25 if birthyear <1963 
replace person_time_2013=registration_date_stata-enter_2013 if registration_status==3 & registration_status_year==2013
replace person_time_2013=registration_date_stata-enter_2013 if registration_status==5 & registration_status_year==2013 
replace person_time_2013=hipfx_date-enter_2013 if admission_year==2013
replace person_time_2013 =. if admission_year<2013														
replace person_time_2013 =. if registration_status_year<2013 & (registration_status==3 | registration_status==5)  
gen person_time_years_2013 = person_time_2013/365.25

gen hipfx_2013=1 if admission_year==2013
replace hipfx_2013=0 if hipfx_2013==.

collapse (sum) hipfx_2013 person_time_years_2013, by (RxRiskScore2012 sex birthyear)
rename RxRiskScore2012 rxriskscore
drop if person_time_years_2013== 0 		
gen calendar_year=2012

*save 

**************2014**********************
restore, preserve

gen enter_2014= mdy(01, 01, 2014) if birthyear <1964 
format enter_2014 %td

gen person_time_2014=365.25 if birthyear <1964 
replace person_time_2014=registration_date_stata-enter_2014 if registration_status==3 & registration_status_year==2014
replace person_time_2014=registration_date_stata-enter_2014 if registration_status==5 & registration_status_year==2014 
replace person_time_2014=hipfx_date-enter_2014 if admission_year==2014
replace person_time_2014 =. if admission_year<2014														
replace person_time_2014 =. if registration_status_year<2014 & (registration_status==3 | registration_status==5)  
gen person_time_years_2014 = person_time_2014/365.25

gen hipfx_2014=1 if admission_year==2014
replace hipfx_2014=0 if hipfx_2014==.

collapse (sum) hipfx_2014 person_time_years_2014, by (RxRiskScore2013 sex birthyear)
rename RxRiskScore2013 rxriskscore
drop if person_time_years_2014== 0 		
gen calendar_year=2013

*save

**************2015*********************
restore, preserve

gen enter_2015= mdy(01, 01, 2015) if birthyear <1965 
format enter_2015 %td

gen person_time_2015=365.25 if birthyear <1965 
replace person_time_2015=registration_date_stata-enter_2015 if registration_status==3 & registration_status_year==2015
replace person_time_2015=registration_date_stata-enter_2015 if registration_status==5 & registration_status_year==2015 
replace person_time_2015=hipfx_date-enter_2015 if admission_year==2015
replace person_time_2015 =. if admission_year<2015														
replace person_time_2015 =. if registration_status_year<2015 & (registration_status==3 | registration_status==5)  
gen person_time_years_2015 = person_time_2015/365.25

gen hipfx_2015=1 if admission_year==2015
replace hipfx_2015=0 if hipfx_2015==.

collapse (sum) hipfx_2015 person_time_years_2015, by (RxRiskScore2014 sex birthyear)
rename RxRiskScore2014 rxriskscore
drop if person_time_years_2015== 0 		
gen calendar_year=2014

*save 

**************2016*********************
restore, preserve

gen enter_2016= mdy(01, 01, 2016) if birthyear <1966
format enter_2016 %td

gen person_time_2016=365.25 if birthyear <1966
replace person_time_2016=registration_date_stata-enter_2016 if registration_status==3 & registration_status_year==2016
replace person_time_2016=registration_date_stata-enter_2016 if registration_status==5 & registration_status_year==2016
replace person_time_2016=hipfx_date-enter_2016 if admission_year==2016
replace person_time_2016 =. if admission_year<2016														
replace person_time_2016 =. if registration_status_year<2016 & (registration_status==3 | registration_status==5)  
gen person_time_years_2016 = person_time_2016/365.25

gen hipfx_2016=1 if admission_year==2016
replace hipfx_2016=0 if hipfx_2016==.

collapse (sum) hipfx_2016 person_time_years_2016, by (RxRiskScore2015 sex birthyear)
rename RxRiskScore2015 rxriskscore
drop if person_time_years_2016== 0 		
gen calendar_year=2015

*save

**************2017*********************
restore, preserve

gen enter_2017= mdy(01, 01, 2017) if birthyear <1967 
format enter_2017 %td

gen person_time_2017=365.25 if birthyear <1967 
replace person_time_2017=registration_date_stata-enter_2017 if registration_status==3 & registration_status_year==2017
replace person_time_2017=registration_date_stata-enter_2017 if registration_status==5 & registration_status_year==2017
replace person_time_2017=hipfx_date-enter_2017 if admission_year==2017
replace person_time_2017 =. if admission_year<2017														
replace person_time_2017 =. if registration_status_year<2017 & (registration_status==3 | registration_status==5)  
gen person_time_years_2017 = person_time_2017/365.25

gen hipfx_2017=1 if admission_year==2017
replace hipfx_2017=0 if hipfx_2017==.

collapse (sum) hipfx_2017 person_time_years_2017, by (RxRiskScore2016 sex birthyear)
rename RxRiskScore2016 rxriskscore
drop if person_time_years_2017== 0 		
gen calendar_year=2016

*save 
**************merge files with hip fractures and person time for each calendar year****************************************************************

*merge m:1 rxriskscore sex birthyear calendar_year using "\\file_name.dta"

*Generate variables for total number of hip fractures and person time for the whole time period
egen hipfx_total = rowtotal( hipfx_2006 hipfx_2007 hipfx_2008 hipfx_2009 hipfx_2010 hipfx_2011 hipfx_2012 hipfx_2013 hipfx_2014 hipfx_2015 hipfx_2016 hipfx_2017)
egen person_time_total = rowtotal(person_time_years_2006 person_time_years_2007 person_time_years_2008 person_time_years_2009 person_time_years_2010 person_time_years_2011 person_time_years_2012 person_time_years_2013 person_time_years_2014 person_time_years_2015 person_time_years_2016 person_time_years_2017)



