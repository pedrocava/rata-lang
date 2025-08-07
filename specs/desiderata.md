# rata-lang desiderata

You reason about Rata like you do about tidyverse R, with a bit of python syntax, and leveraging the fantastic ecossystem of Elixir, Phoenix and OTP. A batteries included language, with an optional, algebraic typing system, fit for the type of work DEs are usually doing in Python.

## Features

- Data types should be familiar: ints, floats, booleans, strings, and symbols.
- Data structtures too: Vectors, Lists, Maps, Tables, Sets
- R-like anonymous functions and lambdas: `function (a, b, c) {a + b + c}`, `~ .x + .y`
- Optional typing: `add1 = function(n: int) { n + 1 }`
- Recursive modules: `library datetime as dt; library datetime.timezone as tz`
- Wrapped returns. The standard lib wraps most functions in a `foo!` variant with List return value. Containing a Symbol and a corresponding value.
- Elixir-like pattern matching: 
```
case File.read_csv!("data.csv") {
  {:ok, table} -> Log.info(f"Results: {table}")
  {:error, message} -> Log.error(f"Error: {message}")
}

Dataloader.read_csv("data.csv") # returns Table, raises exception if no such file exists.
```
- Everything you need to get rata applications to prod: json, http, develping APIs, database connectors, cloud SDKs
- 1-indexed.
- No scalars. Every "scalar" value is simply a single entry vector.
- Immutable by default. The standard lib avoids side-effects by design. Idiomatic rata-code has no mutations.
