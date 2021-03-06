% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{PlotSpatialRatio}
\alias{PlotSpatialRatio}
\title{Plot ratio of two spatial distributions.}
\usage{
PlotSpatialRatio(locPos, locNeg, filter = NULL, binWidth = 20,
  posMax = 1000)
}
\arguments{
\item{locPos}{A \code{txLoc} object. These should be the positive control sites.}

\item{locNeg}{A \code{txLoc} object. These should be the negative control sites.}

\item{filter}{Only plot loci in transcript regions specified in filter.}

\item{binWidth}{Spatial bin width. Overrides \code{nbreaks} if not
\code{NULL}.}

\item{posMax}{If \code{absolute == TRUE}, show spatial distribution
within a window given by \code{posMax} from the 5'/3' position of
the transcript feature. Default is 1000 nt.}
}
\description{
Plot ratio of two spatial distributions.
}
\examples{
\dontrun{
bedFile <- system.file("extdata",
                       "miCLIP_m6A_Linder2015_hg38.bed",
                       package = "RNAModR");
sites <- ReadBED(bedFile);
posSites <- SmartMap(sites, id = "m6A", refGenome = "hg38");
negSites <- GenerateNull(posSites, method = "permutation");
PlotSpatialRatio(posSites, negSites, c("3'UTR", "CDS", "5'UTR"));
}

}
\author{
Maurits Evers, \email{maurits.evers@anu.edu.au}
}
\keyword{internal}

