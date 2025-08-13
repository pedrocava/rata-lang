#import "lib/rata_docs/templates/all_modules.typ": all_modules_doc

#let modules_data = (
  (
    name: "Core",
    module_doc: "Core module for the Rata programming language.  Provides basic language primitives and core functionality following Rata's design principles: - All values are vectors (no scalars) - 1-indexed arrays - Immutable by default - Data-first philosophy",
    functions: (
  (
    name: "assert",
    args: ("condition"),
    doc: "Assert function - verifies that a condition is true. Throws an error if the condition is false or falsy."
  ),
    (
    name: "assert",
    args: ("condition", "message"),
    doc: "Assert function with custom message. Throws an error with the provided message if condition is falsy."
  ),
    (
    name: "identity",
    args: ("value"),
    doc: "Identity function - returns its argument unchanged. Useful for testing and as a placeholder."
  ),
    (
    name: "typeof",
    args: ("arg"),
    doc: "Type checking function - returns the type of a value as an atom."
  ),
    (
    name: "when",
    args: ("typeof", "arg"),
    doc: ""
  ),
    (
    name: "when",
    args: ("typeof", "arg"),
    doc: ""
  ),
    (
    name: "when",
    args: ("typeof", "arg"),
    doc: ""
  ),
    (
    name: "when",
    args: ("typeof", "is_binary"),
    doc: ""
  ),
    (
    name: "when",
    args: ("typeof", "is_atom"),
    doc: ""
  ),
    (
    name: "when",
    args: ("typeof", "arg"),
    doc: ""
  ),
    (
    name: "when",
    args: ("typeof", "arg"),
    doc: ""
  ),
    (
    name: "when",
    args: ("typeof", "and"),
    doc: ""
  ),
    (
    name: "typeof",
    args: ("%"),
    doc: ""
  ),
    (
    name: "typeof",
    args: ("%"),
    doc: ""
  ),
    (
    name: "typeof",
    args: ("_"),
    doc: ""
  ),
    (
    name: "debug",
    args: ("value"),
    doc: "Debug print function - prints a value and returns it unchanged. Useful for debugging pipelines."
  ),
    (
    name: "when",
    args: ("debug", "is_binary"),
    doc: "Debug print with custom label."
  ),
    (
    name: "debug",
    args: ("value", "label"),
    doc: ""
  ),
    (
    name: "when",
    args: ("exception", "is_atom"),
    doc: "Create a new exception with the given type."
  ),
    (
    name: "when",
    args: ("exception", "is_binary"),
    doc: ""
  ),
    (
    name: "when",
    args: ("exception", "is_atom"),
    doc: "Create a new exception with type and message."
  ),
    (
    name: "when",
    args: ("exception", "is_binary"),
    doc: ""
  ),
    (
    name: "runtime_error",
    args: ("message"),
    doc: "Create a RuntimeError exception (most common type)."
  ),
    (
    name: "argument_error",
    args: ("message"),
    doc: "Create an ArgumentError exception."
  ),
    (
    name: "type_error",
    args: ("message"),
    doc: "Create a TypeError exception."
  ),
    (
    name: "value_error",
    args: ("message"),
    doc: "Create a ValueError exception."
  ),
    (
    name: "exception_type",
    args: ("%{}"),
    doc: "Get the exception type from an exception."
  ),
    (
    name: "exception_type",
    args: ("_"),
    doc: ""
  ),
    (
    name: "exception_message",
    args: ("%{}"),
    doc: "Get the message from an exception."
  ),
    (
    name: "exception_message",
    args: ("_"),
    doc: ""
  ),
    (
    name: "is_exception",
    args: ("%{}"),
    doc: "Check if a value is an exception."
  ),
    (
    name: "is_exception",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_list", "arg"),
    doc: "Check if a value is a list."
  ),
    (
    name: "is_list",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_vector", "arg"),
    doc: "Check if a value is a vector (same as list in Rata)."
  ),
    (
    name: "is_vector",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_map", "and"),
    doc: "Check if a value is a map."
  ),
    (
    name: "is_map",
    args: ("_"),
    doc: ""
  ),
    (
    name: "is_table",
    args: ("_"),
    doc: "Check if a value is a table (Explorer DataFrame)."
  ),
    (
    name: "when",
    args: ("is_boolean", "arg"),
    doc: "Check if a value is a boolean."
  ),
    (
    name: "is_boolean",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_integer", "arg"),
    doc: "Check if a value is an integer."
  ),
    (
    name: "is_integer",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_float", "arg"),
    doc: "Check if a value is a float."
  ),
    (
    name: "is_float",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_number", "arg"),
    doc: "Check if a value is a number (integer or float)."
  ),
    (
    name: "is_number",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_string", "is_binary"),
    doc: "Check if a value is a string."
  ),
    (
    name: "is_string",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_symbol", "is_atom"),
    doc: "Check if a value is a symbol (atom)."
  ),
    (
    name: "is_symbol",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_tuple", "arg"),
    doc: "Check if a value is a tuple."
  ),
    (
    name: "is_tuple",
    args: ("_"),
    doc: ""
  ),
    (
    name: "is_set",
    args: ("%"),
    doc: "Check if a value is a set."
  ),
    (
    name: "is_set",
    args: ("_"),
    doc: ""
  ),
    (
    name: "is_range",
    args: ("%"),
    doc: "Check if a value is a range."
  ),
    (
    name: "is_range",
    args: ("_"),
    doc: ""
  ),
    (
    name: "is_nil",
    args: ("arg"),
    doc: "Check if a value is nil."
  ),
    (
    name: "is_nil",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_function", "arg"),
    doc: "Check if a value is a function."
  ),
    (
    name: "is_function",
    args: ("_"),
    doc: ""
  ),
    (
    name: "is_truthy",
    args: ("value"),
    doc: "Check if a value is truthy according to Rata's truthiness rules. Public version of the truthiness evaluation."
  )
)
  ),
  (
    name: "Datetime",
    module_doc: "Datetime module for the Rata programming language, mirroring R's lubridate API.  Provides comprehensive date and time parsing, manipulation, and formatting functions  following Rata's design principles: - All values are vectors (no scalars) - 1-indexed arrays where applicable - Immutable by default - Data-first philosophy - Dual function pattern: `foo()` returns direct results or raises, `foo!()` returns tuples  This module leverages Elixir's robust datetime libraries (DateTime, Date, Time, NaiveDateTime) while providing an R-like interface familiar to data engineering workflows.  ## Function Convention  Each operation comes in two variants: - `function_name/arity` - Returns direct results, raises exceptions on errors - `function_name!/arity` - Returns `{:ok, result}` or `{:error, reason}` tuples  ## Examples      # Unwrapped version (raises on error)     date = Datetime.ymd(\\"2024-01-15\\")     year_val = Datetime.year(date)          # Wrapped version (safe error handling)     case Datetime.ymd!(\\"2024-01-15\\") do       {:ok, date} -> Log.info(\\"Parsed: #{date}\\")       {:error, message} -> Log.error(\\"Failed: #{message}\\")     end",
    functions: (
  (
    name: "when",
    args: ("ymd", "is_binary"),
    doc: "Parse date string in Year-Month-Day format (unwrapped version - raises on error).  Accepts various separators: \\"-\\", \\"/\\", \\".\\", or no separator.  ## Examples      iex> Datetime.ymd(\\"2024-01-15\\")     ~D[2024-01-15]          iex> Datetime.ymd(\\"2024/01/15\\")     ~D[2024-01-15]          iex> Datetime.ymd(\\"20240115\\")     ~D[2024-01-15]"
  ),
    (
    name: "when",
    args: ("ymd", "is_list"),
    doc: ""
  ),
    (
    name: "ymd",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("ymd!", "is_binary"),
    doc: "Parse date string in Year-Month-Day format (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> Datetime.ymd!(\\"2024-01-15\\")     {:ok, ~D[2024-01-15]}          iex> Datetime.ymd!(\\"invalid\\")     {:error, \\"Invalid date format\\"}"
  ),
    (
    name: "when",
    args: ("ymd!", "is_list"),
    doc: ""
  ),
    (
    name: "ymd!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dmy", "is_binary"),
    doc: "Parse date string in Day-Month-Year format (unwrapped version - raises on error).  ## Examples      iex> Datetime.dmy(\\"15-01-2024\\")     ~D[2024-01-15]          iex> Datetime.dmy(\\"15/01/2024\\")     ~D[2024-01-15]"
  ),
    (
    name: "when",
    args: ("dmy", "is_list"),
    doc: ""
  ),
    (
    name: "dmy",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dmy!", "is_binary"),
    doc: "Parse date string in Day-Month-Year format (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "when",
    args: ("dmy!", "is_list"),
    doc: ""
  ),
    (
    name: "dmy!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("mdy", "is_binary"),
    doc: "Parse date string in Month-Day-Year format (unwrapped version - raises on error).  ## Examples      iex> Datetime.mdy(\\"01-15-2024\\")     ~D[2024-01-15]          iex> Datetime.mdy(\\"01/15/2024\\")     ~D[2024-01-15]"
  ),
    (
    name: "when",
    args: ("mdy", "is_list"),
    doc: ""
  ),
    (
    name: "mdy",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("mdy!", "is_binary"),
    doc: "Parse date string in Month-Day-Year format (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "when",
    args: ("mdy!", "is_list"),
    doc: ""
  ),
    (
    name: "mdy!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("ymd_hms", "is_binary"),
    doc: "Parse datetime string in Year-Month-Day Hour:Minute:Second format (unwrapped version - raises on error).  ## Examples      iex> Datetime.ymd_hms(\\"2024-01-15 14:30:25\\")     ~U[2024-01-15 14:30:25Z]          iex> Datetime.ymd_hms(\\"2024-01-15T14:30:25\\")     ~U[2024-01-15 14:30:25Z]"
  ),
    (
    name: "when",
    args: ("ymd_hms", "is_list"),
    doc: ""
  ),
    (
    name: "ymd_hms",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("ymd_hms!", "is_binary"),
    doc: "Parse datetime string in Year-Month-Day Hour:Minute:Second format (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "when",
    args: ("ymd_hms!", "is_list"),
    doc: ""
  ),
    (
    name: "ymd_hms!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "year",
    args: ("%"),
    doc: "Extract year from date/datetime (unwrapped version - raises on error).  ## Examples      iex> Datetime.year(~D[2024-01-15])     2024          iex> Datetime.year(~U[2024-01-15 14:30:25Z])     2024"
  ),
    (
    name: "year",
    args: ("%"),
    doc: ""
  ),
    (
    name: "year",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("year", "is_list"),
    doc: ""
  ),
    (
    name: "year",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "year!",
    args: ("%"),
    doc: "Extract year from date/datetime (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "year!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "year!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("year!", "is_list"),
    doc: ""
  ),
    (
    name: "year!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "month",
    args: ("%"),
    doc: "Extract month from date/datetime (unwrapped version - raises on error). Returns 1-indexed month (1 = January, 12 = December).  ## Examples      iex> Datetime.month(~D[2024-01-15])     1          iex> Datetime.month(~U[2024-12-15 14:30:25Z])     12"
  ),
    (
    name: "month",
    args: ("%"),
    doc: ""
  ),
    (
    name: "month",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("month", "is_list"),
    doc: ""
  ),
    (
    name: "month",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "month!",
    args: ("%"),
    doc: "Extract month from date/datetime (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "month!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "month!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("month!", "is_list"),
    doc: ""
  ),
    (
    name: "month!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "day",
    args: ("%"),
    doc: "Extract day of month from date/datetime (unwrapped version - raises on error).  ## Examples      iex> Datetime.day(~D[2024-01-15])     15          iex> Datetime.day(~U[2024-01-25 14:30:25Z])     25"
  ),
    (
    name: "day",
    args: ("%"),
    doc: ""
  ),
    (
    name: "day",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("day", "is_list"),
    doc: ""
  ),
    (
    name: "day",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "day!",
    args: ("%"),
    doc: "Extract day of month from date/datetime (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "day!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "day!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("day!", "is_list"),
    doc: ""
  ),
    (
    name: "day!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("wday", "or"),
    doc: "Extract day of week from date/datetime (unwrapped version - raises on error). Returns 1-indexed day of week (1 = Sunday, 7 = Saturday), following R conventions.  ## Examples      iex> Datetime.wday(~D[2024-01-15])  # Monday     2          iex> Datetime.wday(~D[2024-01-14])  # Sunday     1"
  ),
    (
    name: "when",
    args: ("wday", "is_list"),
    doc: ""
  ),
    (
    name: "wday",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("wday!", "or"),
    doc: "Extract day of week from date/datetime (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "when",
    args: ("wday!", "is_list"),
    doc: ""
  ),
    (
    name: "wday!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "hour",
    args: ("%"),
    doc: "Extract hour from datetime (unwrapped version - raises on error).  ## Examples      iex> Datetime.hour(~U[2024-01-15 14:30:25Z])     14          iex> Datetime.hour(~N[2024-01-15 09:15:30])     9"
  ),
    (
    name: "hour",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("hour", "is_list"),
    doc: ""
  ),
    (
    name: "hour",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "hour!",
    args: ("%"),
    doc: "Extract hour from datetime (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "hour!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("hour!", "is_list"),
    doc: ""
  ),
    (
    name: "hour!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "minute",
    args: ("%"),
    doc: "Extract minute from datetime (unwrapped version - raises on error).  ## Examples      iex> Datetime.minute(~U[2024-01-15 14:30:25Z])     30"
  ),
    (
    name: "minute",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("minute", "is_list"),
    doc: ""
  ),
    (
    name: "minute",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "minute!",
    args: ("%"),
    doc: "Extract minute from datetime (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "minute!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("minute!", "is_list"),
    doc: ""
  ),
    (
    name: "minute!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "second",
    args: ("%"),
    doc: "Extract second from datetime (unwrapped version - raises on error).  ## Examples      iex> Datetime.second(~U[2024-01-15 14:30:25Z])     25"
  ),
    (
    name: "second",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("second", "is_list"),
    doc: ""
  ),
    (
    name: "second",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "second!",
    args: ("%"),
    doc: "Extract second from datetime (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "second!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("second!", "is_list"),
    doc: ""
  ),
    (
    name: "second!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "now",
    args: (),
    doc: "Get current UTC datetime (unwrapped version - raises on error).  ## Examples      iex> Datetime.now()     ~U[2024-01-15 14:30:25.123456Z]"
  ),
    (
    name: "now!",
    args: (),
    doc: "Get current UTC datetime (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "today",
    args: (),
    doc: "Get current date (unwrapped version - raises on error).  ## Examples      iex> Datetime.today()     ~D[2024-01-15]"
  ),
    (
    name: "today!",
    args: (),
    doc: "Get current date (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "when",
    args: ("leap_year", "is_integer"),
    doc: "Check if a year is a leap year (unwrapped version - raises on error).  ## Examples      iex> Datetime.leap_year(2024)     true          iex> Datetime.leap_year(2023)     false          iex> Datetime.leap_year([2020, 2021, 2022, 2023, 2024])     [true, false, false, false, true]"
  ),
    (
    name: "when",
    args: ("leap_year", "is_list"),
    doc: ""
  ),
    (
    name: "leap_year",
    args: ("%"),
    doc: ""
  ),
    (
    name: "leap_year",
    args: ("%"),
    doc: ""
  ),
    (
    name: "leap_year",
    args: ("%"),
    doc: ""
  ),
    (
    name: "leap_year",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("leap_year!", "is_integer"),
    doc: "Check if a year is a leap year (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "when",
    args: ("leap_year!", "is_list"),
    doc: ""
  ),
    (
    name: "leap_year!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "leap_year!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "leap_year!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "leap_year!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("days_in_month", "and"),
    doc: "Get number of days in a given month (unwrapped version - raises on error).  ## Examples      iex> Datetime.days_in_month(2024, 2)     29          iex> Datetime.days_in_month(2023, 2)      28          iex> Datetime.days_in_month(2024, 4)     30"
  ),
    (
    name: "days_in_month",
    args: ("%"),
    doc: ""
  ),
    (
    name: "days_in_month",
    args: ("%"),
    doc: ""
  ),
    (
    name: "days_in_month",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("days_in_month", "is_integer"),
    doc: ""
  ),
    (
    name: "days_in_month",
    args: ("year", "month"),
    doc: ""
  ),
    (
    name: "when",
    args: ("days_in_month!", "and"),
    doc: "Get number of days in a given month (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "days_in_month!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "days_in_month!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "days_in_month!",
    args: ("%"),
    doc: ""
  ),
    (
    name: "when",
    args: ("days_in_month!", "is_integer"),
    doc: ""
  ),
    (
    name: "days_in_month!",
    args: ("year", "month"),
    doc: ""
  ),
    (
    name: "when",
    args: ("with_tz", "is_binary"),
    doc: "Convert datetime to a different timezone (unwrapped version - raises on error).  ## Examples      iex> utc_dt = ~U[2024-01-15 14:30:25Z]     iex> Datetime.with_tz(utc_dt, \\"America/New_York\\")     # Returns datetime in Eastern timezone"
  ),
    (
    name: "when",
    args: ("with_tz", "and"),
    doc: ""
  ),
    (
    name: "with_tz",
    args: ("datetime", "timezone"),
    doc: ""
  ),
    (
    name: "when",
    args: ("with_tz!", "is_binary"),
    doc: "Convert datetime to a different timezone (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "when",
    args: ("with_tz!", "and"),
    doc: ""
  ),
    (
    name: "with_tz!",
    args: ("datetime", "timezone"),
    doc: ""
  ),
    (
    name: "when",
    args: ("force_tz", "is_binary"),
    doc: "Change the timezone designation without converting the time (unwrapped version - raises on error).  ## Examples      iex> naive_dt = ~N[2024-01-15 14:30:25]     iex> Datetime.force_tz(naive_dt, \\"America/New_York\\")     # Returns datetime with EST timezone applied"
  ),
    (
    name: "when",
    args: ("force_tz", "and"),
    doc: ""
  ),
    (
    name: "force_tz",
    args: ("datetime", "timezone"),
    doc: ""
  ),
    (
    name: "when",
    args: ("force_tz!", "is_binary"),
    doc: "Change the timezone designation without converting the time (wrapped version - returns {:ok, result} or {:error, reason})."
  ),
    (
    name: "when",
    args: ("force_tz!", "and"),
    doc: ""
  ),
    (
    name: "force_tz!",
    args: ("datetime", "timezone"),
    doc: ""
  ),
    (
    name: "is_leap_year",
    args: ("year"),
    doc: "Alias for leap_year/1. Check if a year is a leap year."
  ),
    (
    name: "is_leap_year!",
    args: ("year"),
    doc: "Alias for leap_year!/1. Check if a year is a leap year (wrapped version)."
  )
)
  ),
  (
    name: "Enum",
    module_doc: "Enum module for the Rata programming language.  Provides the basic functional programming toolkit for iterating over sequences. Generics for Lists and Vectors following Rata's design principles: - All values are vectors (no scalars) - 1-indexed arrays - Immutable by default - Data-first philosophy  Functions include: Map, Reduce, Keep, Discard, Every, Some, None, Find.",
    functions: (
  (
    name: "when",
    args: ("map", "and"),
    doc: "Transforms each element in the enumerable using the given function. Returns a new collection with the transformed elements.  ## Examples     iex> Enum.map([1, 2, 3], fn x -> x * 2 end)     {:ok, [2, 4, 6]}"
  ),
    (
    name: "when",
    args: ("map", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("map", "not"),
    doc: ""
  ),
    (
    name: "reduce",
    args: ("arg", "_function"),
    doc: "Reduces the enumerable to a single value using the given function. The function should accept two arguments and return a single value. Uses the first element as the initial accumulator.  ## Examples     iex> Enum.reduce([1, 2, 3, 4], fn x, y -> x + y end)     {:ok, 10}"
  ),
    (
    name: "when",
    args: ("reduce", "is_function"),
    doc: ""
  ),
    (
    name: "when",
    args: ("reduce", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("reduce", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("keep", "and"),
    doc: "Keeps elements for which the predicate function returns a truthy value.  ## Examples     iex> Enum.keep([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)     {:ok, [2, 4]}"
  ),
    (
    name: "when",
    args: ("keep", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("keep", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("discard", "and"),
    doc: "Discards elements for which the predicate function returns a truthy value. Opposite of keep - removes elements that match the predicate.  ## Examples     iex> Enum.discard([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)     {:ok, [1, 3]}"
  ),
    (
    name: "when",
    args: ("discard", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("discard", "not"),
    doc: ""
  ),
    (
    name: "every",
    args: ("arg", "_predicate"),
    doc: "Returns true if all elements in the enumerable satisfy the predicate function. Returns false if any element fails the predicate or if the collection is empty.  ## Examples     iex> Enum.every([2, 4, 6], fn x -> rem(x, 2) == 0 end)     {:ok, true}          iex> Enum.every([1, 2, 3], fn x -> rem(x, 2) == 0 end)     {:ok, false}"
  ),
    (
    name: "when",
    args: ("every", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("every", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("every", "not"),
    doc: ""
  ),
    (
    name: "some",
    args: ("arg", "_predicate"),
    doc: "Returns true if any element in the enumerable satisfies the predicate function. Returns false if no elements satisfy the predicate or if the collection is empty.  ## Examples     iex> Enum.some([1, 2, 3], fn x -> rem(x, 2) == 0 end)     {:ok, true}          iex> Enum.some([1, 3, 5], fn x -> rem(x, 2) == 0 end)      {:ok, false}"
  ),
    (
    name: "when",
    args: ("some", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("some", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("some", "not"),
    doc: ""
  ),
    (
    name: "none",
    args: ("arg", "_predicate"),
    doc: "Returns true if no elements in the enumerable satisfy the predicate function. Returns true if all elements fail the predicate or if the collection is empty.  ## Examples     iex> Enum.none([1, 3, 5], fn x -> rem(x, 2) == 0 end)     {:ok, true}          iex> Enum.none([1, 2, 3], fn x -> rem(x, 2) == 0 end)     {:ok, false}"
  ),
    (
    name: "when",
    args: ("none", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("none", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("none", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("find", "and"),
    doc: "Finds the first element in the enumerable for which the predicate function returns a truthy value. Returns nil if no element satisfies the predicate.  ## Examples     iex> Enum.find([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end)     {:ok, 2}          iex> Enum.find([1, 3, 5], fn x -> rem(x, 2) == 0 end)     {:ok, nil}"
  ),
    (
    name: "when",
    args: ("find", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("find", "not"),
    doc: ""
  )
)
  ),
  (
    name: "File",
    module_doc: "File system operations for Rata, inspired by R's fs package.  This module provides cross-platform file system operations following Rata's design principles: - All values are vectors (no scalars) - Functions with `!` suffix return wrapped results: {:ok, result} or {:error, message} - Functions without `!` suffix return unwrapped results or raise exceptions - Immutable by default - Data-first philosophy - Vectorized operations (accepts lists of paths)  All path operations handle UTF-8 encoding and work consistently across platforms.  ## Function Convention  Each operation comes in two variants: - `function_name/arity` - Returns direct results, raises exceptions on errors - `function_name!/arity` - Returns `{:ok, result}` or `{:error, reason}` tuples  ## Examples      # Unwrapped version (raises on error)     path = File.file_create(\\"/tmp/example.txt\\")     content = File.file_read(\\"/tmp/example.txt\\")      # Wrapped version (safe error handling)     case File.file_create!(\\"/tmp/example.txt\\") do       {:ok, path} -> Log.info(\\"Created: #{path}\\")       {:error, message} -> Log.error(\\"Failed: #{message}\\")     end",
    functions: (
  (
    name: "when",
    args: ("file_create", "is_binary"),
    doc: "Create a new file (unwrapped version - raises on error).  ## Examples      iex> File.file_create(\\"/path/to/file.txt\\")     \\"/path/to/file.txt\\"      iex> File.file_create([\\"/path/to/file1.txt\\", \\"/path/to/file2.txt\\"])     [\\"/path/to/file1.txt\\", \\"/path/to/file2.txt\\"]"
  ),
    (
    name: "when",
    args: ("file_create", "is_list"),
    doc: ""
  ),
    (
    name: "file_create",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_create!", "is_binary"),
    doc: "Create a new file (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_create!(\\"/path/to/file.txt\\")     {:ok, \\"/path/to/file.txt\\"}      iex> File.file_create!([\\"/path/to/file1.txt\\", \\"/path/to/file2.txt\\"])     {:ok, [\\"/path/to/file1.txt\\", \\"/path/to/file2.txt\\"]}      iex> File.file_create!(\\"/invalid/path/file.txt\\")     {:error, \\"Failed to create file: /invalid/path/file.txt\\"}"
  ),
    (
    name: "when",
    args: ("file_create!", "is_list"),
    doc: ""
  ),
    (
    name: "file_create!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_delete", "is_binary"),
    doc: "Delete a file (unwrapped version - raises on error).  ## Examples      iex> File.file_delete(\\"/path/to/file.txt\\")     \\"/path/to/file.txt\\"      iex> File.file_delete([\\"/path/to/file1.txt\\", \\"/path/to/file2.txt\\"])     [\\"/path/to/file1.txt\\", \\"/path/to/file2.txt\\"]"
  ),
    (
    name: "when",
    args: ("file_delete", "is_list"),
    doc: ""
  ),
    (
    name: "file_delete",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_delete!", "is_binary"),
    doc: "Delete a file (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_delete!(\\"/path/to/file.txt\\")     {:ok, \\"/path/to/file.txt\\"}      iex> File.file_delete!([\\"/path/to/file1.txt\\", \\"/path/to/file2.txt\\"])     {:ok, [\\"/path/to/file1.txt\\", \\"/path/to/file2.txt\\"]}"
  ),
    (
    name: "when",
    args: ("file_delete!", "is_list"),
    doc: ""
  ),
    (
    name: "file_delete!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_copy", "and"),
    doc: "Copy a file from source to destination (unwrapped version - raises on error).  ## Examples      iex> File.file_copy(\\"/source.txt\\", \\"/destination.txt\\")     \\"/destination.txt\\""
  ),
    (
    name: "file_copy",
    args: ("source", "destination"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_copy!", "and"),
    doc: "Copy a file from source to destination (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_copy!(\\"/source.txt\\", \\"/destination.txt\\")     {:ok, \\"/destination.txt\\"}"
  ),
    (
    name: "file_copy!",
    args: ("source", "destination"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_move", "and"),
    doc: "Move (rename) a file from source to destination (unwrapped version - raises on error).  ## Examples      iex> File.file_move(\\"/old.txt\\", \\"/new.txt\\")     \\"/new.txt\\""
  ),
    (
    name: "file_move",
    args: ("source", "destination"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_move!", "and"),
    doc: "Move (rename) a file from source to destination (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_move!(\\"/old.txt\\", \\"/new.txt\\")     {:ok, \\"/new.txt\\"}"
  ),
    (
    name: "file_move!",
    args: ("source", "destination"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_exists", "is_binary"),
    doc: "Check if a file exists (unwrapped version - raises on error).  ## Examples      iex> File.file_exists(\\"/existing/file.txt\\")     true      iex> File.file_exists(\\"/nonexistent/file.txt\\")     false      iex> File.file_exists([\\"/file1.txt\\", \\"/file2.txt\\"])     [true, false]"
  ),
    (
    name: "when",
    args: ("file_exists", "is_list"),
    doc: ""
  ),
    (
    name: "file_exists",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_exists!", "is_binary"),
    doc: "Check if a file exists (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_exists!(\\"/existing/file.txt\\")     {:ok, true}      iex> File.file_exists!(\\"/nonexistent/file.txt\\")     {:ok, false}      iex> File.file_exists!([\\"/file1.txt\\", \\"/file2.txt\\"])     {:ok, [true, false]}"
  ),
    (
    name: "when",
    args: ("file_exists!", "is_list"),
    doc: ""
  ),
    (
    name: "file_exists!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_info", "is_binary"),
    doc: "Get file information (unwrapped version - raises on error).  ## Examples      iex> File.file_info(\\"/path/to/file.txt\\")     %{size: 1024, type: :regular, access: :read_write, ...}"
  ),
    (
    name: "when",
    args: ("file_info", "is_list"),
    doc: ""
  ),
    (
    name: "file_info",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_info!", "is_binary"),
    doc: "Get file information (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_info!(\\"/path/to/file.txt\\")     {:ok, %{size: 1024, type: :regular, access: :read_write, ...}}"
  ),
    (
    name: "when",
    args: ("file_info!", "is_list"),
    doc: ""
  ),
    (
    name: "file_info!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_read", "is_binary"),
    doc: "Read the contents of a file (unwrapped version - raises on error).  ## Examples      iex> File.file_read(\\"/path/to/file.txt\\")     \\"file contents\\""
  ),
    (
    name: "when",
    args: ("file_read", "is_list"),
    doc: ""
  ),
    (
    name: "file_read",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_read!", "is_binary"),
    doc: "Read the contents of a file (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_read!(\\"/path/to/file.txt\\")     {:ok, \\"file contents\\"}"
  ),
    (
    name: "when",
    args: ("file_read!", "is_list"),
    doc: ""
  ),
    (
    name: "file_read!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_write", "and"),
    doc: "Write content to a file (unwrapped version - raises on error).  ## Examples      iex> File.file_write(\\"/path/to/file.txt\\", \\"hello world\\")     \\"/path/to/file.txt\\""
  ),
    (
    name: "file_write",
    args: ("path", "content"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_write!", "and"),
    doc: "Write content to a file (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_write!(\\"/path/to/file.txt\\", \\"hello world\\")     {:ok, \\"/path/to/file.txt\\"}"
  ),
    (
    name: "file_write!",
    args: ("path", "content"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_touch", "is_binary"),
    doc: "Update file timestamps (touch) (unwrapped version - raises on error).  ## Examples      iex> File.file_touch(\\"/path/to/file.txt\\")     \\"/path/to/file.txt\\""
  ),
    (
    name: "when",
    args: ("file_touch", "is_list"),
    doc: ""
  ),
    (
    name: "file_touch",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("file_touch!", "is_binary"),
    doc: "Update file timestamps (touch) (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.file_touch!(\\"/path/to/file.txt\\")     {:ok, \\"/path/to/file.txt\\"}"
  ),
    (
    name: "when",
    args: ("file_touch!", "is_list"),
    doc: ""
  ),
    (
    name: "file_touch!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dir_create", "is_binary"),
    doc: "Create a directory (unwrapped version - raises on error).  ## Examples      iex> File.dir_create(\\"/path/to/dir\\")     \\"/path/to/dir\\"      iex> File.dir_create([\\"/path/to/dir1\\", \\"/path/to/dir2\\"])     [\\"/path/to/dir1\\", \\"/path/to/dir2\\"]"
  ),
    (
    name: "when",
    args: ("dir_create", "is_list"),
    doc: ""
  ),
    (
    name: "dir_create",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dir_create!", "is_binary"),
    doc: "Create a directory (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.dir_create!(\\"/path/to/dir\\")     {:ok, \\"/path/to/dir\\"}      iex> File.dir_create!([\\"/path/to/dir1\\", \\"/path/to/dir2\\"])     {:ok, [\\"/path/to/dir1\\", \\"/path/to/dir2\\"]}"
  ),
    (
    name: "when",
    args: ("dir_create!", "is_list"),
    doc: ""
  ),
    (
    name: "dir_create!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dir_delete", "is_binary"),
    doc: "Delete a directory and its contents (unwrapped version - raises on error).  ## Examples      iex> File.dir_delete(\\"/path/to/dir\\")     \\"/path/to/dir\\""
  ),
    (
    name: "when",
    args: ("dir_delete", "is_list"),
    doc: ""
  ),
    (
    name: "dir_delete",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dir_delete!", "is_binary"),
    doc: "Delete a directory and its contents (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.dir_delete!(\\"/path/to/dir\\")     {:ok, \\"/path/to/dir\\"}"
  ),
    (
    name: "when",
    args: ("dir_delete!", "is_list"),
    doc: ""
  ),
    (
    name: "dir_delete!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dir_ls", "is_binary"),
    doc: "List directory contents (unwrapped version - raises on error).  ## Examples      iex> File.dir_ls(\\"/path/to/dir\\")     [\\"/path/to/dir/file1.txt\\", \\"/path/to/dir/file2.txt\\"]"
  ),
    (
    name: "when",
    args: ("dir_ls", "is_list"),
    doc: ""
  ),
    (
    name: "dir_ls",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dir_ls!", "is_binary"),
    doc: "List directory contents (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.dir_ls!(\\"/path/to/dir\\")     {:ok, [\\"/path/to/dir/file1.txt\\", \\"/path/to/dir/file2.txt\\"]}"
  ),
    (
    name: "when",
    args: ("dir_ls!", "is_list"),
    doc: ""
  ),
    (
    name: "dir_ls!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dir_exists", "is_binary"),
    doc: "Check if a directory exists (unwrapped version - raises on error).  ## Examples      iex> File.dir_exists(\\"/existing/dir\\")     true      iex> File.dir_exists(\\"/nonexistent/dir\\")     false"
  ),
    (
    name: "when",
    args: ("dir_exists", "is_list"),
    doc: ""
  ),
    (
    name: "dir_exists",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("dir_exists!", "is_binary"),
    doc: "Check if a directory exists (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.dir_exists!(\\"/existing/dir\\")     {:ok, true}      iex> File.dir_exists!(\\"/nonexistent/dir\\")     {:ok, false}"
  ),
    (
    name: "when",
    args: ("dir_exists!", "is_list"),
    doc: ""
  ),
    (
    name: "dir_exists!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_join", "and"),
    doc: "Join path components into a single path (unwrapped version - raises on error).  ## Examples      iex> File.path_join([\\"home\\", \\"user\\", \\"documents\\"])     \\"home/user/documents\\""
  ),
    (
    name: "path_join",
    args: ("arg"),
    doc: ""
  ),
    (
    name: "path_join",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_join!", "and"),
    doc: "Join path components into a single path (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.path_join!([\\"home\\", \\"user\\", \\"documents\\"])     {:ok, \\"home/user/documents\\"}      iex> File.path_join!([])     {:error, \\"File.path_join! requires a non-empty list of path components\\"}"
  ),
    (
    name: "path_join!",
    args: ("arg"),
    doc: ""
  ),
    (
    name: "path_join!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_expand", "is_binary"),
    doc: "Expand home directory paths (unwrapped version - raises on error).  ## Examples      iex> File.path_expand(\\"~/documents\\")     \\"/home/user/documents\\""
  ),
    (
    name: "when",
    args: ("path_expand", "is_list"),
    doc: ""
  ),
    (
    name: "path_expand",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_expand!", "is_binary"),
    doc: "Expand home directory paths (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.path_expand!(\\"~/documents\\")     {:ok, \\"/home/user/documents\\"}"
  ),
    (
    name: "when",
    args: ("path_expand!", "is_list"),
    doc: ""
  ),
    (
    name: "path_expand!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_dirname", "is_binary"),
    doc: "Extract directory name from path (unwrapped version - raises on error).  ## Examples      iex> File.path_dirname(\\"/home/user/file.txt\\")     \\"/home/user\\""
  ),
    (
    name: "when",
    args: ("path_dirname", "is_list"),
    doc: ""
  ),
    (
    name: "path_dirname",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_dirname!", "is_binary"),
    doc: "Extract directory name from path (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.path_dirname!(\\"/home/user/file.txt\\")     {:ok, \\"/home/user\\"}"
  ),
    (
    name: "when",
    args: ("path_dirname!", "is_list"),
    doc: ""
  ),
    (
    name: "path_dirname!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_basename", "is_binary"),
    doc: "Extract file name from path (unwrapped version - raises on error).  ## Examples      iex> File.path_basename(\\"/home/user/file.txt\\")     \\"file.txt\\""
  ),
    (
    name: "when",
    args: ("path_basename", "is_list"),
    doc: ""
  ),
    (
    name: "path_basename",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_basename!", "is_binary"),
    doc: "Extract file name from path (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.path_basename!(\\"/home/user/file.txt\\")     {:ok, \\"file.txt\\"}"
  ),
    (
    name: "when",
    args: ("path_basename!", "is_list"),
    doc: ""
  ),
    (
    name: "path_basename!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_extname", "is_binary"),
    doc: "Extract file extension from path (unwrapped version - raises on error).  ## Examples      iex> File.path_extname(\\"/home/user/file.txt\\")     \\".txt\\""
  ),
    (
    name: "when",
    args: ("path_extname", "is_list"),
    doc: ""
  ),
    (
    name: "path_extname",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_extname!", "is_binary"),
    doc: "Extract file extension from path (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.path_extname!(\\"/home/user/file.txt\\")     {:ok, \\".txt\\"}"
  ),
    (
    name: "when",
    args: ("path_extname!", "is_list"),
    doc: ""
  ),
    (
    name: "path_extname!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_real", "is_binary"),
    doc: "Resolve path to absolute form (unwrapped version - raises on error).  ## Examples      iex> File.path_real(\\"../documents\\")     \\"/home/user/documents\\""
  ),
    (
    name: "when",
    args: ("path_real", "is_list"),
    doc: ""
  ),
    (
    name: "path_real",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("path_real!", "is_binary"),
    doc: "Resolve path to absolute form (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> File.path_real!(\\"../documents\\")     {:ok, \\"/home/user/documents\\"}"
  ),
    (
    name: "when",
    args: ("path_real!", "is_list"),
    doc: ""
  ),
    (
    name: "path_real!",
    args: ("invalid"),
    doc: ""
  )
)
  ),
  (
    name: "Json",
    module_doc: "JSON toolkit for the Rata programming language.  Provides JSON parsing, encoding, and validation following Rata's design principles: - All values are vectors (no scalars) - Functions with `!` suffix return wrapped results: {:ok, result} or {:error, message} - Functions without `!` suffix return unwrapped results or raise exceptions - Immutable by default - Data-first philosophy - Vectorized operations (accepts lists where applicable)  This module handles JSON operations for data engineering workflows, converting between Rata data structures (Maps, Lists, Vectors) and JSON strings.  ## Function Convention  Each operation comes in two variants: - `function_name/arity` - Returns direct results, raises exceptions on errors - `function_name!/arity` - Returns `{:ok, result}` or `{:error, reason}` tuples  Functions ending in `?` also have an `is_` prefixed alias: - `valid?/1` and `is_valid/1` - Check if string is valid JSON - `valid!/1` and `is_valid!/1` - Wrapped versions  ## Examples      # Parse JSON string     data = Json.parse(~s|{\\"name\\": \\"Alice\\", \\"age\\": 30}|)     # => %{\\"name\\" => \\"Alice\\", \\"age\\" => 30}          # Encode data to JSON     json = Json.encode(%{\\"name\\" => \\"Bob\\", \\"items\\" => [1, 2, 3]})     # => ~s|{\\"name\\":\\"Bob\\",\\"items\\":[1,2,3]}|          # Validate JSON     Json.valid?(~s|{\\"valid\\": true}|)  # => true     Json.is_valid(~s|{invalid}|)       # => false          # Wrapped versions for error handling     case Json.parse!(json_string) do       {:ok, data} -> process_data(data)       {:error, message} -> Log.error(\\"JSON parse failed: #{message}\\")     end",
    functions: (
  (
    name: "when",
    args: ("parse", "is_binary"),
    doc: "Parse a JSON string to Rata data structures (unwrapped version - raises on error).  Converts JSON objects to Maps, JSON arrays to Lists, and preserves JSON primitives.  ## Examples      iex> Json.parse(~s|{\\"name\\": \\"Alice\\", \\"age\\": 30}|)     %{\\"name\\" => \\"Alice\\", \\"age\\" => 30}          iex> Json.parse(~s|[1, 2, 3]|)     [1, 2, 3]          iex> Json.parse(~s|[\\"json1\\", \\"json2\\"]|)     [\\"json1\\", \\"json2\\"]"
  ),
    (
    name: "when",
    args: ("parse", "is_list"),
    doc: ""
  ),
    (
    name: "parse",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("parse!", "is_binary"),
    doc: "Parse a JSON string to Rata data structures (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> Json.parse!(~s|{\\"name\\": \\"Alice\\"}|)     {:ok, %{\\"name\\" => \\"Alice\\"}}          iex> Json.parse!(~s|{invalid}|)     {:error, \\"Failed to parse JSON: invalid syntax at position 1\\"}"
  ),
    (
    name: "when",
    args: ("parse!", "is_list"),
    doc: ""
  ),
    (
    name: "parse!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("parse_file", "is_binary"),
    doc: "Parse JSON from a file (unwrapped version - raises on error).  Reads the file and parses its JSON contents to Rata data structures.  ## Examples      iex> Json.parse_file(\\"/path/to/data.json\\")     %{\\"users\\" => [%{\\"name\\" => \\"Alice\\"}, %{\\"name\\" => \\"Bob\\"}]}          iex> Json.parse_file([\\"/file1.json\\", \\"/file2.json\\"])     [%{\\"data1\\" => \\"value1\\"}, %{\\"data2\\" => \\"value2\\"}]"
  ),
    (
    name: "when",
    args: ("parse_file", "is_list"),
    doc: ""
  ),
    (
    name: "parse_file",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("parse_file!", "is_binary"),
    doc: "Parse JSON from a file (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> Json.parse_file!(\\"/path/to/data.json\\")     {:ok, %{\\"users\\" => [%{\\"name\\" => \\"Alice\\"}]}}          iex> Json.parse_file!(\\"/nonexistent.json\\")     {:error, \\"Failed to read file /nonexistent.json: enoent\\"}"
  ),
    (
    name: "when",
    args: ("parse_file!", "is_list"),
    doc: ""
  ),
    (
    name: "parse_file!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("encode", "or"),
    doc: "Encode Rata data to JSON string (unwrapped version - raises on error).  Converts Rata Maps to JSON objects, Lists to JSON arrays, and preserves primitives. Uses compact formatting without indentation.  ## Examples      iex> Json.encode(%{\\"name\\" => \\"Alice\\", \\"age\\" => 30})     ~s|{\\"name\\":\\"Alice\\",\\"age\\":30}|          iex> Json.encode([1, 2, 3])     \\"[1,2,3]\\"          iex> Json.encode([%{\\"a\\" => 1}, %{\\"b\\" => 2}])     [~s|{\\"a\\":1}|, ~s|{\\"b\\":2}|]"
  ),
    (
    name: "when",
    args: ("encode", "is_list"),
    doc: ""
  ),
    (
    name: "encode",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("encode!", "or"),
    doc: "Encode Rata data to JSON string (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> Json.encode!(%{\\"name\\" => \\"Alice\\"})     {:ok, ~s|{\\"name\\":\\"Alice\\"}|}          iex> Json.encode!(:invalid_atom)     {:error, \\"Failed to encode to JSON: cannot encode atom\\"}"
  ),
    (
    name: "when",
    args: ("encode!", "is_list"),
    doc: ""
  ),
    (
    name: "encode!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("encode_pretty", "or"),
    doc: "Encode Rata data to pretty-formatted JSON string (unwrapped version - raises on error).  Same as encode/1 but with indentation and line breaks for readability.  ## Examples      iex> Json.encode_pretty(%{\\"name\\" => \\"Alice\\", \\"age\\" => 30})     ~s|{       \\"name\\": \\"Alice\\",       \\"age\\": 30     }|"
  ),
    (
    name: "when",
    args: ("encode_pretty", "is_list"),
    doc: ""
  ),
    (
    name: "encode_pretty",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("encode_pretty!", "or"),
    doc: "Encode Rata data to pretty-formatted JSON string (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> Json.encode_pretty!(%{\\"name\\" => \\"Alice\\"})     {:ok, ~s|{   \\"name\\": \\"Alice\\" }|}"
  ),
    (
    name: "when",
    args: ("encode_pretty!", "is_list"),
    doc: ""
  ),
    (
    name: "encode_pretty!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "when",
    args: ("write_file", "is_binary"),
    doc: "Write JSON data to a file (unwrapped version - raises on error).  Encodes the data to JSON and writes it to the specified file path.  ## Examples      iex> Json.write_file(%{\\"users\\" => [\\"Alice\\", \\"Bob\\"]}, \\"/path/to/output.json\\")     \\"/path/to/output.json\\""
  ),
    (
    name: "write_file",
    args: ("data", "file_path"),
    doc: ""
  ),
    (
    name: "when",
    args: ("write_file!", "is_binary"),
    doc: "Write JSON data to a file (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> Json.write_file!(%{\\"data\\" => \\"value\\"}, \\"/path/to/output.json\\")     {:ok, \\"/path/to/output.json\\"}          iex> Json.write_file!(%{\\"data\\" => \\"value\\"}, \\"/invalid/path/file.json\\")     {:error, \\"Failed to write JSON to file /invalid/path/file.json: enoent\\"}"
  ),
    (
    name: "write_file!",
    args: ("data", "file_path"),
    doc: ""
  ),
    (
    name: "when",
    args: ("valid?", "is_binary"),
    doc: "Check if a string contains valid JSON (unwrapped version - raises on error).  Returns true if the string can be parsed as valid JSON, false otherwise.  ## Examples      iex> Json.valid?(~s|{\\"name\\": \\"Alice\\"}|)     true          iex> Json.valid?(~s|{invalid json}|)     false          iex> Json.valid?([~s|{\\"valid\\": true}|, ~s|{invalid}|])     [true, false]"
  ),
    (
    name: "when",
    args: ("valid?", "is_list"),
    doc: ""
  ),
    (
    name: "valid?",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "is_valid",
    args: ("json_string_or_list"),
    doc: "Alias for valid?/1 - Check if a string contains valid JSON.  ## Examples      iex> Json.is_valid(~s|{\\"name\\": \\"Alice\\"}|)     true          iex> Json.is_valid(~s|{invalid json}|)     false"
  ),
    (
    name: "when",
    args: ("valid!", "is_binary"),
    doc: "Check if a string contains valid JSON (wrapped version - returns {:ok, result} or {:error, reason}).  ## Examples      iex> Json.valid!(~s|{\\"name\\": \\"Alice\\"}|)     {:ok, true}          iex> Json.valid!(~s|{invalid json}|)     {:ok, false}          iex> Json.valid!([~s|{\\"valid\\": true}|, ~s|{invalid}|])     {:ok, [true, false]}"
  ),
    (
    name: "when",
    args: ("valid!", "is_list"),
    doc: ""
  ),
    (
    name: "valid!",
    args: ("invalid"),
    doc: ""
  ),
    (
    name: "is_valid!",
    args: ("json_string_or_list"),
    doc: "Alias for valid!/1 - Check if a string contains valid JSON (wrapped version).  ## Examples      iex> Json.is_valid!(~s|{\\"name\\": \\"Alice\\"}|)     {:ok, true}"
  )
)
  ),
  (
    name: "List",
    module_doc: "List module for the Rata programming language.  Provides fundamental list operations following Rata's design principles: - All values are vectors (no scalars) - 1-indexed arrays (following R conventions) - Immutable by default - Data-first philosophy  Functions include: first, rest, last, is_empty, length, prepend, append,  concat, reverse, take, drop, at.",
    functions: (
  (
    name: "first",
    args: ("arg"),
    doc: "Returns the first element of a list, or nil if the list is empty.  ## Examples     iex> List.first([1, 2, 3])     {:ok, 1}          iex> List.first([])     {:ok, nil}"
  ),
    (
    name: "when",
    args: ("first", "is_list"),
    doc: ""
  ),
    (
    name: "when",
    args: ("first", "not"),
    doc: ""
  ),
    (
    name: "rest",
    args: ("arg"),
    doc: "Returns all elements except the first (the tail of the list). Returns an empty list if the input list is empty or has only one element.  ## Examples     iex> List.rest([1, 2, 3])     {:ok, [2, 3]}          iex> List.rest([1])     {:ok, []}          iex> List.rest([])     {:ok, []}"
  ),
    (
    name: "when",
    args: ("rest", "is_list"),
    doc: ""
  ),
    (
    name: "when",
    args: ("rest", "not"),
    doc: ""
  ),
    (
    name: "last",
    args: ("arg"),
    doc: "Returns the last element of a list, or nil if the list is empty.  ## Examples     iex> List.last([1, 2, 3])     {:ok, 3}          iex> List.last([])     {:ok, nil}"
  ),
    (
    name: "when",
    args: ("last", "is_list"),
    doc: ""
  ),
    (
    name: "when",
    args: ("last", "not"),
    doc: ""
  ),
    (
    name: "is_empty",
    args: ("arg"),
    doc: "Returns true if the list is empty, false otherwise.  ## Examples     iex> List.is_empty([])     {:ok, true}          iex> List.is_empty([1, 2])     {:ok, false}"
  ),
    (
    name: "when",
    args: ("is_empty", "is_list"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_empty", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("length", "is_list"),
    doc: "Returns the length of a list.  ## Examples     iex> List.length([1, 2, 3])     {:ok, 3}          iex> List.length([])     {:ok, 0}"
  ),
    (
    name: "when",
    args: ("length", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("prepend", "is_list"),
    doc: "Prepends an element to the beginning of a list.  ## Examples     iex> List.prepend([2, 3], 1)     {:ok, [1, 2, 3]}          iex> List.prepend([], 1)     {:ok, [1]}"
  ),
    (
    name: "when",
    args: ("prepend", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("append", "is_list"),
    doc: "Appends an element to the end of a list.  ## Examples     iex> List.append([1, 2], 3)     {:ok, [1, 2, 3]}          iex> List.append([], 1)     {:ok, [1]}"
  ),
    (
    name: "when",
    args: ("append", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("concat", "and"),
    doc: "Concatenates two lists together.  ## Examples     iex> List.concat([1, 2], [3, 4])     {:ok, [1, 2, 3, 4]}          iex> List.concat([], [1, 2])     {:ok, [1, 2]}"
  ),
    (
    name: "when",
    args: ("concat", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("concat", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("reverse", "is_list"),
    doc: "Reverses the order of elements in a list.  ## Examples     iex> List.reverse([1, 2, 3])     {:ok, [3, 2, 1]}          iex> List.reverse([])     {:ok, []}"
  ),
    (
    name: "when",
    args: ("reverse", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("take", "and"),
    doc: "Takes the first n elements from a list. Returns fewer elements if the list is shorter than n.  ## Examples     iex> List.take([1, 2, 3, 4], 2)     {:ok, [1, 2]}          iex> List.take([1, 2], 5)     {:ok, [1, 2]}          iex> List.take([], 3)     {:ok, []}"
  ),
    (
    name: "when",
    args: ("take", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("take", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("take", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("drop", "and"),
    doc: "Drops the first n elements from a list. Returns an empty list if n is greater than or equal to the list length.  ## Examples     iex> List.drop([1, 2, 3, 4], 2)     {:ok, [3, 4]}          iex> List.drop([1, 2], 5)     {:ok, []}          iex> List.drop([], 3)     {:ok, []}"
  ),
    (
    name: "when",
    args: ("drop", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("drop", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("drop", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("at", "and"),
    doc: "Returns the element at the given 1-based index. Returns nil if the index is out of bounds. Following Rata's 1-indexed convention (like R).  ## Examples     iex> List.at([1, 2, 3], 1)     {:ok, 1}          iex> List.at([1, 2, 3], 3)     {:ok, 3}          iex> List.at([1, 2, 3], 5)     {:ok, nil}          iex> List.at([1, 2, 3], 0)     {:error, \\"List.at uses 1-based indexing, got 0\\"}"
  ),
    (
    name: "when",
    args: ("at", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("at", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("at", "not"),
    doc: ""
  )
)
  ),
  (
    name: "Log",
    module_doc: "Logging module for the Rata programming language.  Provides basic logging functionality with different levels following Rata's design principles: - All values are vectors (no scalars) - 1-indexed arrays - Immutable by default - Data-first philosophy",
    functions: (
  (
    name: "info",
    args: ("message"),
    doc: "Log an info message and return nil."
  ),
    (
    name: "debug",
    args: ("message"),
    doc: "Log a debug message and return nil."
  ),
    (
    name: "warn",
    args: ("message"),
    doc: "Log a warning message and return nil."
  ),
    (
    name: "error",
    args: ("message"),
    doc: "Log an error message and return nil."
  ),
    (
    name: "when",
    args: ("log", "is_binary"),
    doc: "Log a message with custom level and return nil."
  ),
    (
    name: "when",
    args: ("log", "is_atom"),
    doc: ""
  ),
    (
    name: "log",
    args: ("level", "message"),
    doc: ""
  )
)
  ),
  (
    name: "Maps",
    module_doc: "Maps module for the Rata programming language.  Provides operations for working with maps/dictionaries following Rata's design principles: - All values are vectors (no scalars) - 1-indexed arrays - Immutable by default - Data-first philosophy  Maps in Rata support both string and atom keys interchangeably. The API treats \\"key\\" and :key as equivalent - you can store with one and retrieve with the other. Functions include: get, put, delete, has_key, keys, values, merge, size, empty, to_list, from_list.",
    functions: (
  (
    name: "when",
    args: ("get", "and"),
    doc: "Gets a value from a map by key. Returns the value if the key exists, otherwise returns nil.  ## Examples     iex> Maps.get({key: \\"value\\"}, :key)     {:ok, \\"value\\"}          iex> Maps.get({key: \\"value\\"}, \\"key\\")  # Same key, different format     {:ok, \\"value\\"}          iex> Maps.get({\\"key\\" => \\"value\\"}, :key)  # Works both ways     {:ok, \\"value\\"}          iex> Maps.get({key: \\"value\\"}, :missing)     {:ok, nil}"
  ),
    (
    name: "when",
    args: ("get", "not"),
    doc: ""
  ),
    (
    name: "get",
    args: ("_map", "key"),
    doc: ""
  ),
    (
    name: "when",
    args: ("put", "and"),
    doc: "Puts a key-value pair into a map. Returns a new map with the key-value pair added or updated. Keys are normalized to atoms and any existing string/atom variants are replaced.  ## Examples     iex> Maps.put({}, :key, \\"value\\")     {:ok, %{key: \\"value\\"}}          iex> Maps.put({existing: \\"old\\"}, \\"existing\\", \\"new\\")  # Updates existing :existing     {:ok, %{existing: \\"new\\"}}"
  ),
    (
    name: "when",
    args: ("put", "not"),
    doc: ""
  ),
    (
    name: "put",
    args: ("_map", "key", "_value"),
    doc: ""
  ),
    (
    name: "when",
    args: ("delete", "and"),
    doc: "Deletes a key from a map. Returns a new map with the key removed. If key doesn't exist, returns the original map.  ## Examples     iex> Maps.delete({key: \\"value\\", other: \\"data\\"}, :key)     {:ok, %{other: \\"data\\"}}          iex> Maps.delete({key: \\"value\\"}, :missing)     {:ok, %{key: \\"value\\"}}"
  ),
    (
    name: "when",
    args: ("delete", "not"),
    doc: ""
  ),
    (
    name: "delete",
    args: ("_map", "key"),
    doc: ""
  ),
    (
    name: "when",
    args: ("has_key", "and"),
    doc: "Checks if a map has a specific key. Returns true if the key exists in the map, false otherwise.  ## Examples     iex> Maps.has_key({key: \\"value\\"}, :key)     {:ok, true}          iex> Maps.has_key({key: \\"value\\"}, :missing)     {:ok, false}"
  ),
    (
    name: "when",
    args: ("has_key", "not"),
    doc: ""
  ),
    (
    name: "has_key",
    args: ("_map", "key"),
    doc: ""
  ),
    (
    name: "when",
    args: ("keys", "is_map"),
    doc: "Gets all keys from a map. Returns a list of all keys in the map.  ## Examples     iex> Maps.keys({a: 1, b: 2, c: 3})     {:ok, [:a, :b, :c]}          iex> Maps.keys({})     {:ok, []}"
  ),
    (
    name: "keys",
    args: ("map"),
    doc: ""
  ),
    (
    name: "when",
    args: ("values", "is_map"),
    doc: "Gets all values from a map. Returns a list of all values in the map.  ## Examples     iex> Maps.values({a: 1, b: 2, c: 3})     {:ok, [1, 2, 3]}          iex> Maps.values({})     {:ok, []}"
  ),
    (
    name: "values",
    args: ("map"),
    doc: ""
  ),
    (
    name: "when",
    args: ("merge", "and"),
    doc: "Merges two maps together. The second map's values will overwrite the first map's values for duplicate keys.  ## Examples     iex> Maps.merge({a: 1, b: 2}, {b: 3, c: 4})     {:ok, %{a: 1, b: 3, c: 4}}          iex> Maps.merge({}, {key: \\"value\\"})     {:ok, %{key: \\"value\\"}}"
  ),
    (
    name: "when",
    args: ("merge", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("merge", "not"),
    doc: ""
  ),
    (
    name: "when",
    args: ("size", "is_map"),
    doc: "Gets the size of a map. Returns the number of key-value pairs in the map.  ## Examples     iex> Maps.size({a: 1, b: 2, c: 3})     {:ok, 3}          iex> Maps.size({})     {:ok, 0}"
  ),
    (
    name: "size",
    args: ("map"),
    doc: ""
  ),
    (
    name: "when",
    args: ("empty", "is_map"),
    doc: "Checks if a map is empty. Returns true if the map has no key-value pairs, false otherwise.  ## Examples     iex> Maps.empty({})     {:ok, true}          iex> Maps.empty({key: \\"value\\"})     {:ok, false}"
  ),
    (
    name: "empty",
    args: ("map"),
    doc: ""
  ),
    (
    name: "when",
    args: ("to_list", "is_map"),
    doc: "Converts a map to a list of key-value tuples. Returns a list where each element is a two-element tuple {key, value}.  ## Examples     iex> Maps.to_list({a: 1, b: 2})     {:ok, [{:a, 1}, {:b, 2}]}          iex> Maps.to_list({})     {:ok, []}"
  ),
    (
    name: "to_list",
    args: ("map"),
    doc: ""
  ),
    (
    name: "when",
    args: ("from_list", "is_list"),
    doc: "Creates a map from a list of key-value tuples. Takes a list where each element is a two-element tuple {key, value}.  ## Examples     iex> Maps.from_list([{:a, 1}, {:b, 2}])     {:ok, %{a: 1, b: 2}}          iex> Maps.from_list([])     {:ok, %{}}"
  ),
    (
    name: "from_list",
    args: ("list"),
    doc: ""
  )
)
  ),
  (
    name: "Math",
    module_doc: "Math module for the Rata programming language.  Provides basic arithmetic operators and mathematical functions following Rata's design principles: - All values are vectors (no scalars) - 1-indexed arrays - Immutable by default - Data-first philosophy",
    functions: (
  (
    name: "when",
    args: ("add", "and"),
    doc: "Addition function - adds two numbers. In Rata, this wraps the + binary operator for module-style calls."
  ),
    (
    name: "add",
    args: ("a", "b"),
    doc: ""
  ),
    (
    name: "when",
    args: ("subtract", "and"),
    doc: "Subtraction function - subtracts second number from first."
  ),
    (
    name: "subtract",
    args: ("a", "b"),
    doc: ""
  ),
    (
    name: "when",
    args: ("multiply", "and"),
    doc: "Multiplication function - multiplies two numbers."
  ),
    (
    name: "multiply",
    args: ("a", "b"),
    doc: ""
  ),
    (
    name: "when",
    args: ("divide", "and"),
    doc: "Division function - divides first number by second."
  ),
    (
    name: "when",
    args: ("divide", "is_number"),
    doc: ""
  ),
    (
    name: "divide",
    args: ("a", "b"),
    doc: ""
  ),
    (
    name: "when",
    args: ("power", "and"),
    doc: "Power function - raises first number to the power of second."
  ),
    (
    name: "power",
    args: ("a", "b"),
    doc: ""
  ),
    (
    name: "when",
    args: ("abs", "is_number"),
    doc: "Absolute value function."
  ),
    (
    name: "abs",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("sqrt", "and"),
    doc: "Square root function."
  ),
    (
    name: "when",
    args: ("sqrt", "and"),
    doc: ""
  ),
    (
    name: "sqrt",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("square", "is_number"),
    doc: "Square function - returns x^2."
  ),
    (
    name: "square",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("cube", "is_number"),
    doc: "Cube function - returns x^3."
  ),
    (
    name: "cube",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("factorial", "and"),
    doc: "Factorial function - computes n!"
  ),
    (
    name: "when",
    args: ("factorial", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("factorial", "is_number"),
    doc: ""
  ),
    (
    name: "factorial",
    args: ("n"),
    doc: ""
  ),
    (
    name: "when",
    args: ("exp", "is_number"),
    doc: "Natural exponential function - e^x."
  ),
    (
    name: "exp",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("log", "and"),
    doc: "Natural logarithm function - ln(x)."
  ),
    (
    name: "when",
    args: ("log", "and"),
    doc: ""
  ),
    (
    name: "log",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("log10", "and"),
    doc: "Logarithm base 10 function - log10(x)."
  ),
    (
    name: "when",
    args: ("log10", "and"),
    doc: ""
  ),
    (
    name: "log10",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("sin", "is_number"),
    doc: "Sine function."
  ),
    (
    name: "sin",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("cos", "is_number"),
    doc: "Cosine function."
  ),
    (
    name: "cos",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("tan", "is_number"),
    doc: "Tangent function."
  ),
    (
    name: "tan",
    args: ("a"),
    doc: ""
  ),
    (
    name: "pi",
    args: (),
    doc: "Pi constant."
  ),
    (
    name: "e",
    args: (),
    doc: "Euler's number constant."
  ),
    (
    name: "when",
    args: ("max", "and"),
    doc: "Maximum of two numbers."
  ),
    (
    name: "max",
    args: ("a", "b"),
    doc: ""
  ),
    (
    name: "when",
    args: ("min", "and"),
    doc: "Minimum of two numbers."
  ),
    (
    name: "min",
    args: ("a", "b"),
    doc: ""
  ),
    (
    name: "when",
    args: ("ceil", "is_number"),
    doc: "Ceiling function - smallest integer greater than or equal to x."
  ),
    (
    name: "ceil",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("floor", "is_number"),
    doc: "Floor function - largest integer less than or equal to x."
  ),
    (
    name: "floor",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("round", "is_number"),
    doc: "Round function - rounds to nearest integer."
  ),
    (
    name: "round",
    args: ("a"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_even", "is_integer"),
    doc: "Check if a number is even."
  ),
    (
    name: "when",
    args: ("is_even", "is_number"),
    doc: ""
  ),
    (
    name: "is_even",
    args: ("n"),
    doc: ""
  ),
    (
    name: "when",
    args: ("is_odd", "is_integer"),
    doc: "Check if a number is odd."
  ),
    (
    name: "when",
    args: ("is_odd", "is_number"),
    doc: ""
  ),
    (
    name: "is_odd",
    args: ("n"),
    doc: ""
  )
)
  ),
  (
    name: "Set",
    module_doc: "Set module for Rata programming language. Provides immutable set operations with wrapped returns.  All functions return {:ok, result} on success or {:error, message} on failure. Sets are internally represented using Elixir's MapSet for efficiency.",
    functions: (
  (
    name: "when",
    args: ("new", "is_list"),
    doc: "Creates a new set from a vector of elements.  Examples:   Set.new([1, 2, 3, 2} -> {:ok, MapSet.new([1, 2, 3])}}   Set.new([])          -> {:ok, MapSet.new([])}"
  ),
    (
    name: "new",
    args: ("_"),
    doc: ""
  ),
    (
    name: "add",
    args: ("=", "element"),
    doc: "Adds an element to a set, returning a new set.  Examples:   Set.add(MapSet.new([1, 2]), 3) -> {:ok, MapSet.new([1, 2, 3])}   Set.add(MapSet.new([1, 2]), 1) -> {:ok, MapSet.new([1, 2])}  # No duplicates"
  ),
    (
    name: "add",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "delete",
    args: ("=", "element"),
    doc: "Removes an element from a set, returning a new set.  Examples:   Set.delete(MapSet.new([1, 2, 3]), 2) -> {:ok, MapSet.new([1, 3])}   Set.delete(MapSet.new([1, 3]), 2)    -> {:ok, MapSet.new([1, 3])}  # Element not present"
  ),
    (
    name: "delete",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "member?",
    args: ("=", "element"),
    doc: "Checks if an element is a member of the set.  Examples:   Set.member?(MapSet.new([1, 2, 3])}, 2) -> {:ok, true}   Set.member?(MapSet.new([1, 3]), 2)    -> {:ok, false}"
  ),
    (
    name: "member?",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "size",
    args: ("="),
    doc: "Returns the number of elements in the set.  Examples:   Set.size(MapSet.new([1, 2, 3])}) -> {:ok, 3}   Set.size(MapSet.new([]))        -> {:ok, 0}"
  ),
    (
    name: "size",
    args: ("_"),
    doc: ""
  ),
    (
    name: "union",
    args: ("=", "="),
    doc: "Returns the union of two sets.  Examples:   Set.union(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, MapSet.new([1, 2, 3])}"
  ),
    (
    name: "union",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "intersection",
    args: ("=", "="),
    doc: "Returns the intersection of two sets.  Examples:   Set.intersection(MapSet.new([1, 2, 3]), MapSet.new([2, 3, 4])) -> {:ok, MapSet.new([2, 3])}"
  ),
    (
    name: "intersection",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "difference",
    args: ("=", "="),
    doc: "Returns the difference of two sets (elements in first set but not in second).  Examples:   Set.difference(MapSet.new([1, 2, 3]), MapSet.new([2, 4])) -> {:ok, MapSet.new([1, 3])}"
  ),
    (
    name: "difference",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "symmetric_difference",
    args: ("=", "="),
    doc: "Returns the symmetric difference of two sets (elements in either set but not in both).  Examples:   Set.symmetric_difference(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, MapSet.new([1, 3])}"
  ),
    (
    name: "symmetric_difference",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "subset?",
    args: ("=", "="),
    doc: "Checks if the first set is a subset of the second set.  Examples:   Set.subset?(MapSet.new([1, 2]), MapSet.new([1, 2, 3])}) -> {:ok, true}   Set.subset?(MapSet.new([1, 4]), MapSet.new([1, 2, 3])}) -> {:ok, false}"
  ),
    (
    name: "subset?",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "disjoint?",
    args: ("=", "="),
    doc: "Checks if two sets have no elements in common.  Examples:   Set.disjoint?(MapSet.new([1, 2]), MapSet.new([3, 4])) -> {:ok, true}   Set.disjoint?(MapSet.new([1, 2]), MapSet.new([2, 3])) -> {:ok, false}"
  ),
    (
    name: "disjoint?",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "equal?",
    args: ("=", "="),
    doc: "Checks if two sets are equal.  Examples:   Set.equal?(MapSet.new([1, 2]), MapSet.new([2, 1])) -> {:ok, true}   Set.equal?(MapSet.new([1, 2]), MapSet.new([1, 3])) -> {:ok, false}"
  ),
    (
    name: "equal?",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "empty?",
    args: ("="),
    doc: "Checks if the set is empty.  Examples:   Set.empty?(MapSet.new([]))     -> {:ok, true}   Set.empty?(MapSet.new([1, 2])) -> {:ok, false}"
  ),
    (
    name: "empty?",
    args: ("_"),
    doc: ""
  ),
    (
    name: "to_vector",
    args: ("="),
    doc: "Converts a set to a vector (list).  Examples:   Set.to_vector(MapSet.new([1, 2, 3])) -> {:ok, [1, 2, 3]}  # Order may vary"
  ),
    (
    name: "to_vector",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("from_vector", "is_list"),
    doc: "Creates a set from a vector (list). Alias for new/1 for consistency with other modules.  Examples:   Set.from_vector([1, 2, 3, 2]) -> {:ok, MapSet.new([1, 2, 3])}"
  ),
    (
    name: "from_vector",
    args: ("_"),
    doc: ""
  ),
    (
    name: "first",
    args: ("="),
    doc: "Returns an arbitrary element from the set, or error if empty.  Examples:   Set.first(MapSet.new([1, 2, 3])) -> {:ok, 1}  # Could be any element   Set.first(MapSet.new([]))        -> {:error, \\"Set is empty\\"}"
  ),
    (
    name: "first",
    args: ("_"),
    doc: ""
  ),
    (
    name: "is_member",
    args: ("set", "element"),
    doc: "Alias for member?/2. Check if an element is a member of the set."
  ),
    (
    name: "is_subset",
    args: ("set1", "set2"),
    doc: "Alias for subset?/2. Check if the first set is a subset of the second set."
  ),
    (
    name: "is_disjoint",
    args: ("set1", "set2"),
    doc: "Alias for disjoint?/2. Check if two sets have no elements in common."
  ),
    (
    name: "is_equal",
    args: ("set1", "set2"),
    doc: "Alias for equal?/2. Check if two sets are equal."
  ),
    (
    name: "is_empty",
    args: ("set"),
    doc: "Alias for empty?/1. Check if the set is empty."
  )
)
  ),
  (
    name: "Stats",
    module_doc: "Statistics module for the Rata programming language.  Provides statistical functions and random number generation following Rata's design principles: - All values are vectors (no scalars) - 1-indexed arrays - Immutable by default - Data-first philosophy",
    functions: (
  (
    name: "runif",
    args: (),
    doc: "Generate a random float between 0.0 and 1.0 (uniform distribution). Similar to R's runif() function."
  ),
    (
    name: "when",
    args: ("runif", "and"),
    doc: "Generate a random float between min and max (uniform distribution)."
  ),
    (
    name: "when",
    args: ("runif", "and"),
    doc: ""
  ),
    (
    name: "runif",
    args: ("min", "max"),
    doc: ""
  ),
    (
    name: "rnorm",
    args: (),
    doc: "Generate random numbers from normal distribution. Similar to R's rnorm() function."
  ),
    (
    name: "when",
    args: ("rnorm", "and"),
    doc: "Generate random numbers from normal distribution with mean and std deviation."
  ),
    (
    name: "when",
    args: ("rnorm", "and"),
    doc: ""
  ),
    (
    name: "rnorm",
    args: ("mean", "std"),
    doc: ""
  ),
    (
    name: "rdunif",
    args: (),
    doc: "Generate random integers from discrete uniform distribution. Similar to R's rdunif() function with default parameters: n=1, a=0, b=1."
  ),
    (
    name: "when",
    args: ("rdunif", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("rdunif", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("rdunif", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("rdunif", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("rdunif", "and"),
    doc: ""
  ),
    (
    name: "rdunif",
    args: ("n", "a", "b"),
    doc: ""
  ),
    (
    name: "when",
    args: ("mean", "is_list"),
    doc: "Calculate mean of a list of numbers."
  ),
    (
    name: "mean",
    args: ("value"),
    doc: ""
  ),
    (
    name: "when",
    args: ("sd", "is_list"),
    doc: "Calculate standard deviation of a list of numbers."
  ),
    (
    name: "sd",
    args: ("value"),
    doc: ""
  ),
    (
    name: "when",
    args: ("var", "is_list"),
    doc: "Calculate variance of a list of numbers."
  ),
    (
    name: "var",
    args: ("value"),
    doc: ""
  ),
    (
    name: "when",
    args: ("median", "is_list"),
    doc: "Calculate median of a list of numbers."
  ),
    (
    name: "median",
    args: ("value"),
    doc: ""
  ),
    (
    name: "when",
    args: ("quantiles", "and"),
    doc: "Calculate quantiles of a list of numbers."
  ),
    (
    name: "quantiles",
    args: ("values", "probs"),
    doc: ""
  )
)
  ),
  (
    name: "Table",
    module_doc: "Table module for the Rata programming language (temporarily stubbed for CLI compilation).",
    functions: (
  (
    name: "new",
    args: ("_"),
    doc: ""
  ),
    (
    name: "from_list",
    args: ("_"),
    doc: ""
  ),
    (
    name: "select",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "filter",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "mutate",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "arrange",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "slice",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "head",
    args: ("_", "\\"),
    doc: ""
  ),
    (
    name: "tail",
    args: ("_", "\\"),
    doc: ""
  ),
    (
    name: "nrows",
    args: ("_"),
    doc: ""
  ),
    (
    name: "ncols",
    args: ("_"),
    doc: ""
  ),
    (
    name: "names",
    args: ("_"),
    doc: ""
  ),
    (
    name: "print",
    args: ("_"),
    doc: ""
  ),
    (
    name: "summarise",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "group_by",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "count",
    args: ("_"),
    doc: ""
  )
)
  ),
  (
    name: "Vector",
    module_doc: "Vector module for Rata programming language.  Vectors are ordered collections of values of the same type in Rata, using `[1, 2, 3]` syntax. In Rata, there are no scalars - all values are single-entry vectors.  Key features: - 1-indexed access following Rata conventions - Type consistency - all elements must be same type - Immutable operations - all functions return new vectors - Support for common types: :int, :float, :string, :atom, :bool",
    functions: (
  (
    name: "new",
    args: (),
    doc: "Creates a new empty vector.  Examples:   Vector.new() -> []"
  ),
    (
    name: "when",
    args: ("new", "in"),
    doc: "Creates a new empty vector with specified type.  Examples:   Vector.new(:int) -> []   Vector.new(:string) -> []"
  ),
    (
    name: "new",
    args: ("type"),
    doc: ""
  ),
    (
    name: "when",
    args: ("length", "is_list"),
    doc: "Returns the length of a vector.  Examples:   Vector.length([1, 2, 3]) -> 3   Vector.length([]) -> 0"
  ),
    (
    name: "when",
    args: ("length", "is_list"),
    doc: ""
  ),
    (
    name: "length",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("at", "and"),
    doc: "Accesses element at given 1-indexed position.  Examples:   Vector.at([1, 2, 3], 1) -> 1   Vector.at([1, 2, 3], 3) -> 3   Vector.at([1, 2, 3], 4) -> {:error, \\"Index 4 out of bounds for vector of length 3\\"}"
  ),
    (
    name: "when",
    args: ("at", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("at", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("at", "is_list"),
    doc: ""
  ),
    (
    name: "at",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "first",
    args: ("arg"),
    doc: "Returns the first element of a vector.  Examples:   Vector.first([1, 2, 3]) -> 1   Vector.first([]) -> {:error, \\"Vector is empty\\"}"
  ),
    (
    name: "first",
    args: ("arg"),
    doc: ""
  ),
    (
    name: "first",
    args: ("arg"),
    doc: ""
  ),
    (
    name: "first",
    args: ("arg"),
    doc: ""
  ),
    (
    name: "first",
    args: ("_"),
    doc: ""
  ),
    (
    name: "last",
    args: ("arg"),
    doc: "Returns the last element of a vector.  Examples:   Vector.last([1, 2, 3]) -> 3   Vector.last([]) -> {:error, \\"Vector is empty\\"}"
  ),
    (
    name: "when",
    args: ("last", "is_list"),
    doc: ""
  ),
    (
    name: "last",
    args: ("arg"),
    doc: ""
  ),
    (
    name: "when",
    args: ("last", "is_list"),
    doc: ""
  ),
    (
    name: "last",
    args: ("_"),
    doc: ""
  ),
    (
    name: "type",
    args: ("arg"),
    doc: "Returns the type of elements in the vector.  Examples:   Vector.type([1, 2, 3]) -> :int   Vector.type([\\"a\\", \\"b\\"]) -> :string   Vector.type([]) -> :unknown"
  ),
    (
    name: "when",
    args: ("type", "is_integer"),
    doc: ""
  ),
    (
    name: "when",
    args: ("type", "is_float"),
    doc: ""
  ),
    (
    name: "when",
    args: ("type", "is_binary"),
    doc: ""
  ),
    (
    name: "when",
    args: ("type", "is_atom"),
    doc: ""
  ),
    (
    name: "when",
    args: ("type", "is_boolean"),
    doc: ""
  ),
    (
    name: "type",
    args: ("arg"),
    doc: ""
  ),
    (
    name: "type",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("append", "is_list"),
    doc: "Appends an element to the end of a vector, returning a new vector.  Examples:   Vector.append([1, 2], 3) -> [1, 2, 3]   Vector.append([], 1) -> [1]"
  ),
    (
    name: "when",
    args: ("append", "is_list"),
    doc: ""
  ),
    (
    name: "append",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("concat", "and"),
    doc: "Concatenates two vectors, returning a new vector.  Examples:   Vector.concat([1, 2], [3, 4]) -> [1, 2, 3, 4]   Vector.concat([], [1, 2]) -> [1, 2]"
  ),
    (
    name: "when",
    args: ("concat", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("concat", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("concat", "and"),
    doc: ""
  ),
    (
    name: "concat",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("reverse", "is_list"),
    doc: "Reverses the order of elements in a vector.  Examples:   Vector.reverse([1, 2, 3]) -> [3, 2, 1]   Vector.reverse([]) -> []"
  ),
    (
    name: "when",
    args: ("reverse", "is_list"),
    doc: ""
  ),
    (
    name: "reverse",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("slice", "and"),
    doc: "Extracts a slice of the vector starting at 1-indexed position for given length.  Examples:   Vector.slice([1, 2, 3, 4, 5], 2, 3) -> [2, 3, 4]   Vector.slice([1, 2, 3], 1, 2) -> [1, 2]"
  ),
    (
    name: "when",
    args: ("slice", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("slice", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("slice", "and"),
    doc: ""
  ),
    (
    name: "when",
    args: ("slice", "is_list"),
    doc: ""
  ),
    (
    name: "slice",
    args: ("_", "_", "_"),
    doc: ""
  ),
    (
    name: "empty?",
    args: ("arg"),
    doc: "Checks if a vector is empty.  Examples:   Vector.empty?([]) -> true   Vector.empty?([1, 2, 3]) -> false"
  ),
    (
    name: "when",
    args: ("empty?", "is_list"),
    doc: ""
  ),
    (
    name: "empty?",
    args: ("arg"),
    doc: ""
  ),
    (
    name: "when",
    args: ("empty?", "is_list"),
    doc: ""
  ),
    (
    name: "empty?",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("member?", "is_list"),
    doc: "Checks if an element is a member of the vector.  Examples:   Vector.member?([1, 2, 3], 2) -> true   Vector.member?([1, 2, 3], 4) -> false"
  ),
    (
    name: "when",
    args: ("member?", "is_list"),
    doc: ""
  ),
    (
    name: "member?",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("to_list", "is_list"),
    doc: "Converts a vector to an Elixir list.  Examples:   Vector.to_list([1, 2, 3]) -> [1, 2, 3]"
  ),
    (
    name: "when",
    args: ("to_list", "is_list"),
    doc: ""
  ),
    (
    name: "to_list",
    args: ("_"),
    doc: ""
  ),
    (
    name: "when",
    args: ("from_list", "and"),
    doc: "Creates a vector from an Elixir list with specified type.  Examples:   Vector.from_list([1, 2, 3], :int) -> {[1, 2, 3], :int}   Vector.from_list([\\"a\\", \\"b\\"], :string) -> {[\\"a\\", \\"b\\"], :string}"
  ),
    (
    name: "when",
    args: ("from_list", "is_list"),
    doc: ""
  ),
    (
    name: "from_list",
    args: ("_", "_"),
    doc: ""
  ),
    (
    name: "is_empty",
    args: ("vector"),
    doc: "Alias for empty?/1. Check if a vector is empty."
  ),
    (
    name: "is_member",
    args: ("vector", "element"),
    doc: "Alias for member?/2. Check if an element is a member of the vector."
  )
)
  )
)


#all_modules_doc(modules: modules_data)
