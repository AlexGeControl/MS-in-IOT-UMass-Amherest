# Foundation of Computer Engineering

## Lesson 01 - Boolean Switching Functions

### 1. Minimize the following expressions using the laws and properties of Boolean logic discussed in lesson 1. Show the sequence of minimized expressions created (one per line) and indicate which law or property was applied for each line.

a. (AB)'(A' + B)(B + B')
= (AB)'(A' + B)(1)
= (A' + B')(A' + B)
= A'A' + A'B + A'B' + BB'
= A' + A'(B + B')
= A' + A'
= A'

b. A'(A + B) + (B + A)(A + B’)
= (A + B)(A' + A + B)
= (A + B)B
= AB

c. (A’ + B’)(A + B)(AB)’
= (AB)'(AB)'(A + B)
= (AB)'(A + B)
= (A' + B')(A + B)
= A'A + A'B + B'A + B'B
= A'B + B'A

d. (A + B + C)’ABC’
= A'B'C'ABC'
= (A'A)(B'B)(C'C')
= 0

e. (A + B + C)(A + B + C’)
= (A'B'C' + A'B'C)'
= (A'B'(C+C'))'
= (A'B')'
= A + B

### 2. Use Boolean laws and properties to show that: xy + x’z + yz = xy + x’z

Show the sequence of laws and properties you use to minimize the expression on the left. Use a truth table to show that your minimization result is correct.

**Ans**

Since xy + x'z + yz

= xy + x'z + xyz + x'yz

= (xy + xyz) + (x'z + x'zy)

= xy(1 + z) + x'z(1 + y)

= xy + x'z

**Q.E.D**

Below is the corresponding truth table:

| x | y | z | xy | x'z | yz | xy+x'z+yz | xy+x'z |
|---|---|---|----|-----|----|-----------|--------|
| 0 | 0 | 0 | 0  | 0   | 0  | 0         | 0      |
| 0 | 0 | 1 | 0  | 1   | 0  | 1         | 1      |
| 0 | 1 | 0 | 0  | 0   | 0  | 0         | 0      |
| 0 | 1 | 1 | 0  | 1   | 1  | 1         | 1      |
| 1 | 0 | 0 | 0  | 0   | 0  | 0         | 0      |
| 1 | 0 | 1 | 0  | 0   | 0  | 0         | 0      |
| 1 | 1 | 0 | 1  | 0   | 0  | 1         | 1      |
| 1 | 1 | 1 | 1  | 0   | 1  | 1         | 1      |

### 3. Use Boolean laws and properties to show that: (x+y)(x’+z)(y+z) = (x+y)(x’+z)

Show the sequence of laws and properties you use to minimize the expression on the left. Use a truth table to show that your minimization result is correct.

**Ans**

Since (x + y)(x’ + z)(y + z) = ((x'y') + (xz') + (y'z'))' and (x+y)(x’+z) = ((x'y') + (xz'))'

Using consensus theorem, we already have:

(x'y') + (xz') + (y'z') = (x'y') + (xz')

Take the complement of both sides, we have:

((x'y') + (xz') + (y'z'))' = ((x'y') + (xz'))'

Which is equivalent to:

(x+y)(x’+z)(y+z) = (x+y)(x’+z)

**Q.E.D**

Below is the corresponding truth table:

| x | y | z | xy | x'z | yz | xy+x'z+yz | xy+x'z |
|---|---|---|----|-----|----|-----------|--------|
| 0 | 0 | 0 | 0  | 0   | 0  | 0         | 0      |
| 0 | 0 | 1 | 0  | 1   | 0  | 1         | 1      |
| 0 | 1 | 0 | 0  | 0   | 0  | 0         | 0      |
| 0 | 1 | 1 | 0  | 1   | 1  | 1         | 1      |
| 1 | 0 | 0 | 0  | 0   | 0  | 0         | 0      |
| 1 | 0 | 1 | 0  | 0   | 0  | 0         | 0      |
| 1 | 1 | 0 | 1  | 0   | 0  | 1         | 1      |
| 1 | 1 | 1 | 1  | 0   | 1  | 1         | 1      |

### 4. Convert the following binary values to decimal and hexadecimal. Show all work

a. 11001
= 1*2^4 + 1*2^3 + 0*2^2 + 0*2^1 + 1*2^0
= (16)D + (8)D + (1)D = (25)D
= (10)H + (5)H = (15)H

b. 1111
= 1*2^3 + 1*2^2 + 1*2^1 + 1*2^0
= (8)D + (4)D + (2)D + (1D) = (15)D
= (F)H

c. 110010
= 1*2^5 + 1*2^4 + 0*2^3 + 0*2^2 + 1*2^1 + 0*2^0
= (32)D + (16)D + (2)D = (50)D
= (20)H + (10)H + (2)H = (32)H

### 5. Modify the truth table in Table 7.1 if w1 = -2 instead of -1. All other weights and the threshold value remain the same as the example.

Below is the updated truth table after changing w1 to 2.

| x1 | x2 | x3 | -2*x1+2*x2+x3 | y |
|----|----|----|---------------|---|
| 0  | 0  | 0  | 0             | 0 |
| 0  | 0  | 1  | 1             | 1 |
| 0  | 1  | 0  | 2             | 1 |
| 0  | 1  | 1  | 3             | 1 |
| 1  | 0  | 0  | -2            | 0 |
| 1  | 0  | 1  | -1            | 0 |
| 1  | 1  | 0  | 0             | 0 |
| 1  | 1  | 1  | 1             | 1 |
