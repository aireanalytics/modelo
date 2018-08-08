##########################################################################
# Proyecto: Aire Analytics
# Fecha última modificación: 2018-07-03
# Código: datos calidad del aire
##########################################################################
#------------------------------------
rango_temp <- c()
meses<-c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
anos<-c("2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018")
for (value1 in anos){
  print(value1)
  for (value2 in meses){
    print(value2)
   #prueba <- paste(value1,value2,sep="")
   rango_temp <- c(paste(value1,value2,sep=""), rango_temp)
  }
}

print(rango_temp)
if (file.exists("../dat/calidad_aire/aire_comunidad")){
  # Lectura de las estaciones
  estaciones <- read.csv2("../dat/calidad_aire/aire_comunidad.csv",sep=",")
} else {
  calidad_comunidad.df<-data.frame()
  for (value in rango_temp){
    if (file.exists(paste("../dat/calidad_aire/",value,"MMA.dat",sep=""))){
    } else {
  url4 <-paste("http://gestiona.madrid.org/ICMdownload/",value,"MMA.dat",sep="")
  #fichero4 <- paste0(tempfile(), ".xls")
  fichero4 <- paste0(tempfile(), ".dat")
  fichero4
  try(download.file(url4, destfile = fichero4))
  try(my.file.rename(from = fichero4,
                 to = paste("../dat/calidad_aire/",value,"MMA.dat",sep="")))
                 #try(calidad_comunidad<-read.table(paste("../dat/calidad_aire/",value,"MMA.dat",sep="")))
  #try(calidad_comunidad.df <- rbind(calidad_comunidad.df,calidad_comunidad))
  #unzip(zipfile= "../dat/calidad_aire/calidad_ca.zip" ,e)xdir = "../dat/calidad_aire")
  #file.remove("../dat/calidad_aire/calidad_ca.zip")
  #crea el archivo estaciones.csv para no tener que bajarlo cada vez que se ejecute el código
  #write.csv(estaciones,file="../dat/estaciones/estaciones.csv", sep=";",dec=".",col.names=TRUE,fileEncoding ="utf-8")
  }
  }
}
#separamos valores
calidad_comunidad.df$cod_estacion <- substr(calidad_comunidad.df$V1, start = 1, stop = 8)
calidad_comunidad.df$prov <- substr(calidad_comunidad.df$cod_estacion, start = 1, stop = 2)
calidad_comunidad.df$municipio <- substr(calidad_comunidad.df$cod_estacion, start = 3, stop = 5)
calidad_comunidad.df$estacion <- substr(calidad_comunidad.df$V1, start = 6, stop = 8)
calidad_comunidad.df$parametro <- substr(calidad_comunidad.df$V1, start = 9, stop = 11)
calidad_comunidad.df$tecnica <- substr(calidad_comunidad.df$V1, start = 12, stop = 14)
calidad_comunidad.df$perioricidad <- substr(calidad_comunidad.df$V1, start = 15, stop = 16)
calidad_comunidad.df$fecha <- substr(calidad_comunidad.df$V1, start = 17, stop = 22)
calidad_comunidad.df$valor1 <- substr(calidad_comunidad.df$V1, start = 23, stop = 29)
calidad_comunidad.df$validacion1 <- substr(calidad_comunidad.df$V1, start = 30, stop = 31)
calidad_comunidad.df$valor2 <- substr(calidad_comunidad.df$V1, start = 32, stop = 38)
calidad_comunidad.df$validacion2 <- substr(calidad_comunidad.df$V1, start = 39, stop = 41)
#subset de los valores válidos V25=V
calidad_comunidad.df <- calidad_comunidad.df[ which(calidad_comunidad.df$V25=='V'),]
#convertimos a numéricos los valores de las mediciones horarias
calidad_comunidad.df$valor1 <- as.numeric(calidad_comunidad.df$valor1)
for(i in 2:24)
  calidad_comunidad.df[,i]<-substr(calidad_comunidad.df[,i], start = 2, stop = 8)
for(i in 2:24)
  calidad_comunidad.df[,i] <- as.numeric(as.character(calidad_comunidad.df[,i]))
View(calidad_comunidad.df)

if(!is.element("rvest", installed.packages()[, 1]))
  install.packages("rvest")
library(rvest)
if(!is.element("stringr", installed.packages()[, 1]))
  install.packages("stringr")
