################################################################################
# Proyecto: Aire Analytics
# Fecha última modificación: 2018-07-13
# Código: Instalación de paquetes, definición de funciones y carga de estaciones
################################################################################
#rm(list=ls()) para limpiar el environment

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
if(!is.element("rgdal", installed.packages()[, 1]))
  install.packages("rgdal")
library(rgdal)
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
if(!is.element("rJava", installed.packages()[, 1]))
  install.packages("rJava")
library(rJava)
if(!is.element("jsonlite", installed.packages()[, 1]))
  install.packages("jsonlite")
library(jsonlite)
if(!is.element("XLConnect", installed.packages()[, 1])){install.packages("XLConnect")}
if(!is.element("geosphere", installed.packages()[, 1])){install.packages("geosphere")}
library(XLConnect)
library(geosphere)
require(rJava)
if(!is.element("rPython", installed.packages()[, 1]))
  install.packages("rPython")
library(rPython)
# Funcion de latitud y longitud. Convierte el grados y segundos a decimales.
LatLon<-function(DATAFRAME){
  DATAFRAME <- as.character(DATAFRAME)
  # Grados
  matriz=matrix(unlist(strsplit(DATAFRAME,"º ")),ncol=2,byrow=TRUE)
  grados=as.numeric(matriz[,1])
  # Minutos
  matriz=matrix(unlist(strsplit(matriz[,2],"' ")),ncol=2,byrow=TRUE)
  minutos=as.numeric(matriz[,1])
  # Segundos
  matriz[,2]=gsub(",",".",gsub("\"","",gsub("'","",matriz[,2])))
  segundos=as.numeric(substr(matriz[,2],1,nchar(matriz[,2])-1))
  # Signo
  signo=substr(matriz[,2],nchar(matriz[,2]),nchar(matriz[,2]))
  signo=as.numeric(gsub("O","-1",gsub("E","1",gsub("S","-1",gsub("N","1",signo)))))
  # Latitud o longitud en decimal
  signo*(grados+minutos/60+segundos/3600)
}
#Funcion distancia entre 2 puntos
distancia<-function(Lat1,Lon1,Lat2,Lon2){
  distm(t(rbind(Lat1, Lon1)), t(rbind(Lat2, Lon2)), fun = distHaversine) / 1609
}

#-----------------------------------------------------------
# 1. Lectura de estaciones de calidad del aire
#-----------------------------------------------------------
#Si estaciones.csv existe lee. Si no existe, descarga la info, aplica la función
#que convierte lat y long en decimales y crea el archivo
if (file.exists("../dat/estaciones/estaciones_ayuntamiento.csv")){
  # Lectura de las estaciones
  estaciones_ayuntamiento <- read.csv2("../dat/estaciones/estaciones_ayuntamiento.csv",sep=",")
} else {
  # Descarga de los datos de las estaciones y lee el archivo
  tmp=tempfile(fileext=".xls")
  download.file(url="https://datos.madrid.es/egob/catalogo/212629-0-estaciones-control-aire.xls", destfile=tmp, mode="wb",quiet=TRUE)
  estaciones_ayuntamiento<-readWorksheetFromFile(tmp,sheet=1,startRow=5)
  estaciones_ayuntamiento<-subset(estaciones,!(is.na(estaciones$LONGITUD))&!(is.na(estaciones$LATITUD)))
  estaciones_ayuntamiento$LAT.DD=LatLon(estaciones$LATITUD)
  estaciones_ayuntamiento$LONG.DD=LatLon(estaciones$LONGITUD)
  file.remove(tmp)
  #crea el archivo estaciones.csv para no tener que bajarlo cada vez que se ejecute el código
  write.csv(estaciones_ayuntamiento,file="../dat/estaciones/estaciones_ayuntamiento.csv", sep=";",dec=".",col.names=TRUE,fileEncoding ="utf-8")
}
#head(estaciones_ayuntamiento)
#View(estaciones_ayuntamiento)

estaciones_comunidad <- read.csv2("../dat/estaciones/estaciones_comunidad.csv", dec=",", header=T)
#
#View(estaciones_comunidad)

