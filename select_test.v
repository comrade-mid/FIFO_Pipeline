`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:55:23 05/15/2019
// Design Name:   select_FSM
// Module Name:   C:/Users/Nathan/Desktop/CMPE 125L/lab4/select_test.v
// Project Name:  lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: select_FSM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module select_test;

	// Inputs
	reg shift_in;
	reg shift_out;
	reg prev_full;
	reg next_full;
	reg now_full;
	reg clk = 0;
	reg [4:0] stuff = 5'd0;
	// Outputs
	wire [1:0] sel;

	// Instantiate the Unit Under Test (UUT)
	fifo_g uut (
		.sel(sel), 
		.shift_in(shift_in), 
		.shift_out(shift_out), 
		.prev_full(prev_full), 
		.next_full(next_full), 
		.now_full(now_full), 
		.clk(clk)
	);
	always #5 clk = ~clk;
	always #100 stuff = stuff + 1;
	always #100 {shift_in, shift_out, now_full, next_full, prev_full} = stuff;
	initial begin
		// Initialize Inputs
		//clk = 0;

		// Wait 100 ns for global reset to finish
      
		// Add stimulus here

	end
      
endmodule

