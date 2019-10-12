**********************************************
* Chapter 03
*
* hotels
* input: 
*      hotelbookingdata-vienna.csv

* output: 
*       hotels-vienna.dta

* v1.4
**********************************************
cd "C:\Users\GB\Dropbox (MTA KRTK)\bekes_kezdi_textbook"

*location folders
global data_in   "da_data_repo/hotels-vienna/raw"
global data_out   "da_data_repo/hotels-vienna/clean"



*** IMPORT AND PREPARE DATA

* variables downoaded as string, often in form that is not helpful
* need to transform then to numbers that we can use

import delimited using "$data_in/hotelbookingdata-vienna.csv", clear


* generate numerical variable of rating variable from string variable
*  trick: ignore charecters listed in option

*  distance to center entered as string in miles with one decimal
destring center1distance , generate(distance) ignore(" miles")
lab var distance "Distance to city center (miles)
destring center2distance , generate(distance_alter) ignore(" miles")
lab var distance "Distance to second center (miles)


split accommodationtype , p("@")
drop accommodationtype1 accommodationtype
rename accommodationtype2 accommodation_type

gen nnights=1
replace nnights = 4 if price_night=="price for 4 nights"
 lab var nnights "Number of nights"

 
 * ratings
* generate numerical variable of rating variable from string variable

gen rating = substr(guestreviewsrating,1,strpos(guestreviewsrating," ")-1)
destring rating, replace


* check: frequency table of all values incl. missing varlues as recignized by Stata
*  note same as in string format previously, except # missing here = # NA there

tab rating, missing
 
 

* RENAME VARIABLES
rename rating_reviewcount rating_count
rename rating2_ta ratingta
rename rating2_ta_reviewcount ratingta_count
rename addresscountryname country
rename s_city city


 * look at key vars
rename starrating stars
tab stars
replace stars=. if stars==0

tab rating
codebook hotel_id
drop if hotel_id==.



drop center2distance center1distance price_night guestreviewsrating

* DROP PERFECT DUPLICATES

duplicates report
* these are perfect duplicates of the observation in the previous row
duplicates drop

sort city hotel_id distance stars rating year month weekend holiday

* count if all relevant variables are same as observation in previous row
gen dupl=1 == (city==city[_n-1] & hotel_id==hotel_id[_n-1] & distance==distance[_n-1] ///
 & stars==stars[_n-1] & rating==rating[_n-1] & price==price[_n-1] & year==year[_n-1] & month==month[_n-1] & weekend==weekend[_n-1] & holiday==holiday[_n-1] )
* drop them
tab dupl
drop if dupl==1
drop dupl

drop if hotel_id==. | price==.
order hotel_id 
 
saveold "$data_out/hotels-vienna.dta", replace 
