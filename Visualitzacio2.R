require(tidyverse)
require(ggmap)

trips201801 <- read.csv('201801_citibikenyc_tripdata.csv',header = T)

top.station <- trips201801 %>%
  group_by(start.station.id) %>%
  summarise(n.trips=n(),
            name=start.station.name[1],
            lat=start.station.latitude[1],
            lon=start.station.longitude[1]) %>%            
  arrange(desc(n.trips))%>%
slice(1)

station.out <- trips201801 %>%
  filter(start.station.id==top.station$start.station.id) %>%
  group_by(end.station.id) %>%
  summarise(n.trips=n(),
            name=end.station.name[1],
            start.lat = as.numeric(start.station.latitude[1]),
            start.lon = as.numeric(start.station.longitude[1]),
            end.lat = as.numeric(end.station.latitude[1]),
            end.lon = as.numeric(end.station.longitude[1])) %>%
  arrange(desc(n.trips))%>%
  slice(1:50)

map <- get_map(location = c(lon = top.station$lon, 
                               lat = top.station$lat),source='google', maptype = 'roadmap',zoom=14)

ggmap(map) + 
  geom_segment(data=station.out,aes(x=start.lon,y=start.lat,
                                         xend=end.lon,yend=end.lat,
                                         color=n.trips),
               size=0.75,alpha=0.75) +
  geom_point(data=station.out,aes(x=end.lon,y=end.lat,color=n.trips), size=1.5,alpha=0.75) + 
  geom_point(data=top.station, aes(x=lon,y=lat), size=1, alpha=0.5) +
  scale_colour_gradient(high="red",low='green') + 
  theme(axis.ticks = element_blank(),
        axis.text = element_blank()) +
  xlab('')+ylab('') +
  ggtitle(paste0('Top 50 Trips starting at ', top.station$name))

