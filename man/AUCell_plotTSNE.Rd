% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aux_AUCell_plotTSNE.R
\name{AUCell_plotTSNE}
\alias{AUCell_plotTSNE}
\title{Plot}
\usage{
AUCell_plotTSNE(tSNE, exprMat = NULL, cellsAUC = NULL, thresholds = NULL,
  reorderGeneSets = FALSE, cex = 1, alphaOn = 1, alphaOff = 0.2,
  borderColor = adjustcolor("lightgray", alpha.f = 0.1),
  offColor = "lightgray", plots = c("histogram", "binaryAUC", "AUC",
  "expression"), exprCols = c("goldenrod1", "darkorange", "brown"),
  asPNG = FALSE, ...)
}
\arguments{
\item{tSNE}{t-SNE coordinates (e.g. \code{tSNE$Y})}

\item{exprMat}{Expression matrix}

\item{cellsAUC}{AUC (as returned by calcAUC)}

\item{thresholds}{Thresholds returned by AUCell}

\item{reorderGeneSets}{Whether to reorder the gene sets based on AUC similarity}

\item{cex}{Scaling factor for the dots in the scatterplot}

\item{alphaOn}{Transparency for the dots representing "active" cells}

\item{alphaOff}{Transparency for the dots representing "inactive" cells}

\item{borderColor}{Border color for the dots (scatterplot)}

\item{offColor}{Color for the dots representing "inactive" cells}

\item{plots}{Which plots to generate? Select one or multiple: \code{plots=c("histogram", "binaryAUC", "AUC", "expression")}}

\item{exprCols}{Color scale for the expression}

\item{asPNG}{Output each individual plot in a .png file? (can also be a directory)}

\item{...}{Other arguments to pass to \code{\link{hist}} function.}
}
\value{
Returns invisible: \code{cells_trhAssignment}
}
\description{
Plots the AUC histogram and t-SNE coloured by AUC, binary activity and TF expression
}
\details{
To avoid calculating thresholds, set thresholds to FALSE
}
\examples{


######
# Fake run of AUCell
set.seed(123)
exprMatrix <- matrix(
  data=sample(c(rep(0, 5000), sample(1:3, 5000, replace=TRUE))),
  nrow=20, 
  dimnames=list(paste("Gene", 1:20, sep=""), 
                paste("Cell", 1:500, sep="")))
geneSets <- list(geneSet1=sample(rownames(exprMatrix), 10),
                 geneSet2=sample(rownames(exprMatrix), 5))

cells_rankings <- AUCell_buildRankings(exprMatrix, plotStats = FALSE)
cells_AUC <- AUCell_calcAUC(geneSets, cells_rankings, aucMaxRank=5, nCores=1)
selectedThresholds <- rowMeans(getAUC(cells_AUC))
cellsTsne<- Rtsne::Rtsne(t(exprMatrix),max_iter = 10)$Y
rownames(cellsTsne) <- colnames(exprMatrix)
######


par(mfrow=c(2,3))
thrs <- AUCell_plotTSNE(tSNE=cellsTsne, exprMat=NULL,
                        cellsAUC=cells_AUC, thresholds=selectedThresholds, 
                        plots = c("histogram", "binaryAUC", "AUC"))
 


#####
# Color based on the known phenodata:
cellInfo <- data.frame(cellType1=sample(LETTERS[1:3],ncol(exprMatrix), replace=TRUE), 
                       cellType2=sample(letters[5:7],ncol(exprMatrix), replace=TRUE), 
                       nGenes=abs(rnorm(ncol(exprMatrix))), 
                       row.names=colnames(exprMatrix))
colVars <- list(cellType2=setNames(c("skyblue","magenta", "darkorange"),letters[5:7]))
# dev.off()
plotTsne_cellProps(cellsTsne, cellInfo, colVars=colVars)

}
\seealso{
List of vignettes included in the package: \code{vignette(package="AUCell")}
}
