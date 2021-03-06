###############################################################
#                                                             #
#   (c) Victor Maus <vwmaus1@gmail.com>                       #
#       Institute for Geoinformatics (IFGI)                   #
#       University of Muenster (WWU), Germany                 #
#                                                             #
#       Earth System Science Center (CCST)                    #
#       National Institute for Space Research (INPE), Brazil  #
#                                                             #
#                                                             #
#   R Package dtwSat - 2016-01-16                             #
#                                                             #
###############################################################


#' @include methods.R
#' @title Classify time series 
#' @name twdtwClassify
#' @author Victor Maus, \email{vwmaus1@@gmail.com}
#' 
#' @description This function classifies the intervals of a time series 
#' based on the TWDTW results. 
#' 
#' @inheritParams get
#'
#' @param x an object of class twdtw*. This is the target time series. 
#' Usually, it is a set of unclassified time series. 
#' 
#' @param from A character or \code{\link[base]{Dates}} object in the format "yyyy-mm-dd".
#' 
#' @param to A \code{\link[base]{character}} or \code{\link[base]{Dates}} object in the format "yyyy-mm-dd".
#' 
#' @param by A \code{\link[base]{character}} with the intevals size, \emph{e.g.} "6 month".
#' 
#' @param breaks A vector of class \code{\link[base]{Dates}}. This replaces the arguments \code{from},
#' \code{to}, and \code{by}.
#' 
#' @param overlap A number between 0 and 1. The minimum overlapping 
#' between one match and the interval of classification. Default is 0.5, 
#' \emph{i.e.} an overlap minimum of 50\%.
#' 
#' @param thresholds A numeric vector the same length as \code{patterns.labels}. 
#' The TWDTW dissimilarity thresholds, i.e. the maximum TWDTW cost for consideration 
#' in the classification. Default is \code{Inf} for all \code{patterns.labels}.
#' 
#' @param fill a character or value to fill the classification gaps. 
#' For signature \code{twdtwTimeSeries} the default is \code{fill="unclassified"}, and 
#' for signature \code{twdtwRaster} the default is \code{fill="unclassified"}.
#' 
#' @param filepath A character. The path to save the raster with results. If not informed the 
#' function saves in the same directory as the input time series raster. 
#'  
#' @param ... arguments to pass to specifique methods for each twdtw* signature 
#' and other arguments to pass to \code{\link[raster]{writeRaster}}. 
#'
#' @return An object of class twdtw*.
#' 
#' @seealso 
#' \code{\link[dtwSat]{twdtwApply}}, 
#' \code{\link[dtwSat]{twdtwMatches-class}}, 
#' \code{\link[dtwSat]{twdtwTimeSeries-class}}, and 
#' \code{\link[dtwSat]{twdtwRaster-class}}, 
#' 
#' @export  
setGeneric(name = "twdtwClassify", 
          def = function(x, ...) standardGeneric("twdtwClassify"))

#' @rdname twdtwClassify
#' @aliases twdtwClassify-twdtwTimeSeries 
#' @examples
#' # Classifying time series based on TWDTW results 
#' ts = twdtwTimeSeries(example_ts.list)
#' patt = twdtwTimeSeries(patterns.list)
#' log_fun = logisticWeight(-0.1, 100)
#' time_intervals = seq(from=as.Date("2007-09-01"), to=as.Date("2013-09-01"), by="6 month")
#' mat = twdtwApply(x=ts, y=patt, weight.fun=log_fun, keep=TRUE)
#' best_mat = twdtwClassify(mat, breaks=time_intervals, overlap=0.5)
#' 
#' \dontrun{
#' require(parallel)
#' best_mat = mclapply(mat, mc.cores=4, FUN=twdtwClassify, breaks=time_intervals, overlap=0.5) 
#' best_mat = twdtwMatches(alignments=best_mat)
#' }
#' @export
setMethod("twdtwClassify", "twdtwMatches",
          function(x, patterns.labels=NULL, from=NULL, to=NULL, by=NULL, breaks=NULL,
                overlap=.5, thresholds=Inf, fill="unclassified"){
                    if(is.null(patterns.labels)) patterns.labels = labels(x@patterns)
                    if( overlap < 0 & 1 < overlap )
                      stop("overlap out of range, it must be a number between 0 and 1")
                  if(is.null(breaks))
                    if( !is.null(from) &  !is.null(to) ){
                      breaks = seq(as.Date(from), as.Date(to), by=by)    
                    } else {
                      y = x@patterns
                      patt_range = lapply(index(y), range)
                      patt_diff = trunc(sapply(patt_range, diff)/30)+1
                      min_range = which.min(patt_diff)
                      by = patt_diff[[min_range]]
                      from = patt_range[[min_range]][1]
                      to = from 
                      month(to) = month(to) + by
                      dates = as.Date(unlist(index(x@timeseries)))
                      year(from) = year(min(dates))
                      year(to) = year(max(dates))
                      breaks = seq(from, to, paste(by,"month"))
                    }
                    breaks = as.Date(breaks)
                  twdtwClassify.twdtwMatches(x, patterns.labels=patterns.labels, breaks=breaks, 
                            overlap=overlap, thresholds=thresholds, fill=fill)
           })

