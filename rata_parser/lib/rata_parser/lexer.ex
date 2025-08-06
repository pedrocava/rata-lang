defmodule RataParser.Lexer do
  @moduledoc """
  Lexer for the Rata programming language using NimbleParsec.
  
  Tokenizes Rata source code into a stream of tokens for parsing.
  """

  import NimbleParsec

  # Whitespace and comments
  whitespace = 
    choice([
      ascii_char([?\s, ?\t]),
      string("\r\n"),
      ascii_char([?\r, ?\n])
    ])
    |> times(min: 1)
    |> ignore()

  comment = 
    string("#")
    |> repeat(ascii_char([{:not, ?\n}]))
    |> ignore()

  # Keywords
  keywords = 
    choice([
      string("library") |> replace(:library),
      string("module") |> replace(:module),
      string("function") |> replace(:function),
      string("return") |> replace(:return),
      string("if") |> replace(:if),
      string("else") |> replace(:else),
      string("case") |> replace(:case),
      string("as") |> replace(:as),
      string("assert") |> replace(:assert),
      string("try") |> replace(:try),
      string("catch") |> replace(:catch),
      string("raise") |> replace(:raise),
      string("reraise") |> replace(:reraise),
      string("after") |> replace(:after),
      string("when") |> replace(:when),
      string("posint") |> replace(:posint),
      string("numeric") |> replace(:numeric),
      string("int") |> replace(:int),
      string("string") |> replace(:string),
      string("bool") |> replace(:bool)
    ])

  # Operators
  pipe_op = string("|>") |> replace(:pipe)
  lambda_op = string("~") |> replace(:lambda)
  range_op = string("..") |> replace(:range)
  
  operators = 
    choice([
      pipe_op,
      lambda_op,
      range_op,
      string("->") |> replace(:arrow),
      string("==") |> replace(:equal),
      string("!=") |> replace(:not_equal),
      string("<=") |> replace(:less_equal),
      string("%%") |> replace(:modulo),
      string("=") |> replace(:assign),
      string("+") |> replace(:plus),
      string("-") |> replace(:minus),
      string("*") |> replace(:multiply),
      string("^") |> replace(:power),
      string(">") |> replace(:greater)
    ])

  # Delimeters
  set_start = string("#{") |> replace(:set_start)
  
  delimiters = 
    choice([
      set_start,
      string("{") |> replace(:left_brace),
      string("}") |> replace(:right_brace),
      string("[") |> replace(:left_bracket),
      string("]") |> replace(:right_bracket),
      string("(") |> replace(:left_paren),
      string(")") |> replace(:right_paren),
      string(":") |> replace(:colon),
      string(",") |> replace(:comma),
      string(".") |> replace(:dot)
    ])

  # Numbers
  integer = 
    optional(string("-"))
    |> ascii_string([?0..?9], min: 1)
    |> reduce({__MODULE__, :to_integer, []})
    |> unwrap_and_tag(:integer)

  float = 
    optional(string("-"))
    |> ascii_string([?0..?9], min: 1)
    |> string(".")
    |> ascii_string([?0..?9], min: 1)
    |> reduce({__MODULE__, :to_float, []})
    |> unwrap_and_tag(:float)

  # Strings
  string_literal = 
    ignore(string("\""))
    |> repeat(
      choice([
        string("\\\"") |> replace(?"),
        string("\\\\") |> replace(?\\),
        string("\\n") |> replace(?\n),
        string("\\t") |> replace(?\t),
        string("\\r") |> replace(?\r),
        ascii_char([{:not, ?"}, {:not, ?\\}])
      ])
    )
    |> ignore(string("\""))
    |> reduce({__MODULE__, :to_string, []})
    |> unwrap_and_tag(:string)

  # F-strings (interpolated strings) - capture content for later parsing
  f_string = 
    string("f\"")
    |> repeat(
      choice([
        string("\\\""),
        string("\\\\"),
        string("\\{"),
        string("\\}"),
        ascii_char([{:not, ?"}])
      ])
    )
    |> string("\"")
    |> reduce({__MODULE__, :to_f_string, []})
    |> unwrap_and_tag(:f_string)

  # Special identifiers
  module_ref = string("__module__") |> replace({:module_ref, "__module__"})

  # Symbols
  symbol = 
    string(":")
    |> ascii_char([?a..?z, ?A..?Z, ?_])
    |> repeat(ascii_char([?a..?z, ?A..?Z, ?0..?9, ?_]))
    |> reduce({__MODULE__, :to_symbol, []})
    |> unwrap_and_tag(:symbol)

  # Lambda parameters (.x, .y, etc.)
  lambda_param = 
    string(".")
    |> ascii_char([?a..?z, ?A..?Z])
    |> repeat(ascii_char([?a..?z, ?A..?Z, ?0..?9, ?_]))
    |> reduce({__MODULE__, :to_lambda_param, []})
    |> unwrap_and_tag(:lambda_param)

  # Underscore wildcard (must come before identifier)
  underscore = string("_") |> replace(:underscore)

  # Regular identifiers
  identifier = 
    ascii_char([?a..?z, ?A..?Z, ?_])
    |> repeat(ascii_char([?a..?z, ?A..?Z, ?0..?9, ?_]))
    |> reduce({Enum, :join, [""]})
    |> unwrap_and_tag(:identifier)

  # Token definitions in order of precedence
  token = 
    choice([
      f_string,
      string_literal,
      float,
      integer,
      keywords,
      symbol,
      lambda_param,
      module_ref,
      underscore,
      identifier,
      operators,
      delimiters
    ])

  # Main tokenizer with whitespace/comment handling
  defparsec :tokenize, 
    repeat(
      choice([
        whitespace,
        comment,
        token
      ])
    )
    |> eos()

  # Helper functions for token conversion
  def to_integer(parts) do
    parts
    |> Enum.join("")
    |> String.to_integer()
  end

  def to_float(parts) do
    parts
    |> Enum.join("")
    |> String.to_float()
  end

  def to_symbol([_colon | rest]) do
    rest
    |> Enum.join("")
  end

  def to_lambda_param([_dot | rest]) do
    rest
    |> Enum.join("")
  end

  def to_string(chars) do
    chars
    |> List.to_string()
  end

  def to_f_string(parts) do
    parts
    |> Enum.join("")
  end
end