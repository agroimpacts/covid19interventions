#' Intervention Breakpoint Deetection Function
#'
#' This is adapted from an R script written by Markus Loew on RPubs.
#' breakpoints() in struccchange package by Achim Zeileis was used
#' to estimate psi param in segmentation function
#'
#' @description This function detects breakpoints where the slope of
#' rates of cases change
#' @return Date of elbow changepoint in Julian and Date format
#' @param x Date range in julian date, origin = '2019-12-31'
#' @param y Rate of change, k in y = Ae^(kx)
#' @export
#' @examples
#' intervention_breakpts(x, y)

intervention_breakpts <- function(x, y){
  # # warning if packages not installed
  # if (!require(strucchange)) {
  #   stop("strucchange not installed")
  # } else if (!require(segmented)){
  #   stop("segmented not installed")
  # } else {
  #   break
  # }

  # coerce x and y into a tibble
  # param x renamed as jdates
  # param y renamed as rate
  t <- list(jdates = x[2:length(x)], rate = y) %>% as_tibble() %>%
    mutate(rate = na.approx(k, na.rm = FALSE))
  t <- t[complete.cases(t),]

  # estimate breakpoints
  bp <- breakpoints(t$rate ~ t$jdates, h=.25)

  # create a linear model
  my.lm <- lm(rate~jdates,data=t)

  # analyze data for breakpoints with guiding estimates, bp
  my.seg <- segmented(my.lm,
                      seg.Z = ~ jdates,
                      psi = list(jdates = t$jdates[bp$breakpoints]))

  # get the fitted data
  my.fitted <- fitted(my.seg)
  my.model <- data.frame(jdates = t$jdates, rate = my.fitted)

  # get the modeled breakpoints
  my.lines <- my.seg$psi[, 2]

  # collect outputs as list
  l <- list(my.lm, my.seg, my.model, my.lines)
  return(list(t, l))
}
