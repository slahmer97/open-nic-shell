# *************************************************************************
#
# Copyright 2020 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# *************************************************************************
set clk_wiz qdma_subsystem_clk_div_0
create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name $clk_wiz -dir ${ip_build_dir}
set_property -dict {
    CONFIG.PRIMITIVE {Auto} 
    CONFIG.USE_FREQ_SYNTH {true} 
    CONFIG.USE_PHASE_ALIGNMENT {true} 
    CONFIG.PRIM_IN_FREQ {250.000} 
    CONFIG.JITTER_OPTIONS {PS} 
    CONFIG.CLKOUT2_USED {true} 
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000} 
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} 
    CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} 
    CONFIG.CLKIN1_JITTER_PS {40.000} 
    CONFIG.CLKOUT1_DRIVES {Buffer} 
    CONFIG.CLKOUT2_DRIVES {Buffer} 
    CONFIG.CLKOUT3_DRIVES {Buffer} 
    CONFIG.CLKOUT4_DRIVES {Buffer} 
    CONFIG.CLKOUT5_DRIVES {Buffer} 
    CONFIG.CLKOUT6_DRIVES {Buffer} 
    CONFIG.CLKOUT7_DRIVES {Buffer} 
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} 
    CONFIG.USE_LOCKED {false} 
    CONFIG.USE_RESET {false} 
    CONFIG.MMCM_DIVCLK_DIVIDE {1} 
    CONFIG.MMCM_BANDWIDTH {OPTIMIZED} 
    CONFIG.MMCM_CLKFBOUT_MULT_F {4.000} 
    CONFIG.MMCM_CLKIN1_PERIOD {4.000} 
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} 
    CONFIG.MMCM_COMPENSATION {AUTO} 
    CONFIG.MMCM_REF_JITTER2 {0.010} 
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} 
    CONFIG.MMCM_CLKOUT1_DIVIDE {10} 
    CONFIG.NUM_OUT_CLKS {2} 
    CONFIG.CLKOUT1_JITTER {102.531} 
    CONFIG.CLKOUT1_PHASE_ERROR {85.928} 
    CONFIG.CLKOUT2_JITTER {107.111} 
    CONFIG.CLKOUT2_PHASE_ERROR {85.928} 
    CONFIG.AUTO_PRIMITIVE {MMCM}
} [get_ips $clk_wiz]
