# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACCUM_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXIS_START_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M00_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXIS_TDATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FRAC_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LUT_NUM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MODEL_DIMENSION_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MODULE_NUM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SHIFT_VALUE_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SHIFT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SQUARED_ACCUM_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SQUARED_MEAN_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "START_INDEX" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VAR_DATA_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACCUM_DATA_WIDTH { PARAM_VALUE.ACCUM_DATA_WIDTH } {
	# Procedure called to update ACCUM_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACCUM_DATA_WIDTH { PARAM_VALUE.ACCUM_DATA_WIDTH } {
	# Procedure called to validate ACCUM_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_START_COUNT { PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to update C_M00_AXIS_START_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_START_COUNT { PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to validate C_M00_AXIS_START_COUNT
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.FRAC_WIDTH { PARAM_VALUE.FRAC_WIDTH } {
	# Procedure called to update FRAC_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAC_WIDTH { PARAM_VALUE.FRAC_WIDTH } {
	# Procedure called to validate FRAC_WIDTH
	return true
}

proc update_PARAM_VALUE.LUT_NUM { PARAM_VALUE.LUT_NUM } {
	# Procedure called to update LUT_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LUT_NUM { PARAM_VALUE.LUT_NUM } {
	# Procedure called to validate LUT_NUM
	return true
}

proc update_PARAM_VALUE.MODEL_DIMENSION_WIDTH { PARAM_VALUE.MODEL_DIMENSION_WIDTH } {
	# Procedure called to update MODEL_DIMENSION_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MODEL_DIMENSION_WIDTH { PARAM_VALUE.MODEL_DIMENSION_WIDTH } {
	# Procedure called to validate MODEL_DIMENSION_WIDTH
	return true
}

proc update_PARAM_VALUE.MODULE_NUM { PARAM_VALUE.MODULE_NUM } {
	# Procedure called to update MODULE_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MODULE_NUM { PARAM_VALUE.MODULE_NUM } {
	# Procedure called to validate MODULE_NUM
	return true
}

proc update_PARAM_VALUE.SHIFT_VALUE_DATA_WIDTH { PARAM_VALUE.SHIFT_VALUE_DATA_WIDTH } {
	# Procedure called to update SHIFT_VALUE_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SHIFT_VALUE_DATA_WIDTH { PARAM_VALUE.SHIFT_VALUE_DATA_WIDTH } {
	# Procedure called to validate SHIFT_VALUE_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.SHIFT_WIDTH { PARAM_VALUE.SHIFT_WIDTH } {
	# Procedure called to update SHIFT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SHIFT_WIDTH { PARAM_VALUE.SHIFT_WIDTH } {
	# Procedure called to validate SHIFT_WIDTH
	return true
}

proc update_PARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH { PARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH } {
	# Procedure called to update SQUARED_ACCUM_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH { PARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH } {
	# Procedure called to validate SQUARED_ACCUM_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.SQUARED_MEAN_DATA_WIDTH { PARAM_VALUE.SQUARED_MEAN_DATA_WIDTH } {
	# Procedure called to update SQUARED_MEAN_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SQUARED_MEAN_DATA_WIDTH { PARAM_VALUE.SQUARED_MEAN_DATA_WIDTH } {
	# Procedure called to validate SQUARED_MEAN_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.START_INDEX { PARAM_VALUE.START_INDEX } {
	# Procedure called to update START_INDEX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.START_INDEX { PARAM_VALUE.START_INDEX } {
	# Procedure called to validate START_INDEX
	return true
}

proc update_PARAM_VALUE.VAR_DATA_WIDTH { PARAM_VALUE.VAR_DATA_WIDTH } {
	# Procedure called to update VAR_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VAR_DATA_WIDTH { PARAM_VALUE.VAR_DATA_WIDTH } {
	# Procedure called to validate VAR_DATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.MODULE_NUM { MODELPARAM_VALUE.MODULE_NUM PARAM_VALUE.MODULE_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MODULE_NUM}] ${MODELPARAM_VALUE.MODULE_NUM}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ACCUM_DATA_WIDTH { MODELPARAM_VALUE.ACCUM_DATA_WIDTH PARAM_VALUE.ACCUM_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACCUM_DATA_WIDTH}] ${MODELPARAM_VALUE.ACCUM_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH { MODELPARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH PARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH}] ${MODELPARAM_VALUE.SQUARED_ACCUM_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.SHIFT_WIDTH { MODELPARAM_VALUE.SHIFT_WIDTH PARAM_VALUE.SHIFT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SHIFT_WIDTH}] ${MODELPARAM_VALUE.SHIFT_WIDTH}
}

proc update_MODELPARAM_VALUE.MODEL_DIMENSION_WIDTH { MODELPARAM_VALUE.MODEL_DIMENSION_WIDTH PARAM_VALUE.MODEL_DIMENSION_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MODEL_DIMENSION_WIDTH}] ${MODELPARAM_VALUE.MODEL_DIMENSION_WIDTH}
}

proc update_MODELPARAM_VALUE.FRAC_WIDTH { MODELPARAM_VALUE.FRAC_WIDTH PARAM_VALUE.FRAC_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAC_WIDTH}] ${MODELPARAM_VALUE.FRAC_WIDTH}
}

proc update_MODELPARAM_VALUE.SQUARED_MEAN_DATA_WIDTH { MODELPARAM_VALUE.SQUARED_MEAN_DATA_WIDTH PARAM_VALUE.SQUARED_MEAN_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SQUARED_MEAN_DATA_WIDTH}] ${MODELPARAM_VALUE.SQUARED_MEAN_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.VAR_DATA_WIDTH { MODELPARAM_VALUE.VAR_DATA_WIDTH PARAM_VALUE.VAR_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VAR_DATA_WIDTH}] ${MODELPARAM_VALUE.VAR_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.LUT_NUM { MODELPARAM_VALUE.LUT_NUM PARAM_VALUE.LUT_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LUT_NUM}] ${MODELPARAM_VALUE.LUT_NUM}
}

proc update_MODELPARAM_VALUE.START_INDEX { MODELPARAM_VALUE.START_INDEX PARAM_VALUE.START_INDEX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.START_INDEX}] ${MODELPARAM_VALUE.START_INDEX}
}

proc update_MODELPARAM_VALUE.SHIFT_VALUE_DATA_WIDTH { MODELPARAM_VALUE.SHIFT_VALUE_DATA_WIDTH PARAM_VALUE.SHIFT_VALUE_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SHIFT_VALUE_DATA_WIDTH}] ${MODELPARAM_VALUE.SHIFT_VALUE_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M00_AXIS_START_COUNT { MODELPARAM_VALUE.C_M00_AXIS_START_COUNT PARAM_VALUE.C_M00_AXIS_START_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_START_COUNT}] ${MODELPARAM_VALUE.C_M00_AXIS_START_COUNT}
}

