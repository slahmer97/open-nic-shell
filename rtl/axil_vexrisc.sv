`resetall `timescale 1ns / 1ps `default_nettype none

//------------------------------------------------------------------------------
// axilvexrisc: wrap VexRiscv core, expose AXI4-Lite masters for imem and dmem
//------------------------------------------------------------------------------
module axilvexrisc #(
    parameter DATA_W = 32,
    parameter ADDR_W = 32,
    parameter STRB_W = (DATA_W / 8)
) (
    input wire clk,
    input wire reset,
    input wire timerInterrupt,
    input wire externalInterrupt,
    input wire softwareInterrupt,

    // imem AXI4-Lite master (read-only)
    taxi_axil_if.rd_mst imem_axil,

    // dmem AXI4-Lite master (read/write)
    taxi_axil_if.wr_mst dmem_axil_wr,
    taxi_axil_if.rd_mst dmem_axil_rd
);

  //----------------------------------------------------------------------
  // Internal wiring between VexRiscv and AXI4-Lite signals
  //----------------------------------------------------------------------
  // Instruction bus => AXI4-Lite read
  assign imem_axil.araddr       = iBus_cmd_payload_pc;
  assign imem_axil.arprot       = 3'b000;
  assign imem_axil.arvalid      = iBus_cmd_valid;
  assign iBus_cmd_ready         = imem_axil.arready;

  assign iBus_rsp_valid         = imem_axil.rvalid;
  assign iBus_rsp_payload_inst  = imem_axil.rdata;
  assign iBus_rsp_payload_error = (imem_axil.rresp != 2'b00);
  assign imem_axil.rready       = iBus_rsp_valid && iBus_cmd_ready;

  // Data bus => AXI4-Lite read/write
  // write
  assign dmem_axil_wr.awaddr    = dBus_cmd_payload_address;
  assign dmem_axil_wr.awprot    = 3'b000;
  assign dmem_axil_wr.awvalid   = dBus_cmd_valid & dBus_cmd_payload_wr;

  assign dmem_axil_wr.wdata     = dBus_cmd_payload_data;
  assign dmem_axil_wr.wstrb     = dBus_cmd_payload_mask;
  assign dmem_axil_wr.wvalid    = dBus_cmd_valid & dBus_cmd_payload_wr;

  assign dBus_cmd_ready         = dBus_cmd_payload_wr ? dmem_axil_wr.bready : dmem_axil_rd.rready;
  assign dmem_axil_wr.bready    = dBus_cmd_ready;

  // read
  assign dmem_axil_rd.araddr    = dBus_cmd_payload_address;
  assign dmem_axil_rd.arprot    = 3'b000;
  assign dmem_axil_rd.arvalid   = dBus_cmd_valid & ~dBus_cmd_payload_wr;

  assign dBus_rsp_data          = dmem_axil_rd.rdata;
  assign dBus_rsp_error         = (dmem_axil_rd.rresp != 2'b00);
  assign dBus_rsp_ready         = dmem_axil_rd.rvalid;
  assign dmem_axil_rd.rready    = dBus_rsp_ready;

  //----------------------------------------------------------------------
  // Instantiate the VexRiscv core
  //----------------------------------------------------------------------
  VexRiscv core (
      .iBus_cmd_valid        (imem_axil.arvalid),
      .iBus_cmd_ready        (imem_axil.arready),
      .iBus_cmd_payload_pc   (imem_axil.araddr),
      .iBus_rsp_valid        (imem_axil.rvalid),
      .iBus_rsp_payload_error(imem_axil.rresp != 2'b00),
      .iBus_rsp_payload_inst (imem_axil.rdata),
      .timerInterrupt        (timerInterrupt),
      .externalInterrupt     (externalInterrupt),
      .softwareInterrupt     (softwareInterrupt),

      .dBus_cmd_valid          (dBus_cmd_valid),
      .dBus_cmd_ready          (dBus_cmd_ready),
      .dBus_cmd_payload_wr     (dBus_cmd_payload_wr),
      .dBus_cmd_payload_mask   (dBus_cmd_payload_mask),
      .dBus_cmd_payload_address(dBus_cmd_payload_address),
      .dBus_cmd_payload_data   (dBus_cmd_payload_data),
      .dBus_cmd_payload_size   (dBus_cmd_payload_size),
      .dBus_rsp_ready          (dBus_rsp_ready),
      .dBus_rsp_error          (dBus_rsp_error),
      .dBus_rsp_data           (dBus_rsp_data),

      .clk  (clk),
      .reset(reset)
  );

endmodule
