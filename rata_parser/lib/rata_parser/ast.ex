defmodule RataParser.AST do
  @moduledoc """
  Abstract Syntax Tree node definitions for the Rata language.
  """

  # Documentation node
  defmodule Docstring do
    @moduledoc "Represents docstring literals: \"\"\"documentation\"\"\""
    defstruct [:content, :metadata]
    @type t :: %__MODULE__{content: String.t(), metadata: map()}
  end

  # Top-level nodes
  defmodule Module do
    @moduledoc "Represents a module declaration: module Name { ... }"
    defstruct [:name, :body, :docstring, imports: []]
    @type t :: %__MODULE__{name: String.t(), body: [Statement.t()], docstring: Docstring.t() | nil, imports: [LibraryImport.t()]}
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
    defstruct [:name, :params, :body, :docstring]
    @type t :: %__MODULE__{name: String.t(), params: [Parameter.t()], body: [Statement.t()], docstring: Docstring.t() | nil}
  end

  defmodule Return do
    @moduledoc "Represents return statement: return value"
    defstruct [:value]
    @type t :: %__MODULE__{value: Expression.t()}
  end

  defmodule AssertStatement do
    @moduledoc "Represents assert statement: assert condition"
    defstruct [:condition]
    @type t :: %__MODULE__{condition: Expression.t()}
  end

  defmodule TryExpression do
    @moduledoc "Represents try expression: try { body } catch { clauses } after { cleanup }"
    defstruct [:body, :catch_clauses, :else_clause, :after_clause, :exception_var]
    @type t :: %__MODULE__{
            body: [Statement.t()],
            catch_clauses: [CatchClause.t()],
            else_clause: [Statement.t()] | nil,
            after_clause: [Statement.t()] | nil,
            exception_var: String.t() | nil
          }
  end

  defmodule CatchClause do
    @moduledoc "Represents catch clause: exception_pattern -> body"
    defstruct [:pattern, :guard, :body]
    @type t :: %__MODULE__{
            pattern: Expression.t(),
            guard: Expression.t() | nil,
            body: [Statement.t()]
          }
  end

  defmodule RaiseStatement do
    @moduledoc "Represents raise statement: raise exception or raise exception, message"
    defstruct [:exception, :message]
    @type t :: %__MODULE__{exception: Expression.t(), message: Expression.t() | nil}
  end

  defmodule ReraisStatement do
    @moduledoc "Represents reraise statement: reraise or reraise exception, stacktrace"
    defstruct [:exception, :stacktrace]
    @type t :: %__MODULE__{exception: Expression.t() | nil, stacktrace: Expression.t() | nil}
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
    @moduledoc "Represents list literals: {1, :two, \"three\"}, {:ok, value}"
    defstruct [:elements]
    @type t :: %__MODULE__{elements: [Expression.t()]}
  end

  defmodule Set do
    @moduledoc "Represents set literals: {1, 2, 3}"
    defstruct [:elements]
    @type t :: %__MODULE__{elements: [Expression.t()]}
  end

  defmodule Vector do
    @moduledoc "Represents vector literals (homogeneous): [1, 2, 3], [:ok, :error]"
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

  defmodule Underscore do
    @moduledoc "Represents underscore wildcard pattern: _"
    defstruct []
    @type t :: %__MODULE__{}
  end

  defmodule CaseExpression do
    @moduledoc "Represents case expressions: case value { pattern -> result, pattern -> result }"
    defstruct [:subject, :clauses]
    @type t :: %__MODULE__{subject: Expression.t(), clauses: [CaseClause.t()]}
  end

  defmodule CaseClause do
    @moduledoc "Represents case clause: pattern -> result or pattern when guard -> result"
    defstruct [:pattern, :guard, :body]
    @type t :: %__MODULE__{
            pattern: Pattern.t(),
            guard: Expression.t() | nil,
            body: Expression.t()
          }
  end

  defmodule Pipe do
    @moduledoc "Represents pipe operations: left \\> right"
    defstruct [:left, :right]
    @type t :: %__MODULE__{left: Expression.t(), right: Expression.t()}
  end

  # Pattern types for pattern matching
  defmodule TuplePattern do
    @moduledoc "Represents list patterns in case expressions: {:ok, value}"
    defstruct [:elements]
    @type t :: %__MODULE__{elements: [Pattern.t()]}
  end

  defmodule SymbolPattern do
    @moduledoc "Represents symbol patterns: :ok, :error"
    defstruct [:name]
    @type t :: %__MODULE__{name: String.t()}
  end

  defmodule LiteralPattern do
    @moduledoc "Represents literal patterns: 42, \"hello\""
    defstruct [:value]
    @type t :: %__MODULE__{value: number() | String.t()}
  end

  defmodule IdentifierPattern do
    @moduledoc "Represents variable binding patterns: x, value"
    defstruct [:name]
    @type t :: %__MODULE__{name: String.t()}
  end

  defmodule WildcardPattern do
    @moduledoc "Represents wildcard patterns: _"
    defstruct []
    @type t :: %__MODULE__{}
  end

  # Support types
  defmodule Parameter do
    @moduledoc "Represents function parameters with optional type annotations"
    defstruct [:name, :type]
    @type t :: %__MODULE__{name: String.t(), type: String.t() | nil}
  end

  # Type unions for convenience - temporarily commented out to fix compilation
  # @type Statement :: LibraryImport.t() | Assignment.t() | FunctionDef.t() | Return.t() | AssertStatement.t() | RaiseStatement.t() | ReraisStatement.t()
  # @type Expression :: Literal.t() | InterpolatedString.t() | Docstring.t() | Symbol.t() | Tuple.t() | Set.t() | Vector.t() | Range.t() | Map.t() | Identifier.t() | QualifiedIdentifier.t() | FunctionCall.t() | BinaryOp.t() | If.t() | Function.t() | Lambda.t() | LambdaParam.t() | Pipe.t() | TryExpression.t() | CaseExpression.t() | Underscore.t()
  # @type Pattern :: TuplePattern.t() | SymbolPattern.t() | LiteralPattern.t() | IdentifierPattern.t() | WildcardPattern.t()
end