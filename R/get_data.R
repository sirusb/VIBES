#' Get Data (from Phyloseq object)
#'
#' Util function to extract a matrix class with samples on rows and species on
#' columns from a phyloseq object
#'
#' @param pseq Input phyloseq object
#' @param column Input column number occupied by the taxonomic rank Species. Default is Null and take last column
#'
#' @return matrix. A matrix class with samples on rows and species in columns
#'
#' @import phyloseq
#'
#' @examples
#' # Original ASV table
#' require(VIBES)
#' m <- VIBES:::get_data(PRJNA208535)
#' # Output matrix with taxas names instead ASVs names
#' print(m)
get_data <- function(pseq, column = NULL){
  # Aglom by species
  if (is.null(x = column)) {
    # Ensure aglom by last level (usually species)
    pseq <- phyloseq::tax_glom(pseq, utils::tail(colnames(pseq@tax_table), n = 1))
  }else{
    pseq <- phyloseq::tax_glom(pseq, colnames(pseq@tax_table)[column])
  }
  # Extract dataframe from phyloseq
  otu <- phyloseq::otu_table(pseq)
  if (phyloseq::taxa_are_rows(pseq) == TRUE){
    otu <- t(otu)
  }
  df <- as.data.frame(otu)
  # Change otus names to their corresponding tax names
  if (is.null(x = column)) {
    colnames(df) <- as.data.frame(phyloseq::tax_table(pseq))[,ncol(phyloseq::tax_table(pseq))]
  }else{
    colnames(df) <- as.data.frame(phyloseq::tax_table(pseq))[,column]
  }
  return(as.matrix(df))
}
