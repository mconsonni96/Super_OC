
# =========================== SET PATH =========================================
#set path [pwd]
#regsub -all {(.)/logs} $path {\1} path

#append path "/Utility_Ip_Core/ip_repo/TDC_Basic_IPs/calibrator/package_ip"

# set path "/home/nicola/Documents/Vivado/Utility_Ip_Core/ip_repo/TDC_Basic_IPs/synchronizer"
set path "D:/Xilinx_bis/Utility_Ip_Core/ip_repo/overflowcounter_ip/package_ip"
# ==============================================================================


# ============================ Identification ==================================
set vendor "DigiLAB"
set_property vendor $vendor [ipx::current_core]

set library "TDC_Basic_IPs"
set_property library $library [ipx::current_core]

set name "AXI4Stream_OverflowCounter"
set_property name $name [ipx::current_core]

set version "1.0"
set_property version $version [ipx::current_core]

set display_name "AXI4-Stream OverflowCounter"
set_property display_name $display_name [ipx::current_core]

set description "OverflowCounter of the TDC"
set_property description $description [ipx::current_core]

set vendor_display_name "DigiLAB"
set_property vendor_display_name $vendor_display_name [ipx::current_core]

set company_url {https://bitbucket.org/TimeEngineers/oveflowcounter/src/master/}
set_property company_url $company_url [ipx::current_core]

set taxonomy {/TDC_Basic_IPs}
set_property taxonomy $taxonomy [ipx::current_core]
# ==============================================================================



# ========================== Import TCL Functions ==============================
set set_param_fx $path
append set_param_fx "/ip_customization_parameters/set_param_fx.tcl"
source $set_param_fx -notrace
# ==============================================================================

# ====================== SET IP CUSTOMIZATION PARAMIETR ========================
set overflowcounter_param_path [file join $path "ip_customization_parameters"]
#append overflowcounter_param_path "/ip_customization_parameters/"

source [file join $overflowcounter_param_path "set_bit_coarse.tcl"] -notrace
source [file join $overflowcounter_param_path "set_bit_fid.tcl"] -notrace
source [file join $overflowcounter_param_path "set_bit_resolution.tcl"] -notrace

# ==============================================================================
