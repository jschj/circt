// NOTE: Assertions have been autogenerated by utils/generate-test-checks.py
// RUN: circt-opt %s --convert-llhd-to-llvm | FileCheck %s

// CHECK-LABEL: @dummy_i1
func.func @dummy_i1 (%0 : i1) {
  return
}

// CHECK-LABEL: @dummy_i32
func.func @dummy_i32 (%0 : i32)  {
  return
}

// CHECK-LABEL: @dummy_time
func.func @dummy_time (%0 : !llhd.time) {
  return
}

// CHECK-LABEL: @dummy_ptr
func.func @dummy_ptr(%0 : !llhd.ptr<i32>) {
  return
}

// CHECK-LABEL: @dummy_subsig
func.func @dummy_subsig(%0 : !llhd.sig<i10>) {
  return
}

// CHECK-LABEL:   llvm.func @convert_persistent_i1(
// CHECK-SAME:                                     %[[VAL_0:.*]]: !llvm.ptr,
// CHECK-SAME:                                     %[[VAL_1:.*]]: !llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i1)>)>>,
// CHECK-SAME:                                     %[[VAL_2:.*]]: !llvm.ptr<struct<(ptr, i64, i64, i64)>>) {
// CHECK:           %[[VAL_3:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_4:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_5:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_3]], 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i1)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_6:.*]] = llvm.load %[[VAL_5]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb1
// CHECK:         ^bb1:
// CHECK:           %[[VAL_7:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_8:.*]] = llvm.icmp "eq" %[[VAL_6]], %[[VAL_7]] : i32
// CHECK:           llvm.cond_br %[[VAL_8]], ^bb2, ^bb4
// CHECK:         ^bb2:
// CHECK:           %[[VAL_9:.*]] = llvm.mlir.constant(false) : i1
// CHECK:           %[[VAL_10:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_11:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_12:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_13:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_10]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i1)>)>>, i32) -> !llvm.ptr<i1>
// CHECK:           llvm.store %[[VAL_9]], %[[VAL_13]] : !llvm.ptr<i1>
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_14:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_15:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_16:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_17:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_14]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i1)>)>>, i32) -> !llvm.ptr<i1>
// CHECK:           %[[VAL_18:.*]] = llvm.load %[[VAL_17]] : !llvm.ptr<i1>
// CHECK:           llvm.call @dummy_i1(%[[VAL_18]]) : (i1) -> ()
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb4:
// CHECK:           llvm.return
// CHECK:         }
llhd.proc @convert_persistent_i1 () -> () {
  %0 = hw.constant 0 : i1
  cf.br ^resume
^resume:
  func.call @dummy_i1(%0) : (i1) -> ()
  cf.br ^resume
}

// CHECK-LABEL:   llvm.func @convert_persistent_i32(
// CHECK-SAME:                                      %[[VAL_0:.*]]: !llvm.ptr,
// CHECK-SAME:                                      %[[VAL_1:.*]]: !llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>,
// CHECK-SAME:                                      %[[VAL_2:.*]]: !llvm.ptr<struct<(ptr, i64, i64, i64)>>) {
// CHECK:           %[[VAL_3:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_4:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_5:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_3]], 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_6:.*]] = llvm.load %[[VAL_5]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb1
// CHECK:         ^bb1:
// CHECK:           %[[VAL_7:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_8:.*]] = llvm.icmp "eq" %[[VAL_6]], %[[VAL_7]] : i32
// CHECK:           llvm.cond_br %[[VAL_8]], ^bb2, ^bb4
// CHECK:         ^bb2:
// CHECK:           %[[VAL_9:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_10:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_11:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_12:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_13:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_10]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_9]], %[[VAL_13]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_14:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_15:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_16:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_17:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_14]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_18:.*]] = llvm.load %[[VAL_17]] : !llvm.ptr<i32>
// CHECK:           llvm.call @dummy_i32(%[[VAL_18]]) : (i32) -> ()
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb4:
// CHECK:           llvm.return
// CHECK:         }

llhd.proc @convert_persistent_i32 () -> () {
  %0 = hw.constant 0 : i32
  cf.br ^resume
^resume:
  func.call @dummy_i32(%0) : (i32) -> ()
  cf.br ^resume
}

