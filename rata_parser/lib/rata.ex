defmodule Rata do
  @moduledoc """
  Main entry point for the Rata CLI application.
  
  This module serves as the escript main function and delegates 
  to the RataCli module for command processing.
  """
  
  @doc """
  Main entry point for the escript.
  
  This function is called when the rata command is executed.
  """
  def main(argv) do
    ExCLI.run(argv, RataCli)
  end
end