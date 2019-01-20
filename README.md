# DiscreteFunctions


[![Build Status](https://travis-ci.org/scheinerman/DiscreteFunctions.jl.svg?branch=master)](https://travis-ci.org/scheinerman/DiscreteFunctions.jl)


[![codecov.io](http://codecov.io/github/scheinerman/DiscreteFunctions.jl/coverage.svg?branch=master)](http://codecov.io/github/scheinerman/DiscreteFunctions.jl?branch=master)


This module defines the `DiscreteFunction` type which represents a
function defined on the set `{1,2,...,n}` (`n` must be positive).

## Basic Constructor

A `DiscreteFunction` is created by providing a list of values either by
passing an array of `Int` values or as a list of `Int` arguments:
```
julia> using DiscreteFunctions

julia> f = DiscreteFunction([2,3,1,4]);

julia> g = DiscreteFunction(2,3,1,4);

julia> f==g
true
```
Function evaluation may use either `f(x)` or `f[x]`. It is possible
to change the value of `f` at `x` using the latter.

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
to negative exponents.

`length(f)` returns the number of elements in `f`'s domain.  
