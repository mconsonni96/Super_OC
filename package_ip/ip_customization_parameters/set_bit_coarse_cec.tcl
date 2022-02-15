# Bit of Coarse Counter, If 0 not Coarse counter is consider only Fine
# BIT_COARSE_CEC		:	NATURAL		RANGE	0	TO	32	:=	8;

# ---------------- BIT_COARSE -----------------
set MIN_BIT_COARSE_CEC 1
set MAX_BIT_COARSE_CEC 32
set DEFAULT_BIT_COARSE_CEC 8

set enablement {True}
set editable {}

set dependency {}

set tooltip "Bit Coarse Counter input dimension"
set display_name "Bit Coarse CEC"

set_param_long_range "BIT_COARSE_CEC" $MIN_BIT_COARSE_CEC $MAX_BIT_COARSE_CEC $DEFAULT_BIT_COARSE_CEC $enablement $editable $dependency $tooltip $display_name
# ----------------------------------------------
