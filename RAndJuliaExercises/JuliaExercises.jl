############################
#### Exercise 3 (JULIA) ####
############################
# Create a 2x4 two dimensional matrix with random floats
Mx = repeat(rand(2),1,4)
# 2×4 Matrix{Float64}:
#  0.549527  0.549527  0.549527  0.549527
#  0.428752  0.428752  0.428752  0.428752

# Determine the biggest element of A
findmax(Mx)
# (0.5495273885732144, CartesianIndex(1, 1))

############################
#### Exercise 4 (JULIA) ####
############################

# 1.
# Create two matrices of the same layout 
A = [2 6; 4 7; 3 1]
# 3×2 Matrix{Int64}:
#  2  6
#  4  7
#  3  1
B = [1 5; 3 6; 2 8]
# 3×2 Matrix{Int64}:
#  1  5
#  3  6
#  2  8

# Test if addition and subtraction of the matrix works as expected: C = A + B
C = A + B
# 3×2 Matrix{Int64}:
#  3  11
#  7  13
#  5   9
# => as expected

D = A - B
# 3×2 Matrix{Int64}:
#  1   1
#  1   1
#  1  -7
# => as expected

#######
# 2. Matrix multiplication
M1 = A*B
# ERROR: DimensionMismatch("matrix A has dimensions (3,2), matrix B has dimensions (3,2)")
# => cannot multiply matrix with dimensions 3x2 to matrix with dimensions 3x2

M2 = A.*B
# 3×2 Matrix{Int64}:
#   2  30
#  12  42
#   6   8
# => element-wise multiplication

#######
# 3. Matrix division
D1 = A/B
# 3×3 Matrix{Float64}:
#   0.200873  0.366812   0.349345
#  -0.275109  1.45415   -0.0436681
#  -0.781659  1.70306   -0.663755

D2 = A\B
# 2×2 Matrix{Float64}:
#   0.733333    2.4
#  -0.0294574  -0.269767
# For rectangular A the result is the minimum-norm least squares solution
# computed by a pivoted QR factorization of A and a rank estimate of A based on the R factor.

#######
# 4. Create a 3x3 integer matrix A with useful numbers
A = [1 2 3; 4 5 6; 7 8 9]
# 3×3 Matrix{Int64}:
#  1  2  3
#  4  5  6
#  7  8  9

A+1
# ERROR: MethodError: no method matching +(::Matrix{Int64}, ::Int64)
# For element-wise addition, use broadcasting with dot syntax: array .+ scalar

A.+1
# 3×3 Matrix{Int64}:
#  2  3   4
#  5  6   7
#  8  9  10

A-1
# ERROR: MethodError: no method matching -(::Matrix{Int64}, ::Int64)
# For element-wise subtraction, use broadcasting with dot syntax: array .- scalar

A.-1
# 3×3 Matrix{Int64}:
#  0  1  2
#  3  4  5
#  6  7  8

A*2
# 3×3 Matrix{Int64}:
#   2   4   6
#   8  10  12
#  14  16  18

A/2
# 3×3 Matrix{Float64}:
#  0.5  1.0  1.5
#  2.0  2.5  3.0
#  3.5  4.0  4.5

########
# 5. Multiply a 3x4 matrix with a suitable (4)vector
M5 = [1 2 3 4; 5 6 7 8; 9 10 11 12]
# 3×4 Matrix{Int64}:
#  1   2   3   4
#  5   6   7   8
#  9  10  11  12

V = [4, 3, 2, 1]
# 4-element Vector{Int64}:
#  4
#  3
#  2
#  1

M5*V
# 3-element Vector{Int64}:
#   20
#   60
#  100
# breakdown: 
# 1*4 + 2*3  + 3*2  + 4*1 = 20
# 5*4 + 6*3  + 7*2  + 8*1 = 60
# 9*4 + 10*3 + 11*2 + 12*1 = 100