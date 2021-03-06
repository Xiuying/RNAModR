#' Safe-loading an R package.
#'
#' Safe-loading an R package. See 'Details'.
#'
#' The function calls \code{require} to load a package.
#' If the package can be loaded it returns \code{TRUE},
#' else \code{FALSE}. 
#'
#' @param lib A character string; package to be loaded.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @return A logical scalar.
SafeLoad <- function(lib) {
    # Safe-loading an R package.
    #
    # Args:
    #   lib: Name of the package to be loaded
    #
    # Returns:
    #   A logical scalar; TRUE if lib was loaded successfully
    ret <- suppressMessages(require(lib,
                                    character.only = TRUE,
                                    quietly = TRUE));
    return(ret);
}


#' Check if object has class classType.
#'
#' Check if object has class classType.
#' 
#' @param object An R object.
#' @param classType String of class type for toplevel.
#' @param classType2 String of class type for level 2.
#'
#' @return Logical. \code{TRUE} if object is of class classType.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @export
CheckClass <- function(object, classType = NULL, classType2 = NULL) {
    # Check that object is of type classType
    #
    # Args:
    #   object: Object.
    #   classType: Class type of object.
    #
    # Returns:
    #    TRUE
    if (class(object) != classType) {
        objName <- deparse(substitute(object));
        stop(sprintf("%s is not an object of type %s.\n",
                     objName, classType),
             call. = FALSE);
    }
    if (classType == "list" &&
        !is.null(classType2) &&
        !all(lapply(object, class) == classType2)) {
        objName <- deparse(substitute(object));
        stop(sprintf("%s does not contain a list of objects of type %s.\n",
                     objName, classType2),
             call. = FALSE);
    }
    return(TRUE);
}


#' Check if entries of two \code{txLoc} objects are based on the
#' same reference genome.
#' 
#' Check if entries of two \code{txLoc} objects are based on the
#' same reference genome.
#'
#' @param obj1 A \code{txLoc} object.
#' @param obj2 A \code{txLoc} object.
#'
#' @return A logical scalar.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @export
CheckClassTxLocRef <- function(obj1, obj2) {
    CheckClass(obj1, "txLoc");
    CheckClass(obj2, "txLoc");
    obj1Name <- deparse(substitute(obj1));
    obj2Name <- deparse(substitute(obj2));
    ref1 <- GetRef(obj1);
    ref2 <- GetRef(obj2);
    if (ref1 != ref2) {
        ss <- sprintf("%s and %s are not based on the same reference genome.",
                      obj1Name, obj2Name);
        ss <- sprintf("%s\n  %s: %s", ss, obj1Name, ref1);
        ss <- sprintf("%s\n  %s: %s", ss, obj2Name, ref2);
        stop(ss);
    }
    return(TRUE);
}


#' Check if entries of two \code{txLoc} objects are consistent.
#'
#' Check if entries of two \code{txLoc} objects are consistent.
#' See 'Details'.
#'
#' The function checks if entries from two \code{txLoc} objects
#' are based on the same reference genome _and_ contain entries
#' for the same transcript sections.
#' 
#' @param obj1 A \code{txLoc} object.
#' @param obj2 A \code{txLoc} object.
#'
#' @return A logical scalar.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @export
CheckClassTxLocConsistency <- function(obj1, obj2) {
    # Check that the underlying properties of txloc
    # objects obj1 and obj2 are consistent.
    #
    # Args:
    #   obj1: txLoc object.
    #   obj2: txLoc object
    #
    # Returns:
    #   TRUE
    CheckClassTxLocRef(obj1, obj2);
    obj1Name <- deparse(substitute(obj1));
    obj2Name <- deparse(substitute(obj2));
    sec1 <- names(GetLoci(obj1));
    sec2 <- names(GetLoci(obj2));
    matchSec <- intersect(sec1, sec2);
    if (!identical(sec1, sec2)) {
        ss <- sprintf("Transcript sections in %s and %s do not match.",
             obj1Name, obj2Name);
        ss <- sprintf("%s\n  %s: %s",
                      ss, obj1Name, paste(sec1, collapse = ", "));
        ss <- sprintf("%s\n  %s: %s",
                      ss, obj2Name, paste(sec2, collapse = ", "));
        stop(ss);
    }
    return(TRUE);
}


