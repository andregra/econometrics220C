clear all 
capture log close
global dir "C:\Users\andre\Dropbox\ucsd_classes\econometrics\"
cd "$dir/220C"
log using pset1_prob6.log, replace
use handguns.dta

gen log_vio=log(vio)
gen log_mur=log(mur)
gen log_rob=log(rob)

//--------------------------
*Q1
//---------------------------
foreach var in vio mur rob {
quietly: reg log_`var' shall, r
eststo `var'
}

estout vio mur rob, cells(b(star fmt(3)) se(par fmt(2))) ///
   legend label varlabels(_cons Constant)

/*Shall variables in this regression shows reduce of 44% for
violent crime, 47% reduction for murder, 77% reduction for robbery
these effects appear statistically significant with p-value<0.01
*/

//--------------------------
*Q2
//---------------------------
global controls incarc_rate density pop pm1029 avginc

foreach var in vio mur rob {
quietly: reg log_`var' shall $controls, r
eststo `var'
}

estout vio mur rob, cells(b(star fmt(3)) se(par fmt(2))) ///
   legend label varlabels(_cons Constant)
   
/*
(a) now the effects for violent, murder and robbery are 
-36, -30 and -56% respectively
(b) Yes, practically speaking these are large differences. A 10 percentage 
point difference in crime is considered a large change for policy. 

*/

//--------------------------
*Q3
//---------------------------
/*
(a) If stronger laws are associated with low ui, and stronger laws 
are positively correlated with shall laws, then cov(X1i, ui)>0

(b) B theta is biased downward, as the correlation between strong laws and 
shall laws makes the effect look more negative than it is. 

*/

//--------------------------
*Q4
//---------------------------
quietly: tab state, generate(statedummy)
xtset stateid year

foreach var in vio mur rob {
quietly: reg log_`var' shall $controls, r
eststo `var'1
quietly: reg log_`var' shall $controls statedummy*, r
eststo `var'2
quietly: testparm statedummy*
quietly: estadd scalar F_state=r(p)
quietly: reg log_`var' shall $controls statedummy* i.year, r
eststo `var'3
quietly: testparm statedummy*
quietly: estadd scalar F_state=r(p)
quietly: testparm i.year
quietly: estadd scalar F_year=r(p)
quietly: reg log_`var' shall $controls statedummy* i.year, r cluster(state)
eststo `var'4
}

foreach var in vio mur rob {
estout `var'1 `var'2 `var'3 `var'4, cells(b(star fmt(3)) se(par fmt(2))) ///
   legend label varlabels(_cons Constant) stats(F_state F_year) keep(shall)
}

 /*
 (a) Introduction of state effects reduces coefficients of the effect to near zero
 (b) This suggests that there is a large omitted variable problem in the initial
 regression. Ommitted variables correlated with a given state explain most of the 
 spurious relationship between shall and crime.
 (c) The F-test for including state dummies is significant at the 1% level.
 (d) Yes, it suggests that our initial B was downward biased by an ommitted variable
 (e) The year fixed effects should control for general year trends or variables that 
 affect all states in a given year, for instance a sudden spike in violent crime across the US
 from some socioeconomic shock.
 (f) The jump in standard errors suggests that there is high correlation of standard 
 errors within state, which adds to the story that particular state effects are 
 very significant in this model.
 
 */



