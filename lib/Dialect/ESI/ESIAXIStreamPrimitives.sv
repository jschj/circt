/*
module ESI_BitwidthConversion # (
  int IN_BYTE_WIDTH = 8,
  int OUT_BYTE_WIDTH = 8
) (
  input logic clk,
  input logic rst,
  input logic [IN_BYTE_WIDTH*8-1:0] data_in,
  input logic data_in_valid,
  output logic data_in_ready,
  output logic [OUT_BYTE_WIDTH*8-1:0] data_out,
  output logic data_out_valid,
  input logic data_out_ready
);
  int N = (IN_BYTE_WIDTH+OUT_BYTE_WIDTH)*2;
  logic [7:0] ram [N-1:0];
  logic [$clog2(N)-1:0] head;
  logic [$clog2(N)-1:0] tail;

  // reset block
  @always_ff @(posedge clk) if (rst) begin
    head <= 0;
    tail <= 0;
  end

  logic canEnqueue;

  // enqueue block
  @always_ff @(posedge clk) if (canEnqueue) begin
    genvar i;
    for (i = 0; i < IN_BYTE_WIDTH; i++)
      ram[head + i] <= data_in[i*8 +: 8];

    head <= head + IN_BYTE_WIDTH;
  end

endmodule
 */

module ESI_AXIStreamReceiver # (
  int TDATA_WIDTH = 64,
  int DATA_OUT_WIDTH = 32
) (
  input logic clk,
  input logic rst,
  // AXIStream input channel
  input logic TVALID,
  output logic TREADY,
  input logic [TDATA_WIDTH-1:0] TDATA,
  // rv output channel
  output logic [DATA_OUT_WIDTH-1:0] data_out,
  output logic data_out_valid,
  input logic data_out_ready
);

  logic in_data [TDATA_WIDTH-1:0];
  logic in_data_valid;

  // enqueue logic
  always_ff @(posedge clk)
    if (rst) begin
      in_data <= 0;
      in_data_valid <= 0;
    end else if (TVALID && TREADY && !in_data_valid) begin
      in_data <= TDATA;
      in_data_valid <= 1;
    end

  // dequeue logic
  always_ff @(posedge clk)
    if (data_out_ready && in_data_valid) begin
      data_out <= in_data[DATA_OUT_WIDTH-1:0];
      in_data_valid <= 0;
    end

  assign data_out_valid = in_data_valid;
endmodule

module ESI_AXIStreamSender # (
  int TDATA_WIDTH = 64,
  int DATA_IN_WIDTH = 32
) (
  input logic clk,
  input logic rst,
  // AXIStream output channel
  output logic TVALID,
  input logic TREADY,
  output logic [TDATA_WIDTH-1:0] TDATA,
  // rv input channel
  input logic [DATA_IN_WIDTH-1:0] data_in,
  input logic data_in_valid,
  output logic data_in_ready
);

  

endmodule