library(stringr)
page <- read_html("http://gestiona.madrid.org/azul_internet/run/j/InformExportacionAccion.icm?ESTADO_MENU=8")

calidad_comunidad.df<-data.frame()
for (value in rango_temp){
    try(calidad_comunidad<-read.table(paste("../dat/calidad_aire/",value,"MMA.dat",sep="")))
    try(calidad_comunidad.df <- rbind(calidad_comunidad.df,calidad_comunidad))
}

#separamos valores
calidad_comunidad.df$cod_estacion <- substr(calidad_comunidad.df$V1, start = 1, stop = 8)
calidad_comunidad.df$prov <- substr(calidad_comunidad.df$cod_estacion, start = 1, stop = 2)
calidad_comunidad.df$municipio <- substr(calidad_comunidad.df$cod_estacion, start = 3, stop = 5)
calidad_comunidad.df$estacion <- substr(calidad_comunidad.df$V1, start = 6, stop = 8)
calidad_comunidad.df$parametro <- substr(calidad_comunidad.df$V1, start = 9, stop = 11)
calidad_comunidad.df$tecnica <- substr(calidad_comunidad.df$V1, start = 12, stop = 14)
calidad_comunidad.df$perioricidad <- substr(calidad_comunidad.df$V1, start = 15, stop = 16)
calidad_comunidad.df$fecha <- substr(calidad_comunidad.df$V1, start = 17, stop = 22)
calidad_comunidad.df$valor1 <- substr(calidad_comunidad.df$V1, start = 23, stop = 29)
calidad_comunidad.df$validacion1 <- substr(calidad_comunidad.df$V1, start = 30, stop = 31)
calidad_comunidad.df$valor2 <- substr(calidad_comunidad.df$V1, start = 32, stop = 38)
calidad_comunidad.df$validacion2 <- substr(calidad_comunidad.df$V1, start = 39, stop = 41)
#subset de los valores válidos V25=V
calidad_comunidad.df <- calidad_comunidad.df[ which(calidad_comunidad.df$V25=='V'),]
#convertimos a numéricos los valores de las mediciones horarias
calidad_comunidad.df$valor1 <- as.numeric(calidad_comunidad.df$valor1)
for(i in 2:24)
  calidad_comunidad.df[,i]<-substr(calidad_comunidad.df[,i], start = 2, stop = 8)
for(i in 2:24)
  calidad_comunidad.df[,i] <- as.numeric(as.character(calidad_comunidad.df[,i]))
#filtro contaminantes: 1 (SO2), 3 (PM's), 12 (NOx), 14 (O3)
calidad_comunidad.df<-calidad_comunidad.df[(calidad_comunidad.df$parametro %in% c("001", "012", "014", "003")), ]
View(calidad_comunidad.df)
calidad_comunidad.df <- calidad_comunidad.df %>% mutate( V1 = valor1 )
#eliminamos valores negativos
calidad_comunidad.df <- calidad_comunidad.df %>% mutate_all(funs(replace(., .<0, 0)))
#eliminamos las filas con NA's
#calidad_comunidad.df <- calidad_comunidad.df[complete.cases(calidad_comunidad.df), ]
calidad_comunidad.df$validacion1 <- NULL
calidad_comunidad.df$validacion2 <- NULL
calidad_comunidad.df$valor2 <- NULL
calidad_comunidad.df$valor1 <- NULL

medias<-data.frame()
medias<-aggregate(calidad_comunidad.df[,1:24], list(calidad_comunidad.df$parametro), mean)
ggplot(promedio_horario_so2)
View(medias)
#representación
library(ggplot2)
library(lubridate)
theme_set(theme_bw())
#dia<-seq(1,24,1)
#attach(mtcars)
par(mfrow=c(3,1)) 
p1<-plot(x=seq(1,24,1),y=medias[1,2:25], type="l", xlab="hora", ylab=expression(paste(mu,"g/m3")), main = "Concentración SO2")
p2<-plot(x=seq(1,24,1),y=medias[2,2:25], type="l", xlab="hora", col="red", ylab=expression(paste(mu,"g/m3")),main = "Concentración NOx")
p3<-plot(x=seq(1,24,1),y=medias[3,2:25], type="l", xlab="hora", col="blue", ylab=expression(paste(mu,"g/m3")), main = "Concentración O3")




