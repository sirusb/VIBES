#' CLR Transformation
#'
#' Util function to transform raw counts using centered log ratio transform
#' approximation (the same approach as the microbiome package used in the
#' experiments)
#'
#' @param matrix Input count matrix with samples on rows and species in columns
#'
#' @return matrix. A clr transformed matrix class with samples on rows and species
#'  in columns
#'
#' @examples
#' # Original data
#' require(VIBES)
#' em_clr <- VIBES:::clr_transformation(PRJNA208535_matrix)
#' # Transformed data
#' print(em_clr)
clr_transformation <- function(matrix){
  m_t <- t(matrix)
  # Minor constant 1e-32 is compared to zero to avoid zero
  # division. Essentially zero counts will then remain zero
  # and otherwise this wont have any effect.
  m_t <- apply(m_t, 2, function(x) {
    x/max(sum(x), 1e-32)
  })
  if (any(m_t == 0)) {
    v <- as.vector(m_t)
    minval <- min(v[v > 0])/2
    m_t <- m_t + minval
  }
  # Pick samples x taxa abundance matrix
  d <- t(apply(m_t, 2, function(x) {
    log(x) - mean(log(x))
  }))
  return(d)
}
