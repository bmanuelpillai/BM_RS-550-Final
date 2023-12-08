libname d 'C:\Users\Bevin\Desktop\Final';
proc print data=d.fham;
RUN;


/*Part A Table 1*/
/*Sample Size*/
proc freq data=d.fham;
	where PERIOD = 1;
	tables hyperten;
run;
/*Distribution of Sex variable*/
proc freq data=d.fham;
	where PERIOD = 1;
	tables SEX;
run;
/*BMI*/
proc univariate data = d.fham;
where PERIOD = 1;
var BMI;
run;
/*AGE*/
proc univariate data = d.fham;
where PERIOD = 1;
var AGE;
run;
/*Education*/
/*Distribution of Attained Education variable*/
proc freq data=d.fham;
	where PERIOD = 1;
	tables EDUC;
run;
/*Smoking Status*/
/*Distribution of Smoking Status variable*/
proc freq data=d.fham;
	where PERIOD = 1;
	tables CURSMOKE;
run;

/*With Hypertension Rates*/
/*Distribution of Sex variable*/
proc freq data=d.fham;
	where PERIOD = 1;
	where hyperten = 1;
	tables SEX;
run;
/*BMI*/
proc univariate data = d.fham;
where PERIOD = 1;
where hyperten = 1;
var BMI;
run;
/*AGE*/
proc univariate data = d.fham;
where PERIOD = 1;
where hyperten = 1;
var AGE;
run;
/*Education*/
proc freq data=d.fham;
	where PERIOD = 1;
	where hyperten = 1;
	tables EDUC;
run;
/*Smoking Status*/
/*Distribution of Smoking Status variable*/
proc freq data=d.fham;
	where PERIOD = 1;
	where hyperten = 1;
	tables CURSMOKE;
run;

/*Without Hypertension Rates*/
/*Distribution of Sex variable*/
proc freq data=d.fham;
	where PERIOD = 1;
	where hyperten = 0;
	tables SEX;
run;
/*BMI*/
proc univariate data = d.fham;
where PERIOD = 1;
where hyperten = 0;
var BMI;
run;
/*AGE*/
proc univariate data = d.fham;
where PERIOD = 1;
where hyperten = 0;
var AGE;
run;
/*Education*/
proc freq data=d.fham;
	where PERIOD = 1;
	where hyperten = 0;
	tables EDUC;
run;
/*Smoking Status*/
/*Distribution of Smoking Status variable*/
proc freq data=d.fham;
	where PERIOD = 1;
	where hyperten = 0;
	tables CURSMOKE;
run;


/*Part B*/
/*Kaplan-Meier curve*/
/*Log-Rank Test for Two Groups*/
proc lifetest data=d.fham;
	time TIMEDTH*DEATH(0);
	strata PREVHYP;
	id RANDID;
run;


/*Part C*/
/*Variable 1 (Age at Baseline)*/
/*Graphically*/
/*Creating 2 Groups for Continuous Variable of Age*/
proc means data=d.fham median;
	var AGE_BL;
run;
/*Median is 49*/
data d.fham2;
	set d.fham;
	if AGE_BL <= 49 then AGE_BL_GROUP = 0;
	else AGE_BL_GROUP = 1;
run;
proc lifetest data= d.fham2 method = km plots = lls;
	time TIMEDTH*DEATH(0);
	strata AGE_BL_GROUP;
run;

/*Creating 3 Groups for Continuous Variable of Age*/
proc univariate data=d.fham;
	var AGE_BL;
	output out=quartile_data 
	pctlpts = 33 66
	pctlpre=Q_;
run;
/*Q1 = 42  Q3 = 56*/
data d.fham3;
	set d.fham;
	if AGE_BL <= 42 then AGE_BL_GROUP = 0;
	else if 42 < AGE_BL <= 56 then AGE_BL_GROUP = 1;
	else AGE_BL_GROUP = 2;
run;
proc lifetest data= d.fham3 method = km plots = lls;
	time TIMEDTH*DEATH(0);
	strata AGE_BL_GROUP;
run;

/*Goodness-of-fit-tests*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = AGE_BL;
	assess ph / resample seed = 550;
run;
/*Time-Dependent covariates*/
/*g(t) = t*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = AGE_BL AGE_BL_t;
	AGE_BL_t = AGE_BL*TIMEDTH;
run;

/*g(t) = ln(t)*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = AGE_BL AGE_BL_lnt;
	AGE_BL_lnt = AGE_BL*log(TIMEDTH);
run;

/*Variable 2 (Education)*/
/*Graphically*/
proc lifetest data= d.fham method = km plots = lls;
	time TIMEDTH*DEATH(0);
	strata EDUC;
run;

/*Goodness-of-fit-tests*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = EDUC;
	assess ph / resample seed = 550;
run;
/*Time-Dependent covariates*/
/*g(t) = t*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = EDUC EDUC_t;
	EDUC_t = EDUC*TIMEDTH;
run;

/*g(t) = ln(t)*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = EDUC EDUC_lnt;
	EDUC_lnt = EDUC*log(TIMEDTH);
run;

/*Variable 3 (Prevalent Hypertension at Baseline)*/
/*Graphically*/
proc lifetest data= d.fham method = km plots = lls;
	time TIMEDTH*DEATH(0);
	strata HYPERTEN_BL;
run;

