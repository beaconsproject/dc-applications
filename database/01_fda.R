# Extract one FDA using fda_code variable from master.R
# PV 2022-03-15

fda1 <- st_read('../gisdata/FDA/region.gpkg', 'fda') %>%
    filter(FDA==toupper(fda_code))
st_write(fda1, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'fda', delete_dsn=T)

# Create raster version of selected FDA
fda1v <- vect(paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'fda')
r30 <- rast('../gisdata/FDA/region_30m.tif')
r30 <- terra::crop(r30, fda1v)
r30 <- terra::mask(r30, fda1v)
terra::writeRaster(r30, paste0('../gisdata/FDA/fda_',fda_code,'/bnd.tif'), overwrite=TRUE)

# NTS 50k
nts <- st_read('../gisdata/FDA/region.gpkg', 'nts_50k')
nts <- nts[fda1,]
st_write(nts, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'nts_50k', delete_layer=T)

# Make 2-km grid that covers FDA
g <- st_read('../gisdata/FDA/region.gpkg', 'grid_2k')
#g <- st_read('../gisdata/grid/nts_nested_2km.shp')
gg <- g[fda1,]
ggg <- mutate(gg, grid_id=1:nrow(gg))
st_write(ggg, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'grid_2k', delete_layer=T)

# Intact forest landscapes
ifl2000 <- st_read('../gisdata/FDA/region.gpkg', 'ifl_2000') %>%
    st_intersection(fda1)
st_write(ifl2000, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'ifl_2000', delete_layer=T)

ifl2020 <- st_read('../gisdata/FDA/region.gpkg', 'ifl_2020') %>%
    st_intersection(fda1)
st_write(ifl2020, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'ifl_2020', delete_layer=T)
