import minigen/interop
import gleeunit/should

pub fn uniform_s_test() {
  let init_state =
    interop.default_algorithm()
    |> interop.seed(1000)
  let #(x, new_state) = interop.uniform_s(init_state)
  should.equal(x, 0.7109364198110805)
  let #(y, _) = interop.uniform_s(init_state)
  should.equal(y, 0.7109364198110805)
  let #(z, _) = interop.uniform_s(new_state)
  should.equal(z, 0.47372875562526207)
}
