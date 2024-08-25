# DiscreteFunctions


This module defines the `DiscreteFunction` type which represents a
function defined on the set `{1,2,...,n}` (`n` must be positive).

## Basic Constructor

A `DiscreteFunction` is created by providing a list of values either by
passing an array of `Int` values or as a list of `Int` arguments.
For example, to define a function `f` with `f(1)==2`, `f(2)==3`,
`f(3)==1`, and `f(4)==4` we do this:
```
julia> using DiscreteFunctions

julia> f = DiscreteFunction([2,3,1,4]);

julia> g = DiscreteFunction(2,3,1,4);

julia> f==g
true
```
Function evaluation may use either `f(x)` or `f[x]`. It is possible
to change the value of `f` at `x` using the latter.

#### Conversion of a `Permutation` to a `DiscreteFunction`
If `p` is a `Permutation` then `DiscreteFunction(p)` creates a
`DiscreteFunction` based on `p`.
```
julia> using Permutations

julia> p = RandomPermutation(6)
(1,6)(2,5,3,4)

julia> DiscreteFunction(p)
DiscreteFunction on [6]
   1   2   3   4   5   6
   6   5   4   2   3   1
```

Conversely, if `f` is a `DiscreteFunction` that is invertible, it can be
converted to a `Permutation` by `Permutation(f)`.

#### Conversion of a `Matrix` to a `DiscreteFunction`

Let `A` be a square matrix with exactly one nonzero element in each row.
Then `DiscreteFunction(A)` creates a `DiscreteFunction` `f` such that
`f[i]==j` exactly when `A[i,j] != 0`.

This is the inverse of the `Matrix` function (see below). That is,
if `A==Matrix(f)` then `f==DiscreteFunction(A)`.



## Special Constructors

* `IdentityFunction(n)` creates the identity function on the set `{1,2,...,n}`.
* `RandomFunction(n)` creates a random function on the set `{1,2,...,n}`.


## Operations and Methods


The composition of functions `f` and `g` is computed with `f*g`.
Exponentiation signals repeated composition,
i.e., `f^4` is the same as `f*f*f*f`.

We can test if `f` is invertible using `has_inv(f)` and `inv(f)` returns the
inverse function (or throws an error if no inverse exists). This can also
be computed as `f^-1` and, in general, if `f` is invertible it can be raised
to negative exponents. The function `is_permutation` is a synonym for `has_inv`.

#### Other methods

+ `length(f)` returns the number of elements in `f`'s domain.  
+ `fixed_points(f)` returns a list of the fixed points in the function.
+ `cycles(f)` returns a list of the cycles in the function.
+ `image(f)` returns a `Set` containing the output values of `f`.
+ `sources(f)` returns a list of all inputs to `f` that are not outputs of `f`.
+ `Matrix(f)` returns a square, zero-one matrix with a one in position `i,j`
exactly when `f(i)==j`.
+ `eigvals(f)` returns the eigenvalues of `Matrix(f)`.


#### Expensive operations
+ `all_functions(n)` returns an iterator for all functions defined on `1:n`.
Note that there are `n^n` such functions so this grows quickly.
+ `sqrt(g)` returns a `DiscreteFunction` `f` such that `f*f==g` or throws an
error if no such function exists.  Found using integer linear programming.
+ `all_sqrts(g)` returns a list of all square roots of `g`. Very slow.

## Extras

This is some additional code that is not automatically loaded by `using DiscreteFunctions`.
Use `include` on the appropriate file in the `src` directory.

### `src/tree_function.jl`

This file defines `tree2function(G::SimpleGraph)`. It assumes that `G` is a
tree with vertex set `1:n` and returns a `DiscreteFunction` defined by
pointing all edges to the root, `1`.

### `src/draw_function.jl`

This file defines `draw(f)` to give a picture of `f`.
