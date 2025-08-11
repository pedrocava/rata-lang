# Dataload Module

The Dataload module provides utilities for reading and writing data in various formats commonly used in data engineering: CSV, Excel, Parquet, Arrow, and more.

## Overview

Dataload supports:
- **Multiple formats**: CSV, Excel, Parquet, Arrow, JSON, TSV
- **Automatic type inference**: Smart detection of column types
- **Large file support**: Streaming and chunked reading
- **Configuration options**: Flexible parsing parameters
- **Error handling**: Robust error reporting and recovery

## Import

```rata
library Dataload as dl
```

## CSV Operations

### `read_csv(path, options \\= {})` - Read CSV file as Table
### `write_csv(table, path, options \\= {})` - Write Table to CSV
### `stream_csv(path, options \\= {})` - Stream large CSV files

```rata
# Read CSV with options
data = Dataload.read_csv!("sales.csv", {
  delimiter: ",",
  headers: true,
  skip_rows: 1,
  infer_types: true
})

# Write processed data
processed_data |> Dataload.write_csv!("output.csv")
```

## Excel Operations

### `read_excel(path, options \\= {})` - Read Excel file
### `write_excel(table, path, options \\= {})` - Write Excel file
### `list_sheets(path)` - List worksheet names

```rata
# Read specific worksheet
data = Dataload.read_excel!("report.xlsx", {
  sheet: "Sales Data",
  range: "A1:F100"
})
```

## Parquet Operations

### `read_parquet(path)` - Read Parquet file
### `write_parquet(table, path)` - Write Parquet file

```rata
# Efficient columnar storage
large_dataset |> Dataload.write_parquet!("data.parquet")
loaded = Dataload.read_parquet!("data.parquet")
```

## JSON Operations

### `read_json(path)` - Read JSON file as Table
### `write_json(table, path)` - Write Table as JSON
### `read_jsonl(path)` - Read JSON Lines format

## Usage Examples

```rata
# ETL pipeline with multiple formats
result = dl.read_csv!("input.csv")
  |> Table.filter(amount > 0)
  |> Table.group_by(:category)
  |> Table.summarize(total: Math.sum(amount))
  |> dl.write_parquet!("summary.parquet")

# Handle large files with streaming
dl.stream_csv("huge_file.csv", chunk_size: 10000)
  |> Stream.map(process_chunk/1)
  |> Stream.run()
```

---

*This is a skeleton for the Dataload module documentation. Full implementation details will be added as the module is developed.*