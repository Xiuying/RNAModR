% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{PlotOverlap}
\alias{PlotOverlap}
\title{Plot overlap of sites.}
\usage{
PlotOverlap(loc1, loc2)
}
\arguments{
\item{loc1}{A \code{txLoc} object.}

\item{loc2}{A \code{txLoc} object.}
}
\description{
Plot overlap of sites from two \code{txLoc} object.
See 'Details'.
}
\details{
The function plots one or multiple Venn diagrams denoting the
spatial overlap between entries from two \code{txLoc} objects.
Two features are defined as overlapping, if they overlap by
at least one nucleotide. Overlaps are determined using the
function \code{GenomicRanges::countOverlaps}.
}
\author{
Maurits Evers, \email{maurits.evers@anu.edu.au}
}