// CHECK-LABEL:   llvm.func @convert_persistent_time(
// CHECK-SAME:                                       %[[VAL_0:.*]]: !llvm.ptr,
// CHECK-SAME:                                       %[[VAL_1:.*]]: !llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(array<3 x i64>)>)>>,
// CHECK-SAME:                                       %[[VAL_2:.*]]: !llvm.ptr<struct<(ptr, i64, i64, i64)>>) {
// CHECK:           %[[VAL_3:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_4:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_5:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_3]], 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(array<3 x i64>)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_6:.*]] = llvm.load %[[VAL_5]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb1
// CHECK:         ^bb1:
// CHECK:           %[[VAL_7:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_8:.*]] = llvm.icmp "eq" %[[VAL_6]], %[[VAL_7]] : i32
// CHECK:           llvm.cond_br %[[VAL_8]], ^bb2, ^bb4
// CHECK:         ^bb2:
// CHECK:           %[[VAL_9:.*]] = llvm.mlir.constant(dense<[0, 0, 1]> : tensor<3xi64>) : !llvm.array<3 x i64>
// CHECK:           %[[VAL_10:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_11:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_12:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_13:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_10]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(array<3 x i64>)>)>>, i32) -> !llvm.ptr<array<3 x i64>>
// CHECK:           llvm.store %[[VAL_9]], %[[VAL_13]] : !llvm.ptr<array<3 x i64>>
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_14:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_15:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_16:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_17:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_14]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(array<3 x i64>)>)>>, i32) -> !llvm.ptr<array<3 x i64>>
// CHECK:           %[[VAL_18:.*]] = llvm.load %[[VAL_17]] : !llvm.ptr<array<3 x i64>>
// CHECK:           llvm.call @dummy_time(%[[VAL_18]]) : (!llvm.array<3 x i64>) -> ()
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb4:
// CHECK:           llvm.return
// CHECK:         }
llhd.proc @convert_persistent_time () -> () {
  %0 = llhd.constant_time #llhd.time<0ns, 0d, 1e>
  cf.br ^resume
^resume:
  func.call @dummy_time(%0) : (!llhd.time) -> ()
  cf.br ^resume
}

// CHECK-LABEL:   llvm.func @convert_persistent_ptr(
// CHECK-SAME:                                      %[[VAL_0:.*]]: !llvm.ptr,
// CHECK-SAME:                                      %[[VAL_1:.*]]: !llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>,
// CHECK-SAME:                                      %[[VAL_2:.*]]: !llvm.ptr<struct<(ptr, i64, i64, i64)>>) {
// CHECK:           %[[VAL_3:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_4:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_5:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_3]], 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_6:.*]] = llvm.load %[[VAL_5]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb1
// CHECK:         ^bb1:
// CHECK:           %[[VAL_7:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_8:.*]] = llvm.icmp "eq" %[[VAL_6]], %[[VAL_7]] : i32
// CHECK:           llvm.cond_br %[[VAL_8]], ^bb2, ^bb4
// CHECK:         ^bb2:
// CHECK:           %[[VAL_9:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_10:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_11:.*]] = llvm.alloca %[[VAL_10]] x i32 {alignment = 4 : i64} : (i32) -> !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_9]], %[[VAL_11]] : !llvm.ptr<i32>
// CHECK:           %[[VAL_12:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_13:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_14:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_15:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_12]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_16:.*]] = llvm.load %[[VAL_11]] : !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_16]], %[[VAL_15]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_17:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_18:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_19:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_20:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_17]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           llvm.call @dummy_ptr(%[[VAL_20]]) : (!llvm.ptr<i32>) -> ()
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb4:
// CHECK:           llvm.return
// CHECK:         }
llhd.proc @convert_persistent_ptr () -> () {
  %0 = hw.constant 0 : i32
  %1 = llhd.var %0 : i32
  cf.br ^resume
^resume:
  func.call @dummy_ptr(%1) : (!llhd.ptr<i32>) -> ()
  cf.br ^resume
}

