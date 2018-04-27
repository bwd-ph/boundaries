## Based on Trafford Data Lab script at https://github.com/traffordDataLab/boundaries/blob/master/pre-processing/script.R

## Spatial data pre-processing and exporting Pennine Lancs vector boundaries to GeoJSON ##

# load necessary packages
library(sf) ; library(tidyverse)

setwd('C:/Users/user/Documents/BwD work/Interactive Mapping/GeoJSON files')

# -------------------  Local Authority Districts
# Source: http://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2016-full-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/686603e943f948acaa13fb5d2b0f1275_0.geojson") %>% 
  filter(grepl('Blackburn with Darwen|Burnley|Hyndburn|Pendle|Ribble Valley|Rossendale', lad16nm)) %>%
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>%
  st_write("local_authorities.geojson", driver = "GeoJSON")

# ------------------- Wards (NB these aren't the generalised ones. Takes an age to read.)
# Source: http://geoportal.statistics.gov.uk/datasets/wards-december-2016-full-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/afcc88affe5f450e9c03970b237a7999_0.geojson") %>% 
  filter(grepl('Blackburn with Darwen|Burnley|Hyndburn|Pendle|Ribble Valley|Rossendale', lad16nm)) %>%
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("wards_full.geojson", driver = "GeoJSON")

# ------------------- Wards (NB these are the generalised ones.)
# Source: http://geoportal.statistics.gov.uk/datasets/wards-december-2016-generalised-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/afcc88affe5f450e9c03970b237a7999_2.geojson") %>% 
  filter(grepl('Blackburn with Darwen|Burnley|Hyndburn|Pendle|Ribble Valley|Rossendale', lad16nm)) %>%
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("wards_generalised.geojson", driver = "GeoJSON")

# ------------------- Middle Super Output Areas
# Source: http://geoportal.statistics.gov.uk/datasets/middle-layer-super-output-areas-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/826dc85fb600440889480f4d9dbb1a24_2.geojson") %>% 
  filter(grepl('Blackburn with Darwen|Burnley|Hyndburn|Pendle|Ribble Valley|Rossendale', msoa11nm)) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("msoa.geojson", driver = "GeoJSON")

# ------------------- Lower Super Output Areas
# Source: http://geoportal.statistics.gov.uk/datasets/lower-layer-super-output-areas-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/da831f80764346889837c72508f046fa_2.geojson") %>% 
  filter(grepl('Blackburn with Darwen|Burnley|Hyndburn|Pendle|Ribble Valley|Rossendale', lsoa11nm)) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("lsoa.geojson", driver = "GeoJSON")

# ------------------- Output Areas
# Source: http://geoportal.statistics.gov.uk/datasets/output-area-december-2011-generalised-clipped-boundaries-in-england-and-wales
st_read("https://opendata.arcgis.com/datasets/09b8a48426e3482ebbc0b0c49985c0fb_2.geojson") %>% 
  filter(grepl('E06000008|E07000117|E07000120|E07000122|E07000124|E07000125', lad11cd)) %>% 
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("oa.geojson", driver = "GeoJSON")