#' argsparsR class definition.
#'
#' \code{argsparsR} creates an instance of a \code{argsparsR} object.
#' Takes the definition of the arguments as only parameter.
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
#' @name argsparsR-class
#' @rdname argsparsR-class
#' @docType class
#' @aliases argsparsR,argsparsR-class
#'
#' @slot args matrix of argument definitions.
#' @slot no.args number of argument definitions.
#' @slot args.names vector containing the names of the arguments.
#' @slot long.flags vector of flags in long form (e.g. \code{--flag}).
#' Positions correspond to the positions of \code{args.names}.
#' @slot short.flags vector of flags in short form(e.g. \code{-f}). Positions
#' correspond to the positions of \code{args.names}.
#' @slot args.types type of the arguments. Position correspond to the
#' positions in \code{args.names}.
#' @slot args.defaults list of default values for the arguments. Positions correspond
#' to the positions in \code{args.names}.
#' @slot values list of the actual values of the parameters, as from the command line.
#'
#'@exportClass argsparsR
setClass("argsparsR",
         representation(
            args          = "matrix",
            no.args       = "integer",
            args.names    = "character",
            long.flags    = "character",
            short.flags   = "character",
            args.types    = "character",
            args.defaults = "list",
            values        = "list"
         ),
         prototype(
            args          = matrix(),
            no.args       = 0L,
            args.names    = NULL,
            long.flags    = NULL,
            short.flags   = NULL,
            args.types    = NULL,
            args.defaults = NULL,
            values        = NULL
         )
)

