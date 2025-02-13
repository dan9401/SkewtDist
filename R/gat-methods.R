#' @title Methods for gat class
#'
#' @description Methods for gat S3 class
#'
#' @param object A GAT fit object of class \code{\link{gat}}
#' @param x A GAT fit object of class \code{\link{gat}}
#' @param method one of "numerical" and "analytical", calculating the moments using numerical integration / analytical formula
#' @param type one of "density" and "QQplot"
#' @param type one of "density" or "qqplot"
#' @param dist one of "norm" or "ast", the theoretical distribution used in QQplots
#' @param envelope the confidence level used to construct the envelope
#' @param ... additional arguments for the \code{hist} or \code{plot} function from \code{graphics}
#'
#' @details should also add the empirical moments
#'
#' @name gat-methods
#' @aliases summary.gat
#' @aliases moments.gat
#' @aliases plots.gat
#' @aliases objective.gat
#'
#' @examples
#' pars <- c(0.12, 0.6, 1.5, 1.2, 2, 5)
#' data <- rgat(1000, pars = pars)
#' 
#' fit <- gatMLE(data)
#' 
#' summary(fit)
#' moments(fit)
#' plot(fit, 1)
#' 
#' @importFrom utils menu

#' @rdname gat-methods
#' @export
summary.gat <- function(object, ...) {
  fit <- object
  dist <- "GAT"
  pars <- rbind(fit$start_pars, fit$fixed_pars)
  res <- rbind(fit$fitted_pars, fit$standard_errors)
  colnames(pars) <- colnames(res) <- names(fit$fitted_pars)
  rownames(pars) <- c("start_pars", "fixed_pars")
  rownames(res) <- c("fitted_pars", "standard_errors")

  cat("Distribution: ", dist, "\n")
  cat("Observations: ", length(fit$data), "\n")
  cat("\nResult:\n")
  print(res)
  cat("\nLog-likelihood", fit$objective)
  cat("\n\nSolver: ", fit$solver)
  cat("\n\n")
  print(pars)
  cat("\nTime elapsed: ", fit$time_elapsed)
  cat("\nConvergence Message: ", fit$message)
  cat("\n")
}

#' @rdname gat-methods
#' @export
moments.gat <- function(x, method = c("analytical", "numerical"), ...) {
  fit <- x
  pars <- fit$fitted_pars
  gatMoments(pars = pars, method)
}

#' @rdname gat-methods
#' @export
print.gat <- function(x, ...) {
  fit <- x
  dist <- "GAT"
  res <- rbind(fit$fitted_pars, fit$standard_errors)
  colnames(res) <- names(fit$fitted_pars)
  rownames(res) <- c("fitted_pars", "standard_errors")

  cat("Distrifitbution: ", dist, "\n")
  cat("Observations: ", length(fit$data), "\n")
  cat("\nResult:\n")
  print(res)
}

#' @rdname gat-methods
#' @export
plot.gat <- function(x, type = NULL, dist = "gat", envelope = 0.95, ...) {
  fit <- x
  if (is.null(type)) {
    selection <- 1
    while (selection) {
      selection <- menu(c("Density", "qqplot"), title = "Make a plot selection (or 0 to exit)")
      if (selection == 1) {
        density_gat(fit, ...)
      } else if(selection == 2) {
        qqplot_gat(fit, dist, envelope = 0.95, ...)
      }
    }
  } else {
    if (type == "density") {
      density_gat(fit, ...)
    } else if(type == "qqplot") {
      qqplot_gat(fit, dist = dist, envelope = envelope, ...)
    }
  }
}
