##########################################################################
# Proyecto: Aire Analytics
# Fecha última modificación: 2018-07-14
# Código: mapas de los municipios y barrios de Madrid
##########################################################################
#Cargamos librerías
library(rgeos)
library(sp)
library(rgdal)
library(RColorBrewer)
library(ggplot2)
library(ggmap)
#función para mover archivo de una ruta a otra
my.file.rename <- function(from, to) {
  todir <- dirname(to)
  if (!isTRUE(file.info(todir)$isdir)) dir.create(todir, recursive=TRUE)
  file.rename(from = from,  to = to)
}
#-------------------------------------------------------------------------
# 1. Incorporamos municipios de España y filtramos los de la CA de Madrid
#-------------------------------------------------------------------------
#Si el shp de municipios existe, sale. Si no existe, lo descarga
if (file.exists("../dat/shapefiles/municipios/Municipios_IGN.shp")){
  # sale del bucle sin hacer nada
} else {
  #crea un zip, descarga la info, movemos el zip de la ruta temporal a nuestro dat/shapefiles,
  #descomprimimos y borramos el .zip creado
  url1 <-"https://opendata.arcgis.com/datasets/53229f5912e04f1ba6dddb70a5abeb72_0.zip"
  fichero1 <- paste0(tempfile(), ".zip")
  fichero1
  download.file(url1, destfile = fichero1)
  my.file.rename(from = fichero1,
          to = "../dat/shapefiles/municipios.zip")
  unzip(zipfile= "../dat/shapefiles/municipios.zip" ,exdir = "../dat/shapefiles/municipios")
  file.remove("../dat/shapefiles/municipios.zip")
}
#leemos los municipios de toda España.
municipios_espanha <- readOGR(dsn="../dat/shapefiles/municipios",layer="Municipios_IGN")
#los municicipios de la Comunidad de Madrid son del tipo  CODNUT2 LIKE 'ES30'
municipios<-municipios_espanha[municipios_espanha@data$CODNUT2=="ES30",]
plot(municipios)

estaciones_ayuntamiento$LAT.DD <- as.numeric(as.character(estaciones_ayuntamiento$LAT.DD))
estaciones_ayuntamiento$LONG.DD <- as.numeric(as.character(estaciones_ayuntamiento$LONG.DD))
estaciones_comunidad$LATITUD <- as.numeric(as.character(estaciones_comunidad$LATITUD))
estaciones_comunidad$LONGITUD <- as.numeric(as.character(estaciones_comunidad$LONGITUD))
#-----------------------------------------------------------
# 2. Ploteamos las estaciones de medición de la capital
#-----------------------------------------------------------
#Usamos longitudes y latitudes como primera y segunda columnas, respectivamente.
estacionesdf1 <- data.frame(Longitude = estaciones_ayuntamiento$LONG.DD,
                         Latitude =estaciones_ayuntamiento$LAT.DD,
                         names = estaciones_ayuntamiento$NÚMERO)
estacionesdf2 <- data.frame(Longitude = estaciones_comunidad$LONGITUD,
                           Latitude =estaciones_comunidad$LATITUD,
                           names = estaciones_comunidad$COD_ESTACIÓN)
estacionesdf <-rbind(estacionesdf1,estacionesdf2)
#Obtenemos las coordenadas de las estaciones.
coordinates(estacionesdf) <- ~ Latitude + Longitude
#Determinamos la proyección del objeto SpatialPointsDataFrame usando la proyección del shapefile.
proj4string(estacionesdf) <- proj4string(municipios)
over(estacionesdf, municipios)
over(municipios, estacionesdf)
plot(municipios)
points(estacionesdf$Latitude ~ estacionesdf$Longitude, col = "red", cex = 1)


