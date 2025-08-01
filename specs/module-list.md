# Modules to be exposed in the Standard Lib.

Preferably most of this is implemented in Rata itself.

- [ ] Core: Basic functionalities of the language.
- [ ] Module: The code surrounding Module definition. 
- [ ] Math: Basic arithmetic and mathemetical functions e.g. +, -, /, power, square, cube, factorial, exponential, log, etc.
- [ ] Stat: Basic statistic functions e.g. mean, sd, rnorm, runif, rdunif, etc
- [ ] Table: All logic surrounding columnar data. Much of the same API as dplyr. At implementation level, it's basically a wrapper around Elixir's explorer.
- [ ] Maps: ditto for Maps.
- [ ] List: Self-explanatory
- [ ] Vector: You guessed it
- [ ] Enum: Generics for Lists and Vectors. The basic functional programming toolkit for iterating over a sequence of stuff. Map, Reduce, Keep, Discard, Every, Some, None.
- [ ] File: File system abstractions. Including reading and writing to files.
- [ ] Dataload: Utilities to read data from most used file formats like csv, xls, txt, delimited data, dta, arrow, etc.
- [ ] Datetime: Pretty much the same api as R's lubridate.
- [ ] Process: Wrapper around elixir's process module.
- [ ] Tests: Wrapper around Elixir's test tooling.
- [ ] Json: json toolkit.
- [ ] Macro: A macro programming toolkit.
- [ ] Struct: Wrapper around Elixir's Struct functionality.
- [ ] Dabber: A wrapper around Ecto. Exposes 4 submodules: Repo, Schema, Query, Changeset.
- [ ] Log: A logging toolkit.

 
