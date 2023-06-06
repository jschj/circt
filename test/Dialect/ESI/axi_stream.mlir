//hw.module @AXIStreamUnwrap(%chan: !esi.channel<!hw.struct<a: i8, b: i3>, AXIStream>) -> () {
//  // %data has type !hw.struct<a: i8, b: i3>
//  // If the channel type is a simple struct type, we make the bit width of the AXI4Stream interface
//  // the lowest possible multiple of 8 bits wide that can hold the struct type. (in this case 16)
//  %data, %last, %valid = esi.unwrap.axistream %chan, %ready : !esi.channel<!hw.struct<a: i8, b: i3>, AXIStream>
//}

module {
  hw.module @Top1(%chan: !esi.channel<i8>) -> () {
    hw.output
  }

  hw.module @Top2(%chan: !esi.channel<!hw.struct<a: i8, b: i3>>) -> () { //(chan2: !esi.channel<!hw.struct<a: i8, b: i3>>) {
    //hw.output %chan : !esi.channel<!hw.struct<a: i8, b: i3>>
    hw.output
  }

  // lower-esi-ports
  // It's task is to split the channel into its basic components which are primitive hw types or structs.
  // 
  //hw.module @Top3(%chan: !esi.channel<!hw.struct<a: i8, b: i3>, AXIStream>) -> () {
  //  hw.output
  //}

  hw.module @Mul2(%clk: i1, %rst: i1, %inChan: !esi.channel<ui8>) -> (outChan: !esi.channel<ui16>) {
    %x, %valid = esi.unwrap.vr %inChan, %ready : ui8
    %c2 = hwarith.constant 2 : ui8
    %y = hwarith.mul %x, %c2 : (ui8, ui8) -> ui16
    %0, %ready = esi.wrap.vr %y, %valid : ui16
    hw.output %0 : !esi.channel<ui16>
  }

  hw.module @Test(%inChan: !esi.channel<!esi.list<ui8>>) -> () {
    hw.output
  }

  // maybe !esi.channel<!hw.struct<a: i8, b: i5>, AXIStream<128>> is better?

  //hw.module @Test2(%valid: i1, %data: i128, %strb: i16, %keep: i16, %last: i1, %id: i8, %dest: i8, %user: i8, %wakeup: i1) -> () {
    //%axisChan, %axisReady = esi.wrap.axistream %valid, %data, %strb, %keep, %last, %id, %dest, %user, %wakeup : i128, !esi.channel<!hw.struct<a: i8, b: i5>, AXIStream>
    //%rvChan, %rvReady = esi.adapt.axistream2vr %axisChan, %axisChan : i128, !esi.channel<!hw.struct<a: i8, b: i5>, AXIStream>
    //hw.output
  //}

  //hw.module @Test3(%clk: i1, %rst: i1, %axisChan: !esi.channel<!hw.struct<a: i8, b: i5>, AXIStream>) -> (ready: i1) {
  //  %rvChan = esi.adapt.axistream2vr %clk, %rst, %axisChan : i128, !hw.struct<a: i8, b: i5>
  //}

  //hw.module @Test3Lowered(%clk: i1, %rst: i1, %axisChan: !esi.channel<!hw.struct<a: i8, b: i5>, AXIStream>) -> (ready: i1) {
  //  hw.instance @ESI_AXIStreamReceiver(%clk, %rst, )
  //  %rvChan = esi.adapt.axistream2vr %clk, %rst, %axisChan : i128, !hw.struct<a: i8, b: i5>
  //}

  hw.module @Something() -> (result: i8) {
    %0 = hw.constant 11 : i8
    hw.output %0 : i8
  }

  //hw.module @Intersperse(%clk: i1, %rst: i1, %inChan: !esi.channel<ui8>) -> (outChan: !esi.channel<ui8>) {
  //  %x, %valid = esi.unwrap.vr %inChan, %ready : ui8
//
  //  %c0 = hw.constant 0 : i1
  //  %c1 = hw.constant 1 : i1
  //  %state = seq.firreg %next clock %clk reset sync %rst, %c0 : i1
  //  %next =  comb.mux %state, %c0, %c1 : i1
//
  //  %zero = hwarith.constant 0 : ui8
  //  %y = comb.mux %state, %zero, %x : ui8
//
  //  %0, %ready = esi.wrap.vr %y, %valid : ui8
  //  hw.output %0 : !esi.channel<ui8>
  //}

  hw.module @Stage(%clk: i1, %rst: i1, %inChan: !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>) -> (outChan: !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>) {
    %0 = esi.stage %clk, %rst, %inChan : !hw.struct<a: ui3, b: ui4, c: ui32>
    hw.output %0 : !esi.channel<!hw.struct<a: ui3, b: ui4, c: ui32>>
  }
}