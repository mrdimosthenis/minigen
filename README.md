# minigen

Pure random data generation library, appropriate for realistic simulations in the Erlang ecosystem.

## Installation

* For **Erlang** projects, add the dependency into `rebar.config`:

```erlang
{deps, [
    {minigen, "0.1.1"}
]}.
```

* For **Elixir** projects, add the dependency into `mix.exs`:

```elixir
defp deps do
  [
    {:minigen, "~> 0.1.1", manager: :rebar3}
  ]
end
```

* For **Gleam** projects, run `gleam add minigen`.

## Usage

The examples below use the `run` function that will probably return different values on each call.
If we want to get the same values on each call, we need to use `run_with_seed` instead.

Don't forget to visit https://hexdocs.pm/minigen/minigen.html to see the signature of the available functions:
`list`, `then`, `always`, `sequence`, `map`, `map2`, `map3`, `map4`, `map5`. Their combination can generate values for any data type.

More examples can be found in the test directory of the GitHub repository.

### Erlang examples

* Create a random float number

```erlang
GEN=minigen:float(),
minigen:run(GEN).
0.7938520785840248
```

* Create a random integer number

```erlang
GEN=minigen:integer(10),
minigen:run(GEN).
4
```

* Create a random boolean value

```erlang
GEN=minigen:boolean(),
minigen:run(GEN).
true
```

* Get a random element from a list

```erlang
GEN=minigen:element_of_list([1, 2, 3]),
minigen:run(GEN).
{ok,2}
```

```erlang
GEN=minigen:element_of_list([]),
minigen:run(GEN).
{error,nil}
```

* Shuffle a list

```erlang
GEN=minigen:shuffled_list([1, 2, 3]),
minigen:run(GEN).
[2,1,3]
```

* Create a random string

```erlang
GEN=minigen:string(6),
minigen:run(GEN).
"3Rzpqd"
```

### Elixir examples

* Create a random float number

```elixir
:minigen.float
|> :minigen.run
0.36087782004967894
```

* Create a random integer number

```elixir
:minigen.integer(10)
|> :minigen.run
8
```

* Create a random boolean value

```elixir
:minigen.boolean
|> :minigen.run
false
```

* Get a random element from a list

```elixir
:minigen.element_of_list(["a", "b", "c", "d"])
|> :minigen.run
{:ok, "c"}
```

```elixir
:minigen.element_of_list([])
|> :minigen.run
{:error, nil}
```

* Shuffle a list

```elixir
:minigen.shuffled_list(["a", "b", "c", "d"])
|> :minigen.run
["c", "d", "b", "a"]
```

* Create a random string

```elixir
:minigen.string(7)
|> :minigen.run
"eJKp8sc"
```

### Gleam examples

```gleam
import minigen
```

* Create a random float number

```gleam
minigen.float()
|> minigen.run
0.16296012690374562
```

* Create a random integer number

```gleam
minigen.integer(10)
|> minigen.run
6
```

* Create a random boolean value

```gleam
minigen.boolean()
|> minigen.run
True
```

* Get a random element from a list

```gleam
minigen.element_of_list([0.5348931595479329, 0.47372875562526207, 0.7109364198110805])
|> minigen.run
Ok(0.7109364198110805)
```

```gleam
minigen.element_of_list([])
|> minigen.run
Error(Nil)
```

* Shuffle a list

```gleam
minigen.shuffled_list([0.5348931595479329, 0.47372875562526207, 0.7109364198110805])
|> minigen.run
[0.47372875562526207, 0.5348931595479329, 0.7109364198110805]
```

* Create a random string

```gleam
minigen.string(8)
|> minigen.run
"U3j641WL"
```
