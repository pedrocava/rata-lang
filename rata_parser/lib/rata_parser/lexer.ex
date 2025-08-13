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

  # Operators (compound operators temporarily disabled due to string issues)
  # pipe_op = string("|>") |> replace(:pipe)
  # lambda_op = string("~") |> replace(:lambda)
  # range_op = string("..") |> replace(:range)
  
  operators = 
    choice([
      # pipe_op,       # Temporarily disabled
      # lambda_op,     # Temporarily disabled  
      # range_op,      # Temporarily disabled
      # string("->") |> replace(:arrow),     # Temporarily disabled
      # string("==") |> replace(:equal),     # Temporarily disabled
      # string("!=") |> replace(:not_equal), # Temporarily disabled
      # string("<=") |> replace(:less_equal), # Temporarily disabled
      # string("%%") |> replace(:modulo),    # Temporarily disabled
      ascii_char([?=]) |> replace(:assign),
      ascii_char([?+]) |> replace(:plus),
      ascii_char([?-]) |> replace(:minus),
      ascii_char([?*]) |> replace(:multiply),
      ascii_char([?^]) |> replace(:power),
      ascii_char([?>]) |> replace(:greater)
    ])

  # Delimeters (set_start temporarily disabled due to string issues)
  # set_start = string("#{") |> replace(:set_start)
  
  delimiters = 
    choice([
      # set_start,  # Temporarily disabled
      ascii_char([?{]) |> replace(:left_brace),
      ascii_char([?}]) |> replace(:right_brace),
      ascii_char([?[]) |> replace(:left_bracket),
      ascii_char([?]]) |> replace(:right_bracket),
      ascii_char([?(]) |> replace(:left_paren),
      ascii_char([?)]) |> replace(:right_paren),
      ascii_char([?:]) |> replace(:colon),
      ascii_char([?,]) |> replace(:comma),
      ascii_char([?.]) |> replace(:dot)
    ])

  # Numbers
  integer = 
    optional(ascii_char([?-]))
    |> ascii_string([?0..?9], min: 1)
    |> reduce({__MODULE__, :to_integer, []})
    |> unwrap_and_tag(:integer)

  float = 
    optional(ascii_char([?-]))
    |> ascii_string([?0..?9], min: 1)
    |> ascii_char([?.])
    |> ascii_string([?0..?9], min: 1)
    |> reduce({__MODULE__, :to_float, []})
    |> unwrap_and_tag(:float)

  # Docstrings temporarily removed due to parser complexity

  # Strings (simplified - no escape sequences for now)
  string_literal = 
    ignore(ascii_char([34])) 
    |> repeat(ascii_char([{:not, 34}]))
    |> ignore(ascii_char([34]))
    |> reduce({__MODULE__, :to_string, []})
    |> unwrap_and_tag(:string)

  # F-strings (simplified - no escape sequences for now)
  f_string = 
    ascii_char([?f]) |> ascii_char([34])
    |> repeat(ascii_char([{:not, 34}]))
    |> ascii_char([34])
    |> reduce({__MODULE__, :to_f_string, []})
    |> unwrap_and_tag(:f_string)

  # Special identifiers (temporarily disabled due to string issues)

  # Symbols
  symbol = 
    ascii_char([?:])
    |> ascii_char([?a..?z, ?A..?Z, ?_])
    |> repeat(ascii_char([?a..?z, ?A..?Z, ?0..?9, ?_]))
    |> reduce({__MODULE__, :to_symbol, []})
    |> unwrap_and_tag(:symbol)

  # Lambda parameters (.x, .y, etc.)
  lambda_param = 
    ascii_char([?.])
    |> ascii_char([?a..?z, ?A..?Z])
    |> repeat(ascii_char([?a..?z, ?A..?Z, ?0..?9, ?_]))
    |> reduce({__MODULE__, :to_lambda_param, []})
    |> unwrap_and_tag(:lambda_param)

  # Underscore wildcard (must come before identifier)
  underscore = ascii_char([?_]) |> replace(:underscore)

  # Regular identifiers
  identifier = 
    ascii_char([?a..?z, ?A..?Z, ?_])
    |> repeat(ascii_char([?a..?z, ?A..?Z, ?0..?9, ?_]))
    |> reduce({Enum, :join, []})
    |> unwrap_and_tag(:identifier)

  # Token definitions in order of precedence
  token = 
    choice([
      # docstring,  # Temporarily disabled
      f_string,
      string_literal,
      float,
      integer,
      keywords,
      symbol,
      lambda_param,
      # module_ref,  # Temporarily disabled
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
    |> Enum.join()
    |> String.to_integer()
  end

  def to_float(parts) do
    parts
    |> Enum.join()
    |> String.to_float()
  end

  def to_symbol([_colon | rest]) do
    rest
    |> Enum.join()
  end

  def to_lambda_param([_dot | rest]) do
    rest
    |> Enum.join()
  end

  def to_string(chars) do
    chars
    |> List.to_string()
  end

  def to_f_string(parts) do
    parts
    |> Enum.join()
  end

  def to_docstring(chars) do
    content = chars
    |> List.to_string()
    |> String.trim()
    
    # Return structured docstring data
    %{content: content, type: :docstring}
  end
end