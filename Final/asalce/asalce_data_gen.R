# This file documents all R scripts used to generate and clean data

# how to return the size of an ENV object
# format(object.size(my_df), unit = "MB")

####################
# Get all AZ roads #
####################

# az_fips <- fips_codes %>%
#   filter(state == "AZ") %>%
#   pull(state_code) %>%
#   unique()
#
# # Get all counties in the state
# az_counties <- counties(state = az_fips, cb = TRUE)
#
# # Fetch roads for all counties and combine into one sf object
# az_roads <- map_dfr(az_counties$COUNTYFP, function(county) {
#   roads(state = az_fips, county = county)
#   }) %>% st_as_sf()




#######################
# FILTER ALL AZ ROADS #
#######################
#
# az_rd_primary <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1100"))  # Primary  roads
#
# az_rd_secondary <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1200"))  # Secondary roads
#
# az_rd_local <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1400"))  # Local and neighborhood roads
#
# az_rd_4wd <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1500"))  # 4WD roads
#
# az_rd_ramp <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1630"))  # Ramps and interchanges
#
# az_rd_frontage <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1640"))  # Frontage roads
#
# az_rd_ped_trail <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1710"))  # Pedestrian walkway or trail
#
# az_rd_ped_stairs <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1720"))  # Stairways
#
# az_rd_alleys <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1730"))  # Alleyways
#
# az_rd_privateservice <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1740"))  # Private service roads
#
# az_rd_census <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1750"))  # US Census Buereau use only
#
# az_rd_parkinglot <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1780"))  # Parking lot road
#
# az_rd_wintertrail <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1810"))  # Winter trail
#
# az_rd_bikepath <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1820"))  # Bike path or trail, no motorized vehicles
#
# az_rd_bridle <- az_roads_sf %>%
#   filter(MTFCC %in% c("S1830"))  # Horse trail, no motorized vehicles




############################################
#GENERATE CLOSEST ROAD TO WILDFIRE DIST (m)#
############################################

# wfigs_az_sf$distance_rd_primary <-
#   st_distance(wfigs_az_sf, az_rd_primary) %>% apply(1, min)
#
# wfigs_az_sf$distance_rd_secondary <-
#   st_distance(wfigs_az_sf, az_rd_secondary) %>% apply(1, min)
#
# wfigs_az_sf$distance_rd_4wd <-
#   st_distance(wfigs_az_sf, az_rd_4wd) %>% apply(1, min)

# wfigs_az_sf <- wfigs_az_sf %>% filter(distance_rd_primary <= 1000)


#####################
#ORIGINAL ROADS PLOT#
#####################
# Arizona Roads

# mapview(arizona_sf, col.regions = "snow") +
#   mapview(az_rd_primary$geometry, color = "black", alpha = 0.8) +
#   mapview(az_rd_secondary$geometry, color = "lawngreen", alpha = 0.8) +
#   mapview(az_rd_4wd$geometry, color = "gray", lwd = 1)
# mapview(az_rd_frontage$geometry, color = "orange", lwd = 1) +
# mapview(az_rd_privateservice$geometry, color = "blue", lwd = 1) +
# mapview(az_rd_local$geometry, color = "red", lwd = 1)

# do not use: census, alleys, bikepath, bridle, parkinglot, ped_stairs, ped_trail, ramps, wintertraiil

#  maybes: privateservice - ALL over the place, and connect major roads. however you may get enough information from others
# frontage roads - not a lot added information
# local - WAY too much data



