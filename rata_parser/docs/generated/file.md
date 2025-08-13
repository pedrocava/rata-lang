# File Module

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


## Import

```rata
library File
```

## Functions

### `dir_create(invalid)`

_No documentation available._


### `dir_create!(invalid)`

_No documentation available._


### `dir_delete(invalid)`

_No documentation available._


### `dir_delete!(invalid)`

_No documentation available._


### `dir_exists(invalid)`

_No documentation available._


### `dir_exists!(invalid)`

_No documentation available._


### `dir_ls(invalid)`

_No documentation available._


### `dir_ls!(invalid)`

_No documentation available._


### `file_copy(source, destination)`

_No documentation available._


### `file_copy!(source, destination)`

_No documentation available._


### `file_create(invalid)`

_No documentation available._


### `file_create!(invalid)`

_No documentation available._


### `file_delete(invalid)`

_No documentation available._


### `file_delete!(invalid)`

_No documentation available._


### `file_exists(invalid)`

_No documentation available._


### `file_exists!(invalid)`

_No documentation available._


### `file_info(invalid)`

_No documentation available._


### `file_info!(invalid)`

_No documentation available._


### `file_move(source, destination)`

_No documentation available._


### `file_move!(source, destination)`

_No documentation available._


### `file_read(invalid)`

_No documentation available._


### `file_read!(invalid)`

_No documentation available._


### `file_touch(invalid)`

_No documentation available._


### `file_touch!(invalid)`

_No documentation available._


### `file_write(path, content)`

_No documentation available._


### `file_write!(path, content)`

_No documentation available._


### `path_basename(invalid)`

_No documentation available._


### `path_basename!(invalid)`

_No documentation available._


### `path_dirname(invalid)`

_No documentation available._


### `path_dirname!(invalid)`

_No documentation available._


### `path_expand(invalid)`

_No documentation available._


### `path_expand!(invalid)`

_No documentation available._


### `path_extname(invalid)`

_No documentation available._


### `path_extname!(invalid)`

_No documentation available._


### `path_join(arg)`

_No documentation available._


### `path_join(invalid)`

_No documentation available._


### `path_join!(arg)`

_No documentation available._


### `path_join!(invalid)`

_No documentation available._


### `path_real(invalid)`

_No documentation available._


### `path_real!(invalid)`

_No documentation available._


### `when(file_create, is_binary)`

Create a new file (unwrapped version - raises on error).

## Examples

    iex> File.file_create("/path/to/file.txt")
    "/path/to/file.txt"

    iex> File.file_create(["/path/to/file1.txt", "/path/to/file2.txt"])
    ["/path/to/file1.txt", "/path/to/file2.txt"]



### `when(file_create, is_list)`

_No documentation available._


### `when(file_create!, is_binary)`

