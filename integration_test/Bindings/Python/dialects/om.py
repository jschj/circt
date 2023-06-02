# REQUIRES: bindings_python
# RUN: %PYTHON% %s | FileCheck %s

import circt
from circt.dialects import om
from circt.ir import Context, InsertionPoint, Location, Module
from circt.support import var_to_attribute

from dataclasses import dataclass

with Context() as ctx, Location.unknown():
  circt.register_dialects(ctx)

  module = Module.parse("""
  module {
    om.class @Test(%param: i64) {
      om.class.field @field, %param : i64

      %0 = om.object @Child() : () -> !om.class.type<@Child>
      om.class.field @child, %0 : !om.class.type<@Child>
    }
    om.class @Child() {
      %0 = om.constant 14 : i64
      om.class.field @foo, %0 : i64
    }
  }
  """)

  evaluator = om.Evaluator(module)

# Test instantiate failure.


@dataclass
class Test:
  field: int


try:
  obj = evaluator.instantiate(Test)
except ValueError as e:
  # CHECK: actual parameter list length (0) does not match
  # CHECK: actual parameters:
  # CHECK: formal parameters:
  # CHECK: unable to instantiate object, see previous error(s)
  print(e)

# Test get field failure.


@dataclass
class Test:
  foo: int


try:
  obj = evaluator.instantiate(Test, 42)
except ValueError as e:
  # CHECK: field "foo" does not exist
  # CHECK: see current operation:
  # CHECK: unable to get field, see previous error(s)
  print(e)

# Test instantiate success.


@dataclass
class Child:
  foo: int


@dataclass
class Test:
  field: int
  child: Child


obj = evaluator.instantiate(Test, 42)

# CHECK: Test(field=42, child=Child(foo=14))
print(obj)
