# Datetime Module

Datetime module for the Rata programming language, mirroring R's lubridate API.

Provides comprehensive date and time parsing, manipulation, and formatting functions 
following Rata's design principles:
- All values are vectors (no scalars)
- 1-indexed arrays where applicable
- Immutable by default
- Data-first philosophy
- Dual function pattern: `foo()` returns direct results or raises, `foo!()` returns tuples

This module leverages Elixir's robust datetime libraries (DateTime, Date, Time, NaiveDateTime)
while providing an R-like interface familiar to data engineering workflows.

## Function Convention

Each operation comes in two variants:
- `function_name/arity` - Returns direct results, raises exceptions on errors
- `function_name!/arity` - Returns `{:ok, result}` or `{:error, reason}` tuples

## Examples

    # Unwrapped version (raises on error)
    date = Datetime.ymd("2024-01-15")
    year_val = Datetime.year(date)
    
    # Wrapped version (safe error handling)
    case Datetime.ymd!("2024-01-15") do
      {:ok, date} -> Log.info("Parsed: #{date}")
      {:error, message} -> Log.error("Failed: #{message}")
    end


## Import

```rata
library Datetime
```

## Functions

### `day(%)`

Extract day of month from date/datetime (unwrapped version - raises on error).

## Examples

    iex> Datetime.day(~D[2024-01-15])
    15
    
    iex> Datetime.day(~U[2024-01-25 14:30:25Z])
    25



### `day(%)`

_No documentation available._


### `day(%)`

_No documentation available._


### `day(invalid)`

_No documentation available._


### `day!(%)`

Extract day of month from date/datetime (wrapped version - returns {:ok, result} or {:error, reason}).



### `day!(%)`

_No documentation available._


### `day!(%)`

_No documentation available._


### `day!(invalid)`

_No documentation available._


### `days_in_month(%)`

_No documentation available._


### `days_in_month(%)`

_No documentation available._


### `days_in_month(%)`

_No documentation available._


### `days_in_month(year, month)`

_No documentation available._


### `days_in_month!(%)`

_No documentation available._


### `days_in_month!(%)`

_No documentation available._


### `days_in_month!(%)`

_No documentation available._


### `days_in_month!(year, month)`

_No documentation available._


### `dmy(invalid)`

_No documentation available._


### `dmy!(invalid)`

_No documentation available._


### `force_tz(datetime, timezone)`

_No documentation available._


### `force_tz!(datetime, timezone)`

_No documentation available._


### `hour(%)`

Extract hour from datetime (unwrapped version - raises on error).

## Examples

    iex> Datetime.hour(~U[2024-01-15 14:30:25Z])
    14
    
    iex> Datetime.hour(~N[2024-01-15 09:15:30])
    9



### `hour(%)`

_No documentation available._


### `hour(invalid)`

_No documentation available._


### `hour!(%)`

Extract hour from datetime (wrapped version - returns {:ok, result} or {:error, reason}).



### `hour!(%)`

_No documentation available._


### `hour!(invalid)`

_No documentation available._


### `is_leap_year(year)`

Alias for leap_year/1. Check if a year is a leap year.



### `is_leap_year!(year)`

Alias for leap_year!/1. Check if a year is a leap year (wrapped version).



### `leap_year(%)`

_No documentation available._


### `leap_year(%)`

_No documentation available._


### `leap_year(%)`

_No documentation available._


### `leap_year(invalid)`

_No documentation available._


### `leap_year!(%)`

_No documentation available._


### `leap_year!(%)`

_No documentation available._


### `leap_year!(%)`

_No documentation available._


### `leap_year!(invalid)`

_No documentation available._


### `mdy(invalid)`

_No documentation available._


### `mdy!(invalid)`

_No documentation available._


### `minute(%)`

Extract minute from datetime (unwrapped version - raises on error).

## Examples

    iex> Datetime.minute(~U[2024-01-15 14:30:25Z])
    30



### `minute(%)`

_No documentation available._


### `minute(invalid)`

_No documentation available._


### `minute!(%)`

Extract minute from datetime (wrapped version - returns {:ok, result} or {:error, reason}).



### `minute!(%)`

_No documentation available._


### `minute!(invalid)`

_No documentation available._


### `month(%)`

Extract month from date/datetime (unwrapped version - raises on error).
Returns 1-indexed month (1 = January, 12 = December).

