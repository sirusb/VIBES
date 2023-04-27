
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VMC Vaginal Microbiome Cluistering

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The `VMC` package computes clusters of biological significance from 20
species from vaginal microbiome.

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

## Installation

The installation of `VMC` is done via GitHub. For this you need to
install the `devtools` package via the function `install_github`. In
addition `VMC` has dependencies via Bioconductor so it will be necessary
to install the associated `BiocManager` package. This will allow you to
install the `phyloseq` package.

``` r
# Installation requires devtools and bioconductor, please use the following commands
if (!requireNamespace("BiocManager"))
    install.packages("BiocManager")
BiocManager::install()
install.packages("devtools")
# Before installing VMC, you need also to install the dependent package `phyloseq`
BiocManager::install("phyloseq")
# Install VMC from github
devtools::install_github("DiegoFE94/VMC")
```

## Usage

Before starting the demonstration, you need to load the following
packages:

``` r
require(phyloseq)
#> Loading required package: phyloseq
library(VMC)
```

This example works with a phyloseq object. In this case the phyloseq
object is made up of the counts of 1657 microbiome profiles.

``` r
data("example_pseq")
# Load a pseq with 1657 samples 22 species and 7 taxonomic ranks
print(example_pseq)
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
tax_table(example_pseq)[1:5,6:7]
#> Taxonomy Table:     [5 taxa by 2 taxonomic ranks]:
#>                           Genus           Species                    
#> Aerococcus_christensenii  "Aerococcus"    "Aerococcus_christensenii" 
#> Alistipes_finegoldii      "Alistipes"     "Alistipes_finegoldii"     
#> Atopobium_vaginae         "Atopobium"     "Atopobium_vaginae"        
#> Campylobacter_ureolyticus "Campylobacter" "Campylobacter_ureolyticus"
#> Finegoldia_magna          "Finegoldia"    "Finegoldia_magna"
```

Before running the package, the clinical data is made up of 25
variables. Once the package is run, it will return 5 more variables that
correspond to the probability and membership of each cluster.

``` r
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

## Interpreting the results

The `get_clusters()` function returns 5 variables/columns to the
original object:

1.  N: probability (0-1) of belonging to cluster N.
2.  IDN: probability (0-1) of belonging to cluster IDN.
3.  IDD: probability (0-1) of belonging to cluster IDD.
4.  D: probability (0-1) of belonging to cluster D.
5.  p_cluster: label (N, IDN, IDD, D) indicating to which cluster the
    profile belongs

## Contributing

We welcome contributions to `VMC`. Please submit a pull request or open
an issue on the GitHub repository.

## License

`VMC` is released under the MIT License.
