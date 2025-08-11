# Stats Module

The Stats module provides statistical functions for descriptive statistics, probability distributions, and statistical analysis commonly needed in data engineering.

## Overview

Stats features:
- **Descriptive statistics**: Mean, median, mode, variance, etc.
- **Probability distributions**: Normal, uniform, binomial, etc.
- **Random number generation**: Seeded and unseeded RNG
- **Statistical tests**: Basic hypothesis testing
- **Vector operations**: Efficient computation on numeric vectors

## Import

```rata
library Stats as s
```

## Descriptive Statistics

### `mean(numbers)` - Arithmetic mean
### `median(numbers)` - Middle value
### `mode(numbers)` - Most frequent value
### `std(numbers)` - Standard deviation
### `var(numbers)` - Variance
### `quantile(numbers, q)` - Quantile value

```rata
data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

avg = Stats.mean(data)          # 5.5
med = Stats.median(data)        # 5.5
std_dev = Stats.std(data)       # ~2.87
q75 = Stats.quantile(data, 0.75) # 7.75
```

## Distribution Statistics

### `min(numbers)`, `max(numbers)` - Extreme values
### `range(numbers)` - Difference between max and min
### `iqr(numbers)` - Interquartile range
### `skewness(numbers)` - Distribution skewness
### `kurtosis(numbers)` - Distribution kurtosis

## Random Number Generation

### `random()` - Random float between 0 and 1
### `random_int(min, max)` - Random integer in range
### `sample(population, size, replace \\= false)` - Random sample
### `shuffle(list)` - Randomly reorder elements

### Probability Distributions

### `rnorm(n, mean \\= 0, std \\= 1)` - Normal distribution
### `runif(n, min \\= 0, max \\= 1)` - Uniform distribution
### `rbinom(n, size, prob)` - Binomial distribution
### `rpois(n, lambda)` - Poisson distribution

```rata
# Generate random data
normal_data = Stats.rnorm(1000, mean: 100, std: 15)
uniform_data = Stats.runif(500, min: 0, max: 100)

# Statistical sampling
population = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
sample = Stats.sample(population, 5, replace: false)
```

## Correlation and Regression

### `cor(x, y)` - Pearson correlation coefficient
### `cov(x, y)` - Covariance between vectors
### `linear_regression(x, y)` - Simple linear regression

## Usage Examples

```rata
# Data quality assessment
data_summary = function(numbers) {
  {
    count: Vector.length(numbers),
    mean: Stats.mean(numbers),
    median: Stats.median(numbers),
    std: Stats.std(numbers),
    min: Stats.min(numbers),
    max: Stats.max(numbers),
    q25: Stats.quantile(numbers, 0.25),
    q75: Stats.quantile(numbers, 0.75),
    missing: Vector.count(numbers, Core.is_nil/1)
  }
}

# A/B test analysis
control_group = [23, 25, 22, 26, 24]
test_group = [28, 30, 27, 31, 29]

control_mean = Stats.mean(control_group)
test_mean = Stats.mean(test_group)
lift = (test_mean - control_mean) / control_mean * 100

Log.info(f"A/B Test Results: {lift}% improvement")
```

---

*This is a skeleton for the Stats module documentation. Full implementation details will be added as the module is developed.*