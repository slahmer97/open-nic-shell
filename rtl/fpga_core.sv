module fpga_core (
    // ---------------- AXI?Lite CSR slave -----------------------------------
    taxi_axil_if.wr_slv  s_axil_wr,
    taxi_axil_if.rd_slv  s_axil_rd,

    // ---------------- Network side (Ethernet) -----------------------------
    taxi_axis_if.src     m_axis_net,   // to packet_adapter / CMAC
    taxi_axis_if.snk     s_axis_net,   // from packet_adapter / CMAC

    // ---------------- Host side (PCIe) ------------------------------------
    taxi_axis_if.src     m_axis_host,  // to QDMA (C2H)
    taxi_axis_if.snk     s_axis_host,  // from QDMA (H2C)

    // ---------------- Clocks & reset --------------------------------------
    input  logic         axil_aclk,        // 250?MHz CSR clock
    input  logic         ref_clk_100mhz,   // unused for now (HBM option)
    input  logic         axis_aclk,        // 250?MHz data clock
    input  logic         rstn              // active?high reset (from system_cfg)
);

    // =====================================================================
    // 1. Module?local reset (sync to axil_aclk)
    // =====================================================================
    wire core_rstn;       // de?asserted when core may run
    wire core_rst_done;   // unused ? tie?off externally if needed

    generic_reset #(
        .NUM_INPUT_CLK (1),
        .RESET_DURATION(100)
    ) gen_rst_i (
        .mod_rstn     (rstn),          // incoming reset from shell bit 31
        .mod_rst_done (core_rst_done), // not wired upward
        .clk          (axil_aclk),
        .rstn         (core_rstn)
    );

    // =====================================================================
    // 2.  AXI?Lite CSR ? dummy, all registers read as zero, writes acked
    // =====================================================================
    /*
     *  VERY small implementation ? good enough so that host driver sees a
     *  responding target.  Extend with real registers as needed.
     */

    // ------------ Write channel -------------
    logic bvalid_r;
    always_ff @(posedge axil_aclk) begin
        if (!core_rstn) begin
            bvalid_r <= 1'b0;
        end else begin
            if (!bvalid_r && s_axil_wr.awvalid && s_axil_wr.wvalid)
                bvalid_r <= 1'b1;               // accept write
            else if (bvalid_r && s_axil_wr.bready)
                bvalid_r <= 1'b0;               // complete
        end
    end

    assign s_axil_wr.awready = core_rstn & ~bvalid_r;
    assign s_axil_wr.wready  = core_rstn & ~bvalid_r;
    assign s_axil_wr.bvalid  = bvalid_r;
    assign s_axil_wr.bresp   = 2'b00;            // OKAY

    // ------------ Read channel --------------
    logic             rvalid_r;
    logic      [31:0] rdata_r;
    always_ff @(posedge axil_aclk) begin
        if (!core_rstn) begin
            rvalid_r <= 1'b0;
        end else begin
            if (!rvalid_r && s_axil_rd.arvalid) begin
                rvalid_r <= 1'b1;
                rdata_r  <= 32'h0000_0000;      // all zeros for now
            end else if (rvalid_r && s_axil_rd.rready)
                rvalid_r <= 1'b0;
        end
    end

    assign s_axil_rd.arready = core_rstn & ~rvalid_r;
    assign s_axil_rd.rvalid  = rvalid_r;
    assign s_axil_rd.rdata   = rdata_r;
    assign s_axil_rd.rresp   = 2'b00;            // OKAY

    // =====================================================================
    // 3.  Data path ? pure pass?through in each direction
    //     * Host ? Net : H2C  ? m_axis_net
    //     * Net  ? Host: s_axis_net ? m_axis_host (C2H)
    //     Handshakes obey AXIS ready/valid rules, combinational paths are
    //     legal because both source & sink share the same clock (axis_aclk).
    // =====================================================================

    // ------------- Host ? Net (H2C) -------------
    assign m_axis_net.tvalid    = s_axis_host.tvalid;
    assign m_axis_net.tdata     = s_axis_host.tdata;
    assign m_axis_net.tkeep     = s_axis_host.tkeep;
    assign m_axis_net.tlast     = s_axis_host.tlast;
    assign m_axis_net.tid       = s_axis_host.tid;     // size
    assign m_axis_net.tuser     = s_axis_host.tuser;   // src
    assign m_axis_net.tdest     = s_axis_host.tdest;   // dst
    assign s_axis_host.tready   = m_axis_net.tready;

    // ------------- Net ? Host (C2H) -------------
    assign m_axis_host.tvalid   = s_axis_net.tvalid;
    assign m_axis_host.tdata    = s_axis_net.tdata;
    assign m_axis_host.tkeep    = s_axis_net.tkeep;
    assign m_axis_host.tlast    = s_axis_net.tlast;
    assign m_axis_host.tid      = s_axis_net.tid;
    assign m_axis_host.tuser    = s_axis_net.tuser;
    assign m_axis_host.tdest    = s_axis_net.tdest;
    assign s_axis_net.tready    = m_axis_host.tready;

endmodule : fpga_core
