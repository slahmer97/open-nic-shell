`timescale 1ns/1ps
module fpga #(
  parameter [31:0] BUILD_TIMESTAMP = 32'h01010000,
  parameter int    MIN_PKT_LEN     = 64,
  parameter int    MAX_PKT_LEN     = 1518,
  parameter int    USE_PHYS_FUNC   = 1,
  parameter int    NUM_PHYS_FUNC   = 1,
  parameter int    NUM_QUEUE       = 512,
  parameter int    NUM_QDMA        = 1,
  parameter int    NUM_CMAC_PORT   = 1
) (

// Fix the CATTRIP issue for AU50

  output                         hbm_cattrip,
  input                    [1:0] satellite_gpio,


  input                          satellite_uart_0_rxd,
  output                         satellite_uart_0_txd,

  input     [16*NUM_QDMA-1:0] pcie_rxp,
  input     [16*NUM_QDMA-1:0] pcie_rxn,
  output    [16*NUM_QDMA-1:0] pcie_txp,
  output    [16*NUM_QDMA-1:0] pcie_txn,

  input        [NUM_QDMA-1:0] pcie_refclk_p,
  input        [NUM_QDMA-1:0] pcie_refclk_n,
  input        [NUM_QDMA-1:0] pcie_rstn,

  input    [4*NUM_CMAC_PORT-1:0] qsfp_rxp,
  input    [4*NUM_CMAC_PORT-1:0] qsfp_rxn,
  output   [4*NUM_CMAC_PORT-1:0] qsfp_txp,
  output   [3:0] qsfp_txn,


  input       qsfp_refclk_p,
  input       qsfp_refclk_n

);




  wire [16*NUM_QDMA-1:0] qdma_pcie_rxp;
  wire [16*NUM_QDMA-1:0] qdma_pcie_rxn;
  wire [16*NUM_QDMA-1:0] qdma_pcie_txp;
  wire [16*NUM_QDMA-1:0] qdma_pcie_txn;

  wire [NUM_QDMA-1:0] powerup_rstn;
  wire [NUM_QDMA-1:0] pcie_user_lnk_up;
  wire [NUM_QDMA-1:0] pcie_phy_ready;
  wire sys_cfg_powerup_rstn;

  // BAR2-mapped master AXI-Lite feeding into system configuration block
  wire     [NUM_QDMA-1:0] axil_pcie_awvalid;
  wire  [32*NUM_QDMA-1:0] axil_pcie_awaddr;
  wire     [NUM_QDMA-1:0] axil_pcie_awready;
  wire     [NUM_QDMA-1:0] axil_pcie_wvalid;
  wire  [32*NUM_QDMA-1:0] axil_pcie_wdata;
  wire     [NUM_QDMA-1:0] axil_pcie_wready;
  wire     [NUM_QDMA-1:0] axil_pcie_bvalid;
  wire   [2*NUM_QDMA-1:0] axil_pcie_bresp;
  wire     [NUM_QDMA-1:0] axil_pcie_bready;
  wire     [NUM_QDMA-1:0] axil_pcie_arvalid;
  wire  [32*NUM_QDMA-1:0] axil_pcie_araddr;
  wire     [NUM_QDMA-1:0] axil_pcie_arready;
  wire     [NUM_QDMA-1:0] axil_pcie_rvalid;
  wire  [32*NUM_QDMA-1:0] axil_pcie_rdata;
  wire   [2*NUM_QDMA-1:0] axil_pcie_rresp;
  wire     [NUM_QDMA-1:0] axil_pcie_rready;

  wire     [NUM_QDMA-1:0] pcie_rstn_int;
    IBUF pcie_rstn_ibuf_inst (.I(pcie_rstn[0]), .O(pcie_rstn_int[0]));

// Fix the CATTRIP issue for AU280, AU50, AU55C and AU55N custom flow
//
// This pin must be tied to 0; otherwise the board might be unrecoverable
// after programming
// Connect QSFP control lines through to the CMS for AU200 and AU250

  OBUF hbm_cattrip_obuf_inst (.I(1'b0), .O(hbm_cattrip));




  wire         axil_qdma_awvalid;
  wire [31:0]  axil_qdma_awaddr;
  wire         axil_qdma_awready;
  wire         axil_qdma_wvalid;
  wire [31:0]  axil_qdma_wdata;
  wire         axil_qdma_wready;
  wire         axil_qdma_bvalid;
  wire  [1:0]  axil_qdma_bresp;
  wire         axil_qdma_bready;
  wire         axil_qdma_arvalid;
  wire [31:0]  axil_qdma_araddr;
  wire         axil_qdma_arready;
  wire         axil_qdma_rvalid;
  wire [31:0]  axil_qdma_rdata;
  wire  [1:0]  axil_qdma_rresp;
  wire         axil_qdma_rready;

  wire         axil_adap_awvalid;
  wire [31:0]  axil_adap_awaddr;
  wire         axil_adap_awready;
  wire         axil_adap_wvalid;
  wire [31:0]  axil_adap_wdata;
  wire         axil_adap_wready;
  wire         axil_adap_bvalid;
  wire  [1:0]  axil_adap_bresp;
  wire         axil_adap_bready;
  wire         axil_adap_arvalid;
  wire [31:0]  axil_adap_araddr;
  wire         axil_adap_arready;
  wire         axil_adap_rvalid;
  wire [31:0]  axil_adap_rdata;
  wire  [1:0]  axil_adap_rresp;
  wire         axil_adap_rready;

  wire         axil_cmac_awvalid;
  wire [31:0]  axil_cmac_awaddr;
  wire         axil_cmac_awready;
  wire         axil_cmac_wvalid;
  wire [31:0]  axil_cmac_wdata;
  wire         axil_cmac_wready;
  wire         axil_cmac_bvalid;
  wire  [1:0]  axil_cmac_bresp;
  wire         axil_cmac_bready;
  wire         axil_cmac_arvalid;
  wire [31:0]  axil_cmac_araddr;
  wire         axil_cmac_arready;
  wire         axil_cmac_rvalid;
  wire [31:0]  axil_cmac_rdata;
  wire  [1:0]  axil_cmac_rresp;
  wire         axil_cmac_rready;

  wire                         axil_core_awvalid;
  wire                  [31:0] axil_core_awaddr;
  wire                         axil_core_awready;
  wire                         axil_core_wvalid;
  wire                  [31:0] axil_core_wdata;
  wire                         axil_core_wready;
  wire                         axil_core_bvalid;
  wire                   [1:0] axil_core_bresp;
  wire                         axil_core_bready;
  wire                         axil_core_arvalid;
  wire                  [31:0] axil_core_araddr;
  wire                         axil_core_arready;
  wire                         axil_core_rvalid;
  wire                  [31:0] axil_core_rdata;
  wire                   [1:0] axil_core_rresp;
  wire                         axil_core_rready;



  // QDMA subsystem interfaces to the box running at 250MHz
  wire [NUM_PHYS_FUNC-1:0]        axis_qdma_h2c_tvalid;
  wire [512*NUM_PHYS_FUNC-1:0]    axis_qdma_h2c_tdata;
  wire [64*NUM_PHYS_FUNC-1:0]     axis_qdma_h2c_tkeep;
  wire [NUM_PHYS_FUNC-1:0]        axis_qdma_h2c_tlast;
  wire [16*NUM_PHYS_FUNC-1:0]     axis_qdma_h2c_tuser_size;
  wire [16*NUM_PHYS_FUNC-1:0]     axis_qdma_h2c_tuser_src;
  wire [16*NUM_PHYS_FUNC-1:0]     axis_qdma_h2c_tuser_dst;
  wire [NUM_PHYS_FUNC-1:0]        axis_qdma_h2c_tready;

  wire [NUM_PHYS_FUNC-1:0]      axis_qdma_c2h_tvalid;
  wire [512*NUM_PHYS_FUNC-1:0]  axis_qdma_c2h_tdata;
  wire [64*NUM_PHYS_FUNC-1:0]   axis_qdma_c2h_tkeep;
  wire [NUM_PHYS_FUNC-1:0]      axis_qdma_c2h_tlast;
  wire [16*NUM_PHYS_FUNC-1:0]   axis_qdma_c2h_tuser_size;
  wire [16*NUM_PHYS_FUNC-1:0]   axis_qdma_c2h_tuser_src;
  wire [16*NUM_PHYS_FUNC-1:0]   axis_qdma_c2h_tuser_dst;
  wire [NUM_PHYS_FUNC-1:0]      axis_qdma_c2h_tready;
  
  
  // Packet adapter interfaces to the box running at 250MHz
  wire        axis_adap_tx_250mhz_tvalid;
  wire [511:0] axis_adap_tx_250mhz_tdata;
  wire [63:0]  axis_adap_tx_250mhz_tkeep;
  wire        axis_adap_tx_250mhz_tlast;
  wire [15:0]  axis_adap_tx_250mhz_tuser_size;
  wire [15:0]  axis_adap_tx_250mhz_tuser_src;
  wire [15:0]  axis_adap_tx_250mhz_tuser_dst;
  wire        axis_adap_tx_250mhz_tready;

  wire        axis_adap_rx_250mhz_tvalid;
  wire [511:0] axis_adap_rx_250mhz_tdata;
  wire [63:0]  axis_adap_rx_250mhz_tkeep;
  wire        axis_adap_rx_250mhz_tlast;
  wire [15:0]  axis_adap_rx_250mhz_tuser_size;
  wire [15:0]  axis_adap_rx_250mhz_tuser_src;
  wire [15:0]  axis_adap_rx_250mhz_tuser_dst;
  wire        axis_adap_rx_250mhz_tready;

  // Packet adapter interfaces to the box running at 322MHz
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tlast;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tuser_err;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_tx_322mhz_tready;

  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tvalid;
  wire [512*NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tdata;
  wire  [64*NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tkeep;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tlast;
  wire     [NUM_CMAC_PORT-1:0] axis_adap_rx_322mhz_tuser_err;

  // CMAC subsystem interfaces to the box running at 322MHz
  wire        axis_cmac_tx_tvalid;
  wire [511:0] axis_cmac_tx_tdata;
  wire [63:0]  axis_cmac_tx_tkeep;
  wire        axis_cmac_tx_tlast;
  wire        axis_cmac_tx_tuser_err;
  wire        axis_cmac_tx_tready;

  wire        axis_cmac_rx_tvalid;
  wire [511:0] axis_cmac_rx_tdata;
  wire [63:0]  axis_cmac_rx_tkeep;
  wire        axis_cmac_rx_tlast;
  wire        axis_cmac_rx_tuser_err;

  wire [31:0] shell_rstn;
  wire [31:0] shell_rst_done;
  wire        qdma_rstn;
  wire        qdma_rst_done;
  wire        adap_rstn;
  wire        adap_rst_done;
  wire        cmac_rstn;
  wire        cmac_rst_done;

  wire [31:0] user_rstn;
  wire [31:0] user_rst_done;
  wire [15:0] user_250mhz_rstn;
  wire [15:0] user_250mhz_rst_done;
  wire [ 7:0] user_322mhz_rstn;
  wire [ 7:0] user_322mhz_rst_done;
  wire        box_250mhz_rstn;
  wire        box_250mhz_rst_done;
  wire        box_322mhz_rstn;
  wire        box_322mhz_rst_done;

  wire        axil_aclk;
  wire        axis_aclk;
  wire        ref_clk_100mhz;
  wire        cmac_clk;

  // Unused reset pairs must have their "reset_done" tied to 1

 
  // First 4 bits: QDMA subsystem
  assign qdma_rstn                  = shell_rstn[0];
  assign shell_rst_done[0]          = qdma_rst_done;
  assign shell_rst_done[3:1]        = 3'b111;

  // Next 4 bits: CMAC port 0 (bit 4) and its adapter (bit 5)
  assign {adap_rstn, cmac_rstn}     = {shell_rstn[5], shell_rstn[4]};
  assign shell_rst_done[7:4]        = {2'b11, adap_rst_done, cmac_rst_done};

  // Remaining shell_rst_done bits [31:8] unused ? all ones
  assign shell_rst_done[31:8]       = {24{1'b1}};
  
  

  // The box running at 250MHz takes 16+1 user reset pairs, with the extra one
  // used by the box itself.  Similarly, the box running at 322MHz takes 8+1
  // pairs.  The mapping is as follows.
  //
  // | 31    | 30    | 29 ... 24 | 23 ... 16 | 15 ... 0 |
  // ----------------------------------------------------
  // | b@250 | b@322 | Reserved  | user@322  | user@250 |
  // User resets (250 MHz @ bits [15:0], 322 MHz @ bits [23:16])
  assign user_250mhz_rstn           = user_rstn[15:0];
  assign user_rst_done[15:0]        = user_250mhz_rst_done;
  assign user_322mhz_rstn           = user_rstn[23:16];
  assign user_rst_done[23:16]       = user_322mhz_rst_done;

  // Box resets (250 MHz @ bit 31, 322 MHz @ bit 30)
  assign box_250mhz_rstn            = user_rstn[31];
  assign user_rst_done[31]          = box_250mhz_rst_done;
  assign box_322mhz_rstn            = user_rstn[30];
  assign user_rst_done[30]          = box_322mhz_rst_done;

  // Unused pairs must have their rst_done signals tied to 1
  assign user_rst_done[29:24] = {6{1'b1}};


  assign sys_cfg_powerup_rstn = | powerup_rstn; 


  assign qdma_pcie_rxp       = pcie_rxp;
  assign qdma_pcie_rxn       = pcie_rxn;
  assign qdma_pcie_txp       = pcie_txp;
  assign qdma_pcie_txn       = pcie_txn;


  system_config #(
    .BUILD_TIMESTAMP (BUILD_TIMESTAMP),
    .NUM_QDMA        (NUM_QDMA),
    .NUM_CMAC_PORT   (NUM_CMAC_PORT)
  ) system_config_inst (
  
    .s_axil_awvalid      (axil_pcie_awvalid),
    .s_axil_awaddr       (axil_pcie_awaddr),
    .s_axil_awready      (axil_pcie_awready),
    .s_axil_wvalid       (axil_pcie_wvalid),
    .s_axil_wdata        (axil_pcie_wdata),
    .s_axil_wready       (axil_pcie_wready),
    .s_axil_bvalid       (axil_pcie_bvalid),
    .s_axil_bresp        (axil_pcie_bresp),
    .s_axil_bready       (axil_pcie_bready),
    .s_axil_arvalid      (axil_pcie_arvalid),
    .s_axil_araddr       (axil_pcie_araddr),
    .s_axil_arready      (axil_pcie_arready),
    .s_axil_rvalid       (axil_pcie_rvalid),
    .s_axil_rdata        (axil_pcie_rdata),
    .s_axil_rresp        (axil_pcie_rresp),
    .s_axil_rready       (axil_pcie_rready),


    .m_axil_qdma_awvalid (axil_qdma_awvalid),
    .m_axil_qdma_awaddr  (axil_qdma_awaddr),
    .m_axil_qdma_awready (axil_qdma_awready),
    .m_axil_qdma_wvalid  (axil_qdma_wvalid),
    .m_axil_qdma_wdata   (axil_qdma_wdata),
    .m_axil_qdma_wready  (axil_qdma_wready),
    .m_axil_qdma_bvalid  (axil_qdma_bvalid),
    .m_axil_qdma_bresp   (axil_qdma_bresp),
    .m_axil_qdma_bready  (axil_qdma_bready),
    .m_axil_qdma_arvalid (axil_qdma_arvalid),
    .m_axil_qdma_araddr  (axil_qdma_araddr),
    .m_axil_qdma_arready (axil_qdma_arready),
    .m_axil_qdma_rvalid  (axil_qdma_rvalid),
    .m_axil_qdma_rdata   (axil_qdma_rdata),
    .m_axil_qdma_rresp   (axil_qdma_rresp),
    .m_axil_qdma_rready  (axil_qdma_rready),

    .m_axil_adap_awvalid (axil_adap_awvalid),
    .m_axil_adap_awaddr  (axil_adap_awaddr),
    .m_axil_adap_awready (axil_adap_awready),
    .m_axil_adap_wvalid  (axil_adap_wvalid),
    .m_axil_adap_wdata   (axil_adap_wdata),
    .m_axil_adap_wready  (axil_adap_wready),
    .m_axil_adap_bvalid  (axil_adap_bvalid),
    .m_axil_adap_bresp   (axil_adap_bresp),
    .m_axil_adap_bready  (axil_adap_bready),
    .m_axil_adap_arvalid (axil_adap_arvalid),
    .m_axil_adap_araddr  (axil_adap_araddr),
    .m_axil_adap_arready (axil_adap_arready),
    .m_axil_adap_rvalid  (axil_adap_rvalid),
    .m_axil_adap_rdata   (axil_adap_rdata),
    .m_axil_adap_rresp   (axil_adap_rresp),
    .m_axil_adap_rready  (axil_adap_rready),

    .m_axil_cmac_awvalid (axil_cmac_awvalid),
    .m_axil_cmac_awaddr  (axil_cmac_awaddr),
    .m_axil_cmac_awready (axil_cmac_awready),
    .m_axil_cmac_wvalid  (axil_cmac_wvalid),
    .m_axil_cmac_wdata   (axil_cmac_wdata),
    .m_axil_cmac_wready  (axil_cmac_wready),
    .m_axil_cmac_bvalid  (axil_cmac_bvalid),
    .m_axil_cmac_bresp   (axil_cmac_bresp),
    .m_axil_cmac_bready  (axil_cmac_bready),
    .m_axil_cmac_arvalid (axil_cmac_arvalid),
    .m_axil_cmac_araddr  (axil_cmac_araddr),
    .m_axil_cmac_arready (axil_cmac_arready),
    .m_axil_cmac_rvalid  (axil_cmac_rvalid),
    .m_axil_cmac_rdata   (axil_cmac_rdata),
    .m_axil_cmac_rresp   (axil_cmac_rresp),
    .m_axil_cmac_rready  (axil_cmac_rready),

     .m_axil_core_awvalid(axil_core_awvalid),
     .m_axil_core_awaddr(axil_core_awaddr),
     .m_axil_core_awready(axil_core_awready),
     .m_axil_core_wvalid(axil_core_wvalid),
     .m_axil_core_wdata(axil_core_wdata),
     .m_axil_core_wready(axil_core_wready),
     .m_axil_core_bvalid(axil_core_bvalid),
     .m_axil_core_bresp(axil_core_bresp),
     .m_axil_core_bready(axil_core_bready),
     .m_axil_core_arvalid(axil_core_arvalid),
     .m_axil_core_araddr(axil_core_araddr),
     .m_axil_core_arready(axil_core_arready),
     .m_axil_core_rvalid(axil_core_rvalid),
     .m_axil_core_rdata(axil_core_rdata),
     .m_axil_core_rresp(axil_core_rresp),
     .m_axil_core_rready(axil_core_rready),
    
    
    .shell_rstn          (shell_rstn),
    .shell_rst_done      (shell_rst_done),
    .user_rstn           (user_rstn),
    .user_rst_done       (user_rst_done),

    .satellite_uart_0_rxd (satellite_uart_0_rxd),
    .satellite_uart_0_txd (satellite_uart_0_txd),
    .satellite_gpio_0     (satellite_gpio),


    .hbm_temp_1_0            (7'd0),
    .hbm_temp_2_0            (7'd0),
    .interrupt_hbm_cattrip_0 (1'b0),


    .aclk                (axil_aclk),
    .aresetn             (sys_cfg_powerup_rstn)
  );

    qdma_subsystem #(
      .QDMA_ID       (0),
      .MIN_PKT_LEN   (MIN_PKT_LEN),
      .MAX_PKT_LEN   (MAX_PKT_LEN),
      .USE_PHYS_FUNC (USE_PHYS_FUNC),
      .NUM_PHYS_FUNC (NUM_PHYS_FUNC),
      .NUM_QUEUE     (NUM_QUEUE)
    ) qdma_subsystem_inst (
      .s_axil_awvalid                       (axil_qdma_awvalid),
      .s_axil_awaddr                        (axil_qdma_awaddr),
      .s_axil_awready                       (axil_qdma_awready),
      .s_axil_wvalid                        (axil_qdma_wvalid),
      .s_axil_wdata                         (axil_qdma_wdata),
      .s_axil_wready                        (axil_qdma_wready),
      .s_axil_bvalid                        (axil_qdma_bvalid),
      .s_axil_bresp                         (axil_qdma_bresp),
      .s_axil_bready                        (axil_qdma_bready),
      .s_axil_arvalid                       (axil_qdma_arvalid),
      .s_axil_araddr                        (axil_qdma_araddr),
      .s_axil_arready                       (axil_qdma_arready),
      .s_axil_rvalid                        (axil_qdma_rvalid),
      .s_axil_rdata                         (axil_qdma_rdata),
      .s_axil_rresp                         (axil_qdma_rresp),
      .s_axil_rready                        (axil_qdma_rready),

      .m_axis_h2c_tvalid                    (axis_qdma_h2c_tvalid),
      .m_axis_h2c_tdata                     (axis_qdma_h2c_tdata),
      .m_axis_h2c_tkeep                     (axis_qdma_h2c_tkeep),
      .m_axis_h2c_tlast                     (axis_qdma_h2c_tlast),
      .m_axis_h2c_tuser_size                (axis_qdma_h2c_tuser_size),
      .m_axis_h2c_tuser_src                 (axis_qdma_h2c_tuser_src),
      .m_axis_h2c_tuser_dst                 (axis_qdma_h2c_tuser_dst),
      .m_axis_h2c_tready                    (axis_qdma_h2c_tready),

      .s_axis_c2h_tvalid                    (axis_qdma_c2h_tvalid),
      .s_axis_c2h_tdata                     (axis_qdma_c2h_tdata),
      .s_axis_c2h_tkeep                     (axis_qdma_c2h_tkeep),
      .s_axis_c2h_tlast                     (axis_qdma_c2h_tlast),
      .s_axis_c2h_tuser_size                (axis_qdma_c2h_tuser_size),
      .s_axis_c2h_tuser_src                 (axis_qdma_c2h_tuser_src),
      .s_axis_c2h_tuser_dst                 (axis_qdma_c2h_tuser_dst),
      .s_axis_c2h_tready                    (axis_qdma_c2h_tready),

      .pcie_rxp                             (qdma_pcie_rxp),
      .pcie_rxn                             (qdma_pcie_rxn),
      .pcie_txp                             (qdma_pcie_txp),
      .pcie_txn                             (qdma_pcie_txn),
    
      .m_axil_pcie_awvalid                  (axil_pcie_awvalid),
      .m_axil_pcie_awaddr                   (axil_pcie_awaddr),
      .m_axil_pcie_awready                  (axil_pcie_awready),
      .m_axil_pcie_wvalid                   (axil_pcie_wvalid),
      .m_axil_pcie_wdata                    (axil_pcie_wdata),
      .m_axil_pcie_wready                   (axil_pcie_wready),
      .m_axil_pcie_bvalid                   (axil_pcie_bvalid),
      .m_axil_pcie_bresp                    (axil_pcie_bresp),
      .m_axil_pcie_bready                   (axil_pcie_bready),
      .m_axil_pcie_arvalid                  (axil_pcie_arvalid),
      .m_axil_pcie_araddr                   (axil_pcie_araddr),
      .m_axil_pcie_arready                  (axil_pcie_arready),
      .m_axil_pcie_rvalid                   (axil_pcie_rvalid),
      .m_axil_pcie_rdata                    (axil_pcie_rdata),
      .m_axil_pcie_rresp                    (axil_pcie_rresp),
      .m_axil_pcie_rready                   (axil_pcie_rready),

      .pcie_refclk_p                        (pcie_refclk_p),
      .pcie_refclk_n                        (pcie_refclk_n),
      .pcie_rstn                            (pcie_rstn_int),
      .user_lnk_up                          (pcie_user_lnk_up),
      .phy_ready                            (pcie_phy_ready),
      .powerup_rstn                         (powerup_rstn),
  

      .mod_rstn                             (qdma_rstn),
      .mod_rst_done                         (qdma_rst_done),

      .axil_cfg_aclk                        (axil_aclk),
      .axil_aclk                            (axil_aclk),

   
      .ref_clk_100mhz                       (ref_clk_100mhz),
   
      .axis_master_aclk                     (axis_aclk),
      .axis_aclk                            (axis_aclk)
    );


    packet_adapter #(
      .CMAC_ID     (0),
      .MIN_PKT_LEN (MIN_PKT_LEN),
      .MAX_PKT_LEN (MAX_PKT_LEN)
    ) packet_adapter_inst (
      .s_axil_awvalid       (axil_adap_awvalid),
      .s_axil_awaddr        (axil_adap_awaddr),
      .s_axil_awready       (axil_adap_awready),
      .s_axil_wvalid        (axil_adap_wvalid),
      .s_axil_wdata         (axil_adap_wdata),
      .s_axil_wready        (axil_adap_wready),
      .s_axil_bvalid        (axil_adap_bvalid),
      .s_axil_bresp         (axil_adap_bresp),
      .s_axil_bready        (axil_adap_bready),
      .s_axil_arvalid       (axil_adap_arvalid),
      .s_axil_araddr        (axil_adap_araddr),
      .s_axil_arready       (axil_adap_arready),
      .s_axil_rvalid        (axil_adap_rvalid),
      .s_axil_rdata         (axil_adap_rdata),
      .s_axil_rresp         (axil_adap_rresp),
      .s_axil_rready        (axil_adap_rready),

      .s_axis_tx_tvalid     (axis_adap_tx_250mhz_tvalid),
      .s_axis_tx_tdata      (axis_adap_tx_250mhz_tdata),
      .s_axis_tx_tkeep      (axis_adap_tx_250mhz_tkeep),
      .s_axis_tx_tlast      (axis_adap_tx_250mhz_tlast),
      .s_axis_tx_tuser_size (axis_adap_tx_250mhz_tuser_size),
      .s_axis_tx_tuser_src  (axis_adap_tx_250mhz_tuser_src),
      .s_axis_tx_tuser_dst  (axis_adap_tx_250mhz_tuser_dst),
      .s_axis_tx_tready     (axis_adap_tx_250mhz_tready),

      .m_axis_rx_tvalid     (axis_adap_rx_250mhz_tvalid),
      .m_axis_rx_tdata      (axis_adap_rx_250mhz_tdata),
      .m_axis_rx_tkeep      (axis_adap_rx_250mhz_tkeep),
      .m_axis_rx_tlast      (axis_adap_rx_250mhz_tlast),
      .m_axis_rx_tuser_size (axis_adap_rx_250mhz_tuser_size),
      .m_axis_rx_tuser_src  (axis_adap_rx_250mhz_tuser_src),
      .m_axis_rx_tuser_dst  (axis_adap_rx_250mhz_tuser_dst),
      .m_axis_rx_tready     (axis_adap_rx_250mhz_tready),


        .m_axis_tx_tvalid           (axis_cmac_tx_tvalid),
        .m_axis_tx_tdata            (axis_cmac_tx_tdata),
        .m_axis_tx_tkeep            (axis_cmac_tx_tkeep),
        .m_axis_tx_tlast            (axis_cmac_tx_tlast),
        .m_axis_tx_tuser_err        (axis_cmac_tx_tuser_err),
        .m_axis_tx_tready           (axis_cmac_tx_tready),
    
        .s_axis_rx_tvalid           (axis_cmac_rx_tvalid),
        .s_axis_rx_tdata            (axis_cmac_rx_tdata),
        .s_axis_rx_tkeep            (axis_cmac_rx_tkeep),
        .s_axis_rx_tlast            (axis_cmac_rx_tlast),
        .s_axis_rx_tuser_err        (axis_cmac_rx_tuser_err),
    

      .mod_rstn             (adap_rstn),
      .mod_rst_done         (adap_rst_done),

      .axil_aclk            (axil_aclk),
      .axis_aclk            (axis_aclk),
      .cmac_clk             (cmac_clk)
    );

    cmac_subsystem #(
      .CMAC_ID     (0),
      .MIN_PKT_LEN (MIN_PKT_LEN),
      .MAX_PKT_LEN (MAX_PKT_LEN)
    ) cmac_subsystem_inst (
      .s_axil_awvalid               (axil_cmac_awvalid),
      .s_axil_awaddr                (axil_cmac_awaddr),
      .s_axil_awready               (axil_cmac_awready),
      .s_axil_wvalid                (axil_cmac_wvalid),
      .s_axil_wdata                 (axil_cmac_wdata),
      .s_axil_wready                (axil_cmac_wready),
      .s_axil_bvalid                (axil_cmac_bvalid),
      .s_axil_bresp                 (axil_cmac_bresp),
      .s_axil_bready                (axil_cmac_bready),
      .s_axil_arvalid               (axil_cmac_arvalid),
      .s_axil_araddr                (axil_cmac_araddr),
      .s_axil_arready               (axil_cmac_arready),
      .s_axil_rvalid                (axil_cmac_rvalid),
      .s_axil_rdata                 (axil_cmac_rdata),
      .s_axil_rresp                 (axil_cmac_rresp),
      .s_axil_rready                (axil_cmac_rready),

      .s_axis_cmac_tx_tvalid        (axis_cmac_tx_tvalid),
      .s_axis_cmac_tx_tdata         (axis_cmac_tx_tdata),
      .s_axis_cmac_tx_tkeep         (axis_cmac_tx_tkeep),
      .s_axis_cmac_tx_tlast         (axis_cmac_tx_tlast),
      .s_axis_cmac_tx_tuser_err     (axis_cmac_tx_tuser_err),
      .s_axis_cmac_tx_tready        (axis_cmac_tx_tready),

      .m_axis_cmac_rx_tvalid        (axis_cmac_rx_tvalid),
      .m_axis_cmac_rx_tdata         (axis_cmac_rx_tdata),
      .m_axis_cmac_rx_tkeep         (axis_cmac_rx_tkeep),
      .m_axis_cmac_rx_tlast         (axis_cmac_rx_tlast),
      .m_axis_cmac_rx_tuser_err     (axis_cmac_rx_tuser_err),

      .gt_rxp                       (qsfp_rxp),
      .gt_rxn                       (qsfp_rxn),
      .gt_txp                       (qsfp_txp),
      .gt_txn                       (qsfp_txn),
      .gt_refclk_p                  (qsfp_refclk_p),
      .gt_refclk_n                  (qsfp_refclk_n),


      .cmac_clk                     (cmac_clk),


      .mod_rstn                     (cmac_rstn),
      .mod_rst_done                 (cmac_rst_done),
      .axil_aclk                    (axil_aclk)
    );


  fpga_core #(
    .MIN_PKT_LEN   (MIN_PKT_LEN),
    .MAX_PKT_LEN   (MAX_PKT_LEN),
    .USE_PHYS_FUNC (USE_PHYS_FUNC),
    .NUM_PHYS_FUNC (NUM_PHYS_FUNC),
    .NUM_QDMA      (NUM_QDMA),
    .NUM_CMAC_PORT (NUM_CMAC_PORT)
  ) fpga_core (
    .s_axil_awvalid                   (axil_core_awvalid),
    .s_axil_awaddr                    (axil_core_awaddr),
    .s_axil_awready                   (axil_core_awready),
    .s_axil_wvalid                    (axil_core_wvalid),
    .s_axil_wdata                     (axil_core_wdata),
    .s_axil_wready                    (axil_core_wready),
    .s_axil_bvalid                    (axil_core_bvalid),
    .s_axil_bresp                     (axil_core_bresp),
    .s_axil_bready                    (axil_core_bready),
    .s_axil_arvalid                   (axil_core_arvalid),
    .s_axil_araddr                    (axil_core_araddr),
    .s_axil_arready                   (axil_core_arready),
    .s_axil_rvalid                    (axil_core_rvalid),
    .s_axil_rdata                     (axil_core_rdata),
    .s_axil_rresp                     (axil_core_rresp),
    .s_axil_rready                    (axil_core_rready),

    .s_axis_qdma_h2c_tvalid           (axis_qdma_h2c_tvalid),
    .s_axis_qdma_h2c_tdata            (axis_qdma_h2c_tdata),
    .s_axis_qdma_h2c_tkeep            (axis_qdma_h2c_tkeep),
    .s_axis_qdma_h2c_tlast            (axis_qdma_h2c_tlast),
    .s_axis_qdma_h2c_tuser_size       (axis_qdma_h2c_tuser_size),
    .s_axis_qdma_h2c_tuser_src        (axis_qdma_h2c_tuser_src),
    .s_axis_qdma_h2c_tuser_dst        (axis_qdma_h2c_tuser_dst),
    .s_axis_qdma_h2c_tready           (axis_qdma_h2c_tready),

    .m_axis_qdma_c2h_tvalid           (axis_qdma_c2h_tvalid),
    .m_axis_qdma_c2h_tdata            (axis_qdma_c2h_tdata),
    .m_axis_qdma_c2h_tkeep            (axis_qdma_c2h_tkeep),
    .m_axis_qdma_c2h_tlast            (axis_qdma_c2h_tlast),
    .m_axis_qdma_c2h_tuser_size       (axis_qdma_c2h_tuser_size),
    .m_axis_qdma_c2h_tuser_src        (axis_qdma_c2h_tuser_src),
    .m_axis_qdma_c2h_tuser_dst        (axis_qdma_c2h_tuser_dst),
    .m_axis_qdma_c2h_tready           (axis_qdma_c2h_tready),

    .m_axis_adap_tx_250mhz_tvalid     (axis_adap_tx_250mhz_tvalid),
    .m_axis_adap_tx_250mhz_tdata      (axis_adap_tx_250mhz_tdata),
    .m_axis_adap_tx_250mhz_tkeep      (axis_adap_tx_250mhz_tkeep),
    .m_axis_adap_tx_250mhz_tlast      (axis_adap_tx_250mhz_tlast),
    .m_axis_adap_tx_250mhz_tuser_size (axis_adap_tx_250mhz_tuser_size),
    .m_axis_adap_tx_250mhz_tuser_src  (axis_adap_tx_250mhz_tuser_src),
    .m_axis_adap_tx_250mhz_tuser_dst  (axis_adap_tx_250mhz_tuser_dst),
    .m_axis_adap_tx_250mhz_tready     (axis_adap_tx_250mhz_tready),

    .s_axis_adap_rx_250mhz_tvalid     (axis_adap_rx_250mhz_tvalid),
    .s_axis_adap_rx_250mhz_tdata      (axis_adap_rx_250mhz_tdata),
    .s_axis_adap_rx_250mhz_tkeep      (axis_adap_rx_250mhz_tkeep),
    .s_axis_adap_rx_250mhz_tlast      (axis_adap_rx_250mhz_tlast),
    .s_axis_adap_rx_250mhz_tuser_size (axis_adap_rx_250mhz_tuser_size),
    .s_axis_adap_rx_250mhz_tuser_src  (axis_adap_rx_250mhz_tuser_src),
    .s_axis_adap_rx_250mhz_tuser_dst  (axis_adap_rx_250mhz_tuser_dst),
    .s_axis_adap_rx_250mhz_tready     (axis_adap_rx_250mhz_tready),

    .mod_rstn                         (user_250mhz_rstn),
    .mod_rst_done                     (user_250mhz_rst_done),

    .box_rstn                         (box_250mhz_rstn),
    .box_rst_done                     (box_250mhz_rst_done),

    .axil_aclk                        (axil_aclk),

    .ref_clk_100mhz                   (ref_clk_100mhz),
 
    .axis_aclk                        (axis_aclk)
  );

endmodule: fpga
