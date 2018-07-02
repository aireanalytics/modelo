##########################################################################
# Proyecto: Aire Analytics
# Fecha última modificación: 2018-06-30
# Código: mapas de los municipios y barrios de Madrid
##########################################################################
#Cargamos librerías
library(rgeos)
library(sp)
library(rgdal)
library(RColorBrewer)
library(ggplot2)
library(ggmap)
#-----------------------------------------------------------
# 1. Incorporamos municipios de Madrid
#-----------------------------------------------------------
#leemos los municipios de toda España.
#url:"http://opendata.esri.es/datasets/53229f5912e04f1ba6dddb70a5abeb72_0"
municipios_espanha <- readOGR(dsn="../dat/municipios_IGN",layer="municipios_IGN")
#los municicipios de la Comunidad de Madrid son del tipo  CODNUT2 LIKE 'ES30'
municipios<-municipios_espanha[municipios_espanha@data$CODNUT2=="ES30",]
plot(municipios)

#-----------------------------------------------------------
# 2. Incorporamos municipios de Madrid
#-----------------------------------------------------------
#Usamos longitudes y latitudes como primera y segunda columnas, respectivamente.
estacionesdf <- data.frame(Longitude = estaciones$LONG.DD,
                         Latitude =estaciones$LAT.DD,
                         names = estaciones$NUMERO)
#Obtenemos las coordenadas de las estaciones.
coordinates(estacionesdf) <- ~ Latitude + Longitude
#Determinamos la proyección del objeto SpatialPointsDataFrame usando la proyección del shapefile.
proj4string(estacionesdf) <- proj4string(municipios)
over(estacionesdf, municipios)
over(municipios, estacionesdf)
plot(municipios)
points(estacionesdf$Latitude ~ estacionesdf$Longitude, col = "red", cex = 1)


#-----------------------------------------------------------
# 3. Mapa de Madrid ciudad con las estaciones de medición
#-----------------------------------------------------------
# Las estaciones están dentro de la ciudad de Madrid, por lo que centramos el estudio a la ciudad.
ciudad <- get_map("Madrid, España", zoom=11)
p     <- ggmap(ciudad)
p + geom_point(data = estaciones, 
               aes(x = estaciones$LONG.DD, y = estaciones$LAT.DD), 
               color = "red", 
               size  =5, 
               alpha = 0.8) + geom_text(data = estaciones, aes(LONG.DD, LAT.DD, label = NUMERO), size = 3,
                                        box.padding = unit(0.1, 'lines'), force = 0.5)

#-----------------------------------------------------------
# 4. Incorporamos barrios de la ciudad de Madrid
# url_interesante: http://www.nickeubank.com/wp-content/uploads/2015/10/RGIS3_MakingMaps_part1_mappingVectorData.html
#-----------------------------------------------------------
#Descargamos los barrios de Madrid Ciudad
#url: "https://datos.madrid.es/egob/catalogo/200078-10-distritos-barrios.zip"
barrios <- readOGR(dsn="../dat/shp_etrs89",layer="BARRIOS")
base.map <- gmap(barrios, type = "terrain")
reprojected.barrios <- spTransform(barrios, base.map@crs)
plot(base.map)
points(estaciones$LONG.DD,estaciones$LAT.DD,col="red",pch=16)
plot(reprojected.barrios, add = T, border = "black", col = "transparent")
#código para representar los puntos de las estaciones sobre este mapa--> FALTA
points(estaciones$mean_lon, estaciones$mean_lat,col="red", pch=20, cex=5)

#-----------------------------------------------------------
# 5. Centroides de cada barrio
#-----------------------------------------------------------
trueCentroids = gCentroid(barrios,byid=TRUE)
plot(barrios)
points(coordinates(barrios),pch=3,col="red")
head(coordinates(trueCentroids))
#en el siguiente .R se realizará el mallado de esta zona
