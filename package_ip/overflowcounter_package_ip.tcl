
# =========================== SET PATH =========================================
set path "D:/Xilinx_bis/Utility_Ip_Core/ip_repo/axi4stream_overflowcounter/package_ip"

# ============================ Identification ==================================
set vendor "DigiLAB"
set_property vendor $vendor [ipx::current_core]

set library "ip"
set_property library $library [ipx::current_core]

set name "AXI4Stream_OverflowCounter"
set_property name $name [ipx::current_core]

set version "2.0"
set_property version $version [ipx::current_core]

set display_name "AXI4-Stream Overflow Counter"
set_property display_name $display_name [ipx::current_core]

set description "Belt Bus Overflow Counter of the TDC"
set_property description $description [ipx::current_core]

set vendor_display_name "DigiLAB"
set_property vendor_display_name $vendor_display_name [ipx::current_core]

set company_url {https://bitbucket.org/TimeEngineers/oveflowcounter/src/master/}
set_property company_url $company_url [ipx::current_core]

set taxonomy {/TDC_Basic}
set_property taxonomy $taxonomy [ipx::current_core]
# ==============================================================================

# ========================== Import TCL Functions ==============================
#set path [pwd]
#regsub -all {(.)/logs} $path {\1} path
#append path "/Utility_Ip_Core/ip_repo/TDC_Basic_IPs/axi4-stream-overflow-counter/package_ip"
# ==============================================================================

# ====================== SET IP CUSTOMIZATION PARAMIETR ========================
set param_path $path
append param_path "/ip_customization_parameters/"
source [join [list $param_path "set_param_fx.tcl"] ""] -notrace

source [join [list $param_path "set_bit_coarse.tcl"] ""] -notrace
source [join [list $param_path "set_bit_fid.tcl"] ""] -notrace
source [join [list $param_path "set_bit_resolution.tcl"] ""] -notrace
# ==============================================================================
