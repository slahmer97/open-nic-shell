`timescale 1ns / 1ps `default_nettype none

module bram_1rw (
    input wire                clk,        // S_AXI clock
    input wire                rst,        // S_AXI active‐low reset
    // AXI4-Lite write interface
          taxi_axil_if.wr_slv s_axil_wr,
    // AXI4-Lite read interface
          taxi_axil_if.rd_slv s_axil_rd
);

  //----------------------------------------------------------------
  // Instantiate the AXI BRAM Controller (v4.1) with INTERNAL BMG
  //----------------------------------------------------------------
  axi_bram_ctrl_1rw_0 u_axi_bram_ctrl (
      // Global signals
      .s_axi_aclk   (clk),
      .s_axi_aresetn(~rst),

      //–– Write address channel
      .s_axi_awaddr (s_axil_wr.awaddr),
      .s_axi_awprot (s_axil_wr.awprot),
      .s_axi_awvalid(s_axil_wr.awvalid),
      .s_axi_awready(s_axil_wr.awready),

      //–– Write data channel
      .s_axi_wdata (s_axil_wr.wdata),
      .s_axi_wstrb (4'hF),
      .s_axi_wvalid(s_axil_wr.wvalid),
      .s_axi_wready(s_axil_wr.wready),

      //–– Write response channel
      .s_axi_bresp (s_axil_wr.bresp),
      .s_axi_bvalid(s_axil_wr.bvalid),
      .s_axi_bready(s_axil_wr.bready),

      //–– Read address channel
      .s_axi_araddr (s_axil_rd.araddr),
      .s_axi_arprot (s_axil_rd.arprot),
      .s_axi_arvalid(s_axil_rd.arvalid),
      .s_axi_arready(s_axil_rd.arready),

      //–– Read data channel
      .s_axi_rdata (s_axil_rd.rdata),
      .s_axi_rresp (s_axil_rd.rresp),
      .s_axi_rvalid(s_axil_rd.rvalid),
      .s_axi_rready(s_axil_rd.rready)

  );

endmodule

`default_nettype wire
