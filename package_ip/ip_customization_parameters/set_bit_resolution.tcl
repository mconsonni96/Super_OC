
# Number of Bits of the Calibrated_TDL
# BIT_RESOLUTION	:	POSITIVE	RANGE	1	TO	32	:=	16

# --------------- BIT_RESOLUTION ---------------
set MIN_BIT_RESOLUTION 1
set MAX_BIT_RESOLUTION 32
set DEFAULT_BIT_RESOLUTION 16

set enablement {True}
set editable {}

set dependency {}

set tooltip "Bit used for the fine part of the timestamp"
set display_name "Bit Resolution"

set_param_long_range "BIT_RESOLUTION" $MIN_BIT_RESOLUTION $MAX_BIT_RESOLUTION $DEFAULT_BIT_RESOLUTION $enablement $editable $dependency $tooltip $display_name
# ----------------------------------------------
