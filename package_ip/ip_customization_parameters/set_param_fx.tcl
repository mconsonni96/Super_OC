# ====================== SET PARAMETER IN CUSTOMIZATION GUI ====================

# ------------------------ Long Type with Range --------------------------------
proc set_param_long_range {param min max default enablement editable dependency tooltip display_name} \
{

	# Name of the Parameter
	set_property widget {textEdit} [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Type
	set_property value_format long [ipx::get_hdl_parameters $param -of_objects [ipx::current_core]]
	set_property value_validation_type range_long [ipx::get_user_parameters $param  -of_objects [ipx::current_core]]

	# Set Range
	set_property value_validation_range_minimum $min [ipx::get_user_parameters $param -of_objects [ipx::current_core]]
	set_property value_validation_range_maximum $max [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Default
	set_property value $default [ipx::get_hdl_parameters $param -of_objects [ipx::current_core]]
	set_property value $default [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Editable
	set_property enablement_value $enablement [ipx::get_user_parameters $param -of_objects [ipx::current_core]]
	set_property enablement_tcl_expr $editable [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Dependency
	set_property value_tcl_expr $dependency [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Tooltip
	set_property tooltip $tooltip [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Displayed Name
	set_property display_name $display_name [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

}
# ------------------------------------------------------------------------------


# ----------------------- Long Type with list ----------------------------------
proc set_param_long_list {param list default enablement editable dependency tooltip display_name} \
{
	# Name of the Parameter
	set_property widget {comboBox} [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Type
	set_property value_format long [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set List
	set_property value_validation_list $list [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Default
	set_property value $default [ipx::get_hdl_parameters $param -of_objects [ipx::current_core]]
	set_property value $default [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Editable
	set_property enablement_value $enablement [ipx::get_user_parameters $param -of_objects [ipx::current_core]]
	set_property enablement_tcl_expr $editable [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Dependency
	set_property value_tcl_expr $dependency [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Tooltip
	set_property tooltip $tooltip [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Displayed Name
	set_property display_name $display_name [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]
}
# ------------------------------------------------------------------------------

# ---------------------- Bool Type (Boolean) -----------------------------------
proc set_param_bool {param default enablement editable dependency tooltip display_name} \
{
	# Name of the Parameter
	set_property widget {checkBox} [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Type
	set_property value_format bool [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Default
	set_property value $default [ipx::get_hdl_parameters $param -of_objects [ipx::current_core]]
	set_property value $default [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Editable
	set_property enablement_value $enablement [ipx::get_user_parameters $param -of_objects [ipx::current_core]]
	set_property enablement_tcl_expr $editable [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Dependency
	set_property value_tcl_expr $dependency [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Tooltip
	set_property tooltip $tooltip [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Displayed Name
	set_property display_name $display_name [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]
}
# ------------------------------------------------------------------------------

# ----------------------- List Type (String) -----------------------------------
proc set_param_string_list {param list default enablement editable dependency tooltip display_name} \
{
	# Name of the Parameter
	set_property widget {comboBox} [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Type
	set_property value_format string [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	set_property value_validation_list $list [ipx::get_user_parameters $param -of_objects [ipx::current_core]]
	set_property enablement_value true [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Default
	set_property value $default [ipx::get_hdl_parameters $param -of_objects [ipx::current_core]]
	set_property value $default [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Editable
	set_property enablement_value $enablement [ipx::get_user_parameters $param -of_objects [ipx::current_core]]
	set_property enablement_tcl_expr $editable [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Dependency
	set_property value_tcl_expr $dependency [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Tooltip
	set_property tooltip $tooltip [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Displayed Name
	set_property display_name $display_name [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]
}
# ------------------------------------------------------------------------------



# ----------------------- Text Type (String) -----------------------------------
proc set_param_string_text {param default enablement editable dependency tooltip display_name} \
{
	# Name of the Parameter
	set_property widget {textBox} [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Type
	set_property value_format string [ipx::get_user_parameters $param -of_objects [ipx::current_core]]


	# Set Default
	set_property value $default [ipx::get_hdl_parameters $param -of_objects [ipx::current_core]]
	set_property value $default [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Editable
	set_property enablement_value $enablement [ipx::get_user_parameters $param -of_objects [ipx::current_core]]
	set_property enablement_tcl_expr $editable [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Dependency
	set_property value_tcl_expr $dependency [ipx::get_user_parameters $param -of_objects [ipx::current_core]]

	# Set Tooltip
	set_property tooltip $tooltip [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]

	# Set Displayed Name
	set_property display_name $display_name [ipgui::get_guiparamspec -name $param -component [ipx::current_core] ]
}
# ------------------------------------------------------------------------------


# ==============================================================================
