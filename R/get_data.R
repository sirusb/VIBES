#' Get Data (from Phyloseq object)
#'
#' Util function to extract a matrix class with samples on rows and species on
#' columns from a phyloseq object
#'
#' @param pseq Input phyloseq object
#'
#' @return matrix. A matrix class with samples on rows and species in columns
#'
#' @import phyloseq
#'
#' @examples
#' # Original ASV table
#' print(phyloseq::otu_table(example_pseq))
#' m <- get_data(example_pseq)
#' # Output matrix with taxas names instead ASVs names
#' print(m)
get_data <- function(pseq){
  # Ensure aglom by last level (species)
  pseq <- phyloseq::tax_glom(pseq, utils::tail(colnames(pseq@tax_table), n = 1))
  # Extract dataframe from phyloseq
  otu <- phyloseq::otu_table(pseq)
  if (phyloseq::taxa_are_rows(pseq) == TRUE){
    otu <- t(otu)
  }
  df <- as.data.frame(otu)
  # Change otus names to their corresponding tax names
  colnames(df) <- as.data.frame(phyloseq::tax_table(pseq))[,ncol(phyloseq::tax_table(pseq))]
  return(as.matrix(df))
}
