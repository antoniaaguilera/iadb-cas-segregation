/*
================================================================================
FECHA CREACION: 2022_10_14 // akac
ULTIMA MODIFICACION: 2022_12_14 // akac
--------------------------------------------------------------------------------
PROYECTO: Paper Segregación CCAS
DESCRIPCIÓN: Este do-file genera estadística descriptiva sobre la data utilizada
================================================================================
*/

* --------------------------------------------------------------------------------
* SET PATHS
* --------------------------------------------------------------------------------
global pathMain "/Users/antoniaaguilera/ConsiliumBots Dropbox/antoniaaguilera@consiliumbots.com/iadb-segregation-paper"
global pathData "$pathMain/data"
global pathFigures "$pathMain/figures"
global pathTables "$pathMain/tables"
 
set scheme cblind1

* ----------------------------------------
* ----------------------------------------
* STAD DESC FOR DEC16 DEADLINE
* ----------------------------------------
* ----------------------------------------


* ----------------------------------------------------------------------------------------------------
* Caracteristicas descriptivas a nivel de estudiante 
* ----------------------------------------------------------------------------------------------------
use "$pathData/outputs/sae1619_prio1720_mat1720.dta", clear 

keep if year_admission==2020 & rbd_matricula !=.
rename rbd_matricula rbd
merge m:1 rbd using "$pathData/intermediates/rbd_region.dta", keepusing(dependencia)
keep if _merge == 3
drop _merge 

count 
local total_a_overall = `r(N)'
count if prioritario_def == 1
local aux = `r(N)'
local prio_a_overall = round(`aux'/`total_a_overall'*100, 0.001)
count if prioritario_def == 0
local aux = `r(N)'
local noprio_a_overall = round(`aux'/`total_a_overall'*100, 0.001)

forval dep = 1/3 {
	count if dependencia == `dep'
	local total_a_`dep' = `r(N)'

	count if dependencia == `dep' & prioritario_def == 1
	local aux = `r(N)'
	local prio_a_`dep' = round(`aux'/`total_a_`dep''*100, 0.001)
	count if dependencia == `dep' & prioritario_def == 0
	local aux = `r(N)'
	local noprio_a_`dep' = round(`aux'/`total_a_`dep''*100, 0.001)

}

* ---applicants
use "$pathData/intermediates/sae_applicants_2019.dta", clear 

count 
local total_applicants = `r(N)'
count if prioritario_sae == 1
local aux = `r(N)'
local prio_applicants = round(`aux'/`total_applicants'*100, 0.001)
count if prioritario_sae == 0
local aux = `r(N)'
local noprio_applicants = round(`aux'/`total_applicants'*100, 0.001)

* ---applications
use "$pathData/intermediates/sae_applications_2019.dta", clear 
merge m:1 mrun using "$pathData/intermediates/sae_applicants_2019.dta", keepusing(prioritario_sae)
count 
local total_applications = `r(N)'
count if prioritario_sae == 1
local aux = `r(N)'
local prio_applications = round(`aux'/`total_applications'*100, 0.001)
count if prioritario_sae == 0
local aux = `r(N)'
local noprio_applications = round(`aux'/`total_applications'*100, 0.001)

* ---assigned students
use "$pathData/intermediates/sae_respuesta_2019.dta", clear
merge 1:1 mrun using "$pathData/intermediates/sae_applicants_2019.dta", keepusing(prioritario_sae)
drop if inlist(rbd_final, "sin-asignacion", "sale-del-proceso", "rechaza-en-regular")

count 
local total_assigned = `r(N)'
count if prioritario_sae == 1
local aux = `r(N)'
local prio_assigned = round(`aux'/`total_assigned'*100, 0.001)
count if prioritario_sae == 0
local aux = `r(N)'
local noprio_assigned = round(`aux'/`total_assigned'*100, 0.001)

* --- assignment_takeup
use "$pathData/outputs/sae1619_prio1720_mat1720.dta", clear 
keep if rbd_asignado != . & rbd_matricula != . & year_admission == 2020
gen flag = (rbd_asignado != rbd_matricula)

count if flag == 1
local total_takeup = `r(N)'
count if prioritario_def == 1 & flag == 1
local aux = `r(N)'
local prio_takeup = round(`aux'/`total_takeup'*100, 0.001)
count if prioritario_def == 0 & flag == 1
local aux = `r(N)'
local noprio_takeup = round(`aux'/`total_takeup'*100, 0.001)

