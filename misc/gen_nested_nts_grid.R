# create nested grid inside each NTS grid, then merge and project. Results in ~2km grids, but grid sizes change with lat long


library(sf)

nts_prj <- st_read("C:/Users/MAEDW7/Dropbox (BEACONs)/dc_mapping/gisdata/grid/NTS_KDTT_YKAlbers.shp")
nts <- st_read("C:/Users/MAEDW7/Dropbox (BEACONs)/dc_mapping/gisdata/grid/NTS_KDTT.shp")

lst <- list()
for(i in nts$NTS_SNRC){
  
  nts_i <- nts[nts$NTS_SNRC == i,] # subset nts
  grd_i_sfc <- st_make_grid(nts_i, n = 13) # make smaller grids nested in nts
  grd_i <- st_sf(nts = i, geometry = grd_i_sfc) # convert geometries to sf object
  
  lst <- append(lst, list(grd_i))
}

# merge
full_grid <- do.call(rbind, lst)

# project
full_grid_prj <- st_transform(full_grid, st_crs(nts_prj))

plot(nts_prj$geometry[1])
plot(full_grid_prj$geometry, add=T)

st_write(full_grid_prj, "../../gisdata/grid/nts_nested_2km.shp")