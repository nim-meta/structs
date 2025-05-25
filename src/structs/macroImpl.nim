
import std/macros
import ./util
template structImpl(args: varargs[untyped]): NimNode =
  eatAttrs(args, typeFirst=not defined(structsGoStyle))

macro struct*(attrs): untyped =
  structImpl(attrs)

macro struct*(nameMayWithSuper, attrs) =
  var name = nameMayWithSuper
  let objDef = (
    if nameMayWithSuper.kind == nnkCall:
      name = nameMayWithSuper[0]
      structImpl(attrs, nameMayWithSuper[1])
    else:
      structImpl(attrs)
  )
  result = quote do:
    type `name` = `objDef`

