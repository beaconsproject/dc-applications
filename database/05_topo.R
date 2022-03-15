# Download Canadian elevation data (CDEM @ 17.175m resolution according to ArcGIS Project)
# coord. ref. : NAD83 / Yukon Albers (EPSG:3578)
# PV 2022-02-22

fda1 <- st_read(paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'fda')
r30 <- rast(paste0('../gisdata/FDA/fda_',fda_code,'/bnd.tif'))

nts250 <- st_read('data/cdem_index_250k.kml') %>% st_transform(3578)
nts <- nts250[fda1,] 
nts_list <- nts$Name
ftp <- 'https://ftp.maps.canada.ca/pub/nrcan_rncan/elevation/cdem_mnec/'

for (i in nts_list) {
    tile <- paste0(substr(i,1,3),'/cdem_dem_',i,'_tif.zip')
    download.file(paste0(ftp,tile), destfile=paste0('tmp/dem_',i,'.zip'))
    unzip(paste0('tmp/dem_',i,'.zip'), exdir = paste0('tmp/dem'))
    file.remove(paste0('tmp/dem_',i,'.zip'))
}

# Merge download DEM rasters
rm <- rast(paste0('tmp/dem/cdem_dem_',nts_list[1],'.tif'))
rm <- terra::resample(rm, r30, method='bilinear') # better to resample before merging
#rm <- terra::project(rm, r30, method='bilinear') # same as resample
for (i in nts_list[-1]) {
    cat(i,'...\n'); flush.console()
    r <- rast(paste0('tmp/dem/cdem_dem_',i,'.tif')) # 105I is all jumbled up
    r <- terra::resample(r, r30)
    rm <- merge(rm, r) # 105I won't merge
}

# Clip and save elevation raster
elev <- terra::crop(rm, r30)
elev <- terra::mask(elev, r30)
terra::writeRaster(elev, paste0('../gisdata/FDA/fda_',fda_code,'/elev.tif'), overwrite=TRUE)

# Optionally create slope, aspect, and hillshade rasters
#slope <- terrain(elev, "slope", unit = "radians")
#terra::writeRaster(slope, "data/fda/10ab/raster30/slope.tif", overwrite=TRUE)
#aspect <- terrain(elev, "aspect", unit = "radians")
#terra::writeRaster(aspect, "data/fda/10ab/raster30/aspect.tif", overwrite=TRUE)
#hs <- shade(slope, aspect)
#terra::writeRaster(hs, "data/fda/10ab/raster30/hillshade.tif", overwrite=TRUE)

# Delete temp files
unlink('tmp/dem', recursive=TRUE)