// CHECK-LABEL:   llvm.func @convert_persistent_subsig(
// CHECK-SAME:                                         %[[VAL_0:.*]]: !llvm.ptr,
// CHECK-SAME:                                         %[[VAL_1:.*]]: !llvm.ptr<struct<(i32, i32, ptr<array<1 x i1>>, struct<(struct<(ptr, i64, i64, i64)>)>)>>,
// CHECK-SAME:                                         %[[VAL_2:.*]]: !llvm.ptr<struct<(ptr, i64, i64, i64)>>) {
// CHECK:           %[[VAL_3:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_4:.*]] = llvm.getelementptr %[[VAL_2]]{{\[}}%[[VAL_3]]] : (!llvm.ptr<struct<(ptr, i64, i64, i64)>>, i32) -> !llvm.ptr<struct<(ptr, i64, i64, i64)>>
// CHECK:           %[[VAL_5:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_6:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_7:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_5]], 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<1 x i1>>, struct<(struct<(ptr, i64, i64, i64)>)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_8:.*]] = llvm.load %[[VAL_7]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb1
// CHECK:         ^bb1:
// CHECK:           %[[VAL_9:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_10:.*]] = llvm.icmp "eq" %[[VAL_8]], %[[VAL_9]] : i32
// CHECK:           llvm.cond_br %[[VAL_10]], ^bb2, ^bb4
// CHECK:         ^bb2:
// CHECK:           %[[VAL_11:.*]] = llvm.mlir.constant(0 : i5) : i5
// CHECK:           %[[VAL_12:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_13:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_14:.*]] = llvm.getelementptr %[[VAL_4]]{{\[}}%[[VAL_12]], 0] : (!llvm.ptr<struct<(ptr, i64, i64, i64)>>, i32) -> !llvm.ptr<ptr>
// CHECK:           %[[VAL_15:.*]] = llvm.load %[[VAL_14]] : !llvm.ptr<ptr>
// CHECK:           %[[VAL_16:.*]] = llvm.getelementptr %[[VAL_4]]{{\[}}%[[VAL_12]], 1] : (!llvm.ptr<struct<(ptr, i64, i64, i64)>>, i32) -> !llvm.ptr<i64>
// CHECK:           %[[VAL_17:.*]] = llvm.load %[[VAL_16]] : !llvm.ptr<i64>
// CHECK:           %[[VAL_18:.*]] = llvm.mlir.constant(2 : i32) : i32
// CHECK:           %[[VAL_19:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_20:.*]] = llvm.getelementptr %[[VAL_4]]{{\[}}%[[VAL_12]], 2] : (!llvm.ptr<struct<(ptr, i64, i64, i64)>>, i32) -> !llvm.ptr<i64>
// CHECK:           %[[VAL_21:.*]] = llvm.load %[[VAL_20]] : !llvm.ptr<i64>
// CHECK:           %[[VAL_22:.*]] = llvm.getelementptr %[[VAL_4]]{{\[}}%[[VAL_12]], 3] : (!llvm.ptr<struct<(ptr, i64, i64, i64)>>, i32) -> !llvm.ptr<i64>
// CHECK:           %[[VAL_23:.*]] = llvm.load %[[VAL_22]] : !llvm.ptr<i64>
// CHECK:           %[[VAL_24:.*]] = llvm.zext %[[VAL_11]] : i5 to i64
// CHECK:           %[[VAL_25:.*]] = llvm.add %[[VAL_17]], %[[VAL_24]]  : i64
// CHECK:           %[[VAL_26:.*]] = llvm.ptrtoint %[[VAL_15]] : !llvm.ptr to i64
// CHECK:           %[[VAL_27:.*]] = llvm.mlir.constant(8 : i64) : i64
// CHECK:           %[[VAL_28:.*]] = llvm.udiv %[[VAL_25]], %[[VAL_27]]  : i64
// CHECK:           %[[VAL_29:.*]] = llvm.add %[[VAL_26]], %[[VAL_28]]  : i64
// CHECK:           %[[VAL_30:.*]] = llvm.inttoptr %[[VAL_29]] : i64 to !llvm.ptr
// CHECK:           %[[VAL_31:.*]] = llvm.urem %[[VAL_25]], %[[VAL_27]]  : i64
// CHECK:           %[[VAL_32:.*]] = llvm.mlir.undef : !llvm.struct<(ptr, i64, i64, i64)>
// CHECK:           %[[VAL_33:.*]] = llvm.insertvalue %[[VAL_30]], %[[VAL_32]][0] : !llvm.struct<(ptr, i64, i64, i64)>
// CHECK:           %[[VAL_34:.*]] = llvm.insertvalue %[[VAL_31]], %[[VAL_33]][1] : !llvm.struct<(ptr, i64, i64, i64)>
// CHECK:           %[[VAL_35:.*]] = llvm.insertvalue %[[VAL_21]], %[[VAL_34]][2] : !llvm.struct<(ptr, i64, i64, i64)>
// CHECK:           %[[VAL_36:.*]] = llvm.insertvalue %[[VAL_23]], %[[VAL_35]][3] : !llvm.struct<(ptr, i64, i64, i64)>
// CHECK:           %[[VAL_37:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_38:.*]] = llvm.alloca %[[VAL_37]] x !llvm.struct<(ptr, i64, i64, i64)> {alignment = 4 : i64} : (i32) -> !llvm.ptr<struct<(ptr, i64, i64, i64)>>
// CHECK:           llvm.store %[[VAL_36]], %[[VAL_38]] : !llvm.ptr<struct<(ptr, i64, i64, i64)>>
// CHECK:           %[[VAL_39:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_40:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_41:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_42:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_39]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<1 x i1>>, struct<(struct<(ptr, i64, i64, i64)>)>)>>, i32) -> !llvm.ptr<struct<(ptr, i64, i64, i64)>>
// CHECK:           %[[VAL_43:.*]] = llvm.load %[[VAL_38]] : !llvm.ptr<struct<(ptr, i64, i64, i64)>>
// CHECK:           llvm.store %[[VAL_43]], %[[VAL_42]] : !llvm.ptr<struct<(ptr, i64, i64, i64)>>
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_44:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_45:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_46:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_47:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_44]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<1 x i1>>, struct<(struct<(ptr, i64, i64, i64)>)>)>>, i32) -> !llvm.ptr<struct<(ptr, i64, i64, i64)>>
// CHECK:           llvm.call @dummy_subsig(%[[VAL_47]]) : (!llvm.ptr<struct<(ptr, i64, i64, i64)>>) -> ()
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb4:
// CHECK:           llvm.return
// CHECK:         }
llhd.proc @convert_persistent_subsig () -> (%out : !llhd.sig<i32>) {
  %zero = hw.constant 0 : i5
  %0 = llhd.sig.extract %out from %zero : (!llhd.sig<i32>) -> !llhd.sig<i10>
  cf.br ^resume
^resume:
  func.call @dummy_subsig(%0) : (!llhd.sig<i10>) -> ()
  cf.br ^resume
}

