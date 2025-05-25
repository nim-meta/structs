
import std/macros

proc defMayWithDefault(withDefKind: NimNodeKind, name, mayWithVal: NimNode): NimNode =
  if mayWithVal.kind == withDefKind: newIdentDefs(name, mayWithVal[0], mayWithVal[1])
  else: newIdentDefs(name, mayWithVal)

template callRevIf(typeFirst: bool, attr: NimNode): NimNode =
  if typeFirst:
    let
      mayWithVal = attr[1]
      typ = attr[0]
    if mayWithVal.kind == nnkExprEqExpr: newIdentDefs(mayWithVal[0], typ, mayWithVal[1])
    else: newIdentDefs(mayWithVal, typ)
    #defMayWithDefault(nnkExprEqExpr, attr[1], attr[0])
  else:
    defMayWithDefault(nnkExprEqExpr, attr[0], attr[1])

template emptyn*: NimNode = newEmptyNode()

proc eatAttrs*(attrs: NimNode, super: NimNode = ident"RootObj", typeFirst = static true): NimNode =
  result = nnkObjectTy.newTree emptyn
  result.add nnkOfInherit.newTree super
  var ls = nnkRecList.newTree
  for a in attrs:
    case a.kind
    of nnkCall:
      let st = a[1]
      st.expectKind nnkStmtList
      st.expectLen 1
      let rhs = st[0]
      ls.add defMayWithDefault(nnkAsgn, a[0], rhs)
    of nnkCommand:
      ls.add callRevIf(typeFirst, a) 
    of nnkAsgn:
      ls.add newIdentDefs(a[0], emptyn, a[1])
    else:
      error "attr: type or type attr expected, but got " & $a.kind & " '" & a.repr & '\'', a
  result.add ls
