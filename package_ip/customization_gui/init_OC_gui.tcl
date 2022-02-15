
# Definitional proc to organize widgets for parameters.
proc init_OC_gui { IPINST Page} {

	#Adding Page
	set Page_0 [ipgui::add_page $IPINST -name $Page]
        
        set BIT_FID [ipgui::add_param $IPINST -name "BIT_FID" -parent ${Page_0}]
	set_property tooltip {Bit reserver to the FID of the Belt Bus used to identify properly the timestamps} ${BIT_FID}
        set BIT_COARSE_CEC [ipgui::add_param $IPINST -name "BIT_COARSE_CEC" -parent ${Page_0}]
        set_property tooltip {Bit Coarse Counter input dimension} ${BIT_COARSE_CEC}
	set BIT_COARSE [ipgui::add_param $IPINST -name "BIT_COARSE" -parent ${Page_0}]
        set_property tooltip {Bit Coarse Counter output dimension} ${BIT_COARSE}
	
	set BIT_RESOLUTION [ipgui::add_param $IPINST -name "BIT_RESOLUTION" -parent ${Page_0}]
	set_property tooltip {Bit used for the fine part of the timestamp} ${BIT_RESOLUTION}

}