// CHECK-LABEL:   llvm.func @convert_persistent_block_argument(
// CHECK-SAME:                                                 %[[VAL_0:.*]]: !llvm.ptr,
// CHECK-SAME:                                                 %[[VAL_1:.*]]: !llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>,
// CHECK-SAME:                                                 %[[VAL_2:.*]]: !llvm.ptr<struct<(ptr, i64, i64, i64)>>) {
// CHECK:           %[[VAL_3:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_4:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_5:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_3]], 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_6:.*]] = llvm.load %[[VAL_5]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb1
// CHECK:         ^bb1:
// CHECK:           %[[VAL_7:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_8:.*]] = llvm.icmp "eq" %[[VAL_6]], %[[VAL_7]] : i32
// CHECK:           llvm.cond_br %[[VAL_8]], ^bb2, ^bb5
// CHECK:         ^bb2:
// CHECK:           %[[VAL_9:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           llvm.br ^bb3(%[[VAL_9]] : i32)
// CHECK:         ^bb3(%[[VAL_10:.*]]: i32):
// CHECK:           %[[VAL_11:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_12:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_13:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_14:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_11]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_10]], %[[VAL_14]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb4
// CHECK:         ^bb4:
// CHECK:           %[[VAL_15:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_16:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_17:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_18:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_15]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_19:.*]] = llvm.load %[[VAL_18]] : !llvm.ptr<i32>
// CHECK:           llvm.call @dummy_i32(%[[VAL_19]]) : (i32) -> ()
// CHECK:           %[[VAL_20:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_21:.*]] = llvm.mlir.constant(2 : i32) : i32
// CHECK:           %[[VAL_22:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_20]], 2] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32)>)>>, i32) -> !llvm.ptr<ptr<array<0 x i1>>>
// CHECK:           %[[VAL_23:.*]] = llvm.load %[[VAL_22]] : !llvm.ptr<ptr<array<0 x i1>>>
// CHECK:           llvm.return
// CHECK:         ^bb5:
// CHECK:           llvm.return
// CHECK:         }
llhd.proc @convert_persistent_block_argument () -> () {
    %1 = hw.constant 0 : i32
    cf.br ^argBB(%1 : i32)
^argBB(%i : i32):
    cf.br ^end
^end:
    func.call @dummy_i32(%i) : (i32) -> ()
    llhd.halt
}

