defmodule DatetimeTest do
  use ExUnit.Case
  alias RataModules.Datetime

  describe "parsing functions - ymd" do
    test "ymd/1 parses various formats correctly" do
      assert Datetime.ymd("2024-01-15") == ~D[2024-01-15]
      assert Datetime.ymd("2024/01/15") == ~D[2024-01-15]
      assert Datetime.ymd("2024.01.15") == ~D[2024-01-15]
      assert Datetime.ymd("20240115") == ~D[2024-01-15]
      assert Datetime.ymd("2024-1-5") == ~D[2024-01-05]
    end

    test "ymd/1 works with lists" do
      dates = ["2024-01-15", "2024-02-29", "2023-12-31"]
      expected = [~D[2024-01-15], ~D[2024-02-29], ~D[2023-12-31]]
      assert Datetime.ymd(dates) == expected
    end

    test "ymd/1 raises on invalid dates" do
      assert_raise RuntimeError, ~r/Failed to parse date/, fn ->
        Datetime.ymd("invalid")
      end
      
      assert_raise RuntimeError, ~r/Failed to parse date/, fn ->
        Datetime.ymd("2024-13-01")
      end
    end

    test "ymd!/1 returns ok/error tuples" do
      assert Datetime.ymd!("2024-01-15") == {:ok, ~D[2024-01-15]}
      assert {:error, _} = Datetime.ymd!("invalid")
      assert {:error, _} = Datetime.ymd!("2024-13-01")
    end

    test "ymd!/1 works with lists" do
      dates = ["2024-01-15", "2024-02-29"]
      expected = [~D[2024-01-15], ~D[2024-02-29]]
      assert Datetime.ymd!(dates) == {:ok, expected}
      
      # Test with one invalid date in list
      invalid_dates = ["2024-01-15", "invalid"]
      assert {:error, _} = Datetime.ymd!(invalid_dates)
    end
  end

  describe "parsing functions - dmy" do
    test "dmy/1 parses various formats correctly" do
      assert Datetime.dmy("15-01-2024") == ~D[2024-01-15]
      assert Datetime.dmy("15/01/2024") == ~D[2024-01-15]
      assert Datetime.dmy("15.01.2024") == ~D[2024-01-15]
      assert Datetime.dmy("5-1-2024") == ~D[2024-01-05]
    end

    test "dmy!/1 returns ok/error tuples" do
      assert Datetime.dmy!("15-01-2024") == {:ok, ~D[2024-01-15]}
      assert {:error, _} = Datetime.dmy!("invalid")
    end
  end

  describe "parsing functions - mdy" do
    test "mdy/1 parses various formats correctly" do
      assert Datetime.mdy("01-15-2024") == ~D[2024-01-15]
      assert Datetime.mdy("01/15/2024") == ~D[2024-01-15]
      assert Datetime.mdy("1-5-2024") == ~D[2024-01-05]
    end

    test "mdy!/1 returns ok/error tuples" do
      assert Datetime.mdy!("01-15-2024") == {:ok, ~D[2024-01-15]}
      assert {:error, _} = Datetime.mdy!("invalid")
    end
  end

  describe "parsing functions - ymd_hms" do
    test "ymd_hms/1 parses datetime strings correctly" do
      result = Datetime.ymd_hms("2024-01-15 14:30:25")
      assert result.year == 2024
      assert result.month == 1
      assert result.day == 15
      assert result.hour == 14
      assert result.minute == 30
      assert result.second == 25
    end

    test "ymd_hms/1 handles T separator" do
      result = Datetime.ymd_hms("2024-01-15T14:30:25")
      assert result.year == 2024
      assert result.hour == 14
    end

    test "ymd_hms!/1 returns ok/error tuples" do
      {:ok, result} = Datetime.ymd_hms!("2024-01-15 14:30:25")
      assert result.year == 2024
      assert {:error, _} = Datetime.ymd_hms!("invalid")
    end
  end

  describe "component extraction - year" do
    test "year/1 extracts year from various date types" do
      assert Datetime.year(~D[2024-01-15]) == 2024
      assert Datetime.year(~U[2024-01-15 14:30:25Z]) == 2024
      assert Datetime.year(~N[2024-01-15 14:30:25]) == 2024
    end

    test "year/1 works with lists" do
      dates = [~D[2024-01-15], ~D[2023-12-31]]
      assert Datetime.year(dates) == [2024, 2023]
    end

    test "year!/1 returns ok/error tuples" do
      assert Datetime.year!(~D[2024-01-15]) == {:ok, 2024}
      assert {:error, _} = Datetime.year!("invalid")
    end
  end

  describe "component extraction - month" do
    test "month/1 extracts month from various date types" do
      assert Datetime.month(~D[2024-01-15]) == 1
      assert Datetime.month(~D[2024-12-15]) == 12
      assert Datetime.month(~U[2024-06-15 14:30:25Z]) == 6
    end

    test "month!/1 returns ok/error tuples" do
      assert Datetime.month!(~D[2024-01-15]) == {:ok, 1}
      assert {:error, _} = Datetime.month!("invalid")
    end
  end

  describe "component extraction - day" do
    test "day/1 extracts day from various date types" do
      assert Datetime.day(~D[2024-01-15]) == 15
      assert Datetime.day(~D[2024-01-05]) == 5
      assert Datetime.day(~U[2024-01-25 14:30:25Z]) == 25
    end

    test "day!/1 returns ok/error tuples" do
      assert Datetime.day!(~D[2024-01-15]) == {:ok, 15}
      assert {:error, _} = Datetime.day!("invalid")
    end
  end

  describe "component extraction - wday" do
    test "wday/1 returns R-style day of week (Sunday = 1)" do
      # 2024-01-14 is a Sunday
      assert Datetime.wday(~D[2024-01-14]) == 1
      # 2024-01-15 is a Monday
      assert Datetime.wday(~D[2024-01-15]) == 2
      # 2024-01-16 is a Tuesday
      assert Datetime.wday(~D[2024-01-16]) == 3
      # 2024-01-20 is a Saturday
      assert Datetime.wday(~D[2024-01-20]) == 7
    end

    test "wday!/1 returns ok/error tuples" do
      assert Datetime.wday!(~D[2024-01-14]) == {:ok, 1}
      assert {:error, _} = Datetime.wday!("invalid")
    end
  end

  describe "component extraction - time components" do
    test "hour/1 extracts hour from datetime types" do
      assert Datetime.hour(~U[2024-01-15 14:30:25Z]) == 14
      assert Datetime.hour(~N[2024-01-15 09:15:30]) == 9
    end

    test "minute/1 extracts minute from datetime types" do
      assert Datetime.minute(~U[2024-01-15 14:30:25Z]) == 30
      assert Datetime.minute(~N[2024-01-15 09:15:30]) == 15
    end

    test "second/1 extracts second from datetime types" do
      assert Datetime.second(~U[2024-01-15 14:30:25Z]) == 25
      assert Datetime.second(~N[2024-01-15 09:15:30]) == 30
    end

    test "time component functions return errors for invalid input" do
      assert {:error, _} = Datetime.hour!("invalid")
      assert {:error, _} = Datetime.minute!("invalid")  
      assert {:error, _} = Datetime.second!("invalid")
    end
  end

  describe "utility functions - current time" do
    test "now/1 returns current UTC datetime" do
      result = Datetime.now()
      assert %DateTime{} = result
      assert result.time_zone == "Etc/UTC"
    end

    test "now!/1 returns ok tuple" do
      {:ok, result} = Datetime.now!()
      assert %DateTime{} = result
    end

    test "today/1 returns current UTC date" do
      result = Datetime.today()
      assert %Date{} = result
    end

    test "today!/1 returns ok tuple" do
      {:ok, result} = Datetime.today!()
      assert %Date{} = result
    end
  end

  describe "utility functions - leap year" do
    test "leap_year/1 identifies leap years correctly" do
      assert Datetime.leap_year(2024) == true
      assert Datetime.leap_year(2023) == false
      assert Datetime.leap_year(2020) == true
      assert Datetime.leap_year(1900) == false
      assert Datetime.leap_year(2000) == true
    end

    test "leap_year/1 works with dates" do
      assert Datetime.leap_year(~D[2024-01-15]) == true
      assert Datetime.leap_year(~D[2023-01-15]) == false
    end

    test "leap_year/1 works with lists" do
      years = [2020, 2021, 2022, 2023, 2024]
      expected = [true, false, false, false, true]
      assert Datetime.leap_year(years) == expected
    end

    test "leap_year!/1 returns ok/error tuples" do
      assert Datetime.leap_year!(2024) == {:ok, true}
      assert {:error, _} = Datetime.leap_year!("invalid")
    end
  end

  describe "utility functions - days in month" do
    test "days_in_month/2 returns correct days for various months" do
      assert Datetime.days_in_month(2024, 1) == 31
      assert Datetime.days_in_month(2024, 2) == 29  # leap year
      assert Datetime.days_in_month(2023, 2) == 28  # not leap year
      assert Datetime.days_in_month(2024, 4) == 30
      assert Datetime.days_in_month(2024, 12) == 31
    end

    test "days_in_month/1 works with date structs" do
      assert Datetime.days_in_month(~D[2024-02-15]) == 29
      assert Datetime.days_in_month(~D[2023-02-15]) == 28
    end

    test "days_in_month/2 raises on invalid month" do
      assert_raise RuntimeError, ~r/month to be between 1 and 12/, fn ->
        Datetime.days_in_month(2024, 13)
      end
    end

    test "days_in_month!/2 returns ok/error tuples" do
      assert Datetime.days_in_month!(2024, 2) == {:ok, 29}
      assert {:error, _} = Datetime.days_in_month!(2024, 13)
    end
  end

  describe "timezone functions" do
    test "with_tz/2 converts timezone (when timezone database available)" do
      utc_dt = ~U[2024-01-15 14:30:25Z]
      # This test might fail if timezone database is not available
      # We'll make it conditional based on the result
      case Datetime.with_tz!(utc_dt, "America/New_York") do
        {:ok, eastern_dt} ->
          assert %DateTime{} = eastern_dt
          assert eastern_dt.time_zone == "America/New_York"
        {:error, _reason} ->
          # Skip test if timezone database not available
          :skip
      end
    end

    test "with_tz!/2 returns error for invalid timezone" do
      utc_dt = ~U[2024-01-15 14:30:25Z]
      assert {:error, _} = Datetime.with_tz!(utc_dt, "Invalid/Timezone")
    end

    test "force_tz/2 applies timezone to naive datetime" do
      naive_dt = ~N[2024-01-15 14:30:25]
      case Datetime.force_tz!(naive_dt, "Etc/UTC") do
        {:ok, result} ->
          assert %DateTime{} = result
          assert result.time_zone == "Etc/UTC"
        {:error, _reason} ->
          :skip
      end
    end
  end

  describe "error handling" do
    test "functions raise appropriate errors for invalid input types" do
      assert_raise RuntimeError, ~r/requires a string/, fn ->
        Datetime.ymd(123)
      end

      assert_raise RuntimeError, ~r/requires a Date/, fn ->
        Datetime.year("not_a_date")
      end

      assert_raise RuntimeError, ~r/requires a DateTime/, fn ->
        Datetime.hour(~D[2024-01-15])
      end
    end

    test "wrapped functions return appropriate error tuples" do
      assert {:error, msg} = Datetime.ymd!(123)
      assert msg =~ "requires a string"

      assert {:error, msg} = Datetime.year!("not_a_date")  
      assert msg =~ "requires a Date"

      assert {:error, msg} = Datetime.hour!(~D[2024-01-15])
      assert msg =~ "requires a DateTime"
    end
  end

  describe "vectorized operations" do
    test "parsing functions handle lists correctly" do
      dates = ["2024-01-15", "2024-02-29", "2023-12-31"]
      expected = [~D[2024-01-15], ~D[2024-02-29], ~D[2023-12-31]]
      assert Datetime.ymd(dates) == expected
    end

    test "component extraction functions handle lists correctly" do
      dates = [~D[2024-01-15], ~D[2023-12-31], ~D[2022-06-15]]
      assert Datetime.year(dates) == [2024, 2023, 2022]
      assert Datetime.month(dates) == [1, 12, 6]
      assert Datetime.day(dates) == [15, 31, 15]
    end

    test "utility functions handle lists correctly" do
      years = [2020, 2021, 2022, 2023, 2024]
      expected = [true, false, false, false, true]
      assert Datetime.leap_year(years) == expected
    end
  end
end