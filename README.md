argsparsR
=========

Small R package to get command line arguments given to R scripts.

Description
-----------

`argsparsR` is a small package to get and interpret command line parameters
paassed to R scripts (e.g. scripts run with `Rscript`). 

# Installation
The package is hosted at https://github.com/albertofranzin/argsparsR.

It can be installed from an R session with:
```r
library(devtools)
install_github("argsparsR", "albertofranzin")
```
or, equivalently, from a shell:
```bash
git clone https://github.com/albertofranzin/argsparsR.git
cd argsparsR
make install
```

# Usage
In your script, before using the command line parameters, first define the
matrix of definitions
```r
param.definitions <-
            matrix(c(
              'name', '--name', '-n', 'character', 'me',
              'age' , '--age' , ''  , 'integer'  ,  99 ,
              'town', ''      , '-t', 'character', 'Bruxelles'
            ),
            nrow = 3,
            byrow = TRUE
          )
```
then create the `argsparsR` object and parse the arguments with
```r
parser <- argsparsR(param.definitions)
params <- parsR(parser)
```

Suppose you are calling your script as
```
$ Rscript myscript.R --name "Someone Else" -t "Nowhere"
```

Then, the `params` object of the above snippet will contain:

1. `params$params` a vector containing the names of the parameters:
    `('name' 'age' 'town')`

2. `params$values` a list containing the values for the corresponding elements
    in `params$params`, with the desired values for the parameters actually
    seen in the command, and the default values for the other ones:
    1. `params$values$name` with value `'Someone Else'
    2. `params$values$age` with value `99`
    3. `params$values$town` with value `'Nowhere'`.