## Examples

    iex> Datetime.month(~D[2024-01-15])
    1
    
    iex> Datetime.month(~U[2024-12-15 14:30:25Z])
    12



### `month(%)`

_No documentation available._


### `month(%)`

_No documentation available._


### `month(invalid)`

_No documentation available._


### `month!(%)`

Extract month from date/datetime (wrapped version - returns {:ok, result} or {:error, reason}).



### `month!(%)`

_No documentation available._


### `month!(%)`

_No documentation available._


### `month!(invalid)`

_No documentation available._


### `now()`

Get current UTC datetime (unwrapped version - raises on error).

## Examples

    iex> Datetime.now()
    ~U[2024-01-15 14:30:25.123456Z]



### `now!()`

Get current UTC datetime (wrapped version - returns {:ok, result} or {:error, reason}).



### `second(%)`

Extract second from datetime (unwrapped version - raises on error).

## Examples

    iex> Datetime.second(~U[2024-01-15 14:30:25Z])
    25



### `second(%)`

_No documentation available._


### `second(invalid)`

_No documentation available._


### `second!(%)`

Extract second from datetime (wrapped version - returns {:ok, result} or {:error, reason}).



### `second!(%)`

_No documentation available._


### `second!(invalid)`

_No documentation available._


### `today()`

Get current date (unwrapped version - raises on error).

## Examples

    iex> Datetime.today()
    ~D[2024-01-15]



### `today!()`

Get current date (wrapped version - returns {:ok, result} or {:error, reason}).



### `wday(invalid)`

_No documentation available._


### `wday!(invalid)`

_No documentation available._


### `when(ymd, is_binary)`

Parse date string in Year-Month-Day format (unwrapped version - raises on error).

Accepts various separators: "-", "/", ".", or no separator.

## Examples

    iex> Datetime.ymd("2024-01-15")
    ~D[2024-01-15]
    
    iex> Datetime.ymd("2024/01/15")
    ~D[2024-01-15]
    
    iex> Datetime.ymd("20240115")
    ~D[2024-01-15]



### `when(ymd, is_list)`

_No documentation available._


### `when(ymd!, is_binary)`

