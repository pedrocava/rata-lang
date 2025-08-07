defmodule CoreTest do
  use ExUnit.Case
  alias RataModules.Core

  describe "assert/1" do
    test "succeeds with truthy values" do
      assert Core.assert(true) == {:ok, true}
      assert Core.assert(1) == {:ok, 1}
      assert Core.assert("hello") == {:ok, "hello"}
      assert Core.assert([1, 2, 3]) == {:ok, [1, 2, 3]}
      assert Core.assert(%{key: "value"}) == {:ok, %{key: "value"}}
    end

    test "fails with falsy values" do
      assert Core.assert(false) == {:error, "assertion failed: condition was falsy"}
      assert Core.assert(nil) == {:error, "assertion failed: condition was falsy"}
      assert Core.assert(0) == {:error, "assertion failed: condition was falsy"}
      assert Core.assert(0.0) == {:error, "assertion failed: condition was falsy"}
      assert Core.assert("") == {:error, "assertion failed: condition was falsy"}
    end
  end

  describe "assert/2" do
    test "succeeds with truthy values and custom message" do
      assert Core.assert(true, "should be true") == {:ok, true}
      assert Core.assert(42, "number check") == {:ok, 42}
    end

    test "fails with falsy values and custom message" do
      assert Core.assert(false, "custom error") == {:error, "assertion failed: custom error"}
      assert Core.assert(nil, "nil check") == {:error, "assertion failed: nil check"}
    end
  end

  describe "identity/1" do
    test "returns argument unchanged" do
      assert Core.identity(42) == {:ok, 42}
      assert Core.identity("hello") == {:ok, "hello"}
      assert Core.identity([1, 2, 3]) == {:ok, [1, 2, 3]}
      assert Core.identity(nil) == {:ok, nil}
      assert Core.identity(%{key: "value"}) == {:ok, %{key: "value"}}
    end
  end

  describe "typeof/1" do
    test "returns correct types" do
      assert Core.typeof(nil) == {:ok, :nil}
      assert Core.typeof(true) == {:ok, :boolean}
      assert Core.typeof(false) == {:ok, :boolean}
      assert Core.typeof(42) == {:ok, :integer}
      assert Core.typeof(3.14) == {:ok, :float}
      assert Core.typeof("hello") == {:ok, :string}
      assert Core.typeof(:atom) == {:ok, :symbol}
      assert Core.typeof([1, 2, 3]) == {:ok, :vector}
      assert Core.typeof({:ok, "value"}) == {:ok, :list}
      assert Core.typeof(%{key: "value"}) == {:ok, :map}
      assert Core.typeof(MapSet.new([1, 2, 3])) == {:ok, :set}
      assert Core.typeof(1..10) == {:ok, :range}
    end
  end

  describe "debug/1" do
    test "prints and returns value unchanged" do
      # Capture IO to test debug output
      import ExUnit.CaptureIO
      
      output = capture_io(fn ->
        assert Core.debug(42) == {:ok, 42}
      end)
      
      assert String.contains?(output, "DEBUG: 42")
    end
  end

  describe "debug/2" do
    test "prints with custom label and returns value unchanged" do
      import ExUnit.CaptureIO
      
      output = capture_io(fn ->
        assert Core.debug("hello", "test_label") == {:ok, "hello"}
      end)
      
      assert String.contains?(output, "test_label: \"hello\"")
    end

    test "works with non-string labels" do
      import ExUnit.CaptureIO
      
      output = capture_io(fn ->
        assert Core.debug(42, :my_label) == {:ok, 42}
      end)
      
      assert String.contains?(output, ":my_label: 42")
    end
  end

  describe "exception creation functions" do
    test "exception/1 with atom" do
      assert Core.exception(:test_error) == {:ok, %{exception: :test_error, message: nil, stacktrace: nil}}
    end

    test "exception/1 with string" do
      assert Core.exception("test_error") == {:ok, %{exception: :test_error, message: nil, stacktrace: nil}}
    end

    test "exception/2 with atom and message" do
      assert Core.exception(:test_error, "Something went wrong") == 
        {:ok, %{exception: :test_error, message: "Something went wrong", stacktrace: nil}}
    end

    test "exception/2 with string and message" do
      assert Core.exception("test_error", "Something went wrong") == 
        {:ok, %{exception: :test_error, message: "Something went wrong", stacktrace: nil}}
    end

    test "runtime_error/1" do
      assert Core.runtime_error("Runtime issue") == 
        {:ok, %{exception: :runtime_error, message: "Runtime issue", stacktrace: nil}}
    end

    test "argument_error/1" do
      assert Core.argument_error("Invalid argument") == 
        {:ok, %{exception: :argument_error, message: "Invalid argument", stacktrace: nil}}
    end

    test "type_error/1" do
      assert Core.type_error("Type mismatch") == 
        {:ok, %{exception: :type_error, message: "Type mismatch", stacktrace: nil}}
    end

    test "value_error/1" do
      assert Core.value_error("Invalid value") == 
        {:ok, %{exception: :value_error, message: "Invalid value", stacktrace: nil}}
    end
  end

  describe "exception introspection functions" do
    test "exception_type/1" do
      exception = %{exception: :test_error, message: "test", stacktrace: nil}
      assert Core.exception_type(exception) == {:ok, :test_error}
      assert Core.exception_type("not an exception") == {:error, "not an exception"}
    end

    test "exception_message/1" do
      exception = %{exception: :test_error, message: "test message", stacktrace: nil}
      assert Core.exception_message(exception) == {:ok, "test message"}
      assert Core.exception_message("not an exception") == {:error, "not an exception"}
    end

    test "is_exception/1" do
      exception = %{exception: :test_error, message: "test", stacktrace: nil}
      assert Core.is_exception(exception) == {:ok, true}
      assert Core.is_exception("not an exception") == {:ok, false}
      assert Core.is_exception(%{message: "test"}) == {:ok, false}
    end
  end

  describe "type predicate functions" do
    test "is_list/1" do
      assert Core.is_list([1, 2, 3]) == {:ok, true}
      assert Core.is_list([]) == {:ok, true}
      assert Core.is_list("string") == {:ok, false}
      assert Core.is_list(%{key: "value"}) == {:ok, false}
      assert Core.is_list(42) == {:ok, false}
    end

    test "is_vector/1" do
      # In Rata, vectors are the same as lists
      assert Core.is_vector([1, 2, 3]) == {:ok, true}
      assert Core.is_vector([]) == {:ok, true}
      assert Core.is_vector("string") == {:ok, false}
      assert Core.is_vector(%{key: "value"}) == {:ok, false}
      assert Core.is_vector(42) == {:ok, false}
    end

    test "is_map/1" do
      assert Core.is_map(%{key: "value"}) == {:ok, true}
      assert Core.is_map(%{}) == {:ok, true}
      assert Core.is_map([1, 2, 3]) == {:ok, false}
      assert Core.is_map("string") == {:ok, false}
      assert Core.is_map(42) == {:ok, false}
      # Structs should return false
      assert Core.is_map(MapSet.new()) == {:ok, false}
    end

    test "is_table/1" do
      # This test assumes Explorer is available, but we'll mock it for now
      assert Core.is_table(%{}) == {:ok, false}
      assert Core.is_table([1, 2, 3]) == {:ok, false}
      assert Core.is_table("string") == {:ok, false}
      # Would need actual Explorer.DataFrame to test true case
    end

    test "is_boolean/1" do
      assert Core.is_boolean(true) == {:ok, true}
      assert Core.is_boolean(false) == {:ok, true}
      assert Core.is_boolean(nil) == {:ok, false}
      assert Core.is_boolean(0) == {:ok, false}
      assert Core.is_boolean("true") == {:ok, false}
    end

    test "is_integer/1" do
      assert Core.is_integer(42) == {:ok, true}
      assert Core.is_integer(-17) == {:ok, true}
      assert Core.is_integer(0) == {:ok, true}
      assert Core.is_integer(3.14) == {:ok, false}
      assert Core.is_integer("42") == {:ok, false}
      assert Core.is_integer(nil) == {:ok, false}
    end

    test "is_float/1" do
      assert Core.is_float(3.14) == {:ok, true}
      assert Core.is_float(-2.5) == {:ok, true}
      assert Core.is_float(0.0) == {:ok, true}
      assert Core.is_float(42) == {:ok, false}
      assert Core.is_float("3.14") == {:ok, false}
      assert Core.is_float(nil) == {:ok, false}
    end

    test "is_number/1" do
      assert Core.is_number(42) == {:ok, true}
      assert Core.is_number(3.14) == {:ok, true}
      assert Core.is_number(-17) == {:ok, true}
      assert Core.is_number(0) == {:ok, true}
      assert Core.is_number(0.0) == {:ok, true}
      assert Core.is_number("42") == {:ok, false}
      assert Core.is_number(nil) == {:ok, false}
    end

    test "is_string/1" do
      assert Core.is_string("hello") == {:ok, true}
      assert Core.is_string("") == {:ok, true}
      assert Core.is_string("42") == {:ok, true}
      assert Core.is_string(42) == {:ok, false}
      assert Core.is_string(:atom) == {:ok, false}
      assert Core.is_string(nil) == {:ok, false}
    end

    test "is_symbol/1" do
      assert Core.is_symbol(:atom) == {:ok, true}
      assert Core.is_symbol(:ok) == {:ok, true}
      assert Core.is_symbol(nil) == {:ok, true}  # nil is an atom
      assert Core.is_symbol(true) == {:ok, true} # booleans are atoms
      assert Core.is_symbol(false) == {:ok, true}
      assert Core.is_symbol("string") == {:ok, false}
      assert Core.is_symbol(42) == {:ok, false}
    end

    test "is_list/1" do
      assert Core.is_list({:ok, "value"}) == {:ok, true}
      assert Core.is_list({1, 2, 3}) == {:ok, true}
      assert Core.is_list({}) == {:ok, true}
      assert Core.is_list([1, 2, 3]) == {:ok, false}
      assert Core.is_list(%{key: "value"}) == {:ok, false}
      assert Core.is_list("string") == {:ok, false}
    end

    test "is_set/1" do
      assert Core.is_set(MapSet.new([1, 2, 3])) == {:ok, true}
      assert Core.is_set(MapSet.new()) == {:ok, true}
      assert Core.is_set([1, 2, 3]) == {:ok, false}
      assert Core.is_set(%{key: "value"}) == {:ok, false}
      assert Core.is_set("string") == {:ok, false}
    end

    test "is_range/1" do
      assert Core.is_range(1..10) == {:ok, true}
      assert Core.is_range(5..1) == {:ok, true}
      assert Core.is_range(-5..5) == {:ok, true}
      assert Core.is_range([1, 2, 3]) == {:ok, false}
      assert Core.is_range(%{key: "value"}) == {:ok, false}
      assert Core.is_range("string") == {:ok, false}
    end

    test "is_nil/1" do
      assert Core.is_nil(nil) == {:ok, true}
      assert Core.is_nil(false) == {:ok, false}
      assert Core.is_nil(0) == {:ok, false}
      assert Core.is_nil("") == {:ok, false}
      assert Core.is_nil([]) == {:ok, false}
    end

    test "is_function/1" do
      fun = fn x -> x + 1 end
      assert Core.is_function(fun) == {:ok, true}
      assert Core.is_function(&String.upcase/1) == {:ok, true}
      assert Core.is_function(42) == {:ok, false}
      assert Core.is_function("function") == {:ok, false}
      assert Core.is_function([1, 2, 3]) == {:ok, false}
    end
  end

  describe "is_truthy/1" do
    test "returns true for truthy values" do
      assert Core.is_truthy(true) == {:ok, true}
      assert Core.is_truthy(1) == {:ok, true}
      assert Core.is_truthy(-1) == {:ok, true}
      assert Core.is_truthy(3.14) == {:ok, true}
      assert Core.is_truthy("hello") == {:ok, true}
      assert Core.is_truthy(" ") == {:ok, true}
      assert Core.is_truthy([1, 2, 3]) == {:ok, true}
      assert Core.is_truthy([]) == {:ok, true}
      assert Core.is_truthy(%{key: "value"}) == {:ok, true}
      assert Core.is_truthy(%{}) == {:ok, true}
      assert Core.is_truthy(:atom) == {:ok, true}
    end

    test "returns false for falsy values" do
      assert Core.is_truthy(nil) == {:ok, false}
      assert Core.is_truthy(false) == {:ok, false}
      assert Core.is_truthy(0) == {:ok, false}
      assert Core.is_truthy(0.0) == {:ok, false}
      assert Core.is_truthy("") == {:ok, false}
    end
  end
end