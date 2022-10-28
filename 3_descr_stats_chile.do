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


use "$pathData/outputs/sae20162019_mat20172020.dta", clear 
* ----------------------------------------
* PRIORITARIOS POR AÑO
* ----------------------------------------
preserve
collapse (sum) mat_total prioritario_alu preferente_alu prioritario_sae insae inmat, by(year)

// prioritarios como % de la matrícula total de cada año 
gen float pc_prio_mat = round(prioritario_alu/inmat*100, 0.01)
tostring  pc_prio_mat, replace format(%20.0g)
replace   pc_prio_mat = substr(pc_prio_mat, 1,5)
replace   pc_prio_mat = pc_prio_mat+"%"

// % de la matrícula total que es prioritario (desde la base matrícula)
tw (connect inmat year)(connect prioritario_alu year, mlabel(pc_prio_mat) mlabposition(1)) , ///
graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) scheme(538) ///
legend(order(1 "Matrícula 1º básico" 2 "Prioritarios 1º básico") row(1) position(6)) xtitle("Año") ytitle("Número de estudiantes")

gr export "$pathFigures/mat_prio_byyear.png", as(png) replace 

// prioritarios como % de postulantes sae
gen float pc_prio_sae = round(prioritario_sae/insae*100, 0.01)
tostring  pc_prio_sae, replace format(%20.0g)
replace   pc_prio_sae = substr(pc_prio_sae, 1,5)
replace   pc_prio_sae = pc_prio_sae + "%"

// % de la matrícula total que es prioritario (desde la base matrícula)
tw (connect insae year)(connect prioritario_sae year, mlabel(pc_prio_sae) mlabposition(1)) , ///
graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) scheme(538) ///
legend(order(1 "Postulantes 1º básico" 2 "Prioritarios Postulantes 1º básico") row(1) position(6)) xtitle("Año") ytitle("Número de estudiantes")

gr export "$pathFigures/sae_prio_byyear.png", as(png) replace 
restore

* ----------------------------------------
* SEGÚN AÑO
* ----------------------------------------
*preserve

// prioritarios como % de la matrícula total de cada año 
gen float pc_prio_mat = round(prioritario_alu/inmat*100, 0.01)
tostring  pc_prio_mat, replace format(%20.0g)
replace   pc_prio_mat = substr(pc_prio_mat, 1,5)
replace   pc_prio_mat = pc_prio_mat+"%"

 
tw (connect prioritario_alu year if region_insae == "no"        , mlabel(pc_prio_mat) mlabposition(1))   /// 
   (connect prioritario_alu year if region_insae == "only_entry", mlabel(pc_prio_mat) mlabposition(1))   ///
   (connect prioritario_alu year if region_insae == "all_grades", mlabel(pc_prio_mat) mlabposition(1)) , ///
graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) scheme(538) ///
legend(order(1 "No SAE" 2 "Sólo Entrada" 3 "Todos los cursos") row(1) position(6)) xtitle("Año") ytitle("Número de estudiantes") title("Prioritarios")

gr export "$pathFigures/mat_prio_bysae.png", as(png) replace 

restore


/*
Notas:
- agregar donde fue asignado 
- 1: estad desc SAE por año 
* ojo que no todos los estudiantes de matricula me van a pegar con SAE (es obvio pero es por regiones)
- 3: prioritarios por SAE y no SAE
	- opcion 1: sacar magallanes 
	- tomar esta decision después 
- 4: agregar 
- 5: postulaciones sae prioritarios vs no prioritarios
	- revisar si hay estudiantes que se cambiaron a prioritarios (antes del inicio de SAE)
	- graficar por año, separando regiones con año que son nuevos en el sae 
- 6: cuanta gente de 1ro básico que queda asignada a un colegio termina yendo a otro colegio
- 7: descriptivo
- 8: 
para diciembre bien preliminar, 
	

*/
/*
dudas para la reu 13oct
- qué hago con los que están en sae y no en matrícula 
- agrego info agregada de vacantes? (col tot_vacantes, tot_asignados?)
*/

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
- disadvantaged students (prioritarios)
- revisar formato gráfico 
*/
