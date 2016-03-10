This is is a mod to a previous stable rocket-chip with the RoCC attached.

This project has been built off of the release of the RISCV rocket-chip
project, including all sub-folders, that was on the master branch on
October 4th, 2015. I have not successfully tested the current project 
with RoCC acceleration all the way to the FPGA, but would like to translate
this project when it shows results.

The project will have to be pulled from the repo, the riscv-tools will have
to be built, and all dependencies made dependable, according to the 
rocket-chip and riscv-tools documentation before these files are added to 
the project. Once you have the toolchain assembled and all files in place, 
you can drop the fsim, rocket, and src files in place of the corresponding 
folders in the rocket-chip directory.

The provided AccumulatorExample has been hacked and now serves as a
user-defined sized memory for initializing a function of the user's 
choosing. Verilog accelerators plugged into the RoCC
will have to conform the Accelerator interface, but should allow for 
quick plugging in and prototyping. To start, put your verilog into the 
/hackbox/rocket/src/main/verilog/ folder and modify it to the specifications
of the README provided.
