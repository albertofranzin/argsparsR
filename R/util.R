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

