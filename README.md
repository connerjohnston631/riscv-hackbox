This is a mod to a previous stable rocket-chip with the RoCC attached.

The provided AccumulatorExample has been hacked and now serves as a
user-defined sized memory for initializing a function of the user's 
choosing. Other mods will hopefully be available soon, as well as increased
flexibility of this mod. Verilog accelerators plugged into the RoCC
will have to conform the Accelerator interface, but should allow for 
quick plugging in and prototyping. To start, put your verilog into the 
/hackbox/rocket/src/main/verilog/ folder and modify it to the specifications
of the README provided.