#-----------------------------------------------------------
# Como es lógico, están dentro de la ciudad de Madrid,
# ya que son las estaciones dentro de la capital
# 3. Centramos el foco a la ciudad que es la zona objetivo
#-----------------------------------------------------------
#icono para mostrar sobre el mapa
greenLeafIcon <- makeIcon(
  iconUrl = "https://openclipart.org/image/2400px/svg_to_png/177826/color-icons-green-home.png",
  iconWidth = 25, iconHeight = 35,
  iconAnchorX = 22, iconAnchorY = 94,
  # shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
  #shadowWidth = 50, shadowHeight = 64,
  #shadowAnchorX = 4, shadowAnchorY = 62
)
#municipios@proj4string <-CRS("+init=epsg:3857")
#municipios <- spTransform(municipios,  CRS("+ellps=WGS84 +proj=longlat +datum=WGS84 +no_defs"))

#estacionesdf$Latitude ~ estacionesdf$Longitude
leaflet(data = estacionesdf) %>% addTiles() %>%
  addMarkers(~ estacionesdf$Longitude, estacionesdf$Latitude, icon = greenLeafIcon)%>%
  #addMarkers(~estaciones_comunidad$LONGITUD, ~estaciones_comunidad$LAT, icon = greenLeafIcon)%>%
  addPolygons(data = municipios, stroke = TRUE, weight = 1, opacity = 0.5, fill = TRUE, fillOpacity = 0.2)

#addPolygons(map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
#    stroke = TRUE, color = "#03F", weight = 5, opacity = 0.5,
#    fill = TRUE, fillColor = color, fillOpacity = 0.2, dashArray = NULL,
#    smoothFactor = 1, noClip = FALSE, popup = NULL, popupOptions = NULL,
#     label = NULL, labelOptions = NULL, options = pathOptions(),
#-----------------------------------------------------------
# 4. El objetivo es obtener un mallado de la ciudad de Madrid. Para esto:
#    - Incorporaremos los barrios de la ciudad de Madrid 
#      url_interesante: http://www.nickeubank.com/wp-content/uploads/2015/10/RGIS3_MakingMaps_part1_mappingVectorData.html
#    - Sacaremos los contornos de la unión de los barrios (03_mallado.R)
#    - Se hará el mallado (03_mallado.R)
#-----------------------------------------------------------
#Descargamos los barrios de Madrid Ciudad para sacar la forma y el mallado
#url: "https://datos.madrid.es/egob/catalogo/200078-10-distritos-barrios.zip"
if (file.exists("../dat/shapefiles/barrios/BARRIOS.shp")){
  # sale del bucle sin hacer nada
} else {
  #crea un zip, descarga la info, movemos el zip de la ruta temporal a nuestro dat/shapefiles,
  #descomprimimos y borramos el .zip creado
  url2 <-"https://datos.madrid.es/egob/catalogo/200078-10-distritos-barrios.zip"
  fichero2 <- paste0(tempfile(), ".zip")
  fichero2
  download.file(url2, destfile = fichero2)
  my.file.rename(from = fichero2,
                 to = "../dat/shapefiles/barrios.zip")
  unzip(zipfile= "../dat/shapefiles/barrios.zip" ,exdir = "../dat/shapefiles/")
  file.remove("../dat/shapefiles/barrios.zip")
  #cambiamos el nombre del directorio contenedor de los shapefiles
  my.file.rename(from = "../dat/shapefiles/SHP_ETRS89",
                 to = "../dat/shapefiles/barrios")
}
#leemos los barrios de la ciudad de Madrid
barrios <- readOGR(dsn="../dat/shapefiles/barrios",layer="BARRIOS")
base.map <- gmap(barrios, type = "terrain")
reprojected.barrios <- spTransform(barrios, base.map@crs)
plot(base.map)
points(estaciones_ayuntamiento$LONG.DD,estaciones_ayuntamiento$LAT.DD,col="red",pch=16)
#barrios de la ciudad de Madrid
plot(reprojected.barrios, add = T, border = "black", col = "transparent")

#-----------------------------------------------------------
# 5. Centroides de cada barrio.
#-----------------------------------------------------------
trueCentroids = gCentroid(barrios,byid=TRUE)
plot(barrios)
points(coordinates(barrios),pch=3,col="red")
head(coordinates(trueCentroids))
#en el siguiente .R se realizará el mallado de esta zona