########################
#UNUSED ROAD DATA PLOTS#
########################
#
#
# layout(matrix(1:2, 1, 2))
# par(mar = c(1, 1, 1, 1))
#
# plot(arizona_sf$geometry, main = "Alleys")
# plot(az_rd_4wd$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_primary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_secondary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_alleys$geometry, col = "deeppink3", lwd = 1, add = T)
#
# plot(arizona_sf$geometry, main = "Bike Paths")
# plot(az_rd_4wd$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_primary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_secondary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_alleys$geometry, col = "deeppink3", lwd = 1, add = T)
#
#
#
# layout(matrix(1:2, 1, 2))
# par(mar = c(1, 1, 1, 1))
#
# plot(arizona_sf$geometry, main = "Census")
# plot(az_rd_4wd$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_primary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_secondary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_census$geometry, col = "deeppink3", lwd = 0.5, add = T)
#
#
# plot(arizona_sf$geometry, main = "Frontage")
# plot(az_rd_4wd$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_primary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_secondary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_frontage$geometry, col = "deeppink3", lwd = 0.5, add = T)
#
#
# layout(matrix(1:2, 1, 2))
# par(mar = c(1, 1, 1, 1))
#
# plot(arizona_sf$geometry, main = "Local")
# plot(az_rd_4wd$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_primary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_secondary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_local$geometry, col = "deeppink3", lwd = 0.5, add = T)
#
#
# plot(arizona_sf$geometry, main = "Parking Lot")
# plot(az_rd_4wd$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_primary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_secondary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_parkinglot$geometry, col = "deeppink3", lwd = 0.5, add = T)
#
#
# layout(matrix(1:2, 1, 2))
# par(mar = c(1, 1, 1, 1))
#
# plot(arizona_sf$geometry, main = "Private Service Roads")
# plot(az_rd_4wd$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_primary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_secondary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_privateservice$geometry, col = "deeppink3", lwd = 0.5, add = T)
#
#
# plot(arizona_sf$geometry, main = "Ramps and Interchanges")
# plot(az_rd_4wd$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_primary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_secondary$geometry, col = "gray80", add = T, lwd = 0.1)
# plot(az_rd_ramp$geometry, col = "deeppink3", lwd = 0.5, add = T)


########################
##OLD LOAD DIRECTORIES##
########################

# load(here("./data/az_roads_cc_sf.RData"))
# load(here('data/az_roads_sf.RData'))


########################
###     CLEANUP      ###
########################

# reference for vars
# https://data-nifc.opendata.arcgis.com/datasets/nifc::wildland-fire-incident-locations/about)

# Low hanging fruit (mostly if not all NA)
# wfigs_az_sf <- wfigs_az_sf %>% select(-c(ABCDMisc,
#                                          FinalAcres,
#                                          FinalFireReportApprovedByTitle,
#                                          FinalFireReportApprovedByUnit,
#                                          FinalFireReportApprovedDate,
#                                          FireDepartmentID,
#                                          POOLegalDescQtr,
#                                          POOLegalDescQtrQtr,
#                                          POOLegalDescPrincipalMeridian,
#                                          POOLegalDescRange,
#                                          POOLegalDescSection,
#                                          POOLegalDescTownship,
#                                          CpxName,
#                                          CpxID,
#                                          IncidentComplexityLevel))
#
#
# # data for this project only
# wfigsaz_sf <- wfigs_az_sf %>% select(c(OBJECTID,
#                                        IncidentSize,
#                                        FireCause,
#                                        FireCauseGeneral,
#                                        FireCauseSpecific,
#                                        FireDiscoveryDateTime,
#                                        IncidentName,
#                                        IncidentShortDescription,
#                                        IncidentTypeCategory,
#                                        IncidentTypeKind,
#                                        InitialResponseAcres,
#                                        InitialResponseDateTime,
#                                        IrwinID,
#                                        IsFireCauseInvestigated,
#                                        POOCity,
#                                        POOCounty,
#                                        POOFips,
#                                        POODispatchCenterID,
#                                        PredominantFuelGroup,
#                                        PredominantFuelModel,
#                                        UniqueFireIdentifier,
#                                        EstimatedFinalCost,
#                                        79:98
# ))

