

set tag "test"
set board "au50"
set rebuild 0
set board_repo ""
# Directory variables
set root_dir [file normalize ..]
set constr_dir ${root_dir}/constr
set plugin_dir ${root_dir}/plugin
set script_dir ${root_dir}/script
set ip_dir ${root_dir}/ip
set src_dir ${root_dir}/src


set use_phys_func 1
set num_phys_func 1
set num_cmac_port 1
set num_qdma 1
set num_queue 512
set min_pkt_len 64
set max_pkt_len 1518



source ${script_dir}/board_settings/${board}.tcl

set top synic

set build_name ${board}

if {![string equal $tag ""]} {
    set build_name ${build_name}_${tag}
}


set build_dir [file normalize ${root_dir}/build/${build_name}]
if {[file exists $build_dir]} {
    if {!$rebuild } {
        puts "Found existing build directory $build_dir"
        puts "  1. Update existing build directory (default)"
        puts "  2. Delete existing build directory and create a new one"
        puts "  3. Exit"
        puts -nonewline {Choose an option: }
        gets stdin ans
        if {[string equal $ans "2"]} {
            file delete -force $build_dir
            puts "Deleted existing build directory $build_dir"
            file mkdir $build_dir
        } elseif {[string equal $ans "3"]} {
            puts "Build directory existed. Try to specify a different design tag"
            exit
        }
    } else {
	file delete -force $build_dir/open_nic_shell
	puts "Deleted existing build director $build_dir/open_nic_shell"
    }
} else {
    file mkdir $build_dir
}



# Update the board store
if {[string equal $board_repo ""]} {
    set_param board.repoPaths "${root_dir}/board_files"    
    # xhub::refresh_catalog [xhub::get_xstores xilinx_board_store]
} else {
    set_param board.repoPaths $board_repo
}


# Create/open Manage IP project
set ip_build_dir ${ip_dir}/vivado_ip
if {![file exists ${ip_build_dir}/manage_ip/]} {
    puts "INFO: \[Manage IP\] Creating Manage IP project..."
    create_project -force manage_ip ${ip_build_dir}/manage_ip -part $part -ip
    if {![string equal $board_part ""]} {
        set_property BOARD_PART $board_part [current_project]
    }
    set_property simulator_language verilog [current_project]
} else {
    puts "INFO: \[Manage IP\] Opening existing Manage IP project..."
    open_project -quiet ${ip_build_dir}/manage_ip/manage_ip.xpr
}

# source ../ip/cmac_subsystem/cmac_usplus_0.tcl
# source ../ip/cmac_subsystem/cmac_axil_crossbar_0.tcl


# source ../ip/qdma_subsystem/qdma_0.tcl
# source ../ip/qdma_subsystem/qdma_subsystem_axi_cdc_0.tcl
# source ../ip/qdma_subsystem/qdma_subsystem_c2h_ecc_0.tcl
# source ../ip/qdma_subsystem/qdma_subsystem_clk_div_0.tcl
# source ../ip/qdma_subsystem/qdma_subsystem_axi_crossbar_0.tcl
# source ../ip/qdma_subsystem/qdma_subsystem_clk_converter_0.tcl


# source ../ip/config_subsystem/cms_subsystem_0.tcl
# source ../ip/config_subsystem/axi_quad_spi_0.tcl
# source ../ip/config_subsystem/clk_wiz_50Mhz_0.tcl
# source ../ip/config_subsystem/system_management_wiz_0.tcl
# source ../ip/config_subsystem/system_config_axi_crossbar_0.tcl
# source ../ip/config_subsystem/system_config_axi_clock_converter_0.tcl

# source ../ip/utility/axi_stream_pipeline_0.tcl
# source ../ip/utility/axi_lite_clock_converter_0.tcl

#source ../ip/box_250/box_250mhz_axis_switch_0.tcl
#source ../ip/box_250/box_250mhz_axi_crossbar_0.tcl
# source ../ip/box_322/box_322mhz_axi_crossbar_0.tcl


close_project

set top_build_dir ${build_dir}/${top}



if {[file exists $top_build_dir] && !$overwrite} {
    puts "INFO: \[$top\] Use existing build (overwrite=0)"
    return
}
if {[file exists $top_build_dir]} {
    puts "INFO: \[$top\] Found existing build, deleting... (overwrite=1)"
    file delete -force $top_build_dir
}

create_project -force $top $top_build_dir -part $part

if {![string equal $board_part ""]} {
    set_property BOARD_PART $board_part [current_project]
}
set_property target_language verilog [current_project]

