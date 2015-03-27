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

The file can also be given as first command line parameter; in this case, use
an empty constructor `argsparsR()`, with no arguments.

When a valid parameter definition is given, the method returns a list containing:

* `params`, a vector containing the parameter names;

* `values`, a vector containing the values for the corresponding parameter in
  `params`. The value is the value provided through command line
  if present, and the default value otherwise.

If no definition is given in the constructor, and the first command line
is not a valid file, the raw list of command line parameters is returned.

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
Here some examples to show th various usage possibilities,
with a file passed as first argument, with a file passed to the constructor,
and with a matrix of definitions.

1. Parameter definitions in a file passed as first parameter:
create a valid file by, say,
```bash
echo -e "name --name -n character me\n\
age  --age  '' integer   99\n\
town ''     -t character Bruxelles" > pars.txt
```
In your script `myscript.R` place
```r
params <- argsparsR()
```
and run
```bash
Rscript myscript.R pars.txt --name "Someone Else" -t "Nowhere"
```

2. Parameter definition in a file passed to the constructor:
```bash
echo -e "name --name -n character me\n\
age  --age  '' integer   99\n\
town ''     -t character Bruxelles" > pars.txt
```
In your script `myscript.R` place
```r
params <- argsparsR("pars.txt")
```
and run
```bash
Rscript myscript.R --name "Someone Else" -t "Nowhere"
```

3. Without files. In your script, before using the command line parameters,
first define the matrix of definitions, then call `argsparsR` as:
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
parser <- argsparsR(param.definitions)
```

Then run
```bash
Rscript myscript.R --name "Someone Else" -t "Nowhere"
```

In all of the above cases, the `params` object will contain:

* `params$params` a vector containing the names of the parameters:
    `('name' 'age' 'town')`

* `params$values` a list containing the values for the corresponding elements
    in `params$params`, with the desired values for the parameters actually
    seen in the command, and the default values for the other ones:
    1. `params$values$name` with value `'Someone Else'`
    2. `params$values$age` with value `99`
    3. `params$values$town` with value `'Nowhere'`.
