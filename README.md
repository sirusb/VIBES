
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VIBES - VagInal Bacterial subtyping using machine learning for Enhanced classification of bacterial vaginosiS

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`VIBES` is a pretrained Elastic Net (glmnet) algorithm for classifying
the vaginal microbiome into clusters of biological significance due to
their species profile. `VIBES` directly works with the raw counts of
vaginal microbiome species. From these counts, the samples are
classified into 4 different clusters (VCS-I, VCS-II, VCS-III, VCS-IV).
`VIBES` works with three types of input data: matrix, dataframe and
phyloseq. In case the provided object is a phyloseq the package
automatically extracts the matrix of interest to execute the rest. In
case the object is a dataframe or a matrix the samples must be in the
rows and the species in the columns.

The 20 species used by `VIBES` are as follows, and regardless of the
object passed must be named as such (`Genus_species`):
Aerococcus_christensenii, Campylobacter_ureolyticus, Finegoldia_magna,
Lactobacillus_crispatus, Lactobacillus_gasseri, Porphyromonas_uenonis,
Prevotella_bivia, Prevotella_timonensis, Atopobium_vaginae,
Lactobacillus_iners, Prevotella_amnii, Prevotella_disiens,
Staphylococcus_haemolyticus, Veillonella_montpellierensis,
Alistipes_finegoldii, Gardnerella_vaginalis, Mycoplasma_hominis,
Mobiluncus_mulieris, Prevotella_buccalis and Sneathia_sanguinegens.

## Installation

The installation of `VIBES` is done via GitHub. For this you need to
install the `devtools` package via the function `install_github`. In
addition `VIBES` has dependencies via Bioconductor so it will be
necessary to install the associated `BiocManager` package. This will
allow you to install the `phyloseq` package.

``` r
# Installation requires devtools and bioconductor, please use the following commands
if (!requireNamespace("BiocManager"))
    install.packages("BiocManager")
BiocManager::install()
install.packages("devtools")
# Before installing VIBES, you need also to install the dependent package `phyloseq`
BiocManager::install("phyloseq")
# Install VIBES from github
devtools::install_github("MALL-Machine-Learning-in-Live-Sciences/VIBES")
```

## Usage

Before starting, you need to load the following packages:

``` r
require(phyloseq)
#> Loading required package: phyloseq
library(VIBES)
```

The main function of the package is `get_VIBES()`. This function, from
the input data (matrix, dataframe or phyloseq) computes the prediction
of membership of these clusters. The function returns for each sample
the probability of belonging to each cluster and the cluster label to
which it belongs.

## Example

This example works with a phyloseq object. In this case the phyloseq
object is made up of the counts of 1657 microbiome profiles.

``` r
data("PRJNA208535")
# Load a pseq with 1657 samples 22 species and 7 taxonomic ranks
print(PRJNA208535)
#> phyloseq-class experiment-level object
#> otu_table()   OTU Table:         [ 6284 taxa and 1657 samples ]
#> sample_data() Sample Data:       [ 1657 samples by 25 sample variables ]
#> tax_table()   Taxonomy Table:    [ 6284 taxa by 7 taxonomic ranks ]
#> refseq()      DNAStringSet:      [ 6284 reference sequences ]
# Note that the otu table is made up of the counts
otu_table(PRJNA208535)[1:5,1:5]
#> OTU Table:          [5 taxa and 5 samples]
#>                      taxa are rows
#>      SRR902006 SRR902881 SRR903842 SRR903941 SRR903945
#> ASV1         0         0         0         0         0
#> ASV2    188890      3623         0         0         0
#> ASV3         0         0         0         0         0
#> ASV4         0         0      3345      1709       590
#> ASV5         0         0         0         0         0
tax_table(PRJNA208535)[1:5,6:7]
#> Taxonomy Table:     [5 taxa by 2 taxonomic ranks]:
#>      Genus           Species              
#> ASV1 "Lactobacillus" "Lactobacillus_iners"
#> ASV2 "Lactobacillus" "Lactobacillus_iners"
#> ASV3 "Lactobacillus" "Lactobacillus_iners"
#> ASV4 "Lactobacillus" "Lactobacillus_iners"
#> ASV5 "Lactobacillus" NA
```

Before running the package, the clinical data is made up of 25
variables. Once the package is run, it will return 5 more variables that
correspond to the probability and membership of each cluster.

``` r
# Sample data has no info about clusters
sample_data(PRJNA208535)[1:5,20:25]
#>           VAG_ITCH VAG_BURN VAG_DIS MENSTRU1 MENSTRU2 MENSTRU3
#> SRR902006       NA       NA      NA       NA       NA       NA
#> SRR902881        0        0       0       NA       NA       NA
#> SRR903842        0        0       0       NA       NA       NA
#> SRR903941        0        0       0       NA       NA       NA
#> SRR903945        0        0       0       NA       NA       NA
# Compute clusterization
pseq_w_clusters <- get_VIBES(object = PRJNA208535)
#> Remember that the species names must be in the following format: Genus_species
# Check sample data of the new object 'pseq_w_clusters'
sample_data(pseq_w_clusters)[1:5,25:30]
#>           MENSTRU3        VCS.I    VCS.II      VCS.III       VCS.IV p_cluster
#> SRR902006       NA 2.883447e-18 0.9998651 3.257710e-06 1.315948e-04    VCS-II
#> SRR902881       NA 7.292814e-24 1.0000000 9.895719e-12 8.154546e-10    VCS-II
#> SRR903842       NA 2.211632e-20 1.0000000 3.602075e-10 1.755376e-08    VCS-II
#> SRR903941       NA 4.992614e-26 1.0000000 1.369296e-10 8.586513e-09    VCS-II
#> SRR903945       NA 3.820220e-24 0.9941218 1.527713e-07 5.878046e-03    VCS-II
```

## Interpreting the results

The `get_VIBES()` function returns 5 variables/columns to the original
object:

1.  VCS.I: probability (0-1) of belonging to cluster VCS-I.
2.  VCS.II: probability (0-1) of belonging to cluster VCS-II.
3.  VCS.III: probability (0-1) of belonging to cluster VCS-III.
4.  VCS.IV: probability (0-1) of belonging to cluster VCS-IV.
5.  p_cluster: label (VCS-I, VCS-II, VCS-III, VCS-IV) indicating to
    which cluster the profile belongs

## Data

The processed cohorts of the original
[paper](https://github.com/MALL-Machine-Learning-in-Live-Sciences/BV_Microbiome) are
available in the data folder.

## Contributing

We welcome contributions to `VIBES`. Please submit a pull request or
open an issue on the GitHub repository.

## License

`VIBES` is released under the MIT License.

## Contact

If you have any questions, comments, or suggestions, please feel free to
contact us at:

- Diego Fernández Edreira
  - Email: <diego.fedreira@udc.es>
  - Twitter: [@diego_edreira](https://twitter.com/diego_edreira)
  - GitHub: [DiegoFE94](https://github.com/DiegoFE94/)
- Jose Liñares Blanco
  - Email: <j.linares@udc.es>
  - Twitter: [@8JoseLinares](https://twitter.com/8JoseLinares)
  - GitHub: [jlinaresb](https://github.com/jlinaresb)
- Carlos Fernández Lozano
  - Email: <carlos.fernandez@udc.es>
  - Twitter: [@cafernandezlo](https://twitter.com/cafernandezlo)
  - GitHub: [cafernandezlo](https://github.com/cafernandezlo)
