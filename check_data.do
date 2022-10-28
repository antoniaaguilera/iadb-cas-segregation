/*
================================================================================
FECHA CREACION: 2022-07-01
ULTIMA MODIFICACION: 2022-07-01 // akac
--------------------------------------------------------------------------------
PROYECTO: Paper Segregación IADB
DESCRIPCIÓN: Revisión de los datos de Perú.
================================================================================
*/


* ----------------------------------------------------------------- *
* ----------------------------- PATHS ----------------------------- *
* ----------------------------------------------------------------- *


if "`c(username)'"=="antoniaaguilera" { // Antonia
  global pathData =  "/Users/antoniaaguilera/ConsiliumBots Dropbox/antoniaaguilera@consiliumbots.com/projects/iadb-macak-paper"
}

br
* --- 2014 --- *
import delimited "$pathData/BD_5/2014/BID_UMC_2P_2014.csv", clear
unique nombre_ie
local colegios_2p_2014 = `r(unique)'
local estudiantes_2p_2014 = `r(N)'
unique departamento
local dptos_2p_2014 = `r(unique)'
unique cod_ugel
local ugel_2p_2014 = `r(unique)'

/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, medida500_l, grupo_l,
peso_l, medida500_m, grupo_m, peso_m
*/

* --- 2015 --- *
import delimited "$pathData/BD_5/2015/BID_UMC_2P_2015.csv", clear
unique nombre_ie
local colegios_2p_2015 = `r(unique)'
local estudiantes_2p_2015 = `r(N)'
unique departamento
local dptos_2p_2015 = `r(unique)'
unique cod_ugel
local ugel_2p_2015 = `r(unique)'
/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, ise, n_ise, medida500_l, grupo_l,
peso_l, medida500_m, grupo_m, peso_m
*/

import delimited "$pathData/BD_5/2015/BID_UMC_2S_2015.csv", clear
unique nombre_ie
local colegios_2s_2015 = `r(unique)'
local estudiantes_2s_2015 = `r(N)'
unique departamento
local dptos_2s_2015 = `r(unique)'
unique cod_ugel
local ugel_2s_2015 = `r(unique)'
/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, ise, n_ise, medida500_l,
grupo_l, ajuste_por_no_respuesta_l,
medida500_m, grupo_m,ajuste_por_no_respuesta_m,
*/


* --- 2016 --- *
import delimited "$pathData/BD_5/2016/BD_ECE_2P_2016.csv", clear
unique nombre_ie
local colegios_2p_2016 = `r(unique)'
local estudiantes_2p_2016 = `r(N)'
unique departamento
local dptos_2p_2016 = `r(unique)'
unique cod_ugel
local ugel_2p_2016 = `r(unique)'
/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, ise, n_ise, medida500_l,
grupo_l, peso_l, medida500_m, grupo_m, peso_m
*/


import delimited "$pathData/BD_5/2016/BD_ECE_2S_2016.csv", clear
unique nombre_ie
local colegios_2s_2016 = `r(unique)'
local estudiantes_2s_2016 = `r(N)'
unique departamento
local dptos_2s_2016 = `r(unique)'
unique cod_ugel
local ugel_2s_2016 = `r(unique)'
/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, ise, n_ise, medida500_l,
grupo_l, ajuste_por_no_respuesta_l, medida500_l, grupo_m,
ajuste_por_no_respuesta_m, medida500_cs, grupo_cs,
ajuste_por_no_respuesta_cs
*/


import delimited "$pathData/BD_5/2016/BD_ECE_4P_2016.csv", clear
unique nombre_ie
local colegios_4p_2016 = `r(unique)'
local estudiantes_4p_2016 = `r(N)'
unique departamento
local dptos_4p_2016 = `r(unique)'
unique cod_ugel
local ugel_4p_2016 = `r(unique)'
/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, ise, n_ise, medida500_l,
grupo_l, ajuste_por_no_respuesta_l, medida500_m, grupo_m,
ajuste_por_no_respuesta_m
*/

* --- 2018 --- *
import delimited "$pathData/BD_5/2018/BD_ECE_2S_2018.csv", clear
unique nombre_ie
local colegios_2s_2018 = `r(unique)'
local estudiantes_2s_2018 = `r(N)'
unique departamento
local dptos_2s_2018 = `r(unique)'
unique cod_ugel
local ugel_2s_2018 = `r(unique)'
/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, ise, n_ise, medida500_l,
grupo_l, ajuste_por_no_respuesta_l, medida500_m, grupo_m,
ajuste_por_no_respuesta_m, medida500_cs, grupo_cs,
ajuste_por_no_respuesta_cs, medida500_cn, grupo_cn,
ajuste_por_no_respuesta_cn
*/

