# Stats Module

Statistics module for the Rata programming language.

Provides statistical functions and random number generation following
Rata's design principles:
- All values are vectors (no scalars)
- 1-indexed arrays
- Immutable by default
- Data-first philosophy


## Import

```rata
library Stats
```

## Functions

### `mean(value)`

_No documentation available._


### `median(value)`

_No documentation available._


### `quantiles(values, probs)`

_No documentation available._


### `rdunif()`

Generate random integers from discrete uniform distribution.
Similar to R's rdunif() function with default parameters: n=1, a=0, b=1.



### `rdunif(n, a, b)`

_No documentation available._


### `rnorm()`

Generate random numbers from normal distribution.
Similar to R's rnorm() function.



### `rnorm(mean, std)`

_No documentation available._


### `runif()`

Generate a random float between 0.0 and 1.0 (uniform distribution).
Similar to R's runif() function.



### `runif(min, max)`

_No documentation available._


### `sd(value)`

_No documentation available._


### `var(value)`

_No documentation available._


### `when(runif, and)`

Generate a random float between min and max (uniform distribution).



### `when(runif, and)`

_No documentation available._


### `when(rnorm, and)`

Generate random numbers from normal distribution with mean and std deviation.



### `when(rnorm, and)`

_No documentation available._


### `when(rdunif, and)`

_No documentation available._


### `when(rdunif, and)`

_No documentation available._


### `when(rdunif, and)`

_No documentation available._


### `when(rdunif, and)`

_No documentation available._


### `when(rdunif, and)`

_No documentation available._


### `when(mean, is_list)`

Calculate mean of a list of numbers.



### `when(sd, is_list)`

Calculate standard deviation of a list of numbers.



### `when(var, is_list)`

Calculate variance of a list of numbers.



### `when(median, is_list)`

Calculate median of a list of numbers.



### `when(quantiles, and)`

Calculate quantiles of a list of numbers.


