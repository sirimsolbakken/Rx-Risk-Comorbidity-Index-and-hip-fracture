
# R code to calculate the Rx-Risk Comorbidity Index based on individual-level data from the Norwegian Prescription Database

# When using this code, please cite reference: Holvik K et al., BMJ Open 2022;12(5):e057823. doi: 10.1136/bmjopen-2021-057823. 


#######################################################################################################################


# SUMMARY OF APPROACH:

# STEP 1: Map ATC codes of filled prescriptions in a calendar year to 46 different comorbidity categories
# STEP 2: Run a logistic regression model with death in the subsequent year as outcome, with each category as indicator (0/1), age and sex.		 
# STEP 3: Calculate individual weighted Rx-Risk score for the calendar year by summing each individual's assigned severity weights based on the output obtained in step 2. 



##################################################################################

# STEP 1

# Selected prescriptions filled within a defined calendar year (index year) are defined into 46 categories based on their ATC code.
# Below, rr refers to the national dataset of prescriptions filled in the index year within a defined age range.
# The dataset needs to be prepared considering any restrictions related to the aim of the study 
# (e.g., age range 65+ years, conditioned on being alive by the end of the index year)
# The dataset needs to be structured in long format with each prescription fill recorded in a separate row, 
# and contain an id column to indicate the individual patient. 
# The script is based on detailed information about chemical substance dispensed; ATC codes available on the 5th level.

################################################################################




###################	CATEGORY 1: ALCOHOL DEPENDENCY		###################

rr$category <- 0
rr$category[which(substr(rr$ATCcode, 1, 5)== "N07BB") ] <- 1



###################	CATEGORY 2: ALLERGIES		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "R01AC") ] <- 2
rr$category[which(substr(rr$ATCcode, 1, 5)== "R01AD") ] <- 2
rr$category[which(substr(rr$ATCcode, 1, 7)== "R06AD02") ] <- 2
rr$category[which(substr(rr$ATCcode, 1, 7)== "R06AD03") ] <- 2
rr$category[which(substr(rr$ATCcode, 1, 5)== "R06AE") ] <- 2
rr$category[which(substr(rr$ATCcode, 1, 5)== "R06AX") ] <- 2
rr$category[which(substr(rr$ATCcode, 1, 5)== "R06AB") ] <- 2




###################	CATEGORY 3: ANTICOAGULANTS		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "B01AA") ] <- 3
rr$category[which(substr(rr$ATCcode, 1, 5)== "B01AB") ] <- 3
rr$category[which(substr(rr$ATCcode, 1, 7)== "B01AE07") ] <- 3
rr$category[which(substr(rr$ATCcode, 1, 5)== "B01AF") ] <- 3
rr$category[which(substr(rr$ATCcode, 1, 5)== "B01AX") ] <- 3


###################	CATEGORY 4: ANTIPLATELETS		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "B01AC") ] <- 4



###################	CATEGORY 5: ANXIETY		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "N05BA") ] <- 5
rr$category[which(substr(rr$ATCcode, 1, 5)== "N05BE") ] <- 5




###################	CATEGORY 6: ARRYTHMIA		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "C01AA") ] <- 6
rr$category[which(substr(rr$ATCcode, 1, 4)== "C01B") ] <- 6
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AA07") ] <- 6	# Note; other beta-blockers except C07AA07 sotalol are coded in category 28.




###################	CATEGORY 7: BENIGN PROSTATIC HYPERPLASIA		###################


# Note: needs conditioning on male sex since women suffering from bladder obstructions can be prescribed drugs within this category.

rr$category[which((substr(rr$ATCcode, 1, 4)== "G04C") & rr$PatientSex==1) ] <- 7		



###################	CATEGORY 8: BIPOLAR DISORDER 	###################


rr$category[which(substr(rr$ATCcode, 1, 7)== "N05AN01") ] <- 8



###################	CATEGORY 9: CHRONIC AIRWAYS DISEASE		###################


rr$category[which(substr(rr$ATCcode, 1, 3)== "R03") ] <- 9




###################	CATEGORY 10: CONGESTIVE HEART FAILURE		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "C03DA") ] <- 10
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AB07") ] <- 10
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AB12") ] <- 10
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AG02") ] <- 10




