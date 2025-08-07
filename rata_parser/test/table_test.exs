defmodule RataModules.TableTest do
  use ExUnit.Case
  doctest RataModules.Table

  alias RataModules.Table

  describe "new/1" do
    test "creates table from map of column data" do
      data = %{"x" => [1, 2, 3], "y" => ["a", "b", "c"]}
      assert {:ok, table} = Table.new(data)
      assert {:ok, 3} = Table.nrows(table)
      assert {:ok, 2} = Table.ncols(table)
      assert {:ok, ["x", "y"]} = Table.names(table)
    end

    test "creates empty table from empty map" do
      assert {:ok, table} = Table.new(%{})
      assert {:ok, 0} = Table.nrows(table)
      assert {:ok, 0} = Table.ncols(table)
    end

    test "returns error for non-map input" do
      assert {:error, _} = Table.new([1, 2, 3])
      assert {:error, _} = Table.new("not a map")
      assert {:error, _} = Table.new(123)
    end
  end

  describe "from_list/1" do
    test "creates table from list of maps" do
      data = [%{"x" => 1, "y" => "a"}, %{"x" => 2, "y" => "b"}, %{"x" => 3, "y" => "c"}]
      assert {:ok, table} = Table.from_list(data)
      assert {:ok, 3} = Table.nrows(table)
      assert {:ok, 2} = Table.ncols(table)
    end

    test "creates empty table from empty list" do
      assert {:ok, table} = Table.from_list([])
      assert {:ok, 0} = Table.nrows(table)
      assert {:ok, 0} = Table.ncols(table)
    end

    test "returns error for non-list input" do
      assert {:error, _} = Table.from_list(%{x: 1})
      assert {:error, _} = Table.from_list("not a list")
    end
  end

  describe "select/2" do
    setup do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3], "y" => ["a", "b", "c"], "z" => [10, 20, 30]})
      {:ok, table: table}
    end

    test "selects columns by name", %{table: table} do
      assert {:ok, selected} = Table.select(table, ["x", "z"])
      assert {:ok, 2} = Table.ncols(selected)
      assert {:ok, ["x", "z"]} = Table.names(selected)
    end

    test "selects single column by name", %{table: table} do
      assert {:ok, selected} = Table.select(table, "x")
      assert {:ok, 1} = Table.ncols(selected)
      assert {:ok, ["x"]} = Table.names(selected)
    end

    test "selects columns by 1-indexed position", %{table: table} do
      assert {:ok, selected} = Table.select(table, [1, 3])  # x and z columns
      assert {:ok, 2} = Table.ncols(selected)
      assert {:ok, ["x", "z"]} = Table.names(selected)
    end

    test "returns error for invalid column names", %{table: table} do
      assert {:error, _} = Table.select(table, ["nonexistent"])
    end

    test "returns error for out-of-bounds column positions", %{table: table} do
      assert {:error, _} = Table.select(table, [5])  # Only 3 columns
    end

    test "returns error for 0-indexed position", %{table: table} do
      assert {:error, _} = Table.select(table, [0])  # Rata uses 1-indexing
    end
  end

  describe "slice/3" do
    setup do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3, 4, 5], "y" => ["a", "b", "c", "d", "e"]})
      {:ok, table: table}
    end

    test "slices rows with 1-indexed positions", %{table: table} do
      assert {:ok, sliced} = Table.slice(table, 2, 4)  # Rows 2-4 (1-indexed)
      assert {:ok, 3} = Table.nrows(sliced)
    end

    test "returns error for invalid indices" do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3]})
      assert {:error, _} = Table.slice(table, 0, 2)  # 0-indexed not allowed
      assert {:error, _} = Table.slice(table, -1, 2)  # Negative not allowed
      assert {:error, _} = Table.slice(table, "a", 2)  # String not allowed
    end
  end

  describe "head/2 and tail/2" do
    setup do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3, 4, 5, 6, 7, 8], "y" => ["a", "b", "c", "d", "e", "f", "g", "h"]})
      {:ok, table: table}
    end

    test "head returns first n rows", %{table: table} do
      assert {:ok, head_table} = Table.head(table, 3)
      assert {:ok, 3} = Table.nrows(head_table)
    end

    test "head uses default of 6 rows", %{table: table} do
      assert {:ok, head_table} = Table.head(table)
      assert {:ok, 6} = Table.nrows(head_table)
    end

    test "tail returns last n rows", %{table: table} do
      assert {:ok, tail_table} = Table.tail(table, 3)
      assert {:ok, 3} = Table.nrows(tail_table)
    end

    test "tail uses default of 6 rows", %{table: table} do
      assert {:ok, tail_table} = Table.tail(table)
      assert {:ok, 6} = Table.nrows(tail_table)
    end

    test "returns error for negative n" do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3]})
      assert {:error, _} = Table.head(table, -1)
      assert {:error, _} = Table.tail(table, -1)
    end
  end

  describe "nrows/1, ncols/1, names/1" do
    test "returns correct dimensions and names" do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3], "y" => ["a", "b", "c"], "z" => [10, 20, 30]})
      
      assert {:ok, 3} = Table.nrows(table)
      assert {:ok, 3} = Table.ncols(table)
      assert {:ok, names} = Table.names(table)
      assert length(names) == 3
      assert "x" in names
      assert "y" in names
      assert "z" in names
    end

    test "handles empty table" do
      {:ok, table} = Table.new(%{})
      
      assert {:ok, 0} = Table.nrows(table)
      assert {:ok, 0} = Table.ncols(table)
      assert {:ok, []} = Table.names(table)
    end
  end

  describe "print/1" do
    test "prints table and returns it" do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3], "y" => ["a", "b", "c"]})
      
      # Capture IO to test printing
      import ExUnit.CaptureIO
      
      result = capture_io(fn ->
        assert {:ok, returned_table} = Table.print(table)
        assert returned_table == table
      end)
      
      # Should have printed something
      assert String.length(result) > 0
    end
  end

  describe "group_by/2" do
    setup do
      {:ok, table} = Table.new(%{
        "category" => ["A", "A", "B", "B"],
        "value" => [1, 2, 3, 4]
      })
      {:ok, table: table}
    end

    test "groups by single column", %{table: table} do
      assert {:ok, _grouped} = Table.group_by(table, ["category"])
    end

    test "groups by single column (non-list)", %{table: table} do
      assert {:ok, _grouped} = Table.group_by(table, "category")
    end

    test "groups by multiple columns", %{table: table} do
      {:ok, extended_table} = Table.new(%{
        "category" => ["A", "A", "B", "B"],
        "region" => ["X", "Y", "X", "Y"],
        "value" => [1, 2, 3, 4]
      })
      assert {:ok, _grouped} = Table.group_by(extended_table, ["category", "region"])
    end
  end

  describe "count/1" do
    test "counts rows in ungrouped table" do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3, 4, 5]})
      assert {:ok, _count_table} = Table.count(table)
    end

    test "counts rows in grouped table" do
      {:ok, table} = Table.new(%{
        "category" => ["A", "A", "B", "B"],
        "value" => [1, 2, 3, 4]
      })
      {:ok, grouped} = Table.group_by(table, ["category"])
      assert {:ok, _count_table} = Table.count(grouped)
    end
  end

  describe "joins" do
    setup do
      {:ok, left_table} = Table.new(%{
        "id" => [1, 2, 3],
        "name" => ["Alice", "Bob", "Charlie"]
      })
      {:ok, right_table} = Table.new(%{
        "id" => [1, 2, 4],
        "score" => [85, 92, 78]
      })
      {:ok, left_table: left_table, right_table: right_table}
    end

    test "inner_join", %{left_table: left, right_table: right} do
      assert {:ok, _joined} = Table.inner_join(left, right, ["id"])
    end

    test "left_join", %{left_table: left, right_table: right} do
      assert {:ok, _joined} = Table.left_join(left, right, ["id"])
    end

    test "right_join", %{left_table: left, right_table: right} do
      assert {:ok, _joined} = Table.right_join(left, right, ["id"])
    end

    test "full_join", %{left_table: left, right_table: right} do
      assert {:ok, _joined} = Table.full_join(left, right, ["id"])
    end

    test "returns error for non-list join keys" do
      {:ok, left} = Table.new(%{"id" => [1, 2]})
      {:ok, right} = Table.new(%{"id" => [1, 3]})
      
      assert {:error, _} = Table.inner_join(left, right, "id")
      assert {:error, _} = Table.left_join(left, right, "id")
      assert {:error, _} = Table.right_join(left, right, "id")
      assert {:error, _} = Table.full_join(left, right, "id")
    end
  end

  describe "summarise/2" do
    test "summarises with aggregation functions" do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3, 4, 5]})
      aggregations = %{"total" => {:sum, "x"}, "average" => {:mean, "x"}}
      
      assert {:ok, _summary} = Table.summarise(table, aggregations)
    end

    test "returns error for non-map aggregations" do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3]})
      assert {:error, _} = Table.summarise(table, "not a map")
    end
  end

  describe "arrange/2" do
    setup do
      {:ok, table} = Table.new(%{
        "x" => [3, 1, 2],
        "y" => ["c", "a", "b"]
      })
      {:ok, table: table}
    end

    test "arranges by single column", %{table: table} do
      assert {:ok, _sorted} = Table.arrange(table, ["x"])
    end

    test "arranges by single column (non-list)", %{table: table} do
      assert {:ok, _sorted} = Table.arrange(table, "x")
    end

    test "arranges by multiple columns with directions", %{table: table} do
      sort_spec = [{"x", :asc}, {"y", :desc}]
      assert {:ok, _sorted} = Table.arrange(table, sort_spec)
    end
  end

  describe "filter/2 and mutate/2" do
    setup do
      {:ok, table} = Table.new(%{"x" => [1, 2, 3, 4, 5], "y" => ["a", "b", "c", "d", "e"]})
      {:ok, table: table}
    end

    test "filter with function predicate", %{table: table} do
      predicate = fn row -> row["x"] > 3 end
      assert {:ok, _filtered} = Table.filter(table, predicate)
    end

    test "filter returns error for non-function predicate", %{table: table} do
      assert {:error, _} = Table.filter(table, "not a function")
    end

    test "mutate with column mutations", %{table: table} do
      mutations = %{"z" => fn row -> row["x"] * 2 end}
      assert {:ok, _mutated} = Table.mutate(table, mutations)
    end

    test "mutate returns error for non-map mutations", %{table: table} do
      assert {:error, _} = Table.mutate(table, "not a map")
    end
  end
end