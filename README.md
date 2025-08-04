# Rata

<div align="center">
  <img src="assets/rata-logo.png" alt="Rata Logo" width="200"/>
</div>

Rata combines what I like about three programming languages I had professional contact with and came to appreciate. 

* Modern, [`tidyverse`](https://www.tidyverse.org/) R just feels *nice* to code with.
* Python is the go-to data engineering language for a reason, and mimicking it is in many ways inevitable for any language that is being designed with production data environments. I also enjoy some aspects of its syntax.
* Elixir is a language designed with such good taste. It's just elegant, and it constrain users in a paradoxically freeing way. There is a real joy in Elixir, and the [BEAM virtual machine](https://whyelixirlang.com/#elixir-is-special) it runs on is a natural fit to data engineering workloads because it allows one to easily write fault-tolerant, parallel code.

This is being vibe coded and takes a lot of inspiration from [T](https://github.com/b-rodrigues/tlang).

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
module BirdCount {
  # Get today's bird count (first element)
  today = function(counts: [int]) {
    if List.is_empty(counts) {
      nil
    } else {
      List.first(counts)
    }
  }
  
  # Increment today's count by 1
  increment_day_count = function(counts: [int]) {
    if List.is_empty(counts) {
      [1]
    } else {
      today_count = List.first(counts)
      rest_counts = List.rest(counts)
      List.prepend(rest_counts, today_count + 1)
    }
  }
  
  # Check if any day had zero birds
  has_day_without_birds = function(counts: [int]) {
    Enum.any(counts, ~ .x == 0)
  }
  
  # Calculate total birds across all days
  total = function(counts: [int]) {
    Enum.sum(counts)
  }
  
  # Count busy days (5+ birds)
  busy_days = function(counts: [int]) {
    counts 
      |> Enum.keep(~ .x >= 5)
      |> List.length()
  }
}

# Track daily bird visits: [today, yesterday, day_before, ...]
daily_counts = [2, 5, 0, 7, 4, 1]
updated_counts = BirdCount.increment_day_count(daily_counts)

Log.info(f"Today's count: {BirdCount.today(daily_counts)}")
Log.info(f"After increment: {BirdCount.today(updated_counts)}")
Log.info(f"Total birds: {BirdCount.total(daily_counts)}")
Log.info(f"Busy days: {BirdCount.busy_days(daily_counts)}")
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

## Project Status

Rata is still highly experimental and my side-project. Wanna talk about it? Hit me up on [~twitter~ X](https://x.com/pedroocava).

## Documentation

- [Language Specification](specs/desiderata.md)
- [Implementation Roadmap](specs/ROADMAP.md) 
- [Standard Library Modules](specs/module-list.md)
- [Sample Code](specs/samples/)
