//1.
// Create a scatter plot of the dependent variable (gpa) on the independent 
// (attendance)
scatter gpa attendance


// 2.
//Linear regression of gpa on attendance
	// The coeff value is the 'a' in y = ax + b
	/* Eg. the value of attendance in this instance is 1.22 so the 
	equation will look like this: 
		y = 1.22x + b; 
	where x is the value of all the attendance recorded 
	and y is the gpa we want to calculate
	*/
regress gpa attendance


// 3.
// Using the model above, predict values for gpa
predict gpa_predicted


// 4.
/* 
Visualizing model fit
*/
// Construct on the same graph, a graph for the predicted gpa and the real gpa
// and a line graph of gpa against gpa (this should result in a straight line)
/*
If the model is prediction is good, most of the points from the scatter graph
will lie on or close to the graph
*/
twoway (scatter gpa_predicted gpa) (line gpa gpa)


// 5.
// Predict residuals in a variable called 'residuals'
predict residuals, resid


// 6.
// Visualizing residuals
// Create a histogram and on top of that, construct a normal distribution
histogram residuals, normal


// 7.
/* or we can use qnorm. This 'qnorm residuals' compares the distribution of
residuals against the normal distribution 
If normal, the values of the plotted residuals should lie on the line 
after running 'qnorm residuals'.
*/
	// qnorm residuals


/*
	Multiple Linear Regression
*/


// 8.
//First scatter plot of the independent variable (study) against gpa to see 
// whether or not there is a relationship
scatter gpa study


// 9.
// Now regression using 'study' together with 'attendance'
/* 
Resulting equation: gpa = 0.71 * attendance + 0.59 * study + 6.98 

Since 0.71 > 0.59, we can see that the effect attendance has on gpa greater than
effect of study on gpa
*/
regress gpa attendance study


// 10.
// Model fit assessment (Which model to use)
/*
When we have different number of independent variables (eg. model with only
'attendance' and model with 'attendance' and 'study'), it is better to select
the model based on the model with the highest Adjusted R-squared value rather
than just the R-squared value. In this case, the one with multiple variables
*/
// Since we chose the 2nd one, we predict using last regression model
//(i.e regress gpa attendance study)
predict gpa_predicted2



//11.
// Just like in (4), we construct a graph to visualize the model fit
twoway (scatter gpa_predicted2 gpa) (line gpa gpa)
	// We could even include the first model (gpa_predicted) to our graph
	// to really prove that the second one is better
//twoway (scatter gpa_predicted2 gpa) (scatter gpa_predicted gpa) (line gpa gpa)



//12.
// predict residuals value
predict residuals2, resid


//13.
// histogram of residuals2
	// The results are better than the first residuals
histogram residuals2, normal

//or qnorm residuals2



// 14. 
	// To get info about a variable, we could use codebook
	// It can show us which category or group is the reference group
	// --> shows female as 1 and male as 0. Female is the reference group
	// eg. codebook gender 
	
	

// 15.
// Adding the gender variable
	// Gives better Adjusted R-squared with all the variables as significant
regress gpa attendance study gender
	// Better still, we can use i.gender to indicate the reference category, in 
	// this case, 'female'
regress gpa attendance study i.gender

/* To set male as the reference group, we can use

	regress gpa attendance study b1.gender

This will result in male being used as a reference group, although the
coeffient will be negative
*/


// 16.
// Adding 'major' variable

// Info about major
codebook major

// since 'major' is a categorical variable and has more than 2 categories,
// it is important to add 'i'


// 17.
// Regress including major
regress gpa attendance study i.gender i.major
/*
Since major has more than one category, Stata will take the one will the lowest
binary values as the reference, in this case 'Business'. This will result in the
result of the values being negative. Just like with 'male' and 'female'.
Originally, if we use female as the reference, it comes out as a positive value
because it is the value with '1' as shown in 'codebook gender'. If we change the
reference to 'male', the 'male' ref will have a negative value because it's 
binary is zero. Since the binary for Business is zero, and by default, Stata 
chooses the one with the lowest binary values as the reference, all the other 
categories will have a negative value.

Also the reference, Business, is not shown in the table.

In case we don't want to use Business as the reference group, and want to use,
let's say, Biology, we write

	regress gpa attendance study i.gender b2.major

Where 2 is the value of Biology as shown in 'codebook major'.
This will result in positive values since the binary (numeric) value for Biology
is positive.
Also, Biology will be excluded from the result table since it's now the ref.
*/