###################	CATEGORY 11: DEMENTIA		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "N06DA") ] <- 11
rr$category[which(substr(rr$ATCcode, 1, 7)== "N06DX01") ] <- 11



###################	CATEGORY 12: DEPRESSION		###################


rr$category[which(substr(rr$ATCcode, 1, 4)== "N06A") ] <- 12




###################	CATEGORY 13: DIABETES		###################


rr$category[which(substr(rr$ATCcode, 1, 3)== "A10") ] <- 13



###################	CATEGORY 14: EPILEPSY		###################


rr$category[which(substr(rr$ATCcode, 1, 4)== "N03A") ] <- 14





###################	CATEGORY 15: GLAUCOMA		###################


rr$category[which(substr(rr$ATCcode, 1, 4)== "S01E") ] <- 15



###################	CATEGORY 16: GASTROOESOPHAGEAL REFLUX DISEASE  		###################



rr$category[which(substr(rr$ATCcode, 1, 4)== "A02B") ] <- 16



###################	CATEGORY 17: GOUT		###################



rr$category[which(substr(rr$ATCcode, 1, 3)== "M04") ] <- 17




###################	CATEGORY 18: HEPATITIS B		###################


rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF08") ] <- 18
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF10") ] <- 18
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF11") ] <- 18



###################	CATEGORY 19: HEPATITIS C		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "J05AP") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "L03AB10") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "L03AB11") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AB54") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "L03AB60") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "L03AB61") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AE14") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AE11") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AE12") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AX14") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AX15") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AX65") ] <- 19
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AB04") ] <- 19





###################	CATEGORY 20: HIV		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "J05AE") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF12") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF13") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 5)== "J05AG") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 5)== "J05AR") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AX07") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AX08") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AX09") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AX12") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF01") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF02") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF03") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF04") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF05") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF06") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF07") ] <- 20
rr$category[which(substr(rr$ATCcode, 1, 7)== "J05AF09") ] <- 20




###################	CATEGORY 21: HYPERKALAEMIA		###################


rr$category[which(substr(rr$ATCcode, 1, 7)== "V03AE01") ] <- 21


###################	CATEGORY 22: HYPERLIPIDAEMIA		###################


# Note: ATC A10BH03 (combination product for diabetes and hypertension) is not included in this category but included in category 13 diabetes


rr$category[which(substr(rr$ATCcode, 1, 3)== "C10") ] <- 22



###################	CATEGORY 23: HYPERTENSION		###################


# See also category 28: ischaemic heart disease: hypertension.

# Drugs in groups such as diuretics (C03), beta blockers (C07), calcium channel blockers (C08) and ACE inhibitors/ARB (angiotensin II renin blockers) (C09)
# are used to treat different diseases, most commonly hypertension, angina, oedema and heart failure.


rr$category[which(substr(rr$ATCcode, 1, 4)== "C03A") ] <- 23		# Low-ceiling, diuretichs, thiazides 
rr$category[which(substr(rr$ATCcode, 1, 4)== "C03B") ] <- 23		# Low-ceiling, diuretichs, excl. thiazides 
rr$category[which(substr(rr$ATCcode, 1, 5)== "C03DB") ] <- 23		# Other potassium-sparing agents
rr$category[which(substr(rr$ATCcode, 1, 5)== "C03EA") ] <- 23		# Low-ceiling diuretics and potassium-sparing agents
rr$category[which(substr(rr$ATCcode, 1, 5)== "C09BA") ] <- 23		# ACE inhibitors and diuretics
rr$category[which(substr(rr$ATCcode, 1, 5)== "C09DA") ] <- 23		# Angiotensin II antagonists and diuretics
rr$category[which(substr(rr$ATCcode, 1, 4)== "C02A") ] <- 23		# Antiadrenergic agents, centrally acting
rr$category[which(substr(rr$ATCcode, 1, 5)== "C02DB") ] <- 23		# Hydrazinophthalazine derivatives (agents acting on arteriolar smooth muscle)
rr$category[which(substr(rr$ATCcode, 1, 4)== "C03C") ] <- 23		# High-ceiling diuretics, thiazides
rr$category[which(substr(rr$ATCcode, 1, 4)== "C09C") ] <- 23		# Angiotensin II antagonists, plain

