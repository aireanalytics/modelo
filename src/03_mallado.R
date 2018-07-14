##########################################################################
# Proyecto: Aire Analytics
# Fecha última modificación: 2018-07-14
# Código: Mallado de la ciudad de Madrid
##########################################################################
library(rgeos)

#-----------------------------------------------------------
# 1. Contorno de la ciudad de Madrid
#-----------------------------------------------------------
plot(barrios)
points(estaciones_ayuntamiento$LONG.DD,estaciones_ayuntamiento$LAT.DD,col="red",pch=16)
# Juntamos el mallado con los barrios de Madrid
madrid_centro = gUnaryUnion(barrios,barrios$dummy)
# intersección del grid con el mapa de los barrios
map <- gIntersection(barrios,madrid_centro,drop_lower_td = TRUE)
plot(madrid_centro)

#-----------------------------------------------------------
# 2. Mallado de la ciudad
#-----------------------------------------------------------
e <- extent(bbox(barrios))                  # define boundaries of object
r <- raster(e)                           # create raster object 
dim(r) <- c(40, 40)                      # specify number of cells
projection(r) <- CRS(proj4string(barrios))  # give it the same projection as port
g <- as(r, 'SpatialPolygonsDataFrame')   # convert into polygon
summary(g)
#We now clip the new grid to match Portland and perform the same aggregation procedure to count the number of crimes within our newly defined (square) polygons.dd
p <- g[barrios,]
barrios_agg <- aggregate(x=barrios["ORIG_FID"],by=p,FUN=length)
barrios_agg$ORIG_FID[is.na(barrios_agg$ORIG_FID)] <- 0
#Something to watch out for when using a fine grid, which are now a lot smaller than the initial police districts, is that some polygons may not have any crimes committed within them. The length function therefore takes the length of an empty vector in those cases, which returns a NA value. To avoid ugly NA parts on the map, we replace them with with zeros.
barrios_agg$ORIG_FID[is.na(barrios_agg$ORIG_FID)] <- 0
barrios_agg <- spTransform(barrios_agg, CRS("+init=epsg:4326")) # reproject
qpal <- colorBin("Reds", barrios_agg$ORIG_FID, bins=5)       # define color bins
plot2<-leaflet(barrios_agg) %>%
  #cambiar el fillOpacity a 0.5 para ver color
  addPolygons(stroke = TRUE,opacity = 1,fillOpacity = 0., smoothFactor = 0.5,
              color="black",fillColor = ~qpal(ORIG_FID),weight = 0.5)# %>%
  #addLegend(values=~ORIG_FID,pal=qpal,title="Niveles NOx de Madrid")
#mallado
plot2

#-----------------------------------------------------------
# 3. Mallado de la ciudad sobre mapa
#-----------------------------------------------------------
# la clase de map--> es spatialpolygons
barrios_agg2 <- aggregate(x=barrios["ORIG_FID"],by=map,FUN=length)
barrios_agg2$ORIG_FID[is.na(barrios_agg2$ORIG_FID)] <- 0
barrios_agg2 <- spTransform(barrios_agg2, CRS("+init=epsg:4326"))
qpal <- colorBin("Reds", barrios_agg2$ORIG_FID, bins=5)
plot3 <- leaflet(barrios_agg2) %>%
  addPolygons(stroke = TRUE,opacity = 1,fillOpacity = 0, smoothFactor = 0.5,
              color="black",fillColor = ~qpal(ORIG_FID),weight = 1) #%>%
  #addLegend(values=~ORIG_FID,pal=qpal,title="Niveles NOx de Madrid")

# Mallado de la ciudad de Madrid en el mapa
plot3<-plot2%>% addTiles()
plot4 <- plot3 %>% addTiles()
plot4
# Zoom dee la zona de interés
cent <- gCentroid(barrios_agg2) # Find center of map
plot5 <- plot4 %>% setView(zoom = 10.5,lng=cent@coords[[1]], lat=cent@coords[[2]])
plot5

#-----------------------------------------------------------
# 3. Centroides del mallado y estaciones
#-----------------------------------------------------------
#mallado con los centroides de cada celda
trueCentroids = gCentroid(barrios_agg,byid=TRUE)
plot(barrios_agg)
points(estaciones_ayuntamiento$LONG.DD,estaciones_ayuntamiento$LAT.DD,col="red",pch=16)
points(coordinates(barrios_agg),pch=1,col="blue")
points(trueCentroids,pch=3, col="blue")
head(coordinates(trueCentroids))

#-----------------------------------------------------------
# 4. Comprobamos que el el contorno y el mallado se ajusta a los bordes de la Ciudad
#-----------------------------------------------------------

leaflet(data = estaciones_ayuntamiento) %>% addTiles() %>%
  addPolygons(data = barrios_agg2, stroke = TRUE, weight = 1, opacity = 0.5, fill = TRUE, fillOpacity = 0.2)%>%
  addMarkers(~estaciones_ayuntamiento$LONG.DD, ~estaciones_ayuntamiento$LAT.DD, icon = greenLeafIcon)

leaflet(data = estaciones_ayuntamiento) %>% addTiles() %>%
  addPolygons(data = barrios_agg, stroke = TRUE, weight = 1, opacity = 0.5, fill = TRUE, fillOpacity = 0.2)%>%
  addMarkers(~estaciones_ayuntamiento$LONG.DD, ~estaciones_ayuntamiento$LAT.DD, icon = greenLeafIcon)

