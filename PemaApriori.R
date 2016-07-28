require(RevoPemaR)
library(Matrix)
library(arules)

PemaApriori <- setPemaClass(
  Class = "PemaApriori", 
  
  contains = "PemaBaseClass",

  fields = list(
    item_col = "character",  # item column name
    user_col = "character",  # user column name (can be transaction column)
    item_id_max = "integer", # max id of items
    user_id_max = "integer", # max id of users
    item_x_user = "ANY",     # sparse matrix, row is item, column is user (transaction)
    params = "list"),        # parameter list for apriori function
  
  methods = list(
    "initialize" = function(item_col = "item", user_col = "user", 
                            item_id_max = 10000L, user_id_max = 10000L, params = list(), ...) {
      callSuper(...)
      usingMethods(.pemaMethods)
      
      item_col <<- item_col
      user_col <<- user_col
      item_id_max <<- item_id_max
      user_id_max <<- user_id_max
      item_x_user <<- NULL
      params <<- params
      rules <<- NULL
    },
    
    "processData" = function(dataList) {
      # Convert data.frame to sparse matrix
      mtrx <- sparseMatrix(i = dataList[[item_col]],
                           j = dataList[[user_col]],
                           dims = c(item_id_max, user_id_max))
      # Add up sparse matrix
      if (is.null(item_x_user)) {
        item_x_user <<- mtrx
      } else {
        item_x_user <<- as(item_x_user + mtrx, "ngCMatrix")
      }
      
      invisible(NULL)
    },
    
    "updateResults" = function(pemaAprioriObj) {
      # Only used in distributed environment
      item_x_user <<- as(item_x_user + pemaAprioriObj$item_x_user, "ngCMatrix")
      invisible(NULL)
    },
    
    "processResults" = function() {
      # Apply apriori
      apriori(item_x_user, parameter = params)
    }
  ) # End of methods
)