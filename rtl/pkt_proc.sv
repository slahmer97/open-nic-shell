`resetall `timescale 1ns / 1ps `default_nettype none

module pkt_proc (
    input wire clk,
    input wire rst,

    taxi_axil_if.wr_slv s_axil_wr_host,
    taxi_axil_if.rd_slv s_axil_rd_host
);

  localparam IMEM_BASE_ADDR = 32'h0000_0000;  //size = 64 KB -> width=16
  localparam DMEM_BASE_ADDR = 32'h0001_0000;  // size = 32 KB -> width=15



  localparam C_NUM_SLAVES = 2;
  localparam IMEM_INDEX = 0;
  localparam DMEM_INDEX = 1;

  wire [ 1*C_NUM_SLAVES-1:0] axil_awvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_awaddr;
  wire [ 1*C_NUM_SLAVES-1:0] axil_awready;
  wire [ 1*C_NUM_SLAVES-1:0] axil_wvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_wdata;
  wire [ 1*C_NUM_SLAVES-1:0] axil_wready;
  wire [ 1*C_NUM_SLAVES-1:0] axil_bvalid;
  wire [ 2*C_NUM_SLAVES-1:0] axil_bresp;
  wire [ 1*C_NUM_SLAVES-1:0] axil_bready;
  wire [ 1*C_NUM_SLAVES-1:0] axil_arvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_araddr;
  wire [ 1*C_NUM_SLAVES-1:0] axil_arready;
  wire [ 1*C_NUM_SLAVES-1:0] axil_rvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_rdata;
  wire [ 2*C_NUM_SLAVES-1:0] axil_rresp;
  wire [ 1*C_NUM_SLAVES-1:0] axil_rready;
  wire [ 3*C_NUM_SLAVES-1:0] axil_arprot;
  wire [ 3*C_NUM_SLAVES-1:0] axil_awprot;
  wire [ 4*C_NUM_SLAVES-1:0] axil_wstrb;


  taxi_axil_if s_axil_dmem ();
  taxi_axil_if s_axil_imem ();
  taxi_axi_if s_axi_pmem ();

  wire [31:0] imem_awaddr_raw, imem_araddr_raw;
  wire [31:0] dmem_awaddr_raw, dmem_araddr_raw;
  assign imem_awaddr_raw = axil_awaddr[`getvec(32, IMEM_INDEX)] - IMEM_BASE_ADDR;
  assign imem_araddr_raw = axil_araddr[`getvec(32, IMEM_INDEX)] - IMEM_BASE_ADDR;
  assign dmem_awaddr_raw = axil_awaddr[`getvec(32, DMEM_INDEX)] - DMEM_BASE_ADDR;
  assign dmem_araddr_raw = axil_araddr[`getvec(32, DMEM_INDEX)] - DMEM_BASE_ADDR;


  assign s_axil_imem.awvalid = axil_awvalid[IMEM_INDEX];
  assign s_axil_imem.awaddr = imem_awaddr_raw;
  assign axil_awready[IMEM_INDEX] = s_axil_imem.awready;
  assign s_axil_imem.wvalid = axil_wvalid[IMEM_INDEX];
  assign s_axil_imem.wdata = axil_wdata[`getvec(32, IMEM_INDEX)];
  assign s_axil_imem.wstrb = axil_wstrb[`getvec(4, IMEM_INDEX)];
  assign axil_wready[IMEM_INDEX] = s_axil_imem.wready;
  assign axil_bvalid[IMEM_INDEX] = s_axil_imem.bvalid;
  assign axil_bresp[`getvec(2, IMEM_INDEX)] = s_axil_imem.bresp;
  assign s_axil_imem.bready = axil_bready[IMEM_INDEX];
  assign s_axil_imem.arvalid = axil_arvalid[IMEM_INDEX];
  assign s_axil_imem.araddr = imem_araddr_raw;
  assign axil_arready[IMEM_INDEX] = s_axil_imem.arready;
  assign axil_rvalid[IMEM_INDEX] = s_axil_imem.rvalid;
  assign axil_rdata[`getvec(32, IMEM_INDEX)] = s_axil_imem.rdata;
  assign axil_rresp[`getvec(2, IMEM_INDEX)] = s_axil_imem.rresp;
  assign s_axil_imem.rready = axil_rready[IMEM_INDEX];

  // DMEM Connections -----------------------------------------------------------
  assign s_axil_dmem.awvalid = axil_awvalid[DMEM_INDEX];
  assign s_axil_dmem.awaddr = dmem_awaddr_raw;
  assign axil_awready[DMEM_INDEX] = s_axil_dmem.awready;
  assign s_axil_dmem.wvalid = axil_wvalid[DMEM_INDEX];
  assign s_axil_dmem.wdata = axil_wdata[`getvec(32, DMEM_INDEX)];
  assign s_axil_dmem.wstrb = axil_wstrb[`getvec(4, DMEM_INDEX)];
  assign axil_wready[DMEM_INDEX] = s_axil_dmem.wready;
  assign axil_bvalid[DMEM_INDEX] = s_axil_dmem.bvalid;
  assign axil_bresp[`getvec(2, DMEM_INDEX)] = s_axil_dmem.bresp;
  assign s_axil_dmem.bready = axil_bready[DMEM_INDEX];
  assign s_axil_dmem.arvalid = axil_arvalid[DMEM_INDEX];
  assign s_axil_dmem.araddr = dmem_araddr_raw;
  assign axil_arready[DMEM_INDEX] = s_axil_dmem.arready;
  assign axil_rvalid[DMEM_INDEX] = s_axil_dmem.rvalid;
  assign axil_rdata[`getvec(32, DMEM_INDEX)] = s_axil_dmem.rdata;
  assign axil_rresp[`getvec(2, DMEM_INDEX)] = s_axil_dmem.rresp;
  assign s_axil_dmem.rready = axil_rready[DMEM_INDEX];

  pkt_proc_xbar_0 pkt_proc_xbar (
      .aclk   (clk),
      .aresetn(~rst),

      .s_axi_awaddr (s_axil_wr_host.awaddr),
      .s_axi_awprot (s_axil_wr_host.awprot),
      .s_axi_awvalid(s_axil_wr_host.awvalid),
      .s_axi_awready(s_axil_wr_host.awready),
      .s_axi_wdata  (s_axil_wr_host.wdata),
      .s_axi_wstrb  (s_axil_wr_host.wstrb),
      .s_axi_wvalid (s_axil_wr_host.wvalid),
      .s_axi_wready (s_axil_wr_host.wready),
      .s_axi_bresp  (s_axil_wr_host.bresp),
      .s_axi_bvalid (s_axil_wr_host.bvalid),
      .s_axi_bready (s_axil_wr_host.bready),

      .s_axi_araddr (s_axil_rd_host.araddr),
      .s_axi_arprot (s_axil_rd_host.arprot),
      .s_axi_arvalid(s_axil_rd_host.arvalid),
      .s_axi_arready(s_axil_rd_host.arready),
      .s_axi_rdata  (s_axil_rd_host.rdata),
      .s_axi_rresp  (s_axil_rd_host.rresp),
      .s_axi_rvalid (s_axil_rd_host.rvalid),
      .s_axi_rready (s_axil_rd_host.rready),

      .m_axi_awaddr (axil_awaddr),
      .m_axi_awprot (axil_awprot),
      .m_axi_awvalid(axil_awvalid),
      .m_axi_awready(axil_awready),
      .m_axi_wdata  (axil_wdata),
      .m_axi_wstrb  (axil_wstrb),
      .m_axi_wvalid (axil_wvalid),
      .m_axi_wready (axil_wready),
      .m_axi_bresp  (axil_bresp),
      .m_axi_bvalid (axil_bvalid),
      .m_axi_bready (axil_bready),
      .m_axi_araddr (axil_araddr),
      .m_axi_arprot (axil_arprot),
      .m_axi_arvalid(axil_arvalid),
      .m_axi_arready(axil_arready),
      .m_axi_rdata  (axil_rdata),
      .m_axi_rresp  (axil_rresp),
      .m_axi_rvalid (axil_rvalid),
      .m_axi_rready (axil_rready)

  );



  snic_rv snic_inst (
      .core_clk(clk),
      .core_rst(rst),

      .s_axil_wr_imem_host(s_axil_imem),
      .s_axil_rd_imem_host(s_axil_imem),  // TODO remove later just for debuging

      .s_axil_wr_dmem_host(s_axil_dmem),
      .s_axil_rd_dmem_host(s_axil_dmem),
      
      .s_axi_wr_pmem_dmover(s_axi_pmem),
      .s_axi_rd_pmem_dmover(s_axi_pmem)

  );

endmodule

`default_nettype wire
