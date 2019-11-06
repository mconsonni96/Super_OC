# OverflowCounter
This is a Vivado 2017.3 Project, used to counting the number of Overflow which occur in the timestamps coming from the TDC.
The input of the OverflowCounter is a AXI4 Stream interface consisting of a Valid and a Data channel, *s00_timestamp_tvalid* and *s00_timestamp_tdata*.
The output depends on the value of the most significant bits(*FID*) of the input.
The timestamps in output of the OverflowCounter is an AXI4 Stream interface.


# Sources
We can find in *"OverflowCounter/OverflowCounter.scrs/sources_1"* the following module directory:

 - **AXI4Stream_OverflowCounter**: Wrapper used for rename the input and output interfaces with AXI4-Stream, input as slave and output as a master.
 - **AXI4Stream_OverflowCounterWrapper**: Wrapper used for rename the input and output interfaces with presudo AXI4-Stream, input as slave and output as a master.
 - **OverflowCounter**: Count the number of Overflow in the input data(*s00_timestamp_tdata*).


## AXI4Stream_OverflowCounter
Wrapping of OverflowCounter for AXI4-Stream interface.

### Generic

 - **BIT_FID**: Bit Dimension of the Fid part of the Timestamp, *NATURAL* type. If *BIT_FID = 0* the belt bus is removed and it is a standard axi4 stream.
 - **BIT_COARSE**: Bit Dimension of the Coarse part of the Timestamp, *NATURAL* type *RANGE 0 TO 32*.
 - **BIT_RESOLUTION**: Bit Dimension of the Fine part of the Timestamp, *POSITIVE* type *RANGE 1 TO 32*.

### Port

 - **reset**: Asynchronous system reset active high (if '1' goto reset state).

 - **clk**: System clock.

 - **s00_timestamp**: AXI4 Stream Slave (Input) interface, uncalibrated data coming from the previous module().
     - **s00_timestamp_tvalid**: Valid of the input data, *STD_LOGIC* type.
     - **s00_timestamp_tdata**: Input data (timestamp) padded to upper byte dimension, *STD_LOGIC_VECTOR((((BIT_FID + BIT_COARSE + BIT_RESOLUTION-1)/8+1)* * *8)-1 DOWNTO 0)* type, used only *STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 downto 0)* type.

 - **m00_beltbus**: AXI4 Stream master (Output) interface, containing the value of the input data (*s00_timestamp_tdata*) or the number of Overflow depending on the value of the FID.
     - **m00_beltbus_tvalid**: Valid of the output data, *STD_LOGIC* type.
     - **m00_beltbus_tdata**: Output data with the proper FID padded to upper byte dimension *STD_LOGIC_VECTOR((((BIT_FID + BIT_COARSE + BIT_RESOLUTION-1)/8+1)* * *8)-1 DOWNTO 0)* type, used only *STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 downto 0)* type.

The module instantiates the *OverflowCounter*, set to '0' the MSBs of the output data (*m00_beltbus_tdata(m00_beltbus_tdata'LENGTH-1 downto BIT_FID + BIT_COARSE + BIT_RESOLUTION)*) and rename the input and output interfaces with AXI4-Stream, input as slave and output as master.


## AXI4Stream_OverflowCounterWrapper
Wrapping of OverflowCounter for AXI4-Stream interface.

### Generic

 - **BIT_FID**: Bit Dimension of the Fid part of the Timestamp, *NATURAL* type. If *BIT_FID = 0* the belt bus is removed and it is a standard axi4 stream.
 - **BIT_COARSE**: Bit Dimension of the Coarse part of the Timestamp, *NATURAL* type *RANGE 0 TO 32*.
 - **BIT_RESOLUTION**: Bit Dimension of the Fine part of the Timestamp, *POSITIVE* type *RANGE 1 TO 32*.

### Port

 - **reset**: Asynchronous system reset active high (if '1' goto reset state).

 - **clk**: System clock.

 - **s00_timestamp**: AXI4 Stream Slave (Input) interface, uncalibrated data coming from the previous module().
     - **s00_timestamp_tvalid**: Valid of the input data, *STD_LOGIC* type.
     - **s00_timestamp_tdata**: Input data (timestamp) padded to upper byte dimension, *STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0)* type, used only *STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 downto 0)* type.

 - **m00_beltbus**: AXI4 Stream master (Output) interface, containing the value of the input data (*s00_timestamp_tdata*) or the number of Overflow depending on the value of the FID.
     - **m00_beltbus_tvalid**: Valid of the output data, *STD_LOGIC* type.
     - **m00_beltbus_tdata**: Output data with the proper FID padded to upper byte dimension *STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 DOWNTO 0)* type, used only *STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 downto 0)* type.


#OverflowCounter
Count the number of Overflow and send it in output depending on the value of the FID.

### Generic

 - **BIT_FID**: Bit Dimension of the Fid part of the Timestamp, *NATURAL* type. If *BIT_FID = 0* the belt bus is removed and it is a standard axi4 stream.
 - **BIT_COARSE**: Bit Dimension of the Coarse part of the Timestamp, *NATURAL* type *RANGE 0 TO 32*.
 - **BIT_RESOLUTION**: Bit Dimension of the Fine part of the Timestamp, *POSITIVE* type *RANGE 1 TO 32*.

### Port

 - **reset**: Asynchronous system reset active high (if '1' goto reset state).

 - **clk**: System clock.

 - **timestamp_tvalid**: Valid of the input data, *STD_LOGIC* type.
 - **timestamp_tdata**: Input data (timestamp), *STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 downto 0)* type.

 - **beltbus_tvalid**: Valid of the output data, *STD_LOGIC* type.
 - **beltbus_tdata**: Output data, *STD_LOGIC_VECTOR(BIT_FID + BIT_COARSE + BIT_RESOLUTION-1 downto 0)* type.


If *BIT_FID = 0* the Belt Bus is removed and the output is a standard Axi4 Stream. In this case the module is trasparent and the input is transferred unchanged to the output (*beltbus_tvalid <= timestamp_tvalid*, *beltbus_tdata <= timestamp_tdata*). Morover the Counter of Overflow(*CoarseOverflow_cnt*) is not enabled.
If *BIT_FID /= 0* and *timestamp_tvalid = '1'*, the output corresponds exactly to the input (*beltbus_tdata <= timestamp_tdata*) if you have a measure (*fid = '1'*), otherwise if you have an Overflow (*fid = 0*) the *CoarseOverflow_cnt* is increased by one and the output contains the *fid* & *CoarseOverflow_cnt*.


![InputOutput Image](OverflowCounter.doc/InputOutput.svg)


# Simulation
We can find in *"OverflowCounter/OverflowCounter.scrs/sim_1"* the following module directory:

 - **tb_AXI4Stream_OverflowCounter**: HDL simulation of *AXI4Stream_OverflowCounter*.
 - **tb_AXI4Stream_OverflowCounter_behav**: Waveform of *tb_AXI4Stream_OverflowCounter*.


![wave Image](OverflowCounter.doc/wave.png)
