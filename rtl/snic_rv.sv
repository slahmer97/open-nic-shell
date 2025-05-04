
`resetall `timescale 1ns / 1ps `default_nettype none

module snic_rv (
    input wire core_clk,
    input wire core_rst,

    taxi_axil_if.wr_slv s_axil_wr_imem_host,
    taxi_axil_if.rd_slv s_axil_rd_imem_host,  // TODO remove later just for debuging


    taxi_axil_if.wr_slv s_axil_wr_dmem_host,
    taxi_axil_if.rd_slv s_axil_rd_dmem_host
);


  // ------------------------------------------------------------------------
  // Boot register: set/reset by writes to BOOT_ADDR
  // ------------------------------------------------------------------------
  // Define the boot intercept address (last word in IMEM space)
  localparam [31:0] IMEM_SIZE_BYTES = 32'h0001_0000;  // e.g. 64KB
  localparam [31:0] IMEM_BASE = 32'h0000_0000;
  localparam [31:0] BOOT_ADDR = IMEM_BASE + IMEM_SIZE_BYTES - 4;

  reg        boot;

  reg        aw_hs;
  reg [31:0] awaddr_lat;

  always @(posedge core_clk) begin
    if (core_rst) begin
      aw_hs      <= 1'b0;
      awaddr_lat <= 32'b0;
    end else begin
      // On AWVALID & AWREADY, latch the address and mark ?in-progress?
      if (s_axil_wr_imem_host.awvalid && s_axil_wr_imem_host.awready) begin
        aw_hs      <= 1'b1;
        awaddr_lat <= s_axil_wr_imem_host.awaddr;
      end  // Once we see the W handshake, clear aw_hs so we only handle one write per transaction
      else if (s_axil_wr_imem_host.wvalid && s_axil_wr_imem_host.wready) begin
        aw_hs <= 1'b0;
      end
    end
  end

  always @(posedge core_clk) begin
    if (core_rst) begin
      boot <= 1'b0;
    end else if (
    aw_hs &&
    s_axil_wr_imem_host.wvalid &&
    s_axil_wr_imem_host.wready &&
    (awaddr_lat == BOOT_ADDR)
  ) begin
      boot <= s_axil_wr_imem_host.wdata[0];
    end
  end


  // Stub-read FSM for debug
  reg rd_idle;
  always @(posedge core_clk) begin
    if (core_rst) begin
      rd_idle <= 1;
    end else begin
      if (rd_idle) begin
        if (s_axil_rd_imem_host.arvalid) rd_idle <= 0;
      end else if (s_axil_rd_imem_host.rvalid && s_axil_rd_imem_host.rready) begin
        rd_idle <= 1;
      end
    end
  end

  assign s_axil_rd_imem_host.arready = rd_idle;
  assign s_axil_rd_imem_host.rvalid  = ~rd_idle;
  assign s_axil_rd_imem_host.rresp   = 2'b00;
  assign s_axil_rd_imem_host.rdata   = 32'hDEAD_BEEF;


  ila_boot ila_boot_i (
      .clk   (core_clk),
      .probe0(boot)
  );


  ila_boot ila_rst (
      .clk   (core_clk),
      .probe0(core_rst)
  );

  taxi_axil_if imem_axil ();
  taxi_axil_if internal_io_axil ();
  taxi_axil_if external_io_axil ();
  taxi_axil_if dmem_axil ();
  taxi_axil_if pmem_axil ();


  // TIMER
  wire timerInterrupt = 1'b0;  // TODO enabe the timer later
  /*
  snic_timer timer_inst (
      .clk          (core_clk),
      .rst          (core_rst),
      .timeout_pulse(timerInterrupt)
  );
*/

  wire externalInterrupt = 1'b0;
  wire softwareInterrupt = 1'b0;


  wire local_reset = core_rst || !boot;

  vexrv_wrapper vexrv_wrapper_inst (
      .core_clk(core_clk),
      .core_rst(local_reset),

      .timerInterrupt   (timerInterrupt),
      .externalInterrupt(externalInterrupt),
      .softwareInterrupt(softwareInterrupt),

      .m_axil_rd_imem(imem_axil),


      .dmem_axil_wr(dmem_axil),
      .dmem_axil_rd(dmem_axil),

      .pmem_axil_wr(pmem_axil),
      .pmem_axil_rd(pmem_axil),

      .iiomem_axil_wr(internal_io_axil),
      .iiomem_axil_rd(internal_io_axil),

      .eiomem_axil_wr(external_io_axil),
      .eiomem_axil_rd(external_io_axil)

  );


  memory_system mem_system_inst (
      .core_clk(core_clk),
      .core_rst(core_rst),

      .s_axil_wr_imem_host(s_axil_wr_imem_host),
      //.s_axil_rd_imem_host(s_axil_rd_imem_host),

      .s_axil_rd_imem_core(imem_axil),

      .s_axil_wr_dmem_core(dmem_axil),
      .s_axil_rd_dmem_core(dmem_axil),

      .s_axil_wr_dmem_host(s_axil_wr_dmem_host),
      .s_axil_rd_dmem_host(s_axil_rd_dmem_host)

  );

endmodule

`default_nettype wire