rr$category[which(substr(rr$ATCcode, 1, 4)== "C09A") ] <- 23	 	# C09A: ACE inhibitors, plain. Note: Added later (after BMJ Open 2022 publication).



###################	CATEGORY 24: HYPERTHYROIDISM		###################


rr$category[which(substr(rr$ATCcode, 1, 4)== "H03B") ] <- 24



###################	CATEGORY 25: HYPOTHYROIDISM		###################


rr$category[which(substr(rr$ATCcode, 1, 4)== "H03A") ] <- 25


###################	CATEGORY 26: IRRITABLE BOWEL SYNDROME		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "A07EC") ] <- 26
rr$category[which(substr(rr$ATCcode, 1, 5)== "A07EA") ] <- 26
rr$category[which(substr(rr$ATCcode, 1, 7)== "L04AA33") ] <- 26



###################	CATEGORY 27: ISCHAEMIC HEART DISEASE: ANGINA		###################

rr$category[which(substr(rr$ATCcode, 1, 4)== "C01D") ] <- 27
rr$category[which(substr(rr$ATCcode, 1, 7)== "C08EX02") ] <- 27



###################	CATEGORY 28: ISCHAEMIC HEART DISEASE: HYPERTENSION		###################


# note: C07AA07 sotalol is included in category 6 arrythmia, and not in the current category (in accordance with Pratt et al., BMJ Open 2018).

rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AA03") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AA05") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AA06") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AA12") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AB02") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AG01") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 3)== "C08") ] 	<- 28
rr$category[which(substr(rr$ATCcode, 1, 5)== "C09DB") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 7)== "C09DX01") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 5)== "C09BB") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 7)== "C07AB03") ] <- 28
rr$category[which(substr(rr$ATCcode, 1, 7)== "C09DX03") ] <- 28



###################	CATEGORY 29: INCONTINENCE		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "G04BD") ] <- 29


###################	CATEGORY 30: INFLAMMATION/PAIN		###################



rr$category[which(substr(rr$ATCcode, 1, 4)== "M01A") ] <- 30



###################	CATEGORY 31: LIVER FAILURE		###################


rr$category[which(substr(rr$ATCcode, 1, 7)== "A06AD11") ] <- 31
rr$category[which(substr(rr$ATCcode, 1, 7)== "A07AA11") ] <- 31



###################	CATEGORY 32: MALIGNANCIES		###################


# Note: these drugs (L01: Antineoplastic agents) are mainly used in hospitals and therefore the numbers in outpatient registry data may be low. 

rr$category[which(substr(rr$ATCcode, 1, 3)== "L01") ] <- 32



###################	CATEGORY 33: MALNUTRITION		###################


# Note: these drugs (B05: Blood substitutes and perfusion solutions) are mainly used in hospitals and therefore the numbers in outpatient registry data may be low. 

rr$category[which(substr(rr$ATCcode, 1, 5)== "B05BA") ] <- 33


###################	CATEGORY 34: MIGRAINE		###################


rr$category[which(substr(rr$ATCcode, 1, 4)== "N02C") ] <- 34


###################	CATEGORY 35: OSTEOPOROSIS/PAGET'S	###################


rr$category[which(substr(rr$ATCcode, 1, 3)== "M05") ] <- 35		
rr$category[which(substr(rr$ATCcode, 1, 7)== "G03XC01") ] <- 35		  
rr$category[which(substr(rr$ATCcode, 1, 7)== "H05AA02") ] <- 35		   
rr$category[which(substr(rr$ATCcode, 1, 7)== "H05BA01") ] <- 35		   



###################	CATEGORY 36: PAIN		###################

rr$category[which(substr(rr$ATCcode, 1, 4)== "N02A") ] <- 36	
rr$category[which(substr(rr$ATCcode, 1, 5)== "N02BE") ] <- 36


###################	CATEGORY 37: PANCREATIC INSUFFICIENCY		###################

rr$category[which(substr(rr$ATCcode, 1, 7)== "A09AA02") ] <- 37	



###################	CATEGORY 38: PARKINSON'S DISEASE		###################


rr$category[which(substr(rr$ATCcode, 1, 4)== "N04A") ] <- 38	
rr$category[which(substr(rr$ATCcode, 1, 4)== "N04B") ] <- 38	


