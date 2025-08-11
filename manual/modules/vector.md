# Vector Module

The Vector module provides operations for working with Rata's fundamental data structure - vectors. In Rata, there are no scalar values; everything is a vector, even single values like `42` are actually `[42]`.

## Vector Creation

```rata
names = ["Alice", "Bob", "Charlie"]
odds = [1, 3, 5, 7]
syms = [:ok, :fine, :gotcha, :nope]
```

### `new(elements)`
Creates a new vector from a list of elements.

```rata
numbers = Vector.new(1, 2, 3, 4, 5)
names = Vector.new("Alice", "Bob", "Charlie")

```

### `range(start, stop, step \\ 1)`
Creates a vector of numbers in a range.

```rata
Vector.range(1, 10)      # [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
Vector.range(0, 1, 0.1)  # [0.0, 0.1, 0.2, ..., 1.0]
Vector.range(10, 1, -2)  # [10, 8, 6, 4, 2]
```

### `repeat(value, times)`
Creates a vector by repeating a value.

```rata
Vector.repeat(0, 5)      # [0, 0, 0, 0, 0]
Vector.repeat("hello", 3) # ["hello", "hello", "hello"]
```

### `zeros(size)`, `ones(size)`
Creates vectors of zeros or ones.

```rata
Vector.zeros(4)          # [0, 0, 0, 0]
Vector.ones(3)           # [1, 1, 1]
```

## Vector Information

### `length(vector)`
Returns the number of elements.

### `is_empty(vector)`
Checks if vector has no elements.

### `type(vector)`
Returns the element type of the vector.

### `head(vector, n \\ 5)`, `tail(vector, n \\ 5)`
Returns first/last n elements.

## Element Access

### `get(vector, index)`
Gets element at index (1-based).

### `slice(vector, start, length \\ nil)`
Extracts a portion of the vector.

### `first(vector)`, `last(vector)`
Gets first or last element.

## Vector Operations

### `append(vector, elements)`
Adds elements to the end.

### `prepend(vector, elements)`
Adds elements to the beginning.

### `concat(vector1, vector2)`
Combines two vectors.

### `reverse(vector)`
Reverses element order.

### `sort(vector, descending \\ false)`
Sorts elements.

### `unique(vector)`
Removes duplicate elements.

## Mathematical Operations

### `sum(vector)`, `product(vector)`
Sum or product of all elements.

### `min(vector)`, `max(vector)`
Minimum or maximum element.

### `cumsum(vector)`, `cumprod(vector)`
Cumulative sum or product.

## Functional Operations

### `map(vector, function)`
Transforms each element.

### `filter(vector, predicate)`
Keeps elements matching condition.

### `reduce(vector, function, initial)`
Reduces to single value.

### `any(vector, predicate)`, `all(vector, predicate)`
Tests if any/all elements match condition.

## Usage Examples

```rata
library Vector as v
library Math as m

# Data analysis
scores = v.range(1, 100) |> v.map(~ Random.float() * 100)
high_scores = scores |> v.filter(~ .x > 80)
avg_score = v.sum(scores) / v.length(scores)

# Vector arithmetic  
a = [1, 2, 3, 4]
b = [5, 6, 7, 8]
sum_vectors = v.map2(a, b, Math.add/2)  # [6, 8, 10, 12]
```

---

*This is a skeleton for the Vector module documentation. Full implementation details will be added as the module is developed.*
