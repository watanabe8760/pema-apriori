library(data.table)
library(dplyr)
library(RevoScaleR)

# MovieLens data sets
#  - https://grouplens.org/datasets/movielens/
ORGDIR <- "./org-data"
ml100k <- file.path(ORGDIR, "ml-100k", "u.data")
ml001m <- file.path(ORGDIR, "ml-1m", "ratings.dat")
ml010m <- file.path(ORGDIR, "ml-10m", "ratings.dat")
ml020m <- file.path(ORGDIR, "ml-20m", "ratings.csv")
mllatest <- file.path(ORGDIR, "ml-latest", "ratings.csv")
movie <- file.path(ORGDIR, "ml-latest", "movies.csv")

# Movie titles master
movie_master <- fread(movie, data.table = F)
names(movie_master) <- c("movie_id", "title", "genres")

create_files <- function(org, special_sep, header, master, file_name) {
  #
  # Convert original data into standardized csv and xdf files.
  #
  OUTDIR <- "./input"
  COLNAMES <- c("user_id", "movie_id", "rating", "timestamp")
  
  if (special_sep) {
    df <- read.table(org, sep = ":", header = header, colClasses = c(NA, "NULL"))
    names(df) <- COLNAMES
  } else {
    df <- fread(org, header = header, col.names = COLNAMES, data.table = F)
  }
  
  # Join movie master
  df <- left_join(df, master)
  
  # Create csv file
  write.csv(df, file.path(OUTDIR, paste0(file_name, ".csv")), row.names = F)
  # Create xdf file
  rxDataStep(df, file.path(OUTDIR, paste0(file_name, ".xdf")), overwrite = T,
             rowsPerRead = 4200000, reportProgress = 3)
}

# Execute
create_files(ml100k, F, F, movie_master, "ml100k")
create_files(ml001m, T, F, movie_master, "ml001m")
create_files(ml010m, T, F, movie_master, "ml010m")
create_files(ml020m, F, T, movie_master, "ml020m")
create_files(mllatest, F, T, movie_master, "mllatest")

# Confirmation
dim(RxXdfData(file.path("./input", "ml100k.xdf")))
dim(RxXdfData(file.path("./input", "ml001m.xdf")))
dim(RxXdfData(file.path("./input", "ml010m.xdf")))
dim(RxXdfData(file.path("./input", "ml020m.xdf")))
dim(RxXdfData(file.path("./input", "mllatest.xdf")))

# Not to have the conflict in combine and union functions with arules package in the later process
detach("package:dplyr", unload=TRUE)
