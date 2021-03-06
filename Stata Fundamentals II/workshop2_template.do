******************************* 
*	Stata Intensive: Workshop 2
*	Fall 2017, D-LAB
*	Jackie Ferguson
********************************

**************************************************
* Day 2

* Outline:
* I. 	CORRELATION AND T-TESTS
* II. 	PLOTTING
* III. 	REGRESSION AND ITS OUTPUT
* IV. 	POST-ESTIMATION
* V. 	PLOTTING REGRESSION RESULTS

**************************************************



/* Step 1: File > Change Working Directory > Navigate to the folder where you 
   have saved the data file nlsw88.dta */
   
/* Step 2: Copy-paste the last command that shows up on result screen.
   My result window shows this:*/   


   
/***
		We paste this command above so that next time we can just run this 
		do-file from the top and it will run smoothly. We will not need to
		use the file menu or copy-paste again. We should be able to run 
		everything from the do-file.
***/


*I.  Open the data file */

use nlsw88.dta , clear // open data file 

/* You can also write: */

use nlsw88 , clear


********************************************************************************
********************************************************************************
***From last Workshop!
********************************************************************************
********************************************************************************


* EXPORTING AND IMPORTING DATA *


* Export data for use with other programs
help export excel

*Export out of Stata in several different formats
*Can also use the drop down menu to populate this code
export delimited using "nlsw88.csv", replace datafmt
export excel using "nlsw88.xlsx", firstrow(variables) replace   


* Import data from excel sheet into stata as nlsw88_clean.xlsx

// Let's first clear the current data in memory
clear all

// import the data file you just exported to excel as nlsw88_clean.xlsx
import excel using "nlsw88.xlsx", first clear


// "first" specifies that the first row in the excel file is a variable name
*What would happen if we didn't select this option?



**Do you notice anything different from our datafile to our xlsx file?
*Was any data lost?
*Does our data look any different?
des



*Compare it to the original data before we exported it to excel
clear all
use "nlsw88.dta", clear



*Set more off for this workshop-
*You can set it off permanently by adding ", perm" to the end
set more off




**************************************************
* I. 	CORRELATION AND T-TESTS
**********************************************

*CORRELATION AND T-TESTS

//How do we use the correlation command in Stata?
//First, let's access the help file for `correlate'
help correlate

//Let's try checking the correlation between age and wage
corr age wage 

//What if we want to look at age wage and tenure
//COMMAND:

*T-TESTS

//Now, let's test whether wages are different by union membership

ttest wage, by(union)

//What if we want to look at whether wages vary by if the person lives in the south?

//Hint: use the south variable
//COMMAND:


*How would you interpret this?


**************************************************
* II. 	PLOTTING
**********************************************
*HISTOGRAM

help histogram //let's take a look at the histogram command

histogram age
histogram age, freq

histogram wage
histogram wage, freq

histogram age, discrete 
histogram wage, discrete


//Let's create a histogram with five bins
//COMMAND:


//What about a histogram with bins of width 2?
//COMMAND:



**All of our histogram options can stack together

*Add a title 
//COMMAND:


*Add a title and labels
//COMMAND:

*Create a difference X-axist Title
//COMMAND:

*************
**Additional options for a Histogram
*************

*We can restrict our population by a conditional statement
histogram wage if married==1, width(.25) title("Wage Histogram only amongst those who are married")
	
	
*We can also create a histogram by a categorical variable
histogram wage, by(married) 


//How would we change this command if we wanted to look at the histograms by industry?
//COMMAND:


*************
*SCATTERPLOT
*************

help scatter //now scatterplots

scatter wage age
 
scatter wage tenure 
scatter wage age, title("Hourly  vs. Age") legend(on)
scatter wage age, title("Hourly  vs. Age") mcolor(blue)

//Let's try using a scheme. 
help scheme

//Make the same scatterplot as above, with a monocolor scheme.
//COMMAND:


//There are other formatting changes we can also make
scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f))

*COMBINE GRAPHS
//We want to make a scatterplot, and add a linear prediction-based line of best fit 	
twoway (scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f))) ///
	(lfit wage age)	

//Alternatively, we can use || instead of () to define plots
scatter wage age, title("Hourly  vs. Age") legend(on) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f)) || ///
	(lfit wage age)


//Let's save the graph
scatter wage age, title("Hourly  vs. Age") legend(on) scheme(s1color) ///
	mcolor(blue) xlabel(34(1)46, format(%2.0f)) ylabel(,format(%2.1f)) || ///
	(lfit wage age) 
	
	
