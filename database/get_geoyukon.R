get_geoyukon <- function (outdir='../gisdata/YT/', http) {
    # Create temp folder
    if (!dir.exists('tmp')) dir.create('tmp')

    # Download file to temp folder
    download.file(http, destfile='tmp/tmp.zip')

    # Unzip downloaded file
    unzip('tmp/tmp.zip', exdir = 'tmp/unzip')
    
    # Copy geodatabase or shapefile to YT gis folder
    gdb <- list.files('tmp/unzip', pattern=".gdb")
    file.copy(from=paste0('tmp/unzip/',gdb), to=paste0(outdir), overwrite = TRUE, recursive = TRUE)

    # Clean up
    file.remove('tmp/tmp.zip')
    Sys.sleep(3)
    unlink('tmp/unzip', recursive=TRUE)
}

# Fire history
get_geoyukon(http='https://map-data.service.yukon.ca/geoyukon/Biophysical/Fire_History/Fire_History.fgdb.zip')
