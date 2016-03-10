module myverilog(
	input [63: 0] io_in_0,
	input [63: 0] io_in_1,
	input [63: 0] io_in_2,
	output [63: 0] io_out
);

	assign out = io_in_0 + (io_in_1 * io_in_2);
endmodule

