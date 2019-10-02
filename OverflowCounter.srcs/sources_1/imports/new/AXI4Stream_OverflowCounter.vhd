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
--					Wrapper of Overflow Counter in Timestamp AXI4 Stream					--
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





entity AXI4Stream_OverflowCounter is

	generic (

		---------- Calibrated Timestamp Dimension ----
	    BIT_FID				:	NATURAL							:=	1;			        -- Function ID of the Belt Bus 0 = OVERFLOW Coarse, 1 = MEASURE, If BIT_FID = 0 the belt bus is removed and it is a standard axi4 stream
		BIT_COARSE			:	NATURAL		RANGE	0   TO	32	:=	8;					-- Bit of Coarse Counter, If 0 not Coarse counter is considered only Fine
		BIT_RESOLUTION      :	POSITIVE	RANGE	1	TO	32	:=	16					-- Number of Bits of the Calibrated_TDL
		----------------------------------------------
	);

	port(

		------------------ Reset/Clock ---------------
		--------- Reset --------
		reset   : IN    STD_LOGIC;														                                        --  Asynchronous system reset active '1'
		------------------------

		--------- Clocks -------
		clk     : IN    STD_LOGIC;			 											                                        -- System clock
		------------------------
		----------------------------------------------

		--------------- Timestamp Input ---------------
		s00_timestamp_tvalid	:	IN	STD_LOGIC;																                -- Valid Timestamp
		s00_timestamp_tdata		:	IN	STD_LOGIC_VECTOR((((BIT_FID + BIT_COARSE + BIT_RESOLUTION-1)/8+1)*8)-1 DOWNTO 0);   	-- Timestamp dFID + COARSE + RESOLUTION
		-----------------------------------------------

		--------------- BeltBus Output ----------------
		m00_beltbus_tvalid	   :	OUT	STD_LOGIC;																                -- Valid Belt Bus
		m00_beltbus_tdata	   :	OUT	STD_LOGIC_VECTOR((((BIT_FID + BIT_COARSE + BIT_RESOLUTION-1)/8+1)*8)-1 DOWNTO 0) 		-- Belt Bus
		-----------------------------------------------

	);

end AXI4Stream_OverflowCounter;

architecture Behavioral of AXI4Stream_OverflowCounter is


	--------------------- Components Declaration ---------------------

	COMPONENT OverflowCounter
		generic (

			---------- Calibrated Timestamp Dimension ----
		    BIT_FID				:	NATURAL							:=	1;			        -- Function ID of the Belt Bus 0 = OVERFLOW Coarse, 1 = MEASURE, If BIT_FID = 0 the belt bus is removed and it is a standard axi4 stream
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
			timestamp_tvalid	:	IN	STD_LOGIC;															        -- Valid Timestamp
			timestamp_tdata		:	IN	STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0); 	    -- Timestamp dFID + COARSE + RESOLUTION
			-----------------------------------------------

			--------------- BeltBus Output ----------------
		    beltbus_tvalid	   :	OUT	STD_LOGIC;															    	-- Valid Belt Bus
			beltbus_tdata	   :	OUT	STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0)	    	-- Belt Bus
			-----------------------------------------------

		);

	END COMPONENT;


begin

	------------------ Components instantiation --------------------


	---------- OverflowCounter -----------
	Inst_OverflowCounter : OverflowCounter
		GENERIC MAP (

			---------- Calibrated Timestamp Dimension ----
			BIT_FID			=>	BIT_FID,
			BIT_COARSE   	=>	BIT_COARSE,

			BIT_RESOLUTION	=>	BIT_RESOLUTION
			--------------------

		)
		PORT MAP(

			------ Reset ------
			reset	=> reset,
			-------------------

			------ Clocks ------
			clk		=> clk,
			--------------------

			--------------- Timestamp Input ---------------
			timestamp_tvalid	=> s00_timestamp_tvalid,
			timestamp_tdata		=> s00_timestamp_tdata(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0),
			-----------------------------------------------

			--------------- BeltBus Output ----------------
			beltbus_tvalid	    => m00_beltbus_tvalid,
			beltbus_tdata		=> m00_beltbus_tdata(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0)
			-----------------------------------------------
		);
	---------------------------------


	------------------------------------------------------------------

	------------------------------ DATA FLOW ------------------------------
	----- Zero Padding of the AXI4-Stream ------
	m00_beltbus_tdata(m00_beltbus_tdata'LENGTH-1 downto BIT_FID + BIT_COARSE + BIT_RESOLUTION) <= (others => '0');
	---------------------------------------------
	----------------------------------------------------------------------

end Behavioral;
