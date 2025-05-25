
# To run these tests, simply execute `nimble test`.

import unittest

import structs
test "struct X":

  type st2 = struct:
    a: int
    c = 3

  type st3{.used.} = struct of st2:
    b: int

  when defined(structsGoStyle):
    struct GoStyleSt:
      a int
  else:
    struct st:
      a = 1
      int b
      int c = 3
    check st().a == 1
