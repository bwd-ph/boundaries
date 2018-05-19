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
  
  
# -------------------  CCGs
# Source: http://geoportal.statistics.gov.uk/datasets/clinical-commissioning-groups-april-2018-full-extent-boundaries-in-england
# NB - using 'full extent' because 'clipped' gives messy outline for Greater Preston
st_read("https://opendata.arcgis.com/datasets/5252644ec26e4bffadf9d3661eef4826_1.geojson") %>% 
  filter(grepl('Blackburn with Darwen|East Lancashire|Greater Preston', ccg18nm)) %>%
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>%
  st_write("CCGs.geojson", driver = "GeoJSON")

# ------------------- Wards (NB these aren't the generalised ones. Takes an age to read. Includes the old boundaries for BwD.)
# Source: http://geoportal.statistics.gov.uk/datasets/wards-december-2016-full-clipped-boundaries-in-great-britain
st_read("https://opendata.arcgis.com/datasets/afcc88affe5f450e9c03970b237a7999_0.geojson") %>% 
  filter(grepl('Blackburn with Darwen|Burnley|Hyndburn|Pendle|Ribble Valley|Rossendale', lad16nm)) %>%
  st_as_sf(crs = 4326, coords = c("long", "lat")) %>% 
  st_write("wards_full.geojson", driver = "GeoJSON")

# ------------------- Wards (NB these are the generalised ones. Includes the old boundaries for BwD.)
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

# ------------------- Neighbourhoods
# Source: existing shape file of exact BwD neighbourhoods,
#    plus existing shape file of Pennine neighbourhoods with the BwD ones approximated to be made up of complete LSOAs
library(rgdal)
library(geojsonio)

# NB - these are the exact boundaries for BwD nhoods (not approximated to LSOAs)
setwd("C:/Users/user/Documents/BwD work/Atlases/BwD Data Atlas")
BwD_Nhoods <- readOGR(dsn = '.',"Four Neighbourhoods_region")
BwD_Nhoods <- spTransform(BwD_Nhoods,CRS("+init=epsg:4326"))
summary(BwD_Nhoods)

# NB - these include the approximate boundaries for BwD nhoods
setwd("C:/Users/user/Documents/BwD work/Pennine nhood mapping")
Pennine_Nhoods <- readOGR(dsn = ".","Nhoods_EmmaRobert_region")
Pennine_Nhoods <- spTransform(Pennine_Nhoods,CRS("+init=epsg:4326"))

# Remove the upper left part of Ribble Valley, that doesn't have a neighbourhood name
Pennine_Nhoods <- subset(Pennine_Nhoods, ! is.na(Nhood_Emma))

# Want to remove the approximate boundaries and replace them with the exact ones
ELancs_Nhoods <- subset(Pennine_Nhoods, ! Nhood_Emma %in% c("Blackburn East","Blackburn West","Blackburn North","Darwen Rural")) # remove approx BwD boundaries
summary(ELancs_Nhoods)
colnames(ELancs_Nhoods@data)[1] = "NAME" # Rename 'Nhood_Emma' to 'NAME' to be same as BwD
BwD_Nhoods <- BwD_Nhoods[,-1] # Remove first data column ('ID') from Bwd to be same as ELancs
Pennine_Nhoods <- rbind(BwD_Nhoods, ELancs_Nhoods) # Exact BwD nhoods plus ELancs nhoods

setwd("C:/Users/user/Documents/BwD work/Interactive Mapping/GeoJSON files")
geojson_write(Pennine_Nhoods,geometry = "polygon",file = "Pennine_Nhoods.geojson")

#
# ---------------- Wards - amending to include the new ward boundaries for BwD
#
setwd("C:/Users/user/Documents/BwD work/Shape Files")
New_Wards <- readOGR(dsn = '.',"Wards_region")
New_Wards <- spTransform(New_Wards,CRS("+init=epsg:4326"))

Pennine_Wards <- st_read("https://github.com/bwd-ph/boundaries/blob/master/wards_generalised.geojson?raw=true")
Pennine_Wards <- as(Pennine_Wards,"Spatial")
Pennine_Wards <- spTransform(Pennine_Wards,CRS("+init=epsg:4326"))

# Want to remove the (old) BwD wards from Pennine_Wards....
Pennine_Wards <- subset(Pennine_Wards, ! lad16nm == "Blackburn with Darwen")

# Want to remove extraneous columns from each 
Pennine_Wards <- Pennine_Wards[,-c(1,4,7,8,9,10,11,12)] # remove various columns
New_Wards <- New_Wards[,-c(2,3,4,5,6,7,8,10,11,12,13,14,15)]

# Want to strip the word ' Ward' (i.e. final 5 characters) off end of New Ward names
New_Wards@data$Name <- factor(substr(as.character(New_Wards@data$Name),1,nchar(as.character(New_Wards@data$Name))-5))

# Want to rename columns in Pennine_Wards
colnames(Pennine_Wards@data) = c("wardCode","wardName","ladCode","ladName")

# Want to switch round columns in New_Wards
New_Wards <- New_Wards[,c(2,1)]

# Want to rename columns in New_Wards
colnames(New_Wards@data) = c("wardCode","wardName")

# Want to introduce two extra columns in New_Wards
New_Wards@data$ladCode <- factor("E06000008")
New_Wards@data$ladName <- factor("Blackburn with Darwen")

# Want to merge Pennine_Wards with New_Wards
Wards2018 <- rbind(Pennine_Wards,New_Wards)
setwd("C:/Users/user/Documents/BwD work/Interactive Mapping/GeoJSON files")
geojson_write(Wards2018,geometry = "polygon",file = "Wards2018.geojson")