# Function ID of the Belt Bus 0 = OVERLOW Coarse, 1 = MEASURE, If 0 no FID is consider
# BIT_FID				:	NATURAL	:=	1;

# ------------------ BIT_FID -------------------
set MIN_BIT_FID 0
set MAX_BIT_FID 4
set DEFAULT_BIT_FID 2

set enablement {True}
set editable {}

set dependency {}

set tooltip "Bit reserver to the FID of the Belt Bus used to identify properly the timestamps"
set display_name "Bit FID"

set_param_long_range "BIT_FID" $MIN_BIT_FID $MAX_BIT_FID $DEFAULT_BIT_FID $enablement $editable $dependency $tooltip $display_name
# ----------------------------------------------
