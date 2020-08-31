`define STAGES 5
`define BITS 32
`define NUM_OF_INPUTS 20

module lab4_random_test;
//	 Files
	parameter FILE_IN = "data_in.txt";
	parameter FILE_TEMP = "data_temp.txt";
	parameter FILE_OUT = "data_out.txt";
	integer infile;
	integer tempfile;
	integer outfile;
	
//	 Inputs
	reg [`BITS-1:0] data_in;
	reg             shift_in = 0;
	reg             shift_out = 0;
	reg             reset = 0;
	reg             clk = 0;

//	 Outputs
	wire  [`BITS-1:0] data_out;
	wire             empty;
	wire             full;
	
//	 intermediate
	integer i = 0;
	integer j = 0;
	integer k = 0;
	reg [`BITS-1:0] rand [0:`NUM_OF_INPUTS-1];
	reg [`BITS-1:0] fileInput [0:`NUM_OF_INPUTS-1];
	
	initial $readmemh(FILE_TEMP, fileInput);

//	 Instantiate the Unit Under Test (UUT)
	pipeline #(.SIZE(`STAGES), .DATA(`BITS)) uut (.data_out(data_out),
															.empty(empty),
															.full(full),
															.data_in(data_in),
															.shift_in(shift_in),
															.shift_out(shift_out),
															.reset(reset),
															.clk(clk));
	always #5 clk = ~clk;
	 
	initial begin
		infile = $fopen(FILE_IN);
		tempfile = $fopen(FILE_TEMP);
		outfile = $fopen(FILE_OUT);
	
//		 Initialize Inputs
		for (i = 0; i < `NUM_OF_INPUTS; i = i+1) begin
		    rand[i] = $random;
		end
		 
		for (j = 0; j < `NUM_OF_INPUTS; j = j+1) begin
		     $fdisplay(tempfile, "%x",rand[j]);
		end
		 
		//data_in = fileInput[0];
		
		#200;
		#10; //reset = 1'b1;
		#10; //reset = 1'b0;
		#10;
		
		#20 shift_in = 1;
		#20 shift_in = 0;
		
		#20 shift_out = 1;
		#20 shift_out = 0;
		#20;
		
		for (k = 0; k < `STAGES; k=k+1) begin
			#20 shift_in = 1;
			#20 shift_in = 0;
		end
		
		#20 shift_out = 1;
		#20 shift_out = 0;
		
		#20 shift_out = 1;
		#20 shift_out = 0;
		
		/*for (k = 0; k < (`STAGES)-3; k=k+1) begin
			#20 shift_out = 1;
			#20 shift_out = 0;
			#20;
		end*/
		
	end
	 
	always begin
		#200;
		for (k = 0; k < `NUM_OF_INPUTS+1; k = k+1) begin
		     #40 data_in = fileInput[k];
			  if (shift_in == 1)
					$fdisplay(infile, "%x", data_in);
			  if (data_out != 8'hxxxxxxxx) begin
				if (shift_out == 1)
					$fdisplay(outfile, "%x", data_out);
			  end
		end
		
		$fclose(infile);
		$fclose(tempfile);
		$fclose(outfile);
	end   
endmodule

