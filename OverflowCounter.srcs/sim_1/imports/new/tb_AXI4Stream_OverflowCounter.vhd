-------------------------------------------------------------------------------------------------------------------------
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


---------------------------------- DESCRIPTION -----------------------------------
----------------------------------------------------------------------------------
--				  Simulation of AXI4Stream_OverflowCounter			     		--
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






ENTITY tb_AXI4Stream_OverflowCounter IS
END tb_AXI4Stream_OverflowCounter;

ARCHITECTURE Behavioral OF tb_AXI4Stream_OverflowCounter IS

	--------------------- CONSTANTS NON IN PACKAGE -----------------------------

	---------------- Timing -------------------
	constant	CLK_PERIOD 	: time := 10 ns;
	constant	RESET_WAIT 	: time := 100 ns;

	constant	VALID_WAIT 	: time := 2*CLK_PERIOD;
	--------------------------------------------


	-------------- Calibrated Timestamp Dimension --------------
	constant BIT_FID             : NATURAL                         := 2;                -- Function ID of the Belt Bus 0 = OVERFLOW Coarse, 1 = MEASURE, If BIT_FID = 0 the Belt Bus is removed and it is a standard axi4 stream
	constant BIT_COARSE          : NATURAL     RANGE   0   TO  32  := 8;				-- Bit of Coarse Counter, if 0 not Coarse Counter is considered only Fine
	constant BIT_RESOLUTION      : POSITIVE    RANGE   1   TO  32  := 16;				-- Number of Bits of Calibrated TDL
	---------------------------------------------


	----------------------------------------------

	----------------------------------------------------------------------------



	---------------------- COMPONENTS DECLARATION (DUT) -------------------------

	----- AXI4Stream_OverflowCounter -----
	COMPONENT AXI4Stream_OverflowCounter
		generic (

			------------ Calibrated Timestamp Dimension  --------------
		    BIT_FID				:	NATURAL							:=	0;			        -- Function ID of the Belt Bus 0 = OVERFLOW Coarse, 1 = MEASURE, If BIT_FID = 0 the belt bus is removed and it is a standard axi4 stream
		    BIT_COARSE			:	NATURAL		RANGE	0   TO	32	:=	8;					-- Bit of Coarse Counter, If 0 not Coarse counter is considered only Fine
	     	BIT_RESOLUTION      :	POSITIVE	RANGE	1	TO	32	:=	16					-- Number of Bits of the Calibrated_TDL
		    ----------------------------------------------
	    );

	    port(

		    ------------------ Reset/Clock ---------------
		    --------- Reset --------
			reset   : IN    STD_LOGIC;														              			--  Asynchronous system reset active '1'
		    ------------------------

		    --------- Clocks -------
		 	clk     : IN    STD_LOGIC;			 																	-- System clock
		    ------------------------
		    ----------------------------------------------

		    --------------- Timestamp Input ---------------
			s00_timestamp_tvalid	:	IN	STD_LOGIC;																-- Valid Timestamp
			s00_timestamp_tdata		:	IN	STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0); 	-- Timestamp dFID + COARSE + RESOLUTION
		    -----------------------------------------------

		    ------------ BeltBus Output --------------
			m00_beltbus_tvalid	:	OUT	STD_LOGIC;																	-- Valid Belt Bus
			m00_beltbus_tdata	:	OUT	STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0) 			-- Belt Bus
		    -------------------------------------------

		);
	END COMPONENT;
	-----------------------------------------------


	----------------------------------------------------------------------------



	---------------------------- SIGNALS DECLARATION ----------------------------

	------------------ Reset/Clock ---------------
	--------- Reset --------
	signal	reset                   :  STD_LOGIC;																	-- Asynchronous system reset active '1'
	------------------------

	--------- Clocks -------
	signal	clk                     :  STD_LOGIC	:=	'1'; 														-- System clock
	------------------------
	----------------------------------------------


	-------------------- Timestamp Input ------------------
	signal	s00_timestamp_tvalid	:  STD_LOGIC;																	-- Valid Timestamp
	signal	s00_timestamp_tdata	    :  STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 downto 0);			-- Timestamp dFID + COARSE + RESOLUTION
	-------------------------------------------------------

	-------------------- BeltBus Output -----------------
	signal	m00_beltbus_tvalid   	:  STD_LOGIC;																	-- Valid Belt Bus
	signal	m00_beltbus_tdata	    :  STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 downto 0);		    -- Belt Bus
	-----------------------------------------------------

	----------------------------------------------------------------------------


BEGIN




	--------------------- COMPONENTS DUT INSTANTIATIONS -----------------------


	----- AXI4Stream_OverflowCounter -----
	dut_AXI4Stream_OverflowCounter	:	AXI4Stream_OverflowCounter
		generic map(

			-------- Calibrated Timestamp Dimension ------
			BIT_FID	          =>  BIT_FID,
			BIT_COARSE        =>  BIT_COARSE,
			BIT_RESOLUTION    =>  BIT_RESOLUTION
			----------------------------------------------
		)
		port map(
			------------------ Reset/Clock ---------------
			--------- Reset --------
			reset             =>  reset,
			------------------------

			--------- Clocks -------
			clk               =>  clk,
			------------------------
			----------------------------------------------


			--------------- Timestamp Input --------------
			s00_timestamp_tvalid	=>	s00_timestamp_tvalid,
			s00_timestamp_tdata	    =>	s00_timestamp_tdata,
			----------------------------------------------

			----------------- BeltBus Output -------------
			m00_beltbus_tvalid  	=>	m00_beltbus_tvalid,
			m00_beltbus_tdata   	=>	m00_beltbus_tdata
			----------------------------------------------

		);
	-----------------------------------------------


	-----------------------------------------------------------------------------


	--------------------------------- PROCESS ----------------------------------


	-- ------ Clock Process --------
	-- clk_process :process
	-- begin
	-- 	clk <= '0';
	-- 	wait for CLK_PERIOD/2;
	-- 	clk <= '1';
	-- 	wait for CLK_PERIOD/2;
	-- end process;
	-- ----------------------------
	clk	<=	not	clk	after	 CLK_PERIOD/2;


	----- Reset Process --------
	sim_process :process
	begin
		reset <= '1';
		wait for RESET_WAIT;

		reset <= '0';
		wait for RESET_WAIT;

		for i in 0 to 10 loop

			s00_timestamp_tvalid	<= '1';
			s00_timestamp_tdata	    <= std_logic_vector(to_unsigned(i,s00_timestamp_tdata'LENGTH));                                                         -- Simulation with FID = 0 (Overflow)
			wait for CLK_PERIOD;

			s00_timestamp_tvalid	<= '0';
			wait for VALID_WAIT-CLK_PERIOD;

			s00_timestamp_tvalid    <= '1';
			s00_timestamp_tdata     <= std_logic_vector(to_unsigned(1,BIT_FID)) & std_logic_vector(to_unsigned(i,s00_timestamp_tdata'LENGTH - BIT_FID));    -- Simulation with FID = 1 (Measure)
			wait for CLK_PERIOD;

			s00_timestamp_tvalid    <= '0';
			wait for VALID_WAIT-CLK_PERIOD;

		end loop;


		wait;

	end process;
	----------------------------

	----------------------------------------------------------------------------




END Behavioral;
