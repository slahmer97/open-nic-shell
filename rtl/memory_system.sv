`resetall `timescale 1ns / 1ps `default_nettype none

module memory_system (
    input wire core_clk,
    input wire core_rst,

    taxi_axil_if.wr_slv s_axil_wr_imem_host,
    //    taxi_axil_if.rd_slv s_axil_rd_imem_host,

    taxi_axil_if.rd_slv s_axil_rd_imem_core,


    taxi_axil_if.wr_slv s_axil_wr_dmem_core,
    taxi_axil_if.rd_slv s_axil_rd_dmem_core,

    taxi_axil_if.wr_slv s_axil_wr_dmem_host,
    taxi_axil_if.rd_slv s_axil_rd_dmem_host

);


  // Single-port IMEM BRAM (writes from host, reads from core)

/*
  taxi_axil_ram #(
      .ADDR_W(16)
  ) imem_inst (
      .clk      (core_clk),
      .rst      (core_rst),
      .s_axil_wr(s_axil_wr_imem_host),
      .s_axil_rd(s_axil_rd_imem_core)
  );
*/

bram_1rw (
    .clk(core_clk),
    .rst(core_rst),
    .s_axil_wr(s_axil_wr_imem_host),
    .s_axil_rd(s_axil_rd_imem_core)
);




  ila_bus_write memsH_imem_wr (
      .clk   (core_clk),
      .probe0(s_axil_wr_imem_host.awvalid),  // core AW valid
      .probe1(s_axil_wr_imem_host.awaddr),   // core AW addr
      .probe2(s_axil_wr_imem_host.wvalid),   // core W valid
      .probe3(s_axil_wr_imem_host.wdata),     // core W data
      .probe4(s_axil_wr_imem_host.wstrb),
      .probe5(s_axil_wr_imem_host.bvalid),
      .probe6(s_axil_wr_imem_host.bready),
      .probe7(s_axil_wr_imem_host.bresp)
  );

  ila_bus_read memsC_imem_rd (
      .clk   (core_clk),
      .probe0(s_axil_rd_imem_core.arvalid),  // core AR valid
      .probe1(s_axil_rd_imem_core.araddr),   // core AR addr
      .probe2(s_axil_rd_imem_core.rvalid),   // core R valid
      .probe3(s_axil_rd_imem_core.rdata)     // core R data
  );


  /*
  taxi_axil_if dummy_imem_b ();
  
  taxi_axil_dp_ram #(
    .ADDR_W(16)
  ) imem_inst (
     .a_clk       (core_clk),
    .a_rst       (core_rst),
    .s_axil_wr_a (s_axil_wr_imem_host),
    .s_axil_rd_a (s_axil_rd_imem_host),
    
    .b_clk       (core_clk),
    .b_rst       (core_rst),
    .s_axil_wr_b (dummy_imem_b),
    .s_axil_rd_b (s_axil_rd_imem_core)
  );
  
  */


  // Dual-port DMEM (port A = core, port B = host)
  taxi_axil_dp_ram #(
      .ADDR_W(15)
  ) dmem_inst (
      .a_clk      (core_clk),
      .a_rst      (core_rst),
      .s_axil_wr_a(s_axil_wr_dmem_core),
      .s_axil_rd_a(s_axil_rd_dmem_core),
      .b_clk      (core_clk),
      .b_rst      (core_rst),
      .s_axil_wr_b(s_axil_wr_dmem_host),
      .s_axil_rd_b(s_axil_rd_dmem_host)
  );



  ila_bus_write memsC_dmem_wr (
      .clk   (core_clk),
      .probe0(s_axil_wr_dmem_core.awvalid),  // core AW valid
      .probe1(s_axil_wr_dmem_core.awaddr),   // core AW addr
      .probe2(s_axil_wr_dmem_core.wvalid),   // core W valid
      .probe3(s_axil_wr_dmem_core.wdata),     // core W data
      .probe4(s_axil_wr_dmem_core.wstrb),
      .probe5(s_axil_wr_dmem_core.bvalid),
      .probe6(s_axil_wr_dmem_core.bready),
      .probe7(s_axil_wr_dmem_core.bresp)
  );

  ila_bus_read memsC_dmem_rd (
      .clk   (core_clk),
      .probe0(s_axil_rd_dmem_core.arvalid),  // core AR valid
      .probe1(s_axil_rd_dmem_core.araddr),   // core AR addr
      .probe2(s_axil_rd_dmem_core.rvalid),   // core R valid
      .probe3(s_axil_rd_dmem_core.rdata)     // core R data
  );


  ila_bus_write memsH_dmem_wr (
      .clk   (core_clk),
      .probe0(s_axil_wr_dmem_host.awvalid),  // core AW valid
      .probe1(s_axil_wr_dmem_host.awaddr),   // core AW addr
      .probe2(s_axil_wr_dmem_host.wvalid),   // core W valid
      .probe3(s_axil_wr_dmem_host.wdata),     // core W data
      .probe4(s_axil_wr_dmem_host.wstrb),
      .probe5(s_axil_wr_dmem_host.bvalid),
      .probe6(s_axil_wr_dmem_host.bready),
      .probe7(s_axil_wr_dmem_host.bresp)
  );

  ila_bus_read memsH_dmem_rd (
      .clk   (core_clk),
      .probe0(s_axil_rd_dmem_host.arvalid),  // core AR valid
      .probe1(s_axil_rd_dmem_host.araddr),   // core AR addr
      .probe2(s_axil_rd_dmem_host.rvalid),   // core R valid
      .probe3(s_axil_rd_dmem_host.rdata)     // core R data
  );




endmodule


`resetall `default_nettype wire
