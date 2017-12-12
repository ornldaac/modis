# Load the library
library(MODISTools)
# Get a list of avilable MODIS products
GetProducts()
# Get a list of Bands for the specified products
GetBands("MYD15A2H")
# Get a list of Dates available for the specified product and location 
GetDates(40.1,-110.2,"MYD15A2H")
# Get subset data for the specified product, band, location, date range, and size
GetSubset(40,-110,"MYD15A2H", "Lai_500m","A2007065","A2007065", 1,1)