import lustre
import lustre/element/html

// Quickstart guide at: https://hexdocs.pm/lustre/guide/01-quickstart.html
pub fn main() {
  let app = lustre.element(html.text("Hello, from @@@PROJECT@@@!"))
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