################################
# Background and predction data#
################################
#
# ## Build covariate data for background points
#
# background_sf$distance_rd_primary <-
#   st_distance(background_sf, az_rd_primary) %>% apply(1, min)
#
# background_sf$distance_rd_secondary <-
#   st_distance(background_sf, az_rd_secondary) %>% apply(1, min)
#
# background_sf$distance_rd_4wd <-
#   st_distance(background_sf, az_rd_4wd) %>% apply(1, min)
#
#
# # dist_road covariates
#
# background_sf <- background_sf %>%
#   mutate(distance_rd_min_all = pmin(distance_rd_primary,
#                                     distance_rd_secondary,
#                                     distance_rd_4wd))
#
# background_sf <- background_sf %>%
#   mutate(distance_rd_min_prisec = pmin(distance_rd_primary,
#                                        distance_rd_secondary))
#
# background_sf$distance_rd_min_isprisec <- as.integer(
#   background_sf$distance_rd_min_all ==
#     background_sf$distance_rd_min_prisec)
#
# # generate random dates
#
# start_date <- ymd_hms("2014-01-01 00:00:00")
# end_date <- now()
# n <- nrow(background_sf)
#
# random_dates <- sample(seq(start_date, end_date, by = "min"), n, replace = TRUE)
# random_dates <- as.POSIXlt(random_dates)
#
# background_sf$FireDiscoveryDateTime <- random_dates
#
#
# ## Population density data
#
# population_data <- get_decennial(
#   geography = "tract",
#   variables = c(population="P001001"),
#   state = "AZ",
#   year = 2010,
#   geometry = TRUE
# )
# population_data$variable = population_data$value/st_area(population_data$geometry)
# names(population_data) <- c("GEOID","NAME","pop.density","pop.","geometry")
#
# population_data <- st_transform(population_data, crs = "EPSG:32612")
#
# background_sf <- st_join(background_sf, population_data, left = TRUE)
#
# ## Import Covariates
#
# background_nat <- read_csv(here('data/background_final.csv'))
#
# background_sf <- cbind(background_sf, background_nat[,11:19])


##################################
# Generate CSV for background_sf #
##################################
#
# coords <- st_coordinates(background_sf)
# df <- st_drop_geometry(background_sf)
# df$x <- coords[, 1]
# df$y <- coords[, 2]
# write.csv(df, file = 'predictions_sf.csv', row.names = FALSE)
#
# rm(df, coords)

##################################
# Grid predction dataframe update#
##################################


az_prediction_grid <- read_csv(here('data/az_prediction_grid_utm_latlon.csv'))

# az_prediction_grid <- az_prediction_grid %>% select(c(-1))

az_prediction_grid_sf <- st_as_sf(az_prediction_grid, coords = c("X", "Y"), crs = "EPSG:32612")

az_prediction_grid_sf <- st_transform(az_prediction_grid_sf, crs = 4326)

# Extract coordinates
coords_4326 <- st_coordinates(az_prediction_grid_sf)

# Create a dataframe with original coordinates
df <- data.frame(
  lon = coords_4326[,1],
  lat = coords_4326[,2]
)

az_prediction_grid <- cbind(az_prediction_grid, df)



az_prediction_grid_nat_covs <- read_csv(here('data/az_locations_all.csv'))

az_prediction_grid_nat_covs <- az_prediction_grid_nat_covs %>% select(,-c(1:5))

az_prediction_grid_sf <- cbind(az_prediction_grid_sf, az_prediction_grid_nat_covs)

az_prediction_grid_sf <- st_join(az_prediction_grid_sf, population_data, left = TRUE)



az_prediction_grid_sf$distance_rd_primary <-
  st_distance(az_prediction_grid_sf, az_rd_primary) %>% apply(1, min)

az_prediction_grid_sf$distance_rd_secondary <-
  st_distance(az_prediction_grid_sf, az_rd_secondary) %>% apply(1, min)

az_prediction_grid_sf$distance_rd_4wd <-
  st_distance(az_prediction_grid_sf, az_rd_4wd) %>% apply(1, min)


az_prediction_grid_sf <- az_prediction_grid_sf %>%
  mutate(distance_rd_min_prisec = pmin(distance_rd_primary,
                                       distance_rd_secondary))

az_prediction_grid_sf <- az_prediction_grid_sf %>%
  mutate(distance_rd_min_all = pmin(distance_rd_primary,
                                    distance_rd_secondary,
                                    distance_rd_4wd))

az_prediction_grid_sf$distance_rd_min_isprisec <- as.integer(az_prediction_grid_sf$distance_rd_min_all ==                                                     az_prediction_grid_sf$distance_rd_min_prisec)


################################
# READ IN NATIONAL FOREST SHP  #
################################

# # Read the shapefile into R
# forests <- st_read(here('data/Forest_Administrative_Boundaries_(Feature_Layer).shp'))
#
# naz_forests <- forests[forests$FORESTNAME=="Coconino National Forest" |
#                          forests$FORESTNAME=="Kaibab National Forest" |
#                          forests$FORESTNAME=="Apache-Sitgreaves National Forests"|
#                          forests$FORESTNAME=="Prescott National Forest",]



################################
#  #
################################