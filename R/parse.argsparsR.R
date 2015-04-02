#' Parse definitions provided in the argsparsR format.
#' 
#' @param args.defs definition of parameters.
#' 
parse.argsparsR <- function(args.defs = NULL, ...) {
  
  x        <- new("argsparsR")
  cargs    <- commandArgs(trailingOnly = TRUE)
  was.null <- is.null(args.defs)
  
  if (!class(args.defs) == "matrix"                &&
      (was.null || class(args.defs) == "character")  ) {
    
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
  x@args.ranges   <- args.defs[,6]
  x@args.defaults <- list(rep(NULL,x@no.args))
  
  for (i in 1:x@no.args) {
    tryCatch(
      x@args.no.vals[i] <- as.integer(args.defs[i,5])
      ,
      error = function(e) {
        stop("argsparsR fatal error :: number of values for parameter '",
             x@args.names[i],
             "' must be an integer.\n")
      }
    )
    
    if (x@args.no.vals[i] %in% c(0,1))
      x@args.defaults[[i]] <- args.defs[i,7]
    else {
      x@args.defaults[[i]] <- strsplit(args.defs[i,7],',')[[1]]
    }
    names(x@args.defaults[[i]]) <- NULL
  }
  
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
          grepl(' ', x@short.flags[i]) == TRUE   ) {
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
  
  # look for duplicates
  unames  <- unique(x@args.names)
  ulflags <- unique(x@long.flags[which(x@long.flags != '')])
  usflags <- unique(x@short.flags[which(x@short.flags != '')])
  if (length(unames) != length(x@args.names)                             ||
        length(ulflags) != length(x@long.flags[which(x@long.flags != '')]) ||
        length(usflags) != length(x@short.flags[which(x@short.flags != '')]) ) {
    stop("argsparsR fatal error :: no duplicates allowed in parameter names or flags.")
  }
  
  x@values <- x@args.defaults
  
  i <- 1
  ncargs <- length(cargs)
  while (i <= ncargs) {
    poslf     <- match(cargs[i], x@long.flags)
    possf     <- match(cargs[i], x@short.flags)
    
    if (is.na(poslf) && is.na(possf)){
      message("argsparsR :: there are unrecognized arguments.")
      print.help(x@args)
      stop("argsparsR fatal error :: argument ", cargs[i], " not recognized.")
    }
    
    if (!is.na(poslf))
      pos <- poslf
    else
      pos <- possf
    
    if (x@args.no.vals[pos] == 0){
      
      # 'singleton' parameter: works as yes/no
      # if present (=yes) the value takes the name of the parameter
      x@values[[pos]] <- x@args.names[pos]
      
    } else {
      
      if (x@args.no.vals[pos] > 0)
        end <- i + x@args.no.vals[pos]
      else {
        # variable number of values: iterate get until a new flag is found,
        # or until the parameters are finished
        # find value for end
        end <- i + 1
        while (end <= ncargs) {
          p1 <- match(cargs[end], x@long.flags)
          p2 <- match(cargs[end], x@short.flags)
          if (!is.na(p1) || !is.na(p2)) break
          end <- end + 1
        }
        end <- end - 1
        
      }
      
      vals <- c()
      while (i < end) {
        i <- i + 1
        vals <- c(vals, cargs[i])
      }
      
      tryCatch(
        x@values[[pos]] <- convertType(vals, x@args.types[pos])
        ,
        error = function(e) {
          stop("argsparsR fatal error :: value of '",x@args.names[pos],
               "' not coherent with the parameter type (",x@args.types[pos],").")
        }
      )
      
    }
    
    i <- i + 1
  }
  
  all.valid <- rep(F, x@no.args)
  for (i in 1:x@no.args)
    all.valid[i] <- in.valid.range(x@values[[i]], x@args.ranges[i])
  
  if (sum(all.valid) < x@no.args) {
    message("argsparsR :: there are values not allowed for parameter(s): ",
            strcat(x@args.names[which(all.valid == F)], sep=' '),"\n")
    print.help(x@args)
    stop("argsparsR fatal error :: some values are not in the allowed range.")
  }
  
  names(x@values) <- as.list(x@args.names)
  
  return(list("params" = x@args.names,
              "values" = x@values))
  
}
