if(!require("tidyverse")) {
  install.packages("tidyverse")
  library("tidyverse")
}

if(!require("ggmap")) {
  install.packages("ggmap")
  library("ggmap")
}

if(!require("jsonlite")) {
  install.packages("jsonlite")
  library("jsonlite")
}

if(!require("RCurl")) {
  install.packages("RCurl")
  library("RCurl")
}

if(!require("leaflet")) {
  install.packages("leaflet")
  library("leaflet")
}

# Cargamos las coordenadas de las estaciones

json_file = getURL("https://feeds.citibikenyc.com/stations/stations.json")
json_file2 = fromJSON(json_file)

stations <- as.data.frame(do.call(rbind, lapply(json_file2[-1], rbind)))

trips201801 <- read.csv('201801_citibikenyc_tripdata.csv',header = T)

# Creamos los colores de los iconos según el número de bicicletas disponibles en cada estación

getColor <- function(stations) {
  sapply(stations$availableBikes, function(availableBikes) {
    if(availableBikes < 1) {
      "red"
    } else if(availableBikes < 10) {
      "orange"
    } else  {
      "green"
    } })
}


# Creamos los iconos que nosotros deseamos para representarlos en le mapa

icons <- awesomeIcons(icon = 'fa-bicycle', iconColor = 'black',
                      library = 'fa', markerColor = getColor(stations))

# Aplicamos estos iconos sobre el mapa de Nueva York

leaflet(stations) %>% addTiles() %>%
  addAwesomeMarkers(lng=stations$longitude, lat=stations$latitude, icon=icons,
                    popup = ~as.character(stations$stationName, stations$availableBikes),
                    label = ~as.character(availableBikes))

# Estudiamos los trips para una única estación

station.281 <- subset(trips201801, start.station.id == 281)

#i=1
#z=nrow(station.281)

getColor2 <- function(station.281) {
  sapply(station.281$end.station.name, function(end.station.name) {
    #for (i in 1:z){
    if(station.281$end.station.name == 'Grand Army Plaza & Central Park S') {
      "red"
    } else if(station.281$end.station.name != 'Grand Army Plaza & Central Park S') {
      "blue"
    } 
    #}
  } )
}

icons2 <- awesomeIcons(icon = 'fa-bicycle', iconColor = 'black', 
                       library = 'fa', markerColor = getColor2(station.281))

leaflet(data = station.281) %>% addTiles() %>%
  addAwesomeMarkers(lng=station.281$end.station.longitude, lat=station.281$end.station.latitude,
                    icon=icons2, popup = ~as.character(station.281$end.station.name))
