# convertType
convertType <- function(x, type) {

  if (length(x) == 1) {
    if (type != "character" && x == "NA")
      return(NA)
  
    if (type != "character" && x == "NULL")
      return(NULL)    
  }

  if (type == "logical")
    return(as.logical(x))

  if (type == "integer")
    return(as.integer(x))

  if (type == "numeric")
    return(as.numeric(x))

  if (type == "character")
    return(x)

}

# read.params.file
read.params.file <- function(filename, ...) {
  m <- as.matrix(read.table(filename, ...), ncol=7, byrow=TRUE)
  return (m) 
}

# concatenate strings: paste an arbitrary number of strings with default sep=''
# input strings are not checked, be careful
strcat <- function(..., sep = '')
{
  s <- ""
  args <- list(...)
  for (i in unlist(args))
  {
    s <- paste(s, as.character(i), sep=sep)
  }
  return(s)
}

# print a small helper when parameters are not recognized
print.help <- function(x) {
  message("Argument definitions provided are:\n")
  rownames(x) <- sapply(x[,1], function(n) strcat(c("  ",n, " : ")))
  colnames(x) <- c("Name", " Long Flag ", " Short Flag ", " Type ",
                   " Number of values ", " Range ", " Default Value ")
  print(x[,c(2:7)])
  message("")
}

# method to validate a value according to the given range.
# Range is the string provided in the definition, and has to be parsed here.
in.valid.range <- function(value, range) {
  
  parse.range <- function(val, r) {
    # immediately rule out trivial cases
    if (r == '*')
      return (TRUE)
    if (r == '')
      return (FALSE)
    
    # is it a closed range (contains '-')?
    if (grepl('-', r)) {
      subr <- strsplit(r, '-')[[1]]
      ext1 <- convertType(subr[1], class(val))
      ext2 <- convertType(subr[2], class(val))
      if (val >= ext1 && val <= ext2) return (TRUE)
      return (FALSE)
    }
    
    # is it an open range (has '<=', '<', '>=', '>')?
    split.on <- "NO"
    if (grepl('<=', r)) {
      split.on <- '<='
    } else if (grepl('<', r)) {
      split.on <- '<'
    } else if (grepl('>=', r)) {
      split.on <- '>='
    } else if (grepl('>', r)) {
      split.on <- '>'
    }
    
    if (split.on != "NO") {
      ext <- convertType(strsplit(r, split.on)[[1]][2], class(val))
      if (split.on == '<=') {
        if (val <= ext) return (TRUE)
      } else if (split.on == '<') {
        if (val < ext) return (TRUE)
      } else if (split.on == '>=') {
        if (val >= ext) return (TRUE)
      } else if (split.on == '>') {
        if (val > ext) return (TRUE)
      }
      return (FALSE)
    }
    
    # only one value, check.
    chk <- convertType(r, class(val))
    if (val == chk) return (TRUE)
    return (FALSE)
  }
  
  if (grepl('\\|', range)) {
    tokens <- strsplit(range, '\\|')[[1]]
  } else {
    tokens <- range
  }
  
  return(sum(sapply(tokens, function(token) parse.range(value, token))) >= 1)
}