#' Load reference transcriptome.
#'
#' Load reference transcriptome. See 'Details'.
#'
#' The function loads transcriptome data stored in a \code{.RData}
#' file, and makes the objects assessible in the user's workspace.
#'
#' @param refGenome A character string; specifies a specific
#' reference genome assembly version based on which a transcriptome
#' is loaded; default is \code{"hg38"}.
#' @param env An \code{environment} object; default is the user's
#' workspace, i.e. \code{env = .GlobalEnv}.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @export
LoadRefTx <- function(refGenome = "hg38", env = .GlobalEnv) {
    refTx <- sprintf("tx_%s.RData", refGenome);
    if (!file.exists(refTx)) {
        ss <- sprintf("Reference transcriptome for %s not found.", refGenome);
        ss <- sprintf("%s\nRunning BuildTx(\"%s\") might fix that.",
                      ss, refGenome);
        stop(ss);
    }
    load(refTx);
    requiredObj <- c("geneXID", "seqBySec", "txBySec");
    if (!all(requiredObj %in% ls())) {
        ss <- sprintf("Mandatory transcript objects not found.");
        ss <- sprintf("%s\nNeed all of the following: %s",
                      ss, paste0(requiredObj, collapse = ", "));
        ss <- sprintf("%s\nRunning BuildTx(\"%s\") might fix that.",
                      ss, refGenome);
        stop(ss);
    }
    geneXID <- base::get("geneXID");
    seqBySec <- base::get("seqBySec");
    txBySec <- base::get("txBySec");
    assign("geneXID", geneXID, envir = env);
    assign("seqBySec", seqBySec, envir = env);
    assign("txBySec", txBySec, envir = env);
}


#' Filter sections of a \code{txLoc} object.
#'
#' Filter sections of a \code{txLoc} object.
#'
#' @param locus A \code{txLoc} object.
#' @param filter A character vector; only keep transcript sections
#' specified in \code{filter}; if \code{NULL} consider all sections.
#'
#' @return A \code{txLoc} object.
#' 
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @export
FilterTxLoc <- function(locus, filter = NULL) {
    CheckClass(locus, "txLoc");
    id <- GetId(locus);
    refGenome <- GetRef(locus);
    version <- GetVersion(locus);
    locus <- GetLoci(locus);
    if (!is.null(filter)) {
        locus <- locus[which(names(locus) %in% filter)];
    }
    obj <- new("txLoc",
               loci = locus,
               id = id,
               refGenome = refGenome,
               version = version);
    return(obj);
}


#' Subsample from a \code{txLoc} object.
#'
#' Subsample from a \code{txLoc} object.
#'
#' @param locus A \code{txLoc} object.
#' @param fraction A float scalar;
#'
#' @return A \code{txLoc} object.
#' 
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @export
SubsampleTxLoc <- function(locus, fraction = 0) {
    CheckClass(locus, "txLoc");
    id <- GetId(locus);
    id <- sprintf("%s_subsampled", id);
    refGenome <- GetRef(locus);
    version <- GetVersion(locus);
    size <- lapply(GetNumberOfLoci(locus), 
                   function(x) sample(x, fraction * x));
    locus <- GetLoci(locus);
    if (fraction > 0) {
        for (i in 1:length(locus)) {
            locus[[i]] <- locus[[i]][size[[i]], ];
        }
    }
    obj <- new("txLoc",
               loci = locus,
               id = id,
               refGenome = refGenome,
               version = version);
    return(obj);
}


