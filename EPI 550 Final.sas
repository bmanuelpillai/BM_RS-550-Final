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
/*Graphically*/
proc lifetest data= d.fham method = km plots = lls;
	time TIMEDTH*DEATH(0);
	strata AGE;
run;

/*Goodness-of-fit-tests*/
proc phreg data = d.fham;
	model TIMEDTH*DEATH(0) = AGE;
	assess ph / resample seed = 550;
run;


/*Part E*/
/*Question 1*/
proc logistic data = d.fham;
	where PERIOD = 1;
	model DEATH (event = '1') = HYPERTEN BMI AGE SEX EDUC CURSMOKE;
run;

/*Question 2*/
/* Create offset*/
data d.fham;
	set d.fham;
	ln_n = log(n);
run;

/* Run the Poisson Regression Model */
proc genmod data=d.fham;
    where PERIOD = 1;
	class randid;
    model DEATH = HYPERTEN BMI AGE SEX EDUC CURSMOKE / dist=poisson link=log;
    repeated subject=randid / type=unstr; 
	estimate 'HYPERTEN v. DEATH' Hyperten 1;
run;

/*Part F*/
/* Recode BMI*/
data d.fham;
	set d.fham;
	if missing(BMI) then BMI_category_numeric = .;
	if BMI < 25 then BMI_C = 0;
	else if 25 <= BMI < 30 then BMI_C = 1;
	else BMI_C = 3;
run;
