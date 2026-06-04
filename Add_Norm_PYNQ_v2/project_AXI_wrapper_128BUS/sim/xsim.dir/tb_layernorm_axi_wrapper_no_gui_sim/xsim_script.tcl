set_param project.enableReportConfiguration 0
load_feature core
current_fileset
xsim {tb_layernorm_axi_wrapper_no_gui_sim} -testplusarg SCENARIO=0 -wdb {simulate_scn0_basic.wdb} -autoloadwcfg -tclbatch {sim.tcl} -protoinst {./protoinst_files/layernorm_sim.protoinst}
