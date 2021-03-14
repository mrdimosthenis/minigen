import gleam/float
import gleam/int
import gleam/list
import gleam/pair
import gleam_zlists as zlist
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

pub fn list(gen: Generator(a), n: Int) -> Generator(List(a)) {
  let Generator(f) = gen
  let new_f = fn(seed_0) {
    case n > 0 {
      True -> {
        let Ok(res) =
          zlist.iterate(
            tuple(seed_0, []),
            fn(t) {
              let tuple(seed, ls) = t
              let tuple(next_seed, elem) = f(seed)
              let next_ls = list.append([elem], ls)
              tuple(next_seed, next_ls)
            },
          )
          |> zlist.fetch(n)
        res
      }
      False -> tuple(seed_0, [])
    }
  }
  Generator(new_f)
}

pub fn element_of_list(gen: Generator(List(a))) -> Generator(Result(a, Nil)) {
  let fun = fn(ls) {
    ls
    |> list.length
    |> integer
    |> map(fn(n) { list.at(ls, n) })
  }
  then(gen, fun)
}

pub fn shuffled_list(gen: Generator(List(a))) -> Generator(List(a)) {
  let move_to_edge = fn(ls) {
    case ls {
      [] -> always([])
      [x] -> always([x])
      _ ->
        ls
        |> list.length
        |> integer
        |> map2(
          boolean(),
          fn(i, b) {
            let tuple(before, rest) = list.split(ls, i)
            let tuple(elem, after) = list.split(rest, 1)
            case b {
              True -> list.flatten([elem, before, after])
              False -> list.flatten([before, after, elem])
            }
          },
        )
    }
  }

  let fun = fn(ls) {
    let init_acc = always(ls)
    list.fold(ls, init_acc, fn(_, acc) { then(acc, move_to_edge) })
  }

  then(gen, fun)
}
