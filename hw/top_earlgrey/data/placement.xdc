# Clock net "top_earlgrey/u_clkmgr_aon/u_clk_main_aes_cg/gen_xilinx.u_impl_xilinx/clocks_o[clk_main_aes]" driven by instance "top_earlgrey/u_clkmgr_aon/u_clk_main_aes_cg/gen_xilinx.u_impl_xilinx/gen_gate.gen_bufhce.u_bufhce" located at site "BUFHCE_X1Y0"
#startgroup
create_pblock {CLKAG_top_earlgrey/u_clkmgr_aon/u_clk_main_aes_cg/gen_xilinx.u_impl_xilinx/clocks_o[clk_main_aes]}
add_cells_to_pblock [get_pblocks  {CLKAG_top_earlgrey/u_clkmgr_aon/u_clk_main_aes_cg/gen_xilinx.u_impl_xilinx/clocks_o[clk_main_aes]}] [get_cells -filter { PRIMITIVE_GROUP != I/O && IS_PRIMITIVE==1 && PRIMITIVE_LEVEL !=INTERNAL } -of_object [get_pins -filter {DIRECTION==IN} -of_objects [get_nets -hierarchical -filter {PARENT=="top_earlgrey/u_clkmgr_aon/u_clk_main_aes_cg/gen_xilinx.u_impl_xilinx/clocks_o[clk_main_aes]"}]]]
resize_pblock [get_pblocks {CLKAG_top_earlgrey/u_clkmgr_aon/u_clk_main_aes_cg/gen_xilinx.u_impl_xilinx/clocks_o[clk_main_aes]}] -add {CLOCKREGION_X1Y0:CLOCKREGION_X1Y0}
#endgroup
