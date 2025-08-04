defmodule RataModules.ListTest do
  use ExUnit.Case
  doctest RataModules.List

  alias RataModules.List

  describe "first/1" do
    test "returns first element of non-empty list" do
      assert {:ok, 1} = List.first([1, 2, 3])
      assert {:ok, :a} = List.first([:a, :b, :c])
      assert {:ok, "hello"} = List.first(["hello", "world"])
    end

    test "returns nil for empty list" do
      assert {:ok, nil} = List.first([])
    end

    test "returns error for non-list input" do
      assert {:error, _} = List.first("not a list")
      assert {:error, _} = List.first(123)
      assert {:error, _} = List.first(nil)
    end
  end

  describe "rest/1" do
    test "returns tail of non-empty list" do
      assert {:ok, [2, 3]} = List.rest([1, 2, 3])
      assert {:ok, [:b, :c]} = List.rest([:a, :b, :c])
      assert {:ok, []} = List.rest([1])
    end

    test "returns empty list for empty list" do
      assert {:ok, []} = List.rest([])
    end

    test "returns error for non-list input" do
      assert {:error, _} = List.rest("not a list")
      assert {:error, _} = List.rest(123)
    end
  end

  describe "last/1" do
    test "returns last element of non-empty list" do
      assert {:ok, 3} = List.last([1, 2, 3])
      assert {:ok, :c} = List.last([:a, :b, :c])
      assert {:ok, 1} = List.last([1])
    end

    test "returns nil for empty list" do
      assert {:ok, nil} = List.last([])
    end

    test "returns error for non-list input" do
      assert {:error, _} = List.last("not a list")
      assert {:error, _} = List.last(123)
    end
  end

  describe "is_empty/1" do
    test "returns true for empty list" do
      assert {:ok, true} = List.is_empty([])
    end

    test "returns false for non-empty list" do
      assert {:ok, false} = List.is_empty([1])
      assert {:ok, false} = List.is_empty([1, 2, 3])
    end

    test "returns error for non-list input" do
      assert {:error, _} = List.is_empty("not a list")
      assert {:error, _} = List.is_empty(123)
    end
  end

  describe "length/1" do
    test "returns correct length for lists" do
      assert {:ok, 0} = List.length([])
      assert {:ok, 1} = List.length([1])
      assert {:ok, 3} = List.length([1, 2, 3])
      assert {:ok, 5} = List.length([:a, :b, :c, :d, :e])
    end

    test "returns error for non-list input" do
      assert {:error, _} = List.length("not a list")
      assert {:error, _} = List.length(123)
    end
  end

  describe "prepend/2" do
    test "prepends element to list" do
      assert {:ok, [1, 2, 3]} = List.prepend([2, 3], 1)
      assert {:ok, [:a, :b]} = List.prepend([:b], :a)
      assert {:ok, [1]} = List.prepend([], 1)
    end

    test "returns error for non-list first argument" do
      assert {:error, _} = List.prepend("not a list", 1)
      assert {:error, _} = List.prepend(123, 1)
    end
  end

  describe "append/2" do
    test "appends element to list" do
      assert {:ok, [1, 2, 3]} = List.append([1, 2], 3)
      assert {:ok, [:a, :b]} = List.append([:a], :b)
      assert {:ok, [1]} = List.append([], 1)
    end

    test "returns error for non-list first argument" do
      assert {:error, _} = List.append("not a list", 1)
      assert {:error, _} = List.append(123, 1)
    end
  end

  describe "concat/2" do
    test "concatenates two lists" do
      assert {:ok, [1, 2, 3, 4]} = List.concat([1, 2], [3, 4])
      assert {:ok, [1, 2]} = List.concat([], [1, 2])
      assert {:ok, [1, 2]} = List.concat([1, 2], [])
      assert {:ok, []} = List.concat([], [])
    end

    test "returns error for non-list arguments" do
      assert {:error, _} = List.concat("not a list", [1, 2])
      assert {:error, _} = List.concat([1, 2], "not a list")
      assert {:error, _} = List.concat(123, 456)
    end
  end

  describe "reverse/1" do
    test "reverses list order" do
      assert {:ok, [3, 2, 1]} = List.reverse([1, 2, 3])
      assert {:ok, [:c, :b, :a]} = List.reverse([:a, :b, :c])
      assert {:ok, []} = List.reverse([])
      assert {:ok, [1]} = List.reverse([1])
    end

    test "returns error for non-list input" do
      assert {:error, _} = List.reverse("not a list")
      assert {:error, _} = List.reverse(123)
    end
  end

  describe "take/2" do
    test "takes first n elements" do
      assert {:ok, [1, 2]} = List.take([1, 2, 3, 4], 2)
      assert {:ok, [1, 2, 3, 4]} = List.take([1, 2, 3, 4], 4)
      assert {:ok, [1, 2, 3, 4]} = List.take([1, 2, 3, 4], 10)
      assert {:ok, []} = List.take([1, 2, 3], 0)
      assert {:ok, []} = List.take([], 3)
    end

    test "returns error for negative n" do
      assert {:error, _} = List.take([1, 2, 3], -1)
    end

    test "returns error for non-integer n" do
      assert {:error, _} = List.take([1, 2, 3], "not an integer")
      assert {:error, _} = List.take([1, 2, 3], 3.14)
    end

    test "returns error for non-list first argument" do
      assert {:error, _} = List.take("not a list", 2)
      assert {:error, _} = List.take(123, 2)
    end
  end

  describe "drop/2" do
    test "drops first n elements" do
      assert {:ok, [3, 4]} = List.drop([1, 2, 3, 4], 2)
      assert {:ok, []} = List.drop([1, 2, 3, 4], 4)
      assert {:ok, []} = List.drop([1, 2, 3, 4], 10)
      assert {:ok, [1, 2, 3]} = List.drop([1, 2, 3], 0)
      assert {:ok, []} = List.drop([], 3)
    end

    test "returns error for negative n" do
      assert {:error, _} = List.drop([1, 2, 3], -1)
    end

    test "returns error for non-integer n" do
      assert {:error, _} = List.drop([1, 2, 3], "not an integer")
      assert {:error, _} = List.drop([1, 2, 3], 3.14)
    end

    test "returns error for non-list first argument" do
      assert {:error, _} = List.drop("not a list", 2)
      assert {:error, _} = List.drop(123, 2)
    end
  end

  describe "at/2" do
    test "returns element at 1-based index" do
      assert {:ok, 1} = List.at([1, 2, 3], 1)
      assert {:ok, 2} = List.at([1, 2, 3], 2)
      assert {:ok, 3} = List.at([1, 2, 3], 3)
      assert {:ok, :a} = List.at([:a, :b, :c], 1)
    end

    test "returns nil for out of bounds index" do
      assert {:ok, nil} = List.at([1, 2, 3], 5)
      assert {:ok, nil} = List.at([], 1)
    end

    test "returns error for 0 or negative index (1-based indexing)" do
      assert {:error, msg} = List.at([1, 2, 3], 0)
      assert msg =~ "1-based indexing"
      
      assert {:error, msg} = List.at([1, 2, 3], -1)
      assert msg =~ "1-based indexing"
    end

    test "returns error for non-integer index" do
      assert {:error, _} = List.at([1, 2, 3], "not an integer")
      assert {:error, _} = List.at([1, 2, 3], 3.14)
    end

    test "returns error for non-list first argument" do
      assert {:error, _} = List.at("not a list", 1)
      assert {:error, _} = List.at(123, 1)
    end
  end
end