graph save "wageage.gph", replace // save in Stata format (can be re-opened in Stata)
graph export "wageage.png", replace //save in .png format for use

*Remember- you can code all these graphs on one line without the /// 
*I have them broken up into multiple lines for easy display in class 
*Do what is best for you!

*************
**Additional options for a Scatter Plot
*************


*Scatter plot by wage and age- separate graph for each
scatter wage age, by(race)

*Same as previous but includes a graph for total cohort
scatter wage age, by(race, total)

***This is the same syntax as the histogram above!



******************
*More Advanced Plotting Options
******************

**What if we want to put two graphs on the same plot?

**Two histograms in one
twoway (histogram wage if union==1) ///
		(histogram wage if union==0)
		*Hard to differentiate the bars
		
*Lets add some color differences and add a legend
twoway (histogram wage if union==1, color(blue)) ///
	(histogram wage if union==0, legend(order (1 "Union" 2 "Non-Union")))
	
*Lets change the opacity of the bars 
twoway (histogram wage if union==1, percent color(blue) lcolor(black)) ///
	(histogram wage if union==0, fcolor(none) lcolor(black) /// 
	legend(order (1 "Union" 2 "Non-Union")))
	
*Change the y axis to percentage
twoway (histogram wage if union==1, percent color(blue) lcolor(black)) ///
	(histogram wage if union==0, percent fcolor(none) lcolor(black) /// 
	legend(order (1 "Union" 2 "Non-Union")))

*Add a title
twoway (histogram wage if union==1, percent color(blue) lcolor(black)) ///
	(histogram wage if union==0, title("Wage by Union Status") percent fcolor(none) lcolor(black) /// 
	legend(order (1 "Union" 2 "Non-Union")))
	
	

**************************************************
* III. 	REGRESSION AND ITS OUTPUT
**********************************************

*LINEAR REGRESSION

help regress //Let's look at the doccumentation for the regress commend

*Lets regress wage and age
reg wage age

*How about wage, age, union, and married?
//COMMAND:


*Why can't we use married_txt?
reg wage age union married_txt

*So far all of our variables have been continous or binary
*What happens when we do a categorical variable?

*What does this output mean?
reg wage age union married industry // Not right

*This treats each industry number as its own category instead of assuming a linear
*relationship between each of them
**How do we fix this?
//COMMAND:


//What if we only want to run this regression for certain industries?
//COMMAND:


*Note number of observations in these regressions
*Do all of them match?


*Why not?


******************
*Interaction Terms
******************


// Let's add an interaction term for being married and education

*Basic regression
reg wage age union married collgrad

gen marriedXcollgrad= married*collgrad


//Run the same basic specification as before, with the robust indicator
//Include the interaction term and other relevant variables
reg wage age married collgrad union marriedXcollgrad

reg wage age union married#collgrad




*LOGIT REGRESSIONS
//Logits are used for binary dependent variables
//For a logit regression, we interpret the coefficients as the log odds

*Lets predict union status
logit union wage age married

//The coefficient on wage tells us that, holding age and married at a fixed value,
//a one-unit increase in wage leads to a certain increase in the log odds of being a union worker

*What the heck are log odds?
disp exp(.076859 )

//or use the or option
logit union wage age married, or

*Or use the logistic command
logistic union wage age married
//specifically, we see approximately a 7% increase in the odds of being a union worker


*What is the difference
help logistic
help logit



******************************************
* IV. 	POST-ESTIMATION
******************************************
//We can do more than just display coefficients following regression
//Examples from linear regression

help regress postestimation // here is the relevant help file

*TESTING FOR HETEROSKEDASTICITY
reg wage union age married 
estat hettest


*WALD TESTS
reg wage union age married 
test union = married

//What are we testing? What do we conclude?

******************************************
* V.	PLOTTING REGRESSION RESULTS
******************************************

// Sometimes, we may want to display results in figures rather than tables

//you will need to run the below to install this very useful user-written command
ssc install coefplot

reg wage union age married i.industry
coefplot, horizontal
coefplot, drop(_cons) horizontal

reg wage union age married i.industry
coefplot, drop(_cons) vertical 

**How would you alter this coefplot for a logistic regression?
//COMMAND:



*Does the Scale need to be changed at all?


//What if you want to use 99 percent confidence intervals instead of 95?
//Use the help file for coefplot to figure out how to plot the above figure that way
//COMMAND: 

