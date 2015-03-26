#' parse command line arguments.
#'
#' Parse command line arguments according to the definitions
#' provided to the constructor \code{argsparsR}.
#'
#' Errors are thrown in case of mismatch between the nominal type of
#' the parameter and the actual type of the value given.
#'
#' @param x a \code{argsparsR} object.
#'
#' @return a list containing:
#'
#' * \code{params}, a vector containing the parameter names
#'
#' * \code{values}, a vector containing the values for the corresponding parameter in
#' \code{params}. The value is the value provided through command line
#' if present, and the default value otherwise.
#'
#' @name parsR
#' @rdname parsR
#'
#' @exportMethod parsR
setGeneric("parsR", function(x) standardGeneric("parsR"))
