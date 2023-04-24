
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VMC

<!-- badges: start -->
<!-- badges: end -->

Welcome to the homepage of `VMC` package!

This package computes clusters of biological significance from 20
species from vaginal microbiome.

## Description

The package works with three types of input data: matrix, dataframe and
phyloseq. In case the provided object is a phyloseq the package
automatically extracts the matrix of interest to execute the rest. In
case the object is a dataframe or a matrix the samples must be in the
rows and the species in the columns.

The 20 species used by the package are as follows, and regardless of the
object passed must be named as such (`Genus_species`):
Aerococcus_christensenii, Campylobacter_ureolyticus, Finegoldia_magna,
Lactobacillus_crispatus, Lactobacillus_gasseri, Porphyromonas_uenonis,
Prevotella_bivia, Prevotella_timonensis, Atopobium_vaginae,
Lactobacillus_iners, Prevotella_amnii, Prevotella_disiens,
Staphylococcus_haemolyticus, Veillonella_montpellierensis,
Alistipes_finegoldii, Gardnerella_vaginalis, Mycoplasma_hominis,
Mobiluncus_mulieris, Prevotella_buccalis and Sneathia_sanguinegens.

It consists of 4 functions:

- 3 internal
  - get_data: this function extract a matrix from a phyloseq object
  - clr_transformation: perform clr transformation (like microbiome
    package)
  - model_predict: use our trained model to predict the clusters
- 1 available to the user
  - get_cluster: uses inner functions to return the user’s original
    object with cluster memberships added.

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
