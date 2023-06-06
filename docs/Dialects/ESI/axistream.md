# ESI AXI4 Stream

For now we only implement support for unalined continuous packets on the receiving and
sending sides. This means that there is no support for interleaving and
reordering. `TSTRB` and `TKEEP` signals are not present.

- Receiving streams from multiple sources is not supported. `TID` and `TDEST` are omitted.

The ESI implementation of AXI4 Stream (AXIS) is defined the following way:
- An AXIS channel is specified the following way `!esi.channel<SomeType, AXIStream>`.
