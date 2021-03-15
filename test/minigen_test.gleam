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

pub fn element_of_list_test() {
  [False, False, True, False]
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(True))

  [0.5348931595479329, 0.47372875562526207, 0.7109364198110805]
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(0.7109364198110805))

  [2, 9, 5, 4, 7]
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(4))

  [2, 9, 5, 4, 7]
  |> minigen.element_of_list
  |> minigen.run_with_seed(999)
  |> should.equal(Ok(5))

  [6]
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(6))

  [6]
  |> minigen.element_of_list
  |> minigen.run()
  |> should.equal(Ok(6))

  []
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Error(Nil))

  []
  |> minigen.element_of_list
  |> minigen.run()
  |> should.equal(Error(Nil))
}

pub fn shuffled_list_test() {
  [False, False, True, False]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(1000)
  |> should.equal([False, False, False, True])

  [0.5348931595479329, 0.47372875562526207, 0.7109364198110805]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(1000)
  |> should.equal([0.47372875562526207, 0.5348931595479329, 0.7109364198110805])

  [2, 9, 5, 4, 7]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(1000)
  |> should.equal([7, 2, 9, 5, 4])

  [2, 9, 5, 4, 7]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(999)
  |> should.equal([2, 4, 7, 9, 5])

  [2, 9, 5, 4, 7]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(998)
  |> should.equal([4, 7, 5, 9, 2])

  [1, 2, 3]
  |> minigen.shuffled_list
  |> minigen.list(30)
  |> minigen.run_with_seed(1000)
  |> should.equal([
    [1, 2, 3],
    [1, 2, 3],
    [3, 1, 2],
    [2, 3, 1],
    [1, 3, 2],
    [3, 1, 2],
    [3, 1, 2],
    [3, 1, 2],
    [3, 2, 1],
    [3, 2, 1],
    [1, 2, 3],
    [2, 1, 3],
    [3, 1, 2],
    [2, 1, 3],
    [2, 3, 1],
    [2, 3, 1],
    [1, 2, 3],
    [1, 3, 2],
    [2, 3, 1],
    [1, 2, 3],
    [3, 2, 1],
    [1, 3, 2],
    [1, 3, 2],
    [1, 3, 2],
    [1, 3, 2],
    [1, 2, 3],
    [3, 2, 1],
    [2, 1, 3],
    [3, 2, 1],
    [2, 1, 3],
  ])

  [False, True]
  |> minigen.shuffled_list
  |> minigen.list(20)
  |> minigen.run_with_seed(1000)
  |> should.equal([
    [False, True],
    [False, True],
    [True, False],
    [False, True],
    [False, True],
    [False, True],
    [True, False],
    [False, True],
    [False, True],
    [False, True],
    [False, True],
    [True, False],
    [False, True],
    [True, False],
    [True, False],
    [True, False],
    [True, False],
    [True, False],
    [False, True],
    [False, True],
  ])

  [6]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(1000)
  |> should.equal([6])

  [6]
  |> minigen.shuffled_list
  |> minigen.run()
  |> should.equal([6])

  []
  |> minigen.shuffled_list
  |> minigen.run_with_seed(1000)
  |> should.equal([])

  []
  |> minigen.shuffled_list
  |> minigen.run()
  |> should.equal([])
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
