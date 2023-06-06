//===- ESIPorts.td - ESI port specifications ---------------*- tablegen -*-===//
//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// ESI ports are the primary mechanism on which the ESI dialect operates. These
// types wrap other types to specify the port as an ESI port. They represent
// ESI communication flows of various kinds. At first, ESI will only support
// 'channels' -- unidirectional, point-to-point, latency-insensitive streams.
//
//===----------------------------------------------------------------------===//

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/EnumAttr.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "circt/Dialect/HW/HWTypes.td"


class ESI_Port<string name> : TypeDef<ESI_Dialect, name> {}

// Standard valid-ready signaling.
def ChannelSignalingValidReady : I32EnumAttrCase<"ValidReady", 0>;
// FIFO interface with a read latency of zero. Very similiar to valid-ready, but
// cannot assert ready if data is not available.
def ChannelSignalingFIFO0      : I32EnumAttrCase<"FIFO0",      1>;
// AXI Stream interface. In general very similiar to valid-ready.
def ChannelSignalingAXIStream  : I32EnumAttrCase<"AXIStream",  2>;

def ChannelSignaling : I32EnumAttr<
    "ChannelSignaling",
    "ESI channel wire signaling standard",
    [ChannelSignalingValidReady, ChannelSignalingFIFO0, ChannelSignalingAXIStream]>{
  let cppNamespace = "::circt::esi";
}

def AXIStreamType : TypeDef<ESI_Dialect, "AXIStream"> {
  let summary = "";
  let description = "";

  let mnemonic = "axistream";
  let parameters = (ins "Type":$inner, "::mlir::IntegerType":$axisBusType);

  let assemblyFormat = "`<` $inner `,` $axisBusType `>`";

  let builders = [
    TypeBuilder<(ins "Type":$innerType, "uint64_t":$axisWidth), [{
        auto busType = ::mlir::IntegerType::get($_ctxt, axisWidth, ::mlir::IntegerType::Signless);
        return Base::get($_ctxt, innerType, busType);
      }]>,
  ];
}

def ChannelType : ESI_Port<"Channel"> {
  let summary = "An ESI-compatible channel port";
  let description = [{
    An ESI port kind which models a latency-insensitive, unidirectional,
    point-to-point data stream. Channels are typed (like all of ESI). Said
    type can be any MLIR type, but must be lowered to something a backend
    knows how to output (i.e. something emitVerilog knows about).

    Example:

    ```mlir
    hw.module.extern @Sender() -> (%x: !esi.channel<i1>)
    hw.module @Reciever(%a: !esi.channel<hw.array<5xi16>>) { }
    ```
  }];

  let mnemonic = "channel";
  let parameters = (ins
      "Type":$inner,
      DefaultValuedParameter<
        "::circt::esi::ChannelSignaling",
        "::circt::esi::ChannelSignaling::ValidReady">:$signaling);

  let assemblyFormat = "`<` $inner (`,` $signaling^)? `>`";
 
  let builders = [
    TypeBuilder<(ins "Type":$type), [{
        return Base::get(type.getContext(), type,
                         ::circt::esi::ChannelSignaling::ValidReady);
      }]>,
  ];

  let extraClassDeclaration = [{
    Type getPayloadType() {
      if (getSignaling() == ::circt::esi::ChannelSignaling::AXIStream)
        return getInner().cast<AXIStreamType>().getInner();
      else
        return getInner();
    }
  }];
}

//=========
// Operations on ports.

def WrapValidReadyOp : ESI_Op<"wrap.vr", [
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "Wrap a value into an ESI port";
  let description = [{
    Wrapping a value into an ESI port type allows modules to send values down
    an ESI port. Wrap data with valid bit, result is the ESI channel and the
    ready signal from the other end of the channel.
  }];

  let arguments = (ins AnyType:$rawInput, I1:$valid);
  let results = (outs ChannelType:$chanOutput, I1:$ready);
  let hasCustomAssemblyFormat = 1;
  let hasFolder = 1;
  let hasVerifier = 1;

  let builders = [
    OpBuilder<(ins "mlir::Value":$data, "mlir::Value":$valid)>
  ];
}

def UnwrapValidReadyOp : ESI_Op<"unwrap.vr", [
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "Unwrap a value from an ESI port";
  let description = [{
    Unwrapping a value allows operations on the contained value. Unwrap the
    channel along with a ready signal that you generate. Result is the data
    along with a valid signal.
  }];

  let arguments = (ins ChannelType:$chanInput, I1:$ready);
  let results = (outs AnyType:$rawOutput, I1:$valid);
  let hasCustomAssemblyFormat = 1;
  let hasVerifier = 1;

  let builders = [
    OpBuilder<(ins "mlir::Value":$inChan, "mlir::Value":$ready)>
  ];
}