* --- quality 
use "$pathData/outputs/sae1619_prio1720_mat1720.dta", clear 
keep if rbd_matricula != .
rename rbd_matricula rbd
merge m:1 rbd year_application using "$pathData/intermediates/school_quality.dta"
keep if _merge == 3
drop _merge 

gen quality = .
replace quality = 1 if quality_cat == "INSUFICIENTE"
replace quality = 2 if quality_cat == "MEDIO-BAJO"|quality_cat == "MEDIO-BAJO (NUEVO)"
replace quality = 3 if quality_cat == "MEDIO"
replace quality = 4 if quality_cat == "ALTO"


sum quality
local total_quality = round(`r(mean)', 0.01)
sum quality if prioritario_def == 1
local prio_quality = round(`r(mean)', 0.01)
sum quality if prioritario_def == 0
local noprio_quality = round(`r(mean)', 0.01)

file open  students using "$pathTables/students_staddesc.tex", write replace
file write students "\begin{table}[ht!]" _n
file write students "\centering"_n
file write students "\caption{Descriptive statistics}"_n
file write students "\resizebox{13cm}{!}{"_n
file write students "\begin{tabular}{l|cc|c} \hline \hline"_n
file write students "\multicolumn{4}{l}{\textbf{Panel A: Pre-K Enrollment}}  \\ \hline"_n
file write students "                    & Disadvantaged     & Not Disadvantaged  & Total            \\ \hline"_n
file write students "  Overall           & `prio_a_overall'  & `noprio_a_overall' & `prio_a_overall'  \\"_n
file write students "  Public Schools    & `prio_a_1'        & `noprio_a_1'       & `total_a_1'  \\"_n
file write students "  Voucher Schools   & `prio_a_2'        & `noprio_a_2'       & `total_a_2'  \\"_n
file write students "  Private Schools   & `prio_a_3'        & `noprio_a_3'       & `total_a_3'  \\ \hline"_n
file write students "\multicolumn{4}{l}{\textbf{Panel b: SAS Stats}} \\ \hline"_n
file write students " Applicants                       & `prio_applicants'    & `noprio_applicants'   &  `total_applicants'    \\"_n
file write students " Applications                     & `prio_applications'  & `noprio_applications' &  `total_applications'  \\"_n
file write students " Assigned students                & `prio_assigned'      & `noprio_assigned'     &  `total_assigned'      \\"_n
file write students " Assignment non-takeup            & `prio_takeup'      & `noprio_takeup'         &  `total_takeup'        \\"_n
file write students " Average quality of enrollment    & `prio_quality'  & `noprio_quality'           &  `total_quality'  \\ \hline \hline"_n
file write students "\end{tabular} "_n
file write students "}"_n
file write students "\label{tab:students_staddesc}"_n
file write students "\end{table} "_n
file close students
stop
* ----------------------------------------------------------------------------------------------------
* Caracterización de estudiantes que se matriculan en un colegio distinto al que fueron asignados en SAE.
* ----------------------------------------------------------------------------------------------------
use "$pathData/outputs/sae1619_prio1720_mat1720.dta", clear 
gen aux = (cod_com_alu ==cod_com_rbd)
tab aux
//preserve 
// keep if rbd_asignado != . & rbd_matricula != .
// gen flag = (rbd_asignado != rbd_matricula)
// tab prioritario_def if flag == 1
// tab prioritario_def if flag == 0
// stop 
// keep if flag == 1
// keep mrun year_application rbd_asignado rbd_matricula 
// reshape long rbd_,i(mrun year_application) j(tipo) string
// rename rbd_ rbd
// merge m:1 rbd using "$pathData/intermediates/rbd_region.dta", keepusing(dependencia)
// keep if _merge == 3
// drop  _merge 
// rename rbd rbd_
// rename dependencia dep_
// sort year_application mrun tipo
//
// reshape wide rbd_@ dep_@, i(mrun year_application) j(tipo) string 
//
// //   gen dependencia     = 1 if inlist(cod_depe, 1, 2, 6) //estatal
// //   replace dependencia = 2 if inlist(cod_depe, 3, 5) //subvencionado
// //   replace dependencia = 3 if inlist(cod_depe, 4) //pagado
//
// gen     group = 1 if dep_asignado == 1 & dep_matricula == 2 // pasa de público a subvencionado
// replace group = 2 if dep_asignado == 1 & dep_matricula == 3 // pasa de público a privado
// replace group = 3 if dep_asignado == 2 & dep_matricula == 1 // pasa de subvencionado a público
// replace group = 4 if dep_asignado == 2 & dep_matricula == 3 // pasa de subvencionado a privado
// replace group = 5 if dep_asignado == 1 & dep_matricula == 1 // mantiene dependencia público
// replace group = 6 if dep_asignado == 2 & dep_matricula == 2 // mantiene dependencia subvencionada
//
// collapse (count) mrun ,by(group year_application)
// bys year_application: egen total = sum(mrun)
// gen float percent = round(mrun/total*100, 0.01)
// gen float percent_tag = round(mrun/total*100, 0.01)
// tostring percent_tag , replace format(%20.0g)
// replace  percent_tag = substr(percent_tag, 1,5)
// replace  percent_tag = percent_tag+"%"
//
// tw (connect percent year_application if group == 1 ) ///
//    (connect percent year_application if group == 2 ) ///
//    (connect percent year_application if group == 3 ) ///
//    (connect percent year_application if group == 4 ) ///
//    (connect percent year_application if group == 5 ) ///
//    (connect percent year_application if group == 6 ) , ///
//    graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
//    xtitle("year") ytitle("Percentage of total (%)") ylabel(#10,angle(0)) ///
//    legend(order(1 "Public to Voucher" 2 "Public to Private" 3 "Voucher to Public" 4 "Voucher to Private" 5 "Public to Public" 6 "Voucher to Voucher") rows(2) size(4)) 
//   
//    gr export "$pathFigures/sector_consistency_bygroup.png", as(png) replace  
// restore

* ----------------------------------------
* APPLICATION GRADE
* ----------------------------------------
// 	use "$pathData/outputs/sae_applicants_final.dta", clear 
//
// 	collapse (count) mrun, by(year_application cod_nivel)
//
// 	set obs 57
// 	replace cod_nivel = 2 in 48
// 	replace cod_nivel = 3 in 49
// 	replace cod_nivel = 4 in 50
// 	replace cod_nivel = 5 in 51
// 	replace cod_nivel = 6 in 52
// 	replace cod_nivel = 8 in 53
// 	replace cod_nivel = 9 in 54
// 	replace cod_nivel = 10 in 55
// 	replace cod_nivel = 11 in 56
// 	replace cod_nivel = 12 in 57
// 	replace year_application = 2016 if _n>=48
// 	replace mrun = 0 if _n>=48
//
// 	gen nivel_label = "PreK"        if cod_nivel == -1
// 	replace nivel_label = "Kinder"  if cod_nivel == 0
// 	replace nivel_label = "1º"  if cod_nivel == 1
// 	replace nivel_label = "2º"  if cod_nivel == 2
// 	replace nivel_label = "3º"  if cod_nivel == 3
// 	replace nivel_label = "4º"  if cod_nivel == 4
// 	replace nivel_label = "5º"  if cod_nivel == 5
// 	replace nivel_label = "6º"  if cod_nivel == 6
// 	replace nivel_label = "7º"  if cod_nivel == 7
// 	replace nivel_label = "8º"  if cod_nivel == 8
// 	replace nivel_label = "Iº"  if cod_nivel == 9
// 	replace nivel_label = "IIº"  if cod_nivel == 10
// 	replace nivel_label = "IIIº"  if cod_nivel == 11
// 	replace nivel_label = "IVº"  if cod_nivel == 12 
//
// 	sort year_application cod_nivel
// 	bys year_application: egen total = sum(mrun)
// 	replace mrun = round(mrun/total*100, 0.1)
//
// 	gr hbar mrun if year_application == 2016 , over(nivel_label, sort(1) descending) asyvars showyvars ///
// 	graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick))  ///
// 	legend(off) ytitle("% of Total Applicants") ylabel(5 "5" 10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35") saving(year2016, replace) title("2016")
//
// 	gr hbar mrun if year_application == 2017 , over(nivel_label, sort(1) descending) asyvars showyvars ///
// 	graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick))  ///
// 	legend(off) ytitle("% of Total Applicants") ylabel(5 "5" 10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35") saving(year2017, replace) title("2017")
//
// 	gr hbar mrun if year_application == 2018 , over(nivel_label, sort(1) descending) asyvars showyvars ///
// 	graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick))  ///
// 	legend(off) ytitle("% of Total Applicants") ylabel(5 "5" 10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35") saving(year2018, replace) title("2018")
//
// 	gr hbar mrun if year_application == 2019 , over(nivel_label, sort(1) descending) asyvars showyvars ///
// 	graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick))  ///
// 	legend(off) ytitle("% of Total Applicants") ylabel(5 "5" 10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35") saving(year2019, replace ) title("2019")
//
// 	gr combine year2016.gph year2017.gph year2018.gph year2019.gph
//
// 	gr export "$pathFigures/applicants_bygrade2.png", as(png) replace  

 
* ----------------------------------------
* STATS GENERALES
* ----------------------------------------

* --- applicants by region and year
use "$pathData/outputs/sae_applications_final.dta", clear

// preserve
// collapse (firstnm) cod_reg_rbd, by(mrun year_application)
//
// collapse (count) postulantes = mrun, by(cod_reg_rbd year_application)
//
// sort year_application cod_reg_rbd
//
// gen region_name     = "Tarapacá"            if cod_reg_rbd == 1
// replace region_name = "Arica y Parinacota"  if cod_reg_rbd == 15
// replace region_name = "Antofagasta"         if cod_reg_rbd == 2
// replace region_name = "Atacama" 		    if cod_reg_rbd == 3
// replace region_name = "Coquimbo"            if cod_reg_rbd == 4
// replace region_name = "Valparaíso"          if cod_reg_rbd == 5
// replace region_name = "Metropolitana"       if cod_reg_rbd == 13
// replace region_name = "O'Higgins" 	        if cod_reg_rbd == 6
// replace region_name = "Maule" 	            if cod_reg_rbd == 7
// replace region_name = "Ñuble" 	            if cod_reg_rbd == 16
// replace region_name = "Biobío" 		        if cod_reg_rbd == 8
// replace region_name = "Araucanía" 	        if cod_reg_rbd == 9
// replace region_name = "Los Ríos" 	        if cod_reg_rbd == 14
// replace region_name = "Los Lagos" 	        if cod_reg_rbd == 10
// replace region_name = "Aysén" 	 	        if cod_reg_rbd == 11
// replace region_name = "Magallanes" 	        if cod_reg_rbd == 12
//
// gr hbar (sum) postulantes, over(year_application) over(region_name, sort(postulantes) ) asyvars stack  ///
// graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick))  ///
// legend(row(1) position(6) size(medium)) ytitle("Total Applicants")
//
// gr export "$pathFigures/applicants_byregion.png", as(png) replace  
// restore
//
// * --- applications by school sector and year
// preserve
// collapse (count) postulaciones = mrun, by(dependencia year_application)
// sort year_application dependencia
// bys year_application: egen total = sum(postulaciones)
//
// gen float percent = postulaciones/total*100
// gen float pc_tag = round(postulaciones/total*100, 0.01)
// tostring  pc_tag, replace format(%20.0g)
// replace   pc_tag = substr(pc_tag, 1,5)
// replace   pc_tag = pc_tag+"%"
//
// gr bar percent, over(dependencia) over(year_application) asyvars stack ///
// graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick))  ///
// legend(row(1) position(6) size(medium)) ytitle("% of total applications") legend(order(1 "Public Schools" 2 "Voucher Schools")) 
//
// gr export "$pathFigures/applicants_bysector.png", as(png) replace
// restore

* ----------------------------------------
* PRIORITARIOS POR AÑO
* ----------------------------------------
use "$pathData/outputs/sae1619_prio1720_mat1720.dta", clear 

// 	* --- check consistency of disadvantaged status
// 	preserve 
// 	tab prioritario_alu prioritario_sae
//	 
// 	count if prioritario_alu == 0 & prioritario_sae == 0 
// 	local sae0_alu0 : di %6.0f `r(N)'
//
// 	count if prioritario_alu == 1 & prioritario_sae == 0 
// 	local sae0_alu1 : di %6.0f `r(N)'
//
// 	count if prioritario_alu == 0 & prioritario_sae == 1 
// 	local sae1_alu0 : di %6.0f `r(N)'
//
// 	count if prioritario_alu == 1 & prioritario_sae == 1 
// 	local sae1_alu1 : di %6.0f `r(N)'
//
// 	local total1_sep = `sae1_alu1'+`sae0_alu1'
// 	local total0_sep = `sae1_alu0'+`sae0_alu0' 
// 	local total1_sae = `sae1_alu1'+`sae1_alu0'
// 	local total0_sae = `sae0_alu1'+`sae0_alu0'
// 	local total      = `total0_sae' + `total1_sae'
//
// 	file open  consistency using "$pathTables/disadvantaged_consistency.tex", write replace
// 	file write consistency "\begin{table}[ht!]" _n
// 	file write consistency "\centering"_n
// 	file write consistency "\caption{Number of disadvantaged students according to SAS application and SEP registry}"_n
// 	file write consistency "\resizebox{13cm}{!}{"_n
// 	file write consistency "\begin{tabular}{lc|cc|c}"_n
// 	file write consistency "& &\multicolumn{2}{c}{SAS application} \\"_n
// 	file write consistency "                              &                   & Disadvantaged  & Not Disadvantaged & Total \\ \hline"_n
// 	file write consistency "\multirow{2}{*}{SEP registry} & Disadvantaged     & `sae1_alu1'    &   `sae0_alu1'     &  `total1_sep'  \\"_n
// 	file write consistency "                              & Not Disadvantaged & `sae1_alu0'    &   `sae0_alu0'     &  `total0_sep'  \\ \hline"_n
// 	file write consistency "                              &    Total          & `total1_sae'   &   `total0_sae'    &  `total' "_n
// 	file write consistency "\end{tabular} "_n
// 	file write consistency "}"_n
// 	file write consistency "\label{tab:disadvantaged_consistency}"_n
// 	file write consistency "\end{table} "_n
// 	file close consistency
// 	restore 
//	 
* --- applicants with 'disadvantaged' status
// 	preserve 
//	 
// 	collapse (count) total_students =mrun (sum) prioritario_def prioritario_sae in_sae, by(year_application)
//	 
// 	gen float pc_prio_sae = prioritario_sae/in_sae*100
// 	gen float pc_prio_sae_tag = round(prioritario_sae/in_sae*100, 0.01)
// 	tostring  pc_prio_sae_tag, replace format(%20.0g)
// 	replace   pc_prio_sae_tag = substr(pc_prio_sae_tag, 1,5)
// 	replace   pc_prio_sae_tag = pc_prio_sae_tag + "%"
//
// 	gen float pc_prio_mat = prioritario_def/total_students*100
// 	gen float pc_prio_mat_tag = round(prioritario_def/total_students*100, 0.01)
// 	tostring  pc_prio_mat_tag, replace format(%20.0g)
// 	replace   pc_prio_mat_tag = substr(pc_prio_mat_tag, 1,5)
// 	replace   pc_prio_mat_tag = pc_prio_mat_tag+"%"
//
// 	tw (connect pc_prio_sae year_application, mlabel(pc_prio_sae_tag) mlabposition(1))(connect pc_prio_mat year_application, mlabel(pc_prio_mat_tag) mlabposition(1)) , ///
// 	graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
// 	xtitle("year") ytitle("% of disadvantaged students") ylabel(#10,angle(0)) legend(order(1 "Among SAS applicants" 2 "Among total enrollment"))
//
// 	gr export "$pathFigures/disadvantaged_sae_mat_byyear.png", as(png) replace  
//
// 	restore
 
* --- 'disadvantaged' students event study
// 	preserve
//
// 	collapse (count) total_students = mrun (sum) prioritario_def , by(years_to_event group)
//
// 	// disadvantaged students as a % of total enrollment 
// 	gen float pc_prio = prioritario_def/total_students*100
// 	gen float pc_prio_tag = round(prioritario_def/total_students*100, 0.01)
// 	tostring  pc_prio_tag, replace format(%20.0g)
// 	replace   pc_prio_tag = substr(pc_prio_tag, 1,5)
// 	replace   pc_prio_tag = pc_prio_tag+"%"
//
// 	tw (connect pc_prio years_to_event if group == 1)(connect pc_prio years_to_event if group == 2)(connect pc_prio years_to_event if group == 3)(connect pc_prio years_to_event if group == 4) , ///
// 	graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
// 	xtitle("year") ytitle("% disadvantaged") ylabel(,angle(0)) xlabel(#10) legend(order(1 "Group 1" 2 "Group 2" 3 "Group 3" 4 "Group 4") row(1) position(6) size(medium)) note("Note: Group 1: Magallanes region; Group 2: Tarapacá, Coquimbo, O'Higgins and Los Lagos regions; Group 3: Antofagasta, Atacama, Valparaíso, Maule, Biobío, Araucanía, Los Ríos, Arica y Parinacota and Ñuble regions; Group 4: Metropolitan region ", size(tiny) span)
//
// 	gr export "$pathFigures/disadvantaged_mat_bygroup.png", as(png) replace  
//
// 	restore 
 
* ----------------------------------------
* ASIGNACIÓN VS MATRÍCULA
* ----------------------------------------
// 	preserve 
//
// 	keep if in_sae == 1
// 	tostring rbd_matricula, replace 
//	   
// 	keep mrun etapa rbd* year_application
//
// 	gen asignado  = 1        if rbd_asignado != .
// 	replace asignado = 0     if asignado == .
// 	keep if asignado == 1
//
// 	gen same_school = (rbd_asignado == rbd_matricula)
//
// 	collapse (sum) asignado , by(same_school year_application)
// 	gen id = _n 
// 	reshape wide asignado, i(id) j(same_school)
// 	collapse (firstnm) asignado0 asignado1, by(year_application)
//
// 	gen total = asignado0 +  asignado1
// 	gen pc_asignado0 = round(asignado0/total*100, 0.1)
// 	gen pc_asignado1 = round(asignado1/total*100, 0.1)
//
// 	local pc0_2016 : di pc_asignado0[1]
// 	local pc1_2016 : di pc_asignado1[1]
// 	local pc0_2017 : di pc_asignado0[2]
// 	local pc1_2017 : di pc_asignado1[2]
// 	local pc0_2018 : di pc_asignado0[3]
// 	local pc1_2018 : di pc_asignado1[3]
// 	local pc0_2019 : di pc_asignado0[4]
// 	local pc1_2019 : di pc_asignado1[4]
//
// 	file open  sae_assingment using "$pathTables/assignment_consistency.tex", write replace
// 	file write sae_assingment "\begin{table}[ht!]" _n
// 	file write sae_assingment "\centering"_n
// 	file write sae_assingment "\caption{Enrollment consistency among assigned SAS applicants}"_n
// 	file write sae_assingment "\resizebox{13cm}{!}{"_n
// 	file write sae_assingment "\begin{tabular}{l|cccc}"_n
// 	file write sae_assingment "                                   & \multicolumn{4}{c}{Assigned applicants}   \\ "_n
// 	file write sae_assingment "                                   &  2016       & 2017       & 2018       & 2019       \\ \hline "_n
// 	file write sae_assingment "  Enrolled in assigned school (\%)     &  `pc1_2016' & `pc1_2017' & `pc1_2018' & `pc1_2019' \\ "_n
// 	file write sae_assingment "  Not enrolled in assigned school (\%)  &  `pc0_2016' & `pc0_2017' & `pc0_2018' & `pc0_2019'   \\ \hline"_n
// 	file write sae_assingment "\end{tabular} "_n
// 	file write sae_assingment "}"_n
// 	file write sae_assingment "\label{tab:assignment_consistency}"_n
// 	file write sae_assingment "\end{table} "_n
// 	file close sae_assingment
// 	restore 
//
// * ----------------------------------------
// * PATRONES ESTUDIANTES PRIORITARIOS
// * ----------------------------------------
//
// * --- generate supply of schools
// use "$pathData/outputs/sae_oferta_final.dta", clear 
//
// rename lat lat_school 
// rename lon lon_school
//
// merge 1:1 rbd year_application using "$pathData/intermediates/school_quality.dta"
// drop if _m == 2
// drop _m 
// 
// tempfile supply
// save `supply', replace 
//
// * --- generate demand for schools
// use "$pathData/outputs/sae_applications_final.dta", clear 
// tab year_application
//
// collapse (count) applicants = mrun, by(rbd year_application etapa )
// gen id = _n
//
// reshape wide applicants@ , i(id) j(etapa) string
// 
// rename applicantsregular applicants_reg
// rename applicantscomplementaria applicants_comp
//
// collapse (firstnm) applicants_reg applicants_comp, by(rbd year_application)
//
// replace applicants_reg  = 0 if applicants_reg == .
// replace applicants_comp = 0 if applicants_comp == .
//
// * -- merge supply and demand
// merge 1:1 rbd year_application using `supply'
// keep if _m == 3
// drop _m
//
// tempfile supply_demand
// save `supply_demand', replace 
//
// * --- merge applications with student characteristics
// use "$pathData/outputs/sae_applications_final.dta", clear 
//
// merge m:1 mrun year_application using "$pathData/outputs/sae1619_prio1720_mat1720.dta", keepusing(prioritario_def prioritario_sae lat_con_error lon_con_error cod_reg_rbd group)
// keep if _m == 3
// drop _m
// rename *_con_error *_applicant
//
// * --- merge applications with school characteristics
// merge m:1 rbd year_application using `supply_demand'
// drop _m
//
// keep mrun rbd year_application cod_depe prioritario_def applicants* con_copago lat* lon* cupos_* vacantes_* quality_cat preferencia_postulante cod_reg_rbd group
//
// sort year_application mrun preferencia_postulante, stable
//
// * -- create variables to compare
// foreach etapa in reg comp {
// 	gen is_overdemanded_`etapa'    = (applicants_`etapa' > vacantes_`etapa')
// 	gen isnot_overdemanded_`etapa' = (applicants_`etapa' <= vacantes_`etapa')
// 	gen demand_excess_`etapa'      = (applicants_`etapa'- vacantes_`etapa')
// 	gen demand_ratio_`etapa'	   = applicants_`etapa' / vacantes_`etapa'
//
// }
// * --- demanda 
// tw (kdensity demand_ratio_reg if prioritario_def == 0 & demand_ratio_reg<=40, lwidth(0.5))(kdensity demand_ratio_reg if prioritario_def == 1 &demand_ratio_reg<=40, lwidth(0.5)), ///
// graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
// legend(order(1 "Not Disadvantaged" 2 "Disadvantaged") size(4)) xtitle("Applicants-to-Seat ratio") ytitle("")
//
// gr export "$pathFigures/disadvantaged_comparison_demand.png", as(png) replace  
// 
// * --- distance distribution
// geodist lat_school lon_school lat_applicant lon_applicant , g(distance)
// tw (kdensity distance if prioritario_def == 0 & distance <=10, lwidth(0.5))(kdensity distance if prioritario_def == 1 & distance <=10, lwidth(0.5)), ///
// graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
// legend(order(1 "Not Disadvantaged" 2 "Disadvantaged") size(4)) xtitle("Distance (km)") ytitle("")
//
// gr export "$pathFigures/disadvantaged_comparison_distance.png", as(png) replace  
// 
// * --- calidad del EE 
// replace quality_cat = "HIGH" if quality_cat == "ALTO"
// replace quality_cat = "MED-LOW" if quality_cat == "MEDIO-BAJO (NUEVO)"
// replace quality_cat = "MED-LOW" if quality_cat == "MEDIO-BAJO"
// replace quality_cat = "MEDIUM"  if quality_cat == "MEDIO"
// replace quality_cat = "INSUFFICIENT"  if quality_cat == "INSUFICIENTE"
//
// preserve 
//
// collapse (count) mrun, by(quality_cat prioritario_def)
// drop if quality_cat == ""
// drop if quality_cat == "SIN CATEGORIA: BAJA MATRICULA"
// drop if quality_cat == "SIN CATEGORIA: FALTA DE INFORMACIÓN"
//
// bys quality_cat: egen total = sum(mrun)
// gen pc_quality = round(mrun/total*100, 0.1)
//
// * - SORT
// gen aux  = 1      if quality_cat == "HIGH"
// replace aux = 2   if quality_cat == "MEDIUM"
// replace aux = 3   if quality_cat == "MED-LOW"
// replace aux = 4   if quality_cat == "INSUFFICIENT"
//
// gr hbar pc_quality , over(prioritario_def) over(quality_cat, sort(aux)) blabel(pc_quality) asyvars showyvars stack ///
// graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
// legend(order(1 "Not Disadvantaged" 2 "Disadvantaged") size(4)) ytitle("Percent")
//
// gr export "$pathFigures/disadvantaged_comparison_quality.png", as(png) replace  
//
// restore
