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

collapse (mean) prioritario_def (firstnm) cod_reg_rbd region_insae D_*, by(cod_com_rbd year_application)

* --- compare coefficients
//tw (kdensity D_assigned)(kdensity D_enrolled)

* --------------------------------------------------------------------------------
* DIFFERENCE IN DIFFERENCE 
* --------------------------------------------------------------------------------
/*
Cuando ya tienes en duncan para cada año y comuna, hay que correr un DinD. 
Partamos con lo mas simple, donde el duncan es la variable dependiente y 
agregando un efecto fijo de año y region (y errores estandar clusterizados 
a nivel de region)
*/
gen is_insae = (region_insae != "no")
*https://www.stata.com/new-in-stata/difference-in-differences-DID-DDD/#:~:text=Difference%20in%20differences%20(DID)%20offers,the%20name%20difference%20in%20differences.
didregress (D_assigned) (is_insae), group(cod_reg_rbd) time(year_application)

* --- 
sum D_assigned if 
*save "$pathData/outputs/for_did.dta", replace
