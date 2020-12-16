/****************************************************************************** 
* Author:		Christopher J Greenwood 

* Purpose:		This do file creates derived variables from:
				
				Financial difficulties
						
* Date:			16 Nov 2020
*******************************************************************************/

********************************************************************************
* FINANCIAL DIFFICULTIES *
********************************************************************************		
/*******************************************************************************

* PRELIMINARY VARIABLES ONLY *				

*******************************************************************************/

* Personal SEP outcomes directly due to COVID
* 1=You lost job and/or had reduced capacity to earn, 0=no to both these

tab1 covid_dx2*		
	
tab covid_dx2___6  
tab covid_dx2___7

egen	COVIDper2 = rowmax(covid_dx2___6 covid_dx2___7)
ta		COVIDper2
	
* Financial situation	
* After reviewing the distribution and considering response options, dichotomised as 1/2=0 and 3/5=1
	
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
* any and 2 or more difficulties

egen 	COVIDany = rowtotal(COVIDper2 covid_financ12 findif2)
recode 	COVIDany 0=0 1/3=1
ta 		COVIDany

egen 	COVIDcomp = rowtotal(COVIDper2 covid_financ12 findif2)
recode 	COVIDcomp 0/1=0 2/3=1
ta 		COVIDcomp
	