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
argsparsR <- function(args.defs = NULL, format = "argsparsR", ...) {

  if (format == "argsparsR")
    return(parse.argsparsR(args.defs, ...))
  
  stop("argsparsR fatal error :: format not recognized.")
}
