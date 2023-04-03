// RUN: circt-opt %s --lower-arc-to-llvm | FileCheck %s

// CHECK-LABEL: llvm.func @EmptyArc() {
arc.define @EmptyArc() {
  arc.output
  // CHECK-NEXT: llvm.return
}
// CHECK-NEXT: }

// CHECK-LABEL: llvm.func @Types(
// CHECK-SAME:    %arg0: !llvm.ptr<i8>
// CHECK-SAME:    %arg1: !llvm.ptr<i1>
// CHECK-SAME:    %arg2: !llvm.ptr<i72>
// CHECK-SAME:  ) -> !llvm.struct<(
// CHECK-SAME:    ptr<i8>
// CHECK-SAME:    ptr<i1>
// CHECK-SAME:  )> {
func.func @Types(
  %arg0: !arc.storage,
  %arg1: !arc.state<i1>,
  %arg2: !arc.memory<4 x i7, 9>
) -> (
  !arc.storage,
  !arc.state<i1>,
  !arc.memory<4 x i7, 9>
) {
  return %arg0, %arg1, %arg2 : !arc.storage, !arc.state<i1>, !arc.memory<4 x i7, 9>
  // CHECK: llvm.return
  // CHECK-SAME: !llvm.struct<(ptr<i8>, ptr<i1>, ptr<i72>)>
}
// CHECK-NEXT: }

// CHECK-LABEL: llvm.func @StorageTypes(%arg0: !llvm.ptr<i8>) -> !llvm.struct<(ptr<i1>, ptr<i24>, ptr<i8>)> {
func.func @StorageTypes(%arg0: !arc.storage) -> (!arc.state<i1>, !arc.memory<4 x i1, 3>, !arc.storage) {
  %0 = arc.storage.get %arg0[42] : !arc.storage -> !arc.state<i1>
  // CHECK-NEXT: [[OFFSET:%.+]] = llvm.mlir.constant(42 :
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[[[OFFSET]]]
  // CHECK-NEXT: llvm.bitcast [[PTR]] : !llvm.ptr<i8> to !llvm.ptr<i1>
  %1 = arc.storage.get %arg0[43] : !arc.storage -> !arc.memory<4 x i1, 3>
  // CHECK-NEXT: [[OFFSET:%.+]] = llvm.mlir.constant(43 :
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[[[OFFSET]]]
  // CHECK-NEXT: llvm.bitcast [[PTR]] : !llvm.ptr<i8> to !llvm.ptr<i24>
  %2 = arc.storage.get %arg0[44] : !arc.storage -> !arc.storage
  // CHECK-NEXT: [[OFFSET:%.+]] = llvm.mlir.constant(44 :
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[[[OFFSET]]]
  return %0, %1, %2 : !arc.state<i1>, !arc.memory<4 x i1, 3>, !arc.storage
  // CHECK: llvm.return
}
// CHECK-NEXT: }

// CHECK-LABEL: llvm.func @StateAllocation(%arg0: !llvm.ptr<i8>) {
func.func @StateAllocation(%arg0: !arc.storage<10>) {
  arc.root_input "a", %arg0 {offset = 0} : (!arc.storage<10>) -> !arc.state<i1>
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[0]
  // CHECK-NEXT: llvm.bitcast [[PTR]] : !llvm.ptr<i8> to !llvm.ptr<i1>
  arc.root_output "b", %arg0 {offset = 1} : (!arc.storage<10>) -> !arc.state<i2>
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[1]
  // CHECK-NEXT: llvm.bitcast [[PTR]] : !llvm.ptr<i8> to !llvm.ptr<i2>
  arc.alloc_state %arg0 {offset = 2} : (!arc.storage<10>) -> !arc.state<i3>
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[2]
  // CHECK-NEXT: llvm.bitcast [[PTR]] : !llvm.ptr<i8> to !llvm.ptr<i3>
  arc.alloc_memory %arg0 {offset = 3, stride = 1} : (!arc.storage<10>) -> !arc.memory<4 x i1, 1>
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[3]
  // CHECK-NOT:  llvm.bitcast
  arc.alloc_memory %arg0 {offset = 3, stride = 3} : (!arc.storage<10>) -> !arc.memory<4 x i1, 3>
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[3]
  // CHECK-NEXT: llvm.bitcast [[PTR]] : !llvm.ptr<i8> to !llvm.ptr<i24>
  arc.alloc_storage %arg0[7] : (!arc.storage<10>) -> !arc.storage<3>
  // CHECK-NEXT: [[PTR:%.+]] = llvm.getelementptr %arg0[7]
  return
  // CHECK-NEXT: llvm.return
}
// CHECK-NEXT: }

// CHECK-LABEL: llvm.func @StateUpdates(%arg0: !llvm.ptr<i8>) {
func.func @StateUpdates(%arg0: !arc.storage<1>) {
  %0 = arc.alloc_state %arg0 {offset = 0} : (!arc.storage<1>) -> !arc.state<i1>
  // CHECK-NEXT: [[RAW_PTR:%.+]] = llvm.getelementptr %arg0[0]
  // CHECK-NEXT: [[PTR:%.+]] = llvm.bitcast [[RAW_PTR]] : !llvm.ptr<i8> to !llvm.ptr<i1>
  %1 = arc.state_read %0 : <i1>
  // CHECK-NEXT: [[LOAD:%.+]] = llvm.load [[PTR]]
  arc.state_write %0 = %1 : <i1>
  // CHECK-NEXT: llvm.store [[LOAD]], [[PTR]]
  %false = hw.constant false
  arc.state_write %0 = %false if %1 : <i1>
  // CHECK-NEXT:   [[FALSE:%.+]] = llvm.mlir.constant(false)
  // CHECK-NEXT:   llvm.cond_br [[LOAD]], [[BB1:\^.+]], [[BB2:\^.+]]
  // CHECK-NEXT: [[BB1]]:
  // CHECK-NEXT:   llvm.store [[FALSE]], [[PTR]]
  // CHECK-NEXT:   llvm.br [[BB2]]
  // CHECK-NEXT: [[BB2]]:
  return
  // CHECK-NEXT: llvm.return
}
// CHECK-NEXT: }

