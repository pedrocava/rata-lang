# Rata

<div align="center">
  <img src="assets/rata-logo.png" alt="Rata Logo" width="200"/>
</div>

Rata combines what I like about three programming languages I had professional contact with and came to appreciate. 

* Modern, [`tidyverse`])() R just feels *nice* to code with.
* Python is the go-to data engineering language for a reason, and mimicking it is in many ways inevitable for any language that is being designed with production data environments. I also enjoy some aspects of its syntax.
* Elixir is a language designed with such good taste. It's just elegant, and it constrain users in a paradoxically freeing way. There is a real joy in Elixir, and the [BEAM virtual machine](https://whyelixirlang.com/#elixir-is-special) it runs on is a natural fit to data engineering workloads because it allows one to easily write fault-tolerant, parallel code.

This is being vibe coded and takes a lot of inspiration from [T](https://github.com/b-rodrigues/tlang).

## Design Principles

- **💬 REPL-first**: Interactive development experience that encourages exploration  
- **🔒 Immutable by default**: Standard library avoids side-effects by design
- **📊 1-indexed**: Following R conventions for intuitive data work
- **🏷️ Optional typing**: Add types when you need them: `function(n: int) { n + 1 }`
- **🚫 No scalars**: Every value is a single-entry vector, eliminating scalar/vector confusion

## Code Examples

### RNA to DNA Transcription

```rata
# Convert RNA sequence to DNA
rna_to_dna = function(rna: string) {
  rna 
    |> String.replace("U", "T")
    |> String.replace("u", "t")
}

rna_sequence = "AUCGAUCGAU"
dna_sequence = rna_to_dna(rna_sequence)
Log.info(f"RNA: {rna_sequence} -> DNA: {dna_sequence}")
```

### Bird Count Analysis

```rata
# Analyze bird observation data
bird_counts = {
  :sparrow => [12, 8, 15, 20],
  :robin => [5, 3, 8, 12], 
  :cardinal => [2, 1, 4, 6]
}

total_counts = Maps.map(bird_counts, ~ Enum.sum(.y))
most_observed = Maps.max_by(total_counts, ~ .y)

Log.info(f"Total observations: {total_counts}")
Log.info(f"Most observed bird: {most_observed}")
```

### Fibonacci Sequence

```rata
module Math {
  fibonacci = function(n: posint) {
    if n <= 2 {
      return 1
    } else {
      return fibonacci(n-1) + fibonacci(n-2)  
    }
  }
  
  # Generate first 10 fibonacci numbers
  fib_sequence = 1..10 |> Enum.map(fibonacci)
}
```

## Quick Start

```bash
# Clone the repository
git clone https://github.com/your-username/rata-lang.git
cd rata-lang/rata_parser

# Install dependencies (requires Elixir)
mix deps.get

# Start the REPL
elixir repl.exs
```

### REPL Commands
- `:help` - Show help message
- `:quit` - Exit REPL  
- `:clear` - Clear all variables
- `:vars` - Show defined variables

## Language Features

- **R-like lambdas**: `~ .x + .y` for concise anonymous functions
- **Pattern matching**: Elixir-style `case` expressions with wrapped returns
- **Pipe operations**: `|>` for readable data transformation chains
- **Recursive modules**: `library datetime.timezone as tz`
- **Rich data types**: Vectors, Lists, Maps, Tables, Sets, Tuples

## Project Status

Rata is currently in active development. The parser and basic REPL are functional, with ongoing work on:

- Standard library modules (Vector, Maps, File, Database connectors)
- Advanced type system features
- Cloud SDK integrations
- Production tooling

## Documentation

- [Language Specification](specs/desiderata.md)
- [Implementation Roadmap](specs/ROADMAP.md) 
- [Standard Library Modules](specs/module-list.md)
- [Sample Code](specs/samples/)

## Contributing

Rata is being "vibecoded into existence" with an iterative, community-driven approach. Check out the [roadmap](specs/ROADMAP.md) to see what's next and how you can help!

---

*Built with ❤️ for the data engineering community*
