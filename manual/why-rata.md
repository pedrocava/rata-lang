# Why Rata?

Rata is a programming language designed specifically for data engineering tasks, combining the best aspects of R's data manipulation capabilities with Python's familiar syntax, all running on the robust Elixir BEAM virtual machine.

## The Problem with Current Tools

### Python: Great Ecosystem, Painful Data Work
```python
# Python pandas - verbose and mutable
import pandas as pd

df = pd.read_csv('data.csv')
df['age_next_year'] = df['age'] + 1
df_filtered = df[df['age'] > 25]
df_filtered.to_csv('output.csv')
```

### R: Excellent for Data, Awkward for Engineering  
```r
# R tidyverse - great for data, but...
library(dplyr)
library(readr)

data <- read_csv('data.csv') %>%
  mutate(age_next_year = age + 1) %>%
  filter(age > 25) %>%
  write_csv('output.csv')
```

### Rata: The Best of Both Worlds
```rata
# Rata - data-first with engineering in mind
library Table as t
library Dataload as dl

dl.read_csv("data.csv")
  |> t.mutate(age_next_year: age + 1)
  |> t.filter(age > 25)
  |> dl.write_csv("output.csv")
```

## Core Design Philosophy

### 1. Data Engineering First
Rata is purpose-built for the workflows data engineers encounter daily:
- Loading data from various formats (CSV, Excel, Parquet, JSON, databases)
- Transforming and cleaning data with intuitive syntax
- Building robust data pipelines with proper error handling
- Orchestrating concurrent data processing tasks

### 2. Immutable by Default
```rata
# No accidental mutations - data flows through transformations
original_data = load_data()
cleaned_data = original_data |> clean() |> validate()
# original_data is unchanged
```

### 3. 1-Indexed Like R
```rata
names = ["Alice", "Bob", "Charlie"]
names[1]  # "Alice" - natural for data work
```

### 4. No Scalar Values
```rata
# Everything is a vector, even single values
age = 25        # This is actually [25]
ages = [25, 30] # This is [25, 30]
```

### 5. Pattern Matching for Error Handling
```rata
case File.read("data.csv") {
  {:ok, content} -> process_data(content)
  {:error, reason} -> Log.error(f"Failed to read file: {reason}")
}
```

### 6. Leveraging the BEAM
- **Fault tolerance**: Let it crash philosophy with supervisor trees
- **Concurrency**: Process-based parallelism for data processing
- **Distribution**: Built-in support for multi-node processing
- **Hot code swapping**: Update running data pipelines without downtime

## Comparison with Other Languages

| Feature | Python | R | Julia | Rata |
|---------|--------|---|-------|------|
| Data manipulation | 🟡 Pandas | 🟢 Excellent | 🟡 DataFrames.jl | 🟢 Built-in |
| Syntax clarity | 🟢 Clean | 🟡 Quirky | 🟢 Clean | 🟢 Clean |
| Concurrency | 🔴 GIL issues | 🔴 Limited | 🟢 Good | 🟢 Excellent (BEAM) |
| Error handling | 🟡 Exceptions | 🔴 Inconsistent | 🟡 Exceptions | 🟢 Pattern matching |
| Package ecosystem | 🟢 Huge | 🟢 Statistical | 🟡 Growing | 🟡 Building |
| Learning curve | 🟢 Easy | 🟡 Moderate | 🟡 Moderate | 🟢 Easy |

## Real-World Use Cases

### ETL Pipelines
```rata
library Process as p
library Table as t

# Concurrent data processing
sources = ["api1", "api2", "api3"]

results = sources
  |> Enum.map(~ p.async(fn -> fetch_data(.x) end))
  |> Enum.map(p.await/1)
  |> Enum.map(t.standardize/1)
  |> t.union_all()
```

### API Data Processing
```rata
library Http as h
library Json as j

case h.get("https://api.example.com/data", headers: auth_headers) {
  {:ok, response} -> 
    response.body
      |> j.decode!()
      |> transform_api_data()
      |> save_to_warehouse()
  
  {:error, reason} ->
    Log.error(f"API call failed: {reason}")
    send_alert_to_team(reason)
}
```

### Stream Processing
```rata
library Process as p

data_stream
  |> Stream.chunk_every(1000)
  |> Stream.map(process_batch/1)
  |> Stream.run()
```

## Who Should Use Rata?

### Perfect for:
- **Data Engineers** building robust data pipelines
- **Analytics Engineers** creating data transformation workflows  
- **Data Scientists** who want better engineering practices
- **Backend Engineers** working with data-intensive applications

### Might not be ideal for:
- Web frontend development (use JavaScript/TypeScript)
- Mobile app development (use platform-specific tools)
- System programming (use Rust/C/Go)
- Machine learning model development (Python ecosystem is unmatched)

## Getting Started

Ready to try Rata? Head to the [Basic Concepts](basic-concepts.md) guide to learn the syntax, or jump into the [Installation](installation.md) guide to get Rata running on your system.

---

*"Rata combines the ergonomics of R's tidyverse with Python-like syntax, running on the Elixir BEAM virtual machine to leverage OTP's process model and fault tolerance."*