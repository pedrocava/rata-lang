defmodule RataModules.Table do
  @moduledoc """
  Table module for the Rata programming language (temporarily stubbed for CLI compilation).
  """

  # Stub all functions to return error messages
  def new(_), do: {:error, "Table module temporarily disabled"}
  def from_list(_), do: {:error, "Table module temporarily disabled"}
  def select(_, _), do: {:error, "Table module temporarily disabled"}
  def filter(_, _), do: {:error, "Table module temporarily disabled"}
  def mutate(_, _), do: {:error, "Table module temporarily disabled"}
  def arrange(_, _), do: {:error, "Table module temporarily disabled"}
  def slice(_, _), do: {:error, "Table module temporarily disabled"}
  def head(_, _ \\ 6), do: {:error, "Table module temporarily disabled"}
  def tail(_, _ \\ 6), do: {:error, "Table module temporarily disabled"}
  def nrows(_), do: {:error, "Table module temporarily disabled"}
  def ncols(_), do: {:error, "Table module temporarily disabled"}
  def names(_), do: {:error, "Table module temporarily disabled"}
  def print(_), do: {:error, "Table module temporarily disabled"}
  def summarise(_, _), do: {:error, "Table module temporarily disabled"}
  def group_by(_, _), do: {:error, "Table module temporarily disabled"}
  def count(_), do: {:error, "Table module temporarily disabled"}
end