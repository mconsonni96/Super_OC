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


--------------------------BRIEF MODULE DESCRIPTION -----------------------------
--! \file
--! \brief This is the HDL testbench of the OverflowCounter. In the following figure we see the result of the simulation
--! \image html wave.png  [Waveform image]
--------------------------------------------------------------------------------



----------------------------- LIBRARY DECLARATION ------------------------------

------------ IEEE LIBRARY -----------
--! Standard IEEE library
library IEEE;
	--! Standard Logic Vector library
	use IEEE.STD_LOGIC_1164.all;
	--! Numeric library
	use IEEE.NUMERIC_STD.ALL;
--	--! Math operation over real number (not for implementation)
--	--use IEEE.MATH_REAL.all;
------------------------------------

-- ------------ STD LIBRARY -----------
-- --! Standard
-- library STD;
-- 	--! Textual Input/Output (only in simulation)
-- 	use STD.textio.all;
-- ------------------------------------


-- ---------- XILINX LIBRARY ----------
-- --! Xilinx Unisim library
-- library UNISIM;
-- 	--! Xilinx Unisim VComponent library
-- 	use UNISIM.VComponents.all;
--
-- --! \brief Xilinx Parametric Macro library
-- --! \details To be correctly used in Vivado write auto_detect_xpm into tcl console.
-- library xpm;
-- 	--! Xilinx Parametric Macro VComponent library
-- 	use xpm.vcomponents.all;
-- ------------------------------------


-- ------------ LOCAL LIBRARY ---------
-- --! Project defined libary
-- library work;
-- ------------------------------------

--------------------------------------------------------------------------------





ENTITY tb_AXI4Stream_OverflowCounter IS
END tb_AXI4Stream_OverflowCounter;

ARCHITECTURE Behavioral OF tb_AXI4Stream_OverflowCounter IS

	--------------------- CONSTANTS NON IN PACKAGE -----------------------------

	---------------- Timing -------------------
	constant	CLK_PERIOD 	: time := 10 ns;									--! Period of the testing clock
	constant	RESET_WAIT 	: time := 100 ns;									--! Reset duration

	constant	VALID_WAIT 	: time := 2*CLK_PERIOD;								--! Time to be waited before the valid goes to 1
	--------------------------------------------


	------ Calibrated Timestamp Dimension ------
	constant BIT_FID             : NATURAL                         := 1;                --! Bit Dimension of the Fid part of the Timestamp. If BIT_FID = 0 the belt bus is removed and it is a standard axi4 stream.
	constant BIT_COARSE          : NATURAL     RANGE   0   TO  32  := 8;				--! Bit Dimension of the Coarse part of the Timestamp
	constant BIT_RESOLUTION      : POSITIVE    RANGE   1   TO  32  := 16;				--! Bit Dimension of the Fine part of the Timestamp
	---------------------------------------------

	----------------------------------------------------------------------------



	---------------------- COMPONENTS DECLARATION (DUT) ------------------------

	----- AXI4Stream_OverflowCounter -----
	--! \brief The AXI4Stream_OverflowCounter is the Device Under Test
	COMPONENT AXI4Stream_OverflowCounter
		generic (

			------------ Calibrated Timestamp Dimension  --------------
		    BIT_FID				:	NATURAL							:=	1;			        -- Function ID of the Belt Bus 0 = OVERFLOW Coarse, 1 = MEASURE, If BIT_FID = 0 the belt bus is removed and it is a standard axi4 stream
		    BIT_COARSE			:	NATURAL		RANGE	0   TO	32	:=	8;					-- Bit of Coarse Counter, If 0 not Coarse counter is considered only Fine
	     	BIT_RESOLUTION      :	POSITIVE	RANGE	1	TO	32	:=	16					-- Number of Bits of the Calibrated_TDL
		    ----------------------------------------------
	    );

	    port(

		    ------------------ Reset/Clock ---------------
		    --------- Reset --------
			reset   : IN    STD_LOGIC;														              			                --  Asynchronous system reset active '1'
		    ------------------------

		    --------- Clocks -------
		 	clk     : IN    STD_LOGIC;			 																                	-- System clock
		    ------------------------
		    ----------------------------------------------

		    --------------- Timestamp Input ---------------
			s00_axis_timestamp_tvalid	:	IN	STD_LOGIC;																                -- Valid Timestamp
			s00_axis_timestamp_tdata		:	IN	STD_LOGIC_VECTOR((((BIT_FID + BIT_COARSE + BIT_RESOLUTION-1)/8+1)*8)-1 DOWNTO 0); 	    -- Timestamp dFID + COARSE + RESOLUTION
		    -----------------------------------------------

			-------------- Calibrated Input ---------------
			IsCalibrated		:	IN	STD_LOGIC;																						--! Is '1' if the s00_axis_timestamp is calibrated.
			-----------------------------------------------

		    ------------ BeltBus Output --------------
			m00_axis_beltbus_tvalid	:	OUT	STD_LOGIC;																	                -- Valid Belt Bus
			m00_axis_beltbus_tdata	:	OUT	STD_LOGIC_VECTOR((((BIT_FID + BIT_COARSE + BIT_RESOLUTION-1)/8+1)*8)-1 DOWNTO 0) 			-- Belt Bus
		    -------------------------------------------

		);
	END COMPONENT;
	-----------------------------------------------


	----------------------------------------------------------------------------



	---------------------------- SIGNALS DECLARATION ----------------------------

	------------------ Reset/Clock ---------------
	--------- Reset --------
	signal	reset                   :  STD_LOGIC;																				 --! Asynchronous system reset active '1'
	------------------------

	--------- Clocks -------
	signal	clk                     :  STD_LOGIC	:=	'1'; 														             --! System clock
	------------------------
	----------------------------------------------


	-------------------- Timestamp Input ------------------
	signal	s00_axis_timestamp_tvalid	:  STD_LOGIC;																				 --! Valid Timestamp
	signal	s00_axis_timestamp_tdata	:  STD_LOGIC_VECTOR((((BIT_FID + BIT_COARSE + BIT_RESOLUTION-1)/8+1)*8)-1 DOWNTO 0);		 --! Timestamp FID + COARSE + RESOLUTION
	-------------------------------------------------------

	-------------- Calibrated Input ---------------
	signal	IsCalibrated				:	STD_LOGIC	:=	'0';																	--! Is '1' if the s00_axis_timestamp is calibrated.
	-----------------------------------------------

	-------------------- BeltBus Output -----------------
	signal	m00_axis_beltbus_tvalid   	:  STD_LOGIC;																				 --! Valid Belt Bus
	signal	m00_axis_beltbus_tdata	    :  STD_LOGIC_VECTOR((((BIT_FID + BIT_COARSE + BIT_RESOLUTION-1)/8+1)*8)-1 DOWNTO 0);		 --! Belt Bus
	-----------------------------------------------------

	----------------------------------------------------------------------------