/*Goodness-of-fit-tests*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = HYPERTEN_BL;
	assess ph / resample seed = 550;
run;
/*Time-Dependent covariates*/
/*g(t) = t*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = HYPERTEN_BL HYPERTEN_BL_t;
	HYPERTEN_BL_t = HYPERTEN_BL*TIMEDTH;
run;

/*g(t) = ln(t)*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = HYPERTEN_BL HYPERTEN_BL_lnt;
	HYPERTEN_BL_lnt = HYPERTEN_BL*log(TIMEDTH);
run;

/*Variable 4 (Sex)*/
/*Graphically*/
proc lifetest data= d.fham method = km plots = lls;
	time TIMEDTH*DEATH(0);
	strata SEX;
run;

/*Goodness-of-fit-tests*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = SEX;
	assess ph / resample seed = 550;
run;
/*Time-Dependent covariates*/
/*g(t) = t*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = SEX SEX_t;
	SEX_t = SEX*TIMEDTH;
run;

/*g(t) = ln(t)*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = SEX SEX_lnt;
	SEX_lnt = SEX*log(TIMEDTH);
run;


/*Part D*/
proc phreg data = d.fham covs(aggregate) covm;
	model TIMEDTH*DEATH(0) = AGE_BL BMI CURSMOKE HYPERTEN_BL_gt1 HYPERTEN_BL_gt2 HYPERTEN_BL_gt3 HYPERTEN_BL_gt4;
	id RANDID;
	gt1 = 0;
	gt2 = 0;
	gt3 = 0;
	gt4 = 0;
	if TIMEDTH ge 0 and TIMEDTH lt 2000 then gt1 = 1;
	if TIMEDTH ge 2000 and TIMEDTH lt 4000 then gt2 = 1;
	if TIMEDTH ge 4000 and TIMEDTH lt 6000 then gt3 = 1;
	if TIMEDTH ge 6000 then gt4 = 1;
	HYPERTEN_BL_gt1 = HYPERTEN*gt1;
	HYPERTEN_BL_gt2 = HYPERTEN*gt2;
	HYPERTEN_BL_gt3 = HYPERTEN*gt3;
	HYPERTEN_BL_gt4 = HYPERTEN*gt4;
	contrast 'HR - GT1' HYPERTEN_BL_gt1 1 / estimate = exp;
	contrast 'HR - GT2' HYPERTEN_BL_gt2 1 / estimate = exp;
	contrast 'HR - GT3' HYPERTEN_BL_gt3 1 / estimate = exp;
	contrast 'HR - GT4' HYPERTEN_BL_gt4 1 / estimate = exp;
run;


/*Part E*/
/*Question 1*/
proc logistic data = d.fham;
	where PERIOD = 1;
	model DEATH (event = '1') = HYPERTEN BMI AGE SEX EDUC CURSMOKE;
run;

/*Question 2*/
/* Run the Poisson Regression Model */
proc genmod data=d.fham;
    where PERIOD = 1;
	class randid;
    model DEATH = HYPERTEN BMI AGE SEX EDUC CURSMOKE / dist=poisson link=log;
    repeated subject=randid / type=unstr; 
	estimate 'HYPERTEN v. DEATH' Hyperten 1;
run;


/*Part F*/
/*Recode BMI */
data d.fham;
	set d.fham;
	BMI_OW = 0;
	BMI_OB = 0;
	if missing(BMI) then BMI_OW = .;
	if missing(BMI) then BMI_OB = .;
	if 25 <= BMI < 30 then BMI_OW = 1;
	if BMI >= 30 then BMI_OB = 1;
run;

proc print data = d.fham;
	var bmi bmi_ow bmi_ob;
run;

/*Hazard Ratios*/
proc univariate data = d.fham;
	var SEX;
run;

/* Overweight*/
proc phreg data =d.fham;
	model TIMECHD*PREVCHD(1) = BMI_OW SEX BMI_OW*SEX/RL;
	contrast 'males' BMI_OW 1 BMI_OW*SEX 1 / estimate = exp;
	contrast 'females' BMI_OW 1 BMI_OW*SEX 2 / estimate = exp;
run;

/*Obesity*/
proc phreg data =d.fham;
	model TIMECHD*PREVCHD(1) = BMI_OB SEX BMI_OB*SEX/RL;
	contrast 'males' BMI_OB 1 BMI_OB*SEX 1 / estimate = exp;
	contrast 'females' BMI_OB 1 BMI_OB*SEX 2 / estimate = exp;
run;

/*Q2*/
/* LRT Test */
data d.fham_CHD;
	set d.fham;
	where PREVCHD = 0;
run;

/*Full model*/
proc logistic data = d.fham;
	model PREVCHD (event = '1') = BMI_OW BMI_OB CURSMOKE SEX BMI_OW*SEX BMI_OB*SEX CURSMOKE*SEX;
run;
/*Reduced model*/
proc logisitic data = d.fham;
	model PREVCHD (event = '1') = BMI_OW BMI_OB CURSMOKE SEX;
run;
/*p-value calculation*/
data one;
	p = 1 - probchi(26.387, 3);
run;
proc print data = one;
run;

/*Q3*/
/*Full model*/
proc logistic data = d.fham;
	model PREVCHD (event = '1') = BMI_OW BMI_OB CURSMOKE SEX BMI_OW*CURSMOKE BMI_OB*CURSMOKE CURSMOKE*SEX;
run;
/*Reduced model*/
proc logisitic data = d.fham;
	model PREVCHD (event = '1') = BMI_OW BMI_OB CURSMOKE SEX;
run;
/*p-value calculation*/
data two;
	p = 1 - probchi(6.2, 3);
run;
proc print data = two;
run;
