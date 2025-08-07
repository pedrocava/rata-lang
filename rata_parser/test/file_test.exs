defmodule RataModules.FileTest do
  use ExUnit.Case, async: false
  alias RataModules.File

  @test_dir "/tmp/rata_file_test"
  @test_file "/tmp/rata_file_test/test_file.txt"
  @test_content "Hello, Rata!"

  setup do
    # Clean up any existing test files
    if Elixir.File.exists?(@test_dir) do
      Elixir.File.rm_rf!(@test_dir)
    end
    
    # Create test directory
    Elixir.File.mkdir_p!(@test_dir)
    
    on_exit(fn ->
      if Elixir.File.exists?(@test_dir) do
        Elixir.File.rm_rf!(@test_dir)
      end
    end)
    
    :ok
  end

  describe "file operations (unwrapped)" do
    test "file_create/1 creates a new file" do
      assert File.file_create(@test_file) == @test_file
      assert Elixir.File.exists?(@test_file)
    end

    test "file_create/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      assert File.file_create([file1, file2]) == [file1, file2]
      assert Elixir.File.exists?(file1)
      assert Elixir.File.exists?(file2)
    end

    test "file_create/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_create requires a string path/, fn ->
        File.file_create(123)
      end
    end

    test "file_delete/1 removes a file" do
      # Create file first
      Elixir.File.touch!(@test_file)
      
      assert File.file_delete(@test_file) == @test_file
      refute Elixir.File.exists?(@test_file)
    end

    test "file_delete/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      Elixir.File.touch!(file1)
      Elixir.File.touch!(file2)
      
      assert File.file_delete([file1, file2]) == [file1, file2]
      refute Elixir.File.exists?(file1)
      refute Elixir.File.exists?(file2)
    end

    test "file_delete/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_delete requires a string path/, fn ->
        File.file_delete(123)
      end
    end

    test "file_copy/2 copies a file" do
      source = "/tmp/rata_file_test/source.txt"
      dest = "/tmp/rata_file_test/dest.txt"
      
      Elixir.File.write!(source, @test_content)
      
      assert File.file_copy(source, dest) == dest
      assert Elixir.File.exists?(dest)
      assert Elixir.File.read!(dest) == @test_content
    end

    test "file_copy/2 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_copy requires two string paths/, fn ->
        File.file_copy(123, "dest")
      end
    end

    test "file_move/2 moves a file" do
      source = "/tmp/rata_file_test/source.txt"
      dest = "/tmp/rata_file_test/dest.txt"
      
      Elixir.File.write!(source, @test_content)
      
      assert File.file_move(source, dest) == dest
      refute Elixir.File.exists?(source)
      assert Elixir.File.exists?(dest)
      assert Elixir.File.read!(dest) == @test_content
    end

    test "file_move/2 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_move requires two string paths/, fn ->
        File.file_move(123, "dest")
      end
    end

    test "file_exists/1 checks if file exists" do
      assert File.file_exists(@test_file) == false
      
      Elixir.File.touch!(@test_file)
      assert File.file_exists(@test_file) == true
    end

    test "file_exists/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      Elixir.File.touch!(file1)
      # file2 doesn't exist
      
      assert File.file_exists([file1, file2]) == [true, false]
    end

    test "file_exists/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_exists requires a string path/, fn ->
        File.file_exists(123)
      end
    end

    test "file_info/1 returns file metadata" do
      Elixir.File.write!(@test_file, @test_content)
      
      info = File.file_info(@test_file)
      assert is_map(info)
      assert info.size == byte_size(@test_content)
      assert info.type == :regular
    end

    test "file_info/1 raises error for nonexistent file" do
      assert_raise RuntimeError, ~r/Failed to get file info/, fn ->
        File.file_info("/nonexistent/file.txt")
      end
    end

    test "file_info/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_info requires a string path/, fn ->
        File.file_info(123)
      end
    end

    test "file_read/1 reads file contents" do
      Elixir.File.write!(@test_file, @test_content)
      
      assert File.file_read(@test_file) == @test_content
    end

    test "file_read/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      content1 = "content1"
      content2 = "content2"
      
      Elixir.File.write!(file1, content1)
      Elixir.File.write!(file2, content2)
      
      assert File.file_read([file1, file2]) == [content1, content2]
    end

    test "file_read/1 raises error for nonexistent file" do
      assert_raise RuntimeError, ~r/Failed to read file/, fn ->
        File.file_read("/nonexistent/file.txt")
      end
    end

    test "file_read/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_read requires a string path/, fn ->
        File.file_read(123)
      end
    end

    test "file_write/2 writes content to file" do
      assert File.file_write(@test_file, @test_content) == @test_file
      assert Elixir.File.read!(@test_file) == @test_content
    end

    test "file_write/2 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_write requires a string path and string content/, fn ->
        File.file_write(123, "content")
      end
      
      assert_raise RuntimeError, ~r/File.file_write requires a string path and string content/, fn ->
        File.file_write("path", 123)
      end
    end

    test "file_touch/1 updates file timestamps" do
      assert File.file_touch(@test_file) == @test_file
      assert Elixir.File.exists?(@test_file)
    end

    test "file_touch/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      assert File.file_touch([file1, file2]) == [file1, file2]
      assert Elixir.File.exists?(file1)
      assert Elixir.File.exists?(file2)
    end

    test "file_touch/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.file_touch requires a string path/, fn ->
        File.file_touch(123)
      end
    end
  end

  describe "file operations (wrapped)" do
    test "file_create!/1 creates a new file" do
      assert File.file_create!(@test_file) == {:ok, @test_file}
      assert Elixir.File.exists?(@test_file)
    end

    test "file_create!/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      assert File.file_create!([file1, file2]) == {:ok, [file1, file2]}
      assert Elixir.File.exists?(file1)
      assert Elixir.File.exists?(file2)
    end

    test "file_create!/1 returns error for invalid input" do
      assert File.file_create!(123) == {:error, "File.file_create! requires a string path or list of paths, got 123"}
    end

    test "file_delete!/1 removes a file" do
      # Create file first
      Elixir.File.touch!(@test_file)
      
      assert File.file_delete!(@test_file) == {:ok, @test_file}
      refute Elixir.File.exists?(@test_file)
    end

    test "file_delete!/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      Elixir.File.touch!(file1)
      Elixir.File.touch!(file2)
      
      assert File.file_delete!([file1, file2]) == {:ok, [file1, file2]}
      refute Elixir.File.exists?(file1)
      refute Elixir.File.exists?(file2)
    end

    test "file_delete!/1 returns error for invalid input" do
      assert File.file_delete!(123) == {:error, "File.file_delete! requires a string path or list of paths, got 123"}
    end

    test "file_copy!/2 copies a file" do
      source = "/tmp/rata_file_test/source.txt"
      dest = "/tmp/rata_file_test/dest.txt"
      
      Elixir.File.write!(source, @test_content)
      
      assert File.file_copy!(source, dest) == {:ok, dest}
      assert Elixir.File.exists?(dest)
      assert Elixir.File.read!(dest) == @test_content
    end

    test "file_copy!/2 returns error for invalid input" do
      assert File.file_copy!(123, "dest") == {:error, "File.file_copy! requires two string paths, got 123 and \"dest\""}
    end

    test "file_move!/2 moves a file" do
      source = "/tmp/rata_file_test/source.txt"
      dest = "/tmp/rata_file_test/dest.txt"
      
      Elixir.File.write!(source, @test_content)
      
      assert File.file_move!(source, dest) == {:ok, dest}
      refute Elixir.File.exists?(source)
      assert Elixir.File.exists?(dest)
      assert Elixir.File.read!(dest) == @test_content
    end

    test "file_move!/2 returns error for invalid input" do
      assert File.file_move!(123, "dest") == {:error, "File.file_move! requires two string paths, got 123 and \"dest\""}
    end

    test "file_exists!/1 checks if file exists" do
      assert File.file_exists!(@test_file) == {:ok, false}
      
      Elixir.File.touch!(@test_file)
      assert File.file_exists!(@test_file) == {:ok, true}
    end

    test "file_exists!/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      Elixir.File.touch!(file1)
      # file2 doesn't exist
      
      assert File.file_exists!([file1, file2]) == {:ok, [true, false]}
    end

    test "file_exists!/1 returns error for invalid input" do
      assert File.file_exists!(123) == {:error, "File.file_exists! requires a string path or list of paths, got 123"}
    end

    test "file_info!/1 returns file metadata" do
      Elixir.File.write!(@test_file, @test_content)
      
      assert {:ok, info} = File.file_info!(@test_file)
      assert is_map(info)
      assert info.size == byte_size(@test_content)
      assert info.type == :regular
    end

    test "file_info!/1 returns error for nonexistent file" do
      assert {:error, _} = File.file_info!("/nonexistent/file.txt")
    end

    test "file_info!/1 returns error for invalid input" do
      assert File.file_info!(123) == {:error, "File.file_info! requires a string path or list of paths, got 123"}
    end

    test "file_read!/1 reads file contents" do
      Elixir.File.write!(@test_file, @test_content)
      
      assert File.file_read!(@test_file) == {:ok, @test_content}
    end

    test "file_read!/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      content1 = "content1"
      content2 = "content2"
      
      Elixir.File.write!(file1, content1)
      Elixir.File.write!(file2, content2)
      
      assert File.file_read!([file1, file2]) == {:ok, [content1, content2]}
    end

    test "file_read!/1 returns error for nonexistent file" do
      assert {:error, _} = File.file_read!("/nonexistent/file.txt")
    end

    test "file_read!/1 returns error for invalid input" do
      assert File.file_read!(123) == {:error, "File.file_read! requires a string path or list of paths, got 123"}
    end

    test "file_write!/2 writes content to file" do
      assert File.file_write!(@test_file, @test_content) == {:ok, @test_file}
      assert Elixir.File.read!(@test_file) == @test_content
    end

    test "file_write!/2 returns error for invalid input" do
      assert File.file_write!(123, "content") == {:error, "File.file_write! requires a string path and string content, got 123 and \"content\""}
      assert File.file_write!("path", 123) == {:error, "File.file_write! requires a string path and string content, got \"path\" and 123"}
    end

    test "file_touch!/1 updates file timestamps" do
      assert File.file_touch!(@test_file) == {:ok, @test_file}
      assert Elixir.File.exists?(@test_file)
    end

    test "file_touch!/1 works with list of paths" do
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      assert File.file_touch!([file1, file2]) == {:ok, [file1, file2]}
      assert Elixir.File.exists?(file1)
      assert Elixir.File.exists?(file2)
    end

    test "file_touch!/1 returns error for invalid input" do
      assert File.file_touch!(123) == {:error, "File.file_touch! requires a string path or list of paths, got 123"}
    end
  end

  describe "directory operations (unwrapped)" do
    test "dir_create/1 creates a directory" do
      dir_path = "/tmp/rata_file_test/new_dir"
      
      assert File.dir_create(dir_path) == dir_path
      assert Elixir.File.dir?(dir_path)
    end

    test "dir_create/1 works with list of paths" do
      dir1 = "/tmp/rata_file_test/dir1"
      dir2 = "/tmp/rata_file_test/dir2"
      
      assert File.dir_create([dir1, dir2]) == [dir1, dir2]
      assert Elixir.File.dir?(dir1)
      assert Elixir.File.dir?(dir2)
    end

    test "dir_create/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.dir_create requires a string path/, fn ->
        File.dir_create(123)
      end
    end

    test "dir_delete/1 removes a directory" do
      dir_path = "/tmp/rata_file_test/to_delete"
      Elixir.File.mkdir_p!(dir_path)
      
      assert File.dir_delete(dir_path) == dir_path
      refute Elixir.File.exists?(dir_path)
    end

    test "dir_delete/1 works with list of paths" do
      dir1 = "/tmp/rata_file_test/dir1"
      dir2 = "/tmp/rata_file_test/dir2"
      
      Elixir.File.mkdir_p!(dir1)
      Elixir.File.mkdir_p!(dir2)
      
      assert File.dir_delete([dir1, dir2]) == [dir1, dir2]
      refute Elixir.File.exists?(dir1)
      refute Elixir.File.exists?(dir2)
    end

    test "dir_delete/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.dir_delete requires a string path/, fn ->
        File.dir_delete(123)
      end
    end

    test "dir_ls/1 lists directory contents" do
      # Create some test files
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      Elixir.File.touch!(file1)
      Elixir.File.touch!(file2)
      
      files = File.dir_ls(@test_dir)
      assert length(files) == 2
      assert Enum.sort(files) == Enum.sort([file1, file2])
    end

    test "dir_ls/1 raises error for nonexistent directory" do
      assert_raise RuntimeError, ~r/Failed to list directory/, fn ->
        File.dir_ls("/nonexistent/directory")
      end
    end

    test "dir_ls/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.dir_ls requires a string path/, fn ->
        File.dir_ls(123)
      end
    end

    test "dir_exists/1 checks if directory exists" do
      assert File.dir_exists(@test_dir) == true
      assert File.dir_exists("/nonexistent/directory") == false
    end

    test "dir_exists/1 works with list of paths" do
      dir1 = "/tmp/rata_file_test/existing"
      dir2 = "/tmp/rata_file_test/nonexistent"
      
      Elixir.File.mkdir_p!(dir1)
      
      assert File.dir_exists([dir1, dir2]) == [true, false]
    end

    test "dir_exists/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.dir_exists requires a string path/, fn ->
        File.dir_exists(123)
      end
    end
  end

  describe "directory operations (wrapped)" do
    test "dir_create!/1 creates a directory" do
      dir_path = "/tmp/rata_file_test/new_dir"
      
      assert File.dir_create!(dir_path) == {:ok, dir_path}
      assert Elixir.File.dir?(dir_path)
    end

    test "dir_create!/1 works with list of paths" do
      dir1 = "/tmp/rata_file_test/dir1"
      dir2 = "/tmp/rata_file_test/dir2"
      
      assert File.dir_create!([dir1, dir2]) == {:ok, [dir1, dir2]}
      assert Elixir.File.dir?(dir1)
      assert Elixir.File.dir?(dir2)
    end

    test "dir_create!/1 returns error for invalid input" do
      assert File.dir_create!(123) == {:error, "File.dir_create! requires a string path or list of paths, got 123"}
    end

    test "dir_delete!/1 removes a directory" do
      dir_path = "/tmp/rata_file_test/to_delete"
      Elixir.File.mkdir_p!(dir_path)
      
      assert File.dir_delete!(dir_path) == {:ok, dir_path}
      refute Elixir.File.exists?(dir_path)
    end

    test "dir_delete!/1 works with list of paths" do
      dir1 = "/tmp/rata_file_test/dir1"
      dir2 = "/tmp/rata_file_test/dir2"
      
      Elixir.File.mkdir_p!(dir1)
      Elixir.File.mkdir_p!(dir2)
      
      assert File.dir_delete!([dir1, dir2]) == {:ok, [dir1, dir2]}
      refute Elixir.File.exists?(dir1)
      refute Elixir.File.exists?(dir2)
    end

    test "dir_delete!/1 returns error for invalid input" do
      assert File.dir_delete!(123) == {:error, "File.dir_delete! requires a string path or list of paths, got 123"}
    end

    test "dir_ls!/1 lists directory contents" do
      # Create some test files
      file1 = "/tmp/rata_file_test/file1.txt"
      file2 = "/tmp/rata_file_test/file2.txt"
      
      Elixir.File.touch!(file1)
      Elixir.File.touch!(file2)
      
      assert {:ok, files} = File.dir_ls!(@test_dir)
      assert length(files) == 2
      assert Enum.sort(files) == Enum.sort([file1, file2])
    end

    test "dir_ls!/1 returns error for nonexistent directory" do
      assert {:error, _} = File.dir_ls!("/nonexistent/directory")
    end

    test "dir_ls!/1 returns error for invalid input" do
      assert File.dir_ls!(123) == {:error, "File.dir_ls! requires a string path or list of paths, got 123"}
    end

    test "dir_exists!/1 checks if directory exists" do
      assert File.dir_exists!(@test_dir) == {:ok, true}
      assert File.dir_exists!("/nonexistent/directory") == {:ok, false}
    end

    test "dir_exists!/1 works with list of paths" do
      dir1 = "/tmp/rata_file_test/existing"
      dir2 = "/tmp/rata_file_test/nonexistent"
      
      Elixir.File.mkdir_p!(dir1)
      
      assert File.dir_exists!([dir1, dir2]) == {:ok, [true, false]}
    end

    test "dir_exists!/1 returns error for invalid input" do
      assert File.dir_exists!(123) == {:error, "File.dir_exists! requires a string path or list of paths, got 123"}
    end
  end

  describe "path operations (unwrapped)" do
    test "path_join/1 joins path components" do
      assert File.path_join(["home", "user", "documents"]) == "home/user/documents"
      assert File.path_join(["/"]) == "/"
    end

    test "path_join/1 raises error for empty list" do
      assert_raise RuntimeError, ~r/File.path_join requires a non-empty list/, fn ->
        File.path_join([])
      end
    end

    test "path_join/1 raises error for non-string components" do
      assert_raise RuntimeError, ~r/File.path_join requires all components to be strings/, fn ->
        File.path_join(["home", 123, "documents"])
      end
    end

    test "path_join/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.path_join requires a list of path components/, fn ->
        File.path_join("not_a_list")
      end
    end

    test "path_expand/1 expands paths" do
      expanded = File.path_expand(".")
      assert String.contains?(expanded, "/")
      assert Path.absname(".") == expanded
    end

    test "path_expand/1 works with list of paths" do
      [expanded1, expanded2] = File.path_expand([".", ".."])
      assert String.contains?(expanded1, "/")
      assert String.contains?(expanded2, "/")
    end

    test "path_expand/1 raises error for non-string paths" do
      assert_raise RuntimeError, ~r/File.path_expand requires all paths to be strings/, fn ->
        File.path_expand([123])
      end
    end

    test "path_expand/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.path_expand requires a string path/, fn ->
        File.path_expand(123)
      end
    end

    test "path_dirname/1 extracts directory name" do
      assert File.path_dirname("/home/user/file.txt") == "/home/user"
      assert File.path_dirname("file.txt") == "."
    end

    test "path_dirname/1 works with list of paths" do
      paths = ["/home/user/file.txt", "/var/log/app.log"]
      expected = ["/home/user", "/var/log"]
      
      assert File.path_dirname(paths) == expected
    end

    test "path_dirname/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.path_dirname requires a string path/, fn ->
        File.path_dirname(123)
      end
    end

    test "path_basename/1 extracts file name" do
      assert File.path_basename("/home/user/file.txt") == "file.txt"
      assert File.path_basename("/home/user/") == "user"
    end

    test "path_basename/1 works with list of paths" do
      paths = ["/home/user/file.txt", "/var/log/app.log"]
      expected = ["file.txt", "app.log"]
      
      assert File.path_basename(paths) == expected
    end

    test "path_basename/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.path_basename requires a string path/, fn ->
        File.path_basename(123)
      end
    end

    test "path_extname/1 extracts file extension" do
      assert File.path_extname("/home/user/file.txt") == ".txt"
      assert File.path_extname("/home/user/file") == ""
    end

    test "path_extname/1 works with list of paths" do
      paths = ["/home/user/file.txt", "/var/log/app.log", "/etc/config"]
      expected = [".txt", ".log", ""]
      
      assert File.path_extname(paths) == expected
    end

    test "path_extname/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.path_extname requires a string path/, fn ->
        File.path_extname(123)
      end
    end

    test "path_real/1 resolves absolute paths" do
      real_path = File.path_real(".")
      assert String.starts_with?(real_path, "/")
      assert Path.absname(".") == real_path
    end

    test "path_real/1 works with list of paths" do
      [real1, real2] = File.path_real([".", ".."])
      assert String.starts_with?(real1, "/")
      assert String.starts_with?(real2, "/")
    end

    test "path_real/1 raises error for invalid input" do
      assert_raise RuntimeError, ~r/File.path_real requires a string path/, fn ->
        File.path_real(123)
      end
    end
  end

  describe "path operations (wrapped)" do
    test "path_join!/1 joins path components" do
      assert File.path_join!(["home", "user", "documents"]) == {:ok, "home/user/documents"}
      assert File.path_join!(["/"]) == {:ok, "/"}
    end

    test "path_join!/1 returns error for empty list" do
      assert File.path_join!([]) == {:error, "File.path_join! requires a non-empty list of path components"}
    end

    test "path_join!/1 returns error for non-string components" do
      assert File.path_join!(["home", 123, "documents"]) == {:error, "File.path_join! requires all components to be strings"}
    end

    test "path_join!/1 returns error for invalid input" do
      assert File.path_join!("not_a_list") == {:error, "File.path_join! requires a list of path components, got \"not_a_list\""}
    end

    test "path_expand!/1 expands paths" do
      assert {:ok, expanded} = File.path_expand!(".")
      assert String.contains?(expanded, "/")
      assert Path.absname(".") == expanded
    end

    test "path_expand!/1 works with list of paths" do
      assert {:ok, [expanded1, expanded2]} = File.path_expand!([".", ".."])
      assert String.contains?(expanded1, "/")
      assert String.contains?(expanded2, "/")
    end

    test "path_expand!/1 returns error for non-string paths" do
      assert File.path_expand!([123]) == {:error, "File.path_expand! requires all paths to be strings"}
    end

    test "path_expand!/1 returns error for invalid input" do
      assert File.path_expand!(123) == {:error, "File.path_expand! requires a string path or list of paths, got 123"}
    end

    test "path_dirname!/1 extracts directory name" do
      assert File.path_dirname!("/home/user/file.txt") == {:ok, "/home/user"}
      assert File.path_dirname!("file.txt") == {:ok, "."}
    end

    test "path_dirname!/1 works with list of paths" do
      paths = ["/home/user/file.txt", "/var/log/app.log"]
      expected = ["/home/user", "/var/log"]
      
      assert File.path_dirname!(paths) == {:ok, expected}
    end

    test "path_dirname!/1 returns error for invalid input" do
      assert File.path_dirname!(123) == {:error, "File.path_dirname! requires a string path or list of paths, got 123"}
    end

    test "path_basename!/1 extracts file name" do
      assert File.path_basename!("/home/user/file.txt") == {:ok, "file.txt"}
      assert File.path_basename!("/home/user/") == {:ok, "user"}
    end

    test "path_basename!/1 works with list of paths" do
      paths = ["/home/user/file.txt", "/var/log/app.log"]
      expected = ["file.txt", "app.log"]
      
      assert File.path_basename!(paths) == {:ok, expected}
    end

    test "path_basename!/1 returns error for invalid input" do
      assert File.path_basename!(123) == {:error, "File.path_basename! requires a string path or list of paths, got 123"}
    end

    test "path_extname!/1 extracts file extension" do
      assert File.path_extname!("/home/user/file.txt") == {:ok, ".txt"}
      assert File.path_extname!("/home/user/file") == {:ok, ""}
    end

    test "path_extname!/1 works with list of paths" do
      paths = ["/home/user/file.txt", "/var/log/app.log", "/etc/config"]
      expected = [".txt", ".log", ""]
      
      assert File.path_extname!(paths) == {:ok, expected}
    end

    test "path_extname!/1 returns error for invalid input" do
      assert File.path_extname!(123) == {:error, "File.path_extname! requires a string path or list of paths, got 123"}
    end

    test "path_real!/1 resolves absolute paths" do
      assert {:ok, real_path} = File.path_real!(".")
      assert String.starts_with?(real_path, "/")
      assert Path.absname(".") == real_path
    end

    test "path_real!/1 works with list of paths" do
      assert {:ok, [real1, real2]} = File.path_real!([".", ".."])
      assert String.starts_with?(real1, "/")
      assert String.starts_with?(real2, "/")
    end

    test "path_real!/1 returns error for invalid input" do
      assert File.path_real!(123) == {:error, "File.path_real! requires a string path or list of paths, got 123"}
    end
  end
end