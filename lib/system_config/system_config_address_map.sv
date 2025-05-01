// *************************************************************************
//
// Copyright 2020 Xilinx, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// *************************************************************************
// System address map (through PCI-e BAR2 4MB)
//
// --------------------------------------------------
//   BaseAddr  |  HighAddr |  Module
// --------------------------------------------------
//    0x00000  |  0x00FFF  |  System configuration
// --------------------------------------------------
//    0x01000  |  0x05FFF  |  QDMA subsystem #0
// --------------------------------------------------
//    0x08000  |  0x0AFFF  |  CMAC subsystem #0
// --------------------------------------------------
//    0x0B000  |  0x0BFFF  |  Packet adapter #0
// --------------------------------------------------
//    0x0C000  |  0x0EFFF  |  CMAC subsystem #1
// --------------------------------------------------
//    0x0F000  |  0x0FFFF  |  Packet adapter #1
// --------------------------------------------------
//    0x10000  |  0x11FFF  |  Sysmon block
// --------------------------------------------------
//    0x12000  |  0x16FFF  |  QDMA subsystem #1
// --------------------------------------------------
//   0x100000  |  0x2FFFFF |  Core @ 250MHz
// --------------------------------------------------
//   0x300000  |  0x33FFFF |  Card Management System
// --------------------------------------------------
//   0x340000  |  0x340FFF |  QSPI
// --------------------------------------------------

