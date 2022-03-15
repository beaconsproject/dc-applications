# Canada landcover 1984-2019 at 30m resolution
# https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_2019.zip
# PV 2022-03-10

lc_code <- c('0','20','31','32','33','40','50','80','81','100','210','220','230')
lc_name <- c('unclassified','water','snow_ice','rock_rubble','exposed_barren','bryoids','shrubs','wetland','wetland-treed','herbs','coniferous','broadleaf','mixedwood')
lc_tbl <- data.frame(ID=lc_code, Landcover=lc_name)

rbnd <- rast(paste0('../gisdata/FDA/fda_',fda_code,'/bnd.tif'))
bnd <- vect(paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'fda')
for (i in c(1984,1989,1994,1999,2004,2009,2014,2019)) {
    cat(i,'\n...downloading\n'); flush.console()
    http <- paste0('https://opendata.nfis.org/downloads/forest_change/CA_forest_VLCE2_',i,'.zip')
    download.file(http, destfile=paste0('tmp/lcc_',i,'.zip'))
    cat('...unzipping\n'); flush.console()
    unzip(paste0('tmp/lcc_',i,'.zip'), exdir = paste0('tmp/lcc'))
    file.remove(paste0('tmp/lcc_',i,'.zip'))
    lc <- rast(paste0('tmp/lcc/CA_forest_VLCE2_',i,'.tif'))
    cat('...clipping\n'); flush.console()
    if (i==1984) bnd <- project(bnd, lc) # project bnd to match landcover data
    xlc <- terra::mask(terra::crop(lc, bnd), bnd)
    cat('...projecting\n'); flush.console()
    xlcp <- project(xlc, rbnd, method="near") # project back to yukon albers using nearest neighbor method
    cat('...writing\n'); flush.console()
    
    # Add raster attribute table with LC classes
    cat('...adding attributes\n'); flush.console()
    r <- as.factor(xlcp)
    rat <- levels(r)[[1]]
    rat <- data.frame(ID=rat[!is.na(rat)])
    rat <- merge(rat, lc_tbl)
    levels(r) <- rat

    writeRaster(r, paste0('../gisdata/FDA/fda_',fda_code,'/lc_',i,'.tif'), overwrite=TRUE)
    unlink('tmp/lcc', recursive=TRUE)
}


################################################################################
# DELETE CODE BELOW ONCE ABOVE CODE HAS BEEN TESTED
# Add a raster attribute table (this should be incorporated into the above code)
fda_code <- '10ab'
rastDir <- paste0('C:/Users/PIVER37/Dropbox (BEACONs)/dc_mapping/gisdata/FDA/fda_',fda_code,'/')
lc_code <- c('0','20','31','32','33','40','50','80','81','100','210','220','230')
lc_name <- c('unclassified','water','snow_ice','rock_rubble','exposed_barren','bryoids','shrubs','wetland','wetland-treed','herbs','coniferous','broadleaf','mixedwood')
lc_tbl <- data.frame(ID=lc_code, Landcover=lc_name)

for (i in c(1984,1989,1994,1999,2004,2009,2014,2019)) {
    cat('Converting LCC', i,'\n'); flush.console()
    r = rast(paste0('../../dc_mapping/gisdata/FDA/fda_',fda_code,'/lc_',i,'.tif'))
    r <- as.factor(r)
    rat <- levels(r)[[1]]
    rat <- data.frame(ID=rat[!is.na(rat)])
    rat <- merge(rat, lc_tbl)
    levels(r) <- rat
    terra::writeRaster(r,paste0('../../dc_mapping/gisdata/FDA/fda_',fda_code,'/lc_',i,'.tif'), overwrite=TRUE)
}
