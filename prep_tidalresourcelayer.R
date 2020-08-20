#Data prep tidal info
# crop to Scottish EEZ
## load EEZ file
library(sf)
library(rmapshaper)
library(tmap)
library(dplyr)
library(ggplot2)

tidalUK.sf<-st_read("Tide.shp")
pfbox.sf<-st_read("PFbox.shp")

st_crs(tidalUK.sf)
st_crs(pfbox.sf)

tidalUK_scotcrs.sf<-st_transform(x=tidalUK.sf,crs=32630)

## clip to pfbox

tidal_scot.sf<-ms_clip(tidalUK_scotcrs.sf,clip=pfbox.sf)
st_write(tidal_scot.sf,"Tidal_PF.shp")

#in order for tidal stream marine renewable energy devices (hereafter tidal energy devices) to be commercially viable, mean spring tide current velocities >2ms-1 are necessary (Fraenkel, 2006; Lewis et al., 2015).

tidalPF_viable.sf<-tidal_scot.sf[tidal_scot.sf$MEAN_SP_PC > 2,]
tm_shape(tidalPF_viable.sf)+tm_fill(col="MEAN_SP_PC",palette="plasma")

tm_shape(pfbox.sf)+tm_borders()+tm_shape(coast.sf)+tm_fill(col="grey")


#convert to raster
viabletidalprep.r<-raster(as(tidalPF_viable.sf, "Spatial"),res=10)

tidal_PF.r<-rasterize(as(tidalPF_viable.sf,"Spatial"),viabletidalprep.r,progress="text",field="MEAN_SP_PC")

tm_shape(tidal_PF.r)+tm_raster()

writeRaster(tidal_PF.r, "tidalPF.tif")

