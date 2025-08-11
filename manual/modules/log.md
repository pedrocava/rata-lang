# Log Module

The Log module provides structured logging capabilities for debugging, monitoring, and observability in Rata applications.

## Overview

Log features:
- **Multiple levels**: Debug, info, warn, error, fatal
- **Structured logging**: Support for metadata and context
- **Configurable outputs**: Console, file, remote systems
- **Performance**: Efficient logging that doesn't block

## Import

```rata
library Log as log
```

## Log Levels

### `debug(message, metadata \\= {})` - Detailed debugging info
### `info(message, metadata \\= {})` - General information  
### `warn(message, metadata \\= {})` - Warning conditions
### `error(message, metadata \\= {})` - Error conditions
### `fatal(message, metadata \\= {})` - Critical failures

```rata
Log.debug("Processing user data", {user_id: 123})
Log.info(f"Processed {count} records")
Log.warn("API rate limit approaching", {remaining: 10})
Log.error("Database connection failed", {error: reason})
Log.fatal("System out of memory", {memory_usage: "95%"})
```

## Configuration

### `set_level(level)` - Set minimum log level
### `configure(options)` - Configure logging backend

```rata
# Development setup
Log.set_level(:debug)
Log.configure({output: :console, format: :pretty})

# Production setup  
Log.set_level(:info)
Log.configure({
  output: :file,
  path: "logs/rata.log",
  format: :json,
  rotation: :daily
})
```

## Structured Logging

```rata
# Rich metadata for observability
Log.info("Data pipeline completed", {
  pipeline_id: pipeline.id,
  duration_ms: timer.elapsed(),
  records_processed: result.count,
  status: :success
})

# Error context
Log.error("File processing failed", {
  filename: file_path,
  error: error_reason,
  line_number: current_line,
  user_id: session.user_id
})
```

## Usage Examples

```rata
# Function-level logging
process_user_data = function(user_id) {
  Log.debug("Starting user processing", {user_id: user_id})
  
  case Database.get_user(user_id) {
    {:ok, user} -> 
      Log.info(f"Processing user: {user.name}")
      result = transform_user(user)
      Log.debug("User processing complete", {result: result})
      {:ok, result}
      
    {:error, reason} ->
      Log.error("User not found", {user_id: user_id, reason: reason})
      {:error, reason}
  }
}

# Pipeline monitoring
data_pipeline = function(input_file) {
  start_time = System.monotonic_time()
  
  Log.info("Pipeline started", {file: input_file})
  
  result = input_file
    |> Dataload.read_csv!()
    |> Log.tap(~ Log.debug(f"Loaded {Table.nrows(.x)} records"))
    |> Table.filter(valid_record?/1)
    |> Log.tap(~ Log.debug(f"Filtered to {Table.nrows(.x)} records"))
    |> process_data()
    |> save_results()
  
  duration = System.monotonic_time() - start_time
  Log.info("Pipeline completed", {
    file: input_file,
    duration_ms: duration,
    status: :success
  })
  
  result
}
```

---

*This is a skeleton for the Log module documentation. Full implementation details will be added as the module is developed.*