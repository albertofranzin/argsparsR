#' @name argsparsR
#' @rdname argsparsR-class
#' @aliases initialize,argsparsR-method
#' 
#' @param .Object an argsparsR object.
#' 
setMethod(
  "initialize",
  "argsparsR",
  function(.Object) {
     return (.Object)
  }
)


#' constructor for argsparsR objects.
#'
#' Create an instance of a \code{argsparsR} object. Takes the definition of
#' the arguments as only parameter.
#'
#' The argument list is defined as a 5-column matrix, whose columns are:
#'
#' 1. name of the argument (string, no spaces)
#'
#' 2. long flag, of the kind \code{--argument} (string, no spaces)
#'
#' 3. short flag, of the kind \code{-a} (string, no spaces)
#'
#' 4. argument (basic R-)type (one among character, logical, integer, numeric)
#'
#' 5. default value
#'
#' Providing at least one among the long and the short flags is mandatory,
#' both is optional. Remember anyway that you are filling in an R array,
#' so if you don't specify an item you have to set it to \code{''}.
#'
#' The \code{nrow} parameter of \code{matrix} is the number of argument
#' definitions given.
#'
#' The \code{byrow=TRUE} option in the matrix definition is also preferred,
#' as this allows a much clearer representation than the R default behaviour
#' of column-wise packing of the data.
#'
#' @param args matrix of argument definitions, as defined in the `Details` section.
#'
#' @return a \code{argsparsR} object compiled with the parameter definitions given.
#'
#' @examples
#' args <- argsparsR(matrix(c(
#'                   'name', '--name', '-n', 'character', 'me',
#'                   'age' , '--age' , ''  , 'integer'  ,  0  ,
#'                   'town', ''      , '-t', 'character', 'Brusaporco (TV)'
#'                   ),
#'                   nrow = 3,
#'                   byrow = TRUE
#'                   )
#'          )
#'
#' @name argsparsR
#' @rdname argsparsR-class
#' 
#'
#' @export
argsparsR <- function(args = NULL) {

  x <- new("argsparsR")

  if (is.null(args)) {
    warning("argsparsR :: no arguments definition given, returning the raw list of command line arguments.\n",
            "Please take a look at > ?argsparsR for help.")
    return (commandArgs(trailingOnly = TRUE))
  }

  # if args is a file, read the file

  # otherwise...

  x@args <- args
  x@no.args <- nrow(args)
  x@args.names <- args[,1]
  x@long.flags <- args[,2]
  x@short.flags <- args[,3]
  x@args.types  <- args[,4]
  x@args.defaults <- as.list(args[,5])

  for (i in 1:x@no.args) {
    x@args.defaults[[i]] <- convertType(x@args.defaults[[i]],
                                        x@args.types[i])
  }

  # TODO check everything is ok:
  # - no spaces in names and flags
  # - type is valid
  # - default value is of the right type

  x@values <- x@args.defaults

  return(x)
}


#' @rdname parsR
#' @aliases parsR,argsparsR
setMethod("parsR",
          "argsparsR",
          function(x)
{
  cargs <- commandArgs(trailingOnly = TRUE)

  i <- 1
  ncargs <- length(cargs)
  while (i <= ncargs) {
    poslf <- match(cargs[i], x@long.flags)
    possf <- match(cargs[i], x@short.flags)

    if (is.na(poslf) && is.na(possf))
      stop("argsparsR fatal error :: argument ", cargs[i], " not recognized.")

    if (!is.na(poslf))
      pos <- poslf
    else
      pos <- possf

    i <- i + 1
    val <- cargs[i]

    tryCatch(
      x@values[[pos]] <- convertType(val, x@args.types[pos])
    ,
      error = function(e) {
         stop("argsparsR fatal error :: value of '",x@args.names[pos],
              "' not coherent with the parameter type (",x@args.types[pos],").")
      }
    )

    i <- i + 1
  }

  names(x@values) <- as.list(x@args.names)

  return(list("params" = x@args.names,
              "values" = x@values))

}
)

