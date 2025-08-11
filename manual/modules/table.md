# Table Module

The Table module provides columnar data structures and operations similar to R's dplyr or Python's pandas, optimized for data engineering workflows. Tables are the primary data structure for working with structured data in Rata.

## Overview

Tables in Rata are:
- **Columnar**: Data stored efficiently by column
- **Immutable**: Operations return new tables rather than modifying existing ones
- **Type-aware**: Each column maintains consistent types
- **1-indexed**: Following R conventions for data work
- **Lazy when possible**: Some operations are optimized with lazy evaluation

Built on top of Elixir's Explorer library for performance.

## Import

```rata
library Table as t
```

## Table Creation

### `new(column_map)`
Creates a new table from a map of column names to vectors.

```rata
users = Table.new({
  id: [1, 2, 3],
  name: ["Alice", "Bob", "Charlie"],
  age: [25, 30, 35],
  city: ["NYC", "LA", "Chicago"]
})
```

### `from_map(map)`
Alias for `new()` - creates table from column map.

```rata
data = Table.from_map({
  x: [1, 2, 3],
  y: [4, 5, 6]
})
```

### `from_vectors(column_names, row_vectors)`
Creates table from a vector of column names and vectors of row data.

```rata
table = Table.from_vectors(
  ["name", "score"],
  [
    ["Alice", 95],
    ["Bob", 87],
    ["Charlie", 92]
  ]
)
```

### `empty(schema)`
Creates an empty table with specified column schema.

```rata
empty_users = Table.empty({
  id: :int,
  name: :string,
  email: :string
})
```

## Table Information

### `nrows(table)`
Returns the number of rows in the table.

```rata
count = Table.nrows(users)  # 3
```

### `ncols(table)`
Returns the number of columns in the table.

```rata
width = Table.ncols(users)  # 4
```

### `shape(table)`
Returns `{rows, cols}` tuple with table dimensions.

```rata
{num_rows, num_cols} = Table.shape(users)  # {3, 4}
```

### `columns(table)`
Returns a vector of column names.

```rata
col_names = Table.columns(users)  # ["id", "name", "age", "city"]
```

### `dtypes(table)`
Returns a map of column names to their data types.

```rata
types = Table.dtypes(users)
# {id: :int, name: :string, age: :int, city: :string}
```

### `head(table, n \\ 5)`
Returns the first n rows of the table.

```rata
preview = Table.head(large_dataset, 10)
```

### `tail(table, n \\ 5)`
Returns the last n rows of the table.

```rata
recent = Table.tail(time_series, 20)
```

## Data Selection

### `select(table, columns)`
Selects specific columns from the table.

```rata
# Select by column names
names_and_ages = users |> Table.select(["name", "age"])

# Select with symbols
subset = users |> Table.select([:name, :city])
```

### `drop(table, columns)`
Removes specific columns from the table.

```rata
# Drop single column
without_id = users |> Table.drop("id")

# Drop multiple columns  
core_data = users |> Table.drop(["id", "city"])
```

### `rename(table, column_map)`
Renames columns according to a mapping.

```rata
renamed = users |> Table.rename({
  name: :full_name,
  age: :years_old
})
```

### `slice(table, start, length \\ nil)`
Extracts rows by position (1-indexed).

```rata
# Get rows 2-4
middle_rows = Table.slice(users, 2, 3)

# Get from row 2 to end
from_second = Table.slice(users, 2)
```

## Data Filtering

### `filter(table, condition)`
Filters rows based on a condition expression.

```rata
# Simple condition
adults = users |> Table.filter(age >= 18)

# Multiple conditions
ny_adults = users 
  |> Table.filter(age >= 18)
  |> Table.filter(city == "NYC")

# Complex expression
filtered = data |> Table.filter(score > mean(score) + std(score))
```

### `filter_not(table, condition)`
Filters rows that don't match the condition.

```rata
non_nyc = users |> Table.filter_not(city == "NYC")
```

### `distinct(table, columns \\ nil)`
Removes duplicate rows.

