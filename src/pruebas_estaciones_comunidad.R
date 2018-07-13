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
if (file.exists("../dat/calidad_aire/calidad_ca.csv")){
  # Lectura de las estaciones
  estaciones <- read.csv2("../dat/calidad_aire/calidad_ca.csv",sep=",")
} else {
  calidad_ca.df<-data.frame()
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
  #try(calidad_ca<-read.table(paste("../dat/calidad_aire/",value,"MMA.dat",sep="")))
  #try(calidad_ca.df <- rbind(calidad_ca.df,calidad_ca))
  #unzip(zipfile= "../dat/calidad_aire/calidad_ca.zip" ,e)xdir = "../dat/calidad_aire")
  #file.remove("../dat/calidad_aire/calidad_ca.zip")
  #crea el archivo estaciones.csv para no tener que bajarlo cada vez que se ejecute el código
  #write.csv(estaciones,file="../dat/estaciones/estaciones.csv", sep=";",dec=".",col.names=TRUE,fileEncoding ="utf-8")
  }
  }
}
#separamos valores
calidad_ca.df$cod_estacion <- substr(calidad_ca.df$V1, start = 1, stop = 8)
calidad_ca.df$prov <- substr(calidad_ca.df$cod_estacion, start = 1, stop = 2)
calidad_ca.df$municipio <- substr(calidad_ca.df$cod_estacion, start = 3, stop = 5)
calidad_ca.df$estacion <- substr(calidad_ca.df$V1, start = 6, stop = 8)
calidad_ca.df$parametro <- substr(calidad_ca.df$V1, start = 9, stop = 11)
calidad_ca.df$tecnica <- substr(calidad_ca.df$V1, start = 12, stop = 14)
calidad_ca.df$perioricidad <- substr(calidad_ca.df$V1, start = 15, stop = 16)
calidad_ca.df$fecha <- substr(calidad_ca.df$V1, start = 17, stop = 22)
calidad_ca.df$valor1 <- substr(calidad_ca.df$V1, start = 23, stop = 29)
calidad_ca.df$validacion1 <- substr(calidad_ca.df$V1, start = 30, stop = 31)
calidad_ca.df$valor2 <- substr(calidad_ca.df$V1, start = 32, stop = 38)
calidad_ca.df$validacion2 <- substr(calidad_ca.df$V1, start = 39, stop = 41)
#subset de los valores válidos V25=V
calidad_ca.df <- calidad_ca.df[ which(calidad_ca.df$V25=='V'),]
#convertimos a numéricos los valores de las mediciones horarias
calidad_ca.df$valor1 <- as.numeric(calidad_ca.df$valor1)
for(i in 2:24)
  calidad_ca.df[,i]<-substr(calidad_ca.df[,i], start = 2, stop = 8)
for(i in 2:24)
  calidad_ca.df[,i] <- as.numeric(as.character(calidad_ca.df[,i]))
View(calidad_ca.df)


