if(!require("tidyverse")) {
  install.packages("tidyverse")
  library("tidyverse")
}

if(!require("shiny")) {
  install.packages("shiny")
  library("shiny")
}

if(!require("leaflet")) {
  install.packages("leaflet")
  library("leaflet")
}

if(!require("RCurl")) {
  install.packages("RCurl")
  library("RCurl")
}

if(!require("XML")) {
  install.packages("XML")
  library("XML")
}

# Creamos una API que nos permita obtener los datos de cada estación en tiempo real

web = "http://wservice.viabicing.cat/getstations.php?v=1"

datos1 <- xmlParse(web)

datos2 <- xmlToList(datos1)

lapply

datos2$station$streetNumber <- NA

datos <- data.frame(matrix(unlist(datos2), ncol = 10, byrow = TRUE), stringsAsFactors = FALSE)

names(datos) <- names(datos2$station)[-5]

datos$time <- Sys.time()

# Creamos las capas de color según el número de bicis disponibles en cada estación

getColor <- function(datos) {
  sapply(datos$bikes, function(bikes) {
    if(bikes < 1) {
      "red"
    } else if(bikes < 10) {
      "orange"
    } else  {
      "green"
    } })
}

# Creamos los iconos que nosotros deseamos para representarlos en le mapa

icons <- awesomeIcons(icon = 'ios-close', iconColor = 'black', library = 'ion', markerColor = getColor(datos))

# Aplicamos estos iconos sobre el mapa de Barcelona

leaflet(datos) %>% addTiles() %>%
  addAwesomeMarkers(lng=datos$long, lat=datos$lat, icon=icons, label=~as.character(bikes))