```rata
# Remove completely duplicate rows
unique_users = users |> Table.distinct()

# Unique based on specific columns
unique_cities = users |> Table.distinct(["city"])
```

## Data Transformation

### `mutate(table, column_expressions)`
Adds new columns or modifies existing ones.

```rata
enhanced = users |> Table.mutate(
  age_next_year: age + 1,
  is_adult: age >= 18,
  name_length: String.length(name),
  age_group: case age {
    n when n < 30 -> "young"
    n when n < 50 -> "middle"
    _ -> "senior"
  }
)
```

### `transmute(table, column_expressions)`
Like mutate, but keeps only the new/specified columns.

```rata
summary = users |> Table.transmute(
  name: name,
  decade: Math.floor(age / 10) * 10,
  location: String.upcase(city)
)
```

### `with_row_number(table, column_name \\ :row_number)`
Adds a column with row numbers.

```rata
numbered = users |> Table.with_row_number(:id)
```

## Data Arrangement

### `arrange(table, columns)`
Sorts the table by specified columns.

```rata
# Sort by single column (ascending)
by_age = users |> Table.arrange(:age)

# Sort by multiple columns
by_city_then_age = users |> Table.arrange([:city, :age])

# Descending order (use negative)
by_age_desc = users |> Table.arrange(-age)

# Mixed ordering
mixed = users |> Table.arrange([city, -age])
```

### `sample(table, n \\ nil, replace \\ false)`
Randomly samples rows from the table.

```rata
# Sample 10 rows without replacement
sample_data = large_dataset |> Table.sample(10)

# Sample with replacement
bootstrap_sample = data |> Table.sample(1000, replace: true)
```

## Grouping and Summarization

### `group_by(table, columns)`
Groups table by specified columns for aggregation.

```rata
grouped = sales_data |> Table.group_by([:region, :product])
```

### `ungroup(table)`
Removes grouping from a table.

```rata
ungrouped = grouped_data |> Table.ungroup()
```

### `summarize(table, summary_expressions)`
Aggregates grouped data.

```rata
summary = sales_data
  |> Table.group_by(:region)
  |> Table.summarize(
      total_sales: Math.sum(amount),
      avg_price: Math.mean(price),
      transaction_count: Table.n(),
      max_date: Date.max(transaction_date)
     )
```

### `n()`
Counts rows in each group (used within summarize).

```rata
counts = data 
  |> Table.group_by(:category)
  |> Table.summarize(count: Table.n())
```

## Joining Tables

### `inner_join(left, right, on)`
Inner join - returns rows that match in both tables.

```rata
result = users 
  |> Table.inner_join(orders, on: :user_id)
```

### `left_join(left, right, on)`
Left join - returns all rows from left table.

```rata
with_orders = users
  |> Table.left_join(orders, on: :user_id)
```

### `right_join(left, right, on)`
Right join - returns all rows from right table.

```rata
all_orders = users
  |> Table.right_join(orders, on: :user_id)
```

### `full_join(left, right, on)`
Full outer join - returns all rows from both tables.

```rata
complete = table1
  |> Table.full_join(table2, on: [:key1, :key2])
```

### `anti_join(left, right, on)`
Returns rows from left table that don't have matches in right table.

```rata
users_without_orders = users
  |> Table.anti_join(orders, on: :user_id)
```

### `semi_join(left, right, on)`
Returns rows from left table that have matches in right table.

```rata
users_with_orders = users
  |> Table.semi_join(orders, on: :user_id)
```

## Table Combination

### `union(table1, table2)`
Combines rows from two tables (removes duplicates).

```rata
all_data = current_data |> Table.union(historical_data)
```

### `union_all(table1, table2)`
Combines rows from two tables (keeps duplicates).

```rata
combined = batch1 |> Table.union_all(batch2)
```

### `bind_rows(tables)`
Combines multiple tables vertically.

```rata
monthly_reports = [jan_data, feb_data, mar_data]
  |> Table.bind_rows()
```

### `bind_cols(table1, table2)`
Combines tables horizontally (by position).

```rata
enhanced = base_data |> Table.bind_cols(additional_features)
```

