#' Get VIBES
#'
#' This function uses an elastic net model (trained with the knowledge extracted
#' from previous cluster analyses) to predict the membership of the input samples
#' to the VIBES clusters. Based on the 20 species raw counts, it assigns the samples
#' to the VIBES clusters.
#'
#' @param object (phyloseq, matrix or data frame). In the case of the latter two,
#' the samples in the rows and the species in the columns
#' @param column (only for phyloseq) Input column number occupied by the taxonomic rank Species. Default is Null and take last column
#'
#' @return object (phyloseq, matrix or data frame). Same input class object with
#' with the probabilities and the cluster membership label attached
#' @export
#'
#' @import phyloseq
#'
#' @examples
#' # Original sample data (phyloseq case)
#' print(phyloseq::sample_data(PRJNA208535))
#' new_pseq <- get_VIBES(PRJNA208535)
#' # New sample data (phyloseq case)
#' print(phyloseq::sample_data(new_pseq))
get_VIBES <- function(object, column = NULL){
  # 0.Remember of species names
  mssg <- "Remember that the species names must be in the following format: Genus_species"
  cat(mssg, "\n")
  # 1.Check data class
  if (!(class(object)[1] %in% c("matrix", "data.frame", "phyloseq"))) {
    stop("Please use only matrix, dataframe or phyloseq object")
  }

  # 2.If input object is a phyloseq load package and extract dataset in matrix
  # format. If input class is dataframe its transformed in matrix format
  if(class(object)[1] == "phyloseq"){
    data <- get_data(pseq = object, column = column)
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
  miss_sps <- setdiff(species, colnames(data))
  if (length(miss_sps) > 0) {
    warning("The following species are not present in the input data: ", paste(miss_sps, collapse = ", "))
  }

  detected_species = intersect(species, colnames(data))
  

  mat1 = data[,detected_species]

  mat2 = matrix(0, nrow = nrow(mat1), ncol = length(miss_sps))
  colnames(mat2) = miss_sps
  rownames(mat2) = rownames(data)
  
  # 4.Retain species
  data = cbind(mat1, mat2)


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
