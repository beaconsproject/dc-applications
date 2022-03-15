# Select one FDA and extract streams, lakes, etc.
# PV 2021-02-22
# https://mitchellgritts.com/posts/load-kml-and-kmz-files-into-r/
#download.file('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/geobase_nhn_rhn/index/nhn_rhn_geobase.kmz', destfile='data/nhn_rhn_geobase.kmz')
#download.file('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/geobase_nrn_rrn/bc/nrn_rrn_bc_kml_en.kmz', destfile='data/nrn_rrn_bc_kml_en.kmz')
#"https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/geobase_nhn_rhn/gdb_en/10/nhn_rhn_10ab000_gdb_en.zip"
# Download NHN data and extract attributes of interest
# "http://ftp.maps.canada.ca/pub/nrcan_rncan/vector/geobase_nhn_rhn/gdb_en/08/nhn_rhn_08gabx1_gdb_en.zip"
# PV 2022-02-22

fda1_nhn <- st_read('../gisdata/FDA/region.gpkg', 'nhn') %>%
    filter(FDA==toupper(fda_code))
nhn_list <- pull(fda1_nhn, DATASETNAM)

# Select one NHN
#for (i in nhn_list) {
    i <- nhn_list[1]
    nhn_id <- tolower(i) # yt kaska (KZK mine)
    #nhn1_http <- strsplit(nhn1$Description, '"')[[1]][2]
    nhn1_http <- paste0('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/geobase_nhn_rhn/gdb_en/',substring(nhn_id,1,2),'/nhn_rhn_',nhn_id,'_gdb_en.zip')
    download.file(nhn1_http, destfile=paste0('tmp/nhn_',i,'.zip'))
    unzip(paste0('tmp/nhn_',i,'.zip'), exdir = paste0('tmp/nhn'))
    file.remove(paste0('tmp/nhn_',i,'.zip'))

    # Attributes of interest
    st_layers(paste0('tmp/nhn/nhn_rhn_',nhn_id,'.gdb'))
    boundary <- 'NHN_WORKUNIT_LIMIT_2'
    water_poly <- 'NHN_HD_WATERBODY_2'
    water_line <- 'NHN_HD_SLWATER_1'
    water_line_all <- 'NHN_HN_NLFOW_1' # includes lines thru polygons

    # Lakes and rivers
    lakes <- read_sf(paste0('tmp/nhn/nhn_rhn_',nhn_id,'.gdb'), water_poly) %>% 
        st_zm() %>% 
        st_transform(3578)
    st_write(lakes, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'lakes_rivers', delete_layer=T)

    # Streams
    streams <- read_sf(paste0('tmp/nhn/nhn_rhn_',nhn_id,'.gdb'), water_line) %>% 
        st_zm() %>% 
        st_transform(3578)
    st_write(streams, paste0('../gisdata/FDA/fda_',fda_code,'.gpkg'), 'streams', delete_layer=T)

    # Add code to merge for FDAs comprised of more than one NHN
    # ...
#}

# Delete temp files
unlink('tmp/nhn', recursive=TRUE)
