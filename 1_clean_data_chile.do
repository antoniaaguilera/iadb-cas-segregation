/*
================================================================================
FECHA CREACION: 2022_09_09 // akac
ULTIMA MODIFICACION: 2022_11_03 // akac
--------------------------------------------------------------------------------
PROYECTO: Paper Segregación CCAS
DESCRIPCIÓN: Este do-file limpia las bases originales y genera bases intermedias 
================================================================================
*/

* --------------------------------------------------------------------------------
* SET PATHS
* --------------------------------------------------------------------------------
global pathMain "/Users/antoniaaguilera/ConsiliumBots Dropbox/antoniaaguilera@consiliumbots.com/iadb-segregation-paper"
global pathData "$pathMain/data"

// MATRICULA
local mat_2016 "$pathData/inputs/matricula/matricula-por-estudiante-2016/20160926_matricula_unica_2016_20160430_PUBL.csv"
local mat_2017 "$pathData/inputs/matricula/matricula-por-estudiante-2017/20170921_matricula_unica_2017_20170430_PUBL.csv"
local mat_2018 "$pathData/inputs/matricula/matricula-por-estudiante-2018/20181005_Matrícula_unica_2018_20180430_PUBL.csv"
local mat_2019 "$pathData/inputs/matricula/matricula-por-estudiante-2019/20191028_Matrícula_unica_2019_20190430_PUBL.csv"
local mat_2020 "$pathData/inputs/matricula/matricula-por-estudiante-2020/20200921_Matrícula_unica_2020_20200430_WEB.CSV"

// PRIORITARIOS
local prio_2016 "$pathData/inputs/prioritarios/Alumnos-SEP-2016/Preferentes_Prioritarios_y_Beneficiarios_2016_20160908_PUBL.csv"
local prio_2017 "$pathData/inputs/prioritarios/Alumnos-SEP-2017/Preferentes_Prioritarios_y_Beneficiarios_2017_20171030_PUBL.csv"
local prio_2018 "$pathData/inputs/prioritarios/Alumnos-SEP-2018/20181211_Preferentes_Prioritarios_y_Beneficiarios_2018_20181106_PUBL.csv"
local prio_2019 "$pathData/inputs/prioritarios/Alumnos-SEP-2019/20191122_Preferentes_Prioritarios_y_Beneficiarios_2019_20191106_PUBL.csv"
local prio_2020 "$pathData/inputs/prioritarios/Alumnos-SEP-2020/20201209_Preferentes_Prioritarios_y_Beneficiarios_2020_20201126_WEB.csv"

// RENDIMIENTO
local rend_2016 "$pathData/inputs/rendimiento/rendimiento-2016/20170216_Rendimiento_2016_20170131_PUBL.csv"
local rend_2017 "$pathData/inputs/rendimiento/rendimiento-2017/20180213_Rendimiento_2017_20180131_PUBL.csv"
local rend_2018 "$pathData/inputs/rendimiento/rendimiento-2018/20190220_Rendimiento_2018_20190131_PUBL.csv"
local rend_2019 "$pathData/inputs/rendimiento/rendimiento-2019/20200220_Rendimiento_2019_20200131_PUBL.csv"
local rend_2020 "$pathData/inputs/rendimiento/rendimiento-2020/20210223_Rendimiento_2020_20210131_WEB.csv"

// SAE
local sae_2016 "$pathData/inputs/SAE/SAE_2016"
local sae_2017 "$pathData/inputs/SAE/SAE_2017"
local sae_2018 "$pathData/inputs/SAE/SAE_2018"
local sae_2019 "$pathData/inputs/SAE/SAE_2019"

* --------------------------------------------------------------------------------
* WORK DATA
* --------------------------------------------------------------------------------

