# This workflow extract values of interest from a local raster
# Load required libraries
library(terra)
library(sf)
library(ggplot2)

# Step 1: Load Fire Data (CSV with fire event locations)
wfigs_az <- read.csv(paste0('/Users/rowino/Library/CloudStorage/Box-Box/owino/',
                            'fall_semester/2024/Enviromental_stats/Group final proj/',
                            'STATS574E_final/data/wfigs_az.csv'))

# Step 2: Load Slope Raster (digital elevation model showing slope)
slope_raster <- rast(paste0('/Users/rowino/Library/CloudStorage/Box-Box/owino/',
                            'Arizona_raster/AZ_BAEA_pSlope_NAD83_12N.tif'))

# Step 3: Load NLCD Land Cover Data (National Land Cover Database for Arizona)
nlcd_raster <- rast(paste0('/Users/rowino/Library/CloudStorage/Box-Box/owino/',
                           'Arizona_raster/AZ_NLCD_2021_NAD8312N.tif'))

# Step 4: Reclassify NLCD Raster into binary categories for land cover types (forest, grass, shrub)
# Forest: Classes 41, 42, 43
# Grass: Class 71
# Shrub: Class 81

# Reclassification matrix for Forest (41, 42, 43 become 1, others are 0)
forest_matrix <- matrix(c(11,21,22,23,24,31,41,42,43,52,71,81,82,90,95,
                          0,0,0,0,0,0,1,1,1,0,0,0,0,0,0), ncol = 2)
forest_raster <- classify(nlcd_raster, forest_matrix)

# Reclassification matrix for Grass (Class 71 becomes 1, others are 0)
grass_matrix <- matrix(c(11,21,22,23,24,31,41,42,43,52,71,81,82,90,95,
                         0,0,0,0,0,0,0,0,0,0,1,0,0,0,0), ncol = 2)
grass_raster <- classify(nlcd_raster, grass_matrix)

# Reclassification matrix for Shrub (Class 81 becomes 1, others are 0)
shrub_matrix <- matrix(c(11,21,22,23,24,31,41,42,43,52,71,81,82,90,95,
                         0,0,0,0,0,0,0,0,0,0,0,1,0,0,0), ncol = 2)
shrub_raster <- classify(nlcd_raster, shrub_matrix)

#N/B: This will allow you to calculate proportion of the feature of interest

# Step 5: Convert Fire Data (CSV) to SpatVector 
wfigs_az_spat <- vect(wfigs_az, geom = c("InitialLongitude", "InitialLatitude"))
crs(wfigs_az_spat) <- "EPSG:4326"  # Set CRS (coordinate reference system)
wfigs_az_spat <- project(wfigs_az_spat, "EPSG:26912")  # Reproject to NAD83 / UTM Zone 12N

# Caution: You want your rasters and data to have the same projection 

# Step 6: Create Buffers around Fire Points (1000 meters)
wfigs_buffers_spat <- buffer(wfigs_az_spat, width = 1000)  

# Step 7: Extract Slope Values within Buffers
slope_buffer_values <- extract(slope_raster, wfigs_buffers_spat, fun = "mean", na.rm = TRUE)
wfigs_az$mean_slope <- slope_buffer_values$AZ_BAEA_pSlope_NAD83_12N  # Assign extracted values

# Ensure 'mean_slope' is numeric 
wfigs_az$mean_slope <- as.numeric(wfigs_az$mean_slope)

# Plot histogram for mean slope values
hist(wfigs_az$mean_slope, 
     main = "Histogram of Mean Slope Values", 
     xlab = "Slope (degrees)", col = "lightblue", 
     breaks = 20, na.rm = TRUE)

# Step 8: Extract Forest Cover Values within Buffers
forest_buffer_values <- extract(forest_raster, 
                                wfigs_buffers_spat, fun = "mean", na.rm = TRUE)
wfigs_az$mean_forest <- forest_buffer_values$Red  # Assign extracted forest values

# Ensure 'mean_forest' is numeric 
wfigs_az$mean_forest <- as.numeric(wfigs_az$mean_forest)

# Plot histogram for mean forest cover values
hist(wfigs_az$mean_forest, 
     main = "Histogram of Mean Forest Cover", 
     xlab = "Forest Cover (Binary: 0 or 1)", col = "lightgreen", breaks = 20, na.rm = TRUE)

# Step 9: Extract Grass Cover Values within Buffers
grass_buffer_values <- extract(grass_raster, 
                               wfigs_buffers_spat, fun = "mean",
                               na.rm = TRUE)
wfigs_az$mean_grass <- grass_buffer_values$Red  # Assign extracted grass values

# Ensure 'mean_grass' is numeric 
wfigs_az$mean_grass <- as.numeric(wfigs_az$mean_grass)

# Plot histogram for mean grass cover values
hist(wfigs_az$mean_grass, 
     main = "Histogram of Mean Grass Cover", 
     xlab = "Grass Cover (Binary: 0 or 1)", col = "lightyellow", 
     breaks = 20, na.rm = TRUE)

# Step 10: Extract Shrub Cover Values within Buffers
shrub_buffer_values <- extract(shrub_raster, 
                               wfigs_buffers_spat, fun = "mean", 
                               na.rm = TRUE)
wfigs_az$mean_shrub <- shrub_buffer_values$Red  # Assign extracted shrub values

# Ensure 'mean_shrub' is numeric (convert if necessary)
wfigs_az$mean_shrub <- as.numeric(wfigs_az$mean_shrub)

# Plot histogram for mean shrub cover values
hist(wfigs_az$mean_shrub, 
     main = "Histogram of Mean Shrub Cover", 
     xlab = "Shrub Cover (Binary: 0 or 1)", col = "lightcoral", breaks = 20, 
     na.rm = TRUE)

# Step 11: Clip Shrub Cover to Range [0, 1] and Rescale to Percentages
wfigs_az$mean_shrub_percentage <- pmin(pmax(wfigs_az$mean_shrub, 0), 1) * 100

# Plot histogram for shrub cover percentage
hist(wfigs_az$mean_shrub_percentage, breaks = 20, 
     main = "Histogram of Shrub Cover (%)", xlab = "Shrub Cover (%)", col = "lightgreen", border = "darkgreen", na.rm = TRUE)

# Step 12: Save Updated Data to CSV (overwrite original file)
write.csv(wfigs_az, paste0('/Users/rowino/Library/CloudStorage/Box-Box/owino/',
                           'fall_semester/2024/Enviromental_stats/Group final proj/',
                           'STATS574E_final/data/wfigs_az.csv_all_cov'), row.names = FALSE)
