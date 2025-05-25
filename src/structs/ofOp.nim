
import std/macros
import ./[util]
macro `of`*(structLit: typed; super: typed, attrs): untyped =
  assert $structLit == "struct"
  #[
  Don't use `struct.strVal` as `structLit.kind == nnkClosedSymChoice`.
  However, note `structLit != bindSym("struct", brClosed)`
  (after `import ./macroImpl`),
  just because their children order differs!
  (checked against symBodyHash of children)`)
  ]#
  eatAttrs(attrs, super)
