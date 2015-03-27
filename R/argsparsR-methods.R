# ' @name argsparsR
# ' @rdname argsparsR-class
# ' @aliases initialize,argsparsR-method
# ' 
# ' @param .Object an argsparsR object.
# ' 
setMethod(
  "initialize",
  "argsparsR",
  function(.Object) {
     return (.Object)
  }
)


#' @name argsparsR
#' @rdname argsparsR-class
#' @export
argsparsR <- function(args.defs = NULL, ...) {

  x <- new("argsparsR")

  cargs     <- commandArgs(trailingOnly = TRUE)
  was.null  <- is.null(args.defs)

  if (!class(args.defs) == "matrix"                         &&
      (was.null || class(args.defs) == "character") ) {

    if (was.null) {
      # Check if the first parameter is an existing file.
      # If yes, it is assumed it contains valid definitions.
      args.defs <- cargs[1]
      cargs     <- cargs[-1]
    }

    if (file.exists(args.defs)) {
      args.defs <- read.params.file(args.defs, ...)
    } else if (was.null) {
      # reinsert first parameter and return the raw list of command line arguments
      message("argsparsR :: no valid definitions given, returning the list of arguments as is.")
      return(c(args.defs, cargs))
    } else {
       # then args.defs must be a string containing valid definitions
       # TODO implement
       stop("argsparsR fatal error :: definition type not yet supported.")
    }

  } # otherwise, it must already be a valid matrix - TODO: check

  x@args          <- args.defs
  x@no.args       <- nrow(args.defs)
  x@args.names    <- args.defs[,1]
  x@long.flags    <- args.defs[,2]
  x@short.flags   <- args.defs[,3]
  x@args.types    <- tolower(c(args.defs[,4]))
  x@args.defaults <- as.list(args.defs[,5])

  # check argument types: allowed for now are
  # integer, numeric, logical, character
  if (FALSE %in% c(x@args.types %in% c("numeric", "integer", "logical", "character"))) {
    wrongs <- which(x@args.types %in% c("numeric", "integer", "logical", "character") == FALSE)
    stop("argsparsR fatal error :: type not allowed for argument(s) ",
         strcat(c(x@args.names[wrongs]), sep=" "),
         "\nAllowed types are: 'numeric', 'integer', 'logical', 'character'.")
  }

  # TODO move this to validObject()?
  for (i in 1:x@no.args) {
    if (grepl(' ', x@args.names[i]) == TRUE ||
        grepl(' ', x@long.flags[i]) == TRUE ||
        grepl(' ', x@long.flags[i]) == TRUE   ) {
      stop("argsparsR fatal error :: no spaces are allowed in arguments names or flags.")
    }

    tryCatch(
      x@args.defaults[[i]] <- convertType(x@args.defaults[[i]],
                                          x@args.types[i])
      ,
      error = function(e) {
        stop("argsparsR fatal error :: default value for parameter '",
             x@args.names[i],
             "' is not of type '",x@args.types[i],"'\n")
      }
    )
  }

  x@values <- x@args.defaults

  return(parsR(cargs, x))
}

# ' parse command line arguments.
# '
# ' Parse command line arguments according to the definitions
# ' provided to the constructor \code{argsparsR}.
# '
# ' Errors are thrown in case of mismatch between the nominal type of
# ' the parameter and the actual type of the value given.
# '
# ' @param cargs the list of command line arguments passed by the user.
# ' @param x a \code{argsparsR} object.
# '
# ' @return a list containing:
# '
# ' * \code{params}, a vector containing the parameter names
# '
# ' * \code{values}, a vector containing the values for the corresponding parameter in
# ' \code{params}. The value is the value provided through command line
# ' if present, and the default value otherwise.
# '
# ' @name parsR
# ' @rdname parsR
# '
# ' @export
parsR <- function(cargs, x) {
  i <- 1
  ncargs <- length(cargs)
  while (i <= ncargs) {
    poslf <- match(cargs[i], x@long.flags)
    possf <- match(cargs[i], x@short.flags)

    if (is.na(poslf) && is.na(possf)){
      message("argsparsR :: there are unrecognized arguments.")
      print.help(x@args)
      stop("argsparsR fatal error :: argument ", cargs[i], " not recognized.")
    }

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

