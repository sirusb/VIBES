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
#' @importFrom glmnet glmnet_softmax
#'
#' @examples
#' # Data from which you want to predict cluster labels
#' print(example_matrix)
#' em_clr <- clr_transformation(example_matrix)
#' pred <- model_predict(example_matrix)
#' # Probabilities and label for each sample
#' print(pred)
model_predict <- function(newdata){
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
  class <- apply(cp, 3, glmnet:::glmnet_softmax)
  #Bind both
  response$p_cluster <- class[,]
  return(response)
}
