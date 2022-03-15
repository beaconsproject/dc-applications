# Select FDAs that intersect KDTT and subset Upper and Middle Liard
# coord. ref. : NAD83 / Yukon Albers (EPSG:3578)
# PV 2022-03-15

kdtt <- st_read('../gisdata/KDTT/kdtt.shp') # EPSG:3578
st_write(kdtt, '../gisdata/FDA/region.gpkg', 'kdtt', delete_dsn=T)

# Open NHN index shapefile
nhn <- st_read('data/nts_nhn_subset_3578.gpkg', 'nhn')

# Select intersecting FDAs (via NHNs)
nhn45 <- nhn[kdtt,] # first we select all NHNs that intersect KDTT
nhn48 <- dplyr::filter(nhn, FDA %in% nhn45$FDA) # then we select all NHNs that for those FDAs

# Select NHNs comprising central and upper Liard SDAs, and Upper Pelly SSDA
#nhn <- filter(nhn48, WSCSDA %in% c('10A','10B') | FDA=='09BA')
st_write(nhn48, '../gisdata/FDA/region.gpkg', 'nhn', delete_layer=T)

# Dissolve by FDA
fda <- ms_dissolve(nhn48, field='FDA')
st_write(fda, '../gisdata/FDA/region.gpkg', 'fda', delete_layer=T)

# Buffer region
buf50k <- st_buffer(nhn48, 50000) %>%
    st_union() %>%
    st_sf() %>%
    mutate(centrum=T, one=1)
st_write(buf50k, '../gisdata/FDA/region.gpkg', 'buff_50k', delete_layer=T)

# Add NTS 50k grid
#grid <- st_read('../gisdata/YT/NTS_Index_50k.gdb', 'NTS_Index_50k') # Yukon only
grid <- st_read('data/nts_nhn_subset_3578.gpkg', 'nts_50k')
g <- grid[fda,]
st_write(g, '../gisdata/FDA/region.gpkg', 'nts_50k', delete_layer=T)

# Select 2-km grid that covers FDA
fda <- st_read('../gisdata/FDA/region.gpkg', 'fda')
g1 <- st_read('../gisdata/grid/nts_nested_2km.shp')
g1g <- g1[fda,]
g1gg <- mutate(g1g, grid_id=1:nrow(g1g))
st_write(g1gg, '../gisdata/FDA/region.gpkg', 'grid_2k', delete_layer=T)

# Create 30m raster of region
# memory.limit(size=2500000)
#v <- mutate(fda, one=1)
#r1 = fasterize(sf=v, raster=raster::raster(v, res=30), field="one")
#writeRaster(r1, '../gisdata/FDA/region_30m.tif', overwrite=T)

# Protected areas - select and clip to 50k buffer
pas <- st_read('../gisdata/canada/canada_eco.gdb', 'CPCAD_Dec2020') %>% 
    st_transform(3578)
pas50 <- pas[buf50k,]
pas50clip <- st_intersection(pas50, buf50k)
st_write(pas50clip, '../gisdata/FDA/region.gpkg', 'pas_buf50k_clip', delete_layer=T)

# Intact forest landscapes
xi <- st_read('../gisdata/canada/canada_eco.gdb', 'GIFL_2000') %>%
    ms_clip(buf50k) %>% st_transform(3578)
st_write(xi, '../gisdata/FDA/region.gpkg', 'ifl_2000', delete_layer=T)
xi <- st_read('../gisdata/canada/canada_eco.gdb', 'GIFL_2020') %>%
    ms_clip(buf50k) %>% st_transform(3578)
st_write(xi, '../gisdata/FDA/region.gpkg', 'ifl_2020', delete_layer=T)
