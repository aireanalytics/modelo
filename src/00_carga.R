##########################################################################
# Proyecto: Aire Analytics
# Fecha última modificación: 2018-07-01
# Código: Instalación de paquetes y carga de estaciones
##########################################################################

#-----------------------------------------------------------
# 0. Incorporamos los paquetes que van a ser necesarios
#-----------------------------------------------------------
if(!is.element("raster", installed.packages()[, 1]))
install.packages("raster")
library(raster)
if(!is.element("rgeos", installed.packages()[, 1]))
install.packages("rgeos")
library(rgeos)
if(!is.element("dismo", installed.packages()[, 1]))
install.packages("dismo")
library(dismo)
if(!is.element("leaflet", installed.packages()[, 1]))
install.packages("leaflet")
library(leaflet)
if(!is.element("openair", installed.packages()[, 1]))
install.packages("openair", dep=TRUE)
library(openair)
if(!is.element("ggplot2", installed.packages()[, 1]))
  install.packages("ggplot2", dep=TRUE)
library(ggplot2)
if(!is.element("ggmap", installed.packages()[, 1]))
  install.packages("ggmap", dep=TRUE)
library(ggmap)
if(!is.element("ggmap", installed.packages()[, 1]))
  install.packages("ggmap", dep=TRUE)
library(ggmap)
#-----------------------------------------------------------
# 1. Lectura de estaciones de calidad del aire
#-----------------------------------------------------------
estaciones <- read.csv2("../dat/estaciones.csv")
head(estaciones)
View(estaciones)