###################	CATEGORY 39: PSORIASIS		###################


rr$category[which(substr(rr$ATCcode, 1, 3)== "D05") ] <- 39	


###################	CATEGORY 40: PSYCHOTIC ILLNESS		###################


# N05A* except N05AN01 lithium which denotes category 8 bipolar disorder

rr$category[which(substr(rr$ATCcode, 1, 4)== "N05A") ] <- 40	

rr$category[which(substr(rr$ATCcode, 1, 7)== "N05AN01") ] <- 8		# (overwrites previous line)



###################	CATEGORY 41: PULMONARY HYPERTENSION		###################

rr$category[which(substr(rr$ATCcode, 1, 5)== "C02KX") ] <- 41	



###################	CATEGORY 42: RENAL DISEASE		###################


rr$category[which(substr(rr$ATCcode, 1, 4)== "B03X") ] <- 42		# Other antianemic preparations	
rr$category[which(substr(rr$ATCcode, 1, 7)== "A11CC03") ] <- 42		# Vitamin D analogues: alfacalcidiol	
rr$category[which(substr(rr$ATCcode, 1, 7)== "A11CC04") ] <- 42		# Vitamin D analogues: calcitriol
rr$category[which(substr(rr$ATCcode, 1, 5)== "V03AE") ] <- 42		# Drugs for treatment of hyperkalemia and hyperphosphatemia

rr$category[which(substr(rr$ATCcode, 1, 7)== "V03AE01") ] <- 21		# with the exception of V03AE01 polystyrene sulfonate which is defined as category 21: hyperkalemia (overwrites previous line)



###################	CATEGORY 43: SMOKING CESSATION		###################


rr$category[which(substr(rr$ATCcode, 1, 5)== "N07BA") ] <- 43	# drugs used in nicotine dependence (includes nicotine and varenicline)



###################	CATEGORY 44: STEROID-RESPONSIVE DISEASE		###################


rr$category[which(substr(rr$ATCcode, 1, 3)== "H02") ] <- 44		# corticosteroids for systemic use (both plain and combinations)


###################	CATEGORY 45: TRANSPLANT		###################


rr$category[which(substr(rr$ATCcode, 1, 7)== "L04AA06") ] <- 45	# Selective immunosuppressants: mycophenolic acid
rr$category[which(substr(rr$ATCcode, 1, 7)== "L04AA10") ] <- 45	# Selective immunosuppressants: sirolimus
rr$category[which(substr(rr$ATCcode, 1, 7)== "L04AA18") ] <- 45	# Selective immunosuppressants: everolimus
rr$category[which(substr(rr$ATCcode, 1, 7)== "L04AD01") ] <- 45	# Calcineurin inhibitors: ciclosporin
rr$category[which(substr(rr$ATCcode, 1, 7)== "L04AD02") ] <- 45	# Calcineurin inhibitors: tacrolimus


###################	CATEGORY 46: TUBERCULOSIS		###################



rr$category[which(substr(rr$ATCcode, 1, 4)== "J04A") ] <- 46


########################################################################




# category0 <- rr[rr$category ==0, ]		
# dim(category0)				# Number of filled prescriptions that did not apply to any of the 46 comorbidity categories
# table(category0$ATCcode)			# ATC codes that did not apply to any of the 46 comorbidity categories



##########################
##    END OF STEP 1	## 
##########################






######################################################################################################################### 

#  STEP 2

#  To obtain the severity weights to assign to each comorbidity category: 									 
#  Run a mutually adjusted logistic regression model with death within the subsequent calendar year as outcome,
#  each category as indicator (0/1) variable, adjusted for age and sex.		 
#  Needs to be run in a wide format data set containing one row for each individual patient.
									 
##########################################################################################################################

# Substeps in step 2:
# a) preparation: transform the dataset into wide format and create indicator variables (dummy variables) from the variable "category" using the function pivot_wider.
# b) run logistic regression.


(.packages())

# library(data.table)
# library(haven)
# library(dplyr)
# library(tidyr)




##########################################################################

# a) transform the dataset to wideformat and create indicator variables.
 
########################################################################## 


a <- rr

names(a)
dim(a)
length(unique(a$id))

a$age <- as.numeric(a$YearDispensedDrug - a$PatientBornYear)

