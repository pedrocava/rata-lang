# Core Module

Core module for the Rata programming language.

Provides basic language primitives and core functionality following
Rata's design principles:
- All values are vectors (no scalars)
- 1-indexed arrays
- Immutable by default
- Data-first philosophy


## Import

```rata
library Core
```

## Functions

### `argument_error(message)`

Create an ArgumentError exception.



### `assert(condition)`

Assert function - verifies that a condition is true.
Throws an error if the condition is false or falsy.



### `assert(condition, message)`

Assert function with custom message.
Throws an error with the provided message if condition is falsy.



### `debug(value)`

Debug print function - prints a value and returns it unchanged.
Useful for debugging pipelines.



### `debug(value, label)`

_No documentation available._


### `exception_message(%{})`

Get the message from an exception.



### `exception_message(_)`

_No documentation available._


### `exception_type(%{})`

Get the exception type from an exception.



### `exception_type(_)`

_No documentation available._


### `identity(value)`

Identity function - returns its argument unchanged.
Useful for testing and as a placeholder.



### `is_boolean(_)`

_No documentation available._


### `is_exception(%{})`

Check if a value is an exception.



### `is_exception(_)`

_No documentation available._


### `is_float(_)`

_No documentation available._


### `is_function(_)`

_No documentation available._


### `is_integer(_)`

_No documentation available._


### `is_list(_)`

_No documentation available._


### `is_map(_)`

_No documentation available._


### `is_nil(arg)`

Check if a value is nil.



### `is_nil(_)`

_No documentation available._


### `is_number(_)`

_No documentation available._


### `is_range(%)`

Check if a value is a range.



### `is_range(_)`

_No documentation available._


### `is_set(%)`

Check if a value is a set.



### `is_set(_)`

_No documentation available._


### `is_string(_)`

_No documentation available._


### `is_symbol(_)`

_No documentation available._


### `is_table(_)`

Check if a value is a table (Explorer DataFrame).



### `is_truthy(value)`

Check if a value is truthy according to Rata's truthiness rules.
Public version of the truthiness evaluation.



### `is_tuple(_)`

_No documentation available._


### `is_vector(_)`

_No documentation available._


### `runtime_error(message)`

Create a RuntimeError exception (most common type).



### `type_error(message)`

Create a TypeError exception.



### `typeof(arg)`

Type checking function - returns the type of a value as an atom.



### `typeof(%)`

_No documentation available._


### `typeof(%)`

_No documentation available._


### `typeof(_)`

_No documentation available._


### `value_error(message)`

Create a ValueError exception.



### `when(typeof, arg)`

_No documentation available._


### `when(typeof, arg)`

_No documentation available._


### `when(typeof, arg)`

_No documentation available._


### `when(typeof, is_binary)`

_No documentation available._


### `when(typeof, is_atom)`

_No documentation available._


### `when(typeof, arg)`

_No documentation available._


### `when(typeof, arg)`

_No documentation available._


### `when(typeof, and)`

_No documentation available._


### `when(debug, is_binary)`

Debug print with custom label.



### `when(exception, is_atom)`

Create a new exception with the given type.



### `when(exception, is_binary)`

_No documentation available._


### `when(exception, is_atom)`

Create a new exception with type and message.



### `when(exception, is_binary)`

_No documentation available._


### `when(is_list, arg)`

Check if a value is a list.



### `when(is_vector, arg)`

Check if a value is a vector (same as list in Rata).



### `when(is_map, and)`

Check if a value is a map.



### `when(is_boolean, arg)`

Check if a value is a boolean.



### `when(is_integer, arg)`

Check if a value is an integer.



### `when(is_float, arg)`

Check if a value is a float.



### `when(is_number, arg)`

Check if a value is a number (integer or float).



### `when(is_string, is_binary)`

Check if a value is a string.



### `when(is_symbol, is_atom)`

Check if a value is a symbol (atom).



### `when(is_tuple, arg)`

Check if a value is a tuple.



### `when(is_function, arg)`

Check if a value is a function.


