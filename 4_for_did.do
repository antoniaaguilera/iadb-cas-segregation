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
 
collapse (firstnm) group region_insae cod_reg_rbd (mean) cod_nivel (sum) prioritario_def (count) total = mrun, by(year_application rbd_matricula)

gen pc_prio = prioritario_def/total*100
sort rbd_matricula year_application

gen pre_treatment  = (region_insae == "no")
gen post_treatment = (region_insae != "no")

gen is_treated = (cod_reg_rbd == 12)
replace is_treated = 1 if group == 2 & year_application == 2017
replace is_treated = 1 if group == 3 & year_application == 2018
replace is_treated = 1 if group == 4 & year_application == 2019


save "$pathData/outputs/for_did.dta", replace
