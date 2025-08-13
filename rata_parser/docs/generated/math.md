# Math Module

Math module for the Rata programming language.

Provides basic arithmetic operators and mathematical functions following
Rata's design principles:
- All values are vectors (no scalars)
- 1-indexed arrays
- Immutable by default
- Data-first philosophy


## Import

```rata
library Math
```

## Functions

### `abs(a)`

_No documentation available._


### `add(a, b)`

_No documentation available._


### `ceil(a)`

_No documentation available._


### `cos(a)`

_No documentation available._


### `cube(a)`

_No documentation available._


### `divide(a, b)`

_No documentation available._


### `e()`

Euler's number constant.



### `exp(a)`

_No documentation available._


### `factorial(n)`

_No documentation available._


### `floor(a)`

_No documentation available._


### `is_even(n)`

_No documentation available._


### `is_odd(n)`

_No documentation available._


### `log(a)`

_No documentation available._


### `log10(a)`

_No documentation available._


### `max(a, b)`

_No documentation available._


### `min(a, b)`

_No documentation available._


### `multiply(a, b)`

_No documentation available._


### `pi()`

Pi constant.



### `power(a, b)`

_No documentation available._


### `round(a)`

_No documentation available._


### `sin(a)`

_No documentation available._


### `sqrt(a)`

_No documentation available._


### `square(a)`

_No documentation available._


### `subtract(a, b)`

_No documentation available._


### `tan(a)`

_No documentation available._


### `when(add, and)`

Addition function - adds two numbers.
In Rata, this wraps the + binary operator for module-style calls.



### `when(subtract, and)`

Subtraction function - subtracts second number from first.



### `when(multiply, and)`

Multiplication function - multiplies two numbers.



### `when(divide, and)`

Division function - divides first number by second.



### `when(divide, is_number)`

_No documentation available._


### `when(power, and)`

Power function - raises first number to the power of second.



### `when(abs, is_number)`

Absolute value function.



### `when(sqrt, and)`

Square root function.



### `when(sqrt, and)`

_No documentation available._


### `when(square, is_number)`

Square function - returns x^2.



### `when(cube, is_number)`

Cube function - returns x^3.



### `when(factorial, and)`

Factorial function - computes n!



### `when(factorial, and)`

_No documentation available._


### `when(factorial, is_number)`

_No documentation available._


### `when(exp, is_number)`

Natural exponential function - e^x.



### `when(log, and)`

Natural logarithm function - ln(x).



### `when(log, and)`

_No documentation available._


### `when(log10, and)`

Logarithm base 10 function - log10(x).



### `when(log10, and)`

_No documentation available._


### `when(sin, is_number)`

Sine function.



### `when(cos, is_number)`

Cosine function.



### `when(tan, is_number)`

Tangent function.



### `when(max, and)`

Maximum of two numbers.



### `when(min, and)`

Minimum of two numbers.



### `when(ceil, is_number)`

Ceiling function - smallest integer greater than or equal to x.



### `when(floor, is_number)`

Floor function - largest integer less than or equal to x.



### `when(round, is_number)`

Round function - rounds to nearest integer.



### `when(is_even, is_integer)`

Check if a number is even.



### `when(is_even, is_number)`

_No documentation available._


### `when(is_odd, is_integer)`

Check if a number is odd.



### `when(is_odd, is_number)`

_No documentation available._