* -----------------------------------------
* GET STOCK OF SCHOOLS PER YEAR WITH REGION 
* -----------------------------------------
forvalues year = 2016/2020 {
  * --- matricula --- *
  import delimited "`mat_`year''", clear

  keep rbd cod_reg_rbd cod_depe agno
  duplicates drop rbd, force 
  * --- fix cod_depe
  gen dependencia     = 1 if inlist(cod_depe, 1, 2, 6) //estatal
  replace dependencia = 2 if inlist(cod_depe, 3, 5) //subvencionado
  replace dependencia = 3 if inlist(cod_depe, 4) //pagado
   
  tempfile region_`year'
  save `region_`year'', replace 
}

* --- fix cod_depe
use `region_2016', clear
merge 1:1 rbd using `region_2017'
drop _merge
merge 1:1 rbd using `region_2018'
drop _merge
merge 1:1 rbd using `region_2019'
drop _merge
merge 1:1 rbd using `region_2020'
drop _merge 

duplicates report rbd 
save "$pathData/intermediates/rbd_region.dta", replace 
 

* --------------------------------
* MATRICULA + PRIORITARIOS
* --------------------------------

forvalues year = 2017/2020 {
  * --- matricula --- *
  import delimited "`mat_`year''", clear
  keep rbd rural_rbd nom_com_rbd nom_com_alu mrun gen_alu fec_nac_alu let_cur cod_reg_rbd cod_jor cod_grado2 cod_grado cod_espe cod_ense3 cod_ense2 cod_ense cod_depe2 cod_depe cod_com_rbd agno cod_com_alu
  keep if cod_ense  == 110 & cod_grado == 1

  gen year_application = `year' - 1

  //save "$pathData/intermediates/matricula_`year'.dta", replace
  tempfile mat_`year'
  save `mat_`year'', replace 

  * --- rendimiento --- *
  import delimited "`rend_`year''", clear
  keep if cod_ense  == 110 & cod_grado == 1
  duplicates tag mrun, g(dup_mrun)
  keep mrun sit_fin_r rbd dup_mrun cod_ense cod_grado

  gen sitfin=1
  replace sitfin=2 if sit_fin_r=="Y"
  replace sitfin=3 if sit_fin_r=="R"
  replace sitfin=4 if sit_fin_r=="P"
  replace sitfin=. if sit_fin_r==""
  label define Sitfin 1 "Trasladado" 2 "Retirado" 3 "Reprobado" 4 "Promovido" 
  label values sitfin Sitfin
  bys mrun: egen sitfinal=max(sitfin)
  gen aux=rbd if sitfinal==sitfin
  bys mrun: egen rbd_sitfinal=max(aux)

  * - eliminar ruts duplicados, solo mantengo último dup 
  drop if dup_mrun>0 & sitfin<3
  duplicates tag mrun, gen(dup2)
  drop if dup2>0
  drop dup2 
	
  order mrun *
  sort mrun 
  keep mrun rbd_sitfinal cod_grado cod_ense

  gen year_application = `year' - 1

  merge 1:1 mrun using `mat_`year'' //"$pathData/intermediates/matricula_`year'.dta"
  keep if _merge == 3
  drop _merge 

  //save "$pathData/intermediates/rendmat_`year'.dta", replace
  tempfile rendmat_`year'
  save `rendmat_`year'', replace 

  * --- prioritarios --- *
  local year_prio = `year'-1
  import delimited "`prio_`year_prio''", clear
 
  destring cod_reg_rbd, replace 
  keep agno mrun convenio_sep grado_sep prioritario_alu preferente_alu ben_sep criterio_sep cod_ense cod_grado ee_gratuito cod_reg_rbd
  destring cod_ense cod_grado, replace
  keep if cod_ense  == 10 & cod_grado == 5

  gen year_application = `year' - 1

  merge 1:1 mrun using `rendmat_`year''
  *keep if _merge == 3  
  gen origin = "matricula"        if _m == 2
  replace origin = "prioritario"  if _m == 1
  replace origin = "matricula+prioritario" if _m == 3
  drop _merge
  save "$pathData/intermediates/rendmat`year'_prio`year_prio'.dta", replace 
}
stop 
* --------------------------------
* SAE
* --------------------------------

* -----------------
* APPLICANTS
* -----------------

forvalues year = 2016/2019 {
 local admission_year = `year' + 1

 * --- SAE - APPLICANTS - REGULAR --- *
  import delimited "`sae_`year''/B1_Postulantes_etapa_regular_`year'_Admision_`admission_year'_PUBL.csv", clear
  
  cap rename nivel cod_nivel
  keep if cod_nivel== 1

  tempfile sae_regular_postulantes_`year'
  save `sae_regular_postulantes_`year'', replace

  * --- SAE - APPLICANTS - COMPLEMENTARIO --- *
  import delimited "`sae_`year''/B2_Postulantes_etapa_complementaria_`year'_Admision_`admission_year'_PUBL.csv", clear
  cap rename nivel cod_nivel
  keep if cod_nivel== 1

  merge 1:1 mrun using `sae_regular_postulantes_`year''
  gen etapa = "reg"           if _m == 2
  replace etapa = "comp"      if _m == 1
  replace etapa = "reg+comp"  if _m == 3

  drop _merge
  duplicates report mrun
  rename prioritario prioritario_sae

  gen year_application = `year'
  gen year_admission = `admission_year'

  if year_application>=2017 {
  	replace lat_con_error = subinstr(lat_con_error,",",".",.)
	replace lon_con_error = subinstr(lon_con_error,",",".",.)
  }

  destring lat_con_error lon_con_error, replace
  save "$pathData/intermediates/sae_applicants_`year'.dta", replace 
}

* -----------------
* APPLICATIONS
* -----------------
forvalues year = 2016/2019 {
 local admission_year = `year' + 1

 * --- SAE - APPLICATIONS - REGULAR --- *
  import delimited "`sae_`year''/C1_Postulaciones_etapa_regular_`year'_Admision_`admission_year'_PUBL.csv", clear
  cap rename nivel cod_nivel
  keep if cod_nivel== 1
  keep mrun rbd
  gen etapa = "regular"
 
  tempfile sae_regular_postulaciones_`year'
  save `sae_regular_postulaciones_`year'', replace

  * --- SAE - APPLICATIONS - COMPLEMENTARIO --- *
  import delimited "`sae_`year''/C2_Postulaciones_etapa_complementaria_`year'_Admision_`admission_year'_PUBL.csv", clear
  cap rename nivel cod_nivel
  keep if cod_nivel== 1
  keep mrun rbd
 
  gen etapa = "complementaria"
 
  append using `sae_regular_postulaciones_`year''

  duplicates report mrun

  gen year_application = `year'
  gen year_admission = `admission_year'

  save "$pathData/intermediates/sae_applications_`year'.dta", replace 
}

* -----------------
* SUPPLY
* -----------------
forvalues year = 2016/2019 {
	local admission_year = `year' + 1
 * -----------------
 * SCHOOLS - REGULAR
 * -----------------
	import delimited "`sae_`year''/A1_Oferta_Establecimientos_etapa_regular_`year'_Admision_`admission_year'.csv", clear
	 
	cap rename nivel cod_nivel
	keep if cod_nivel == 1
	collapse (firstnm) cod_nivel con_copago lat lon (sum) cupos_totales vacantes , by(rbd)			 
	
	tempfile sae_regular_oferta_`year'
	save `sae_regular_oferta_`year'', replace 

* ------------------------
* SCHOOLS - COMPLEMENTARIO
* ------------------------
	import delimited "`sae_`year''/A2_Oferta_Establecimientos_etapa_complementaria_`year'_Admision_`admission_year'.csv", clear
	cap rename nivel cod_nivel
	keep if cod_nivel == 1
	collapse (firstnm) cod_nivel con_copago lat lon (sum) cupos_totales vacantes , by(rbd)			 				 
 
    merge 1:1 rbd using `sae_regular_oferta_`year''

	gen etapa     = "reg"       if _m == 2
	replace etapa = "comp"      if _m == 1
	replace etapa = "reg+comp"  if _m == 3

	drop _merge
	duplicates report rbd

	gen year_application = `year'
	gen year_admission = `admission_year'
	
	if year_application>=2017 {
		replace lat = subinstr(lat,",",".",.)
		replace lon = subinstr(lon,",",".",.)
		destring lat lon, replace
	}
  save "$pathData/intermediates/sae_oferta_`year'.dta", replace 
}



* -----------------
* ASSIGNMENT
* -----------------
forvalues year = 2016/2019 {
	local admission_year = `year' + 1
* --------------------
* ASSIGNMENT - REGULAR
* --------------------
	import delimited "$pathData/inputs/SAE/SAE_`year'/D1_Resultados_etapa_regular_`year'_Admision_`admission_year'_PUBL.csv", clear charset(utf-8)
	cap rename nivel cod_nivel
	keep if cod_nivel == 1 
	cap rename respuesta_postulante_post_lista_ respuesta_post_lista
	cap rename * *_reg
	rename mrun_reg mrun

	tempfile sae_regular_resultados
	save `sae_regular_resultados', replace

* ---------------------------
* ASSIGNMENT - COMPLEMENTARIO
* ---------------------------
	import delimited "$pathData/inputs/SAE/SAE_`year'/D2_Resultados_etapa_complementaria_`year'_Admision_`admission_year'_PUBL.csv", clear charset(utf-8)
	rename * *_comp
	rename mrun_comp mrun
	cap rename nivel cod_nivel
	keep if cod_nivel == 1 

	merge 1:1 mrun using `sae_regular_resultados'
	
	order mrun *_reg *_comp

	gen rbd_final = ""
	gen cod_curso_final = ""
	gen asignado_comp = 0
	cap destring respuesta_post_lista_reg, replace
	cap tostring rbd_admitido_reg rbd_admitido_comp, replace
* ---------------------------
* ASSIGNMENT - RESUPUESTAS
* --------------------------- 
	cap gen respuesta_post_lista_reg = . if `year'<=2017
	* --- estudiantes que acepta en etapa regular
	tab _merge if respuesta_postulante_reg == 1 //no hay ninguno que acepte y que estén en complementaria
	replace rbd_final = rbd_admitido_reg  if respuesta_postulante_reg == 1
	
	* --- estudiantes que acepta y espera en etapa regular
	tab _merge if respuesta_postulante_reg == 2 //no hay ninguno que acepte y que estén en complementaria
	cap tab respuesta_post_lista_reg if respuesta_postulante_reg == 2 //respuesta post lista sólo ==1
	* acepta lista de espera
	replace rbd_final       = rbd_admitido_post_resp_reg   if respuesta_postulante_reg == 2 & respuesta_post_lista_reg == 1
	
	* --- estudiantes estudiantes que rechazan
	tab _merge if respuesta_postulante_reg == 3
	* los que están sólo en regular
	replace rbd_final       = "rechaza-en-regular"    if respuesta_postulante_reg == 3 & _merge == 2
	* los que están en ambas, si rechaza en primera está obligado a aceptar en complementaria
	replace rbd_final       = rbd_admitido_comp       if respuesta_postulante_reg == 3 & _merge == 3
	replace asignado_comp   = 1  if respuesta_postulante_reg == 3 & _merge == 3

	* --- estudiantes que rechazan y espera
	tab _merge if respuesta_postulante_reg == 4 //no obs

	* --- estudiantes que no responden
	tab _merge if respuesta_postulante_reg == 5
	replace rbd_final       = rbd_admitido_reg       if respuesta_postulante_reg == 5
	
	* --- estudiantes que están obligados a esperar
	tab _merge if respuesta_postulante_reg == 6
	tab respuesta_post_lista_reg if respuesta_postulante_reg == 6 & _merge == 2
	tab respuesta_post_lista_reg if respuesta_postulante_reg == 6 & _merge == 3
	* espera, se le asigna y acepta
	replace rbd_final       = rbd_admitido_post_resp_reg if respuesta_postulante_reg == 6 & respuesta_post_lista_reg == 1
	* espera, se le asigna y rechaza
	replace rbd_final       = "sale-del-proceso"         if respuesta_postulante_reg == 6 & respuesta_post_lista_reg == 3 & _merge == 2
	replace rbd_final       = rbd_admitido_comp          if respuesta_postulante_reg == 6 & respuesta_post_lista_reg == 3 & _merge == 3
	replace asignado_comp   = 1                          if respuesta_postulante_reg == 6 & respuesta_post_lista_reg == 3 & _merge == 3
	* obligado a esperar y sin respuesta post lista
	replace rbd_final       = rbd_admitido_post_resp_reg if respuesta_postulante_reg == 6 & respuesta_post_lista_reg == 5 & _merge == 2
	* obligado a esperar y sin asignacion
	replace rbd_final       = "sin-asignacion"         if respuesta_postulante_reg == 6 & respuesta_post_lista_reg == 6 & _merge == 2
	replace rbd_final       = rbd_admitido_comp         if respuesta_postulante_reg == 6 & respuesta_post_lista_reg == 6 & _merge == 3
	replace asignado_comp   = 1                         if respuesta_postulante_reg == 6 & respuesta_post_lista_reg == 6 & _merge == 3

	* --- estudiantes que salen del proceso
	replace rbd_final       = "sale-del-proceso"  if respuesta_postulante_reg == 7
	
	count if rbd_final == "" & _merge == 1 //
	count if rbd_final == "" & _merge == 2 //
	count if rbd_final == "" & _merge == 3 // 

	replace rbd_final = rbd_admitido_comp                  if _merge == 1

	replace rbd_final = subinstr(rbd_final, " ", "", .)

	replace rbd_final       = "sin-asignacion" if rbd_final == ""
	
	drop _merge 
	save "$pathData/intermediates/sae_respuesta_`year'.dta", replace 
}
