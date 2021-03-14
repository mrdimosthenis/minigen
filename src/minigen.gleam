import gleam/float
import gleam/int
import gleam/list
import gleam/pair
import minigen/interop

pub type Seed =
  interop.State

pub type Generator(a) {
  Generator(fn(Seed) -> tuple(Seed, a))
}

fn random_seed() -> Seed {
  interop.default_algorithm()
  |> interop.seed_s()
}

fn fixed_seed(i: Int) -> Seed {
  interop.default_algorithm()
  |> interop.seed(i)
}

fn uniform(seed: Seed) -> tuple(Seed, Float) {
  let tuple(x, next_seed) = interop.uniform_s(seed)
  tuple(next_seed, x)
}

pub fn run(gen: Generator(a)) -> a {
  let Generator(f) = gen
  random_seed()
  |> f
  |> pair.second
}

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
    let tuple(seed_1, a) = f(seed_0)
    tuple(seed_1, fun(a))
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
    let tuple(seed_1, a) = f_a(seed_0)
    let tuple(seed_2, b) = f_b(seed_1)
    tuple(seed_2, fun(a, b))
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
    let tuple(seed_1, a) = f_a(seed_0)
    let tuple(seed_2, b) = f_b(seed_1)
    let tuple(seed_3, c) = f_c(seed_2)
    tuple(seed_3, fun(a, b, c))
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
    let tuple(seed_1, a) = f_a(seed_0)
    let tuple(seed_2, b) = f_b(seed_1)
    let tuple(seed_3, c) = f_c(seed_2)
    let tuple(seed_4, d) = f_d(seed_3)
    tuple(seed_4, fun(a, b, c, d))
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
    let tuple(seed_1, a) = f_a(seed_0)
    let tuple(seed_2, b) = f_b(seed_1)
    let tuple(seed_3, c) = f_c(seed_2)
    let tuple(seed_4, d) = f_d(seed_3)
    let tuple(seed_5, e) = f_e(seed_4)
    tuple(seed_5, fun(a, b, c, d, e))
  }
  Generator(f)
}

pub fn then(gen: Generator(a), fun: fn(a) -> Generator(b)) -> Generator(b) {
  let Generator(f) = gen
  let new_f = fn(seed_0) {
    let tuple(seed_1, a) = f(seed_0)
    let Generator(g) = fun(a)
    g(seed_1)
  }
  Generator(new_f)
}

pub fn always(x: a) -> Generator(a) {
  let f = fn(seed) { tuple(seed, x) }
  Generator(f)
}

pub fn float() -> Generator(Float) {
  let f = fn(seed_0) {
    let tuple(seed_1, x) = uniform(seed_0)
    tuple(seed_1, x)
  }
  Generator(f)
}

pub fn integer(n: Int) -> Generator(Int) {
  float()
  |> map(fn(x) {
    x *. int.to_float(n)
    |> float.floor
    |> float.round
  })
}

pub fn boolean() -> Generator(Bool) {
  float()
  |> map(fn(x) { x <. 0.5 })
}

fn list_help(
  gen: Generator(a),
  seed: Seed,
  rev_list: List(a),
  n: Int,
) -> tuple(Seed, List(a)) {
  case n < 1 {
    True -> tuple(seed, rev_list)
    False -> {
      let Generator(f) = gen
      let tuple(next_seed, value) = f(seed)
      list_help(gen, next_seed, list.append([value], rev_list), n - 1)
    }
  }
}

pub fn list(gen: Generator(a), n: Int) -> Generator(List(a)) {
  let new_f = fn(seed) { list_help(gen, seed, list.new(), n) }
  Generator(new_f)
}

pub fn pair(gen_a: Generator(a), gen_b: Generator(b)) -> Generator(tuple(a, b)) {
  map2(gen_a, gen_b, fn(a, b) { tuple(a, b) })
}
