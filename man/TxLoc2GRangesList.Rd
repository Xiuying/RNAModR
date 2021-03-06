% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper.R
\name{TxLoc2GRangesList}
\alias{TxLoc2GRangesList}
\title{Convert a \code{txLoc} object to a \code{GRangesList} object.}
\usage{
TxLoc2GRangesList(locus, filter = NULL, method = c("tPos", "gPos"))
}
\arguments{
\item{locus}{A \code{txLoc} object.}

\item{filter}{A character vector; only keep transcript sections
specified in \code{filter}; if \code{NULL} consider all sections.}

\item{method}{A character string; specifies whether coordinates
are genome (\code{method = "gPos"}) or transcriptome coordinates
(\code{method = "tPos"}).}
}
\value{
A \code{GRangesList} object. See 'Details'.
}
\description{
Convert a \code{txLoc} object to a \code{GRangesList} object.
See 'Details'.
}
\details{
The function converts a \code{txLoc} to a \code{GRangesList}
object. Coordinates can be either genomic coordinates
(\code{method = "gPos"}) or transcript section coordinates
(\code{method = "tPos"}).
}
\author{
Maurits Evers, \email{maurits.evers@anu.edu.au}
}
\keyword{internal}

