module {
  //hw.module @Stage(%clk: i1, %rst: i1, %inChan: !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>) -> (outChan: !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>) {
  //  %0 = esi.stage %clk, %rst, %inChan : !hw.struct<a: ui3, b: ui4, c: ui32>
  //  hw.output %0 : !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>
  //}

  hw.module @Stage1(%clk: i1, %rst: i1) -> () {
    %chan = esi.null : !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>
    %0 = esi.stage %clk, %rst, %chan : !hw.struct<a: ui3, b: ui4, c: ui32>
    hw.output
  }

  hw.module @Stage2(%clk: i1, %rst: i1) -> (outChan: !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>) {
    // Lower types?
    %chan = esi.null : !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>
    // esi.wrap.vr and esi.adapt.vr2axistream must be folded together
    // the following is of course a null op and must be folded away
    %axisChan = esi.adapt.vr2axistream %clk, %rst, %chan : !esi.axistream<!hw.struct<a: ui3, b: ui4, c: ui32>, i128>
    %vrChanOutput = esi.adapt.axistream2vr %clk, %rst, %axisChan : !esi.axistream<!hw.struct<a: ui3, b: ui4, c: ui32>, i128>
    hw.output %vrChanOutput : !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>
  }
//
//  // We want to be able to give a module some AXIStream ports and it should be able to lower it correctly exposing
//  // the raw signals that can then be found by Vivado for example.
//
  hw.module @Stage3(%clk: i1, %rst: i1, %axisChan: !esi.channel<!esi.axistream<!hw.struct<x: i3, y: i3>, i64>, AXIStream>) -> () {
    %vrChan = esi.adapt.axistream2vr %clk, %rst, %axisChan : !esi.axistream<!hw.struct<x: i3, y: i3>, i64>
    hw.output
  }

  hw.module @Stage4(%clk: i1, %rst: i1) -> (axisChan: !esi.channel<!esi.axistream<!hw.struct<x: i3, y: i3>, i64>, AXIStream>) {
    %chan = esi.null : !esi.channel<!hw.struct<x: i3, y: i3>>
    %ac = esi.adapt.vr2axistream %clk, %rst, %chan : !esi.axistream<!hw.struct<x: i3, y: i3>, i64>
    hw.output %ac : !esi.channel<!esi.axistream<!hw.struct<x: i3, y: i3>, i64>, AXIStream>
  }
//
//  hw.module @Stage4(%clk: i1, %rst: i1, %chan: !esi.channel<i8>) -> () {
//    hw.output
//  }
}