def WrapFIFOOp : ESI_Op<"wrap.fifo", [
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "Wrap a value into an ESI port with FIFO signaling";

  let arguments = (ins AnyType:$data, I1:$empty);
  let results = (outs ChannelType:$chanOutput, I1:$rden);
  let hasCanonicalizeMethod = true;
  let hasFolder = true;
  let hasVerifier = 1;

  let assemblyFormat = [{
    $data `,` $empty attr-dict `:`
      custom<WrapFIFOType>(type($data), type($chanOutput))
  }];
}

def UnwrapFIFOOp : ESI_Op<"unwrap.fifo", [
    DeclareOpInterfaceMethods<InferTypeOpInterface>,
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "Unwrap a value from an ESI port into a FIFO interface";

  let arguments = (ins ChannelType:$chanInput, I1:$rden);
  let results = (outs AnyType:$data, I1:$empty);
  let hasCanonicalizeMethod = true;
  let hasVerifier = 1;

  let assemblyFormat = [{
    $chanInput `,` $rden attr-dict `:` qualified(type($chanInput))
  }];

  let extraClassDeclaration = [{
    static LogicalResult mergeAndErase(UnwrapFIFOOp, WrapFIFOOp, PatternRewriter&);
  }];
}

def WrapAXIStreamOp : ESI_Op<"wrap.axistream", [
  DeclareOpInterfaceMethods<ChannelOpInterface>
]> {
  let summary = "Wrap a value into an ESI port with AXI Stream signaling";

  let arguments = (ins
    I1:$valid,
    HWIntegerType:$data
  );

  let results = (outs
    ChannelType:$chanOutput,
    I1:$ready
  );

  let assemblyFormat = [{
    $valid `,` $data
      attr-dict `:` custom<WrapAXIStreamType>(type($data), type($chanOutput))
  }];

  let builders = [
    OpBuilder<(ins "mlir::Value":$valid, "mlir::Value":$data, "mlir::Type":$dataType)>
  ];

  let hasVerifier = 1;
  let hasCanonicalizeMethod = true;
}

def UnwrapAXIStreamOp : ESI_Op<"unwrap.axistream", [
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "Unwrap a value from an ESI port into AXI Stream interface";

  let arguments = (ins ChannelType:$chanInput, I1:$ready);
  let results = (outs
    I1:$valid,
    HWIntegerType:$data
  );

  let assemblyFormat = [{
    $chanInput `,` $ready attr-dict `:` custom<UnwrapAXIStreamType>(type($chanInput), type($data))
  }];

  let hasVerifier = 1;
  let hasCanonicalizeMethod = true;

  let builders = [
    OpBuilder<(ins "mlir::Value":$chanInput, "mlir::Value":$ready)>
  ];

  let extraClassDeclaration = [{
    static LogicalResult mergeAndErase(UnwrapAXIStreamOp, WrapAXIStreamOp, PatternRewriter&);
  }];
}

def ModportType:
  Type<CPred<"$_self.isa<::circt::sv::ModportType>()">, "sv.interface">;

def WrapSVInterfaceOp: ESI_Op<"wrap.iface", [
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "Wrap an SV interface into an ESI port";
  let description = [{
    Wrap a SystemVerilog interface into an ESI channel. Interface MUST look
    like an interface produced by ESI meaning it MUST contain valid, ready,
    and data signals. Any other signals will be discarded.
  }];

  let arguments = (ins ModportType:$interfaceSink);
  let results = (outs ChannelType:$output);

  let assemblyFormat = [{
    $interfaceSink attr-dict `:` qualified(type($interfaceSink)) `->` qualified(type($output))
  }];

  let hasVerifier = 1;
}

def UnwrapSVInterfaceOp : ESI_Op<"unwrap.iface", [
    DeclareOpInterfaceMethods<ChannelOpInterface>
  ]> {
  let summary = "Unwrap an SV interface from an ESI port";
  let description = [{
    Unwrap an ESI channel into a SystemVerilog interface containing valid,
    ready, and data signals.
  }];

  let arguments = (ins ChannelType:$chanInput, ModportType:$interfaceSource);
  let results = (outs);

  let assemblyFormat = [{
    $chanInput `into` $interfaceSource attr-dict `:` `(` qualified(type($chanInput)) `,` qualified(type($interfaceSource)) `)`
  }];

  let hasVerifier = 1;
}
