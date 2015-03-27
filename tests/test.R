library("argsparsR")

args <- argsparsR()

print(args)

definition <- matrix(
  c('a', '--a', '-a', 'integer', 5,
    'b', '--b', ''  , 'numeric', 6.7,
    'c', '--c', '-c', 'logical', TRUE,
    'd', '--d', '-d', 'numeric', 4,
    'e', '--e', '-e', 'character', 'ciao'
  ),
  nrow = 5,
  byrow = TRUE
)

args <- argsparsR(definition)

print(args)

print(class(args$values$d))

args <- argsparsR("./tests/pars.csv", header=FALSE)
print(args)
