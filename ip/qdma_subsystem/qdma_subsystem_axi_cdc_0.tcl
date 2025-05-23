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
set axi_clock_converter qdma_subsystem_axi_cdc_0
create_ip -name axi_clock_converter -vendor xilinx.com -library ip -module_name $axi_clock_converter -dir ${ip_build_dir}
set_property -dict {
    CONFIG.PROTOCOL {AXI4LITE}
    CONFIG.DATA_WIDTH {32}
    CONFIG.ID_WIDTH {0}
    CONFIG.AWUSER_WIDTH {0}
    CONFIG.ARUSER_WIDTH {0}
    CONFIG.RUSER_WIDTH {0}
    CONFIG.WUSER_WIDTH {0}
    CONFIG.BUSER_WIDTH {0}
    CONFIG.SI_CLK.FREQ_HZ {250000000}
    CONFIG.MI_CLK.FREQ_HZ {125000000}
    CONFIG.ACLK_ASYNC {1}
    CONFIG.SYNCHRONIZATION_STAGES {2}
    CONFIG.ACLK_RATIO {2:1}
} [get_ips $axi_clock_converter]
