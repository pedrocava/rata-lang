defmodule RataRepl.Evaluator do
  @moduledoc """
  Evaluator for Rata AST nodes in REPL context (temporarily stubbed for CLI compilation).
  """

  def eval(_ast, context \\ %{}) do
    {:error, "Evaluator temporarily disabled"}
  end
end