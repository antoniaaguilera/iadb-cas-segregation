/*
================================================================================
FECHA CREACION: 2022_11_17 // akac
ULTIMA MODIFICACION: 2022_11_17 // akac
--------------------------------------------------------------------------------
PROYECTO: Paper Segregación CCAS
DESCRIPCIÓN: Este do-file crea la base para la estumació de diferencias en diferencias 
================================================================================
*/

* --------------------------------------------------------------------------------
* SET PATHS
* --------------------------------------------------------------------------------
global pathMain "/Users/antoniaaguilera/ConsiliumBots Dropbox/antoniaaguilera@consiliumbots.com/iadb-segregation-paper"
global pathData "$pathMain/data"
global pathFigures "$pathMain/figures"
global pathTables "$pathMain/tables"
 
* --------------------------------------------------------------------------------
* COLLAPSE DATA 
* --------------------------------------------------------------------------------
use "$pathData/outputs/sae1619_prio1720_mat1720.dta", clear 
 * - con base a nivel de estudiante se genera el indicador con duncan2
 * - construir el duncan con ambos rbd (asignacion y matricula)
 
/*
[13:23] Macarena Kutscher
    by comuna: duncan2 rbd_sae prioritario_def, d(D)
​[13:24] Macarena Kutscher
    foreach region in `region' {​​
local year 2015 2016 2017 2018 2019
foreach year in `year'{​​
use "$output/`region'_duncan_index_`year'.dta", clear
drop if group20_mother12==.
*recovering comunas codes
levelsof cod_com_rbd, local(levels) 
local ncom: word count `levels'
matrix `region'= J(`ncom',1, .)
matrix colname `region'= duncan2
matrix rowname `region'= `levels'
local i=1
foreach l of local levels {​​
local index group20_mother12
foreach index in `index' {​​
duncan2 rbd `index' if cod_com_rbd==`l', d(D)
sum D
matrix `region'[`i',1]=r(mean)
drop D
}​​
local ++i
}​​

matrix list `region'
 
 */
collapse (firstnm) group region_insae cod_reg_rbd (mean) cod_nivel (sum) prioritario_def (count) total = mrun, by(year_application rbd_matricula)
stop 
gen pc_prio = prioritario_def/total*100
sort rbd_matricula year_application

gen pre_treatment  = (region_insae == "no")
gen post_treatment = (region_insae != "no")

gen is_treated = (cod_reg_rbd == 12)
replace is_treated = 1 if group == 2 & year_application == 2017
replace is_treated = 1 if group == 3 & year_application == 2018
replace is_treated = 1 if group == 4 & year_application == 2019


save "$pathData/outputs/for_did.dta", replace
