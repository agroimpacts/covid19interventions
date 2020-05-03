#' Elbow (or Knee) Point Detection Function
#' #'
#' This is adapted from an R script written by L. Pereira based on
#' a solution by Jonas on stackoverflow
#'
#' @description This function detects the change point of a curve with
#' an elbow (or knee) shape
#' @return Date of elbow changepoint in Julian and Date format
#' @param x Date range in julian date, origin = '2019-12-31'
#' @param y Rate of change, k in y = Ae^(kx)
#' @export
#' @examples
#' elbowPoint(x, y)

elbowPoint <- function(x, y){
  elbowCurve = y
  nPoints <- length(elbowCurve)
  allCoord <- cbind(x[2:length(x)], elbowCurve)
  # pull out first point
  firstPoint <- allCoord[1,]
  # get vector between first and last point - this is the line
  lineVec <- allCoord[nPoints,] - firstPoint;
  # normalize the line vector
  lineVecN <- lineVec / sqrt(sum(lineVec^2));
  # find the distance from each point to the line:
  # vector between all points and first point
  vecFromFirst <- lapply(c(1:nPoints), function(x){
    allCoord[x,] - firstPoint
  })
  vecFromFirst <- do.call(rbind, vecFromFirst)
  rep.row<-function(x,n){
    matrix(rep(x,each=n),nrow=n)
  }
  scalarProduct <- matrix(nrow = nPoints, ncol = 2)
  scalarProduct[,1] <- vecFromFirst[,1] * rep.row(lineVecN,nPoints)[,1]
  scalarProduct[,2] <- vecFromFirst[,2] * rep.row(lineVecN,nPoints)[,2]
  scalarProduct <- as.matrix(rowSums(scalarProduct))
  vecFromFirstParallel <- matrix(nrow = nPoints, ncol = 2)
  vecFromFirstParallel[,1] <- scalarProduct * lineVecN[1]
  vecFromFirstParallel[,2] <- scalarProduct * lineVecN[2]
  vecToLine <- lapply(c(1:nPoints), function(x){
    vecFromFirst[x,] - vecFromFirstParallel[x,]
  })
  vecToLine <- do.call(rbind, vecToLine)
  # distance to line is the norm of vecToLine
  distToLine <- as.matrix(sqrt(rowSums(vecToLine^2)))
  # maximum distance value
  maxdate_j <- x[which.max(distToLine)]
  maxdate_j
  maxdate <- as.Date(maxdate_j, origin=as.Date("2019-12-31"))
  maxdate
}
