#' Model Predict
#'
#' Util function to predict sample membership of each cluster class
#'
#' @param newdata A clr transformed matrix class with samples on rows and
#' species on columns
#'
#' @return data frame. A data frame class object with probabilities of belonging to each cluster
#' as well as the label of the cluster with the highest probability of
#' membership
#'
#'
#' @examples
#' # Data from which you want to predict cluster labels
#' require(VIBES)
#' em_clr <- VIBES:::clr_transformation(PRJNA208535_matrix)
#' pred <- VIBES:::model_predict(PRJNA208535_matrix)
#' # Probabilities and label for each sample
#' print(pred)
model_predict <- function(newdata){
  # Declares glmnet function not exportable
  glmnet_softmax <- function (x, ignore_labels = FALSE){
    d <- dim(x)
    dd <- dimnames(x)[[2]]
    if (is.null(dd) || !length(dd))
      ignore_labels = TRUE
    nas = apply(is.na(x), 1, any)
    if (any(nas)) {
      pclass = rep(NA, d[1])
      if (sum(nas) < d[1]) {
        pclass2 = glmnet_softmax(x[!nas, ], ignore_labels)
        pclass[!nas] = pclass2
        if (is.factor(pclass2))
          pclass = factor(pclass, levels = seq(d[2]), labels = levels(pclass2))
      }
    }
    else {
      maxdist <- x[, 1]
      pclass <- rep(1, d[1])
      for (i in seq(2, d[2])) {
        l <- x[, i] > maxdist
        pclass[l] <- i
        maxdist[l] <- x[l, i]
      }
      dd <- dimnames(x)[[2]]
      if (!ignore_labels)
        pclass = factor(pclass, levels = seq(d[2]), labels = dd)
    }
    pclass
  }
  # 1.Pre-processing of data for betas multiplication
  dd <- dim(newdata)
  if (inherits(newdata, "sparseMatrix"))
    newdata = methods::as(newdata, "dMatrix")
  npred = dd[[1]]
  dn = list(names(pruned_glmnet$nbeta), dimnames(pruned_glmnet$nbeta[[1]])[[2]],
            dimnames(newdata)[[1]])
  dp = array(0, c(pruned_glmnet$nclass, pruned_glmnet$nlambda, npred),
             dimnames = dn)
  # 2.Multiplication by betas
  for (i in seq(pruned_glmnet$nclass)) {
    rn <- rownames(pruned_glmnet$nbeta[[i]])
    rn <- rn[-1]
    fitk = methods::cbind2(1, newdata[,rn]) %*% (pruned_glmnet$nbeta[[i]])
    dp[i, , ] = dp[i, , ] + t(as.matrix(fitk))
  }
  # 3.Results are extracted
  pp = exp(dp)
  psum = apply(pp, c(2, 3), sum)
  # Response
  response = aperm(pp/rep(psum, rep(pruned_glmnet$nclass,
                                    pruned_glmnet$nlambda * npred)),
                   c(3,1, 2))
  response <- as.data.frame(response)
  colnames(response) <- substr(colnames(response), 1,
                               nchar(colnames(response))-2)
  cp = aperm(dp, c(3, 1, 2))
  # Class
  class <- apply(cp, 3, glmnet_softmax)
  # Bind both
  response$p_cluster <- class[,]
  # 4.Renaming of clusters with final names
  names(response)[names(response) == "N"] <- "VCS.I"
  names(response)[names(response) == "IDN"] <- "VCS.II"
  names(response)[names(response) == "IDD"] <- "VCS.III"
  names(response)[names(response) == "D"] <- "VCS.IV"
  # 4.Renaming of assigned cluster with final names
  response$p_cluster[response$p_cluster == "N"] <- "VCS-I"
  response$p_cluster[response$p_cluster == "IDN"] <- "VCS-II"
  response$p_cluster[response$p_cluster == "IDD"] <- "VCS-III"
  response$p_cluster[response$p_cluster == "D"] <- "VCS-IV"
  return(response)
}
