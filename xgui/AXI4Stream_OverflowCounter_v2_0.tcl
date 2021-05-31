
# Definitional proc to organize Coarse Extension Core widgets for parameters.
source [file join [file dirname [file dirname [info script]]] package_ip/customization_gui/init_OC_gui.tcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {

	ipgui::add_param $IPINST -name "Component_Name"

	set Page "Overflow Counter"
	init_OC_gui $IPINST $Page

}

source [file join [file dirname [file dirname [info script]]] package_ip/customization_gui/set_OC_gui.tcl]
