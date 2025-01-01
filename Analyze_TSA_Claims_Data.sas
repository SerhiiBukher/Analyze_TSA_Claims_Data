/* Case Study: Analyze TSA Claims Data */

/* ACCESS DATA */

/* Define the TSA library */

libname tsa "~";

/* 1. Import the TSAClaims2002_2017.csv file */

options validvarname=v7;
proc import datafile='/home/u64056077/ECRB94/data/TSAClaims2002_2017.csv' dbms=csv out=tsa.claims_import replace;
guessingrows=max;
run;

/* EXPLORE DATA */

/* 1. Preview the data. */

proc print data=tsa.claims_import (obs=20);
run;

proc contents data=tsa.claims_import;
run;

/* 2. Explore columns */

proc freq data=tsa.claims_import;
	tables Claim_Site Disposition Claim_Type Date_Received Incident_Date / nopercent nocum;
run;
*- All missing and ‘-‘ values in the columns Claim_Type, Claim_Site, and Disposition must be
changed to 'Unknown'.
*- Entirely duplicated records must be removed from the table
*- Present typing errors in some values in Claim_Type column and in Disposition column 

/* Prepare Data */

/* 1. Remove duplicate rows. */;

proc sort data=tsa.claims_import nodupkey;
	by _all_;
run;

/* 2. Sort the data by ascending Incident Date. */
proc sort data = tsa.claims_import;
	by Incident_Date;
run;

/* 3. Clean the Claim_Site column. */
data tsa.claims_cleaned;
	set tsa.claims_import;
	if Claim_Site in ('', '-') then Claim_Site='Unknown';
/* 4. Clean the Disposition column. */
	if missing(Disposition) or Disposition='-' then Disposition='Unknown';
	else if Disposition = 'Closed: Canceled' then Disposition='Closed:Canceled';
	else if Disposition = 'losed: Contractor Claim' then Disposition='Closed:Contractor Claim';
/* 5. Clean the Claim_Type column. */
	if missing(Claim_Type) or Claim_Type='-' then Claim_Type='Unknown';
	else if index(Claim_Type,'/') then Claim_Type=scan(Claim_Type, 1, '/');
/* 6. Convert all State values to uppercase and all StateName values to proper case. */
	State=upcase(State);
	StateName=propcase(StateName);
/* 7. Create a new column to indicate date issues.	 */
	if (missing(Incident_Date) or missing(Date_Received)) 
	or (Incident_Date<'01jan2002'd or Incident_Date>'31dec2017'd)
	or (Date_Received<'01jan2002'd or Date_Received>'31dec2017'd)
	or Incident_Date>Date_Received
	then Date_Issues='Needs Review';
/* 8. Add permanent labels and formats	 */
	format Incident_Date Date_Received date9.;
	label Airport_Code	=	'Airport Code'
	  Airport_Name 	= 	'Airport Name'
	  Claim_Number 	= 	'Claim Number'
	  Claim_Site 	= 	'Claim Site'
	  Claim_Type 	= 	'Claim Type'
	  Close_Amount 	= 	'Close Amount'
	  Date_Issues 	= 	'Date Issues'
	  Date_Recevied = 	'Date Received'
	  Incident_Date = 	'Incident Date'
	  Item_Category = 	'Item Category';
/* 9. Exclude County and City from the output table. */
		 drop County City;
run;

/* Check cleaned data */

proc freq data=tsa.claims_cleaned;
	tables Claim_Site Disposition Claim_Type Date_Issues / nocum nopercent;
run;

/* Analyze & Export Data */

ODS PDF file='~/TSA_Claims.pdf' style=meadow pdftoc=1;
ODS noproctitle;

/* 1. How many date issues are in the overall data? */

ODS proclabel 'Date Issues';
title 'Overall Date Issues';
proc freq data=tsa.claims_cleaned;
	tables Date_Issues / nopercent nocum missing;
run;

/* 2. How many claims per year of Incident_Date are in the overall data? Be sure to include a plot. */

ODS proclabel 'Overall Claims by Year';
title 'Overall Claims by Year';
proc freq data=tsa.claims_cleaned;
	tables Incident_Date / nopercent nocum plots=freqplot;
	format Incident_Date year4.;
	where Date_Issues='';
run;

/* 3. Lastly, a user should be able to dynamically input a specific state value and answer the following:
a. What are the frequency values for Claim_Type for the selected state?
b. What are the frequency values for Claim_Site for the selected state?
c. What are the frequency values for Disposition for the selected state?
d. What is the mean, minimum, maximum, and sum of Close_Amount for the selected state?
The statistics should be rounded to the nearest integer. */

%let Selected_State = Pennsylvania;

ODS proclabel "&Selected_State Claims";
title "&Selected_State : Claim Type, Claim Site, Disposition";
proc freq data=tsa.claims_cleaned;
	tables Claim_Type Claim_Site Disposition / nopercent nocum;
	where Date_Issues='' and StateName="&Selected_State";
run;

ODS proclabel "Close_Amount for the selected state";
title "Close_Amount for the &Selected_State";
proc means data=tsa.claims_cleaned mean min max sum maxdec=0;
	var Close_Amount;
	where Date_Issues='' and StateName="&Selected_State";
run;

ODS PDF close;

/* ---------------------------------------- */
