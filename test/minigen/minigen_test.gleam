import minigen
import gleam/list
import gleeunit/should

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
  |> should.equal(0.27586903946041397)

  minigen.float()
  |> minigen.run_with_seed(999)
  |> should.equal(0.14229440857120912)

  let random_float =
    minigen.float()
    |> minigen.run

  should.be_true(random_float >=. 0.0)

  should.be_true(random_float <. 1.0)
}

pub fn integer_test() {
  minigen.integer(10)
  |> minigen.run_with_seed(1000)
  |> should.equal(2)

  minigen.integer(10)
  |> minigen.run_with_seed(999)
  |> should.equal(1)

  let random_integer =
    minigen.integer(5)
    |> minigen.run

  should.be_true(random_integer >= 0)

  should.be_true(random_integer < 10)
}

pub fn boolean_test() {
  minigen.boolean()
  |> minigen.run_with_seed(1000)
  |> should.equal(True)

  minigen.boolean()
  |> minigen.run_with_seed(1001)
  |> should.equal(False)
}

pub fn element_of_list_test() {
  [False, False, True, False]
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(False))

  [0.5348931595479329, 0.1952355138836377, 0.27586903946041397]
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(0.5348931595479329))

  [2, 9, 5, 4, 7]
  |> minigen.element_of_list
  |> minigen.run_with_seed(1000)
  |> should.equal(Ok(9))

  [2, 9, 5, 4, 7]
  |> minigen.element_of_list
  |> minigen.run_with_seed(999)
  |> should.equal(Ok(2))

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
  |> should.equal([True, False, False, False])

  [0.5348931595479329, 0.1952355138836377, 0.27586903946041397]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(1000)
  |> should.equal([0.27586903946041397, 0.1952355138836377, 0.5348931595479329])

  [2, 9, 5, 4, 7]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(1000)
  |> should.equal([4, 5, 7, 2, 9])

  [2, 9, 5, 4, 7]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(999)
  |> should.equal([5, 7, 4, 9, 2])

  [2, 9, 5, 4, 7]
  |> minigen.shuffled_list
  |> minigen.run_with_seed(998)
  |> should.equal([4, 9, 2, 7, 5])

  [1, 2, 3]
  |> minigen.shuffled_list
  |> minigen.list(30)
  |> minigen.run_with_seed(1000)
  |> should.equal([
    [2, 3, 1],
    [2, 1, 3],
    [2, 1, 3],
    [2, 1, 3],
    [1, 2, 3],
    [1, 3, 2],
    [2, 1, 3],
    [3, 2, 1],
    [1, 2, 3],
    [1, 3, 2],
    [3, 1, 2],
    [3, 1, 2],
    [2, 1, 3],
    [3, 1, 2],
    [3, 2, 1],
    [1, 3, 2],
    [2, 3, 1],
    [3, 2, 1],
    [1, 2, 3],
    [3, 2, 1],
    [1, 2, 3],
    [1, 2, 3],
    [3, 1, 2],
    [3, 2, 1],
    [1, 3, 2],
    [1, 3, 2],
    [2, 1, 3],
    [1, 2, 3],
    [3, 2, 1],
    [3, 2, 1],
  ])

  [False, True]
  |> minigen.shuffled_list
  |> minigen.list(20)
  |> minigen.run_with_seed(1000)
  |> should.equal([
    [False, True],
    [True, False],
    [False, True],
    [False, True],
    [True, False],
    [False, True],
    [False, True],
    [False, True],
    [True, False],
    [False, True],
    [True, False],
    [False, True],
    [False, True],
    [True, False],
    [True, False],
    [True, False],
    [False, True],
    [True, False],
    [False, True],
    [True, False],
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

pub fn string_test() {
  4
  |> minigen.string
  |> minigen.run_with_seed(1000)
  |> should.equal("rmPg")

  5
  |> minigen.string
  |> minigen.run_with_seed(1000)
  |> should.equal("rmPgD")

  5
  |> minigen.string
  |> minigen.run_with_seed(999)
  |> should.equal("ikD7Q")

  1
  |> minigen.string
  |> minigen.run_with_seed(1000)
  |> should.equal("r")

  0
  |> minigen.string
  |> minigen.run_with_seed(1000)
  |> should.equal("")
}

pub fn list_test() {
  minigen.boolean()
  |> minigen.list(4)
  |> minigen.run_with_seed(1000)
  |> should.equal([True, False, True, True])

  minigen.float()
  |> minigen.list(3)
  |> minigen.run_with_seed(1000)
  |> should.equal([0.6724156678264623, 0.1952355138836377, 0.27586903946041397])

  minigen.integer(10)
  |> minigen.list(5)
  |> minigen.run_with_seed(1000)
  |> should.equal([4, 1, 6, 1, 2])

  minigen.integer(10)
  |> minigen.list(5)
  |> minigen.run_with_seed(999)
  |> should.equal([6, 9, 4, 1, 1])

  minigen.integer(5)
  |> minigen.list(0)
  |> minigen.run_with_seed(1000)
  |> should.equal([])

  minigen.integer(5)
  |> minigen.list(1)
  |> minigen.run_with_seed(1000)
  |> should.equal([1])
}

pub fn sequence_test() {
  [
    minigen.integer(1),
    minigen.integer(2),
    minigen.integer(3),
    minigen.integer(4),
    minigen.integer(5),
    minigen.integer(6),
    minigen.integer(7),
    minigen.integer(8),
    minigen.integer(9),
    minigen.integer(10),
    minigen.integer(11),
    minigen.integer(12),
  ]
  |> minigen.sequence
  |> minigen.run_with_seed(1000)
  |> should.equal([0, 0, 2, 0, 2, 2, 6, 5, 2, 8, 4, 0])

  minigen.boolean()
  |> list.repeat(4)
  |> minigen.sequence
  |> minigen.run_with_seed(1000)
  |> should.equal([True, True, False, True])

  minigen.float()
  |> list.repeat(3)
  |> minigen.sequence
  |> minigen.run_with_seed(1000)
  |> should.equal([0.27586903946041397, 0.1952355138836377, 0.6724156678264623])

  minigen.integer(10)
  |> list.repeat(5)
  |> minigen.sequence
  |> minigen.run_with_seed(1000)
  |> should.equal([2, 1, 6, 1, 4])

  minigen.integer(10)
  |> list.repeat(5)
  |> minigen.sequence
  |> minigen.run_with_seed(999)
  |> should.equal([1, 1, 4, 9, 6])

  []
  |> minigen.sequence
  |> minigen.run_with_seed(1000)
  |> should.equal([])

  [minigen.integer(5)]
  |> minigen.sequence
  |> minigen.run_with_seed(1000)
  |> should.equal([1])
}
