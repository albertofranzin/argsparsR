argsparsR
=========

Small R package to get command line arguments given to R scripts.

Description
-----------

`argsparsR` is a small package to get and interpret command line parameters
passed to R scripts (e.g. scripts run with `Rscript`). 

The argument list is defined as a 5-column matrix, whose columns are:

1. name of the argument (string, no spaces)
2. long flag, of the kind `--argument` (string, no spaces)
3. short flag, of the kind `-a` (string, no spaces)
4. argument (basic R-)type (one among `character`, `logical`, `integer`, `numeric`)
5. default value

Providing at least one among the long and the short flags is mandatory,
both is optional. Remember anyway that you are filling in an R array,
so if you don't specify an item you have to set it to `''`.

There are more ways to provide the definition to `argsparsR`.

The first way is to provide a `matrix` containing the definitions.
The `data` vector of the `matrix` is the list of definitions.

The `nrow` parameter of `matrix` is the number of argument
definitions given.

The `byrow=TRUE` option in the matrix definition is also preferred,
as this allows a much more clear representation than the R default behaviour
of column-wise packing of the data.

The second method is by providing a text file containing the definitions, as
defined in the beginning of this section. It is also possible to specify
some optional arguments, for which refer to the documentation of `read.table`.

The definitions in the file must be defined by row.

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

* `params$params` a vector containing the names of the parameters:
    `('name' 'age' 'town')`

* `params$values` a list containing the values for the corresponding elements
    in `params$params`, with the desired values for the parameters actually
    seen in the command, and the default values for the other ones:
    1. `params$values$name` with value `'Someone Else'`
    2. `params$values$age` with value `99`
    3. `params$values$town` with value `'Nowhere'`.
