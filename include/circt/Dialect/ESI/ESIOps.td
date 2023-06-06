//===- ESIOps.td - ESI dialect operation definitions --------- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This is where any operations for the ESI dialect live.
//
//===----------------------------------------------------------------------===//

def ChannelBufferOp : ESI_Abstract_Op<"buffer", [
    Pure,
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "Control options for an ESI channel.";
  let description = [{
    A channel buffer (`buffer`) is essentially a set of options on a channel.
    It always adds at least one cycle of latency (pipeline stage) to the
    channel, but this is configurable.

    This operation is inserted on an ESI dataflow edge. It must exist
    previous to SystemVerilog emission but can be added in a lowering pass.

    A `stages` attribute may be provided to specify a specific number of cycles
    (pipeline stages) to use on this channel. Must be greater than 0.

    A `name` attribute may be provided to assigned a name to a buffered
    connection.

    Example:

    ```mlir
    %esiChan = hw.instance "sender" @Sender () : () -> (!esi.channel<i1>)
    // Allow automatic selection of options.
    %bufferedChan = esi.buffer %esiChan : i1
    hw.instance "recv" @Reciever (%bufferedChan) : (!esi.channel<i1>) -> ()

    // Alternatively, specify the number of stages.
    %fourStageBufferedChan = esi.buffer %esiChan { stages = 4 } : i1
    ```
  }];

  let arguments = (ins I1:$clk, I1:$rst, ChannelType:$input,
    OptionalAttr<ConfinedAttr<I64Attr, [IntMinValue<1>]>>:$stages,
    OptionalAttr<StrAttr>:$name);
  let results = (outs ChannelType:$output);
  let hasCustomAssemblyFormat = 1;
}

def PipelineStageOp : ESI_Physical_Op<"stage", [
    Pure,
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "An elastic buffer stage.";
  let description = [{
    An individual elastic pipeline register. Generally lowered to from a
    ChannelBuffer ('buffer'), though can be inserted anywhere to add an
    additional pipeline stage. Adding individually could be useful for
    late-pass latency balancing.
  }];

  let arguments = (ins I1:$clk, I1:$rst, ChannelType:$input);
  let results = (outs ChannelType:$output);
  let hasCustomAssemblyFormat = 1;
}

def CosimEndpointOp : ESI_Physical_Op<"cosim", []> {
  let summary = "Co-simulation endpoint";
  let description = [{
    A co-simulation endpoint is a connection from the simulation to some
    outside process, usually a software application responsible for driving
    the simulation (driver).

    ESI uses a serialization protocol called Cap'n Proto (capnp for short).
    The advantage of capnp is the decoding overhead: for value types (ints,
    structs, etc.) there is none! This stands in contrast to Protocol Buffers
    and Bond as their messages contain metadata for each field which must be
    interpreted.

    The advantage of using a well-supported serialization protocol is
    language support -- driver applications can be written in any language
    supported by the specific protocol.
  }];

  let arguments = (ins I1:$clk, I1:$rst, ChannelType:$send, StrAttr:$name);
  let results = (outs ChannelType:$recv);

  let assemblyFormat = [{
    $clk `,` $rst `,` $send `,` $name attr-dict
      `:` qualified(type($send)) `->` qualified(type($recv))
  }];
}

def RtlBitArrayType : Type<CPred<"$_self.isa<::circt::hw::ArrayType>()"
 " && $_self.cast<::circt::hw::ArrayType>().getElementType() =="
 "   ::mlir::IntegerType::get($_self.getContext(), 1)">, "an HW bit array">;

def CapnpDecodeOp : ESI_Physical_Op<"decode.capnp", [Pure]> {
  let summary = "Translate bits in Cap'nProto messages to HW typed data";

  let arguments = (ins I1:$clk, I1:$valid, RtlBitArrayType:$capnpBits);
  let results = (outs AnyType:$decodedData);

  let assemblyFormat = [{
    $clk $valid $capnpBits attr-dict `:` qualified(type($capnpBits)) `->`
                                         qualified(type($decodedData))
  }];
}

def CapnpEncodeOp : ESI_Physical_Op<"encode.capnp", [Pure]> {
  let summary = "Translate HW typed data to Cap'nProto";

  let arguments = (ins I1:$clk, I1:$valid, AnyType:$dataToEncode);
  let results = (outs RtlBitArrayType:$capnpBits);

  let assemblyFormat = [{
    $clk $valid $dataToEncode attr-dict `:` qualified(type($dataToEncode))
                                          `->` qualified(type($capnpBits))
  }];
}

def NullSourceOp : ESI_Physical_Op<"null", [Pure]> {
  let summary = "An op which never produces messages.";

  let arguments = (ins);
  let results = (outs ChannelType:$out);

  let assemblyFormat = [{ attr-dict `:` qualified(type($out)) }];
}

def AdaptAXIStreamToValidReadyOp : ESI_Op<"adapt.axistream2vr", [Pure]> {
  let summary = "Adapt a value from an AXI Stream interface to a valid-ready interface";
  let description = [{
    Lowering this operation to HW will implement logic to convert the AXI data bytes to
    the specified result type. TSTRB, TKEEP, TID, TDEST, TUSER and TWAKEUP are
    currently not supported. A single transfer contains a single struct instance.
    This implementation might deviate from some of the recommendations in the spec.

    Example:

    ```mlir
    %vrChanOutput = esi.adapt.axistream2vr %axisChanInput : !esi.axistream<!hw.struct<a: i8, b: i5>, i64>
    ```
  }];

  let arguments = (ins I1:$clk, I1:$rst, ChannelType:$axisChanInput);
  let results = (outs ChannelType:$vrChanOutput);



  let assemblyFormat = [{
    $clk `,` $rst `,` $axisChanInput attr-dict `:`
      custom<AdaptAXIStreamToValidReadyType>(type($axisChanInput), type($vrChanOutput))
  }];

  let extraClassDeclaration = [{
    Type getRawValidReadyType() {
      Type inner = getVrChanOutput().getType().cast<ChannelType>().getInner();
      size_t width = circt::hw::getBitWidth(inner);
      return IntegerType::get(getContext(), width, IntegerType::Signless);
    }
  }];
}

def AdaptValidReadyToAXIStreamOp : ESI_Op<"adapt.vr2axistream", [Pure]> {
  let summary = "";
  let description = "";

  let arguments = (ins I1:$clk, I1:$rst, ChannelType:$vrChanInput);
  let results = (outs ChannelType:$axisChanOutput);

  let assemblyFormat = [{
    $clk `,` $rst `,` $vrChanInput attr-dict `:`
      custom<AdaptValidReadyToAXIStreamType>(type($vrChanInput), type($axisChanOutput))
  }];

  let extraClassDeclaration = [{
    Type getRawValidReadyType() {
      Type inner = getVrChanInput().getType().cast<ChannelType>().getInner();
      size_t width = circt::hw::getBitWidth(inner);
      return IntegerType::get(getContext(), width, IntegerType::Signless);
    }
  }];
}