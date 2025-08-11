# Set Module

The Set module provides operations for working with unique collections of values. Sets use the syntax `#{1, 2, 3}` and automatically handle uniqueness.

## Overview

Sets in Rata are:
- **Unique elements**: No duplicates allowed
- **Unordered**: No guaranteed element ordering
- **Immutable**: Operations return new sets
- **Efficient**: Fast membership testing and set operations

## Import

```rata
library Set as s
```

## Set Creation

### `new(elements)` - Create set from vector or list
### `empty()` - Create empty set
### `from_vector(vector)` - Create from vector (removes duplicates)

## Core Operations

### `member?(set, element)` - Test if element is in set
### `add(set, element)` - Add element to set
### `delete(set, element)` - Remove element from set
### `size(set)` - Get number of elements
### `to_vector(set)` - Convert set to vector

## Set Operations

### `union(set1, set2)` - Elements in either set
### `intersection(set1, set2)` - Elements in both sets
### `difference(set1, set2)` - Elements in first set but not second
### `subset?(set1, set2)` - Test if first set is subset of second
### `disjoint?(set1, set2)` - Test if sets have no common elements

## Usage Examples

```rata
# Tag management
user_tags = Set.new(:engineer, :python, :data_science)
required_tags = #{:python, :sql}

has_required = Set.subset?(required_tags, user_tags)  # true
all_tags = Set.union(user_tags, #{:new_tag})
```

---

*This is a skeleton for the Set module documentation. Full implementation details will be added as the module is developed.*
