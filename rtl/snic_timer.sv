`resetall `timescale 1ns / 1ps `default_nettype none

module snic_timer #(
    parameter LIMIT = 64'd50_000_000
) (
    input  wire clk,
    input  wire rst,
    output reg  timeout_pulse
);

  reg [63:0] counter;

  always @(posedge clk) begin
    if (rst) begin
      counter       <= 64'd0;
      timeout_pulse <= 1'b0;
    end else if (counter == LIMIT - 1) begin
      counter       <= 64'd0;
      timeout_pulse <= 1'b1;
    end else begin
      counter       <= counter + 1;
      timeout_pulse <= 1'b0;
    end
  end

endmodule

`default_nettype wire
