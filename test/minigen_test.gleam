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

pub fn list_test() {
  minigen.boolean()
  |> minigen.list(4)
  |> minigen.run_with_seed(1000)
  |> should.equal([False, False, True, False])

  minigen.float()
  |> minigen.list(3)
  |> minigen.run_with_seed(1000)
  |> should.equal([0.5348931595479329, 0.47372875562526207, 0.7109364198110805])

  minigen.integer(10)
  |> minigen.list(5)
  |> minigen.run_with_seed(1000)
  |> should.equal([2, 9, 5, 4, 7])

  minigen.integer(10)
  |> minigen.list(5)
  |> minigen.run_with_seed(999)
  |> should.equal([5, 7, 3, 1, 4])

  minigen.integer(5)
  |> minigen.list(0)
  |> minigen.run_with_seed(1000)
  |> should.equal([])

  minigen.integer(5)
  |> minigen.list(1)
  |> minigen.run_with_seed(1000)
  |> should.equal([3])
}

pub fn element_of_list_test() {
  minigen.always([False, False, True, False])
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(True))

  minigen.always([0.5348931595479329, 0.47372875562526207, 0.7109364198110805])
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(0.7109364198110805))

  minigen.always([2, 9, 5, 4, 7])
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(4))

  minigen.always([2, 9, 5, 4, 7])
  |> minigen.element_of_list
  |> minigen.run_with_seed(999)
  |> should.equal(Ok(5))

  minigen.always([6])
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(6))

  minigen.always([6])
  |> minigen.element_of_list
  |> minigen.run()
  |> should.equal(Ok(6))

  minigen.always([])
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Error(Nil))

  minigen.always([])
  |> minigen.element_of_list
  |> minigen.run()
  |> should.equal(Error(Nil))
}
