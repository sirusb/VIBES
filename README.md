
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
# Installation requires bioconductor and devtools, please use the following commands
if (!requireNamespace("BiocManager"))
    install.packages("BiocManager")
BiocManager::install()
install.packages("devtools")
# Before installing VMC, you need also to install the dependent packages `phyloseq` and `glmnet`
BiocManager::install("phyloseq")
install.packages('glmnet')
# Install VMC from github
devtools::install_github("DiegoFE94/VMC")
```

## Start

Before starting the demonstration, you need to load the following
packages:

    require(phyloseq)
    require(glmnet)

This is a basic example which shows you how to use the package:

``` r
library(VMC)
data("example_pseq")
# Load a pseq with 1657 samples 22 species and 7 taxonomic ranks
print(example_pseq)
#> Loading required package: phyloseq
#> phyloseq-class experiment-level object
#> otu_table()   OTU Table:         [ 22 taxa and 1657 samples ]
#> sample_data() Sample Data:       [ 1657 samples by 25 sample variables ]
#> tax_table()   Taxonomy Table:    [ 22 taxa by 7 taxonomic ranks ]
#> refseq()      DNAStringSet:      [ 22 reference sequences ]
# Note that the otu table is made up of the counts
otu_table(example_pseq)[1:5,1:5]
#> OTU Table:          [5 taxa and 5 samples]
#>                      taxa are columns
#>           Aerococcus_christensenii Alistipes_finegoldii Atopobium_vaginae
#> SRR902006                     5031                    0              2144
#> SRR902881                       14                    0                 0
#> SRR903842                        0                    0                 0
#> SRR903941                       69                    0                 0
#> SRR903945                       49                    0                29
#>           Campylobacter_ureolyticus Finegoldia_magna
#> SRR902006                         0              279
#> SRR902881                         0                0
#> SRR903842                         0                0
#> SRR903941                         0                0
#> SRR903945                         0                5
# Sample data has no info about clusters
sample_data(example_pseq)[1:5,20:25]
#>           VAG_ITCH VAG_BURN VAG_DIS MENSTRU1 MENSTRU2 MENSTRU3
#> SRR902006       NA       NA      NA       NA       NA       NA
#> SRR902881        0        0       0       NA       NA       NA
#> SRR903842        0        0       0       NA       NA       NA
#> SRR903941        0        0       0       NA       NA       NA
#> SRR903945        0        0       0       NA       NA       NA
# Compute clusterization
pseq_w_clusters <- get_clusters(object = example_pseq)
# Check sample data of the new object 'pseq_w_clusters'
sample_data(pseq_w_clusters)[1:5,25:30]
#>           MENSTRU3            N       IDN          IDD            D p_cluster
#> SRR902006       NA 2.883447e-18 0.9998651 3.257710e-06 1.315948e-04       IDN
#> SRR902881       NA 7.292814e-24 1.0000000 9.895719e-12 8.154546e-10       IDN
#> SRR903842       NA 2.211632e-20 1.0000000 3.602075e-10 1.755376e-08       IDN
#> SRR903941       NA 4.992614e-26 1.0000000 1.369296e-10 8.586513e-09       IDN
#> SRR903945       NA 3.820220e-24 0.9941218 1.527713e-07 5.878046e-03       IDN
```
