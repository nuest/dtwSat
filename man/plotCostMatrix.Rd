% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotCostMatrix.R
\name{plotCostMatrix}
\alias{plotCostMatrix}
\title{Plotting paths}
\usage{
plotCostMatrix(x, timeseries.labels = NULL, patterns.labels = NULL,
  matrix.name = "costMatrix")
}
\arguments{
\item{x}{An object of class \code{\link[dtwSat]{twdtwMatches}}.}

\item{timeseries.labels}{the label or index of the time series.
Default is 1.}

\item{patterns.labels}{a vector with labels of the patterns. If not 
declared the function will plot one alignment for each pattern.}

\item{matrix.name}{A character. The name of the matrix to plot,
"costMatrix" for accumulated cost, "localMatrix" for local cost, 
or "timeWeight" for time-weight. Default is "costMatrix".}
}
\value{
A \link[ggplot2]{ggplot} object.
}
\description{
Method for plotting low cost paths in the TWDTW 
cost matrix.
}
\examples{
log_fun = logisticWeight(-0.1, 100)
ts = twdtwTimeSeries(example_ts.list)
patt = twdtwTimeSeries(patterns.list)
mat1 = twdtwApply(x=ts, y=patt, weight.fun=log_fun, keep=TRUE)

plotCostMatrix(mat1, matrix.name="costMatrix")

plotCostMatrix(mat1, matrix.name="localMatrix")

plotCostMatrix(mat1, matrix.name="timeWeight")

}
\author{
Victor Maus, \email{vwmaus1@gmail.com}
}
\seealso{
\code{\link[dtwSat]{twdtwMatches-class}}, 
\code{\link[dtwSat]{twdtwApply}}, 
\code{\link[dtwSat]{plotAlignments}}, 
\code{\link[dtwSat]{plotPaths}},
\code{\link[dtwSat]{plotMatches}}, and
\code{\link[dtwSat]{plotClassification}}.
}

