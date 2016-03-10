module HackBox(
	input [63: 0] in_0,
	input [63: 0] in_1,
	input [63: 0] in_2,
	output [63: 0] out
);

	assign out = in_0 + (in_1 * in_2);
endmodule

