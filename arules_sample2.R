library(arules)
library(arulesViz)
library(Matrix)

# Sample data
DATADIR <- "./org-data"
file <- file.path(DATADIR, "ml-100k", "u.data")
# file <- file.path(DATADIR, "ml-1m", "ratings.dat")
# file <- file.path(DATADIR, "ml-10m", "ratings.dat")
# file <- file.path(DATADIR, "ml-20m", "ratings.csv")
# file <- file.path(DATADIR, "ml-latest", "ratings.csv")

# Load data
df <- read.table(file, header = F, col.names = c("userid", "itemid", "rating", "timestamp"))

# Convert data.frame to itemMatrix
df_matrix <- as(sparseMatrix(i = df$itemid, j = df$userid, x = 1), "nsparseMatrix")
df_items <- as(df_matrix, "itemMatrix")

# Mine frequent itemsets by apriori
rules <- apriori(df_items, parameter = list(supp = 0.12, minlen = 3, maxlen = 4, target = "rules"))
summary(rules)

# [TODO] Eliminate redundant rules
#  - The following method is not sufficient for big data because of memory size required.
# subset.matrix <- is.subset(rules, sparse = T)
# subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
# redundant <- colSums(subset.matrix, na.rm=T) >= 1
# rules.pruned <- rules[!redundant]
# rules <- rules.pruned

# Inspect
rules <- sort(rules, by="support", decreasing=TRUE)
inspect(rules[1:10])
rules <- sort(rules, by="confidence", decreasing=TRUE)
inspect(rules[1:10])
rules <- sort(rules, by="lift", decreasing=TRUE)
inspect(rules[1:10])

# Plot top items
itemFrequencyPlot(df_items, topN = 25)
