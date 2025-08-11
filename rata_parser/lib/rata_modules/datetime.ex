defmodule RataModules.Datetime do
  @moduledoc """
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
  """

  @doc """
  Parse date string in Year-Month-Day format (unwrapped version - raises on error).
  
  Accepts various separators: "-", "/", ".", or no separator.
  
  ## Examples
  
      iex> Datetime.ymd("2024-01-15")
      ~D[2024-01-15]
      
      iex> Datetime.ymd("2024/01/15")
      ~D[2024-01-15]
      
      iex> Datetime.ymd("20240115")
      ~D[2024-01-15]
  """
  def ymd(date_string) when is_binary(date_string) do
    case parse_ymd(date_string) do
      {:ok, date} -> date
      {:error, reason} -> raise "Failed to parse date '#{date_string}': #{reason}"
    end
  end

  def ymd(date_strings) when is_list(date_strings) do
    Enum.map(date_strings, &ymd/1)
  end

  def ymd(invalid) do
    raise "Datetime.ymd requires a string or list of strings, got #{inspect(invalid)}"
  end

  @doc """
  Parse date string in Year-Month-Day format (wrapped version - returns {:ok, result} or {:error, reason}).
  
  ## Examples
  
      iex> Datetime.ymd!("2024-01-15")
      {:ok, ~D[2024-01-15]}
      
      iex> Datetime.ymd!("invalid")
      {:error, "Invalid date format"}
  """
  def ymd!(date_string) when is_binary(date_string) do
    parse_ymd(date_string)
  end

  def ymd!(date_strings) when is_list(date_strings) do
    results = Enum.map(date_strings, &ymd!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        dates = Enum.map(results, fn {:ok, date} -> date end)
        {:ok, dates}
      error -> error
    end
  end

  def ymd!(invalid) do
    {:error, "Datetime.ymd! requires a string or list of strings, got #{inspect(invalid)}"}
  end

  @doc """
  Parse date string in Day-Month-Year format (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.dmy("15-01-2024")
      ~D[2024-01-15]
      
      iex> Datetime.dmy("15/01/2024")
      ~D[2024-01-15]
  """
  def dmy(date_string) when is_binary(date_string) do
    case parse_dmy(date_string) do
      {:ok, date} -> date
      {:error, reason} -> raise "Failed to parse date '#{date_string}': #{reason}"
    end
  end

  def dmy(date_strings) when is_list(date_strings) do
    Enum.map(date_strings, &dmy/1)
  end

  def dmy(invalid) do
    raise "Datetime.dmy requires a string or list of strings, got #{inspect(invalid)}"
  end

  @doc """
  Parse date string in Day-Month-Year format (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def dmy!(date_string) when is_binary(date_string) do
    parse_dmy(date_string)
  end

  def dmy!(date_strings) when is_list(date_strings) do
    results = Enum.map(date_strings, &dmy!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        dates = Enum.map(results, fn {:ok, date} -> date end)
        {:ok, dates}
      error -> error
    end
  end

  def dmy!(invalid) do
    {:error, "Datetime.dmy! requires a string or list of strings, got #{inspect(invalid)}"}
  end

  @doc """
  Parse date string in Month-Day-Year format (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.mdy("01-15-2024")
      ~D[2024-01-15]
      
      iex> Datetime.mdy("01/15/2024")
      ~D[2024-01-15]
  """
  def mdy(date_string) when is_binary(date_string) do
    case parse_mdy(date_string) do
      {:ok, date} -> date
      {:error, reason} -> raise "Failed to parse date '#{date_string}': #{reason}"
    end
  end

  def mdy(date_strings) when is_list(date_strings) do
    Enum.map(date_strings, &mdy/1)
  end

  def mdy(invalid) do
    raise "Datetime.mdy requires a string or list of strings, got #{inspect(invalid)}"
  end

  @doc """
  Parse date string in Month-Day-Year format (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def mdy!(date_string) when is_binary(date_string) do
    parse_mdy(date_string)
  end

  def mdy!(date_strings) when is_list(date_strings) do
    results = Enum.map(date_strings, &mdy!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        dates = Enum.map(results, fn {:ok, date} -> date end)
        {:ok, dates}
      error -> error
    end
  end

  def mdy!(invalid) do
    {:error, "Datetime.mdy! requires a string or list of strings, got #{inspect(invalid)}"}
  end

  @doc """
  Parse datetime string in Year-Month-Day Hour:Minute:Second format (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.ymd_hms("2024-01-15 14:30:25")
      ~U[2024-01-15 14:30:25Z]
      
      iex> Datetime.ymd_hms("2024-01-15T14:30:25")
      ~U[2024-01-15 14:30:25Z]
  """
  def ymd_hms(datetime_string) when is_binary(datetime_string) do
    case parse_ymd_hms(datetime_string) do
      {:ok, datetime} -> datetime
      {:error, reason} -> raise "Failed to parse datetime '#{datetime_string}': #{reason}"
    end
  end

  def ymd_hms(datetime_strings) when is_list(datetime_strings) do
    Enum.map(datetime_strings, &ymd_hms/1)
  end

  def ymd_hms(invalid) do
    raise "Datetime.ymd_hms requires a string or list of strings, got #{inspect(invalid)}"
  end

  @doc """
  Parse datetime string in Year-Month-Day Hour:Minute:Second format (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def ymd_hms!(datetime_string) when is_binary(datetime_string) do
    parse_ymd_hms(datetime_string)
  end

  def ymd_hms!(datetime_strings) when is_list(datetime_strings) do
    results = Enum.map(datetime_strings, &ymd_hms!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        datetimes = Enum.map(results, fn {:ok, datetime} -> datetime end)
        {:ok, datetimes}
      error -> error
    end
  end

  def ymd_hms!(invalid) do
    {:error, "Datetime.ymd_hms! requires a string or list of strings, got #{inspect(invalid)}"}
  end

  # Private parsing functions
  defp parse_ymd(date_string) do
    # Handle various separators and formats
    normalized = String.replace(date_string, ~r/[\/\.]/, "-")
    
    case Regex.run(~r/^(\d{4})-?(\d{1,2})-?(\d{1,2})$/, normalized) do
      [_, year_str, month_str, day_str] ->
        try do
          year = String.to_integer(year_str)
          month = String.to_integer(month_str)
          day = String.to_integer(day_str)
          
          case Date.new(year, month, day) do
            {:ok, date} -> {:ok, date}
            {:error, _} -> {:error, "Invalid date values: year=#{year}, month=#{month}, day=#{day}"}
          end
        rescue
          ArgumentError -> {:error, "Invalid date format"}
        end
      nil -> 
        {:error, "Invalid date format"}
    end
  end

  defp parse_dmy(date_string) do
    # Handle various separators
    normalized = String.replace(date_string, ~r/[\/\.]/, "-")
    
    case Regex.run(~r/^(\d{1,2})-?(\d{1,2})-?(\d{4})$/, normalized) do
      [_, day_str, month_str, year_str] ->
        try do
          year = String.to_integer(year_str)
          month = String.to_integer(month_str)
          day = String.to_integer(day_str)
          
          case Date.new(year, month, day) do
            {:ok, date} -> {:ok, date}
            {:error, _} -> {:error, "Invalid date values: year=#{year}, month=#{month}, day=#{day}"}
          end
        rescue
          ArgumentError -> {:error, "Invalid date format"}
        end
      nil -> 
        {:error, "Invalid date format"}
    end
  end

  defp parse_mdy(date_string) do
    # Handle various separators
    normalized = String.replace(date_string, ~r/[\/\.]/, "-")
    
    case Regex.run(~r/^(\d{1,2})-?(\d{1,2})-?(\d{4})$/, normalized) do
      [_, month_str, day_str, year_str] ->
        try do
          year = String.to_integer(year_str)
          month = String.to_integer(month_str)
          day = String.to_integer(day_str)
          
          case Date.new(year, month, day) do
            {:ok, date} -> {:ok, date}
            {:error, _} -> {:error, "Invalid date values: year=#{year}, month=#{month}, day=#{day}"}
          end
        rescue
          ArgumentError -> {:error, "Invalid date format"}
        end
      nil -> 
        {:error, "Invalid date format"}
    end
  end

  defp parse_ymd_hms(datetime_string) do
    # Handle both space and 'T' separator between date and time
    normalized = String.replace(datetime_string, "T", " ")
    
    case Regex.run(~r/^(\d{4})-?(\d{1,2})-?(\d{1,2})\s+(\d{1,2}):(\d{1,2}):(\d{1,2})(?:\.(\d+))?(?:\s*([+-]\d{2}:\d{2}|Z))?$/, normalized) do
      [_, year_str, month_str, day_str, hour_str, minute_str, second_str | _] ->
        try do
          year = String.to_integer(year_str)
          month = String.to_integer(month_str)
          day = String.to_integer(day_str)
          hour = String.to_integer(hour_str)
          minute = String.to_integer(minute_str)
          second = String.to_integer(second_str)
          
          case NaiveDateTime.new(year, month, day, hour, minute, second) do
            {:ok, naive_datetime} -> 
              # Convert to UTC DateTime
              case DateTime.from_naive(naive_datetime, "Etc/UTC") do
                {:ok, datetime} -> {:ok, datetime}
                {:error, reason} -> {:error, "Failed to create datetime: #{inspect(reason)}"}
              end
            {:error, _} -> {:error, "Invalid datetime values"}
          end
        rescue
          ArgumentError -> {:error, "Invalid datetime format"}
        end
      nil -> 
        {:error, "Invalid datetime format"}
    end
  end

  # Component extraction functions

  @doc """
  Extract year from date/datetime (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.year(~D[2024-01-15])
      2024
      
      iex> Datetime.year(~U[2024-01-15 14:30:25Z])
      2024
  """
  def year(%Date{year: year_val}), do: year_val
  def year(%DateTime{year: year_val}), do: year_val
  def year(%NaiveDateTime{year: year_val}), do: year_val

  def year(dates) when is_list(dates) do
    Enum.map(dates, &year/1)
  end

  def year(invalid) do
    raise "Datetime.year requires a Date, DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"
  end

  @doc """
  Extract year from date/datetime (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def year!(%Date{year: year_val}), do: {:ok, year_val}
  def year!(%DateTime{year: year_val}), do: {:ok, year_val}
  def year!(%NaiveDateTime{year: year_val}), do: {:ok, year_val}

  def year!(dates) when is_list(dates) do
    try do
      years = Enum.map(dates, &year/1)
      {:ok, years}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def year!(invalid) do
    {:error, "Datetime.year! requires a Date, DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"}
  end

  @doc """
  Extract month from date/datetime (unwrapped version - raises on error).
  Returns 1-indexed month (1 = January, 12 = December).
  
  ## Examples
  
      iex> Datetime.month(~D[2024-01-15])
      1
      
      iex> Datetime.month(~U[2024-12-15 14:30:25Z])
      12
  """
  def month(%Date{month: month_val}), do: month_val
  def month(%DateTime{month: month_val}), do: month_val
  def month(%NaiveDateTime{month: month_val}), do: month_val

  def month(dates) when is_list(dates) do
    Enum.map(dates, &month/1)
  end

  def month(invalid) do
    raise "Datetime.month requires a Date, DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"
  end

  @doc """
  Extract month from date/datetime (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def month!(%Date{month: month_val}), do: {:ok, month_val}
  def month!(%DateTime{month: month_val}), do: {:ok, month_val}
  def month!(%NaiveDateTime{month: month_val}), do: {:ok, month_val}

  def month!(dates) when is_list(dates) do
    try do
      months = Enum.map(dates, &month/1)
      {:ok, months}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def month!(invalid) do
    {:error, "Datetime.month! requires a Date, DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"}
  end

  @doc """
  Extract day of month from date/datetime (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.day(~D[2024-01-15])
      15
      
      iex> Datetime.day(~U[2024-01-25 14:30:25Z])
      25
  """
  def day(%Date{day: day_val}), do: day_val
  def day(%DateTime{day: day_val}), do: day_val
  def day(%NaiveDateTime{day: day_val}), do: day_val

  def day(dates) when is_list(dates) do
    Enum.map(dates, &day/1)
  end

  def day(invalid) do
    raise "Datetime.day requires a Date, DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"
  end

  @doc """
  Extract day of month from date/datetime (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def day!(%Date{day: day_val}), do: {:ok, day_val}
  def day!(%DateTime{day: day_val}), do: {:ok, day_val}
  def day!(%NaiveDateTime{day: day_val}), do: {:ok, day_val}

  def day!(dates) when is_list(dates) do
    try do
      days = Enum.map(dates, &day/1)
      {:ok, days}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def day!(invalid) do
    {:error, "Datetime.day! requires a Date, DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"}
  end

  @doc """
  Extract day of week from date/datetime (unwrapped version - raises on error).
  Returns 1-indexed day of week (1 = Sunday, 7 = Saturday), following R conventions.
  
  ## Examples
  
      iex> Datetime.wday(~D[2024-01-15])  # Monday
      2
      
      iex> Datetime.wday(~D[2024-01-14])  # Sunday
      1
  """
  def wday(date) when is_struct(date, Date) or is_struct(date, DateTime) or is_struct(date, NaiveDateTime) do
    # Convert Elixir's 1-7 (Monday-Sunday) to R's 1-7 (Sunday-Saturday)
    elixir_day = Date.day_of_week(date)
    case elixir_day do
      7 -> 1  # Sunday
      n -> n + 1  # Monday-Saturday
    end
  end

  def wday(dates) when is_list(dates) do
    Enum.map(dates, &wday/1)
  end

  def wday(invalid) do
    raise "Datetime.wday requires a Date, DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"
  end

  @doc """
  Extract day of week from date/datetime (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def wday!(date) when is_struct(date, Date) or is_struct(date, DateTime) or is_struct(date, NaiveDateTime) do
    {:ok, wday(date)}
  end

  def wday!(dates) when is_list(dates) do
    try do
      days = Enum.map(dates, &wday/1)
      {:ok, days}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def wday!(invalid) do
    {:error, "Datetime.wday! requires a Date, DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"}
  end

  @doc """
  Extract hour from datetime (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.hour(~U[2024-01-15 14:30:25Z])
      14
      
      iex> Datetime.hour(~N[2024-01-15 09:15:30])
      9
  """
  def hour(%DateTime{hour: hour_val}), do: hour_val
  def hour(%NaiveDateTime{hour: hour_val}), do: hour_val

  def hour(datetimes) when is_list(datetimes) do
    Enum.map(datetimes, &hour/1)
  end

  def hour(invalid) do
    raise "Datetime.hour requires a DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"
  end

  @doc """
  Extract hour from datetime (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def hour!(%DateTime{hour: hour_val}), do: {:ok, hour_val}
  def hour!(%NaiveDateTime{hour: hour_val}), do: {:ok, hour_val}

  def hour!(datetimes) when is_list(datetimes) do
    try do
      hours = Enum.map(datetimes, &hour/1)
      {:ok, hours}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def hour!(invalid) do
    {:error, "Datetime.hour! requires a DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"}
  end

  @doc """
  Extract minute from datetime (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.minute(~U[2024-01-15 14:30:25Z])
      30
  """
  def minute(%DateTime{minute: minute_val}), do: minute_val
  def minute(%NaiveDateTime{minute: minute_val}), do: minute_val

  def minute(datetimes) when is_list(datetimes) do
    Enum.map(datetimes, &minute/1)
  end

  def minute(invalid) do
    raise "Datetime.minute requires a DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"
  end

  @doc """
  Extract minute from datetime (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def minute!(%DateTime{minute: minute_val}), do: {:ok, minute_val}
  def minute!(%NaiveDateTime{minute: minute_val}), do: {:ok, minute_val}

  def minute!(datetimes) when is_list(datetimes) do
    try do
      minutes = Enum.map(datetimes, &minute/1)
      {:ok, minutes}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def minute!(invalid) do
    {:error, "Datetime.minute! requires a DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"}
  end

  @doc """
  Extract second from datetime (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.second(~U[2024-01-15 14:30:25Z])
      25
  """
  def second(%DateTime{second: second_val}), do: second_val
  def second(%NaiveDateTime{second: second_val}), do: second_val

  def second(datetimes) when is_list(datetimes) do
    Enum.map(datetimes, &second/1)
  end

  def second(invalid) do
    raise "Datetime.second requires a DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"
  end

  @doc """
  Extract second from datetime (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def second!(%DateTime{second: second_val}), do: {:ok, second_val}
  def second!(%NaiveDateTime{second: second_val}), do: {:ok, second_val}

  def second!(datetimes) when is_list(datetimes) do
    try do
      seconds = Enum.map(datetimes, &second/1)
      {:ok, seconds}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def second!(invalid) do
    {:error, "Datetime.second! requires a DateTime, NaiveDateTime or list thereof, got #{inspect(invalid)}"}
  end

  # Utility functions

  @doc """
  Get current UTC datetime (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.now()
      ~U[2024-01-15 14:30:25.123456Z]
  """
  def now() do
    DateTime.utc_now()
  end

  @doc """
  Get current UTC datetime (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def now!() do
    {:ok, DateTime.utc_now()}
  end

  @doc """
  Get current date (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.today()
      ~D[2024-01-15]
  """
  def today() do
    Date.utc_today()
  end

  @doc """
  Get current date (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def today!() do
    {:ok, Date.utc_today()}
  end

  @doc """
  Check if a year is a leap year (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.leap_year(2024)
      true
      
      iex> Datetime.leap_year(2023)
      false
      
      iex> Datetime.leap_year([2020, 2021, 2022, 2023, 2024])
      [true, false, false, false, true]
  """
  def leap_year(year) when is_integer(year) do
    Date.leap_year?(year)
  end

  def leap_year(years) when is_list(years) do
    Enum.map(years, &leap_year/1)
  end

  def leap_year(%Date{year: year_val}) do
    Date.leap_year?(year_val)
  end

  def leap_year(%DateTime{year: year_val}) do
    Date.leap_year?(year_val)
  end

  def leap_year(%NaiveDateTime{year: year_val}) do
    Date.leap_year?(year_val)
  end

  def leap_year(invalid) do
    raise "Datetime.leap_year requires an integer year, Date, DateTime, NaiveDateTime, or list thereof, got #{inspect(invalid)}"
  end

  @doc """
  Check if a year is a leap year (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def leap_year!(year) when is_integer(year) do
    {:ok, Date.leap_year?(year)}
  end

  def leap_year!(years) when is_list(years) do
    try do
      results = Enum.map(years, &leap_year/1)
      {:ok, results}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def leap_year!(%Date{year: year_val}) do
    {:ok, Date.leap_year?(year_val)}
  end

  def leap_year!(%DateTime{year: year_val}) do
    {:ok, Date.leap_year?(year_val)}
  end

  def leap_year!(%NaiveDateTime{year: year_val}) do
    {:ok, Date.leap_year?(year_val)}
  end

  def leap_year!(invalid) do
    {:error, "Datetime.leap_year! requires an integer year, Date, DateTime, NaiveDateTime, or list thereof, got #{inspect(invalid)}"}
  end

  @doc """
  Get number of days in a given month (unwrapped version - raises on error).
  
  ## Examples
  
      iex> Datetime.days_in_month(2024, 2)
      29
      
      iex> Datetime.days_in_month(2023, 2) 
      28
      
      iex> Datetime.days_in_month(2024, 4)
      30
  """
  def days_in_month(year, month) when is_integer(year) and is_integer(month) and month >= 1 and month <= 12 do
    Date.days_in_month(year, month)
  end

  def days_in_month(%Date{year: year_val, month: month_val}) do
    Date.days_in_month(year_val, month_val)
  end

  def days_in_month(%DateTime{year: year_val, month: month_val}) do
    Date.days_in_month(year_val, month_val)
  end

  def days_in_month(%NaiveDateTime{year: year_val, month: month_val}) do
    Date.days_in_month(year_val, month_val)
  end

  def days_in_month(year, month) when is_integer(year) do
    raise "Datetime.days_in_month requires month to be between 1 and 12, got #{month}"
  end

  def days_in_month(year, month) do
    raise "Datetime.days_in_month requires integer year and month, got #{inspect(year)} and #{inspect(month)}"
  end

  @doc """
  Get number of days in a given month (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def days_in_month!(year, month) when is_integer(year) and is_integer(month) and month >= 1 and month <= 12 do
    {:ok, Date.days_in_month(year, month)}
  end

  def days_in_month!(%Date{year: year_val, month: month_val}) do
    {:ok, Date.days_in_month(year_val, month_val)}
  end

  def days_in_month!(%DateTime{year: year_val, month: month_val}) do
    {:ok, Date.days_in_month(year_val, month_val)}
  end

  def days_in_month!(%NaiveDateTime{year: year_val, month: month_val}) do
    {:ok, Date.days_in_month(year_val, month_val)}
  end

  def days_in_month!(year, month) when is_integer(year) do
    {:error, "Datetime.days_in_month! requires month to be between 1 and 12, got #{month}"}
  end

  def days_in_month!(year, month) do
    {:error, "Datetime.days_in_month! requires integer year and month, got #{inspect(year)} and #{inspect(month)}"}
  end

  @doc """
  Convert datetime to a different timezone (unwrapped version - raises on error).
  
  ## Examples
  
      iex> utc_dt = ~U[2024-01-15 14:30:25Z]
      iex> Datetime.with_tz(utc_dt, "America/New_York")
      # Returns datetime in Eastern timezone
  """
  def with_tz(%DateTime{} = datetime, timezone) when is_binary(timezone) do
    case DateTime.shift_zone(datetime, timezone) do
      {:ok, shifted_dt} -> shifted_dt
      {:error, reason} -> raise "Failed to shift timezone to #{timezone}: #{inspect(reason)}"
    end
  end

  def with_tz(datetimes, timezone) when is_list(datetimes) and is_binary(timezone) do
    Enum.map(datetimes, &with_tz(&1, timezone))
  end

  def with_tz(datetime, timezone) do
    raise "Datetime.with_tz requires a DateTime and timezone string, got #{inspect(datetime)} and #{inspect(timezone)}"
  end

  @doc """
  Convert datetime to a different timezone (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def with_tz!(%DateTime{} = datetime, timezone) when is_binary(timezone) do
    case DateTime.shift_zone(datetime, timezone) do
      {:ok, shifted_dt} -> {:ok, shifted_dt}
      {:error, reason} -> {:error, "Failed to shift timezone to #{timezone}: #{inspect(reason)}"}
    end
  end

  def with_tz!(datetimes, timezone) when is_list(datetimes) and is_binary(timezone) do
    results = Enum.map(datetimes, &with_tz!(&1, timezone))
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        shifted_dts = Enum.map(results, fn {:ok, dt} -> dt end)
        {:ok, shifted_dts}
      error -> error
    end
  end

  def with_tz!(datetime, timezone) do
    {:error, "Datetime.with_tz! requires a DateTime and timezone string, got #{inspect(datetime)} and #{inspect(timezone)}"}
  end

  @doc """
  Change the timezone designation without converting the time (unwrapped version - raises on error).
  
  ## Examples
  
      iex> naive_dt = ~N[2024-01-15 14:30:25]
      iex> Datetime.force_tz(naive_dt, "America/New_York")
      # Returns datetime with EST timezone applied
  """
  def force_tz(%NaiveDateTime{} = naive_datetime, timezone) when is_binary(timezone) do
    case DateTime.from_naive(naive_datetime, timezone) do
      {:ok, datetime} -> datetime
      {:error, reason} -> raise "Failed to force timezone to #{timezone}: #{inspect(reason)}"
    end
  end

  def force_tz(naive_datetimes, timezone) when is_list(naive_datetimes) and is_binary(timezone) do
    Enum.map(naive_datetimes, &force_tz(&1, timezone))
  end

  def force_tz(datetime, timezone) do
    raise "Datetime.force_tz requires a NaiveDateTime and timezone string, got #{inspect(datetime)} and #{inspect(timezone)}"
  end

  @doc """
  Change the timezone designation without converting the time (wrapped version - returns {:ok, result} or {:error, reason}).
  """
  def force_tz!(%NaiveDateTime{} = naive_datetime, timezone) when is_binary(timezone) do
    case DateTime.from_naive(naive_datetime, timezone) do
      {:ok, datetime} -> {:ok, datetime}
      {:error, reason} -> {:error, "Failed to force timezone to #{timezone}: #{inspect(reason)}"}
    end
  end

  def force_tz!(naive_datetimes, timezone) when is_list(naive_datetimes) and is_binary(timezone) do
    results = Enum.map(naive_datetimes, &force_tz!(&1, timezone))
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        datetimes = Enum.map(results, fn {:ok, dt} -> dt end)
        {:ok, datetimes}
      error -> error
    end
  end

  def force_tz!(datetime, timezone) do
    {:error, "Datetime.force_tz! requires a NaiveDateTime and timezone string, got #{inspect(datetime)} and #{inspect(timezone)}"}
  end
end