#' Convert a \code{txLoc} object to a \code{GRangesList} object.
#'
#' Convert a \code{txLoc} object to a \code{GRangesList} object.
#' See 'Details'.
#'
#' The function converts a \code{txLoc} to a \code{GRangesList}
#' object. Coordinates can be either genomic coordinates
#' (\code{method = "gPos"}) or transcript section coordinates
#' (\code{method = "tPos"}).
#' 
#' @param locus A \code{txLoc} object.
#' @param filter A character vector; only keep transcript sections
#' specified in \code{filter}; if \code{NULL} consider all sections.
#' @param method A character string; specifies whether coordinates
#' are genome (\code{method = "gPos"}) or transcriptome coordinates
#' (\code{method = "tPos"}).
#'
#' @return A \code{GRangesList} object. See 'Details'.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @import GenomicRanges IRanges
#'
#' @export
TxLoc2GRangesList <- function(locus,
                              filter = NULL,
                              method = c("tPos", "gPos")) {
    CheckClass(locus, "txLoc");
    method <- match.arg(method);
    id <- GetId(locus);
    locus <- GetLoci(locus);
    if (!is.null(filter)) {
        locus <- locus[which(names(locus) %in% filter)];
    }
    gr <- GRangesList();
    options(warn = -1);
    for (i in 1:length(locus)) {
        gr[[length(gr) + 1]] <- switch(
            method,
            "gPos" = GRanges(
                locus[[i]]$CHR,
                IRanges(locus[[i]]$START, locus[[i]]$STOP),
                locus[[i]]$STRAND,
                type = id,
                gene = locus[[i]]$REFSEQ,
                section = locus[[i]]$GENE_REGION,
                names = locus[[i]]$ID),
            "tPos" = GRanges(
                locus[[i]]$REFSEQ,
                IRanges(locus[[i]]$TXSTART, locus[[i]]$TXEND),
                "*",
                type = id,
                gene = locus[[i]]$REFSEQ,
                section = locus[[i]]$GENE_REGION,
                names = locus[[i]]$ID));
    }
    options(warn = 0);
    names(gr) <- names(locus);
    return(gr);
}


#' Return list of nearest distances between entries from two
#' \code{GRangesList} objects.
#'
#' Return list of nearest distances between entries from two
#' \code{GRangesList} objects. See 'Details'.
#'
#' The function uses \code{GenomicRanges::distanceToNearest}
#' to return the nearest distances between the start positions
#' of a features from \code{gr1} and any feature from \code{gr2}
#' with the same name (based on field \code{seqnames}). The
#' return object is a list of distances, where every list
#' element corresponds to a list element from \code{gr1} and
#' \code{gr2}.
#' Note that distances are given as signed integers: Negative
#' distances correspond to pos(gr1) < pos(gr2), positive
#' distances correspond to pos(gr1) > pos(gr2).
#' 
#'
#' @param gr1 A \code{GRangesList} object.
#' @param gr2 A \code{GRangesList} object.
#'
#' @return A list of integer vectors. See 'Details'.
#' 
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#' 
#' @import GenomicRanges
#'
#' @export
GetRelDistNearest <- function(gr1,
                              gr2) {
    CheckClass(gr1, "GRangesList");
    CheckClass(gr2, "GRangesList");
    filter <- intersect(names(gr1), names(gr2));
    gr1 <- gr1[which(names(gr1) %in% filter)];
    gr2 <- gr2[which(names(gr2) %in% filter)];
    if (!identical(names(gr1), names(gr2))) {
        ss <- sprintf("Transcript sections do not match:\n");
        ss <- sprintf(" %s != %s\n",
                      paste(names(gr1), collapse = " "),
                      paste(names(gr2), collapse = " "));
        stop(ss);
    }
    dist.list <- list();
    for (i in 1:length(gr1)) {
        # Collapse range of gr1 and gr2
        end(gr1[[i]]) <- start(gr1[[i]]);
        end(gr2[[i]]) <- start(gr2[[i]]);
        # Disable warnings to get rid of messages "Each of the
        # 2 combined objects has sequence levels not in the other".
        # As this is expected to happen, we can safely ignore.
        options(warn = -1);
        # Get the nearest distance between entries from gr1[[i]]
        # and gr2[[i]] with the same seqnames (i.e. transcript ID).
        d <- as.data.frame(distanceToNearest(gr1[[i]], gr2[[i]]));
        options(warn = 0);
        idx1 <- d$queryHits;
        idx2 <- d$subjectHits;
        # Set d > 0 if pos(gr1[[i]]) > pos(gr2[[i]])
        #     d < 0 if pos(gr1[[i]]) < pos(gr2[[i]])
        # In words: Negative distances => gr1 is upstream of gr2
        #           Positive distances => gr1 is downstream of gr2
        dist <- ifelse(end(gr1[[i]][idx1]) > start(gr2[[i]][idx2]),
                       d$distance,
                       -d$distance);
        names(dist) <- (gr1[[i]][idx1])$names;
        dist.list[[length(dist.list) + 1]] <- dist;
    }
    names(dist.list) <- names(gr1);
    return(dist.list);
}


