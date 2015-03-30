#' argsparsR.
#'
#' \code{argsparsR} creates an instance of a \code{argsparsR} object.
#' 
#' The argument list is defined as a 7-column matrix, whose columns are:
#'
#' 1. name of the argument (string, no spaces)
#' 2. long flag, of the kind `--argument` (string, no spaces)
#' 3. short flag, of the kind `-a` (string, no spaces)
#' 4. argument (basic R-)type (one among `character`, `logical`, `integer`, `numeric`)
#' 5. the number of values to be expected after the flag. `0` means that
#' the flag alone is the parameter, like in `--help`. `1` means that only one value
#' is expected after the flag, a value `k` higher than one means that exactly
#' `k` values are to be read after the flag (e.g. `3` for something like
#' `--3Dcoord 5 7 8`). `-1` means instead an arbitrary number of values,
#' until another flag is found, or there are no more parameters.
#' 6. the range of values that each parameter can take. May be \code{*}
#' to denote 'no restrictions'. A sequence of values separated by \code{|} as \code{a|b|c}
#' denotes a sequence of categorical values. Closed ranges of consecutive values 
#' are denoted with a dash between the two extremes like \code{a-b},
#' while open ranges can be denoted with \code{<=k}, \code{<k}, \code{>k}, \code{>=k}.
#' Ranges for strings are interpreted in lexicographical sense. Ranges are used only to
#' validate the command line values, and are not returned to the user.
#' If the corresponding value in column 5 is \code{0}, insert \code{*}.
#' 7. default value(s). If the value in the 5th column is `0`, just write `''`,
#' do not leave a blank space; if the value in the 5th column is not `0` or `1`,
#' write the sequence of values separated by commas without blank spaces,
#' e.g. `5,6,NA,8` or `a,c,g,t`.
#' 
#' Providing at least one among the long and the short flags is mandatory,
#' both is optional. Remember anyway that you are filling in an R array,
#' so if you don't specify an item you have to set it to \code{''}.
#' 
#' Parameters with \code{0} values expected after the flag act as yes/no indicators.
#' In this case, the value the parameter will take after the processing, if the
#' (or one of the) corresponding flag(s) is present is the name of the parameter.
#' Default value should be \code{''}.
#' 
#' Parameters with \code{k > 1} values expected after the flag have to be _exactly_
#' \code{k} values after the flag, otherwise bad things will happen.
#'
#' There are more ways to provide the definition to \code{argsparsR}.
#'
#' The first way is to provide a \code{matrix} containing the definitions.
#' The \code{data} vector of the \code{matrix} is the list of definitions.
#'
#' The \code{nrow} parameter of \code{matrix} is the number of argument
#' definitions given.
#'
#' The \code{byrow=TRUE} option in the matrix definition is also preferred,
#' as this allows a much more clear representation than the R default behaviour
#' of column-wise packing of the data.
#'
#' The second method is by providing a text file containing the definitions, as
#' defined in the beginning of this section. It is also possible to specify
#' some optional arguments, for which refer to the documentation of \code{read.table}.
#'
#' The definitions in the file must be defined by row.
#'
#' The file can also be given as first command line parameter; in this case, use
#' an empty constructor `argsparsR()`, with no arguments.
#'
#' When a valid parameter definition is given, the method returns a list containing:
#'
#' * \code{params}, a vector containing the parameter names;
#'
#' * \code{values}, a vector containing the values for the corresponding parameter in
#' \code{params}. The value is the value provided through command line
#' if present, and the default value otherwise.
#'
#' If no definition is given in the constructor, and the first command line
#' is not a valid file, the raw list of command line parameters is returned.
#'
#' @param args.defs (file containing the) matrix of argument definitions,
#' as defined in the `Details` section, or `NULL`, or nothing provided. In case
#' of `NULL` or not provided, then it is assumed that the first parameter given
#' in the command line is a file containing the definitions.
#' @param ... optional arguments of \code{read.table}.
#'
#' @return if a valid parameter definition is given, a list containing:
#'
#' * \code{params}, a vector containing the parameter names;
#'
#' * \code{values}, a vector containing the values for the corresponding parameter in
#' \code{params}. The value is the value provided through command line
#' if present, and the default value otherwise.
#'
#' If no definition is given in the constructor, and the first command line
#' is not a valid file, the raw list of command line parameters is returned.
#'
#' @examples
#' \dontrun{
#' args <- argsparsR()
#' print(args)
#' 
## $ echo -e "name --name -n character me\n\
## age  --age  '' integer   0\n\
## town ''     -t character 'Brusaporco (TV)'" > pars.txt
#' ## $ Rscript myscript.R pars.txt --age 99
#' ## $params
#' ## [1] "name" "age"  "town"
#' ##
#' ## $values
#' ## $values$name
#' ## [1] "me"
#' ##
#' ## $values$age
#' ## [1] 99
#' ##
#' ## $values$town
#' ## [1] "Brusaporco (TV)"
#' 
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
#' ## $ Rscript myscript.R --age 99
#' 
#' print(args)
#' ## $params
#' ## [1] "name" "age"  "town"
#' ##
#' ## $values
#' ## $values$name
#' ## [1] "me"
#' ##
#' ## $values$age
#' ## [1] 99
#' ##
#' ## $values$town
#' ## [1] "Brusaporco (TV)"
#' }
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
#' @slot args.types vector of types of the arguments. Position correspond to the
#' positions in \code{args.names}.
#' @slot args.no.vals vector containing the number of values that each parameter
#' can take. `0` means that the flag alone is the parameter to consider, `1` means
#' that after the flag there is one value to consider for that parameter, `2`
#' means that there are two values to evaluate after the flag, and so on.
#' A value `< 0` means that an arbitrary number of values is expected (not supported yet).
#' @slot ranges ranges of allowed values. See the `Details` section.
#' @slot args.defaults list of default values for the arguments. Positions correspond
#' to the positions in \code{args.names}.
#' @slot values list of the actual values of the parameters, as from the command line.
#'
#' @exportClass argsparsR
setClass("argsparsR",
         representation(
            args          = "matrix",
            no.args       = "integer",
            args.names    = "character",
            long.flags    = "character",
            short.flags   = "character",
            args.types    = "character",
            args.no.vals  = "integer",
            args.ranges   = "character",
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
            args.no.vals  = NULL,
            args.defaults = NULL,
            args.ranges   = NULL,
            values        = NULL
         )
)

