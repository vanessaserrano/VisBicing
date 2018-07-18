require(tidyverse)
require(ggmap)

# Lectura de los datos a estudiar

trips201801 <- read.csv('201801_citibikenyc_tripdata.csv',header = T)

# Seleccionamos aquellos viajes que han salido de las estación 281

station.281 <- subset(trips201801, start.station.id == 281)

# Creamos un dataframe  con la informacion que nos interesa

nodes <- unique(station.281[, c("start.station.id", "start.station.longitude", "start.station.latitude",
                                "end.station.id", "end.station.longitude", "end.station.latitude")])

# Eliminamos aquellos viajes que han empezado y terminado en la estacion 281

nodes.end <- subset(nodes,end.station.id!=281) %>% slice(1:10)

nodes.end2 <- nodes.end %>% slice(1)

# Obtenemos el mapa de la ciudad deseada

map.nyc <-  get_map(location = c(lon = nodes.end2$start.station.longitude, 
                                   lat = nodes.end2$start.station.latitude), 
                    source='google', maptype = 'roadmap',zoom=12)

# Representamos el mapa de nuestra ciudad

ggmap(map.nyc) 

# Le añadimos los puntos que representan cada estacion de bicing

mapa <- ggmap(map.nyc) + geom_point(data = nodes, aes(x = start.station.longitude, y = start.station.latitude), 
                                                      colour = "red", size = 1) + 
                        geom_point(data = nodes.end, aes(x = end.station.longitude,
                                                       y = end.station.latitude), colour = "blue", size = 0.5) +
                        geom_segment(data=nodes.end,aes(x=start.station.longitude,y=start.station.latitude,
                                                               xend=end.station.longitude,yend=end.station.latitude),
                                     colour='blue')
                                                              
                                                      
                        
mapa
