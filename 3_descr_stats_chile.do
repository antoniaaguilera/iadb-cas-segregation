/*
================================================================================
FECHA CREACION: 2022_10_14 // akac
ULTIMA MODIFICACION: 2022_10_27 // akac
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
preserve 

keep if in_sae == 1
tostring rbd_matricula, replace 
   
keep mrun etapa rbd* year_application

gen asignado  = 1        if rbd_asignado != "sale-del-proceso" & rbd_asignado != "rechaza-en-regular" & rbd_asignado != "sin-asignacion"
replace asignado = 0     if asignado == .
keep if asignado == 1

gen same_school = (rbd_asignado == rbd_matricula)

collapse (sum) asignado , by(same_school year_application)
gen id = _n 
reshape wide asignado, i(id) j(same_school)
collapse (firstnm) asignado0 asignado1, by(year_application)

gen total = asignado0 +  asignado1
gen pc_asignado0 = round(asignado0/total*100, 0.1)
gen pc_asignado1 = round(asignado1/total*100, 0.1)

local pc0_2016 : di pc_asignado0[1]
local pc1_2016 : di pc_asignado1[1]
local pc0_2017 : di pc_asignado0[2]
local pc1_2017 : di pc_asignado1[2]
local pc0_2018 : di pc_asignado0[3]
local pc1_2018 : di pc_asignado1[3]
local pc0_2019 : di pc_asignado0[4]
local pc1_2019 : di pc_asignado1[4]

file open  sae_assingment using "$pathTables/assignment_consistency.tex", write replace
file write sae_assingment "\begin{table}[ht!]" _n
file write sae_assingment "\centering"_n
file write sae_assingment "\caption{Enrollment consistency among assigned SAS applicants}"_n
file write sae_assingment "\resizebox{13cm}{!}{"_n
file write sae_assingment "\begin{tabular}{l|cccc}"_n
file write sae_assingment "                                   & \multicolumn{4}{c}{Assigned applicants}   \\ "_n
file write sae_assingment "                                   &  2016       & 2017       & 2018       & 2019       \\ \hline "_n
file write sae_assingment "  Enrolled in assigned school (\%)     &  `pc1_2016' & `pc1_2017' & `pc1_2018' & `pc1_2019' \\ "_n
file write sae_assingment "  Not enrolled in assigned school (\%)  &  `pc0_2016' & `pc0_2017' & `pc0_2018' & `pc0_2019'   \\ \hline"_n
file write sae_assingment "\end{tabular} "_n
file write sae_assingment "}"_n
file write sae_assingment "\label{tab:assignment_consistency}"_n
file write sae_assingment "\end{table} "_n
file close sae_assingment
restore 


/*
nov18 
- actualizar estad desc con prioritario_def :falta grafico por dependencia 
- definir indicador socioeconómico (check) y zona geográfica
	- potencialmente definición de mercados educacionales
- histograma de como quedan los prioritarios por comuna
	- ver si hay lugares donde hayan pocos alumnos, para sacarlos de la muestra 
- FALTA HACER EL DUNCAN Y EL HIST
*/





