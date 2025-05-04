module xbar_slice_wrapper #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
) (
    input wire aclk,
    input wire aresetn,

    taxi_axil_if.wr_slv s_wr_if,
    taxi_axil_if.rd_slv s_rd_if,

    // 4 master interfaces
    taxi_axil_if.wr_mst m0_wr,
    taxi_axil_if.rd_mst m0_rd,  // internal IO
    taxi_axil_if.wr_mst m1_wr,
    taxi_axil_if.rd_mst m1_rd,  // external IO
    taxi_axil_if.wr_mst m2_wr,
    taxi_axil_if.rd_mst m2_rd,  // DMEM
    taxi_axil_if.wr_mst m3_wr,
    taxi_axil_if.rd_mst m3_rd   // PMEM
);

  /* --------------- instantiate the generated IP --------------- */
  snic_rv_crossbar_0 snic_rv_crossbar_inst (
      .aclk   (aclk),
      .aresetn(aresetn),

      /* ---- slave: straight‑through from taxi_axil_if ---- */
      .s_axi_awaddr (s_wr_if.awaddr),
      .s_axi_awprot (s_wr_if.awprot),
      .s_axi_awvalid(s_wr_if.awvalid),
      .s_axi_awready(s_wr_if.awready),

      .s_axi_wdata (s_wr_if.wdata),
      .s_axi_wstrb (s_wr_if.wstrb),
      .s_axi_wvalid(s_wr_if.wvalid),
      .s_axi_wready(s_wr_if.wready),

      .s_axi_bresp (s_wr_if.bresp),
      .s_axi_bvalid(s_wr_if.bvalid),
      .s_axi_bready(s_wr_if.bready),

      .s_axi_araddr (s_rd_if.araddr),
      .s_axi_arprot (s_rd_if.arprot),
      .s_axi_arvalid(s_rd_if.arvalid),
      .s_axi_arready(s_rd_if.arready),

      .s_axi_rdata (s_rd_if.rdata),
      .s_axi_rresp (s_rd_if.rresp),
      .s_axi_rvalid(s_rd_if.rvalid),
      .s_axi_rready(s_rd_if.rready),

      /* ---- master vectors ---- */
      .m_axi_awaddr ({m3_wr.awaddr, m2_wr.awaddr, m1_wr.awaddr, m0_wr.awaddr}),
      .m_axi_awprot ({m3_wr.awprot, m2_wr.awprot, m1_wr.awprot, m0_wr.awprot}),
      .m_axi_awvalid({m3_wr.awvalid, m2_wr.awvalid, m1_wr.awvalid, m0_wr.awvalid}),
      .m_axi_awready({m3_wr.awready, m2_wr.awready, m1_wr.awready, m0_wr.awready}),

      .m_axi_wdata ({m3_wr.wdata, m2_wr.wdata, m1_wr.wdata, m0_wr.wdata}),
      .m_axi_wstrb ({m3_wr.wstrb, m2_wr.wstrb, m1_wr.wstrb, m0_wr.wstrb}),
      .m_axi_wvalid({m3_wr.wvalid, m2_wr.wvalid, m1_wr.wvalid, m0_wr.wvalid}),
      .m_axi_wready({m3_wr.wready, m2_wr.wready, m1_wr.wready, m0_wr.wready}),

      .m_axi_bresp ({m3_wr.bresp, m2_wr.bresp, m1_wr.bresp, m0_wr.bresp}),
      .m_axi_bvalid({m3_wr.bvalid, m2_wr.bvalid, m1_wr.bvalid, m0_wr.bvalid}),
      .m_axi_bready({m3_wr.bready, m2_wr.bready, m1_wr.bready, m0_wr.bready}),

      .m_axi_araddr ({m3_rd.araddr, m2_rd.araddr, m1_rd.araddr, m0_rd.araddr}),
      .m_axi_arprot ({m3_rd.arprot, m2_rd.arprot, m1_rd.arprot, m0_rd.arprot}),
      .m_axi_arvalid({m3_rd.arvalid, m2_rd.arvalid, m1_rd.arvalid, m0_rd.arvalid}),
      .m_axi_arready({m3_rd.arready, m2_rd.arready, m1_rd.arready, m0_rd.arready}),

      .m_axi_rdata ({m3_rd.rdata, m2_rd.rdata, m1_rd.rdata, m0_rd.rdata}),
      .m_axi_rresp ({m3_rd.rresp, m2_rd.rresp, m1_rd.rresp, m0_rd.rresp}),
      .m_axi_rvalid({m3_rd.rvalid, m2_rd.rvalid, m1_rd.rvalid, m0_rd.rvalid}),
      .m_axi_rready({m3_rd.rready, m2_rd.rready, m1_rd.rready, m0_rd.rready})
  );

endmodule
