# Tests Module

The Tests module provides a testing framework for Rata code, supporting unit tests, integration tests, and property-based testing.

## Overview

Testing features:
- **Simple assertions**: Easy-to-write test cases
- **Test organization**: Group related tests together
- **Mocking support**: Mock external dependencies
- **Property-based testing**: Generate test cases automatically
- **Coverage reporting**: Track code coverage

## Import

```rata
library Tests as test
```

## Basic Testing

### `assert_eq(actual, expected, message \\= nil)` - Assert equality
### `assert_ne(actual, expected, message \\= nil)` - Assert inequality
### `assert_true(condition, message \\= nil)` - Assert true
### `assert_false(condition, message \\= nil)` - Assert false
### `assert_raises(exception, function)` - Assert exception is raised

```rata
# Simple test function
test_math_operations = function() {
  Tests.assert_eq(Math.add!(2, 3), 5)
  Tests.assert_eq(Math.multiply!(4, 5), 20)
  Tests.assert_raises(DivisionByZeroError, fn -> Math.divide!(1, 0) end)
}
```

## Test Organization

### `describe(description, test_functions)` - Group related tests
### `test(description, test_function)` - Define individual test
### `setup(function)` - Run before each test
### `teardown(function)` - Run after each test

```rata
Tests.describe("Math module", [
  Tests.test("addition works correctly", fn ->
    Tests.assert_eq(Math.add!(2, 3), 5)
    Tests.assert_eq(Math.add!([1, 2], [3, 4]), [4, 6])
  end),
  
  Tests.test("division handles zero", fn ->
    Tests.assert_raises(DivisionByZeroError, fn -> Math.divide!(1, 0) end)
  end)
])
```

## Mocking

### `mock(module, function, return_value)` - Mock function return
### `mock_call(module, function, arguments)` - Verify function was called
### `reset_mocks()` - Clear all mocks

```rata
# Mock external API call
Tests.mock(HttpClient, :get, {:ok, {status: 200, body: "test data"}})

result = process_api_data()
Tests.assert_eq(result.status, :success)
Tests.mock_call(HttpClient, :get, ["https://api.example.com/data"])
```

## Property-Based Testing

### `property(description, generators, test_function)` - Property test
### `generate_int(min, max)` - Integer generator
### `generate_string(length)` - String generator
### `generate_list(element_generator, length)` - List generator

```rata
# Property: addition is commutative
Tests.property("addition is commutative", [
  a: Tests.generate_int(1, 100),
  b: Tests.generate_int(1, 100)
], fn {a, b} ->
  Tests.assert_eq(Math.add!(a, b), Math.add!(b, a))
end)
```

## Usage Examples

```rata
# Complete test suite for data processing function
Tests.describe("User data processing", [
  Tests.setup(fn ->
    # Create test data
    test_users = [
      {id: 1, name: "Alice", age: 30},
      {id: 2, name: "Bob", age: 25},
      {id: 3, name: "Charlie", age: 35}
    ]
    {test_users: test_users}
  end),
  
  Tests.test("filters adult users", fn {test_users} ->
    adults = filter_adults(test_users)
    Tests.assert_eq(Vector.length(adults), 3)
    Tests.assert_true(Enum.all?(adults, ~ .x.age >= 18))
  end),
  
  Tests.test("handles empty input", fn _ ->
    result = filter_adults([])
    Tests.assert_eq(result, [])
  end),
  
  Tests.test("raises error for invalid data", fn _ ->
    Tests.assert_raises(ArgumentError, fn ->
      filter_adults("invalid")
    end)
  end)
])

# Integration test with external services
Tests.describe("Data pipeline integration", [
  Tests.test("processes CSV file end-to-end", fn ->
    # Mock file system
    Tests.mock(File, :read, {:ok, "id,name,age\n1,Alice,30\n2,Bob,25"})
    
    result = process_user_file("test.csv")
    
    Tests.assert_eq(result.status, :success)
    Tests.assert_eq(Vector.length(result.data), 2)
    Tests.mock_call(File, :read, ["test.csv"])
  end)
])
```

## Running Tests

```bash
# Run all tests
rata test

# Run specific test file
rata test test/math_test.rata

# Run with coverage
rata test --coverage

# Run in watch mode
rata test --watch
```

---

*This is a skeleton for the Tests module documentation. Full implementation details will be added as the module is developed.*