# This script enables you to download meteorological data
# The specifically downloads average per year
# Install and load required packages
library(sf)
library(httr)
library(jsonlite)
library(dplyr)
library(purrr)

# 1. Read CSV file with locations
locations_file <- past0('/Users/rowino/Library/CloudStorage/Box-Box/owino/',
                        'fall_semester/2024/Enviromental_stats/Group final proj/',
                        'STATS574E_final/data/wfigs_az.csv')

locations <- read.csv(locations_file)

# 2. Convert latitude and longitude to sf object
locations_sf <- st_as_sf(locations, 
                         coords = c("InitialLongitude", "InitialLatitude"), 
                         crs = 4326)

# 3. Create a 1000-meter buffer around each point
buffered_locations <- st_buffer(locations_sf, dist = 1000)  

# 4. Create a function to extract the bounding box of each geometry
get_bounding_box <- function(buffer) {
  bbox <- st_bbox(buffer)  # Extracts the bounding box (min, max lat, long)
  return(bbox)
}

# 5. Get bounding boxes for each buffered location using purrr::map
bounding_boxes <- map(buffered_locations$geometry, get_bounding_box)
bbox_df <- do.call(rbind, bounding_boxes)
bbox_df <- data.frame(bbox_df)
colnames(bbox_df) <- c("min_lon", "min_lat", "max_lon", "max_lat")
head(bbox_df)

# 6. Function to get Daymet data (temperature and precipitation) for a date
get_daymet_data <- function(lat, lon, date) {
  year <- as.integer(format(as.Date(date), "%Y"))
  start_date <- paste0(year, "-01-01")  # Start of the year
  end_date <- paste0(year, "-12-31")    # End of the year
  
  # Daymet API URL
  base_url <- "https://daymet.ornl.gov/single-pixel/api/data"
  
  params <- list(
    lat = lat,
    lon = lon,
    vars = "tmax,tmin,prcp",  # Max, min temperature and precipitation
    start = start_date,
    end = end_date,
    format = "json"
  )
  
  response <- GET(base_url, query = params)
  
  # Print the status code for debugging
  print(status_code(response))
  
  if (status_code(response) == 200) {
    data <- fromJSON(content(response, "text"))
    if ("data" %in% names(data)) {
      temp_max <- data$data$tmax
      temp_min <- data$data$tmin
      precip <- data$data$prcp
      return(list(temp_max = temp_max, temp_min = temp_min, precip = precip))
    } else {
      message("No data available for the specified location and date range.")
      return(NULL)
    }
  } else {
    message("API request failed with status code: ", status_code(response))
    return(NULL)
  }
}

# 7. Function to calculate the center of a bounding box
get_center <- function(bbox) {
  lat_center <- (bbox["min_lat"] + bbox["max_lat"]) / 2
  lon_center <- (bbox["min_lon"] + bbox["max_lon"]) / 2
  return(c(lat_center, lon_center))
}

# 8. Process in chunks to avoid memory issues
chunk_size <- 1000
num_chunks <- ceiling(nrow(locations) / chunk_size)  # Calculate the number of chunks

# Initialize a list to store the results from each chunk
all_results <- list()

# Loop through chunks with progress feedback (manual progress bar using `cat()`)
for (chunk in 1:num_chunks) {
  # Determine the row indices for the current chunk
  start_row <- (chunk - 1) * chunk_size + 1
  end_row <- min(chunk * chunk_size, nrow(locations))
  
  # Subset the current chunk
  chunk_data <- locations[start_row:end_row, ]
  
  # Convert latitude and longitude to sf  object for the chunk
  chunk_sf <- st_as_sf(chunk_data, coords = c("InitialLongitude", "InitialLatitude"), crs = 4326)
  
  # Create 1000-meter buffer around each point for the chunk
  buffered_chunk <- st_buffer(chunk_sf, dist = 1000)  # 1000 meters buffer
  
  # Get bounding boxes for each buffered location in the chunk
  bounding_boxes <- map(buffered_chunk$geometry, get_bounding_box)
  bbox_df <- do.call(rbind, bounding_boxes)
  bbox_df <- data.frame(bbox_df)
  colnames(bbox_df) <- c("min_lon", "min_lat", "max_lon", "max_lat")
  
  # Initialize vectors to store the results for the chunk
  mean_temp_max <- c()
  mean_temp_min <- c()
  mean_precip <- c()
  
  # 9. Loop through each bounding box in the chunk and fetch Daymet data
  for (i in 1:nrow(bbox_df)) {
    # Get the center coordinates of the bounding box
    center_coords <- get_center(bbox_df[i, ])
    lat <- center_coords[1]
    lon <- center_coords[2]
    
    # Get the date of interest (FireDiscoveryDateTime)
    fire_date <- chunk_data$FireDiscoveryDateTime[i]  #date col
    
    # Get Daymet data for the specific date
    daymet_data <- tryCatch({
      get_daymet_data(lat, lon, fire_date)
    }, error = function(e) {
      message("Error fetching data for index ", i, ": ", e)
      return(NULL)
    })
    
    if (!is.null(daymet_data)) {
      # Calculate the mean of temperature and precipitation (averaged over the year)
      mean_temp_max <- c(mean_temp_max, mean(daymet_data$temp_max, na.rm = TRUE))
      mean_temp_min <- c(mean_temp_min, mean(daymet_data$temp_min, na.rm = TRUE))
      mean_precip <- c(mean_precip, mean(daymet_data$precip, na.rm = TRUE))
    } else {
      # If no data is returned, assign NA
      mean_temp_max <- c(mean_temp_max, NA)
      mean_temp_min <- c(mean_temp_min, NA)
      mean_precip <- c(mean_precip, NA)
    }
  }
  
  # 10. Add the mean temperature and precipitation to the chunk data
  chunk_data$Temp_Max_Buffered <- mean_temp_max
  chunk_data$Temp_Min_Buffered <- mean_temp_min
  chunk_data$Precipitation_Buffered <- mean_precip
  
  # 11. Save the chunk's results into a CSV file
  chunk_filename <- paste0("locations_chunk_", chunk, "_with_buffered_daymet_data.csv")
  write.csv(chunk_data, chunk_filename, row.names = FALSE)
  
  # Add the chunk result to the list of all results
  all_results[[chunk]] <- chunk_data
  
  # Print progress
  cat("Processed chunk ", chunk, " of ", num_chunks, "\n")
}

# 12. Combine all the results into a single data frame
final_locations <- bind_rows(all_results)

# 13. Save the final combined results to a CSV file
write.csv(final_locations, 
          "locations_with_all_buffered_daymet_data.csv", row.names = FALSE)

# 14. View the combined data (first few rows)
head(final_locations)