## Data Reshaping

### `pivot_longer(table, columns, names_to, values_to)`
Converts wide data to long format.

```rata
# Wide: {id: [1, 2], jan: [100, 150], feb: [120, 160]}
# Long: {id: [1, 1, 2, 2], month: ["jan", "feb", "jan", "feb"], value: [100, 120, 150, 160]}

long_data = wide_data |> Table.pivot_longer(
  columns: [:jan, :feb, :mar],
  names_to: :month,
  values_to: :sales
)
```

### `pivot_wider(table, names_from, values_from)`
Converts long data to wide format.

```rata
wide_data = long_data |> Table.pivot_wider(
  names_from: :month,
  values_from: :sales
)
```

### `separate(table, column, into, sep)`
Splits a column into multiple columns.

```rata
separated = data |> Table.separate(
  column: :full_name,
  into: [:first_name, :last_name],
  sep: " "
)
```

### `unite(table, new_column, columns, sep)`
Combines multiple columns into one.

```rata
united = data |> Table.unite(
  new_column: :full_name,
  columns: [:first_name, :last_name],
  sep: " "
)
```

## Usage Examples

### Data Pipeline
```rata
library Table as t
library Math as m

# Complete data processing pipeline
result = raw_sales_data
  |> t.filter(amount > 0)  # Remove invalid transactions
  |> t.filter(date >= "2023-01-01")  # Recent data only
  |> t.mutate(
      month: Date.month(date),
      profit: amount - cost,
      profit_margin: profit / amount * 100
     )
  |> t.group_by([:region, :month])
  |> t.summarize(
      total_sales: m.sum(amount),
      total_profit: m.sum(profit),
      avg_margin: m.mean(profit_margin),
      transaction_count: t.n()
     )
  |> t.arrange([-total_sales])
  |> t.head(20)
```

### Data Validation and Cleaning
```rata
clean_user_data = function(raw_data) {
  raw_data
    |> t.filter(age > 0)  # Remove invalid ages
    |> t.filter(age < 150)  # Remove unrealistic ages
    |> t.filter(email != "")  # Remove empty emails
    |> t.distinct([:email])  # Remove duplicate emails
    |> t.mutate(
        email: String.downcase(email),
        age_group: categorize_age(age),
        is_adult: age >= 18
       )
    |> t.arrange([:age_group, :name])
}
```

### Join Analysis
```rata
# Analyze customer order patterns
customer_analysis = customers
  |> t.left_join(orders, on: :customer_id)
  |> t.left_join(order_items, on: :order_id)
  |> t.group_by(:customer_id)
  |> t.summarize(
      customer_name: Vector.first(customer_name),
      total_orders: t.n_distinct(:order_id),
      total_items: Math.sum(quantity),
      total_spent: Math.sum(price * quantity),
      avg_order_value: Math.mean(order_total),
      first_order: Date.min(order_date),
      last_order: Date.max(order_date)
     )
  |> t.mutate(
      customer_lifetime: Date.diff(last_order, first_order, :days),
      orders_per_month: total_orders / Math.max(customer_lifetime / 30, 1)
     )
  |> t.arrange(-total_spent)
```

## Performance Notes

- **Lazy evaluation**: Many operations are optimized with lazy evaluation
- **Column storage**: Data stored efficiently in columnar format
- **Memory efficiency**: Operations avoid copying data when possible  
- **Parallel processing**: Some operations can be parallelized automatically
- **Explorer backend**: Built on Elixir's Explorer for C-level performance

## Best Practices

1. **Chain operations** using the pipe operator for readable data pipelines
2. **Filter early** to reduce data size before expensive operations
3. **Use appropriate joins** - inner join when you need matches, left join to preserve left table
4. **Group before summarize** - always group before using aggregation functions
5. **Consider memory usage** - use `head()` and `tail()` for large datasets in development
6. **Validate data** - use `distinct()`, filtering, and type checks to ensure data quality

---

The Table module is the heart of data manipulation in Rata. Master these functions to build powerful data processing pipelines that are both readable and performant.