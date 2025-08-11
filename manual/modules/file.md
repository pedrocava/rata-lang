# File Module

The File module provides file system operations for reading, writing, and managing files and directories. Essential for data engineering workflows that involve file-based data sources.

## Overview

File operations in Rata:
- **Safe by default**: Operations return `{:ok, result}` or `{:error, reason}`
- **Cross-platform**: Works consistently across operating systems
- **Encoding aware**: Proper handling of text encodings
- **Stream support**: Efficient handling of large files

## Import

```rata
library File as f
```

## Reading Files

### `read(path)` - Read entire file as string
### `read!(path)` - Read file, raise on error
### `read_lines(path)` - Read file as vector of lines
### `stream(path)` - Create lazy stream for large files

## Writing Files

### `write(path, content)` - Write string to file
### `write!(path, content)` - Write file, raise on error
### `append(path, content)` - Append to existing file
### `write_lines(path, lines)` - Write vector of lines

## File Information

### `exists?(path)` - Check if file exists
### `size(path)` - Get file size in bytes
### `stat(path)` - Get detailed file information
### `type(path)` - Get file type (:file, :directory, :symlink)

## Directory Operations

### `mkdir(path)` - Create directory
### `mkdir_p(path)` - Create directory and parents
### `rmdir(path)` - Remove empty directory
### `list_dir(path)` - List directory contents
### `cwd()` - Get current working directory
### `cd(path)` - Change current directory

## Usage Examples

```rata
# Read configuration file
case File.read("config.json") {
  {:ok, content} -> Json.decode!(content)
  {:error, :enoent} -> default_config()
  {:error, reason} -> 
    Log.error(f"Failed to read config: {reason}")
    System.exit(1)
}

# Process large file line by line
File.stream("large_data.txt")
  |> Stream.map(parse_line/1)
  |> Stream.filter(valid_record?/1)
  |> Enum.to_list()
```

---

*This is a skeleton for the File module documentation. Full implementation details will be added as the module is developed.*