`include "open_nic_shell_macros.vh"
`timescale 1ns/1ps
module system_config_address_map #(
  parameter int NUM_QDMA = 1,
  parameter int NUM_CMAC_PORT = 1
) (
  input          [NUM_QDMA-1:0] s_axil_awvalid,
  input       [32*NUM_QDMA-1:0] s_axil_awaddr,
  output         [NUM_QDMA-1:0] s_axil_awready,
  input          [NUM_QDMA-1:0] s_axil_wvalid,
  input       [32*NUM_QDMA-1:0] s_axil_wdata,
  output         [NUM_QDMA-1:0] s_axil_wready,
  output         [NUM_QDMA-1:0] s_axil_bvalid,
  output       [2*NUM_QDMA-1:0] s_axil_bresp,
  input          [NUM_QDMA-1:0] s_axil_bready,
  input          [NUM_QDMA-1:0] s_axil_arvalid,
  input       [32*NUM_QDMA-1:0] s_axil_araddr,
  output         [NUM_QDMA-1:0] s_axil_arready,
  output         [NUM_QDMA-1:0] s_axil_rvalid,
  output      [32*NUM_QDMA-1:0] s_axil_rdata,
  output       [2*NUM_QDMA-1:0] s_axil_rresp,
  input          [NUM_QDMA-1:0] s_axil_rready,

  output                        m_axil_scfg_awvalid,
  output                 [31:0] m_axil_scfg_awaddr,
  input                         m_axil_scfg_awready,
  output                        m_axil_scfg_wvalid,
  output                 [31:0] m_axil_scfg_wdata,
  input                         m_axil_scfg_wready,
  input                         m_axil_scfg_bvalid,
  input                   [1:0] m_axil_scfg_bresp,
  output                        m_axil_scfg_bready,
  output                        m_axil_scfg_arvalid,
  output                 [31:0] m_axil_scfg_araddr,
  input                         m_axil_scfg_arready,
  input                         m_axil_scfg_rvalid,
  input                  [31:0] m_axil_scfg_rdata,
  input                   [1:0] m_axil_scfg_rresp,
  output                        m_axil_scfg_rready,

  output      [NUM_QDMA-1:0] m_axil_qdma_awvalid,
  output   [32*NUM_QDMA-1:0] m_axil_qdma_awaddr,
  input       [NUM_QDMA-1:0] m_axil_qdma_awready,
  output      [NUM_QDMA-1:0] m_axil_qdma_wvalid,
  output   [32*NUM_QDMA-1:0] m_axil_qdma_wdata,
  input       [NUM_QDMA-1:0] m_axil_qdma_wready,
  input       [NUM_QDMA-1:0] m_axil_qdma_bvalid,
  input     [2*NUM_QDMA-1:0] m_axil_qdma_bresp,
  output      [NUM_QDMA-1:0] m_axil_qdma_bready,
  output      [NUM_QDMA-1:0] m_axil_qdma_arvalid,
  output   [32*NUM_QDMA-1:0] m_axil_qdma_araddr,
  input       [NUM_QDMA-1:0] m_axil_qdma_arready,
  input       [NUM_QDMA-1:0] m_axil_qdma_rvalid,
  input    [32*NUM_QDMA-1:0] m_axil_qdma_rdata,
  input     [2*NUM_QDMA-1:0] m_axil_qdma_rresp,
  output      [NUM_QDMA-1:0] m_axil_qdma_rready,

  output    [NUM_CMAC_PORT-1:0] m_axil_adap_awvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_adap_awaddr,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_awready,
  output    [NUM_CMAC_PORT-1:0] m_axil_adap_wvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_adap_wdata,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_wready,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_bvalid,
  input   [2*NUM_CMAC_PORT-1:0] m_axil_adap_bresp,
  output    [NUM_CMAC_PORT-1:0] m_axil_adap_bready,
  output    [NUM_CMAC_PORT-1:0] m_axil_adap_arvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_adap_araddr,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_arready,
  input     [NUM_CMAC_PORT-1:0] m_axil_adap_rvalid,
  input  [32*NUM_CMAC_PORT-1:0] m_axil_adap_rdata,
  input   [2*NUM_CMAC_PORT-1:0] m_axil_adap_rresp,
  output    [NUM_CMAC_PORT-1:0] m_axil_adap_rready,

  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_awvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_cmac_awaddr,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_awready,
  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_wvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_cmac_wdata,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_wready,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_bvalid,
  input   [2*NUM_CMAC_PORT-1:0] m_axil_cmac_bresp,
  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_bready,
  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_arvalid,
  output [32*NUM_CMAC_PORT-1:0] m_axil_cmac_araddr,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_arready,
  input     [NUM_CMAC_PORT-1:0] m_axil_cmac_rvalid,
  input  [32*NUM_CMAC_PORT-1:0] m_axil_cmac_rdata,
  input   [2*NUM_CMAC_PORT-1:0] m_axil_cmac_rresp,
  output    [NUM_CMAC_PORT-1:0] m_axil_cmac_rready,

  output                       m_axil_core_awvalid,
  output              [31:0]   m_axil_core_awaddr,
  input                        m_axil_core_awready,
  output                       m_axil_core_wvalid,
  output              [31:0]   m_axil_core_wdata,
  input                        m_axil_core_wready,
  input                        m_axil_core_bvalid,
  input                [1:0]   m_axil_core_bresp,
  output                       m_axil_core_bready,
  output                       m_axil_core_arvalid,
  output              [31:0]   m_axil_core_araddr,
  input                        m_axil_core_arready,
  input                        m_axil_core_rvalid,
  input              [31:0]    m_axil_core_rdata,
  input                [1:0]   m_axil_core_rresp,
  output                       m_axil_core_rready,
  

  output                        m_axil_smon_awvalid,
  output                 [31:0] m_axil_smon_awaddr,
  input                         m_axil_smon_awready,
  output                        m_axil_smon_wvalid,
  output                 [31:0] m_axil_smon_wdata,
  input                         m_axil_smon_wready,
  input                         m_axil_smon_bvalid,
  input                   [1:0] m_axil_smon_bresp,
  output                        m_axil_smon_bready,
  output                        m_axil_smon_arvalid,
  output                 [31:0] m_axil_smon_araddr,
  input                         m_axil_smon_arready,
  input                         m_axil_smon_rvalid,
  input                  [31:0] m_axil_smon_rdata,
  input                   [1:0] m_axil_smon_rresp,
  output                        m_axil_smon_rready,

  output                        m_axil_cms_awvalid,
  output                 [31:0] m_axil_cms_awaddr,
  input                         m_axil_cms_awready,
  output                        m_axil_cms_wvalid,
  output                 [31:0] m_axil_cms_wdata,
  input                         m_axil_cms_wready,
  input                         m_axil_cms_bvalid,
  input                   [1:0] m_axil_cms_bresp,
  output                        m_axil_cms_bready,
  output                        m_axil_cms_arvalid,
  output                 [31:0] m_axil_cms_araddr,
  input                         m_axil_cms_arready,
  input                         m_axil_cms_rvalid,
  input                  [31:0] m_axil_cms_rdata,
  input                   [1:0] m_axil_cms_rresp,
  output                        m_axil_cms_rready,
  output                  [2:0] m_axil_cms_arprot,
  output                  [2:0] m_axil_cms_awprot,
  output                  [3:0] m_axil_cms_wstrb,

  output                        m_axil_qspi_awvalid,
  output                 [31:0] m_axil_qspi_awaddr,
  input                         m_axil_qspi_awready,
  output                        m_axil_qspi_wvalid,
  output                 [31:0] m_axil_qspi_wdata,
  input                         m_axil_qspi_wready,
  input                         m_axil_qspi_bvalid,
  input                   [1:0] m_axil_qspi_bresp,
  output                        m_axil_qspi_bready,
  output                        m_axil_qspi_arvalid,
  output                 [31:0] m_axil_qspi_araddr,
  input                         m_axil_qspi_arready,
  input                         m_axil_qspi_rvalid,
  input                  [31:0] m_axil_qspi_rdata,
  input                   [1:0] m_axil_qspi_rresp,
  output                        m_axil_qspi_rready,
  output                  [2:0] m_axil_qspi_arprot,
  output                  [2:0] m_axil_qspi_awprot,
  output                  [3:0] m_axil_qspi_wstrb,

  input          [NUM_QDMA-1:0] aclk,
  input                         aresetn
);

  localparam C_NUM_SLAVES  = 11; // 12
  localparam C_SCFG_INDEX  = 0;
  localparam C_QDMA0_INDEX = 1;
  localparam C_CMAC0_INDEX = 2;
  localparam C_ADAP0_INDEX = 3;
  localparam C_CMAC1_INDEX = 4;
  localparam C_ADAP1_INDEX = 5;
  localparam C_SMON_INDEX  = 6;
  localparam C_QDMA1_INDEX = 7;
  //localparam C_BOX1_INDEX  = 8;
  //localparam C_BOX0_INDEX  = 9;
  localparam C_CORE_INDEX  = 8;
  localparam C_CMS_INDEX   = 9; // 10
  localparam C_QSPI_INDEX  = 10; // 11

  localparam C_SCFG_BASE_ADDR  = 32'h0;
  localparam C_QDMA0_BASE_ADDR = 32'h01000;
  localparam C_QDMA1_BASE_ADDR = 32'h12000;
  localparam C_CMAC0_BASE_ADDR = 32'h08000;
  localparam C_ADAP0_BASE_ADDR = 32'h0B000;
  localparam C_CMAC1_BASE_ADDR = 32'h0C000;
  localparam C_ADAP1_BASE_ADDR = 32'h0F000;
  localparam C_SMON_BASE_ADDR  = 32'h10000;  // 14 bits
  localparam C_CORE_BASE_ADDR  = 32'h100000; // 21
  //localparam C_BOX1_BASE_ADDR  = 32'h200000; // 20 bits
  //localparam C_BOX0_BASE_ADDR  = 32'h100000; // 20 bits

  localparam C_CMS_BASE_ADDR   = 32'h300000; // 18 bits
  localparam C_QSPI_BASE_ADDR  = 32'h340000; // 12 bits

  wire                [31:0] axil_scfg_awaddr;
  wire                [31:0] axil_scfg_araddr;
  wire                [31:0] axil_qdma0_awaddr;
  wire                [31:0] axil_qdma0_araddr;
  wire                [31:0] axil_qdma1_awaddr;
  wire                [31:0] axil_qdma1_araddr;
  wire                [31:0] axil_cmac0_awaddr;
  wire                [31:0] axil_cmac0_araddr;
  wire                [31:0] axil_adap0_awaddr;
  wire                [31:0] axil_adap0_araddr;
  wire                [31:0] axil_cmac1_awaddr;
  wire                [31:0] axil_cmac1_araddr;
  wire                [31:0] axil_adap1_awaddr;
  wire                [31:0] axil_adap1_araddr;

  wire                [31:0] axil_core_awaddr;
  wire                [31:0] axil_core_araddr;
  wire                [31:0] axil_smon_awaddr;
  wire                [31:0] axil_smon_araddr;
  wire                [31:0] axil_cms_awaddr;
  wire                [31:0] axil_cms_araddr;
  wire                [31:0] axil_qspi_awaddr;
  wire                [31:0] axil_qspi_araddr;

  wire        [NUM_QDMA-1:0] axil_pcie_awvalid;
  wire     [32*NUM_QDMA-1:0] axil_pcie_awaddr;
  wire        [NUM_QDMA-1:0] axil_pcie_awready;
  wire        [NUM_QDMA-1:0] axil_pcie_wvalid;
  wire     [32*NUM_QDMA-1:0] axil_pcie_wdata;
  wire        [NUM_QDMA-1:0] axil_pcie_wready;
  wire        [NUM_QDMA-1:0] axil_pcie_bvalid;
  wire      [2*NUM_QDMA-1:0] axil_pcie_bresp;
  wire        [NUM_QDMA-1:0] axil_pcie_bready;
  wire        [NUM_QDMA-1:0] axil_pcie_arvalid;
  wire     [32*NUM_QDMA-1:0] axil_pcie_araddr;
  wire        [NUM_QDMA-1:0] axil_pcie_arready;
  wire        [NUM_QDMA-1:0] axil_pcie_rvalid;
  wire     [32*NUM_QDMA-1:0] axil_pcie_rdata;
  wire      [2*NUM_QDMA-1:0] axil_pcie_rresp;
  wire        [NUM_QDMA-1:0] axil_pcie_rready;

  wire  [1*C_NUM_SLAVES-1:0] axil_awvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_awaddr;
  wire  [1*C_NUM_SLAVES-1:0] axil_awready;
  wire  [1*C_NUM_SLAVES-1:0] axil_wvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_wdata;
  wire  [1*C_NUM_SLAVES-1:0] axil_wready;
  wire  [1*C_NUM_SLAVES-1:0] axil_bvalid;
  wire  [2*C_NUM_SLAVES-1:0] axil_bresp;
  wire  [1*C_NUM_SLAVES-1:0] axil_bready;
  wire  [1*C_NUM_SLAVES-1:0] axil_arvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_araddr;
  wire  [1*C_NUM_SLAVES-1:0] axil_arready;
  wire  [1*C_NUM_SLAVES-1:0] axil_rvalid;
  wire [32*C_NUM_SLAVES-1:0] axil_rdata;
  wire  [2*C_NUM_SLAVES-1:0] axil_rresp;
  wire  [1*C_NUM_SLAVES-1:0] axil_rready;
  wire  [3*C_NUM_SLAVES-1:0] axil_arprot;
  wire  [3*C_NUM_SLAVES-1:0] axil_awprot;
  wire  [4*C_NUM_SLAVES-1:0] axil_wstrb;

  // Adjust AXI-Lite address so that each slave can assume a base address of 0x0
  assign axil_scfg_awaddr                      = axil_awaddr[`getvec(32, C_SCFG_INDEX)] - C_SCFG_BASE_ADDR;
  assign axil_scfg_araddr                      = axil_araddr[`getvec(32, C_SCFG_INDEX)] - C_SCFG_BASE_ADDR;
  assign axil_qdma0_awaddr                     = axil_awaddr[`getvec(32, C_QDMA0_INDEX)] - C_QDMA0_BASE_ADDR;
  assign axil_qdma0_araddr                     = axil_araddr[`getvec(32, C_QDMA0_INDEX)] - C_QDMA0_BASE_ADDR;
  assign axil_qdma1_awaddr                     = axil_awaddr[`getvec(32, C_QDMA1_INDEX)] - C_QDMA1_BASE_ADDR;
  assign axil_qdma1_araddr                     = axil_araddr[`getvec(32, C_QDMA1_INDEX)] - C_QDMA1_BASE_ADDR;
  assign axil_cmac0_awaddr                     = axil_awaddr[`getvec(32, C_CMAC0_INDEX)] - C_CMAC0_BASE_ADDR;
  assign axil_cmac0_araddr                     = axil_araddr[`getvec(32, C_CMAC0_INDEX)] - C_CMAC0_BASE_ADDR;
  assign axil_adap0_awaddr                     = axil_awaddr[`getvec(32, C_ADAP0_INDEX)] - C_ADAP0_BASE_ADDR;
  assign axil_adap0_araddr                     = axil_araddr[`getvec(32, C_ADAP0_INDEX)] - C_ADAP0_BASE_ADDR;
  assign axil_cmac1_awaddr                     = axil_awaddr[`getvec(32, C_CMAC1_INDEX)] - C_CMAC1_BASE_ADDR;
  assign axil_cmac1_araddr                     = axil_araddr[`getvec(32, C_CMAC1_INDEX)] - C_CMAC1_BASE_ADDR;
  assign axil_adap1_awaddr                     = axil_awaddr[`getvec(32, C_ADAP1_INDEX)] - C_ADAP1_BASE_ADDR;
  assign axil_adap1_araddr                     = axil_araddr[`getvec(32, C_ADAP1_INDEX)] - C_ADAP1_BASE_ADDR;
  assign axil_smon_awaddr                      = axil_awaddr[`getvec(32, C_SMON_INDEX)]  - C_SMON_BASE_ADDR;
  assign axil_smon_araddr                      = axil_araddr[`getvec(32, C_SMON_INDEX)] - C_SMON_BASE_ADDR;

  assign axil_core_awaddr                      = axil_awaddr[`getvec(32, C_CORE_INDEX)] - C_CORE_BASE_ADDR;
  assign axil_core_araddr                      = axil_araddr[`getvec(32, C_CORE_INDEX)] - C_CORE_BASE_ADDR;
  
  
  assign axil_cms_awaddr                       = axil_awaddr[`getvec(32, C_CMS_INDEX)] - C_CMS_BASE_ADDR;
  assign axil_cms_araddr                       = axil_araddr[`getvec(32, C_CMS_INDEX)] - C_CMS_BASE_ADDR;
  assign axil_qspi_awaddr                      = axil_awaddr[`getvec(32, C_QSPI_INDEX)] - C_QSPI_BASE_ADDR;
  assign axil_qspi_araddr                      = axil_araddr[`getvec(32, C_QSPI_INDEX)] - C_QSPI_BASE_ADDR;

  assign m_axil_scfg_awvalid                   = axil_awvalid[C_SCFG_INDEX];
  assign m_axil_scfg_awaddr                    = axil_scfg_awaddr;
  assign axil_awready[C_SCFG_INDEX]            = m_axil_scfg_awready;
  assign m_axil_scfg_wvalid                    = axil_wvalid[C_SCFG_INDEX];
  assign m_axil_scfg_wdata                     = axil_wdata[`getvec(32, C_SCFG_INDEX)];
  assign axil_wready[C_SCFG_INDEX]             = m_axil_scfg_wready;
  assign axil_bvalid[C_SCFG_INDEX]             = m_axil_scfg_bvalid;
  assign axil_bresp[`getvec(2, C_SCFG_INDEX)]  = m_axil_scfg_bresp;
  assign m_axil_scfg_bready                    = axil_bready[C_SCFG_INDEX];
  assign m_axil_scfg_arvalid                   = axil_arvalid[C_SCFG_INDEX];
  assign m_axil_scfg_araddr                    = axil_scfg_araddr;
  assign axil_arready[C_SCFG_INDEX]            = m_axil_scfg_arready;
  assign axil_rvalid[C_SCFG_INDEX]             = m_axil_scfg_rvalid;
  assign axil_rdata[`getvec(32, C_SCFG_INDEX)] = m_axil_scfg_rdata;
  assign axil_rresp[`getvec(2, C_SCFG_INDEX)]  = m_axil_scfg_rresp;
  assign m_axil_scfg_rready                    = axil_rready[C_SCFG_INDEX];

    assign m_axil_qdma_awvalid                    = axil_awvalid[C_QDMA0_INDEX];
    assign m_axil_qdma_awaddr                     = axil_qdma0_awaddr;
    assign axil_awready[C_QDMA0_INDEX]            = m_axil_qdma_awready;
    assign m_axil_qdma_wvalid                     = axil_wvalid[C_QDMA0_INDEX];
    assign m_axil_qdma_wdata                      = axil_wdata[`getvec(32, C_QDMA0_INDEX)];
    assign axil_wready[C_QDMA0_INDEX]             = m_axil_qdma_wready;
    assign axil_bvalid[C_QDMA0_INDEX]             = m_axil_qdma_bvalid;
    assign axil_bresp[`getvec(2, C_QDMA0_INDEX)]  = m_axil_qdma_bresp;
    assign m_axil_qdma_bready                     = axil_bready[C_QDMA0_INDEX];
    assign m_axil_qdma_arvalid                    = axil_arvalid[C_QDMA0_INDEX];
    assign m_axil_qdma_araddr                     = axil_qdma0_araddr;
    assign axil_arready[C_QDMA0_INDEX]            = m_axil_qdma_arready;
    assign axil_rvalid[C_QDMA0_INDEX]             = m_axil_qdma_rvalid;
    assign axil_rdata[`getvec(32, C_QDMA0_INDEX)] = m_axil_qdma_rdata;
    assign axil_rresp[`getvec(2, C_QDMA0_INDEX)]  = m_axil_qdma_rresp;
    assign m_axil_qdma_rready                     = axil_rready[C_QDMA0_INDEX];

    // Sink for the unused dummy register interface
    axi_lite_slave dummy_reg_inst (
      .s_axil_awvalid (axil_awvalid[C_QDMA1_INDEX]),
      .s_axil_awaddr  (axil_qdma1_awaddr),
      .s_axil_awready (axil_awready[C_QDMA1_INDEX]),
      .s_axil_wvalid  (axil_wvalid[C_QDMA1_INDEX]),
      .s_axil_wdata   (axil_wdata[`getvec(32, C_QDMA1_INDEX)]),
      .s_axil_wready  (axil_wready[C_QDMA1_INDEX]),
      .s_axil_bvalid  (axil_bvalid[C_QDMA1_INDEX]),
      .s_axil_bresp   (axil_bresp[`getvec(2, C_QDMA1_INDEX)]),
      .s_axil_bready  (axil_bready[C_QDMA1_INDEX]),
      .s_axil_arvalid (axil_arvalid[C_QDMA1_INDEX]),
      .s_axil_araddr  (axil_qdma1_araddr),
      .s_axil_arready (axil_arready[C_QDMA1_INDEX]),
      .s_axil_rvalid  (axil_rvalid[C_QDMA1_INDEX] ),
      .s_axil_rdata   (axil_rdata[`getvec(32, C_QDMA1_INDEX)]),
      .s_axil_rresp   (axil_rresp[`getvec(2, C_QDMA1_INDEX)]),
      .s_axil_rready  (axil_rready[C_QDMA1_INDEX]),

      .aresetn        (aresetn),
      .aclk           (aclk[0])
    );

    assign axil_pcie_awvalid                      = s_axil_awvalid;
    assign axil_pcie_awaddr                       = s_axil_awaddr;
    assign s_axil_awready                         = axil_pcie_awready;
    assign axil_pcie_wvalid                       = s_axil_wvalid;
    assign axil_pcie_wdata                        = s_axil_wdata;
    assign s_axil_wready                          = axil_pcie_wready;
    assign s_axil_bvalid                          = axil_pcie_bvalid;
    assign s_axil_bresp                           = axil_pcie_bresp;
    assign axil_pcie_bready                       = s_axil_bready;
    assign axil_pcie_arvalid                      = s_axil_arvalid;
    assign axil_pcie_araddr                       = s_axil_araddr;
    assign s_axil_arready                         = axil_pcie_arready;
    assign s_axil_rvalid                          = axil_pcie_rvalid;
    assign s_axil_rdata                           = axil_pcie_rdata;
    assign s_axil_rresp                           = axil_pcie_rresp;
    assign axil_pcie_rready                       = s_axil_rready;


    assign m_axil_cmac_awvalid                    = axil_awvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_awaddr                     = axil_cmac0_awaddr;
    assign axil_awready[C_CMAC0_INDEX]            = m_axil_cmac_awready;
    assign m_axil_cmac_wvalid                     = axil_wvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_wdata                      = axil_wdata[`getvec(32, C_CMAC0_INDEX)];
    assign axil_wready[C_CMAC0_INDEX]             = m_axil_cmac_wready;
    assign axil_bvalid[C_CMAC0_INDEX]             = m_axil_cmac_bvalid;
    assign axil_bresp[`getvec(2, C_CMAC0_INDEX)]  = m_axil_cmac_bresp;
    assign m_axil_cmac_bready                     = axil_bready[C_CMAC0_INDEX];
    assign m_axil_cmac_arvalid                    = axil_arvalid[C_CMAC0_INDEX];
    assign m_axil_cmac_araddr                     = axil_cmac0_araddr;
    assign axil_arready[C_CMAC0_INDEX]            = m_axil_cmac_arready;
    assign axil_rvalid[C_CMAC0_INDEX]             = m_axil_cmac_rvalid;
    assign axil_rdata[`getvec(32, C_CMAC0_INDEX)] = m_axil_cmac_rdata;
    assign axil_rresp[`getvec(2, C_CMAC0_INDEX)]  = m_axil_cmac_rresp;
    assign m_axil_cmac_rready                     = axil_rready[C_CMAC0_INDEX];

    assign m_axil_adap_awvalid                    = axil_awvalid[C_ADAP0_INDEX];
    assign m_axil_adap_awaddr                     = axil_adap0_awaddr;
    assign axil_awready[C_ADAP0_INDEX]            = m_axil_adap_awready;
    assign m_axil_adap_wvalid                     = axil_wvalid[C_ADAP0_INDEX];
    assign m_axil_adap_wdata                      = axil_wdata[`getvec(32, C_ADAP0_INDEX)];
    assign axil_wready[C_ADAP0_INDEX]             = m_axil_adap_wready;
    assign axil_bvalid[C_ADAP0_INDEX]             = m_axil_adap_bvalid;
    assign axil_bresp[`getvec(2, C_ADAP0_INDEX)]  = m_axil_adap_bresp;
    assign m_axil_adap_bready                     = axil_bready[C_ADAP0_INDEX];
    assign m_axil_adap_arvalid                    = axil_arvalid[C_ADAP0_INDEX];
    assign m_axil_adap_araddr                     = axil_adap0_araddr;
    assign axil_arready[C_ADAP0_INDEX]            = m_axil_adap_arready;
    assign axil_rvalid[C_ADAP0_INDEX]             = m_axil_adap_rvalid;
    assign axil_rdata[`getvec(32, C_ADAP0_INDEX)] = m_axil_adap_rdata;
    assign axil_rresp[`getvec(2, C_ADAP0_INDEX)]  = m_axil_adap_rresp;
    assign m_axil_adap_rready                     = axil_rready[C_ADAP0_INDEX];

    // Sink for unused CMAC1 register path
    axi_lite_slave #(
      .REG_ADDR_W (13),
      .REG_PREFIX (16'hC100)
    ) cmac1_reg_inst (
      .s_axil_awvalid (axil_awvalid[C_CMAC1_INDEX]),
      .s_axil_awaddr  (axil_cmac1_awaddr),
      .s_axil_awready (axil_awready[C_CMAC1_INDEX]),
      .s_axil_wvalid  (axil_wvalid[C_CMAC1_INDEX]),
      .s_axil_wdata   (axil_wdata[`getvec(32, C_CMAC1_INDEX)]),
      .s_axil_wready  (axil_wready[C_CMAC1_INDEX]),
      .s_axil_bvalid  (axil_bvalid[C_CMAC1_INDEX]),
      .s_axil_bresp   (axil_bresp[`getvec(2, C_CMAC1_INDEX)]),
      .s_axil_bready  (axil_bready[C_CMAC1_INDEX]),
      .s_axil_arvalid (axil_arvalid[C_CMAC1_INDEX]),
      .s_axil_araddr  (axil_cmac1_araddr),
      .s_axil_arready (axil_arready[C_CMAC1_INDEX]),
      .s_axil_rvalid  (axil_rvalid[C_CMAC1_INDEX]),
      .s_axil_rdata   (axil_rdata[`getvec(32, C_CMAC1_INDEX)]),
      .s_axil_rresp   (axil_rresp[`getvec(2, C_CMAC1_INDEX)]),
      .s_axil_rready  (axil_rready[C_CMAC1_INDEX]),

      .aresetn        (aresetn),
      .aclk           (aclk[0])
    );

    // Sink for unused ADAP1 register path
    axi_lite_slave #(
      .REG_ADDR_W (13),
      .REG_PREFIX (16'hC100)
    ) adap1_reg_inst (
      .s_axil_awvalid (axil_awvalid[C_ADAP1_INDEX]),
      .s_axil_awaddr  (axil_adap1_awaddr),
      .s_axil_awready (axil_awready[C_ADAP1_INDEX]),
      .s_axil_wvalid  (axil_wvalid[C_ADAP1_INDEX]),
      .s_axil_wdata   (axil_wdata[`getvec(32, C_ADAP1_INDEX)]),
      .s_axil_wready  (axil_wready[C_ADAP1_INDEX]),
      .s_axil_bvalid  (axil_bvalid[C_ADAP1_INDEX]),
      .s_axil_bresp   (axil_bresp[`getvec(2, C_ADAP1_INDEX)]),
      .s_axil_bready  (axil_bready[C_ADAP1_INDEX]),
      .s_axil_arvalid (axil_arvalid[C_ADAP1_INDEX]),
      .s_axil_araddr  (axil_adap1_araddr),
      .s_axil_arready (axil_arready[C_ADAP1_INDEX]),
      .s_axil_rvalid  (axil_rvalid[C_ADAP1_INDEX]),
      .s_axil_rdata   (axil_rdata[`getvec(32, C_ADAP1_INDEX)]),
      .s_axil_rresp   (axil_rresp[`getvec(2, C_ADAP1_INDEX)]),
      .s_axil_rready  (axil_rready[C_ADAP1_INDEX]),

      .aresetn        (aresetn),
      .aclk           (aclk[0])
    );
 


    assign m_axil_core_awvalid     = axil_awvalid[C_CORE_INDEX];
