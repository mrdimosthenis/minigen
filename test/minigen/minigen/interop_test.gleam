import minigen/interop
import gleeunit/should

pub fn uniform_s_test() {
  let init_state =
    interop.default_algorithm()
    |> interop.seed(1000)
  let #(x, new_state) = interop.uniform_s(init_state)
  should.equal(x, 0.27586903946041397)
  let #(y, _) = interop.uniform_s(init_state)
  should.equal(y, 0.27586903946041397)
  let #(z, _) = interop.uniform_s(new_state)
  should.equal(z, 0.1952355138836377)
}
