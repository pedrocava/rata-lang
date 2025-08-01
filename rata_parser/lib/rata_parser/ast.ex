defmodule RataParser.AST do
  @moduledoc """
  Abstract Syntax Tree node definitions for the Rata language.
  """

  # Top-level nodes
  defmodule Module do
    @moduledoc "Represents a module declaration: module Name { ... }"
    defstruct [:name, :body, imports: []]
    @type t :: %__MODULE__{name: String.t(), body: [Statement.t()], imports: [LibraryImport.t()]}
  end

  # Statement types
  defmodule LibraryImport do
    @moduledoc "Represents library import: library ModuleName as alias"
    defstruct [:module_name, :alias]
    @type t :: %__MODULE__{module_name: String.t(), alias: String.t() | nil}
  end

  defmodule Assignment do
    @moduledoc "Represents variable assignment: name = value"
    defstruct [:name, :value]
    @type t :: %__MODULE__{name: String.t(), value: Expression.t()}
  end

  defmodule FunctionDef do
    @moduledoc "Represents function definition: name = function params { body }"
    defstruct [:name, :params, :body]
    @type t :: %__MODULE__{name: String.t(), params: [Parameter.t()], body: [Statement.t()]}
  end

  defmodule Return do
    @moduledoc "Represents return statement: return value"
    defstruct [:value]
    @type t :: %__MODULE__{value: Expression.t()}
  end

  # Expression types
  defmodule Literal do
    @moduledoc "Represents literal values: numbers, strings"
    defstruct [:value]
    @type t :: %__MODULE__{value: number() | String.t()}
  end

  defmodule InterpolatedString do
    @moduledoc "Represents f-strings with embedded expressions: f\"Hello {name}\""
    defstruct [:parts]
    @type t :: %__MODULE__{parts: [String.t() | Expression.t()]}
  end

  defmodule Symbol do
    @moduledoc "Represents symbol literals: :ok, :error, :info"
    defstruct [:name]
    @type t :: %__MODULE__{name: String.t()}
  end

  defmodule Tuple do
    @moduledoc "Represents tuple literals: {1, 2, 3}, {:ok, value}"
    defstruct [:elements]
    @type t :: %__MODULE__{elements: [Expression.t()]}
  end

  defmodule Set do
    @moduledoc "Represents set literals: #{1, 2, 3}"
    defstruct [:elements]
    @type t :: %__MODULE__{elements: [Expression.t()]}
  end

  defmodule Vector do
    @moduledoc "Represents vector/list literals: [1, 2, 3]"
    defstruct [:elements]
    @type t :: %__MODULE__{elements: [Expression.t()]}
  end

  defmodule Range do
    @moduledoc "Represents range expressions: 1..10"
    defstruct [:start, :end]
    @type t :: %__MODULE__{start: Expression.t(), end: Expression.t()}
  end

  defmodule Map do
    @moduledoc "Represents map literals with key-value pairs: {key: value, key2: value2}"
    defstruct [:pairs]
    @type t :: %__MODULE__{pairs: [{Expression.t(), Expression.t()}]}
  end

  defmodule Identifier do
    @moduledoc "Represents identifiers: variable names, function names"
    defstruct [:name]
    @type t :: %__MODULE__{name: String.t()}
  end

  defmodule QualifiedIdentifier do
    @moduledoc "Represents qualified identifiers: module.name"
    defstruct [:module, :name]
    @type t :: %__MODULE__{module: String.t(), name: String.t()}
  end

  defmodule FunctionCall do
    @moduledoc "Represents function calls: func(args)"
    defstruct [:function, :args]
    @type t :: %__MODULE__{function: Expression.t(), args: [Expression.t()]}
  end

  defmodule BinaryOp do
    @moduledoc "Represents binary operations: left op right"
    defstruct [:left, :operator, :right]
    @type t :: %__MODULE__{left: Expression.t(), operator: atom(), right: Expression.t()}
  end

  defmodule If do
    @moduledoc "Represents if expressions: if condition { then } else { else }"
    defstruct [:condition, :then_branch, :else_branch]
    @type t :: %__MODULE__{
            condition: Expression.t(),
            then_branch: [Statement.t()],
            else_branch: [Statement.t()] | nil
          }
  end

  defmodule Function do
    @moduledoc "Represents anonymous functions: function params { body }"
    defstruct [:params, :body]
    @type t :: %__MODULE__{params: [Parameter.t()], body: [Statement.t()]}
  end

  defmodule Lambda do
    @moduledoc "Represents lambda expressions: ~ .x + .y"
    defstruct [:body, :params]
    @type t :: %__MODULE__{body: Expression.t(), params: [String.t()]}
  end

  defmodule LambdaParam do
    @moduledoc "Represents lambda parameters: .x, .y, etc."
    defstruct [:name]
    @type t :: %__MODULE__{name: String.t()}
  end

  defmodule Pipe do
    @moduledoc "Represents pipe operations: left \\> right"
    defstruct [:left, :right]
    @type t :: %__MODULE__{left: Expression.t(), right: Expression.t()}
  end

  # Support types
  defmodule Parameter do
    @moduledoc "Represents function parameters with optional type annotations"
    defstruct [:name, :type]
    @type t :: %__MODULE__{name: String.t(), type: String.t() | nil}
  end

  # Type unions for convenience
  @type Statement :: LibraryImport.t() | Assignment.t() | FunctionDef.t() | Return.t()
  @type Expression ::
          Literal.t()
          | InterpolatedString.t()
          | Symbol.t()
          | Tuple.t()
          | Set.t()
          | Vector.t()
          | Range.t()
          | Map.t()
          | Identifier.t()
          | QualifiedIdentifier.t()
          | FunctionCall.t()
          | BinaryOp.t()
          | If.t()
          | Function.t()
          | Lambda.t()
          | LambdaParam.t()
          | Pipe.t()
end