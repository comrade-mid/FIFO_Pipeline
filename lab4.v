`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:51:08 05/12/2019 
// Design Name: 
// Module Name:    lab4 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define DEPTH 4
`define WIDTH 32

module lab4 (input gclk);
	wire shift_in = 1'b0;
	wire shift_out = 1'b0;
   wire reset = 1'b0;
	wire full, empty;
	wire [`WIDTH-1:0] data_in = 32'd1;
	wire [`WIDTH-1:0] data_out;

	FIFO #(.DATA(`WIDTH), .SIZE(`DEPTH)) fifo  ( .data_out(data_out),
																.empty(empty),
																.full(full),
																 .shift_in(shift_in), 
																 .shift_out(shift_out), 
																 .reset(reset),
																 .data_in(data_in),
																 .clk(gclk)
																 );

endmodule

module FIFO #(parameter DATA = 32, SIZE = 5) (output [DATA-1:0] data_out, 
                                                    output            empty, 
                                                    output            full,
                                                    input  [DATA-1:0] data_in, 
                                                    input             shift_in, 
                                                    input             shift_out, 
                                                    input             reset,
                                                    input             clk);	
	wire [SIZE-1:0] curr_full;
	wire [(SIZE*DATA)-1:0] data_prev, data_keep, data_done;
	wire [(2*SIZE-1):0] sel_OUT;
	wire check;
	
	assign check = |({data_out, data_done[DATA-2:0]});
	assign full = &({data_out, data_done[DATA-2:0]});
	assign empty = ~check;
	
	fifo_g fifo_stages [SIZE-1:0] (
											.sel			(sel_OUT), 
											.shift_in	({(SIZE){shift_in}}), 
											.shift_out	({(SIZE){shift_out}}), 
											.prev_full	({{curr_full[SIZE-1:1]}, {1'b0}}), 
											.next_full	({{{1'b1}, {curr_full[SIZE-1:1]}}}), 
											.now_full	({{curr_full}}), 
											.clk			({(SIZE){clk}}),
											.reset		({(SIZE){reset}})
											
											);
											
	
	which_data #(.DATA(DATA)) selector_choice [SIZE-1:0](
																	.reset		({(SIZE){reset}}), 
																	.data_out	({data_done[(SIZE*DATA)-1:0]}), 
																	.data_prev	({data_done[(SIZE*DATA)-1:DATA], {DATA{1'bx}}}),
																	.data_in		({(SIZE){data_in}}), 
																	.data_keep	({data_done[(SIZE*DATA)-1:0]}),
																	.sel			(sel_OUT),
																	.clk			({(SIZE){clk}})
												
														);
	
	
	cellFull f_module [SIZE-1:0](
	
												  .oc_curr_out					(curr_full),
												  .sel							(sel_OUT),
												  .oc_curr_in					(curr_full),
												  .oc_prev						({{curr_full[SIZE-1:1]}, {1'b0}}),
												  .res							({(SIZE){reset}}),
												  .clk							({(SIZE){clk}})
									 
									 );
									 
	assign data_out = data_done[(SIZE*DATA)-1:(SIZE*DATA)-DATA];
	
endmodule

/*
module fifo_stage #(parameter DATA = 32) (data_out, data_prev,data_in, data_keep,sel,clk);
	input [DATA-1:0] data_prev, data_in, data_keep;
	input [1:0] sel;
	input clk;
	reg [DATA-1:0] value;
	output reg [DATA-1:0] data_out;
	
	always @(*) begin
		casez(sel)
			2'b00: value = data_keep;
			2'b01: value = data_in;
			2'b11: value = data_prev;
			default: value = data_keep;
		endcase
	end
	
	always @(posedge clk)begin
		data_out <= value;
	end

endmodule


module select_FSM (sel, shift_in, shift_out, prev_full, next_full, now_full, clk);
	input shift_in, shift_out, prev_full, next_full, now_full, clk;
	output reg [1:0] sel;
	reg [1:0] next;
	parameter HOLD = 2'd0;
	parameter S_IN = 2'd1;
	parameter S_OUT = 2'b11;
	
	always @(*) begin
		casez({shift_in, shift_out, now_full, next_full, prev_full})
			
			// Shift_IN Logic, aka Data_Input
			5'b10010: next = S_IN;
			5'b10000: next = S_IN;
			5'b111?0: next = S_IN;
			
			// Shift Out Logic, aka Data_Previous
			5'b111?1: next = S_OUT;
			5'b011?1: next = S_OUT;
			5'b011?0: next = S_OUT;
			
			// Hold Logic, aka Data_Keep or Data_Current
			5'b001??: next = HOLD;
			5'b??0?1: next = HOLD;
			5'b010?1: next = HOLD;
			5'b00???: next = HOLD;
			default: next = HOLD;
		endcase
	end
	
	always @(posedge clk) begin
		sel <= next;
	end
	
endmodule

*/
module cellFull(output reg oc_curr_out,
                input      [1:0]sel,
                input      oc_curr_in,
                input	   oc_prev,
                input      res,
                input      clk);

parameter data_keep = 2'b00;
parameter data_in   = 2'b01;
parameter data_prev = 2'b11;

reg result;

always @ (*) begin
	if (res == 1'b0) begin
        if (sel == data_keep)
            result = oc_curr_in;
        else if (sel == data_prev)
            result = oc_prev;
        else if (sel == data_in)
            result = 1'b1;
        else
            result = 1'b0;
	end
	else
		result = 1'b0;
end

always @ (posedge clk) begin
		oc_curr_out <= result;
end

endmodule


module fifo_g (sel, shift_in, shift_out, prev_full, next_full, now_full, reset, clk);
	input shift_in, shift_out, prev_full, next_full, now_full, reset, clk;
	output reg [1:0] sel;
	reg [1:0] next;
	parameter HOLD = 2'b00;
	parameter S_IN = 2'b01;
	parameter S_OUT = 2'b10;
	parameter RESET = 2'b11;
	
	always @(*) begin
		casez({shift_in, shift_out, now_full, next_full, prev_full, reset})
			// Shift_IN Logic, aka Data_Input
			6'b1001?0: next = S_IN;
			//6'b100000: next = S_IN;
			6'b111?00: next = S_IN;
			
			// Shift Out Logic, aka Data_Previous
			//6'b?1???0: next = S_OUT;
			//6'b?11100: next = S_OUT;
			6'b111?10: next = S_OUT;
			6'b01???0: next = S_OUT;
			//6'b011?00: next = S_OUT;
			
			// Hold Logic, aka Data_Keep or Data_Current
			//6'b001??0: next = HOLD;
			//6'b??0?10: next = HOLD;
			//6'b010000: next = HOLD;
			6'b00???0: next = HOLD;
			6'b101?10: next = HOLD;
			
			//Reset
			6'b?????1: next = RESET;
			
			//Default
			default: next = HOLD;
		endcase
	end
	
	always @(posedge clk) begin
		sel <= next;
	end
	
endmodule

module which_data #(parameter DATA = 32) (clk, reset, data_out, data_prev, data_in, data_keep, sel);

	input [DATA-1:0] data_prev, data_in, data_keep;
	input [1:0] sel;
	input clk, reset;
	output reg [DATA-1:0] data_out;
	
	reg [DATA-1:0] value;
	
	always @(*) begin
		casez(sel)
			2'b00: value = data_keep; 
			2'b01: value = data_in;
			2'b10: value = data_prev;
			2'b11: value = {(DATA){1'bx}};
			default: value = data_keep;
		endcase
	end
	
	always @(posedge clk)begin
		data_out <= value;
	end

endmodule

module LFSR(out, clk);
	input clk;
	output reg [7:0] out;
	reg [7:0]bits = 7'b1000000;
	
	always @ (posedge clk) begin
		bits[0] <= ((bits[7] ^ bits[4]) ^ bits[3]) ^ bits[1];
		bits[7:1] <= bits[6:0];
	end
	
	always @ (*) begin
		out = bits;
	end
endmodule
