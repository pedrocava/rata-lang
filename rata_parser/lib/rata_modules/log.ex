defmodule RataModules.Log do
  @moduledoc """
  Logging module for the Rata programming language.
  
  Provides basic logging functionality with different levels following
  Rata's design principles:
  - All values are vectors (no scalars)
  - 1-indexed arrays
  - Immutable by default
  - Data-first philosophy
  """

  @doc """
  Log an info message and return nil.
  """
  def info(message) do
    IO.puts("[INFO] #{message}")
    {:ok, nil}
  end

  @doc """
  Log a debug message and return nil.
  """
  def debug(message) do
    IO.puts("[DEBUG] #{message}")
    {:ok, nil}
  end

  @doc """
  Log a warning message and return nil.
  """
  def warn(message) do
    IO.puts("[WARN] #{message}")
    {:ok, nil}
  end

  @doc """
  Log an error message and return nil.
  """
  def error(message) do
    IO.puts("[ERROR] #{message}")
    {:ok, nil}
  end

  @doc """
  Log a message with custom level and return nil.
  """
  def log(level, message) when is_binary(level) do
    IO.puts("[#{String.upcase(level)}] #{message}")
    {:ok, nil}
  end
  def log(level, message) when is_atom(level) do
    IO.puts("[#{String.upcase(Atom.to_string(level))}] #{message}")
    {:ok, nil}
  end
  def log(level, message) do
    IO.puts("[#{inspect(level)}] #{message}")
    {:ok, nil}
  end
end