summary(a$age)

# library(tidyr)
# ?pivot_wider		

a <- select(a, -"ATCcode")

a <- as.data.table(a)

names(a)[names(a) == 'category'] <- 'cat'	
summary(a$cat)
catn <- function(...) cat(...,fill=T)
catn("sorting")
setorder(a, cat)		# sort by category before pivoting 

catn("transforming")

wide <- data.frame(pivot_wider(a[!duplicated(a[,.(id,cat)]),.(id, cat), by=.(PatientSex, age)], names_from=cat, values_from=cat))

class(wide)
dim(wide)
names(wide)
head(wide, 50)
tail(wide,50)

summary(wide$age)
table(wide$PatientSex)

# Change values of category columns to 0/1:

catn("change to 0/1")
catcols <- grep("X",names(wide))
for (i in catcols) wide[,i] <- ifelse(is.na(wide[,i]),0,1)

class(wide)
dim(wide)
names(wide)
head(wide)
tail(wide)

# Change names of category columns:

names(wide) <- sub("^X","cat",names(wide))		# substitute X by cat in variable names in data frame wide

names(wide)


# amend cat0 for those who filled prescriptions from other categories: 

catn("amend cat 0")
wide$cat0 <- ifelse(apply(wide[,catcols[-1]],1,sum)>0,0,1)


wide <- data.table(wide)
catn("sorting")
setorder(wide, id)
	

class(wide)			# check results of last round of changes
dim(wide)
length(unique(wide$id))
names(wide)
head(wide,20)
tail(wide,20)



################################################################################################

# b) run logistic regression model with category, age, and sex, as a basis for assigning weights.

################################################################################################


# Merge with deaths the subsequent year from National Population Registry or Cause of death registry
# Here: data.table named regstat with column RegistryStatus==5 implying deceased.

###############################################################

regstat <- readRDS("...")

regstat <- select(regstat, c("id", "RegistryStatus", "RegistryYear"))

a <- merge(wide, regstat, by="id", all.x=TRUE, all.y=FALSE, all=FALSE) 

dim(a)

a <- a[!duplicated(a$id), ]

dim(a)
names(a)

table(a$RegistryStatus)
summary(a$RegistryYear)

table(a$RegistryYear, a$RegistryStatus)

a$dies <- 0
a[a$RegistryStatus==5 & a$RegistryYear <= yyyy, "dies"] <- 1	# input yyyy: the subsequent calendar year after the prescripton year 

table(a$dies)




# Logistic regression model

model <- glm(dies ~ PatientSex + age +cat0 +cat1 +cat2 +cat3 +cat4 +cat5
+cat6 +cat7 +cat8 +cat9 +cat10 +cat11 +cat12  +cat13 +cat14 +cat15 +cat16 +cat17 
+cat18 +cat19 +cat20 +cat21  +cat22 +cat23 +cat24 +cat25 +cat26 +cat27 +cat28 +cat29
+cat30 +cat31 +cat32 +cat33 +cat34 +cat35 +cat36 +cat37 +cat38 +cat39 +cat40 
+cat41 +cat42  +cat43 +cat44  +cat45 +cat46, family=binomial(link="logit"), data = a)

summary(model)						
round((exp(model$coeff)), 2)		# odds ratio
round(summary(model)$coef[,4], 3)	# p values





# Suggestions for quality check
# Examine characteristics of single categories with surprising odds ratios, high p-values, presumed rare and/or presumed harmful diseases

table(a$cat33)								# number of individuals
table(a$dies[a$cat33==1])						# number of deaths
round(prop.table(table(a$dies[a$cat33==1])), 3) *100			# proportion of deaths
mean(a$age[a$cat33==1])							# mean age 
summary(a$age[a$cat33==1])						# age distribution including 25- and 75-percentile
round(prop.table(table(a$PatientSex[a$cat33==1])), 3) *100		# sex distribution 




##########################
###  END OF STEP 2	## 
##########################




######################################################

# STEP 3

# Calculate individual weighted Rx-Risk score for the calendar year
# by manually inserting the weights for each of 46 categories.

# Based on the Rx-Risk algorithm for assigning weights based on the odds ratios and p values, as reported in
# Holvik K et al., BMJ Open 2022;12(5):e057823. doi: 10.1136/bmjopen-2021-057823. 

