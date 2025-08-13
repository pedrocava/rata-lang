defmodule RataParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :rata_parser,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: Rata]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nimble_parsec, "~> 1.4"},
      {:ex_cli, "~> 0.1.0"},
      {:jason, "~> 1.4"}
    ]
  end
end