assign m_axil_core_awaddr      = axil_core_awaddr;
assign axil_awready[C_CORE_INDEX] = m_axil_core_awready;

assign m_axil_core_wvalid      = axil_wvalid[C_CORE_INDEX];
assign m_axil_core_wdata       = axil_wdata[`getvec(32,C_CORE_INDEX)];
assign axil_wready[C_CORE_INDEX] = m_axil_core_wready;

assign axil_bvalid[C_CORE_INDEX]  = m_axil_core_bvalid;
assign axil_bresp[`getvec(2,C_CORE_INDEX)] = m_axil_core_bresp;
assign m_axil_core_bready      = axil_bready[C_CORE_INDEX];

assign m_axil_core_arvalid    = axil_arvalid[C_CORE_INDEX];
assign m_axil_core_araddr     = axil_core_araddr;
assign axil_arready[C_CORE_INDEX] = m_axil_core_arready;

assign axil_rvalid[C_CORE_INDEX]  = m_axil_core_rvalid;
assign axil_rdata[`getvec(32,C_CORE_INDEX)] = m_axil_core_rdata;
assign axil_rresp[`getvec(2,C_CORE_INDEX)]  = m_axil_core_rresp;
assign m_axil_core_rready      = axil_rready[C_CORE_INDEX];



  assign m_axil_smon_awvalid                   = axil_awvalid[C_SMON_INDEX];
  assign m_axil_smon_awaddr                    = axil_smon_awaddr;
  assign axil_awready[C_SMON_INDEX]            = m_axil_smon_awready;
  assign m_axil_smon_wvalid                    = axil_wvalid[C_SMON_INDEX];
  assign m_axil_smon_wdata                     = axil_wdata[`getvec(32, C_SMON_INDEX)];
  assign axil_wready[C_SMON_INDEX]             = m_axil_smon_wready;
  assign axil_bvalid[C_SMON_INDEX]             = m_axil_smon_bvalid;
  assign axil_bresp[`getvec(2, C_SMON_INDEX)]  = m_axil_smon_bresp;
  assign m_axil_smon_bready                    = axil_bready[C_SMON_INDEX];
  assign m_axil_smon_arvalid                   = axil_arvalid[C_SMON_INDEX];
  assign m_axil_smon_araddr                    = axil_smon_araddr;
  assign axil_arready[C_SMON_INDEX]            = m_axil_smon_arready;
  assign axil_rvalid[C_SMON_INDEX]             = m_axil_smon_rvalid;
  assign axil_rdata[`getvec(32, C_SMON_INDEX)] = m_axil_smon_rdata;
  assign axil_rresp[`getvec(2, C_SMON_INDEX)]  = m_axil_smon_rresp;
  assign m_axil_smon_rready                    = axil_rready[C_SMON_INDEX];

  assign m_axil_cms_awvalid                    = axil_awvalid[C_CMS_INDEX];
  assign m_axil_cms_awaddr                     = axil_cms_awaddr;
  assign axil_awready[C_CMS_INDEX]             = m_axil_cms_awready;
  assign m_axil_cms_wvalid                     = axil_wvalid[C_CMS_INDEX];
  assign m_axil_cms_wdata                      = axil_wdata[`getvec(32, C_CMS_INDEX)];
  assign axil_wready[C_CMS_INDEX]              = m_axil_cms_wready;
  assign axil_bvalid[C_CMS_INDEX]              = m_axil_cms_bvalid;
  assign axil_bresp[`getvec(2, C_CMS_INDEX)]   = m_axil_cms_bresp;
  assign m_axil_cms_bready                     = axil_bready[C_CMS_INDEX];
  assign m_axil_cms_arvalid                    = axil_arvalid[C_CMS_INDEX];
  assign m_axil_cms_araddr                     = axil_cms_araddr;
  assign axil_arready[C_CMS_INDEX]             = m_axil_cms_arready;
  assign axil_rvalid[C_CMS_INDEX]              = m_axil_cms_rvalid;
  assign axil_rdata[`getvec(32, C_CMS_INDEX)]  = m_axil_cms_rdata;
  assign axil_rresp[`getvec(2, C_CMS_INDEX)]   = m_axil_cms_rresp;
  assign m_axil_cms_rready                     = axil_rready[C_CMS_INDEX];
  assign m_axil_cms_arprot                     = axil_arprot[`getvec(3, C_CMS_INDEX)];
  assign m_axil_cms_awprot                     = axil_awprot[`getvec(3, C_CMS_INDEX)];
  assign m_axil_cms_wstrb                      = axil_wstrb[`getvec(4, C_CMS_INDEX)];

  assign m_axil_qspi_awvalid                    = axil_awvalid[C_QSPI_INDEX];
  assign m_axil_qspi_awaddr                     = axil_qspi_awaddr;
  assign axil_awready[C_QSPI_INDEX]             = m_axil_qspi_awready;
  assign m_axil_qspi_wvalid                     = axil_wvalid[C_QSPI_INDEX];
  assign m_axil_qspi_wdata                      = axil_wdata[`getvec(32, C_QSPI_INDEX)];
  assign axil_wready[C_QSPI_INDEX]              = m_axil_qspi_wready;
  assign axil_bvalid[C_QSPI_INDEX]              = m_axil_qspi_bvalid;
  assign axil_bresp[`getvec(2, C_QSPI_INDEX)]   = m_axil_qspi_bresp;
  assign m_axil_qspi_bready                     = axil_bready[C_QSPI_INDEX];
  assign m_axil_qspi_arvalid                    = axil_arvalid[C_QSPI_INDEX];
  assign m_axil_qspi_araddr                     = axil_qspi_araddr;
  assign axil_arready[C_QSPI_INDEX]             = m_axil_qspi_arready;
  assign axil_rvalid[C_QSPI_INDEX]              = m_axil_qspi_rvalid;
  assign axil_rdata[`getvec(32, C_QSPI_INDEX)]  = m_axil_qspi_rdata;
  assign axil_rresp[`getvec(2, C_QSPI_INDEX)]   = m_axil_qspi_rresp;
  assign m_axil_qspi_rready                     = axil_rready[C_QSPI_INDEX];
  assign m_axil_qspi_arprot                     = axil_arprot[`getvec(3, C_QSPI_INDEX)];
  assign m_axil_qspi_awprot                     = axil_awprot[`getvec(3, C_QSPI_INDEX)];
  assign m_axil_qspi_wstrb                      = axil_wstrb[`getvec(4, C_QSPI_INDEX)];

  
  system_config_axi_crossbar_2 xbar_inst (
    .s_axi_awaddr  (axil_pcie_awaddr),
    .s_axi_awprot  (0),
    .s_axi_awvalid (axil_pcie_awvalid),
    .s_axi_awready (axil_pcie_awready),
    .s_axi_wdata   (axil_pcie_wdata),
    .s_axi_wstrb   (4'hF),
    .s_axi_wvalid  (axil_pcie_wvalid),
    .s_axi_wready  (axil_pcie_wready),
    .s_axi_bresp   (axil_pcie_bresp),
    .s_axi_bvalid  (axil_pcie_bvalid),
    .s_axi_bready  (axil_pcie_bready),
    .s_axi_araddr  (axil_pcie_araddr),
    .s_axi_arprot  (0),
    .s_axi_arvalid (axil_pcie_arvalid),
    .s_axi_arready (axil_pcie_arready),
    .s_axi_rdata   (axil_pcie_rdata),
    .s_axi_rresp   (axil_pcie_rresp),
    .s_axi_rvalid  (axil_pcie_rvalid),
    .s_axi_rready  (axil_pcie_rready),

    .m_axi_awaddr  (axil_awaddr),
    .m_axi_awprot  (axil_awprot),
    .m_axi_awvalid (axil_awvalid),
    .m_axi_awready (axil_awready),
    .m_axi_wdata   (axil_wdata),
    .m_axi_wstrb   (axil_wstrb),
    .m_axi_wvalid  (axil_wvalid),
    .m_axi_wready  (axil_wready),
    .m_axi_bresp   (axil_bresp),
    .m_axi_bvalid  (axil_bvalid),
    .m_axi_bready  (axil_bready),
    .m_axi_araddr  (axil_araddr),
    .m_axi_arprot  (axil_arprot),
    .m_axi_arvalid (axil_arvalid),
    .m_axi_arready (axil_arready),
    .m_axi_rdata   (axil_rdata),
    .m_axi_rresp   (axil_rresp),
    .m_axi_rvalid  (axil_rvalid),
    .m_axi_rready  (axil_rready),

    .aclk          (aclk[0]),
    .aresetn       (aresetn)
  );

endmodule: system_config_address_map
