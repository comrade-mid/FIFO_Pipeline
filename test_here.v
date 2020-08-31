`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:06:07 05/18/2019
// Design Name:   lab4
// Module Name:   C:/Users/Nathan/Desktop/CMPE 125L/lab4/test_here.v
// Project Name:  lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: lab4
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////



module test_here;

	// Inputs
	reg gclk = 0;
	reg btnC;
	reg btnR = 0;
	reg btnL;

	// Outputs
	wire [7:0] led;

	// Instantiate the Unit Under Test (UUT)
	lab4 uut (
		.led(led), 
		.gclk(gclk), 
		.btnC(btnC), 
		.btnR(btnR), 
		.btnL(btnL)
	);
	
	
	`define RESET 2'b11
	`define HOLD 2'b00
	`define SHIFT_IN 2'b01
	`define SHIFT_OUT 2'b10
	
	always #5 gclk = ~gclk;
	
	initial 
	
	begin
	
	
	
		// Initialize Inputs
		//gclk = 0;
		btnC = 0;
		//btnR = 0;
		btnL = 0;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#100;
		#10 btnL = ~btnL;
		#10 btnL = ~btnL;
		
		/*
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		// Wait 100 ns for global reset to finish
		
		#100;
		btnR = 1'b0;
		btnL = 1'b1;
		#10 btnL = 1'b0;
		#10 btnL = 1'b1;
		#10 btnL = 1'b0;
		#10 btnL = 1'b1;
		#10 btnL = 1'b0;
		#10 btnL = 1'b1;
		#10 btnL = 1'b0;
		#10 btnL = 1'b1;
		#10 btnL = 1'b0;
		
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		
		#10; 
		btnR = ~btnR;
		btnL = 1'b1;
		#10 btnR = ~btnR;
		#10 btnR = ~btnR;
		#10; 
		btnR = ~btnR;
		btnL = 1'b0;
		#50;
		#10 btnR = ~btnR;
		btnL = 1'b1;
		#100;
		btnL = 1'b0;
		btnR = ~btnR;
		
        
		// Add stimulus here
*/
	end
      
endmodule

