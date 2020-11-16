******************************************************************************* 
* Author:		Christopher J Greenwood 

* Purpose:		This do file creates derived variables from the Emotions and Worries domain of the CRISIS survey, as adapted for the Australian Temperament Project Generation 3 study. This corresponds to the 'Baseline Current' version of the CRISIS tool, which can be found at https://github.com/nimh-comppsych/CRISIS  
				
* Date:			16 Nov 2020
********************************************************************************

********************************************************************************
* PARENT - EMOTION/WORRIES *
********************************************************************************

* Over the past 2 weeks, how worried were you generally?
* Over the past 2 weeks, how happy versus sad were you?
* Over the past 2 weeks, how relaxed versus anxious were you?
* Over the past 2 weeks, how fidgety or restless were you?
* Over the past 2 weeks, how fatigued or tired were you?
* Over the past 2 weeks, how well have you been able to concentrate or focus?
* Over the past 2 weeks, how irritable or easily angered have you been?
* Over the past 2 weeks, how lonely have you been?

summ 			covid_worry covid_happy covid_anx covid_rest ///
				covid_fatigue covid_focus covid_irrit covid_lone
				
unab vars: 		covid_worry covid_happy covid_anx covid_rest ///
				covid_fatigue covid_focus covid_irrit covid_lone 

tab1 		`vars'
tab1 		`vars', nol

* recode/relabel to start from 0
foreach x of varlist `vars' { 

	replace 		`x' = `x' - 1

	label copy 		`: value label `x'' `x'rc

	forvalues 		i = 0/4 {
	
		local 		c = `i' + 1
		lab def 	`x'rc `=`i'' "`: label (`x') `c''", modify

	}

	lab val 		`x' `x'rc

	ta 				`x', nol 
	ta 				`x' 

}

tab1 		`vars'
tab1 		`vars', nol
pwcorr		`vars'

* reverse "Over the past 2 weeks, how happy versus sad were you?"
foreach x of varlist covid_happy {

	gen 			`x'r = 4 - `x'
    ta 				`x'r `x', nol

	label copy 		`: value label `x'' `x'r

	forvalues 		i = 0/4 {
				  
		lab def 	`x'r `=4-`i'' "`: label (`x') `i''", modify

	}

	lab val 		`x'r `x'r

	ta 				`x' `x'r
	
}

* Mean score 
unab vars: 		covid_worry covid_happyr covid_anx covid_rest ///
				covid_fatigue covid_focus covid_irrit covid_lone
				
egen miss 		= rowmiss(`vars')

egen emowor 	= rowmean(	`vars' 	) if miss == 0		// need complete data

drop miss

label var 		emowor "Emotions/worries (parent): Mean Score (range 0-4)"
summ 			emowor

alpha 			`vars', std

********************************************************************************
* CHILD - EMOTION/WORRIES *
********************************************************************************

* Over the past 2 weeks, how worried was your child generally?
* Over the past 2 weeks, how happy versus sad was your child?
* Over the past 2 weeks, how relaxed versus anxious was your child?
* Over the past 2 weeks, how fidgety or restless was your child?
* Over the past 2 weeks, how fatigued or tired was your child?
* Over the past 2 weeks, for their age, how well has your child been able to concentrate or focus?
* Over the past 2 weeks, how irritable or easily angered has your child been?
* Over the past 2 weeks, how lonely has your child been?

* child num denoted by _c*
summ 			worry_c* happy_c* anx_c* rest_c* fatigue_c* focus_c* irrit_c* lone_c*

unab vars: 		worry_c* happy_c* anx_c* rest_c* fatigue_c* focus_c* irrit_c* lone_c*

tab1 		`vars'
tab1 		`vars', nol

* recode/relabel to start from 0
foreach x of varlist `vars' { 

	replace 		`x' = `x' - 1

	label copy 		`: value label `x'' `x'rc

	forvalues 		i = 0/4 {
	
		local 		c = `i' + 1
		lab def 	`x'rc `=`i'' "`: label (`x') `c''", modify

	}

	lab val 		`x' `x'rc

	ta 				`x', nol 
	ta 				`x' 

}

tab1 		`vars'
tab1 		`vars', nol
pwcorr		`vars'

* reverse "Over the past 2 weeks, how happy versus sad was your child?"
foreach x of varlist happy_c* {

	gen 			`x'r = 4 - `x'
    ta 				`x'r `x', nol

	label copy 		`: value label `x'' `x'r

	forvalues 		i = 0/4 {
				  
		lab def 	`x'r `=4-`i'' "`: label (`x') `i''", modify

	}

	lab val 		`x'r `x'r

	ta 				`x' `x'r
	
}

* Mean score 
forvalues i = 1/4 {

	unab vars: 		worry_c`i' happy_c`i'r anx_c`i' rest_c`i' fatigue_c`i' focus_c`i' irrit_c`i' lone_c`i'
			
	egen miss 		= rowmiss(`vars')

	egen emowor_c`i' 	= rowmean(	`vars' 	) if miss == 0		// need complete data

	drop miss

	label var 		emowor_c`i' "Emotions/worries (child `i'): Mean Score (range 0-4)"
	summ 			emowor_c`i'

	alpha 			`vars', std

}

