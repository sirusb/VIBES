#' Get Clusters
#'
#' Main function: from an input object (which can be a matrix, a data frame or
#' a phyloseq), this function returned the same object with the probabilities
#' and the cluster membership label attached
#'
#' @param object (phyloseq, matrix or data frame). In the case of the latter two,
#' the samples in the rows and the species in the columns
#'
#' @return object (phyloseq, matrix or data frame). Same input class object with
#' with the probabilities and the cluster membership label attached
#' @export
#'
#' @import phyloseq
#'
#' @examples
#' # Original sample data (phyloseq case)
#' print(phyloseq::sample_data(example_pseq))
#' new_pseq <- get_clusters(example_pseq)
#' # New sample data (phyloseq case)
#' print(phyloseq::sample_data(new_pseq))
#'  # Original sample data (matrix case)
#' print(example_matrix)
#' new_matrix <- get_clusters(example_matrix)
#' # New sample data (matrix case)
#' print(new_matrix)
get_clusters <- function(object){
  # 1.Check data class
  if (!(class(object)[1] %in% c("matrix", "data.frame", "phyloseq"))) {
    stop("Please use only matrix, dataframe or phyloseq object")
  }

  # 2.If input object is a phyloseq load package and extract dataset in matrix
  # format. If input class is dataframe its transformed in matrix format
  if(class(object)[1] == "phyloseq"){
    data <- get_data(pseq = object)
  }else if(class(object)[1] == "data.frame"){
    data <- matrix(object)
  }else if(class(object)[1] == "matrix"){
    data <- object
  }

  #3.Check species (change this if rename clusters)
  species <- unique(c(rownames(pruned_glmnet$nbeta$N),
                      rownames(pruned_glmnet$nbeta$IDN),
                      rownames(pruned_glmnet$nbeta$IDD),
                      rownames(pruned_glmnet$nbeta$D)))[-1]
  for (spp in species) {
    if (!(spp %in% colnames(data))) {
      stop(paste0("Specie '", spp, "' not found in input data"))
    }
  }
  # 4.Retain species
  data <- data[,species]

  # 5.CLR transformation
  data <- clr_transformation(matrix = data)

  # 6.Add results to original object
  pred <- model_predict(newdata = data)

  # 7.Add results to original data
  if(class(object)[1] == "phyloseq"){
    sam <- data.frame(phyloseq::sample_data(object))
    sam <- cbind(sam, pred)
    phyloseq::sample_data(object) <- sam
  }else if(class(object)[1] == "data.frame"){
    object <- cbind(object, pred)
  }else if(class(object)[1] == "matrix"){
    object <- cbind(object, pred)
  }
  return(object)
}
