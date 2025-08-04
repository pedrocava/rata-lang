# Rata

<div align="center">
  <img src="assets/rata-logo.png" alt="Rata Logo" width="200"/>
</div>

Rata combines what I love about three languages:

* Modern, [`tidyverse`](https://www.tidyverse.org/) R just feels *nice* to code with.
* Python is the go-to data engineering language for a reason, it sets a really high bar. I also enjoy some aspects of its syntax.
* Elixir is a language designed with such good taste, it constrain users in a paradoxically freeing way. There is a real joy in Elixir. The [BEAM virtual machine](https://whyelixirlang.com/#elixir-is-special) is a natural fit to data engineering workloads because it allows one to easily write fault-tolerant, parallel code.

This is being vibe coded and takes a lot of inspiration from [T](https://github.com/b-rodrigues/tlang).

## Code Examples

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
    Enum.some(counts, ~ .x == 0)
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
  fib_sequence = 1..10 |>
    Enum.map(fibonacci)
}
```

## Project Status

Rata is still highly experimental and my side-project. Wanna talk about it? Hit me up on [~twitter~ X](https://x.com/pedroocava).

## Documentation

- [Language Specification](specs/desiderata.md)
- [Implementation Roadmap](specs/ROADMAP.md) 
- [Standard Library Modules](specs/module-list.md)
- [Sample Code](specs/samples/)
