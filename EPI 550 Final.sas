libname d 'C:\Users\Bevin\Desktop\Final';
proc print data=d.fham;
RUN;
/*Question 1 Table 1*/
proc univariate data = d.fham;
where PERIOD = 1;
run;
/*Distribution of Sex variable*/
proc freq data=d.fham;
	tables SEX;
run;

/*Distribution of Attained Education variable*/
proc freq data=d.fham;
	tables EDUC;
run;

/*Distribution of Smoking Status variable*/
proc freq data=d.fham;
	tables CURSMOKE;
run;
