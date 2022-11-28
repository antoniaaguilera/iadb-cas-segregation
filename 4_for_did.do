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
* DUNCAN INDEX 
* --------------------------------------------------------------------------------
use "$pathData/outputs/sae1619_prio1720_mat1720.dta", clear 
drop if rbd_matricula == .

* ---  treated 
gen treated = 1        if group == 1 & year_application > 2016 
replace treated = 1    if group == 2 & year_application > 2017
replace treated = 1    if group == 3 & year_application > 2018
replace treated = 1    if group == 4 & year_application > 2019 
replace treated = 0    if treated == .

* --- gen school variables 
gen school_enrolled = rbd_matricula
gen school_assigned = rbd_matricula 
replace school_assigned = rbd_asignado   if rbd_asignado != .

/*
- school_enrolled has more missings than school_assigned because:
	- school_enrolled missings are students that are present in the SAE db but not in the Enrollment db.
	- school_assigned missings are students that are present in the Enrollment db but not in the SAE db, might be private school students.
*/

* --- duncan index
sort cod_com_rbd year_application
by cod_com_rbd  year_application: duncan2 school_enrolled prioritario_def, d(D_enrolled) nobs(D_enrolled_N)
by cod_com_rbd  year_application: duncan2 school_assigned prioritario_def, d(D_assigned) nobs(D_assigned_N)

collapse (mean) treated prioritario_def (firstnm) cod_reg_rbd region_insae D_*, by(cod_com_rbd year_application)
 
* --- compare coefficients
tw (kdensity D_assigned)(kdensity D_enrolled), ///
graphr(fc(white) lcolor(white) ilcolor(white)  lwidth(thick) margin(r+5)) bgcolor(white) plotr(style(none) fc(white) lcolor(white) lwidth(thick)) ///
legend(order(1 "School Assigned" 2 "School Enrolled") size(4))  ytitle("Duncan Index")

gr export "$pathFigures/duncan_distribution.png", as(png) replace  
 

* --------------------------------------------------------------------------------
* DIFFERENCE IN DIFFERENCE 
* --------------------------------------------------------------------------------

*https://www.stata.com/new-in-stata/difference-in-differences-DID-DDD/#:~:text=Difference%20in%20differences%20(DID)%20offers,the%20name%20difference%20in%20differences.
* - ASSIGNED
*didregress (D_assigned) (treated), group(cod_reg_rbd) time(year_application)
reghdfe D_assigned treated i.year_application, absorb(cod_reg_rbd year_application) vce(cluster cod_reg_rbd)

local N_assigned = `e(N)'
mat b_assigned = e(b)
mat V_assigned = e(V)
local coef_assigned = round(b_assigned[1,1], 0.0001)
local se_assigned = round(V_assigned[1,1]^0.5, 0.000001)
local p_assigned  = 2*ttail(`e(df_r)',abs(b_assigned[1,1]/V_assigned[1,1]^0.5))
local r2_assigned = round(`e(r2_a)', 0.0001)

if `p_assigned' <= 0.01 {
	local star_assigned "***"
			}
else if `p_assigned'>0.01 & `p_assigned'<=0.05 {
	local star_assigned "**"
			}
else if `p_assigned'>0.05 & `p_assigned'<=0.1 {
	local star_assigned "*"
			}
else {
	local star_assigned ""
}


* - ENROLLED
*didregress (D_enrolled) (treated), group(cod_reg_rbd) time(year_application)
reghdfe D_enrolled treated i.year_application, absorb(cod_reg_rbd year_application) vce(cluster cod_reg_rbd)
local N_enrolled = `e(N)'
mat   b_enrolled = e(b)
mat   V_enrolled = e(V)
local coef_enrolled = round(b_enrolled[1,1], 0.0001)
local se_enrolled = round(V_enrolled[1,1]^0.5, 0.000001)
local p_enrolled  = 2*ttail(`e(df_r)',abs(b_enrolled[1,1]/V_enrolled[1,1]^0.5))
local r2_enrolled = round( `e(r2_a)', 0.0001)


if `p_enrolled' <= 0.01 {
	local star_enrolled "***"
			}
else if `p_enrolled'>0.01 & `p_enrolled'<=0.05 {
	local star_enrolled "**"
			}
else if `p_enrolled'>0.05 & `p_enrolled'<=0.1 {
	local star_enrolled "*"
			}
else {
	local star_enrolled ""
}


file open  did using "$pathTables/did_preliminary.tex", write replace
file write did "\begin{table}[h!]\centering\caption{Impact of SAE on school segregation}\scalebox{1}{\label{table:sae}\begin{tabular}{lcc} \hline \hline" _n
file write did " & (1) & (2) \\"_n
file write did "             & Assignment   & Enrollment   \\ \hline"_n
file write did "             &              &              \\"_n
file write did "SAE dummy    & `coef_assigned'`star_assigned' & `coef_enrolled'`star_enrolled' \\"_n
file write did "             & (`se_assigned')   & (`se_enrolled')            \\"_n
file write did "& &\\"_n
file write did "Controls     & \checkmark       & \checkmark       \\"_n
file write did "Observations & `N_assigned' & `N_enrolled' \\"_n
file write did "R-squared    & `r2_assigned' & `r2_enrolled'   \\ \hline \hline"_n
file write did "\multicolumn{3}{c}{ Robust standard errors in parentheses} \\"_n
file write did "\multicolumn{3}{c}{ *** p$<$0.01, ** p$<$0.05, * p$<$0.1} \\"_n
file write did "\multicolumn{3}{c}{ \begin{minipage}{10 cm}{\footnotesize{Notes: All regressions include region and year FE. Standard errors are clustered at the region level.}}"_n
file write did "\end{minipage}} \\"_n
file write did "\end{tabular}}\end{table}"_n
file close did


