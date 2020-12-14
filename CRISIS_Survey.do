/****************************************************************************** 
* Author:		Christopher J Greenwood 

* Purpose:		This do file creates derived variables from:
				
				1. Emotions and Worries domain of the CRISIS survey, 
				as adapted for the Australian Temperament Project Generation 3 study. 
				This corresponds to the 'Baseline Current' version of the CRISIS tool, 
				which can be found at https://github.com/nimh-comppsych/CRISIS  
				
				2. Relationships/Social
				
				3. Home schooling
				
				
						
* Date:			16 Nov 2020
*******************************************************************************/

********************************************************************************
* 1a. EMOTION/WORRIES - PARENT *
********************************************************************************
/*******************************************************************************

* TO ADD:		Binary cuts based on number of moderate/high items endorsed

* Over the past 2 weeks, how worried were you generally?
* Over the past 2 weeks, how happy versus sad were you?
* Over the past 2 weeks, how relaxed versus anxious were you?
* Over the past 2 weeks, how fidgety or restless were you?
* Over the past 2 weeks, how fatigued or tired were you?
* Over the past 2 weeks, how well have you been able to concentrate or focus?
* Over the past 2 weeks, how irritable or easily angered have you been?
* Over the past 2 weeks, how lonely have you been?

*******************************************************************************/

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
* 1b. EMOTION/WORRIES - CHILD *
********************************************************************************
/*******************************************************************************

* TO ADD:		Binary cuts based on number of moderate/high items endorsed

* Over the past 2 weeks, how worried was your child generally?
* Over the past 2 weeks, how happy versus sad was your child?
* Over the past 2 weeks, how relaxed versus anxious was your child?
* Over the past 2 weeks, how fidgety or restless was your child?
* Over the past 2 weeks, how fatigued or tired was your child?
* Over the past 2 weeks, for their age, how well has your child been able to concentrate or focus?
* Over the past 2 weeks, how irritable or easily angered has your child been?
* Over the past 2 weeks, how lonely has your child been?

*******************************************************************************/

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

********************************************************************************
* 2. RELATIONSHIPS/SOCIAL *
********************************************************************************
/*******************************************************************************

* PRELIMINARY VARIABLES ONLY *				

* TO ADD:		Relationships with child
				Relationships between child and siblings
				Support family, community, international	
				
* Over the past 2 weeks, how would you rate the quality of your relationship with your partner? 
* Over the past 2 weeks, how would you rate the quality of your relationships with other family and/or friends? 

*******************************************************************************/

tab1 	covid_rel1 covid_rel2

lab var covid_rel1 "Relationship with partner" 
lab var covid_rel2 "Relationship with family/friends" 

tab1 	covid_rel1 covid_rel2

* create binary variables 0 = quite/very good; 1 = very poor/not so good/mixed
foreach v of varlist covid_rel1 covid_rel2 {
	
	recode 	`v' 1/3=1 4/5=0 6=., g(`v'_2)	// 6 = "I dont have a partner"
	
	ta 	 	`v' `v'_2
	
}

********************************************************************************
* 3. HOME SCHOOLING *
********************************************************************************
/*******************************************************************************

* PRELIMINARY VARIABLES ONLY *				

*******************************************************************************/

forvalues i = 1/4 {

	lab var toddcare_c`i' "C`i': Have creche/daycare arrangements changed?"
	lab var toddduties_c`i' "C`i': Looking after toddler made difficult to do paid work/domestic duties?"
	
	lab var prescare_c`i' "C`i': Have kinder/preschool/early learning arrangements changed?"
	lab var presduties_c`i' "C`i': Looking after preschooler made difficult to do paid work/domestic duties?"
	
	lab var schoolcare_c`i' "C`i': Have primary school learning arrangements changed?"
	lab var schoolduties_c`i' "C`i': Online schooling made difficult to do paid work/domestic duties?"
	lab var schoolenjoy_c`i' "C`i': Enjoying and engaging with his/her online learning activities?"
	
}

tab1 toddcare_c*
tab1 toddduties_c*

tab1 prescare_c*
tab1 presduties_c*

tab1 schoolcare_c*
tab1 schoolduties_c*
tab1 schoolenjoy_c*

********************************************************************************
* 4. FINANCIAL DIFFICULTIES *
********************************************************************************		
/*******************************************************************************

* PRELIMINARY VARIABLES ONLY *				

*******************************************************************************/

* Personal SEP outcomes directly due to COVID
* 1=You or your family member lost job and/or You or your family member had reduced capacity to earn, 0=no to both these

tab1 covid_dx2*		
	
tab covid_dx2___6  
tab covid_dx2___7

egen	COVIDper2 = rowmax(covid_dx2___6 covid_dx2___7)
ta		COVIDper2
	
* Financial situation	
* Depending on the distribution, could dichotomise as 1/2=0 and 3/5=1
	
tab covid_financ1		
tab covid_financ1, nol		
		
recode covid_financ1 (1/2=0 ">=Doing alright") (3/5=1 "<=Just getting by"), g(covid_financ12)
ta covid_financ12

* Financial difficulties
* ticked any versus didn't tick any
		
tab1 covid_financ2*	
		
tab covid_financ2___1 
tab covid_financ2___2 
tab covid_financ2___3 
tab covid_financ2___4 
tab covid_financ2___5 
tab covid_financ2___6	

egen	findif2 = rowmax(covid_financ2___1 covid_financ2___2 covid_financ2___3 covid_financ2___4 covid_financ2___5 covid_financ2___6)
ta		findif2
		
* Composite
* 2 or more difficulties

egen 	COVIDcomp = rowtotal(COVIDper2 covid_financ12 findif2)
recode 	COVIDcomp 0/1=0 2/3=1
ta 		COVIDcomp

		