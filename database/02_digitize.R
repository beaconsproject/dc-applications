# Convert digitizing template shapefiles to geopackage EPSG:3578
# PV 2022-02-22

# For now, we use the shapefiles Marc created and reproject them to 3578
folder <- paste0('../digitizing/FDA_',fda_code,'_test/digitizing_layers/')

lines <- st_read(paste0(folder,'FDA',fda_code,'_beacons_lines.shp')) %>%
    st_transform(3578)
st_write(lines, paste0('../gisdata/FDA/fda_',fda_code,'_digitize.gpkg'), 'lines', delete_dsn=T)

polys <- st_read(paste0(folder,'FDA',fda_code,'_beacons_polygons.shp')) %>%
    st_transform(3578)
st_write(polys, paste0('../gisdata/FDA/fda_',fda_code,'_digitize.gpkg'), 'polygons', delete_layer=T)
