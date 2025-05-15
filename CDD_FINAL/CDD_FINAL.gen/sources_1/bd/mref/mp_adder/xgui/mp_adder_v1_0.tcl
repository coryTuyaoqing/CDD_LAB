# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_ITERATIONS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OPERAND_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDER_WIDTH { PARAM_VALUE.ADDER_WIDTH } {
	# Procedure called to update ADDER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDER_WIDTH { PARAM_VALUE.ADDER_WIDTH } {
	# Procedure called to validate ADDER_WIDTH
	return true
}

proc update_PARAM_VALUE.N_ITERATIONS { PARAM_VALUE.N_ITERATIONS } {
	# Procedure called to update N_ITERATIONS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_ITERATIONS { PARAM_VALUE.N_ITERATIONS } {
	# Procedure called to validate N_ITERATIONS
	return true
}

proc update_PARAM_VALUE.OPERAND_WIDTH { PARAM_VALUE.OPERAND_WIDTH } {
	# Procedure called to update OPERAND_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OPERAND_WIDTH { PARAM_VALUE.OPERAND_WIDTH } {
	# Procedure called to validate OPERAND_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.OPERAND_WIDTH { MODELPARAM_VALUE.OPERAND_WIDTH PARAM_VALUE.OPERAND_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OPERAND_WIDTH}] ${MODELPARAM_VALUE.OPERAND_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDER_WIDTH { MODELPARAM_VALUE.ADDER_WIDTH PARAM_VALUE.ADDER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDER_WIDTH}] ${MODELPARAM_VALUE.ADDER_WIDTH}
}

proc update_MODELPARAM_VALUE.N_ITERATIONS { MODELPARAM_VALUE.N_ITERATIONS PARAM_VALUE.N_ITERATIONS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_ITERATIONS}] ${MODELPARAM_VALUE.N_ITERATIONS}
}

