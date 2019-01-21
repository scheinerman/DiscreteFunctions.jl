using Test
using DiscreteFunctions

f = DiscreteFunction(2,3,4,1)
ff = DiscreteFunction([2,3,4,1])
@test f==ff
@test hash(f) == hash(ff)
@test f(1) == 2
g = f^2
@test g(1) == 3
@test has_inv(g)
g = inv(f)
@test g(1) == 4
@test g[1] == g(1)
@test f*g == IdentityFunction(4)
g[1]=2
@test g(1)==2

@test length(f) == 4

@test f*f*f == f^3
@test inv(f) == f^-1

f = RandomFunction(4)
@test f*IdentityFunction(4) == f
