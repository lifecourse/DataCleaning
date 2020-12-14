/****************************************************************************** 
* Author:		Christopher J Greenwood 

* Purpose:		This do file creates derived variables for:
				
				Relationships/Social
						
* Date:			16 Nov 2020
*******************************************************************************/

********************************************************************************
* RELATIONSHIPS/SOCIAL *
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