# Marco to enable conditional compilation at Verilog level
set verilog_define "__synthesis__ __${board}__"
if {$zynq_family} {
    append verilog_define " " "__zynq_family__"
}
set_property verilog_define $verilog_define [current_fileset]




add_files -fileset sources_1 ../rtl/fpga.sv



add_files -fileset sources_1 ../src/open_nic_shell_macros.vh


# add_files -fileset sources_1 ../lib/cmac_subsystem/cmac_subsystem_cmac_wrapper.sv
# add_files -fileset sources_1 ../lib/cmac_subsystem/cmac_subsystem.sv
# add_files -fileset sources_1 ../lib/cmac_subsystem/cmac_subsystem_address_map.sv

add_files -fileset sources_1 [glob ../lib/cmac_subsystem/*.*v]


add_files -fileset sources_1 -norecurse ../lib/taxi/rtl/axi/taxi_axil_if.sv
add_files -fileset sources_1 -norecurse ../lib/taxi/rtl/axis/taxi_axis_if.sv


add_files -fileset sources_1 -norecurse [glob ../lib/utility/*.*v]

add_files -fileset sources_1 -norecurse [glob ../lib/system_config/*.*v]
add_files -fileset sources_1 -norecurse [glob ../lib/qdma_subsystem/*.*v]
add_files -fileset sources_1 -norecurse [glob ../lib/packet_adapter/*.*v]

# add_files -fileset sources_1 -norecurse ../lib/utility/axi_lite_register.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/axi_stream_packet_buffer.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/axi_stream_register_slice.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/generic_reset.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/rr_arbiter.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/axi_lite_slave.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/axi_stream_packet_fifo.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/axi_stream_size_counter.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/level_trigger_cdc.sv
# add_files -fileset sources_1 -norecurse ../lib/utility/crc32.v



add_files -fileset sources_1 \
    ${ip_dir}/vivado_ip/cmac_usplus_0/cmac_usplus_0.xci \
    ${ip_dir}/vivado_ip/cmac_axil_crossbar_0/cmac_axil_crossbar_0.xci \
    ${ip_dir}/vivado_ip/qdma_0/qdma_0.xci \
    ${ip_dir}/vivado_ip/qdma_subsystem_clk_div_0/qdma_subsystem_clk_div_0.xci \
    ${ip_dir}/vivado_ip/qdma_subsystem_c2h_ecc_0/qdma_subsystem_c2h_ecc_0.xci \
    ${ip_dir}/vivado_ip/qdma_subsystem_axi_cdc_0/qdma_subsystem_axi_cdc_0.xci \
    ${ip_dir}/vivado_ip/qdma_subsystem_axi_crossbar_0/qdma_subsystem_axi_crossbar_0.xci \
    ${ip_dir}/vivado_ip/qdma_subsystem_clk_converter_0/qdma_subsystem_clk_converter_0.xci \
    ${ip_dir}/vivado_ip/axi_quad_spi_0/axi_quad_spi_0.xci \
    ${ip_dir}/vivado_ip/clk_wiz_50Mhz_0/clk_wiz_50Mhz_0.xci \
    ${ip_dir}/vivado_ip/cms_subsystem_0/cms_subsystem_0.xci \
    ${ip_dir}/vivado_ip/system_config_axi_clock_converter_0/system_config_axi_clock_converter_0.xci \
    ${ip_dir}/vivado_ip/system_config_axi_crossbar_0/system_config_axi_crossbar_0.xci \
    ${ip_dir}/vivado_ip/system_management_wiz_0/system_management_wiz_0.xci \
    ${ip_dir}/vivado_ip/axi_lite_clock_converter_0/axi_lite_clock_converter_0.xci \
    ${ip_dir}/vivado_ip/axi_stream_pipeline_0/axi_stream_pipeline_0.xci 




set_property include_dirs {\
  "../lib/taxi/rtl/axi" \
  "../lib/taxi/rtl/axis"\
} [current_fileset]


update_compile_order -fileset sources_1

# unused license critical warning
set_msg_config -id {Vivado 12-1790} -new_severity {INFO}
# Design linking license warning
set_msg_config -id {IP_Flow 19-650} -new_severity {INFO}
# PARTPIN warning for constant nets
set_msg_config -id {Vivado 12-4385} -new_severity {INFO}
# Local parameter warning
set_msg_config -id {Synth 8-2507} -new_severity {INFO}
# Zero replication warning
set_msg_config -id {Synth 8-693} -new_severity {INFO}

exit
