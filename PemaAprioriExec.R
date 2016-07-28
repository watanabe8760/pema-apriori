# PEMA class execution -------------------------------------------------
source("PemaApriori.R")
library(RevoScaleR)

# Load data
#  choice of files : ml100k.xdf, ml001m.xdf, ml010m.xdf, ml020m.xdf, mllatest.xdf
#  chunk to read   :    1           1           3            5           6
xdf <- RxXdfData(file.path("./input", "ml020m.xdf"))

# Check max of movie_id and user_id
maxes <- rxSummary(~ movie_id + user_id, xdf, summaryStats = "Max")

# Execute apriori
rules <- pemaCompute(PemaApriori(), xdf, 
                     item_col = "movie_id", user_col = "user_id",
                     item_id_max = as.integer(maxes$sDataFrame$Max[1]), 
                     user_id_max = as.integer(maxes$sDataFrame$Max[2]),
                     params = list(minlen = 3, maxlen = 4),
                     reportProgress = 3)

# Inspect result
rules <- sort(rules, by="lift", decreasing=TRUE)
inspect(rules[1:10])




# Normal execution ------------------------------------------------------
library(data.table)
library(arules)

# Load data
#  choice of files : ml100k.csv, ml001m.csv, ml010m.csv, ml020m.csv, mllatest.csv
csv <- fread(file.path("./input", "ml020m.csv"), data.table = F)

# Convert data.frame to sparse matrix
mtrx <- sparseMatrix(i = csv[["movie_id"]],
                     j = csv[["user_id"]])

# Apply apriori
rules_ <- apriori(mtrx, parameter = list(minlen = 3, maxlen = 4))

# Inspect result
rules_ <- sort(rules_, by="lift", decreasing=TRUE)
inspect(rules_[1:10])

