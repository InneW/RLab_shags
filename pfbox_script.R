#load library
library(sf)
library(ggplot2)

#load layers
pfboxni.sf<-st_read("PFboxnoisles.shp")
coast.sf<-st_read("scotcoast.shp")

#crs layers
st_crs(pfboxni.sf)
st_crs(coast.sf)

#transform layers
pfboxni.sf<-st_transform(x=pfboxni.sf,crs=4326)
coast.sf<-st_transform(x=coast.sf,crs=4326)

#remaking Natalie's map style
ggplot()+geom_sf(data=coast.sf,fill="grey70", color="white")+geom_sf(data=pfboxni.sf,fill=NA, color="red",show.legend=T)+coord_sf(xlim=c(-3.4, -2.78), ylim=c(58.6, 58.81), expand=FALSE)+theme_bw()+theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())+labs(x="Longitude", y="Latitude")