regress gpa attendance study i.gender b2.major


// 18.
// Adding 'english' variable
// Checking on a graph to see the relationship
scatter gpa english


// 19.
// Regress using 'english'
regress gpa english


// 20.
/*
Although a good regress result, there is a reason to suspect that, the model
can better be represented as a Quadratic rather than a straight line. To prove
this, we plot a graph.
lowess - plots a curve to describe the data

The results proves that, a line may not be the best way to describe the data but
rather a curve.
*/
twoway (scatter gpa english) (lowess gap english)


//21.
//Creating a Quadratic Curve
// Two options to do this

// Option 1
	//Create a square of the 'english' variable
gen english2 = english * english

	// Regress using both 'english' and 'english2'
	// b'cos quadratic formula: ax^2+bx+c = 0
regress gpa english english2


// Option 2
 // drop english2  <- Delete english2 variable
 
regress gpa english c.english#c.english

/* Option 1 and Option 2 present the same result and the result is better 
(Higher Adjusted R^2 and all variables are significant) than that of 
the Linear model.

Option 2 is preferable because it doesn't generate a new variable in the table

english#c.english --> same as english * english but not included as a variable.

Useful when there's a lot of data and lots of dummy variables aren't generated
like 'english2'

*/




// 22.
// Checking Model fit

// Loading the model again
use "C:\Users\alfred\Downloads\linear1 (1).dta", clear

// Predict
 predict gpa_predicted
 
// Plot graph
twoway (scatter gpa_predicted gpa) (line gpa gpa)

// qnorm
qnorm residuals


// 23.
// Checking for normality.
// If Prob>chi2 > 0.05, it means that the residuals follow a normal distribution

// Option 1 
	// Using Skewness and Kurtosis
sktest residuals

// Option 2
	// Using Shapiro-Wilk test
swilk residuals



// 24.
/* Checking for Independence of the variables 
	and 
Constant Variance(Homoscedasticity)

Plotting residuals against Fitted values or any of the independent variable
By plotting the graph, we would like to see that the points are random and 
there is no pattern. With no pattern, we can say that the assumption of 
Independence of the variables is sustained.

Constant variance (Homoscedasticity) -The dots should be uniformly distributed
around the line
*/
rvfplot, yline(0)


// 25.
/*
Checking for Homoscedasticity is sometimes difficult to see on the graph so we 
run Breush-Pagan / Cook-Weisberg (test) for heteroskedasticity.
If the Prob > chi2 value is > than 0.05, we cannot reject the 
HO: Constant variance -> which indicates that there is homoskedasticity

If Prob > chi2 is greater than 0.05, then we reject HO and say that, there is 
no constant variance (homoskedasticity) but rather Heteroskedasticity
*/
estat hettest


/*
	If we suspect that any fo the assumptions have been violated 
	(eg. no independence) we can run our regression with 'vce(robust)'
	eg.	regress gpa attendance study i.gender, vce(robust)
*/


// 26.
// Checking for muliticolinearity
// If the VIF for any variable > 10, then there is multicolinearity and we may
// have to exclude that variable
vif



// 27.
// Outliers
// Plots several graphs against the dependent variable to visualize outliers
avplots

/*or 
	
lvr2plot

lvr2plot produces one graph Leverage (Extent of outlier and influence it has
on data) against Normalized Residual Squared( basically, a normalized squared of
the residual values).
 
Points above the horizontal line have more than the average leverage.
Points to the right of the vertical line have very high residuals.

Problematic points are those that are both above the horizontal line and to 
the right of the vertical line. The further to the top on the right side of the
vertical line, the more 'problematic' that outlier is and may need to be removed

*/

// lvr2plot



//28.
// Calculating the influence of outliers
/*
These command create new variables after which we sort (asc) by cook
Looking at the last 3 variables using list -3/1, we can see the values with huge
values across board. This values are the outliers

*/
dfbeta
predict dfits if e(sample), dfits
predict cook, cooksd
sort cook

// Visualizing dfits and cook to see outliers 
// (since high values will be isolated on the graph)

scatter dfits cook, mlabel(attendance)


//29.
// Deciding which variables to include in our model

// Option 1
// Using Stata
	// This means, every variable with p value of 0.05 should be included in 
	// the model
// forward elimination
stepwise, pe(0.05): regress gpa attendance study gender major english

// backward elimination
stepwise, pr(0.05): regress gpa attendance study gender major english

