// CHECK-LABEL: llvm.func @MemoryUpdates(%arg0: !llvm.ptr<i8>, %arg1: i1) {
func.func @MemoryUpdates(%arg0: !arc.storage<24>, %enable: i1) {
  %0 = arc.alloc_memory %arg0 {offset = 0, stride = 6} : (!arc.storage<24>) -> !arc.memory<4 x i42, 6>
  // CHECK-NEXT: [[RAW_PTR:%.+]] = llvm.getelementptr %arg0[0]
  // CHECK-NEXT: [[PTR:%.+]] = llvm.bitcast [[RAW_PTR]] : !llvm.ptr<i8> to !llvm.ptr<i48>

  %clk = hw.constant true
  %c3_i19 = hw.constant 3 : i19
  // CHECK-NEXT: llvm.mlir.constant(true
  // CHECK-NEXT: [[THREE:%.+]] = llvm.mlir.constant(3

  %1 = arc.memory_read %0[%c3_i19], %clk, %enable : <4 x i42, 6>, i19
  %2 = comb.add %1, %1 : i42
  // CHECK-NEXT:   [[ADDR:%.+]] = llvm.zext [[THREE]] : i19 to i20
  // CHECK-NEXT:   [[FOUR:%.+]] = llvm.mlir.constant(4
  // CHECK-NEXT:   [[INBOUNDS:%.+]] = llvm.icmp "ult" [[ADDR]], [[FOUR]]
  // CHECK-NEXT:   [[GEP:%.+]] = llvm.getelementptr [[PTR]][[[ADDR]]] : (!llvm.ptr<i48>, i20) -> !llvm.ptr<i42>
  // CHECK-NEXT:   [[COND:%.+]] = llvm.and %arg1, [[INBOUNDS]]
  // CHECK-NEXT:   llvm.cond_br [[COND]], [[BB_LOAD:\^.+]], [[BB_SKIP:\^.+]]
  // CHECK-NEXT: [[BB_LOAD]]:
  // CHECK-NEXT:   [[TMP:%.+]] = llvm.load [[GEP]]
  // CHECK-NEXT:   llvm.br [[BB_RESUME:\^.+]]([[TMP]] : i42)
  // CHECK-NEXT: [[BB_SKIP]]:
  // CHECK-NEXT:   [[TMP:%.+]] = llvm.mlir.constant
  // CHECK-NEXT:   llvm.br [[BB_RESUME:\^.+]]([[TMP]] : i42)
  // CHECK-NEXT: [[BB_RESUME]]([[LOADED:%.+]]: i42):
  // CHECK:        [[ADDED:%.+]] = llvm.add [[LOADED]], [[LOADED]]

  arc.memory_write %0[%c3_i19], %clk, %enable, %2 : <4 x i42, 6>, i19
  // CHECK-NEXT:   [[ADDR:%.+]] = llvm.zext [[THREE]] : i19 to i20
  // CHECK-NEXT:   [[FOUR:%.+]] = llvm.mlir.constant(4
  // CHECK-NEXT:   [[INBOUNDS:%.+]] = llvm.icmp "ult" [[ADDR]], [[FOUR]]
  // CHECK-NEXT:   [[GEP:%.+]] = llvm.getelementptr [[PTR]][[[ADDR]]] : (!llvm.ptr<i48>, i20) -> !llvm.ptr<i42>
  // CHECK-NEXT:   [[COND:%.+]] = llvm.and %arg1, [[INBOUNDS]]
  // CHECK-NEXT:   llvm.cond_br [[COND]], [[BB_STORE:\^.+]], [[BB_RESUME:\^.+]]
  // CHECK-NEXT: [[BB_STORE]]:
  // CHECK-NEXT:   llvm.store [[ADDED]], [[GEP]]
  // CHECK-NEXT:   llvm.br [[BB_RESUME]]
  // CHECK-NEXT: [[BB_RESUME]]:
  return
  // CHECK-NEXT:   llvm.return
}
// CHECK-NEXT: }

// CHECK-LABEL: llvm.func @zeroCount
func.func @zeroCount(%arg0 : i32) {
  // CHECK-NEXT: [[TRUE1:%.+]] = llvm.mlir.constant(true) : i1
  // CHECK-NEXT: "llvm.intr.ctlz"(%arg0, [[TRUE1]]) : (i32, i1) -> i32
  %0 = arc.zero_count leading %arg0  : i32
  // CHECK-NEXT: [[TRUE2:%.+]] = llvm.mlir.constant(true) : i1
  // CHECK-NEXT: "llvm.intr.cttz"(%arg0, [[TRUE2]]) : (i32, i1) -> i32
  %1 = arc.zero_count trailing %arg0  : i32
  return
}

// CHECK-LABEL: llvm.func @callOp
func.func @callOp(%arg0: i32) -> i32 {
  // CHECK-NEXT: [[V0:%.+]] = llvm.call @dummyCallee(%arg0) : (i32) -> i32
  %0 = arc.call @dummyCallee(%arg0) : (i32) -> i32
  // CHECK-NEXT: return [[V0]] : i32
  return %0 : i32
}
arc.define @dummyCallee(%arg0: i32) -> i32 {
  arc.output %arg0 : i32
}
