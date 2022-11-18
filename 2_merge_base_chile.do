/*
================================================================================
FECHA CREACION: 2022_09_09 // akac
ULTIMA MODIFICACION: 2022_10_13 // akac
--------------------------------------------------------------------------------
PROYECTO: Paper Segregación CCAS
DESCRIPCIÓN: Este do-file genera una base de datos a nivel de estudiante que incluye 
la información de la institución dónde se encuentra matriculado más 
================================================================================
*/

/*
Decisiones/Comentarios:
- conservé la primera región para aquellos alumnos que tenían postulaciones a colegios en más de una región
- se caen muchas obs al ocupar prioritarios del mismo año SAE, probablemente porque no muchos kinder están
*/
* --------------------------------------------------------------------------------
* SET PATHS
* --------------------------------------------------------------------------------
global pathMain "/Users/antoniaaguilera/ConsiliumBots Dropbox/antoniaaguilera@consiliumbots.com/iadb-segregation-paper"
global pathData "$pathMain/data"

* --------------------------------------------------------------------------------
* AGGREGATED SUPPLY DATA 
* --------------------------------------------------------------------------------
use "$pathData/intermediates/sae_oferta_2016.dta", clear
append using "$pathData/intermediates/sae_oferta_2017.dta"
append using "$pathData/intermediates/sae_oferta_2018.dta"
append using "$pathData/intermediates/sae_oferta_2019.dta"

merge m:1 rbd using "$pathData/intermediates/rbd_region.dta"
keep if _merge == 3 
drop _merge

save "$pathData/outputs/sae_oferta_final.dta", replace 

* --------------------------------------------------------------------------------
* AGGREGATED APPLICANTS DATA WITH STUDENT REGION
* --------------------------------------------------------------------------------
use "$pathData/intermediates/sae_applicants_2016.dta", clear
append using "$pathData/intermediates/sae_applicants_2017.dta"
append using "$pathData/intermediates/sae_applicants_2018.dta"
append using "$pathData/intermediates/sae_applicants_2019.dta"

save "$pathData/outputs/sae_applicants_final.dta", replace 
 
* --------------------------------------------------------------------------------
* AGGREGATED APPLICATIONS DATA WITH STUDENT REGION
* --------------------------------------------------------------------------------
use "$pathData/intermediates/sae_applications_2016.dta", clear
append using "$pathData/intermediates/sae_applications_2017.dta"
append using "$pathData/intermediates/sae_applications_2018.dta"
append using "$pathData/intermediates/sae_applications_2019.dta"

merge m:1 rbd using "$pathData/intermediates/rbd_region.dta"
keep if _merge == 3 
drop _merge

replace dependencia = 2 if rbd == 20567 & cod_depe == 4
drop agno

save "$pathData/outputs/sae_applications_final.dta", replace 

* --------------------------------------------------------------------------------
* MERGE DATA SAE BY YEAR 
* --------------------------------------------------------------------------------

forvalues year=2016/2019 {
	use "$pathData/intermediates/sae_applications_`year'.dta", clear
	merge m:1 rbd using "$pathData/intermediates/rbd_region.dta"
	keep if _merge == 3 
	drop _merge 
	collapse (firstnm) cod_reg_rbd, by(mrun)
	merge 1:1 mrun using "$pathData/intermediates/sae_applicants_`year'.dta" // tienen que pegar todos
	drop _merge 
	merge 1:1 mrun using "$pathData/intermediates/sae_respuesta_`year'.dta" // tienen que pegar todos
	drop _merge 
	gen in_sae = 1
	save "$pathData/intermediates/sae_final_`year'.dta", replace 
}
 
* --------------------------------------------------------------------------------
* MERGE MATRICULA + SAE
* --------------------------------------------------------------------------------


* -------------------------------
* 2016
* -------------------------------
*use "$pathData/intermediates/rendmat2017_prio2016.dta", clear
use "$pathData/intermediates/rendmat2017_prio2017.dta", clear
gen in_mat = 1

merge 1:1 mrun using "$pathData/intermediates/sae_final_2016.dta"
rename rbd rbd_matricula 
rename rbd_final rbd_asignado

replace cod_nivel = -1 if cod_ense == 10 & cod_grado == 4

keep mrun etapa cod_nivel *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat year*  origin
order year* mrun cod_nivel etapa *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat origin

gen region_insae     = "only_entry" if  cod_reg_rbd == 12
replace region_insae = "no" 	    if region_insae == ""

tempfile sae2016_mat2017
save `sae2016_mat2017', replace 

* -------------------------------
* 2017
* -------------------------------
*use "$pathData/intermediates/rendmat2018_prio2017.dta", clear
use "$pathData/intermediates/rendmat2018_prio2018.dta", clear
gen in_mat = 1

merge 1:1 mrun using "$pathData/intermediates/sae_final_2017.dta"

rename rbd rbd_matricula 
rename rbd_final rbd_asignado

replace cod_nivel = -1 if cod_ense == 10 & cod_grado == 4

keep mrun etapa cod_nivel *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat year* origin
order year* mrun cod_nivel etapa *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat origin

gen region_insae     = "all_grades" if  cod_reg_rbd == 12
replace region_insae = "only_entry" if inlist(cod_reg_rbd,1,4,10 )
replace region_insae = "no" 	    if region_insae == ""

tempfile sae2017_mat2018
save `sae2017_mat2018', replace 

* -------------------------------
* 2018
* -------------------------------
*use "$pathData/intermediates/rendmat2019_prio2018.dta", clear
use "$pathData/intermediates/rendmat2019_prio2019.dta", clear
gen in_mat = 1

