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

icons <- awesomeIcons(icon = 'ios-close', iconColor = 'black', library = 'ion', markerColor = getColor(stations))

# Aplicamos estos iconos sobre el mapa de Barcelona

leaflet(stations) %>% addTiles() %>%
  addAwesomeMarkers(lng=stations$longitude, lat=stations$latitude, icon=icons, label=~as.character(availableBikes))
