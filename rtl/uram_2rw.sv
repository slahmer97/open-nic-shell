`timescale 1ns / 1ps `default_nettype none

module uram_2rw (
    input wire clk,
    input wire rst,

    // AXI4-Lite write/read interface
    taxi_axil_if.wr_slv s_axil_wr,
    taxi_axil_if.rd_slv s_axil_rd,

    // AXI4-Full write/read interface
    taxi_axi_if.wr_slv s_axi_wr,
    taxi_axi_if.rd_slv s_axi_rd
);

  //--------------------------------------------------------------------------
  // Parameters & local signals
  //--------------------------------------------------------------------------
  localparam BYTES_PER_LINE = 4;
  localparam ADDR_WIDTH = 14;
  localparam LINE_SIZE = 8 * BYTES_PER_LINE;

  // Port A wires  (driven by AXI-Lite ctrl)
  wire                      mem_ena;
  wire [BYTES_PER_LINE-1:0] mem_wena;
  wire [    ADDR_WIDTH-1:0] mem_addra;
  wire [     LINE_SIZE-1:0] mem_dina;
  wire [     LINE_SIZE-1:0] mem_douta;


  wire                      mem_enb;
  wire [BYTES_PER_LINE-1:0] mem_wenb;
  wire [    ADDR_WIDTH-1:0] mem_addrb;
  wire [     LINE_SIZE-1:0] mem_dinb;
  wire [     LINE_SIZE-1:0] mem_doutb;

    
    wire bram_rst_a_lite;
    wire bram_rst_a_full;

  //--------------------------------------------------------------------------
  // AXI4-Lite → BRAM port A
  //--------------------------------------------------------------------------
  uram_axi4lite_ctrl_1rw_0 u_axil_ctrl (
      .s_axi_aclk   (clk),
      .s_axi_aresetn(~rst),

      // AW
      .s_axi_awaddr (s_axil_wr.awaddr),
      .s_axi_awprot (s_axil_wr.awprot),
      .s_axi_awvalid(s_axil_wr.awvalid),
      .s_axi_awready(s_axil_wr.awready),

      // W
      .s_axi_wdata (s_axil_wr.wdata),
      .s_axi_wstrb (s_axil_wr.wstrb),
      .s_axi_wvalid(s_axil_wr.wvalid),
      .s_axi_wready(s_axil_wr.wready),

      // B
      .s_axi_bresp (s_axil_wr.bresp),
      .s_axi_bvalid(s_axil_wr.bvalid),
      .s_axi_bready(s_axil_wr.bready),

      // AR
      .s_axi_araddr (s_axil_rd.araddr),
      .s_axi_arprot (s_axil_rd.arprot),
      .s_axi_arvalid(s_axil_rd.arvalid),
      .s_axi_arready(s_axil_rd.arready),

      // R
      .s_axi_rdata (s_axil_rd.rdata),
      .s_axi_rresp (s_axil_rd.rresp),
      .s_axi_rvalid(s_axil_rd.rvalid),
      .s_axi_rready(s_axil_rd.rready),

      // BRAM port A
      .bram_rst_a   (bram_rst_a_lite),
      .bram_clk_a   (clk),
      .bram_en_a    (mem_ena),
      .bram_we_a    (mem_wena),
      .bram_addr_a  (mem_addra),
      .bram_wrdata_a(mem_dina),
      .bram_rddata_a(mem_douta)
  );


  //--------------------------------------------------------------------------
  // AXI4-Full → BRAM port B
  //--------------------------------------------------------------------------
  uram_axi4_ctrl_1rw_0 u_axi_ctrl (
      .s_axi_aclk   (clk),
      .s_axi_aresetn(~rst),

      // AW
     // .s_axi_awid   (s_axi_wr.awid),
      .s_axi_awaddr (s_axi_wr.awaddr),
      .s_axi_awlen  (s_axi_wr.awlen),
      .s_axi_awsize (s_axi_wr.awsize),
      .s_axi_awburst(s_axi_wr.awburst),
      .s_axi_awlock (s_axi_wr.awlock),
      .s_axi_awcache(s_axi_wr.awcache),
      .s_axi_awprot (s_axi_wr.awprot),
     // .s_axi_awqos  (s_axi_wr.awqos),
      .s_axi_awvalid(s_axi_wr.awvalid),
      .s_axi_awready(s_axi_wr.awready),

      // W
      .s_axi_wdata (s_axi_wr.wdata),
      .s_axi_wstrb (s_axi_wr.wstrb),
      .s_axi_wlast (s_axi_wr.wlast),
      .s_axi_wvalid(s_axi_wr.wvalid),
      .s_axi_wready(s_axi_wr.wready),

      // B
    //  .s_axi_bid   (s_axi_wr.bid),
      .s_axi_bresp (s_axi_wr.bresp),
      .s_axi_bvalid(s_axi_wr.bvalid),
      .s_axi_bready(s_axi_wr.bready),

      // AR
  //    .s_axi_arid   (s_axi_rd.arid),
      .s_axi_araddr (s_axi_rd.araddr),
      .s_axi_arlen  (s_axi_rd.arlen),
      .s_axi_arsize (s_axi_rd.arsize),
      .s_axi_arburst(s_axi_rd.arburst),
      .s_axi_arlock (s_axi_rd.arlock),
      .s_axi_arcache(s_axi_rd.arcache),
      .s_axi_arprot (s_axi_rd.arprot),
      //.s_axi_arqos  (s_axi_rd.arqos),
      .s_axi_arvalid(s_axi_rd.arvalid),
      .s_axi_arready(s_axi_rd.arready),

      // R
   //   .s_axi_rid   (s_axi_rd.rid),
      .s_axi_rdata (s_axi_rd.rdata),
      .s_axi_rresp (s_axi_rd.rresp),
      .s_axi_rlast (s_axi_rd.rlast),
      .s_axi_rvalid(s_axi_rd.rvalid),
      .s_axi_rready(s_axi_rd.rready),

      // BRAM port B (still named “_a” on the controller)
      .bram_rst_a   (bram_rst_a_full),
      .bram_clk_a   (clk),
      .bram_en_a    (mem_enb),
      .bram_we_a    (mem_wenb),
      .bram_addr_a  (mem_addrb),
      .bram_wrdata_a(mem_dinb),
      .bram_rddata_a(mem_doutb)
  );



  mem_2rw_uram #(
      .BYTES_PER_LINE(BYTES_PER_LINE),
      .ADDR_WIDTH    (ADDR_WIDTH)
  ) uram_inst (
      .clk(clk),

      // port A  AXI-Lite
      .ena  (mem_ena),
      .wena (mem_wena),
      .addra(mem_addra),
      .dina (mem_dina),
      .douta(mem_douta),

      // port B  AXI-Full
      .enb  (mem_enb),
      .wenb (mem_wenb),
      .addrb(mem_addrb),
      .dinb (mem_dinb),
      .doutb(mem_doutb)
  );

endmodule

`default_nettype wire