#' @rdname twdtwClassify
#' @aliases twdtwClassify-twdtwRaster 
#' @examples
#' \dontrun{
#' # Run TWDTW analysis for raster time series 
#' load(system.file("lucc_MT/temporal_patterns.RData", package="dtwSat"))
#' patt = twdtwTimeSeries(temporal_patterns)
#' evi = brick(system.file("lucc_MT/data/evi.tif", package="dtwSat"))
#' ndvi = brick(system.file("lucc_MT/data/ndvi.tif", package="dtwSat"))
#' red = brick(system.file("lucc_MT/data/red.tif", package="dtwSat"))
#' blue = brick(system.file("lucc_MT/data/blue.tif", package="dtwSat"))
#' nir = brick(system.file("lucc_MT/data/nir.tif", package="dtwSat"))
#' mir = brick(system.file("lucc_MT/data/mir.tif", package="dtwSat"))
#' doy = brick(system.file("lucc_MT/data/doy.tif", package="dtwSat"))
#' timeline = scan(system.file("lucc_MT/data/timeline", package="dtwSat"), what="date")
#' rts = twdtwRaster(evi, ndvi, red, blue, nir, mir, timeline = timeline, doy = doy)
#' 
#' time_interval = seq(from=as.Date("2007-09-01"), to=as.Date("2013-09-01"), 
#'                     by="12 month")
#' log_fun = weight.fun=logisticWeight(-0.1,50)
#' 
#' r_twdtw = twdtwApply(x=rts, y=patt, weight.fun=log_fun, breaks=time_interval, 
#'           filepath="~/test_twdtw", overwrite=TRUE, format="GTiff", mc.cores=3)
#' 
#' r_lucc = twdtwClassify(r_twdtw, format="GTiff")
#' 
#' }
setMethod("twdtwClassify", "twdtwRaster",
          function(x, patterns.labels=NULL, thresholds=Inf, fill=255, filepath, ...){
                  if(is.null(patterns.labels)) patterns.labels = coverages(x)[-1]
                  if(missing(filepath)) filepath = if(fromDisk(x[[2]])){dirname(filename(x[[2]]))}else{NULL}
                  twdtwClassify.twdtwRaster(x, patterns.labels=patterns.labels, thresholds=thresholds, fill=fill, filepath=filepath, ...)
           })
           
twdtwClassify.twdtwRaster = function(x, patterns.labels, thresholds, fill, filepath, ...){
    
    if(thresholds==Inf) thresholds = 9999
   
    out = lapply(seq_along(index(x)), function(i) {
      r = lapply(as.list(x)[patterns.labels], raster, layer=i)
      b = brick(r)
      mb = min(b)
      res = which.min(b)
      res[which(mb[]>=thresholds)] = fill
      list(class=res, distance=mb)
    })
    
    class_b = do.call("brick", lapply(out, function(x) x$class))
    distance_b = do.call("brick", lapply(out, function(x) x$distance)) 
    names(class_b) = paste0("date.",index(x)) 
    names(distance_b) = paste0("date.",index(x)) 
    
    levels = c(seq_along(patterns.labels), fill)
    labels = c(patterns.labels, "unclassified")
    twdtwRaster(Class=class_b, Distance=distance_b, ..., timeline=index(x), 
                labels=labels, levels=levels, filepath=filepath)
                
}

twdtwClassify.twdtwMatches = function(x, patterns.labels, breaks, overlap, thresholds, fill){
    res = lapply(as.list(x), FUN = classifyIntervals, patterns.labels, breaks, overlap, thresholds, fill)
    twdtwMatches(x@timeseries, patterns=x@patterns, alignments=res)
}

classifyIntervals = function(x, patterns.labels, breaks, overlap, thresholds, fill)
{
  
  dist_table = x[[1, patterns.labels]]
  #dist_table = dist_table[order(dist_table$distance),]
  labels = as.character(patterns.labels)
  names(labels) = labels
  best_match = do.call("rbind", lapply(seq_along(breaks)[-1], function(i){
    from = breaks[i-1]
    to = breaks[i]
    L = .bestMatches(x=dist_table, start=from, end=to, overlap)
    if(is.na(L)) return(NULL)
    data.frame(from, to, K=dist_table$Alig.N[L], label=dist_table$label[L])
  }))
  best_match = lapply(labels, function(p) best_match[best_match$label==p,])
  res = list(lapply(labels, function(p) subset(x, patterns.labels=p, k=best_match[[p]]$K)@alignments[[1]][[1]] ))
  new("twdtwMatches", timeseries=x@timeseries, patterns=x@patterns, alignments=res)
}

.bestMatches = function(x, start, end, overlap){
  J = (x$from <= end & x$to >= start)
  x = x[J,]
  x$from[x$from < start] = start
  x$to[end < x$to] = end
  # Check for minimum overlap 
  r1 = as.numeric(x$to - x$from) / as.numeric(end-start)
  I = overlap < r1 & r1 < 2-overlap
  J[which(J)] = I
  if(!any(I)) return(NA)
  # Sellect the lowest TWDTW distance 
  res = which(J)[which.min(x$distance[I])]
  res
}

.lowestDistances = function(x, start, end, overlap){
  J = (x$from <= end & x$to >= start)
  x = x[J,]
  x$from[x$from < start] = start
  x$to[end < x$to] = end
  # Check for minimum overlap 
  r1 = as.numeric(x$to - x$from) / as.numeric(end-start)
  I = overlap < r1 & r1 < 2-overlap
  J[which(J)] = I
  if(!any(I)) return(9999)
  # Sellect the lowest TWDTW distance 
  min(x$distance[I])
}