######################################################


a$score1 <- 0
a$score1[a$cat1==1] <- 3

a$score2 <- 0
a$score2[a$cat2==1] <- -1

a$score3 <- 0
a$score3[a$cat3==1] <- 3

a$score4 <- 0
a$score4[a$cat4==1] <- 1

a$score5 <- 0
a$score5[a$cat5==1] <- 3

a$score6 <- 0
a$score6[a$cat6==1] <- 1

a$score7 <- 0
a$score7[a$cat7==1] <- -1

a$score8 <- 0
a$score8[a$cat8==1] <- -1

a$score9 <- 0
a$score9[a$cat9==1] <- 2

a$score10 <- 0
a$score10[a$cat10==1] <- 4 

a$score11 <- 0
a$score11[a$cat11==1] <- 5

a$score12 <- 0
a$score12[a$cat12==1] <- 1

a$score13 <- 0
a$score13[a$cat13==1] <- 2

a$score14 <- 0
a$score14[a$cat14==1] <- 4

a$score15 <- 0
a$score15[a$cat15==1] <- -1

a$score16 <- 0
a$score16[a$cat16==1] <- 2

a$score17 <- 0
a$score17[a$cat17==1] <- 0

a$score18 <- 0
a$score18[a$cat18==1] <- 0	

a$score19 <- 0
a$score19[a$cat19==1] <- 6 	

a$score20 <- 0
a$score20[a$cat20==1] <- 6

a$score21 <- 0
a$score21[a$cat21==1] <- 4

a$score22 <- 0
a$score22[a$cat22==1] <- -1

a$score23 <- 0
a$score23[a$cat23==1] <- 1

a$score24 <- 0
a$score24[a$cat24==1] <- 2

a$score25 <- 0
a$score25[a$cat25==1] <- -1

a$score26 <- 0
a$score26[a$cat26==1] <- -1

a$score27 <- 0
a$score27[a$cat27==1] <- 1

a$score28 <- 0
a$score28[a$cat28==1] <- -1

a$score29 <- 0
a$score29[a$cat29==1] <- -1 	

a$score30 <- 0
a$score30[a$cat30==1] <- -1

a$score31 <- 0
a$score31[a$cat31==1] <- 6

a$score32 <- 0
a$score32[a$cat32==1] <- 6

a$score33 <- 0
a$score33[a$cat33==1] <- 6

a$score34 <- 0
a$score34[a$cat34==1] <- -1

a$score35 <- 0
a$score35[a$cat35==1] <- -1 	

a$score36 <- 0
a$score36[a$cat36==1] <- 4

a$score37 <- 0
a$score37[a$cat37==1] <- 6

a$score38 <- 0
a$score38[a$cat38==1] <- 2

a$score39 <- 0
a$score39[a$cat39==1] <- -1

a$score40 <- 0
a$score40[a$cat40==1] <- 6

a$score41 <- 0
a$score41[a$cat41==1] <- 6

a$score42 <- 0
a$score42[a$cat42==1] <- 6

a$score43 <- 0
a$score43[a$cat43==1] <- 2

a$score44 <- 0
a$score44[a$cat44==1] <- 6

a$score45 <- 0
a$score45[a$cat45==1] <- 2

a$score46 <- 0
a$score46[a$cat46==1] <- 0




# Summing up the scores, arriving at the final score.

a$totalweightedscore <- (a$score1
+ a$score2
+ a$score3
+ a$score4
+ a$score5
+ a$score6
+ a$score7
+ a$score8
+ a$score9
+ a$score10
+ a$score11
+ a$score12
+ a$score13
+ a$score14
+ a$score15
+ a$score16
+ a$score17
+ a$score18
+ a$score19
+ a$score20
+ a$score21
+ a$score22
+ a$score23
+ a$score24
+ a$score25
+ a$score26
+ a$score27
+ a$score28
+ a$score29
+ a$score30
+ a$score31
+ a$score32
+ a$score33
+ a$score34
+ a$score35
+ a$score36
+ a$score37
+ a$score38
+ a$score39
+ a$score40
+ a$score41
+ a$score42
+ a$score43
+ a$score44
+ a$score45
+ a$score46)




########################
####    END 	     ### 
########################