// CHECK-LABEL:   llvm.func @convert_ptr_redirect(
// CHECK-SAME:                                    %[[VAL_0:.*]]: !llvm.ptr,
// CHECK-SAME:                                    %[[VAL_1:.*]]: !llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32, i32)>)>>,
// CHECK-SAME:                                    %[[VAL_2:.*]]: !llvm.ptr<struct<(ptr, i64, i64, i64)>>) {
// CHECK:           %[[VAL_3:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_4:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_5:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_3]], 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32, i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_6:.*]] = llvm.load %[[VAL_5]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb1
// CHECK:         ^bb1:
// CHECK:           %[[VAL_7:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_8:.*]] = llvm.icmp "eq" %[[VAL_6]], %[[VAL_7]] : i32
// CHECK:           llvm.cond_br %[[VAL_8]], ^bb2, ^bb4
// CHECK:         ^bb2:
// CHECK:           %[[VAL_9:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_10:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_11:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_12:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_13:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_10]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32, i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_9]], %[[VAL_13]] : !llvm.ptr<i32>
// CHECK:           %[[VAL_14:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_15:.*]] = llvm.alloca %[[VAL_14]] x i32 {alignment = 4 : i64} : (i32) -> !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_9]], %[[VAL_15]] : !llvm.ptr<i32>
// CHECK:           %[[VAL_16:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_17:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_18:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_19:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_16]], 3, 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32, i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_20:.*]] = llvm.load %[[VAL_15]] : !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_20]], %[[VAL_19]] : !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_9]], %[[VAL_19]] : !llvm.ptr<i32>
// CHECK:           llvm.br ^bb3
// CHECK:         ^bb3:
// CHECK:           %[[VAL_21:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_22:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_23:.*]] = llvm.mlir.constant(1 : i32) : i32
// CHECK:           %[[VAL_24:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_21]], 3, 1] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32, i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_25:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_26:.*]] = llvm.mlir.constant(3 : i32) : i32
// CHECK:           %[[VAL_27:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_28:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_25]], 3, 0] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32, i32)>)>>, i32) -> !llvm.ptr<i32>
// CHECK:           %[[VAL_29:.*]] = llvm.load %[[VAL_28]] : !llvm.ptr<i32>
// CHECK:           llvm.store %[[VAL_29]], %[[VAL_24]] : !llvm.ptr<i32>
// CHECK:           %[[VAL_30:.*]] = llvm.mlir.constant(0 : i32) : i32
// CHECK:           %[[VAL_31:.*]] = llvm.mlir.constant(2 : i32) : i32
// CHECK:           %[[VAL_32:.*]] = llvm.getelementptr %[[VAL_1]]{{\[}}%[[VAL_30]], 2] : (!llvm.ptr<struct<(i32, i32, ptr<array<0 x i1>>, struct<(i32, i32)>)>>, i32) -> !llvm.ptr<ptr<array<0 x i1>>>
// CHECK:           %[[VAL_33:.*]] = llvm.load %[[VAL_32]] : !llvm.ptr<ptr<array<0 x i1>>>
// CHECK:           llvm.return
// CHECK:         ^bb4:
// CHECK:           llvm.return
// CHECK:         }
llhd.proc @convert_ptr_redirect () -> () {
  %1 = hw.constant 0 : i32
  %var = llhd.var %1 : i32
  llhd.store %var, %1 : !llhd.ptr<i32>
  cf.br ^bb0
^bb0:
  llhd.store %var, %1 : !llhd.ptr<i32>
  llhd.halt
}