Parse date string in Year-Month-Day format (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> Datetime.ymd!("2024-01-15")
    {:ok, ~D[2024-01-15]}
    
    iex> Datetime.ymd!("invalid")
    {:error, "Invalid date format"}



### `when(ymd!, is_list)`

_No documentation available._


### `when(dmy, is_binary)`

Parse date string in Day-Month-Year format (unwrapped version - raises on error).

## Examples

    iex> Datetime.dmy("15-01-2024")
    ~D[2024-01-15]
    
    iex> Datetime.dmy("15/01/2024")
    ~D[2024-01-15]



### `when(dmy, is_list)`

_No documentation available._


### `when(dmy!, is_binary)`

Parse date string in Day-Month-Year format (wrapped version - returns {:ok, result} or {:error, reason}).



### `when(dmy!, is_list)`

_No documentation available._


### `when(mdy, is_binary)`

Parse date string in Month-Day-Year format (unwrapped version - raises on error).

## Examples

    iex> Datetime.mdy("01-15-2024")
    ~D[2024-01-15]
    
    iex> Datetime.mdy("01/15/2024")
    ~D[2024-01-15]



### `when(mdy, is_list)`

_No documentation available._


### `when(mdy!, is_binary)`

Parse date string in Month-Day-Year format (wrapped version - returns {:ok, result} or {:error, reason}).



### `when(mdy!, is_list)`

_No documentation available._


### `when(ymd_hms, is_binary)`

Parse datetime string in Year-Month-Day Hour:Minute:Second format (unwrapped version - raises on error).

## Examples

    iex> Datetime.ymd_hms("2024-01-15 14:30:25")
    ~U[2024-01-15 14:30:25Z]
    
    iex> Datetime.ymd_hms("2024-01-15T14:30:25")
    ~U[2024-01-15 14:30:25Z]



### `when(ymd_hms, is_list)`

_No documentation available._


### `when(ymd_hms!, is_binary)`

Parse datetime string in Year-Month-Day Hour:Minute:Second format (wrapped version - returns {:ok, result} or {:error, reason}).



### `when(ymd_hms!, is_list)`

_No documentation available._


### `when(year, is_list)`

_No documentation available._


### `when(year!, is_list)`

_No documentation available._


### `when(month, is_list)`

_No documentation available._


### `when(month!, is_list)`

_No documentation available._


### `when(day, is_list)`

_No documentation available._


### `when(day!, is_list)`

_No documentation available._


### `when(wday, or)`

Extract day of week from date/datetime (unwrapped version - raises on error).
Returns 1-indexed day of week (1 = Sunday, 7 = Saturday), following R conventions.

## Examples

    iex> Datetime.wday(~D[2024-01-15])  # Monday
    2
    
    iex> Datetime.wday(~D[2024-01-14])  # Sunday
    1



### `when(wday, is_list)`

_No documentation available._


### `when(wday!, or)`

Extract day of week from date/datetime (wrapped version - returns {:ok, result} or {:error, reason}).



### `when(wday!, is_list)`

_No documentation available._


### `when(hour, is_list)`

_No documentation available._


### `when(hour!, is_list)`

_No documentation available._


### `when(minute, is_list)`

_No documentation available._


### `when(minute!, is_list)`

_No documentation available._


### `when(second, is_list)`

_No documentation available._


### `when(second!, is_list)`

_No documentation available._


### `when(leap_year, is_integer)`

Check if a year is a leap year (unwrapped version - raises on error).

## Examples

    iex> Datetime.leap_year(2024)
    true
    
    iex> Datetime.leap_year(2023)
    false
    
    iex> Datetime.leap_year([2020, 2021, 2022, 2023, 2024])
    [true, false, false, false, true]



### `when(leap_year, is_list)`

_No documentation available._


### `when(leap_year!, is_integer)`

Check if a year is a leap year (wrapped version - returns {:ok, result} or {:error, reason}).



### `when(leap_year!, is_list)`

_No documentation available._


### `when(days_in_month, and)`

Get number of days in a given month (unwrapped version - raises on error).

## Examples

    iex> Datetime.days_in_month(2024, 2)
    29
    
    iex> Datetime.days_in_month(2023, 2) 
    28
    
    iex> Datetime.days_in_month(2024, 4)
    30



### `when(days_in_month, is_integer)`

_No documentation available._


### `when(days_in_month!, and)`

Get number of days in a given month (wrapped version - returns {:ok, result} or {:error, reason}).



### `when(days_in_month!, is_integer)`

_No documentation available._


### `when(with_tz, is_binary)`

Convert datetime to a different timezone (unwrapped version - raises on error).

## Examples

    iex> utc_dt = ~U[2024-01-15 14:30:25Z]
    iex> Datetime.with_tz(utc_dt, "America/New_York")
    # Returns datetime in Eastern timezone



### `when(with_tz, and)`

_No documentation available._


### `when(with_tz!, is_binary)`

Convert datetime to a different timezone (wrapped version - returns {:ok, result} or {:error, reason}).



### `when(with_tz!, and)`

_No documentation available._


### `when(force_tz, is_binary)`

Change the timezone designation without converting the time (unwrapped version - raises on error).

## Examples

    iex> naive_dt = ~N[2024-01-15 14:30:25]
    iex> Datetime.force_tz(naive_dt, "America/New_York")
    # Returns datetime with EST timezone applied



### `when(force_tz, and)`

_No documentation available._


### `when(force_tz!, is_binary)`

Change the timezone designation without converting the time (wrapped version - returns {:ok, result} or {:error, reason}).



### `when(force_tz!, and)`

_No documentation available._


### `with_tz(datetime, timezone)`

_No documentation available._


### `with_tz!(datetime, timezone)`

_No documentation available._


### `year(%)`

Extract year from date/datetime (unwrapped version - raises on error).

## Examples

    iex> Datetime.year(~D[2024-01-15])
    2024
    
    iex> Datetime.year(~U[2024-01-15 14:30:25Z])
    2024



### `year(%)`

_No documentation available._


### `year(%)`

_No documentation available._


### `year(invalid)`

_No documentation available._


### `year!(%)`

Extract year from date/datetime (wrapped version - returns {:ok, result} or {:error, reason}).



### `year!(%)`

_No documentation available._


### `year!(%)`

_No documentation available._


### `year!(invalid)`

_No documentation available._


### `ymd(invalid)`

_No documentation available._


### `ymd!(invalid)`

_No documentation available._


### `ymd_hms(invalid)`

_No documentation available._


### `ymd_hms!(invalid)`

_No documentation available._

