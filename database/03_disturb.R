# Extract disturbance data
# PV 2022-03-07


fda1 <- st_read(paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'fda')

####################################################################################################
# YG SURFACE DISTURBANCE MAPPING

yg_gdb <- 'C:/Users/PIVER37/Dropbox (BEACONs)/dc_mapping/gisdata/YT/YG_SurfaceDisturbance/YG Surface Disturbance [Most Recent].gdb'

# Point disturbances
point <- st_read(yg_gdb, 'Point_Features') %>%
    st_transform(3578)
point_select <- point[fda1,]
if (dim(point_select)[1]) {
    st_write(point_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'point_features', delete_layer=T)
}

# Linear disturbances
linear <- st_read(yg_gdb, 'Linear_Features') %>%
    st_transform(3578)
linear_select <- linear[fda1,]
if (dim(linear_select)[1]) {
    st_write(linear_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'linear_features', delete_layer=T)
}

# Areal disturbances
areal <- st_read(yg_gdb, 'Areal_Features') %>%
    st_transform(3578)
areal_select <- areal[fda1,]
if (dim(areal_select)[1]) {
    st_write(areal_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'areal_features', delete_layer=T)
}

# Extent_of_Detailed_Mapping
extent <- st_read(yg_gdb, 'Extent_of_Detailed_Mapping') %>%
    st_transform(3578)
extent_select <- extent[fda1,]
if (dim(extent_select)[1]) {
    st_write(extent_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'extent_of_detailed_mapping', delete_layer=T)
}


####################################################################################################
# RAILROADS, ROADS, TRAILS

trails <- st_read('C:/Users/PIVER37/Dropbox (BEACONs)/dc_mapping/gisdata/YT/Trails_50k.gdb', 'Trails_50k') %>%
    st_transform(3578)
trails_select <- trails[fda1,]
if (dim(trails_select)[1]) {
    st_write(trails_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'trails', delete_layer=T)
}

#rroads <- st_read('C:/Users/PIVER37/Dropbox (BEACONs)/dc_mapping/gisdata/YT/Railroads_50k_Canvec.gdb', 'Railroads_50k_Canvec')
#rroads_select <- rroads[fda1,]
#if (dim(rroads_select)[1]) {
#    st_write(rroads_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'railroads', delete_layer=T)
#}

roads <- st_read('C:/Users/PIVER37/Dropbox (BEACONs)/dc_mapping/gisdata/YT/Roads_50k_Canvec.gdb', 'Roads_50k_Canvec')
roads_select <- roads[fda1,]
if (dim(roads_select)[1]) {
    st_write(roads_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'roads', delete_layer=T)
}

####################################################################################################
# FIRES

fires <- st_read('C:/Users/PIVER37/Dropbox (BEACONs)/dc_mapping/gisdata/YT/Fire_History.gdb', 'Fire_History') %>%
    st_cast("MULTIPOLYGON")
fires_select <- fires[fda1,]
if (dim(fires_select)[1]) {
    st_write(fires_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'fires', delete_layer=T)
}

####################################################################################################
# MINING
mining <- st_read('C:/Users/PIVER37/Dropbox (BEACONs)/dc_mapping/gisdata/YT/Quartz_Claims_50k.gdb', 'Quartz_Claims_50k') %>%
    st_cast("MULTIPOLYGON")
mining_select <- mining[fda1,]
if (dim(mining_select)[1]) {
    st_write(mining_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'quartz_claims', delete_layer=T)
}

####################################################################################################
# PHOTOS

photos <- st_read('C:/Users/PIVER37/Dropbox (BEACONs)/dc_mapping/gisdata/YT/Footprints_Aerial_Photographs.gdb', 'Footprints_Aerial_Photographs') %>%
    st_cast("MULTIPOLYGON")
photos_select <- photos[fda1,]
if (dim(photos_select)[1]) {
    st_write(photos_select, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'photos', delete_layer=T)
}
