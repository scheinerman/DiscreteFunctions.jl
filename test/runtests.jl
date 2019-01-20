using Test
using DiscreteFunctions

f = DiscreteFunction(2,3,4,1)
@test f(1) == 2
g = f^2
@test g(1) == 3
g = inv(f)
@test g(1) == 4
@test f*g == IdentityFunction(4)

@test length(f) == 4
@test has_inv(f)

f = RandomFunction(4)
@test f*IdentityFunction(4) == f
