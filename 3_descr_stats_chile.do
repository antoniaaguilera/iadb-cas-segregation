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
* STATS GENERALES
* ----------------------------------------
// * --- applicants by region and year
// use "$pathData/outputs/sae_applications_final.dta", clear
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
// gr hbar (sum) postulantes, over(year_application) over(region_name) asyvars stack ///
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
//
// * ----------------------------------------
// * PRIORITARIOS POR AÑO
// * ----------------------------------------
// use "$pathData/outputs/sae1619_prio1619_mat1720.dta", clear 
//
// * --- check consistency of disadvantaged status
// preserve 
// keep if in_sae == 1 & region_insae!="no"
// mdesc prioritario_alu
// replace prioritario_alu = 0 if prioritario_alu == .
//
// gen check_disadvantaged = (prioritario_alu == prioritario_sae)
// tab check_disadvantaged
//
// tab prioritario_alu prioritario_sae
//
// count if prioritario_alu == 0 & prioritario_sae == 0 
// local sae0_alu0 : di %6.0f `r(N)'
//
// count if prioritario_alu == 1 & prioritario_sae == 0 
// local sae0_alu1 : di %6.0f `r(N)'
//
// count if prioritario_alu == 0 & prioritario_sae == 1 
// local sae1_alu0 : di %6.0f `r(N)'
//
// count if prioritario_alu == 1 & prioritario_sae == 1 
// local sae1_alu1 : di %6.0f `r(N)'
//
//
// file open  consistency using "$pathTables/disadvantaged_consistency.tex", write replace
// file write consistency "\begin{table}[ht!]" _n
// file write consistency "\centering"_n
// file write consistency "\caption{Number of disadvantaged students according to SAS application and SEP registry}"_n
// file write consistency "\resizebox{13cm}{!}{"_n
// file write consistency "\begin{tabular}{lc|cc}"_n
// file write consistency "& &\multicolumn{2}{c}{SAS application} \\"_n
// file write consistency "                              &                   & Disadvantaged  & Not Disadvantaged \\ \hline"_n
// file write consistency "\multirow{2}{*}{SEP registry} & Disadvantaged     & `sae1_alu1'    &   `sae0_alu1'  \\"_n
// file write consistency "                              & Not Disadvantaged & `sae1_alu0'    &   `sae0_alu0'  \\"_n
// file write consistency "\end{tabular} "_n
// file write consistency "}"_n
// file write consistency "\label{tab:disadvantaged_consistency}"_n
// file write consistency "\end{table} "_n
// file close consistency
// restore 
//
// * --- applicants with 'disadvantaged' status according to SAE
// preserve 
//
// keep if in_sae == 1 & region_insae!="no"
// mdesc prioritario_alu
//
// collapse (sum) prioritario_alu prioritario_sae in_sae, by(year_application)
//
// gen float pc_prio_sae = prioritario_sae/in_sae*100
// gen float pc_prio_sae_tag = round(prioritario_sae/in_sae*100, 0.01)
// tostring  pc_prio_sae_tag, replace format(%20.0g)
// replace   pc_prio_sae_tag = substr(pc_prio_sae_tag, 1,5)
// replace   pc_prio_sae_tag = pc_prio_sae_tag + "%"
//
// tw (connect pc_prio_sae year_application, mlabel(pc_prio_sae_tag) mlabposition(1)) , ///
// graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
// xtitle("year") ytitle("% applicants classified as disadvantaged") ylabel(#10,angle(0))
//
// gr export "$pathFigures/disadvantaged_sae_byyear.png", as(png) replace  
//
// gen float pc_prio_mat = prioritario_alu/in_sae*100
// gen float pc_prio_mat_tag = round(prioritario_alu/in_sae*100, 0.01)
// tostring  pc_prio_mat_tag, replace format(%20.0g)
// replace   pc_prio_mat_tag = substr(pc_prio_mat_tag, 1,5)
// replace   pc_prio_mat_tag = pc_prio_mat_tag+"%"
//
// tw (connect pc_prio_sae year_application, mlabel(pc_prio_sae_tag) mlabposition(1))(connect pc_prio_mat year_application, mlabel(pc_prio_mat_tag) mlabposition(1)) , ///
// graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
// xtitle("year") ytitle("% applicants classified as disadvantaged") ylabel(#10,angle(0)) legend(order(1 "According to SAS application" 2 "According to SEP registry"))
//
// gr export "$pathFigures/disadvantaged_sae_mat_byyear.png", as(png) replace  
//
// restore
//
// * --- 'disadvantaged' students event study
// preserve
//
// mdesc prioritario_alu
//
// collapse (sum) prioritario_alu in_mat, by(years_to_event group)
//
// // disadvantaged students as a % of total enrollment 
// gen float pc_prio = prioritario_alu/in_mat*100
// gen float pc_prio_tag = round(prioritario_alu/in_mat*100, 0.01)
// tostring  pc_prio_tag, replace format(%20.0g)
// replace   pc_prio_tag = substr(pc_prio_tag, 1,5)
// replace   pc_prio_tag = pc_prio_tag+"%"
//
// tw (connect pc_prio years_to_event if group == 1)(connect pc_prio years_to_event if group == 2)(connect pc_prio years_to_event if group == 3)(connect pc_prio years_to_event if group == 4) , ///
// graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
// xtitle("year") ytitle("% disadvantaged") ylabel(,angle(0)) xlabel(#10) legend(order(1 "Group 1" 2 "Group 2" 3 "Group 3" 4 "Group 4") row(1) position(6) size(medium)) note("Note: Group 1: Magallanes region; Group 2: Tarapacá, Coquimbo, O'Higgins and Los Lagos regions; Group 3: Antofagasta, Atacama, Valparaíso, Maule, Biobío, Araucanía, Los Ríos, Arica y Parinacota and Ñuble regions; Group 4: Metropolitan region ", size(tiny) span)
//
// gr export "$pathFigures/disadvantaged_mat_bygroup.png", as(png) replace  
//
// restore 