BEGIN




	--------------------- COMPONENTS DUT INSTANTIATIONS -----------------------


	----- AXI4Stream_OverflowCounter -----
	--! \brief Instantiation of the Device Under Test
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
			s00_axis_timestamp_tvalid	=>	s00_axis_timestamp_tvalid,
			s00_axis_timestamp_tdata	=>	s00_axis_timestamp_tdata,
			----------------------------------------------

			-------------- Calibrated Input ---------------
			IsCalibrated				=>	IsCalibrated,
			-----------------------------------------------

			----------------- BeltBus Output -------------
			m00_axis_beltbus_tvalid  	=>	m00_axis_beltbus_tvalid,
			m00_axis_beltbus_tdata   	=>	m00_axis_beltbus_tdata
			----------------------------------------------

		);
	-----------------------------------------------


	-----------------------------------------------------------------------------





	-------------------------------- DATA FLOW ---------------------------------
	------------- Clock Datat Flow ----------------
	clk	<=	not	clk	after	 CLK_PERIOD/2;
	-----------------------------------------------
	----------------------------------------------------------------------------





	------------------------ PROCESS DESCRIPTION ------------------------------


	-- --------------- Clock Process ------------------
	-- clk_process :process
	-- begin
	-- 	clk <= '0';
	-- 	wait for CLK_PERIOD/2;
	-- 	clk <= '1';
	-- 	wait for CLK_PERIOD/2;
	-- end process;
	-- -----------------------------------------------


	------------ Simulation Process ---------------
	--! \vhdlflow [sim_process]

	sim_process :process
	begin
		reset <= '1';
		wait for RESET_WAIT;

		reset <= '0';
		wait for RESET_WAIT;

		for i in 0 to 4 loop

			IsCalibrated	<=	'0';

			s00_axis_timestamp_tvalid	<= '1';
			s00_axis_timestamp_tdata  										<= (Others => '0');
			s00_axis_timestamp_tdata(BIT_COARSE+BIT_RESOLUTION-1 downto 0)	<= std_logic_vector(to_unsigned(i,BIT_COARSE+BIT_RESOLUTION));                 -- Simulation with FID = 0 (Overflow)
			wait for CLK_PERIOD;

			s00_axis_timestamp_tvalid	<= '0';
			wait for VALID_WAIT-CLK_PERIOD;

			s00_axis_timestamp_tvalid    <= '1';
			s00_axis_timestamp_tdata(BIT_FID + BIT_COARSE+BIT_RESOLUTION-1 downto BIT_COARSE+BIT_RESOLUTION)     <= std_logic_vector(to_unsigned(1,BIT_FID));    -- Simulation with FID = 1 (Measure)
			wait for CLK_PERIOD;

			s00_axis_timestamp_tvalid    <= '0';
			wait for VALID_WAIT-CLK_PERIOD;

		end loop;


		for i in 5 to 9 loop

			IsCalibrated	<=	'1';

			s00_axis_timestamp_tvalid	<= '1';
			s00_axis_timestamp_tdata  										<= (Others => '0');
			s00_axis_timestamp_tdata(BIT_COARSE+BIT_RESOLUTION-1 downto 0)	<= std_logic_vector(to_unsigned(i,BIT_COARSE+BIT_RESOLUTION));                 -- Simulation with FID = 0 (Overflow)
			wait for CLK_PERIOD;

			s00_axis_timestamp_tvalid	<= '0';
			wait for VALID_WAIT-CLK_PERIOD;

			s00_axis_timestamp_tvalid    <= '1';
			s00_axis_timestamp_tdata(BIT_FID + BIT_COARSE+BIT_RESOLUTION-1 downto BIT_COARSE+BIT_RESOLUTION)     <= std_logic_vector(to_unsigned(1,BIT_FID));    -- Simulation with FID = 1 (Measure)
			wait for CLK_PERIOD;

			s00_axis_timestamp_tvalid    <= '0';
			wait for VALID_WAIT-CLK_PERIOD;

		end loop;


		wait;

	end process;
	-----------------------------------------------

	----------------------------------------------------------------------------




END Behavioral;
