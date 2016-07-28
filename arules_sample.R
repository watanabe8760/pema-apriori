# Market Basket Analysis with R
#  - http://www.salemmarafi.com/code/market-basket-analysis-with-r/
#
library(arules)
library(arulesViz)
library(datasets)

data(Groceries)
summary(Groceries)

# Create an item frequency plot for the top 20 items
itemFrequencyPlot(Groceries,topN=20,type="absolute")

# Get the rules
rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.8))
summary(rules)

# Show the top 5 rules, but only 2 digits
options(digits=2)
inspect(rules[1:5])

# Sort by
rules <- sort(rules, by="support", decreasing=TRUE)
inspect(rules)
rules <- sort(rules, by="confidence", decreasing=TRUE)
inspect(rules)
rules <- sort(rules, by="lift", decreasing=TRUE)
inspect(rules)


# Set max length as 3
rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.8, maxlen = 3))
inspect(sort(rules, by = "support", decreasing = T))

# Eliminate repeated rules
subset.matrix <- is.subset(rules, rules)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
rules.pruned <- rules[!redundant]
rules <- rules.pruned


# Set right hand side
rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.08),
                 appearance = list(default = "lhs",rhs = "whole milk"),
                 control = list(verbose = F))
rules <- sort(rules, decreasing = TRUE, by = "confidence")
inspect(rules[1:5])


# Set left hand side
rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.15, minlen = 2),
                 appearance = list(default = "rhs", lhs = "whole milk"),
                 control = list(verbose = F))
rules <- sort(rules, decreasing = TRUE, by = "confidence")
inspect(rules[1:5])


plot(rules, method = "graph", interactive = TRUE, shading = NA)
