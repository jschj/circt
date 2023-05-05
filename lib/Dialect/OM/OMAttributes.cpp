//===- OMAttributes.cpp - Object Model attribute definitions --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the Object Model attribute definitions.
//
//===----------------------------------------------------------------------===//

#include "circt/Dialect/OM/OMAttributes.h"
#include "circt/Dialect/OM/OMDialect.h"
#include "circt/Dialect/OM/OMTypes.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace circt::om;

#define GET_ATTRDEF_CLASSES
#include "circt/Dialect/OM/OMAttributes.cpp.inc"

Type circt::om::ReferenceAttr::getType() {
  return ReferenceType::get(getContext());
}

void circt::om::OMDialect::registerAttributes() {
  addAttributes<
#define GET_ATTRDEF_LIST
#include "circt/Dialect/OM/OMAttributes.cpp.inc"
      >();
}
