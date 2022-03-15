# Master script to create database
# PV 2022-02-25

library(sf)
library(dplyr)
library(terra)
library(raster)
library(fasterize)
library(rmapshaper)

# Create planning region data
#source('R/00_region.R')

# Select FDA
fda_code <- '10ab'

# Prepare vector data
source('R/01_fda.R')
source('R/02_digitize.R') # digitizing templates
source('R/03_disturb.R')
source('R/04_hydro.R')

# Prepare raster data
source('R/05_topo.R')
source('R/06_cover.R')
