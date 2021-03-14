pub external type Algorithm

pub external type State

pub external fn default_algorithm() -> Algorithm =
  "rand_native" "default_algorithm"

pub external fn seed_s(Algorithm) -> State =
  "rand" "seed_s"

pub external fn seed(Algorithm, Int) -> State =
  "rand" "seed"

pub external fn uniform_s(State) -> tuple(Float, State) =
  "rand" "uniform_s"
