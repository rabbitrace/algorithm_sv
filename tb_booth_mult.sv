`timescale 1ns/1ps
module tb_booth_mult;
	logic       rst;
	logic [3:0] mult_a;
	logic [3:0] mult_b;
	logic [7:0] mult_y;
	logic       booth_done;
	logic 		clk;
	booth_mult inst_booth_mult
		(
			.clk        (clk),
			.rst        (rst),
			.mult_a     (mult_a),
			.mult_b     (mult_b),
			.mult_y     (mult_y),
			.booth_done (booth_done)
		);

	initial begin
		clk = '0;
		forever #(10) clk = ~clk;
	end

	initial begin
		rst <= '0;
		#200;
		rst <= '1;
		mult_a = 3'd4;
		mult_b = -3'd5;
		for(int i =0;i <20;i = i+1)begin
			@(posedge booth_done);
			mult_b = mult_b +1'b1;
		end
		@(posedge booth_done);
		$stop;	
	end
endmodule 