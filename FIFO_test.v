`define STAGES 5
`define BITS 32
`define NUM_OF_INPUTS 1

module test_here;

	// Inputs
	reg [`BITS-1:0] data_in;
	reg             shift_in = 0;
	reg             shift_out = 0;
	reg             reset = 0;
	reg             clk = 0;

	// Outputs
	wire [`BITS-1:0] data_out;
	wire             empty;
	wire             full;
	
	// Files
	parameter FILE_IN = "data_in.dat";
	parameter FILE_OUT = "data_out.dat";
	
	// intermediate
	integer i = 0;
	integer j = 0;
	integer infile;
	reg [`BITS-1:0] rand [0:3];
	reg [`BITS-1:0] test [0:3];
	// Instantiate the Unit Under Test (UUT)
	FIFO #(.SIZE(`STAGES), .DATA(`BITS)) uut (.data_out(data_out),
	                                              .empty(empty),
	                                              .full(full),
	                                              .data_in(data_in),
	                                              .shift_in(shift_in),
	                                              .shift_out(shift_out),
	                                              .reset(reset),
	                                              .clk(clk));
	always #5 clk = ~clk;
	initial $readmemh("data_in.dat", test);
	
	initial begin
		// Initialize Inputs
		for (i = 0; i < 4; i = i+1) begin
		    rand[i][`BITS-1:0] = $random;
		end
		j = 0;
		j = j+i;
		infile = $fopen(FILE_IN, "w");
		for (i = 0; i < 4; i = i+1) begin
		    $fdisplay(infile, rand[i][`BITS-1:0]); 
		end
		$fclose(infile);
		
		$display("File Data");
		
		//$display("%d : %h",i,test);
		for(i=0; i < 4; i=i+1) begin
			$display("%d : %h",i,test[i][`BITS-1:0]);
		end
		/*
		always @()begin
			for (j = 0; j < 2*(`STAGES); j=j+1) begin
				#5 shift_out = ~shift_out;
			end
		end
		*/
		// Wait 100 ns for global reset to finish	
		#100;
        
		// Add stimulus here
	end
	/*
	always #20 {shift_out, shift_in} = rand;
	
	
	 FILE fileno = $fopen("filename");
	 $fdisplay[defbase](fileno, [fmtstr,]{expr,});
	 $fwrite[defbase](fileno, [fmtstr,]{expr,});
	 $fmonitor (fileno, [fmtstr,]{expr,});
	 $fclose(fileno);
	
	// read memory ($readmemh, $readmemb)
	//     Ex.: reg [LINES-1:0] mem [0:WORDS];
	//          $readmemh("initmem.hex", mem, 0);
	
	// write memory ($writememh, $writememb)
	//     Ex.: parameter FILE = "finalmem.hex";
	//          reg [LINES-1:0] mem [0:WORDS];
	//          //     ... modify memory ...
	//          $writememh(FILE, mem);
     */ 
endmodule