* ----------------------------------------
* ASIGNACIÓN VS MATRÍCULA
* ----------------------------------------
use "$pathData/outputs/sae1619_prio1619_mat1720.dta", clear 

keep if in_sae == 1
tostring rbd_sitfinal rbd_matricula, replace 
 
keep mrun etapa rbd* year_application

gen status_sae = "assigned"         if rbd_asignado != "sale-del-proceso" & rbd_asignado != "rechaza-en-regular" & rbd_asignado != "sin-asignacion"
replace status_sae = "not assigned" if status_sae ==""
keep if status_sae == "assigned"

gen     origen_1  = 1 // assigned 

gen     destino_1 = 2 if  (rbd_asignado  == rbd_matricula)  // assigned 
replace destino_1 = 3 if  (rbd_asignado  != rbd_matricula)  //
replace destino_1 = 4 if   rbd_matricula  == "."

gen     origen_2 = 2  if  (rbd_asignado == rbd_matricula)  // assigned 
replace origen_2 = 3  if  (rbd_asignado  != rbd_matricula)  //

gen     destino_2 = 5 if  (rbd_asignado == rbd_matricula) & (rbd_matricula == rbd_sitfinal)
replace destino_2 = 6 if  (rbd_asignado == rbd_matricula) & (rbd_matricula != rbd_sitfinal)

replace destino_2 = 7 if  (rbd_asignado != rbd_matricula) & rbd_matricula!= "." & (rbd_matricula == rbd_sitfinal)
replace destino_2 = 8 if  (rbd_asignado != rbd_matricula) & rbd_matricula!= "." & (rbd_matricula != rbd_sitfinal)

gen id = _n
reshape long origen_@ destino_@, i(id) j(aux) 

collapse (count) mrun, by(origen_ destino_)

rename (origen_ destino_ mrun)(source destination id)
drop if destination == .
export delimited using "$pathTables/sankey.csv", replace



/*
- probar con bases de rendimiento -> CHECK
- dejar colegio en el que está en marzo y el colegio en el que termina el año -> CHECK
- event study: -2, -1, 0, 1, 2 ver si va variando en % de prioritarios
	- para 2015: imputar solo para regiones que empiecen el 2017 ? 
- solo descriptivo 
	- por region 
- queremos mostrar que no pasa nada
- check si hay discrepancia en prioritarios sae vs matricula 
- cambiar prioritario_alu por mismo año (matricula es la única que se corre 1 año)
	- revisar discrepancia 
- participantes sae según matrícula por año 
- % de sae que son prioritarios 
- en overleaf: listado de análisis que se pueden ir haciendo 
- primer dif en dif simple y ver resultados

- prox semana: par de gráficos de análisis
	- discusión de indicadores
	- variable tratamiento: 0 si no se implementó 1 si se implementó
	- enrollment final vs asignación
	- cuanta gente se matrícula en el colegio en el que quedó y cuanta se cambia durante el año (mini análisis de eficiencia en el sistema)
*/

/*
- re hacer con prioritarios del mismo año
- tabla con eficiencia, poner stats
	- cuanta gente postula por año y región y por tipo de EE -> CHECK
	- cuantas postulaciones son prioritario segun sae -> CHECK
- comparación con prioritarios sae vs sep 


- prox semana correr dif en dif simple 
- subir al overleaf los gráficos y la estadística descriptiva
- versión con resultados a fines de nov 
*/






