# Struct Module

The Struct module provides structured data types with schemas, validation, and type safety for building robust data applications.

## Overview

Struct features:
- **Schema definition**: Define data structure contracts
- **Type validation**: Ensure data conforms to schema
- **Default values**: Specify defaults for optional fields
- **Nested structures**: Support for complex data hierarchies
- **Serialization**: Convert to/from maps and JSON

## Import

```rata
library Struct as s
```

## Defining Structs

```rata
# User struct definition
UserStruct = Struct.define({
  id: {:type, :int, required: true},
  name: {:type, :string, required: true},
  email: {:type, :string, required: true},
  age: {:type, :int, default: 0},
  active: {:type, :boolean, default: true},
  preferences: {:type, :map, default: {}}
})
```

## Creating Struct Instances

### `new(struct_definition, data)` - Create new struct instance
### `from_map(struct_definition, map)` - Create from map data

```rata
# Create user instance
user = Struct.new(UserStruct, {
  id: 123,
  name: "Alice Johnson",
  email: "alice@example.com",
  age: 30
})
```

## Accessing and Updating

### `get(struct, field)` - Get field value
### `put(struct, field, value)` - Update field value
### `update(struct, updates)` - Update multiple fields

```rata
# Access fields
user_name = Struct.get(user, :name)  # "Alice Johnson"
user_age = user.age                  # 30 (shorthand access)

# Update fields
updated_user = user |> Struct.put(:age, 31)
user_with_prefs = user |> Struct.update({
  preferences: {theme: "dark", notifications: true}
})
```

## Validation

### `valid?(struct)` - Check if struct is valid
### `validate(struct)` - Get validation results
### `errors(struct)` - Get validation errors

```rata
# Validation
case Struct.validate(user_data) {
  {:ok, valid_user} -> process_user(valid_user)
  {:error, errors} -> 
    Log.error(f"User validation failed: {errors}")
    {:error, "Invalid user data"}
}
```

## Usage Examples

```rata
# Order processing system
OrderStruct = Struct.define({
  id: {:type, :string, required: true},
  customer_id: {:type, :int, required: true},
  items: {:type, :list, default: []},
  total_amount: {:type, :float, required: true},
  status: {:type, :atom, default: :pending},
  created_at: {:type, :datetime, default: Datetime.now()}
})

OrderItemStruct = Struct.define({
  product_id: {:type, :string, required: true},
  quantity: {:type, :int, required: true},
  price: {:type, :float, required: true}
})

# Create order with items
order = Struct.new(OrderStruct, {
  id: "ORD-001",
  customer_id: 123,
  items: [
    Struct.new(OrderItemStruct, {
      product_id: "PROD-A",
      quantity: 2,
      price: 29.99
    }),
    Struct.new(OrderItemStruct, {
      product_id: "PROD-B", 
      quantity: 1,
      price: 49.99
    })
  ],
  total_amount: 109.97
})
```

---

*This is a skeleton for the Struct module documentation. Full implementation details will be added as the module is developed.*