import delimited "$pathData/BD_5/2018/BD_ECE_4P_2018.csv", clear
unique nombre_ie
local colegios_4p_2018 = `r(unique)'
local estudiantes_4p_2018 = `r(N)'
unique departamento
local dptos_4p_2018 = `r(unique)'
unique cod_ugel
local ugel_4p_2018 = `r(unique)'
/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, ise, n_ise, medida500_l,
grupo_l, ajuste_por_no_respuesta_l, medida500_m, grupo_m,
ajuste_por_no_respuesta_m
*/

* --- 2019 --- *
import delimited "$pathData/BD_5/2019/BD_ECE_2S_2019.csv", clear
unique nombre_ie
local colegios_2s_2019 = `r(unique)'
local estudiantes_2s_2019 = `r(N)'
unique departamento
local dptos_2s_2019 = `r(unique)'
unique cod_ugel
local ugel_2s_2019 = `r(unique)'
/*
vars:
año, grado, nivel , id_generado , cod_mod7, anexo, nombre_ie,
id_seccion, seccion, cod_dre, nom_dre, cod_ugel, nom_ugel,
codgeo, departamento, provincia, distrito, gestion2, area,
caracteristica2, sexo, lengua_materna, ise, n_ise, medida500_l,
grupo_l, ajuste_por_no_respuesta_l, medida500_m, grupo_m,
ajuste_por_no_respuesta_m, medida500_cn, grupo_cn, ajuste_por_no_respuesta_cn
*/


file open  tabla1 using "$pathData/tables/revision_ece.tex", write replace
file write tabla1 "\begin{table}" _n
file write tabla1 "\centering"_n
file write tabla1 "\begin{tabular}{lcccc} \hline \hline"_n
file write tabla1 "base                    & año   & grado         & estudiantes           & departamentos    & nº colegios        & nº ugel \\"_n
file write tabla1 "BID\_UMC\_2P\_2014.csv  & 2014  & 2º primaria   & `estudiantes_2p_2014' & `dptos_2p_2014'  & `colegios_2p_2014' & `ugel_2p_2014' \\"_n
file write tabla1 "BID\_UMC\_2P\_2015.csv  & 2015  & 2º primaria   & `estudiantes_2p_2015' & `dptos_2p_2015'  & `colegios_2p_2015' & `ugel_2p_2015' \\"_n
file write tabla1 "BID\_UMC\_2S\_2015.csv  & 2015  & 2º secundaria & `estudiantes_2s_2015' & `dptos_2s_2015'  & `colegios_2s_2015' & `ugel_2s_2015' \\"_n
file write tabla1 "BD\_ECE\_2P\_2016.csv   & 2016  & 2º primaria   & `estudiantes_2p_2016' & `dptos_2p_2016'  & `colegios_2p_2016' & `ugel_2p_2016' \\"_n
file write tabla1 "BD\_ECE\_2S\_2016.csv   & 2016  & 2º secundaria & `estudiantes_2s_2016' & `dptos_2s_2016'  & `colegios_2s_2016' & `ugel_2s_2016' \\"_n
file write tabla1 "BD\_ECE\_4P\_2016.csv   & 2016  & 4º primaria   & `estudiantes_4p_2016' & `dptos_4p_2016'  & `colegios_4p_2016' & `ugel_4p_2016' \\"_n
file write tabla1 "BD\_ECE\_4P\_2018.csv   & 2018  & 4º primaria   & `estudiantes_4p_2018' & `dptos_4p_2018'  & `colegios_4p_2018' & `ugel_4p_2018' \\"_n
file write tabla1 "BD\_ECE\_2S\_2018.csv   & 2018  & 2º secundaria & `estudiantes_2s_2018' & `dptos_2s_2018'  & `colegios_2s_2018' & `ugel_2s_2018' \\"_n
file write tabla1 "BD\_ECE\_2S\_2019.csv   & 2019  & 2º secundaria & `estudiantes_2s_2019' & `dptos_2s_2019'  & `colegios_2s_2019' & `ugel_2s_2019' \\"_n
file write tabla1 "\end{tabular}"_n
file write tabla1 "\label{}"_n
file write tabla1 "\caption{}"_n
file write tabla1 "\end{table}"_n
file close tabla1
