pub type Algorithm

pub type State

@external(erlang, "native_rand_mimigen", "default_algorithm")
pub fn default_algorithm() -> Algorithm

@external(erlang, "rand", "seed_s")
pub fn seed_s(algorithm: Algorithm) -> State

@external(erlang, "rand", "seed")
pub fn seed(algorithm: Algorithm, int: Int) -> State

@external(erlang, "rand", "uniform_s")
pub fn uniform_s(state: State) -> #(Float, State)