Create a new file (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_create!("/path/to/file.txt")
    {:ok, "/path/to/file.txt"}

    iex> File.file_create!(["/path/to/file1.txt", "/path/to/file2.txt"])
    {:ok, ["/path/to/file1.txt", "/path/to/file2.txt"]}

    iex> File.file_create!("/invalid/path/file.txt")
    {:error, "Failed to create file: /invalid/path/file.txt"}



### `when(file_create!, is_list)`

_No documentation available._


### `when(file_delete, is_binary)`

Delete a file (unwrapped version - raises on error).

## Examples

    iex> File.file_delete("/path/to/file.txt")
    "/path/to/file.txt"

    iex> File.file_delete(["/path/to/file1.txt", "/path/to/file2.txt"])
    ["/path/to/file1.txt", "/path/to/file2.txt"]



### `when(file_delete, is_list)`

_No documentation available._


### `when(file_delete!, is_binary)`

Delete a file (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_delete!("/path/to/file.txt")
    {:ok, "/path/to/file.txt"}

    iex> File.file_delete!(["/path/to/file1.txt", "/path/to/file2.txt"])
    {:ok, ["/path/to/file1.txt", "/path/to/file2.txt"]}



### `when(file_delete!, is_list)`

_No documentation available._


### `when(file_copy, and)`

Copy a file from source to destination (unwrapped version - raises on error).

## Examples

    iex> File.file_copy("/source.txt", "/destination.txt")
    "/destination.txt"



### `when(file_copy!, and)`

Copy a file from source to destination (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_copy!("/source.txt", "/destination.txt")
    {:ok, "/destination.txt"}



### `when(file_move, and)`

Move (rename) a file from source to destination (unwrapped version - raises on error).

## Examples

    iex> File.file_move("/old.txt", "/new.txt")
    "/new.txt"



### `when(file_move!, and)`

Move (rename) a file from source to destination (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_move!("/old.txt", "/new.txt")
    {:ok, "/new.txt"}



### `when(file_exists, is_binary)`

Check if a file exists (unwrapped version - raises on error).

## Examples

    iex> File.file_exists("/existing/file.txt")
    true

    iex> File.file_exists("/nonexistent/file.txt")
    false

    iex> File.file_exists(["/file1.txt", "/file2.txt"])
    [true, false]



### `when(file_exists, is_list)`

_No documentation available._


### `when(file_exists!, is_binary)`

Check if a file exists (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_exists!("/existing/file.txt")
    {:ok, true}

    iex> File.file_exists!("/nonexistent/file.txt")
    {:ok, false}

    iex> File.file_exists!(["/file1.txt", "/file2.txt"])
    {:ok, [true, false]}



### `when(file_exists!, is_list)`

_No documentation available._


### `when(file_info, is_binary)`

Get file information (unwrapped version - raises on error).

## Examples

    iex> File.file_info("/path/to/file.txt")
    %{size: 1024, type: :regular, access: :read_write, ...}



### `when(file_info, is_list)`

_No documentation available._


### `when(file_info!, is_binary)`

Get file information (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_info!("/path/to/file.txt")
    {:ok, %{size: 1024, type: :regular, access: :read_write, ...}}



### `when(file_info!, is_list)`

_No documentation available._


### `when(file_read, is_binary)`

Read the contents of a file (unwrapped version - raises on error).

## Examples

    iex> File.file_read("/path/to/file.txt")
    "file contents"



### `when(file_read, is_list)`

_No documentation available._


### `when(file_read!, is_binary)`

Read the contents of a file (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_read!("/path/to/file.txt")
    {:ok, "file contents"}



### `when(file_read!, is_list)`

_No documentation available._


### `when(file_write, and)`

Write content to a file (unwrapped version - raises on error).

## Examples

    iex> File.file_write("/path/to/file.txt", "hello world")
    "/path/to/file.txt"



### `when(file_write!, and)`

Write content to a file (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_write!("/path/to/file.txt", "hello world")
    {:ok, "/path/to/file.txt"}



### `when(file_touch, is_binary)`

Update file timestamps (touch) (unwrapped version - raises on error).

## Examples

    iex> File.file_touch("/path/to/file.txt")
    "/path/to/file.txt"



### `when(file_touch, is_list)`

_No documentation available._


### `when(file_touch!, is_binary)`

Update file timestamps (touch) (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.file_touch!("/path/to/file.txt")
    {:ok, "/path/to/file.txt"}



### `when(file_touch!, is_list)`

_No documentation available._


### `when(dir_create, is_binary)`

Create a directory (unwrapped version - raises on error).

## Examples

    iex> File.dir_create("/path/to/dir")
    "/path/to/dir"

    iex> File.dir_create(["/path/to/dir1", "/path/to/dir2"])
    ["/path/to/dir1", "/path/to/dir2"]



### `when(dir_create, is_list)`

_No documentation available._


### `when(dir_create!, is_binary)`

Create a directory (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.dir_create!("/path/to/dir")
    {:ok, "/path/to/dir"}

    iex> File.dir_create!(["/path/to/dir1", "/path/to/dir2"])
    {:ok, ["/path/to/dir1", "/path/to/dir2"]}



### `when(dir_create!, is_list)`

_No documentation available._


### `when(dir_delete, is_binary)`

Delete a directory and its contents (unwrapped version - raises on error).

## Examples

    iex> File.dir_delete("/path/to/dir")
    "/path/to/dir"



### `when(dir_delete, is_list)`

_No documentation available._


### `when(dir_delete!, is_binary)`

Delete a directory and its contents (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.dir_delete!("/path/to/dir")
    {:ok, "/path/to/dir"}



### `when(dir_delete!, is_list)`

_No documentation available._


### `when(dir_ls, is_binary)`

List directory contents (unwrapped version - raises on error).

## Examples

    iex> File.dir_ls("/path/to/dir")
    ["/path/to/dir/file1.txt", "/path/to/dir/file2.txt"]



### `when(dir_ls, is_list)`

_No documentation available._


### `when(dir_ls!, is_binary)`

List directory contents (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.dir_ls!("/path/to/dir")
    {:ok, ["/path/to/dir/file1.txt", "/path/to/dir/file2.txt"]}



### `when(dir_ls!, is_list)`

_No documentation available._


### `when(dir_exists, is_binary)`

Check if a directory exists (unwrapped version - raises on error).

## Examples

    iex> File.dir_exists("/existing/dir")
    true

    iex> File.dir_exists("/nonexistent/dir")
    false



### `when(dir_exists, is_list)`

_No documentation available._


### `when(dir_exists!, is_binary)`

Check if a directory exists (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.dir_exists!("/existing/dir")
    {:ok, true}

    iex> File.dir_exists!("/nonexistent/dir")
    {:ok, false}



### `when(dir_exists!, is_list)`

_No documentation available._


### `when(path_join, and)`

Join path components into a single path (unwrapped version - raises on error).

## Examples

    iex> File.path_join(["home", "user", "documents"])
    "home/user/documents"



### `when(path_join!, and)`

Join path components into a single path (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.path_join!(["home", "user", "documents"])
    {:ok, "home/user/documents"}

    iex> File.path_join!([])
    {:error, "File.path_join! requires a non-empty list of path components"}



### `when(path_expand, is_binary)`

Expand home directory paths (unwrapped version - raises on error).

## Examples

    iex> File.path_expand("~/documents")
    "/home/user/documents"



### `when(path_expand, is_list)`

_No documentation available._


### `when(path_expand!, is_binary)`

Expand home directory paths (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.path_expand!("~/documents")
    {:ok, "/home/user/documents"}



### `when(path_expand!, is_list)`

_No documentation available._


### `when(path_dirname, is_binary)`

Extract directory name from path (unwrapped version - raises on error).

## Examples

    iex> File.path_dirname("/home/user/file.txt")
    "/home/user"



### `when(path_dirname, is_list)`

_No documentation available._


### `when(path_dirname!, is_binary)`

Extract directory name from path (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.path_dirname!("/home/user/file.txt")
    {:ok, "/home/user"}



### `when(path_dirname!, is_list)`

_No documentation available._


### `when(path_basename, is_binary)`

Extract file name from path (unwrapped version - raises on error).

## Examples

    iex> File.path_basename("/home/user/file.txt")
    "file.txt"



### `when(path_basename, is_list)`

_No documentation available._


### `when(path_basename!, is_binary)`

Extract file name from path (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.path_basename!("/home/user/file.txt")
    {:ok, "file.txt"}



### `when(path_basename!, is_list)`

_No documentation available._


### `when(path_extname, is_binary)`

Extract file extension from path (unwrapped version - raises on error).

## Examples

    iex> File.path_extname("/home/user/file.txt")
    ".txt"



### `when(path_extname, is_list)`

_No documentation available._


### `when(path_extname!, is_binary)`

Extract file extension from path (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.path_extname!("/home/user/file.txt")
    {:ok, ".txt"}



### `when(path_extname!, is_list)`

_No documentation available._


### `when(path_real, is_binary)`

Resolve path to absolute form (unwrapped version - raises on error).

## Examples

    iex> File.path_real("../documents")
    "/home/user/documents"



### `when(path_real, is_list)`

_No documentation available._


### `when(path_real!, is_binary)`

Resolve path to absolute form (wrapped version - returns {:ok, result} or {:error, reason}).

## Examples

    iex> File.path_real!("../documents")
    {:ok, "/home/user/documents"}



### `when(path_real!, is_list)`

_No documentation available._

