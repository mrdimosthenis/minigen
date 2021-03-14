import minigen
import gleam/should

pub fn always_test() {
  minigen.always(5.0)
  |> minigen.run_with_seed(1000)
  |> should.equal(5.0)

  minigen.always("six")
  |> minigen.run_with_seed(999)
  |> should.equal("six")

  minigen.always(7)
  |> minigen.run()
  |> should.equal(7)
}

pub fn float_test() {
  minigen.float()
  |> minigen.run_with_seed(1000)
  |> should.equal(0.7109364198110805)

  minigen.float()
  |> minigen.run_with_seed(999)
  |> should.equal(0.4944539429884903)

  let random_float =
    minigen.float()
    |> minigen.run

  should.be_true(random_float >=. 0.0)

  should.be_true(random_float <. 1.0)
}

pub fn integer_test() {
  minigen.integer(10)
  |> minigen.run_with_seed(1000)
  |> should.equal(7)

  minigen.integer(10)
  |> minigen.run_with_seed(999)
  |> should.equal(4)

  let random_integer =
    minigen.integer(5)
    |> minigen.run

  should.be_true(random_integer >= 0)

  should.be_true(random_integer < 10)
}

pub fn boolean_test() {
  minigen.boolean()
  |> minigen.run_with_seed(1000)
  |> should.equal(False)

  minigen.boolean()
  |> minigen.run_with_seed(999)
  |> should.equal(True)
}
