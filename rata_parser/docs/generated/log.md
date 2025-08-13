# Log Module

Logging module for the Rata programming language.

Provides basic logging functionality with different levels following
Rata's design principles:
- All values are vectors (no scalars)
- 1-indexed arrays
- Immutable by default
- Data-first philosophy


## Import

```rata
library Log
```

## Functions

### `debug(message)`

Log a debug message and return nil.



### `error(message)`

Log an error message and return nil.



### `info(message)`

Log an info message and return nil.



### `log(level, message)`

_No documentation available._


### `warn(message)`

Log a warning message and return nil.



### `when(log, is_binary)`

Log a message with custom level and return nil.



### `when(log, is_atom)`

_No documentation available._