#' Calculate 95% confidence interval from data using empirical
#' bootstrap.
#'
#' Calculate 95% confidence interval from data using empirical
#' bootstrap.
#' 
#' @param x A data vector.
#' @param breaks Vector of integer breaks for binning x.
#' @param nBS Number of boostrap samples. Default is 5000.
#'
#' @return List of upper and lower 95% confidence interval
#' bounds for every bin value.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#'
#' @importFrom graphics hist
#' 
#' @export
EstimateCIFromBS <- function(x, breaks, nBS = 5000) {
    # Estimate 95% CI from empirical bootstrap
    #
    # Args:
    #   x: Data
    #   breaks: Vector of integer breaks for binning x.
    #   nBS: Number of bootstrap samples. Default is 5000.
    #
    # Returns:
    #    List of lower/upper 95% CI values for each bin.
    h0 <- hist(x, breaks = breaks, plot = FALSE);
    matBS <- matrix(0, ncol = length(breaks) - 1, nrow = nBS);
    for (j in 1:nBS) {
        xBS <- sample(x, size = length(x), replace = TRUE);
        h <- hist(xBS, breaks = breaks, plot = FALSE);
        matBS[j, ] <- h$counts;
    }
    sd <- apply(matBS, 2, sd);
    z1 <- apply(matBS, 2, function(x) {(x - mean(x)) / sd(x)});
    z1[is.na(z1)] <- 0;
    z1 <- apply(z1, 2, sort);
    y.low <- h0$counts - z1[round(0.025 * nBS), ] * sd;
    y.high <- h0$counts - z1[round(0.975 * nBS), ] * sd;
    return(list(x = h0$mids,
                y.low = y.low,
                y.high = y.high));
}


#' Add transparency to a list of hex colors
#'
#' Add transparency to a list of colors
#'
#' @param hexList A vector or list of character strings.
#' @param alpha A float scalar; specifies the transparency; default
#' is \code{alpha = 0.5}.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#'
#' @importFrom grDevices col2rgb rgb
#' 
#' @export
AddAlpha <- function(hexList, alpha = 0.5) {
    mat <- sapply(hexList, col2rgb, alpha = TRUE) / 255.0;
    mat[4, ] <- alpha;
    col <- vector();
    for (i in 1:ncol(mat)) {
        col <- c(col, rgb(mat[1, i],
                          mat[2, i],
                          mat[3, i],
                          mat[4, i]));
    }
    return(col);
}


#' Check if all entries in a character vector are empty.
#'
#' Check if all entries in a character vector are empty.
#' 
#' @param v A character vector.
#'
#' @return A logical scalar.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#'
#' @export
IsEmptyChar <- function(v) {
    return(all(nchar(v) == 0));
}


#' Return specific colour palette.
#'
#' Return specific colour palette.
#'
#' @param pal A character string.
#' @param n An integer scalar.
#' @param alpha A float scalar.
#'
#' @return A character vector.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#'
#' @export
GetColPal <- function(pal = c("apple", "google"), n = NULL, alpha = 1.0) {
    pal <- match.arg(pal);
    alpha <- alpha * 255;
    if (pal == "apple") {
        col <- c(
            rgb(95, 178, 51, alpha = alpha, maxColorValue = 255),
            rgb(106, 127, 147, alpha = alpha, maxColorValue = 255),
            rgb(245, 114, 6, alpha = alpha, maxColorValue = 255),
            rgb(235, 15, 19, alpha = alpha, maxColorValue = 255),
            rgb(143, 47, 139, alpha = alpha, maxColorValue = 255),
            rgb(19, 150, 219, alpha = alpha, maxColorValue = 255));
    } else if (pal == "google") {
        col <- c(
            rgb(61, 121, 243, alpha = alpha, maxColorValue = 255),
            rgb(230, 53, 47, alpha = alpha, maxColorValue = 255),
            rgb(249, 185, 10, alpha = alpha, maxColorValue = 255),
            rgb(52, 167, 75, alpha = alpha, maxColorValue = 255));
    }
    if (!is.null(n)) {
        col <- col[1:n];
    }
    return(col);
}


#' Unfactor entries in a \code{data.frame}.
#'
#' Unfactor entries in a \code{data.frame}.
#'
#' @param df A \code{data.frame} object.
#'
#' @return A \code{data.frame} object.
#'
#' @author Maurits Evers, \email{maurits.evers@@anu.edu.au}
#' @keywords internal
#'
#' @export
Unfactor <- function(df) {
    idx <- sapply(df, is.factor);
    df[idx] <- lapply(df[idx], as.character);
    return(df);
}
