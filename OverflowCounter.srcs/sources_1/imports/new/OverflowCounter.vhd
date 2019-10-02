------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
--                                                                                                                     --
--  __/\\\\\\\\\\\\\\\__/\\\\\\\\\\\\\\\__/\\\\\\\\\\\\_____/\\\\\\\\\\\__/\\\\\\\\\\\\\\\__/\\\_____________          --
--   _\///////\\\/////__\/\\\///////////__\/\\\////////\\\__\/////\\\///__\/\\\///////////__\/\\\_____________         --
--    _______\/\\\_______\/\\\_____________\/\\\______\//\\\_____\/\\\_____\/\\\_____________\/\\\_____________        --
--     _______\/\\\_______\/\\\\\\\\\\\_____\/\\\_______\/\\\_____\/\\\_____\/\\\\\\\\\\\_____\/\\\_____________       --
--      _______\/\\\_______\/\\\///////______\/\\\_______\/\\\_____\/\\\_____\/\\\///////______\/\\\_____________      --
--       _______\/\\\_______\/\\\_____________\/\\\_______\/\\\_____\/\\\_____\/\\\_____________\/\\\_____________     --
--        _______\/\\\_______\/\\\_____________\/\\\_______/\\\______\/\\\_____\/\\\_____________\/\\\_____________	   --
--         _______\/\\\_______\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\\/____/\\\\\\\\\\\_\/\\\\\\\\\\\\\\\_\/\\\\\\\\\\\\\\\_   --
--          _______\///________\///////////////__\////////////_____\///////////__\///////////////__\///////////////__  --
--                                                                                                                     --
-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

------------------------------------ DESCRIPTION ---------------------------------
----------------------------------------------------------------------------------
--					Overflow Counter in Timestamp AXI4 Stream					--
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------


---------- DEFAULT LIBRARY ---------
library IEEE;
	use IEEE.STD_LOGIC_1164.all;
	use IEEE.NUMERIC_STD.ALL;
	--use IEEE.MATH_REAL.all;

-- library STD;
	-- 	use STD.textio.all;
------------------------------------


---------- OTHERS LIBRARY ----------

-- library UNISIM;
-- 	use UNISIM.VComponents.all;

-- library xpm;
-- 	use xpm.vcomponents.all;


-- library work;

------------------------------------





entity OverflowCounter is

	generic (

		---------- Calibrated Timestamp Dimension ----
	    BIT_FID				:	NATURAL							:=	0;			        -- Function ID of the Belt Bus 0 = OVERFLOW Coarse, 1 = MEASURE, If BIT_FID = 0 the belt bus is removed and it is a standard axi4 stream
		BIT_COARSE			:	NATURAL		RANGE	0   TO	32	:=	8;					-- Bit of Coarse Counter, If 0 not Coarse counter is considered only Fine
		BIT_RESOLUTION      :	POSITIVE	RANGE	1	TO	32	:=	16					-- Number of Bits of the Calibrated_TDL
		----------------------------------------------
	);

	port(

		------------------ Reset/Clock ---------------
		--------- Reset --------
		reset   : IN    STD_LOGIC;														                        --  Asynchronous system reset active '1'
		------------------------

		--------- Clocks -------
		clk     : IN    STD_LOGIC;			 											                        -- System clock
		------------------------
		----------------------------------------------

		--------------- Timestamp Input ---------------
		timestamp_tvalid	:	IN	STD_LOGIC;															    	-- Valid Timestamp
		timestamp_tdata		:	IN	STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0); 	    -- Timestamp dFID + COARSE + RESOLUTION
		-----------------------------------------------

		--------------- BeltBus Output ----------------
	    beltbus_tvalid	   :	OUT	STD_LOGIC;															    	-- Valid Belt Bus
		beltbus_tdata	   :	OUT	STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0) 	    	-- Belt Bus
		-----------------------------------------------

	);

end OverflowCounter;

architecture Behavioral of OverflowCounter is

	------------------------- CONSTANTS DECLARATION ----------------------------

	------- Coarse Counter OverFlow Manage -------
	constant	BIT_OVERFLOW_CNT	:	POSITIVE	:=	BIT_COARSE + BIT_RESOLUTION;
	----------------------------------------------

	----------- FID of the BeltBus --------------
	constant	FID_OVERFLOW	:	STD_LOGIC_VECTOR(BIT_FID-1 downto 0)	:=									-- 0
		std_logic_vector(
			to_unsigned(
				0,
				BIT_FID
			)
		);

	constant	FID_MEASURE		:	STD_LOGIC_VECTOR(BIT_FID-1 downto 0)	:=   								-- 1
		std_logic_vector(
			to_unsigned(
				1,
				BIT_FID
			)
		);
	---------------------------------------------
	----------------------------------------------------------------------------


	----------------------------- ALIAS DECLARATIONS ---------------------------
	----------- FID of the BeltBus --------------
	alias fid	:	STD_LOGIC_VECTOR(BIT_FID-1 DOWNTO 0) is timestamp_tdata(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO BIT_COARSE + BIT_RESOLUTION);
	----------------------------------------------
	----------------------------------------------------------------------------



	-------------------------- SIGNALS DECLARATION -----------------------------
	------- Coarse Counter OverFlow Manage -------
	signal	CoarseOverflow_cnt	:	UNSIGNED(BIT_OVERFLOW_CNT-1 downto 0);										-- Overflow Counter
	----------------------------------------------
	----------------------------------------------------------------------------

begin

	------------------------- SYNCHRONOUS PROCESS --------------------------------


	------------- Sampling the CNT ----------
	OverflowCNT : process (clk, reset)
	begin

		-- BeltBus with Overflow Counter
		if BIT_FID /= 0 then

			if (reset = '1') then
				beltbus_tvalid	<=	'0';
				CoarseOverflow_cnt	<=	(Others => '0');

			elsif rising_edge (clk) then

				beltbus_tvalid	<=	timestamp_tvalid;

				if timestamp_tvalid = '1' then

					if fid = FID_MEASURE then
						beltbus_tdata	<=	timestamp_tdata;

					elsif fid = FID_OVERFLOW then
						CoarseOverflow_cnt	<=	CoarseOverflow_cnt +1;
						beltbus_tdata	<=	fid & std_logic_vector(CoarseOverflow_cnt +1);

					end if;

				end if;

			end if;
		-----------------------------------

		-- No BeltBus No Overflow Counter --
		else

			beltbus_tvalid	<=	timestamp_tvalid;
			beltbus_tdata	<=	timestamp_tdata;

		end if;
		-----------------------------------


	end process;
	-----------------------------------------

	----------------------------------------------------------------------------




end Behavioral;
