module mem_2rw_uram #(
    parameter BYTES_PER_LINE = 4,
    parameter ADDR_WIDTH     = 13,
    parameter LINE_SIZE      = 8 * BYTES_PER_LINE
) (
    input wire clk,

    input  wire                      ena,
    input  wire [BYTES_PER_LINE-1:0] wena,
    input  wire [  ADDR_WIDTH-1 : 0] addra,
    input  wire [   LINE_SIZE-1 : 0] dina,
    output wire [   LINE_SIZE-1 : 0] douta,

    input  wire                      enb,
    input  wire [BYTES_PER_LINE-1:0] wenb,
    input  wire [  ADDR_WIDTH-1 : 0] addrb,
    input  wire [   LINE_SIZE-1 : 0] dinb,
    output wire [   LINE_SIZE-1 : 0] doutb
);

  (* ram_style = "ultra" *)
  reg [LINE_SIZE-1:0] mem[(1<<ADDR_WIDTH)-1:0];
  reg [LINE_SIZE-1:0] mem_out_a;
  reg [LINE_SIZE-1:0] mem_out_b;
  integer i;

  always @(posedge clk)
    if (ena)
      for (i = 0; i < BYTES_PER_LINE; i = i + 1) if (wena[i]) mem[addra][i*8+:8] <= dina[i*8+:8];

  always @(posedge clk) if (ena) if (~|wena) mem_out_a <= mem[addra];

  always @(posedge clk)
    if (enb)
      for (i = 0; i < BYTES_PER_LINE; i = i + 1) if (wenb[i]) mem[addrb][i*8+:8] <= dinb[i*8+:8];

  always @(posedge clk) if (enb) if (~|wenb) mem_out_b <= mem[addrb];

  assign douta = mem_out_a;
  assign doutb = mem_out_b;

  // Only for simulation, URAM cannot be loaded during programming
  // synthesis translate_off
  integer j;
  initial begin
    // two nested loops for smaller number of iterations per loop
    // workaround for synthesizer complaints about large loop counts
    for (i = 0; i < 2 ** (ADDR_WIDTH); i = i + 2 ** ((ADDR_WIDTH - 1) / 2)) begin
      for (j = i; j < i + 2 ** ((ADDR_WIDTH - 1) / 2); j = j + 1) begin
        mem[j] = {LINE_SIZE{1'b0}};
      end
    end
  end
  // synthesis translate_on

endmodule

`resetall
