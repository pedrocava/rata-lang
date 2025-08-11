# Datetime Module

The Datetime module provides date and time manipulation functions with an API similar to R's lubridate package. Essential for time-series data and temporal analysis.

## Overview

Datetime features:
- **lubridate-style API**: Familiar functions for R users
- **Time zone support**: Full time zone handling
- **Parsing flexibility**: Parse various date/time formats
- **Arithmetic operations**: Add/subtract time periods
- **Formatting**: Custom output formats

## Import

```rata
library Datetime as dt
```

## Current Time

### `now()` - Current datetime in system timezone
### `utc_now()` - Current datetime in UTC
### `today()` - Current date (no time component)

## Parsing

### `parse(string, format \\= nil)` - Parse datetime string
### `parse_date(string)` - Parse date string
### `parse_time(string)` - Parse time string

```rata
# Parse various formats
dt1 = Datetime.parse!("2023-12-25 15:30:00")
dt2 = Datetime.parse!("Dec 25, 2023", "%b %d, %Y")
date = Datetime.parse_date!("2023-12-25")
```

## Components

### `year(datetime)`, `month(datetime)`, `day(datetime)`
### `hour(datetime)`, `minute(datetime)`, `second(datetime)`
### `weekday(datetime)`, `yearday(datetime)`

## Arithmetic

### `add_years(datetime, years)`
### `add_months(datetime, months)` 
### `add_days(datetime, days)`
### `add_hours(datetime, hours)`
### `diff(datetime1, datetime2, unit)`

```rata
# Date arithmetic
next_week = dt.today() |> dt.add_days(7)
age_in_days = dt.diff(dt.today(), birth_date, :days)
```

## Formatting

### `format(datetime, format_string)` - Custom formatting
### `to_string(datetime)` - ISO 8601 format
### `to_date_string(datetime)` - Date only

## Time Zones

### `to_timezone(datetime, timezone)` - Convert timezone
### `timezone(datetime)` - Get current timezone

## Usage Examples

```rata
# Time series analysis
sales_data
  |> Table.mutate(
      year: dt.year(sale_date),
      month: dt.month(sale_date),
      weekday: dt.weekday(sale_date),
      days_since: dt.diff(dt.today(), sale_date, :days)
     )
  |> Table.filter(days_since <= 30)  # Last 30 days

# Working hours calculation
work_start = dt.parse!("2023-12-25 09:00:00")
work_end = dt.parse!("2023-12-25 17:30:00")
work_hours = dt.diff(work_end, work_start, :hours)  # 8.5
```

---

*This is a skeleton for the Datetime module documentation. Full implementation details will be added as the module is developed.*