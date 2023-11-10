//// This module contains some useful functions for generating data in the Erlang ecosystem.
////
//// For more information see [this website](https://github.com/mrdimosthenis/minigen).

import gleam/float
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import minigen/interop

type Seed =
  interop.State

/// A type for representing generators.
/// In order for it to generate data, it should be passed as argument to the `run` or `run_with_seed` function.
pub type Generator(a) {
  Generator(fn(Seed) -> #(Seed, a))
}

fn random_seed() -> Seed {
  interop.default_algorithm()
  |> interop.seed_s()
}

fn fixed_seed(i: Int) -> Seed {
  interop.default_algorithm()
  |> interop.seed(i)
}

fn uniform(seed: Seed) -> #(Seed, Float) {
  let #(x, next_seed) = interop.uniform_s(seed)
  #(next_seed, x)
}

/// Creates pseudorandom data for a generator.
/// If we call this function several times, we will probably get different results.
///
///  #### Erlang example
///
/// ```erlang
/// GEN=minigen:float(),
/// minigen:run(GEN).
/// 0.7938520785840248
/// ```
///
///  #### Elixir example
///
/// ```elixir
/// :minigen.float
/// |> :minigen.run
/// 0.36087782004967894
/// ```
///
///  #### Gleam example
///
/// ```gleam
/// minigen.float()
/// |> minigen.run
/// 0.16296012690374562
/// ```
///
pub fn run(gen: Generator(a)) -> a {
  let Generator(f) = gen
  random_seed()
  |> f
  |> pair.second
}

/// Creates pseudorandom data for a generator but the result depends on the integer seed value.
/// If we call this function several times with the same seed, we will always get the same results.
///
///  #### Erlang example
///
/// ```erlang
/// GEN=minigen:float(),
/// minigen:run_with_seed(GEN, 1000).
/// 0.7109364198110805
/// ```
///
///  #### Elixir example
///
/// ```elixir
/// :minigen.float
/// |> :minigen.run_with_seed(999)
/// 0.4944539429884903
/// ```
///
///  #### Gleam example
///
/// ```gleam
/// minigen.float()
/// |> minigen.run_with_seed(998)
/// 0.29739016530475904
/// ```
///
pub fn run_with_seed(gen: Generator(a), i: Int) -> a {
  let Generator(f) = gen
  i
  |> fixed_seed
  |> f
  |> pair.second
}

pub fn map(gen: Generator(a), fun: fn(a) -> b) -> Generator(b) {
  let Generator(f) = gen
  let new_f = fn(seed_0) {
    let #(seed_1, a) = f(seed_0)
    #(seed_1, fun(a))
  }
  Generator(new_f)
}

pub fn map2(
  gen_a: Generator(a),
  gen_b: Generator(b),
  fun: fn(a, b) -> c,
) -> Generator(c) {
  let Generator(f_a) = gen_a
  let Generator(f_b) = gen_b
  let f = fn(seed_0) {
    let #(seed_1, a) = f_a(seed_0)
    let #(seed_2, b) = f_b(seed_1)
    #(seed_2, fun(a, b))
  }
  Generator(f)
}

pub fn map3(
  gen_a: Generator(a),
  gen_b: Generator(b),
  gen_c: Generator(c),
  fun: fn(a, b, c) -> d,
) -> Generator(d) {
  let Generator(f_a) = gen_a
  let Generator(f_b) = gen_b
  let Generator(f_c) = gen_c
  let f = fn(seed_0) {
    let #(seed_1, a) = f_a(seed_0)
    let #(seed_2, b) = f_b(seed_1)
    let #(seed_3, c) = f_c(seed_2)
    #(seed_3, fun(a, b, c))
  }
  Generator(f)
}

pub fn map4(
  gen_a: Generator(a),
  gen_b: Generator(b),
  gen_c: Generator(c),
  gen_d: Generator(d),
  fun: fn(a, b, c, d) -> e,
) -> Generator(e) {
  let Generator(f_a) = gen_a
  let Generator(f_b) = gen_b
  let Generator(f_c) = gen_c
  let Generator(f_d) = gen_d
  let f = fn(seed_0) {
    let #(seed_1, a) = f_a(seed_0)
    let #(seed_2, b) = f_b(seed_1)
    let #(seed_3, c) = f_c(seed_2)
    let #(seed_4, d) = f_d(seed_3)
    #(seed_4, fun(a, b, c, d))
  }
  Generator(f)
}

