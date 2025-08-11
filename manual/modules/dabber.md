# Dabber Module

The Dabber module provides database operations as a wrapper around Elixir's Ecto, offering four main submodules for comprehensive database integration.

## Overview

Dabber consists of:
- **Dabber.Repo**: Database connection management
- **Dabber.Schema**: Database schema definitions
- **Dabber.Query**: Query building and execution
- **Dabber.Changeset**: Data validation and transformation

## Import

```rata
library Dabber.Repo as repo
library Dabber.Schema as schema
library Dabber.Query as query
library Dabber.Changeset as changeset
```

## Dabber.Repo - Connection Management

### `start_link(config)` - Start database connection
### `get(schema, id)` - Get record by ID
### `all(query)` - Execute query and return all results
### `one(query)` - Execute query and return single result
### `insert(changeset)` - Insert new record
### `update(changeset)` - Update existing record
### `delete(record)` - Delete record

```rata
# Database configuration
config = {
  adapter: :postgres,
  hostname: "localhost",
  database: "myapp_dev",
  username: "postgres",
  password: "password"
}

# Start repository
repo.start_link(config)

# Basic operations
user = repo.get(UserSchema, 123)
all_users = repo.all(UserSchema)
```

## Dabber.Schema - Schema Definitions

### `define(name, fields)` - Define database schema
### `table_name(schema)` - Get table name
### `primary_key(schema)` - Get primary key field

```rata
# Define user schema
UserSchema = schema.define("users", {
  id: {:id, primary_key: true},
  name: {:string, required: true},
  email: {:string, required: true, unique: true},
  age: {:integer},
  active: {:boolean, default: true},
  inserted_at: {:datetime, auto: :insert},
  updated_at: {:datetime, auto: :update}
})
```

## Dabber.Query - Query Building

### `from(schema)` - Start query from schema
### `select(query, fields)` - Select specific fields
### `where(query, conditions)` - Add WHERE conditions
### `order_by(query, fields)` - Add ORDER BY clause
### `limit(query, count)` - Limit results
### `join(query, schema, on)` - Add JOIN clause

```rata
# Build complex queries
active_users = UserSchema
  |> query.where(active == true)
  |> query.where(age >= 18)
  |> query.order_by(:name)
  |> query.limit(50)
  |> repo.all()

# Joins
user_orders = UserSchema
  |> query.join(OrderSchema, on: user_id == id)
  |> query.select([users.name, orders.total])
  |> query.where(orders.status == "completed")
  |> repo.all()
```

## Dabber.Changeset - Data Validation

### `cast(data, schema, permitted)` - Cast data to schema
### `validate_required(changeset, fields)` - Validate required fields
### `validate_format(changeset, field, pattern)` - Validate field format
### `validate_length(changeset, field, options)` - Validate field length
### `errors(changeset)` - Get validation errors

```rata
# Data validation and insertion
user_params = {
  name: "Alice Johnson",
  email: "alice@example.com",
  age: 30
}

changeset = user_params
  |> changeset.cast(UserSchema, [:name, :email, :age])
  |> changeset.validate_required([:name, :email])
  |> changeset.validate_format(:email, ~r/@/)
  |> changeset.validate_length(:name, min: 2, max: 100)

case repo.insert(changeset) {
  {:ok, user} -> Log.info(f"User created: {user.name}")
  {:error, changeset} -> 
    errors = changeset.errors(changeset)
    Log.error(f"User creation failed: {errors}")
}
```

## Usage Examples

```rata
# Complete CRUD operations
module UserService {
  library Dabber.Repo as repo
  library Dabber.Query as query
  library Dabber.Changeset as changeset
  
  # Create user
  create_user = function(params) {
    changeset = params
      |> changeset.cast(UserSchema, [:name, :email, :age])
      |> changeset.validate_required([:name, :email])
      |> changeset.validate_format(:email, email_regex())
      |> changeset.unique_constraint(:email)
    
    repo.insert(changeset)
  }
  
  # Get active users
  get_active_users = function() {
    UserSchema
      |> query.where(active == true)
      |> query.order_by(:name)
      |> repo.all()
  }
  
  # Update user
  update_user = function(user, params) {
    changeset = user
      |> changeset.cast(params, [:name, :email, :age])
      |> changeset.validate_required([:name, :email])
    
    repo.update(changeset)
  }
  
  # Delete user
  delete_user = function(user) {
    repo.delete(user)
  }
}

# Analytics queries
get_user_statistics = function() {
  UserSchema
    |> query.select([
        count: query.count(),
        avg_age: query.avg(:age),
        active_count: query.count(query.where(:active, true))
       ])
    |> repo.one()
}
```

---

*This is a skeleton for the Dabber module documentation. Full implementation details will be added as the database integration is developed.*