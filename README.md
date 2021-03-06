# RNAModR

**RNAModR** provides functions to map lists of genomic loci of RNA modifications 
to a reference mRNA transcriptome, and perform exploratory functional analyses of
sites across the transcriptome trough visualisation and statistical analysis of
the distribution of sites across transcriptome sections (5'UTR, CDS, 3'UTR).

**RNAModR** performs enrichment analyses to assess the statistical significance of
the spatial and sequence-specific localisation of sites relative to null sites.
Null sites can be generated automatically or may be supplied manually in the form
of a list of genomic loci.

Note that enrichment analyses results may depend critically on the choice and validity 
of null sites. For example, in establishing a list of null sites for 5-methylcytidine 
modifications, the non-uniformity in the actual distribution of cytosines across 
transcript sections makes a simple position permutation approach inappropriate for 
generating null sites.

## Installing RNAModR 

### The github way (requires the [devtools](https://github.com/hadley/devtools) package)

1. Make sure you have the following R/Bioconductor packages installed
 
    * AnnotationDbi
    * beanplot
    * Biostrings
    * GenomeInfoDb
    * GenomicFeatures
    * GenomicRanges
    * gplots
    * RSQLite
    * rtracklayer

    You can install additional R/Bioconductor packages in the usual way:
   
    ```{r}
    source("http://www.bioconductor.org/biocLite.R")
    biocLite(c("AnnotationDbi", "beanplot", "Biostrings", "GenomeInfoDb", "GenomicFeatures", "GenomicRanges", "gplots", "RSQLite",    "rtracklayer"))
    ```
   
    Additionally, RNAModR requires two _organism-specific_ R packages to contruct a custom transcriptome. Currently, RNAModR    supports human and mouse data, based on the following reference genome versions
   
     * Human: hg38, hg19
     * Mouse: mm10, mm9.
   
    Please install the corresponding organism- and version-matching R/Bioconductor packages. For example, if genomic loci of RNA modification are based on the human GRCh38/hg38 reference genome,
    RNAModR requires the following R/Bioconductor packages:
   
     * BSgenome.Hsapiens.UCSC.hg38
     * org.Hs.eg.db
   
    which you can install in the usual way

    ```{r}
    biocLite(c("BSgenome.Hsapiens.UCSC.hg38", "org.Hs.eg.db"))
    ```

    We also offer the possibility to download pre-constructed transcriptome data, see section [Downloadable transcriptome data](#downloadTx).


2. If all package dependencies are met, install **RNAModR** with devtools

   ```{r}
if (!require("devtools")) install.packages("devtools");
devtools::install_github("mevers/RNAModR", build_vignettes = FALSE);
   ```

You can force a re-install of RNAModR by adding 

```{r} 
devtools::install_github(..., force = TRUE);
```

## Getting started
The following lines of R code will load the **RNAModR** library, and plot the distribution of m6A sites [[Linder et al., Nature Methods 12, 767 (2015)](http://www.nature.com/nmeth/journal/v12/n8/abs/nmeth.3453.html)] across the 5'UTR, CDS and 3'UTR of the human hg38-based transcriptome.

Note: You can also download pre-constructed transcriptome data, see the [next section](#downloadTx) for details.

```{r}
# Load the library.
library(RNAModR);

# Build reference transcriptome.
# This might take a few minutes.
BuildTx("hg38");

# Load and map m6A sites to reference transcriptome.
posSites <- ReadBED(system.file("extdata", "miCLIP_m6A_Linder2015_hg38.bed", package = "RNAModR"));
posSites <- SmartMap(posSites, "m6A_Linder");

# Keep sites located in the 5'UTR, CDS and 3'UTR
posSites <- FilterTxLoc(posSites, filter = c("5'UTR", "CDS", "3'UTR"));

# Plot distribution across transcript sections
PlotSectionDistribution(posSites);
```

## Downloadable transcriptome data<a name="downloadTx"></a>
You can download pre-constructed transcriptome data files for the following reference genome versions

*Homo sapiens*

1. [hg38](https://drive.google.com/open?id=0B5_hfxBdKWHRVlBCTUlSazJfaWs)
2. [hg19](https://drive.google.com/open?id=0B5_hfxBdKWHRemRwMUtoa1ZnNVE)
3. [hg18](https://drive.google.com/open?id=0B5_hfxBdKWHRZ3ZqdXpVN0VmWlU)

*Mus musculus*

1. [mm10](https://drive.google.com/open?id=0B5_hfxBdKWHRYzliNkotN1NwSTQ)
2. [mm9](https://drive.google.com/open?id=0B5_hfxBdKWHRdkNSMmNleVJUSm8)
3. [mm8](https://drive.google.com/open?id=0B5_hfxBdKWHRMmN5WGRsRkpWcWc)

In order to use the transcriptome data you need to copy the RData file into your working directory.
You can check that RNAModR correctly finds the transcriptome data by running e.g.

```{r}
BuildTx("hg38");
```

Provided you have copied the file tx_hg38.RData into the working directory, this should produce the following message

```
Found existing transcriptome data. Nothing to do.
To rebuild run with force = TRUE.
``` 

## Documentation

The RNAModR manual can be downloaded [here](doc/RNAModR-manual.pdf).


## Contributors

Please contact [Maurits Evers](mailto:maurits.evers@anu.edu.au "Email Maurits Evers") in case of questions/suggestions.
In case of bugs/feature requests please open an issue on github.

## Licensing

The **RNAModR** R package is open source licensed under the 
GNU Public License, version 3 (GPLv3).
