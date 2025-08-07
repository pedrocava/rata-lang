defmodule RataModules.File do
  @moduledoc """
  File system operations for Rata, inspired by R's fs package.

  This module provides cross-platform file system operations following Rata's design principles:
  - All values are vectors (no scalars)
  - Functions with `!` suffix return wrapped results: {:ok, result} or {:error, message}
  - Functions without `!` suffix return unwrapped results or raise exceptions
  - Immutable by default
  - Data-first philosophy
  - Vectorized operations (accepts lists of paths)

  All path operations handle UTF-8 encoding and work consistently across platforms.

  ## Function Convention

  Each operation comes in two variants:
  - `function_name/arity` - Returns direct results, raises exceptions on errors
  - `function_name!/arity` - Returns `{:ok, result}` or `{:error, reason}` tuples

  ## Examples

      # Unwrapped version (raises on error)
      path = File.file_create("/tmp/example.txt")
      content = File.file_read("/tmp/example.txt")

      # Wrapped version (safe error handling)
      case File.file_create!("/tmp/example.txt") do
        {:ok, path} -> Log.info("Created: #{path}")
        {:error, message} -> Log.error("Failed: #{message}")
      end
  """

  @doc """
  Create a new file (unwrapped version - raises on error).

  ## Examples

      iex> File.file_create("/path/to/file.txt")
      "/path/to/file.txt"

      iex> File.file_create(["/path/to/file1.txt", "/path/to/file2.txt"])
      ["/path/to/file1.txt", "/path/to/file2.txt"]
  """
  def file_create(path) when is_binary(path) do
    case Elixir.File.touch(path) do
      :ok -> path
      {:error, reason} -> raise "Failed to create file: #{path} - #{reason}"
    end
  end

  def file_create(paths) when is_list(paths) do
    Enum.map(paths, &file_create/1)
  end

  def file_create(invalid) do
    raise "File.file_create requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Create a new file (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_create!("/path/to/file.txt")
      {:ok, "/path/to/file.txt"}

      iex> File.file_create!(["/path/to/file1.txt", "/path/to/file2.txt"])
      {:ok, ["/path/to/file1.txt", "/path/to/file2.txt"]}

      iex> File.file_create!("/invalid/path/file.txt")
      {:error, "Failed to create file: /invalid/path/file.txt"}
  """
  def file_create!(path) when is_binary(path) do
    case Elixir.File.touch(path) do
      :ok -> {:ok, path}
      {:error, reason} -> {:error, "Failed to create file: #{path} - #{reason}"}
    end
  end

  def file_create!(paths) when is_list(paths) do
    results = Enum.map(paths, &file_create!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        successes = Enum.map(results, fn {:ok, path} -> path end)
        {:ok, successes}
      error -> error
    end
  end

  def file_create!(invalid) do
    {:error, "File.file_create! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Delete a file (unwrapped version - raises on error).

  ## Examples

      iex> File.file_delete("/path/to/file.txt")
      "/path/to/file.txt"

      iex> File.file_delete(["/path/to/file1.txt", "/path/to/file2.txt"])
      ["/path/to/file1.txt", "/path/to/file2.txt"]
  """
  def file_delete(path) when is_binary(path) do
    case Elixir.File.rm(path) do
      :ok -> path
      {:error, reason} -> raise "Failed to delete file: #{path} - #{reason}"
    end
  end

  def file_delete(paths) when is_list(paths) do
    Enum.map(paths, &file_delete/1)
  end

  def file_delete(invalid) do
    raise "File.file_delete requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Delete a file (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_delete!("/path/to/file.txt")
      {:ok, "/path/to/file.txt"}

      iex> File.file_delete!(["/path/to/file1.txt", "/path/to/file2.txt"])
      {:ok, ["/path/to/file1.txt", "/path/to/file2.txt"]}
  """
  def file_delete!(path) when is_binary(path) do
    case Elixir.File.rm(path) do
      :ok -> {:ok, path}
      {:error, reason} -> {:error, "Failed to delete file: #{path} - #{reason}"}
    end
  end

  def file_delete!(paths) when is_list(paths) do
    results = Enum.map(paths, &file_delete!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        successes = Enum.map(results, fn {:ok, path} -> path end)
        {:ok, successes}
      error -> error
    end
  end

  def file_delete!(invalid) do
    {:error, "File.file_delete! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Copy a file from source to destination (unwrapped version - raises on error).

  ## Examples

      iex> File.file_copy("/source.txt", "/destination.txt")
      "/destination.txt"
  """
  def file_copy(source, destination) when is_binary(source) and is_binary(destination) do
    case Elixir.File.cp(source, destination) do
      :ok -> destination
      {:error, reason} -> raise "Failed to copy file from #{source} to #{destination} - #{reason}"
    end
  end

  def file_copy(source, destination) do
    raise "File.file_copy requires two string paths, got #{inspect(source)} and #{inspect(destination)}"
  end

  @doc """
  Copy a file from source to destination (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_copy!("/source.txt", "/destination.txt")
      {:ok, "/destination.txt"}
  """
  def file_copy!(source, destination) when is_binary(source) and is_binary(destination) do
    case Elixir.File.cp(source, destination) do
      :ok -> {:ok, destination}
      {:error, reason} -> {:error, "Failed to copy file from #{source} to #{destination} - #{reason}"}
    end
  end

  def file_copy!(source, destination) do
    {:error, "File.file_copy! requires two string paths, got #{inspect(source)} and #{inspect(destination)}"}
  end

  @doc """
  Move (rename) a file from source to destination (unwrapped version - raises on error).

  ## Examples

      iex> File.file_move("/old.txt", "/new.txt")
      "/new.txt"
  """
  def file_move(source, destination) when is_binary(source) and is_binary(destination) do
    case Elixir.File.rename(source, destination) do
      :ok -> destination
      {:error, reason} -> raise "Failed to move file from #{source} to #{destination} - #{reason}"
    end
  end

  def file_move(source, destination) do
    raise "File.file_move requires two string paths, got #{inspect(source)} and #{inspect(destination)}"
  end

  @doc """
  Move (rename) a file from source to destination (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_move!("/old.txt", "/new.txt")
      {:ok, "/new.txt"}
  """
  def file_move!(source, destination) when is_binary(source) and is_binary(destination) do
    case Elixir.File.rename(source, destination) do
      :ok -> {:ok, destination}
      {:error, reason} -> {:error, "Failed to move file from #{source} to #{destination} - #{reason}"}
    end
  end

  def file_move!(source, destination) do
    {:error, "File.file_move! requires two string paths, got #{inspect(source)} and #{inspect(destination)}"}
  end

  @doc """
  Check if a file exists (unwrapped version - raises on error).

  ## Examples

      iex> File.file_exists("/existing/file.txt")
      true

      iex> File.file_exists("/nonexistent/file.txt")
      false

      iex> File.file_exists(["/file1.txt", "/file2.txt"])
      [true, false]
  """
  def file_exists(path) when is_binary(path) do
    Elixir.File.exists?(path)
  end

  def file_exists(paths) when is_list(paths) do
    Enum.map(paths, fn path -> Elixir.File.exists?(path) end)
  end

  def file_exists(invalid) do
    raise "File.file_exists requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Check if a file exists (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_exists!("/existing/file.txt")
      {:ok, true}

      iex> File.file_exists!("/nonexistent/file.txt")
      {:ok, false}

      iex> File.file_exists!(["/file1.txt", "/file2.txt"])
      {:ok, [true, false]}
  """
  def file_exists!(path) when is_binary(path) do
    {:ok, Elixir.File.exists?(path)}
  end

  def file_exists!(paths) when is_list(paths) do
    results = Enum.map(paths, fn path -> Elixir.File.exists?(path) end)
    {:ok, results}
  end

  def file_exists!(invalid) do
    {:error, "File.file_exists! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Get file information (unwrapped version - raises on error).

  ## Examples

      iex> File.file_info("/path/to/file.txt")
      %{size: 1024, type: :regular, access: :read_write, ...}
  """
  def file_info(path) when is_binary(path) do
    case Elixir.File.stat(path) do
      {:ok, stat} -> 
        %{
          size: stat.size,
          type: stat.type,
          access: stat.access,
          atime: stat.atime,
          mtime: stat.mtime,
          ctime: stat.ctime,
          mode: stat.mode,
          links: stat.links,
          major_device: stat.major_device,
          minor_device: stat.minor_device,
          inode: stat.inode,
          uid: stat.uid,
          gid: stat.gid
        }
      {:error, reason} -> raise "Failed to get file info for #{path} - #{reason}"
    end
  end

  def file_info(paths) when is_list(paths) do
    Enum.map(paths, &file_info/1)
  end

  def file_info(invalid) do
    raise "File.file_info requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Get file information (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_info!("/path/to/file.txt")
      {:ok, %{size: 1024, type: :regular, access: :read_write, ...}}
  """
  def file_info!(path) when is_binary(path) do
    case Elixir.File.stat(path) do
      {:ok, stat} -> 
        info = %{
          size: stat.size,
          type: stat.type,
          access: stat.access,
          atime: stat.atime,
          mtime: stat.mtime,
          ctime: stat.ctime,
          mode: stat.mode,
          links: stat.links,
          major_device: stat.major_device,
          minor_device: stat.minor_device,
          inode: stat.inode,
          uid: stat.uid,
          gid: stat.gid
        }
        {:ok, info}
      {:error, reason} -> {:error, "Failed to get file info for #{path} - #{reason}"}
    end
  end

  def file_info!(paths) when is_list(paths) do
    results = Enum.map(paths, &file_info!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        infos = Enum.map(results, fn {:ok, info} -> info end)
        {:ok, infos}
      error -> error
    end
  end

  def file_info!(invalid) do
    {:error, "File.file_info! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Read the contents of a file (unwrapped version - raises on error).

  ## Examples

      iex> File.file_read("/path/to/file.txt")
      "file contents"
  """
  def file_read(path) when is_binary(path) do
    case Elixir.File.read(path) do
      {:ok, content} -> content
      {:error, reason} -> raise "Failed to read file #{path} - #{reason}"
    end
  end

  def file_read(paths) when is_list(paths) do
    Enum.map(paths, &file_read/1)
  end

  def file_read(invalid) do
    raise "File.file_read requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Read the contents of a file (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_read!("/path/to/file.txt")
      {:ok, "file contents"}
  """
  def file_read!(path) when is_binary(path) do
    case Elixir.File.read(path) do
      {:ok, content} -> {:ok, content}
      {:error, reason} -> {:error, "Failed to read file #{path} - #{reason}"}
    end
  end

  def file_read!(paths) when is_list(paths) do
    results = Enum.map(paths, &file_read!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        contents = Enum.map(results, fn {:ok, content} -> content end)
        {:ok, contents}
      error -> error
    end
  end

  def file_read!(invalid) do
    {:error, "File.file_read! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Write content to a file (unwrapped version - raises on error).

  ## Examples

      iex> File.file_write("/path/to/file.txt", "hello world")
      "/path/to/file.txt"
  """
  def file_write(path, content) when is_binary(path) and is_binary(content) do
    case Elixir.File.write(path, content) do
      :ok -> path
      {:error, reason} -> raise "Failed to write to file #{path} - #{reason}"
    end
  end

  def file_write(path, content) do
    raise "File.file_write requires a string path and string content, got #{inspect(path)} and #{inspect(content)}"
  end

  @doc """
  Write content to a file (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_write!("/path/to/file.txt", "hello world")
      {:ok, "/path/to/file.txt"}
  """
  def file_write!(path, content) when is_binary(path) and is_binary(content) do
    case Elixir.File.write(path, content) do
      :ok -> {:ok, path}
      {:error, reason} -> {:error, "Failed to write to file #{path} - #{reason}"}
    end
  end

  def file_write!(path, content) do
    {:error, "File.file_write! requires a string path and string content, got #{inspect(path)} and #{inspect(content)}"}
  end

  @doc """
  Update file timestamps (touch) (unwrapped version - raises on error).

  ## Examples

      iex> File.file_touch("/path/to/file.txt")
      "/path/to/file.txt"
  """
  def file_touch(path) when is_binary(path) do
    case Elixir.File.touch(path) do
      :ok -> path
      {:error, reason} -> raise "Failed to touch file #{path} - #{reason}"
    end
  end

  def file_touch(paths) when is_list(paths) do
    Enum.map(paths, &file_touch/1)
  end

  def file_touch(invalid) do
    raise "File.file_touch requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Update file timestamps (touch) (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.file_touch!("/path/to/file.txt")
      {:ok, "/path/to/file.txt"}
  """
  def file_touch!(path) when is_binary(path) do
    case Elixir.File.touch(path) do
      :ok -> {:ok, path}
      {:error, reason} -> {:error, "Failed to touch file #{path} - #{reason}"}
    end
  end

  def file_touch!(paths) when is_list(paths) do
    results = Enum.map(paths, &file_touch!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        successes = Enum.map(results, fn {:ok, path} -> path end)
        {:ok, successes}
      error -> error
    end
  end

  def file_touch!(invalid) do
    {:error, "File.file_touch! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Create a directory (unwrapped version - raises on error).

  ## Examples

      iex> File.dir_create("/path/to/dir")
      "/path/to/dir"

      iex> File.dir_create(["/path/to/dir1", "/path/to/dir2"])
      ["/path/to/dir1", "/path/to/dir2"]
  """
  def dir_create(path) when is_binary(path) do
    case Elixir.File.mkdir_p(path) do
      :ok -> path
      {:error, reason} -> raise "Failed to create directory #{path} - #{reason}"
    end
  end

  def dir_create(paths) when is_list(paths) do
    Enum.map(paths, &dir_create/1)
  end

  def dir_create(invalid) do
    raise "File.dir_create requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Create a directory (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.dir_create!("/path/to/dir")
      {:ok, "/path/to/dir"}

      iex> File.dir_create!(["/path/to/dir1", "/path/to/dir2"])
      {:ok, ["/path/to/dir1", "/path/to/dir2"]}
  """
  def dir_create!(path) when is_binary(path) do
    case Elixir.File.mkdir_p(path) do
      :ok -> {:ok, path}
      {:error, reason} -> {:error, "Failed to create directory #{path} - #{reason}"}
    end
  end

  def dir_create!(paths) when is_list(paths) do
    results = Enum.map(paths, &dir_create!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        successes = Enum.map(results, fn {:ok, path} -> path end)
        {:ok, successes}
      error -> error
    end
  end

  def dir_create!(invalid) do
    {:error, "File.dir_create! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Delete a directory and its contents (unwrapped version - raises on error).

  ## Examples

      iex> File.dir_delete("/path/to/dir")
      "/path/to/dir"
  """
  def dir_delete(path) when is_binary(path) do
    case Elixir.File.rm_rf(path) do
      {:ok, _} -> path
      {:error, reason, _} -> raise "Failed to delete directory #{path} - #{reason}"
    end
  end

  def dir_delete(paths) when is_list(paths) do
    Enum.map(paths, &dir_delete/1)
  end

  def dir_delete(invalid) do
    raise "File.dir_delete requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Delete a directory and its contents (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.dir_delete!("/path/to/dir")
      {:ok, "/path/to/dir"}
  """
  def dir_delete!(path) when is_binary(path) do
    case Elixir.File.rm_rf(path) do
      {:ok, _} -> {:ok, path}
      {:error, reason, _} -> {:error, "Failed to delete directory #{path} - #{reason}"}
    end
  end

  def dir_delete!(paths) when is_list(paths) do
    results = Enum.map(paths, &dir_delete!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        successes = Enum.map(results, fn {:ok, path} -> path end)
        {:ok, successes}
      error -> error
    end
  end

  def dir_delete!(invalid) do
    {:error, "File.dir_delete! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  List directory contents (unwrapped version - raises on error).

  ## Examples

      iex> File.dir_ls("/path/to/dir")
      ["/path/to/dir/file1.txt", "/path/to/dir/file2.txt"]
  """
  def dir_ls(path) when is_binary(path) do
    case Elixir.File.ls(path) do
      {:ok, files} -> 
        Enum.map(files, fn file -> Path.join(path, file) end)
      {:error, reason} -> raise "Failed to list directory #{path} - #{reason}"
    end
  end

  def dir_ls(paths) when is_list(paths) do
    Enum.flat_map(paths, &dir_ls/1)
  end

  def dir_ls(invalid) do
    raise "File.dir_ls requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  List directory contents (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.dir_ls!("/path/to/dir")
      {:ok, ["/path/to/dir/file1.txt", "/path/to/dir/file2.txt"]}
  """
  def dir_ls!(path) when is_binary(path) do
    case Elixir.File.ls(path) do
      {:ok, files} -> 
        full_paths = Enum.map(files, fn file -> Path.join(path, file) end)
        {:ok, full_paths}
      {:error, reason} -> {:error, "Failed to list directory #{path} - #{reason}"}
    end
  end

  def dir_ls!(paths) when is_list(paths) do
    results = Enum.map(paths, &dir_ls!/1)
    
    case Enum.find(results, fn {status, _} -> status == :error end) do
      nil -> 
        all_files = Enum.flat_map(results, fn {:ok, files} -> files end)
        {:ok, all_files}
      error -> error
    end
  end

  def dir_ls!(invalid) do
    {:error, "File.dir_ls! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Check if a directory exists (unwrapped version - raises on error).

  ## Examples

      iex> File.dir_exists("/existing/dir")
      true

      iex> File.dir_exists("/nonexistent/dir")
      false
  """
  def dir_exists(path) when is_binary(path) do
    Elixir.File.dir?(path)
  end

  def dir_exists(paths) when is_list(paths) do
    Enum.map(paths, fn path -> Elixir.File.dir?(path) end)
  end

  def dir_exists(invalid) do
    raise "File.dir_exists requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Check if a directory exists (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.dir_exists!("/existing/dir")
      {:ok, true}

      iex> File.dir_exists!("/nonexistent/dir")
      {:ok, false}
  """
  def dir_exists!(path) when is_binary(path) do
    {:ok, Elixir.File.dir?(path)}
  end

  def dir_exists!(paths) when is_list(paths) do
    results = Enum.map(paths, fn path -> Elixir.File.dir?(path) end)
    {:ok, results}
  end

  def dir_exists!(invalid) do
    {:error, "File.dir_exists! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Join path components into a single path (unwrapped version - raises on error).

  ## Examples

      iex> File.path_join(["home", "user", "documents"])
      "home/user/documents"
  """
  def path_join(components) when is_list(components) and length(components) > 0 do
    if Enum.all?(components, &is_binary/1) do
      Path.join(components)
    else
      raise "File.path_join requires all components to be strings"
    end
  end

  def path_join([]) do
    raise "File.path_join requires a non-empty list of path components"
  end

  def path_join(invalid) do
    raise "File.path_join requires a list of path components, got #{inspect(invalid)}"
  end

  @doc """
  Join path components into a single path (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.path_join!(["home", "user", "documents"])
      {:ok, "home/user/documents"}

      iex> File.path_join!([])
      {:error, "File.path_join! requires a non-empty list of path components"}
  """
  def path_join!(components) when is_list(components) and length(components) > 0 do
    if Enum.all?(components, &is_binary/1) do
      {:ok, Path.join(components)}
    else
      {:error, "File.path_join! requires all components to be strings"}
    end
  end

  def path_join!([]) do
    {:error, "File.path_join! requires a non-empty list of path components"}
  end

  def path_join!(invalid) do
    {:error, "File.path_join! requires a list of path components, got #{inspect(invalid)}"}
  end

  @doc """
  Expand home directory paths (unwrapped version - raises on error).

  ## Examples

      iex> File.path_expand("~/documents")
      "/home/user/documents"
  """
  def path_expand(path) when is_binary(path) do
    Path.expand(path)
  end

  def path_expand(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      Enum.map(paths, &Path.expand/1)
    else
      raise "File.path_expand requires all paths to be strings"
    end
  end

  def path_expand(invalid) do
    raise "File.path_expand requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Expand home directory paths (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.path_expand!("~/documents")
      {:ok, "/home/user/documents"}
  """
  def path_expand!(path) when is_binary(path) do
    {:ok, Path.expand(path)}
  end

  def path_expand!(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      expanded = Enum.map(paths, &Path.expand/1)
      {:ok, expanded}
    else
      {:error, "File.path_expand! requires all paths to be strings"}
    end
  end

  def path_expand!(invalid) do
    {:error, "File.path_expand! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Extract directory name from path (unwrapped version - raises on error).

  ## Examples

      iex> File.path_dirname("/home/user/file.txt")
      "/home/user"
  """
  def path_dirname(path) when is_binary(path) do
    Path.dirname(path)
  end

  def path_dirname(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      Enum.map(paths, &Path.dirname/1)
    else
      raise "File.path_dirname requires all paths to be strings"
    end
  end

  def path_dirname(invalid) do
    raise "File.path_dirname requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Extract directory name from path (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.path_dirname!("/home/user/file.txt")
      {:ok, "/home/user"}
  """
  def path_dirname!(path) when is_binary(path) do
    {:ok, Path.dirname(path)}
  end

  def path_dirname!(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      dirnames = Enum.map(paths, &Path.dirname/1)
      {:ok, dirnames}
    else
      {:error, "File.path_dirname! requires all paths to be strings"}
    end
  end

  def path_dirname!(invalid) do
    {:error, "File.path_dirname! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Extract file name from path (unwrapped version - raises on error).

  ## Examples

      iex> File.path_basename("/home/user/file.txt")
      "file.txt"
  """
  def path_basename(path) when is_binary(path) do
    Path.basename(path)
  end

  def path_basename(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      Enum.map(paths, &Path.basename/1)
    else
      raise "File.path_basename requires all paths to be strings"
    end
  end

  def path_basename(invalid) do
    raise "File.path_basename requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Extract file name from path (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.path_basename!("/home/user/file.txt")
      {:ok, "file.txt"}
  """
  def path_basename!(path) when is_binary(path) do
    {:ok, Path.basename(path)}
  end

  def path_basename!(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      basenames = Enum.map(paths, &Path.basename/1)
      {:ok, basenames}
    else
      {:error, "File.path_basename! requires all paths to be strings"}
    end
  end

  def path_basename!(invalid) do
    {:error, "File.path_basename! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Extract file extension from path (unwrapped version - raises on error).

  ## Examples

      iex> File.path_extname("/home/user/file.txt")
      ".txt"
  """
  def path_extname(path) when is_binary(path) do
    Path.extname(path)
  end

  def path_extname(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      Enum.map(paths, &Path.extname/1)
    else
      raise "File.path_extname requires all paths to be strings"
    end
  end

  def path_extname(invalid) do
    raise "File.path_extname requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Extract file extension from path (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.path_extname!("/home/user/file.txt")
      {:ok, ".txt"}
  """
  def path_extname!(path) when is_binary(path) do
    {:ok, Path.extname(path)}
  end

  def path_extname!(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      extnames = Enum.map(paths, &Path.extname/1)
      {:ok, extnames}
    else
      {:error, "File.path_extname! requires all paths to be strings"}
    end
  end

  def path_extname!(invalid) do
    {:error, "File.path_extname! requires a string path or list of paths, got #{inspect(invalid)}"}
  end

  @doc """
  Resolve path to absolute form (unwrapped version - raises on error).

  ## Examples

      iex> File.path_real("../documents")
      "/home/user/documents"
  """
  def path_real(path) when is_binary(path) do
    case Elixir.File.cwd() do
      {:ok, cwd} -> 
        Path.expand(path, cwd)
      {:error, reason} -> 
        raise "Failed to get current working directory - #{reason}"
    end
  end

  def path_real(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      case Elixir.File.cwd() do
        {:ok, cwd} -> 
          Enum.map(paths, fn path -> Path.expand(path, cwd) end)
        {:error, reason} -> 
          raise "Failed to get current working directory - #{reason}"
      end
    else
      raise "File.path_real requires all paths to be strings"
    end
  end

  def path_real(invalid) do
    raise "File.path_real requires a string path or list of paths, got #{inspect(invalid)}"
  end

  @doc """
  Resolve path to absolute form (wrapped version - returns {:ok, result} or {:error, reason}).

  ## Examples

      iex> File.path_real!("../documents")
      {:ok, "/home/user/documents"}
  """
  def path_real!(path) when is_binary(path) do
    case Elixir.File.cwd() do
      {:ok, cwd} -> 
        {:ok, Path.expand(path, cwd)}
      {:error, reason} -> 
        {:error, "Failed to get current working directory - #{reason}"}
    end
  end

  def path_real!(paths) when is_list(paths) do
    if Enum.all?(paths, &is_binary/1) do
      case Elixir.File.cwd() do
        {:ok, cwd} -> 
          real_paths = Enum.map(paths, fn path -> Path.expand(path, cwd) end)
          {:ok, real_paths}
        {:error, reason} -> 
          {:error, "Failed to get current working directory - #{reason}"}
      end
    else
      {:error, "File.path_real! requires all paths to be strings"}
    end
  end

  def path_real!(invalid) do
    {:error, "File.path_real! requires a string path or list of paths, got #{inspect(invalid)}"}
  end
end