merge 1:1 mrun using "$pathData/intermediates/sae_final_2018.dta"

rename rbd rbd_matricula 
rename rbd_final rbd_asignado

replace cod_nivel = -1 if cod_ense == 10 & cod_grado == 4

keep mrun etapa cod_nivel *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat year* origin
order year* mrun cod_nivel etapa *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat origin

gen region_insae     = "all_grades" if inlist(cod_reg, 1,4,10,12)
replace region_insae = "only_entry" if cod_reg != 13 & region_insae == ""
replace region_insae = "no" 	    if region_insae == ""


tempfile sae2018_mat2019
save `sae2018_mat2019', replace 

* -------------------------------
* 2019
* -------------------------------
*use "$pathData/intermediates/rendmat2020_prio2019.dta", clear
use "$pathData/intermediates/rendmat2020_prio2020.dta", clear
gen in_mat = 1

merge 1:1 mrun using "$pathData/intermediates/sae_final_2019.dta"

rename rbd rbd_matricula 
rename rbd_final rbd_asignado

replace cod_nivel = -1 if cod_ense == 10 & cod_grado == 4

keep mrun etapa cod_nivel *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat year* origin
order year* mrun cod_nivel etapa *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat origin

gen region_insae     = "all_grades" if cod_reg != 13
replace region_insae = "only_entry" if cod_reg == 13
replace region_insae = "no" 	    if region_insae == ""

tempfile sae2019_mat2020
save `sae2019_mat2020', replace 


* -------------------------------
* APPEND en una gran base 
* -------------------------------
use `sae2016_mat2017', clear
append using `sae2017_mat2018'
append using `sae2018_mat2019'
append using `sae2019_mat2020'
 
replace year_admission = year_application+1
* -- gen years before policy implementation
// fase 1: magallanes
gen years_to_event = 0       if cod_reg_rbd == 12 & year_application == 2016 
replace years_to_event = 1   if cod_reg_rbd == 12 & year_application == 2017
replace years_to_event = 2   if cod_reg_rbd == 12 & year_application == 2018
replace years_to_event = 3   if cod_reg_rbd == 12 & year_application == 2019 
gen group = 1 				 if cod_reg_rbd == 12

// fase 2: cod_reg 1, 4, 6, 10
replace years_to_event = -1  if inlist(cod_reg_rbd, 1, 4, 6, 10) & year_application == 2016
replace years_to_event = 0 	 if inlist(cod_reg_rbd, 1, 4, 6, 10) & year_application == 2017
replace years_to_event = 1 	 if inlist(cod_reg_rbd, 1, 4, 6, 10) & year_application == 2018
replace years_to_event = 2 	 if inlist(cod_reg_rbd, 1, 4, 6, 10) & year_application == 2019
replace group = 2 			 if inlist(cod_reg_rbd, 1, 4, 6, 10)

// fase 3: todas regiones menos metro
replace years_to_event = -2  if inlist(cod_reg_rbd, 2, 3, 5, 7, 8, 9, 11, 14, 15, 16) & year_application == 2016 
replace years_to_event = -1  if inlist(cod_reg_rbd, 2, 3, 5, 7, 8, 9, 11, 14, 15, 16) & year_application == 2017 
replace years_to_event = 0   if inlist(cod_reg_rbd, 2, 3, 5, 7, 8, 9, 11, 14, 15, 16) & year_application == 2018 
replace years_to_event = 1   if inlist(cod_reg_rbd, 2, 3, 5, 7, 8, 9, 11, 14, 15, 16) & year_application == 2019
replace group = 3 			 if inlist(cod_reg_rbd, 2, 3, 5, 7, 8, 9, 11, 14, 15, 16)

// fase 4: metro
replace years_to_event = -3  if cod_reg_rbd == 13 & year_application == 2016 & years_to_event == .
replace years_to_event = -2  if cod_reg_rbd == 13 & year_application == 2017 & years_to_event == .
replace years_to_event = -1  if cod_reg_rbd == 13 & year_application == 2018 & years_to_event == .
replace years_to_event = 0   if cod_reg_rbd == 13 & year_application == 2019 & years_to_event == .
replace group = 4            if cod_reg_rbd == 13


* -------------------------------
* FIX PRIORITARIO
* -------------------------------

count if prioritario_sae!=.&prioritario_alu!=.
count if prioritario_alu!=prioritario_sae&prioritario_sae!=.&prioritario_alu!=.
count if prioritario_alu==prioritario_sae&prioritario_sae!=.&prioritario_alu!=.

gen prioritario_def     = prioritario_alu
replace prioritario_def = prioritario_sae if prioritario_def == . 
* -- reemplazar los que son distintos 
br if prioritario_alu!=prioritario_sae&prioritario_sae!=.&prioritario_alu!=.
replace prioritario_def = prioritario_sae if  prioritario_alu!=prioritario_sae&prioritario_sae!=.&prioritario_alu!=.
replace prioritario_def = 0 if prioritario_def == .

tab cod_reg year_application if prioritario_alu!=prioritario_sae&prioritario_sae!=.&prioritario_alu!=.
order year* mrun etapa *nivel_* rbd_asignado  rbd_matricula asignado_comp es_mujer prioritario* preferente* lat* lon* criterio_sep convenio_sep ee_gratuito ben_sep rural_rbd cod_com_alu nom_com_alu cod_reg_rbd in_sae in_mat origin

save "$pathData/outputs/sae1619_prio1720_mat1720.dta", replace
