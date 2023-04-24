
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VMC

<!-- badges: start -->
<!-- badges: end -->

Welcome to the homepage of `VMC` package!

This package computes clusters of biological significance from vaginal
microbiome profiles.

## Description

The package works with three types of input data: matrix, dataframe and
phyloseq. It consists of 4 functions: - 3 internal: - get_data: -
clr_transformation: - model_predict: - 1 one available to the user: -
get_cluster:

## Installation

You only need to call `install_github` function in `devtools` to install
`VMC`. Be aware of package dependencies.

``` r
# First install devtools
install.packages("devtools")
# Install VMC from github
devtools::install_github("DiegoFE94/VMC")
```

## Start

This

This is a basic example which shows you how to solve a common problem:

``` r
library(VMC)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
