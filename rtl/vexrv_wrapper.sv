`resetall `timescale 1ns / 1ps `default_nettype none

module vexrv_wrapper #(
    parameter DATA_W = 32,
    parameter ADDR_W = 32,
    parameter STRB_W = DATA_W / 8
) (
    input wire core_clk,
    input wire core_rst,

    input wire timerInterrupt,
    input wire externalInterrupt,
    input wire softwareInterrupt,

    taxi_axil_if.rd_mst m_axil_rd_imem,

    taxi_axil_if.wr_mst dmem_axil_wr,
    taxi_axil_if.rd_mst dmem_axil_rd,

    taxi_axil_if.wr_mst pmem_axil_wr,
    taxi_axil_if.rd_mst pmem_axil_rd,

    taxi_axil_if.wr_mst eiomem_axil_wr,
    taxi_axil_if.rd_mst eiomem_axil_rd,

    taxi_axil_if.wr_mst iiomem_axil_wr,
    taxi_axil_if.rd_mst iiomem_axil_rd


);



  wire              ibus_ar_valid;
  wire              ibus_ar_ready;
  wire [ADDR_W-1:0] ibus_ar_addr;
  wire [       2:0] ibus_ar_prot;
  wire [       3:0] ibus_ar_cache;

  wire              ibus_r_valid;
  wire              ibus_r_ready;
  wire [DATA_W-1:0] ibus_r_data;
  wire [       1:0] ibus_r_resp;


  wire              dbus_aw_valid;
  wire              dbus_aw_ready;
  wire [ADDR_W-1:0] dbus_aw_addr;
  wire [       2:0] dbus_aw_prot;
  wire [       2:0] dbus_aw_size;
  wire [       3:0] dbus_aw_cache;

  wire              dbus_w_valid;
  wire              dbus_w_ready;
  wire [DATA_W-1:0] dbus_w_data;
  wire [STRB_W-1:0] dbus_w_strb;

  wire              dbus_b_valid;
  wire              dbus_b_ready;
  wire [       1:0] dbus_b_resp;

  wire              dbus_ar_valid;
  wire              dbus_ar_ready;
  wire [ADDR_W-1:0] dbus_ar_addr;
  wire [       2:0] dbus_ar_prot;
  wire [       2:0] dbus_ar_size;
  wire [       3:0] dbus_ar_cache;

  wire              dbus_r_valid;
  wire              dbus_r_ready;
  wire [DATA_W-1:0] dbus_r_data;
  wire [       1:0] dbus_r_resp;

  vexrv u_core (
      .clk              (core_clk),
      .reset            (core_rst),
      .timerInterrupt   (timerInterrupt),
      .externalInterrupt(externalInterrupt),
      .softwareInterrupt(softwareInterrupt),

      .iBusAxi_ar_valid        (ibus_ar_valid),
      .iBusAxi_ar_ready        (ibus_ar_ready),
      .iBusAxi_ar_payload_addr (ibus_ar_addr),
      .iBusAxi_ar_payload_cache(ibus_ar_cache),
      .iBusAxi_ar_payload_prot (ibus_ar_prot),

      .iBusAxi_r_valid       (ibus_r_valid),
      .iBusAxi_r_ready       (ibus_r_ready),
      .iBusAxi_r_payload_data(ibus_r_data),
      .iBusAxi_r_payload_resp(ibus_r_resp),
      .iBusAxi_r_payload_last(),

      .dBusAxi_aw_valid        (dbus_aw_valid),
      .dBusAxi_aw_ready        (dbus_aw_ready),
      .dBusAxi_aw_payload_addr (dbus_aw_addr),
      .dBusAxi_aw_payload_size (dbus_aw_size),
      .dBusAxi_aw_payload_cache(dbus_aw_cache),
      .dBusAxi_aw_payload_prot (dbus_aw_prot),

      .dBusAxi_w_valid       (dbus_w_valid),
      .dBusAxi_w_ready       (dbus_w_ready),
      .dBusAxi_w_payload_data(dbus_w_data),
      .dBusAxi_w_payload_strb(dbus_w_strb),
      .dBusAxi_w_payload_last(),

      .dBusAxi_b_valid       (dbus_b_valid),
      .dBusAxi_b_ready       (dbus_b_ready),
      .dBusAxi_b_payload_resp(dbus_b_resp),

      .dBusAxi_ar_valid        (dbus_ar_valid),
      .dBusAxi_ar_ready        (dbus_ar_ready),
      .dBusAxi_ar_payload_addr (dbus_ar_addr),
      .dBusAxi_ar_payload_size (dbus_ar_size),
      .dBusAxi_ar_payload_cache(dbus_ar_cache),
      .dBusAxi_ar_payload_prot (dbus_ar_prot),

      .dBusAxi_r_valid       (dbus_r_valid),
      .dBusAxi_r_ready       (dbus_r_ready),
      .dBusAxi_r_payload_data(dbus_r_data),
      .dBusAxi_r_payload_resp(dbus_r_resp),
      .dBusAxi_r_payload_last()
  );


  ibus_converter_0 ibus_conv_inst (
      .aclk   (core_clk),
      .aresetn(~core_rst),

      .s_axi_araddr (ibus_ar_addr),   // [ADDR_W-1:0]
      .s_axi_arprot (ibus_ar_prot),   // [2:0]
      .s_axi_arvalid(ibus_ar_valid),
      .s_axi_arready(ibus_ar_ready),

      // ---- tie-offs for the rest of the burst signals ----
      .s_axi_arlen   (8'd0),   // single beat
      .s_axi_arsize  (3'd2),   // 2³ = 4?bytes (DATA_W=32)
      .s_axi_arburst (2'b01),  // INCR
      .s_axi_arlock  (1'b0),
      .s_axi_arcache (4'd0),
      .s_axi_arqos   (4'd0),
      .s_axi_arregion(4'd0),


      // R-channel back to your core
      .s_axi_rdata (ibus_r_data),   // [DATA_W-1:0]
      .s_axi_rresp (ibus_r_resp),   // [1:0]
      .s_axi_rvalid(ibus_r_valid),
      .s_axi_rready(ibus_r_ready),
      .s_axi_rlast (1'b1),          // always last in a 1-beat transfer



      .m_axi_araddr (m_axil_rd_imem.araddr),
      .m_axi_arprot (m_axil_rd_imem.arprot),
      .m_axi_arvalid(m_axil_rd_imem.arvalid),
      .m_axi_arready(m_axil_rd_imem.arready),

      .m_axi_rdata (m_axil_rd_imem.rdata),
      .m_axi_rresp (m_axil_rd_imem.rresp),
      .m_axi_rvalid(m_axil_rd_imem.rvalid),
      .m_axi_rready(m_axil_rd_imem.rready)
  );

  // IMEM Core ILA: monitor core side
  ila_bus_read vex_imem_read (
      .clk   (core_clk),
      .probe0(m_axil_rd_imem.arvalid),  // core AR valid
      .probe1(m_axil_rd_imem.araddr),   // core AR addr
      .probe2(m_axil_rd_imem.rvalid),   // core R valid
      .probe3(m_axil_rd_imem.rdata)     // core R data
  );

  taxi_axil_if mem_axil ();

  dbus_converter_0 dbus_conv_inst (
      .aclk   (core_clk),
      .aresetn(~core_rst),

      .s_axi_awaddr  (dbus_aw_addr),
      .s_axi_awprot  (dbus_aw_prot),
      .s_axi_awsize  (dbus_aw_size),   // ? was missing
      .s_axi_awcache (dbus_aw_cache),  // ? was missing
      .s_axi_awlen   (8'd0),           // tie off unused
      .s_axi_awburst (2'b01),          // INCR  
      .s_axi_awlock  (1'b0),
      .s_axi_awregion(4'd0),
      .s_axi_awqos   (4'd0),
      .s_axi_awvalid (dbus_aw_valid),
      .s_axi_awready (dbus_aw_ready),

      // data write channel
      .s_axi_wdata (dbus_w_data),
      .s_axi_wstrb (dbus_w_strb),
      .s_axi_wvalid(dbus_w_valid),
      .s_axi_wready(dbus_w_ready),
      .s_axi_wlast (1'b1),          // AXI4: single beat

      // write response channel
      .s_axi_bresp (dbus_b_resp),
      .s_axi_bvalid(dbus_b_valid),
      .s_axi_bready(dbus_b_ready),

      // address read channel
      .s_axi_araddr(dbus_ar_addr),
      .s_axi_arprot(dbus_ar_prot),
      .s_axi_arsize(dbus_ar_size),  // ? was missing
      .s_axi_arcache(dbus_ar_cache),  // ? was missing
      .s_axi_arlen(8'd0),
      .s_axi_arburst(2'b01),
      .s_axi_arlock(1'b0),
      .s_axi_arregion(4'd0),
      .s_axi_arqos(4'd0),
      .s_axi_arvalid(dbus_ar_valid),
      .s_axi_arready(dbus_ar_ready),

      // read data channel
      .s_axi_rdata (dbus_r_data),
      .s_axi_rresp (dbus_r_resp),
      .s_axi_rvalid(dbus_r_valid),
      .s_axi_rready(dbus_r_ready),
      .s_axi_rlast (),

      .m_axi_awaddr (mem_axil.awaddr),
      .m_axi_awprot (mem_axil.awprot),
      .m_axi_awvalid(mem_axil.awvalid),
      .m_axi_awready(mem_axil.awready),

      .m_axi_wdata (mem_axil.wdata),
      .m_axi_wstrb (mem_axil.wstrb),
      .m_axi_wvalid(mem_axil.wvalid),
      .m_axi_wready(mem_axil.wready),

      .m_axi_bresp (mem_axil.bresp),
      .m_axi_bvalid(mem_axil.bvalid),
      .m_axi_bready(mem_axil.bready),


      .m_axi_araddr (mem_axil.araddr),
      .m_axi_arprot (mem_axil.arprot),
      .m_axi_arvalid(mem_axil.arvalid),
      .m_axi_arready(mem_axil.arready),

      .m_axi_rdata (mem_axil.rdata),
      .m_axi_rresp (mem_axil.rresp),
      .m_axi_rvalid(mem_axil.rvalid),
      .m_axi_rready(mem_axil.rready)
  );



  xbar_slice_wrapper xbar_slice_wrapper_inst (
      .aclk   (core_clk),
      .aresetn(~core_rst),

      .s_wr_if(mem_axil),
      .s_rd_if(mem_axil),

      .m0_wr(iiomem_axil_wr),
      .m0_rd(iiomem_axil_rd),

      // master 1  (external IO)
      .m1_wr(eiomem_axil_wr),
      .m1_rd(eiomem_axil_rd),

      // master 2  (DMEM)
      .m2_wr(dmem_axil_wr),
      .m2_rd(dmem_axil_rd),

      // master 3  (PMEM)
      .m3_wr(pmem_axil_wr),
      .m3_rd(pmem_axil_rd)
  );



  ila_bus_write vex_dmem_write (
      .clk   (core_clk),
      .probe0(dmem_axil_wr.awvalid),  // core AW valid
      .probe1(dmem_axil_wr.awaddr),   // core AW addr
      .probe2(dmem_axil_wr.wvalid),   // core W valid
      .probe3(dmem_axil_wr.wdata)     // core W data
  );

  ila_bus_read vex_dmem_read (
      .clk   (core_clk),
      .probe0(dmem_axil_rd.arvalid),  // core AR valid
      .probe1(dmem_axil_rd.araddr),   // core AR addr
      .probe2(dmem_axil_rd.rvalid),   // core R valid
      .probe3(dmem_axil_rd.rdata)     // core R data
  );





endmodule

`resetall