pub fn map5(
  gen_a: Generator(a),
  gen_b: Generator(b),
  gen_c: Generator(c),
  gen_d: Generator(d),
  gen_e: Generator(e),
  fun: fn(a, b, c, d, e) -> t,
) -> Generator(t) {
  let Generator(f_a) = gen_a
  let Generator(f_b) = gen_b
  let Generator(f_c) = gen_c
  let Generator(f_d) = gen_d
  let Generator(f_e) = gen_e
  let f = fn(seed_0) {
    let #(seed_1, a) = f_a(seed_0)
    let #(seed_2, b) = f_b(seed_1)
    let #(seed_3, c) = f_c(seed_2)
    let #(seed_4, d) = f_d(seed_3)
    let #(seed_5, e) = f_e(seed_4)
    #(seed_5, fun(a, b, c, d, e))
  }
  Generator(f)
}

pub fn then(gen: Generator(a), fun: fn(a) -> Generator(b)) -> Generator(b) {
  let Generator(f) = gen
  let new_f = fn(seed_0) {
    let #(seed_1, a) = f(seed_0)
    let Generator(g) = fun(a)
    g(seed_1)
  }
  Generator(new_f)
}

pub fn always(x: a) -> Generator(a) {
  let f = fn(seed) { #(seed, x) }
  Generator(f)
}

/// Creates a generator for float values.
/// By running it, we get a random float uniformly distributed between 0.0 (included) and 1.0 (excluded).
///
///  #### Erlang example
///
/// ```erlang
/// GEN=minigen:float(),
/// minigen:run(GEN).
/// 0.7938520785840248
/// ```
///
///  #### Elixir example
///
/// ```elixir
/// :minigen.float
/// |> :minigen.run
/// 0.36087782004967894
/// ```
///
///  #### Gleam example
///
/// ```gleam
/// minigen.float()
/// |> minigen.run
/// 0.16296012690374562
/// ```
///
pub fn float() -> Generator(Float) {
  let f = fn(seed_0) {
    let #(seed_1, x) = uniform(seed_0)
    #(seed_1, x)
  }
  Generator(f)
}

/// Creates a generator for integer values.
/// By running it, we get a random integer uniformly distributed between 0 (included) and `n` (excluded).
///
///  #### Erlang example
///
/// ```erlang
/// GEN=minigen:integer(10),
/// minigen:run(GEN).
/// 4
/// ```
///
///  #### Elixir example
///
/// ```elixir
/// :minigen.integer(10)
/// |> :minigen.run
/// 8
/// ```
///
///  #### Gleam example
///
/// ```gleam
/// minigen.integer(10)
/// |> minigen.run
/// 6
/// ```
///
pub fn integer(n: Int) -> Generator(Int) {
  use x <- map(float())
  x *. int.to_float(n)
  |> float.floor
  |> float.round
}

/// Creates a generator for boolean values.
/// By running it, we get a random boolean value with 50% probability.
///
///  #### Erlang example
///
/// ```erlang
/// GEN=minigen:boolean(),
/// minigen:run(GEN).
/// true
/// ```
///
///  #### Elixir example
///
/// ```elixir
/// :minigen.boolean
/// |> :minigen.run
/// false
/// ```
///
///  #### Gleam example
///
/// ```gleam
/// minigen.boolean()
/// |> minigen.run
/// True
/// ```
///
pub fn boolean() -> Generator(Bool) {
  use x <- map(float())
  x <. 0.5
}

/// Creates a generator that randomly selects an element from a list.
/// If the list is empty, then we will get an error.
///
///  #### Erlang examples
///
/// ```erlang
/// GEN=minigen:element_of_list([1, 2, 3]),
/// minigen:run(GEN).
/// {ok,2}
/// ```
///
/// ```erlang
/// GEN=minigen:element_of_list([]),
/// minigen:run(GEN).
/// {error,nil}
/// ```
///
///  #### Elixir examples
///
/// ```elixir
/// :minigen.element_of_list(["a", "b", "c", "d"])
/// |> :minigen.run
/// {:ok, "c"}
/// ```
///
/// ```elixir
/// :minigen.element_of_list([])
/// |> :minigen.run
/// {:error, nil}
/// ```
///  #### Gleam examples
///
/// ```gleam
/// minigen.element_of_list([0.5348931595479329, 0.47372875562526207, 0.7109364198110805])
/// |> minigen.run
/// Ok(0.7109364198110805)
/// ```
///
/// ```gleam
/// minigen.element_of_list([])
/// |> minigen.run
/// Error(Nil)
/// ```
///
pub fn element_of_list(ls: List(a)) -> Generator(Result(a, Nil)) {
  ls
  |> list.length
  |> integer
  |> map(list.at(ls, _))
}

/// Creates a generator that changes the order of the elements in a list.
///
///  #### Erlang example
///
/// ```erlang
/// GEN=minigen:shuffled_list([1, 2, 3]),
/// minigen:run(GEN).
/// [2,1,3]
/// ```
///
///  #### Elixir example
///
/// ```elixir
/// :minigen.shuffled_list(["a", "b", "c", "d"])
/// |> :minigen.run
/// ["c", "d", "b", "a"]
/// ```
///
///  #### Gleam example
///
/// ```gleam
/// minigen.shuffled_list([0.5348931595479329, 0.47372875562526207, 0.7109364198110805])
/// |> minigen.run
/// [0.47372875562526207, 0.5348931595479329, 0.7109364198110805]
/// ```
///
pub fn shuffled_list(ls: List(a)) -> Generator(List(a)) {
  case ls {
    [] -> always([])
    _ -> {
      let gen =
        ls
        |> list.length
        |> list.range(1)
        |> list.map(integer)
        |> sequence
      {
        use indexes <- map(gen)
        use acc, i <- list.fold(indexes, #([], ls))
        let #(selected_elems, rest_elems) = acc
        let #(before, [chosen, ..after]) = list.split(rest_elems, i)
        let next_selected_elems = list.prepend(selected_elems, chosen)
        let next_rest_elems = list.append(before, after)
        #(next_selected_elems, next_rest_elems)
      }
      |> map(pair.first)
    }
  }
}

fn graphemes() -> List(String) {
  [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o",
    "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D",
    "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S",
    "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7",
    "8", "9",
  ]
}

/// Creates a generator for string values.
/// The generated string will contain `n` alphanumerics.
///
///  #### Erlang example
///
/// ```erlang
/// GEN=minigen:string(6),
/// minigen:run(GEN).
/// "3Rzpqd"
/// ```
///
///  #### Elixir example
///
/// ```elixir
/// :minigen.string(7)
/// |> :minigen.run
/// "eJKp8sc"
/// ```
///
///  #### Gleam example
///
/// ```gleam
/// minigen.string(8)
/// |> minigen.run
/// "U3j641WL"
/// ```
///
pub fn string(n: Int) -> Generator(String) {
  graphemes()
  |> element_of_list
  |> map(fn(r) {
    let assert Ok(c) = r
    c
  })
  |> list(n)
  |> map(list.reverse)
  |> map(string.join(_, ""))
}

fn list_go(
  gen: Generator(a),
  seed: Seed,
  ls: List(a),
  n: Int,
) -> #(Seed, List(a)) {
  case n {
    0 -> #(seed, ls)
    _ -> {
      let Generator(f) = gen
      let #(next_seed, value) = f(seed)
      let next_ls = list.prepend(ls, value)
      list_go(gen, next_seed, next_ls, n - 1)
    }
  }
}

pub fn list(gen: Generator(a), n: Int) -> Generator(List(a)) {
  let f = fn(seed) { list_go(gen, seed, [], n) }
  Generator(f)
}

pub fn sequence(gens: List(Generator(a))) -> Generator(List(a)) {
  {
    use acc_gen, next_gen <- list.fold(gens, always([]))
    use acc_ls <- then(acc_gen)
    use next_head <- map(next_gen)
    list.prepend(acc_ls, next_head)
  }
  |> map(list.reverse)
}
