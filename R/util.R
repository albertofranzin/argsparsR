# convertType
convertType <- function(x, type) {

  if (type != "character" && x == "NA")
    return(NA)

  if (type != "character" && x == "NULL")
    return(NULL)

  if (type == "logical")
    return(as.logical(x))

  if (type == "integer")
    return(as.integer(x))

  if (type == "numeric")
    return(as.numeric(x))

  if (type == "character")
    return(x)

}

# read.params.csv
read.params.file <- function(filename, ...) {
  m <- as.matrix(read.table(filename, ...), ncol=5, byrow=TRUE)
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
