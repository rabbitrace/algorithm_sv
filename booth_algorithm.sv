module booth_mult(
	input logic clk,
	input logic rst,
	input logic [3:0] mult_a, //
	input logic [3:0] mult_b, //

	output logic [7:0] mult_y,//result 
	output logic booth_done
);

	logic [3:0] mult_a_i;
	logic [2:0] cnt;
	logic [2:0] mult_booth; //booth mult
	logic [7:0] mult_add ;
	logic [7:0] mult_sum ;
	/***********caclulate the mult_a_i ***************/
	assign mult_a_i = (~mult_a) + 1'd1;
	/************cnt ********************************/
	always_ff @(posedge clk) begin
		if(~rst) begin
			cnt <= '0;
		end else if(cnt == 3'b100) begin
			cnt <= '0;
		end
		else begin
			cnt <= cnt + 1'b1;
		end
	end
	/************mult_booth ************************/
	always_ff @(posedge clk) begin
		if(~rst) begin
			mult_booth <= '0;
		end else if(cnt == 3'b100) begin
			mult_booth <= '0;
		end
		else begin
			case(cnt)
				3'b000:mult_booth <= {mult_b[1:0],1'd0};
				3'b001:mult_booth <= {mult_b[3:1]};
				default:mult_booth <= '0;
			endcase  
		end
	end

	/*********************mult_add****************/
	always_ff @(posedge clk) begin
		if(~rst) begin
			mult_add <= '0;
		end else if(cnt == 3'b100) begin
			mult_add <= '0;
		end
		else begin
			case(mult_booth)
				3'b000:mult_add <= '0;
				3'b001:mult_add <= {{4{mult_a[3]}},mult_a} <<((cnt -1)<<1);
				3'b010:mult_add <= {{4{mult_a[3]}},mult_a} <<((cnt -1)<<1);
				3'b011:mult_add <= {{4{mult_a[3]}},mult_a} <<(((cnt -1)<<1) +1);				
				3'b100:mult_add <= {{4{mult_a_i[3]}},mult_a_i} <<(((cnt -1)<<1) +1);
				3'b101:mult_add <= {{4{mult_a_i[3]}},mult_a_i} <<((cnt -1)<<1);
				3'b110:mult_add <= {{4{mult_a_i[3]}},mult_a_i} <<((cnt -1)<<1);
				3'b111:mult_add <= '0;
			endcase
		end
	end
	/*********************mult_sum****************/	
	always_ff @(posedge clk) begin
		if(~rst) begin
			mult_sum <= '0;
		end else if(cnt == 3'b100) begin
			mult_sum <= '0;
		end
		else begin
			mult_sum <= mult_sum + mult_add;
		end
	end

	always_ff @(posedge clk) begin
		if(~rst) begin
			booth_done <= '0;
		end else if(cnt == 3'b100) begin
			booth_done <= '1;
		end
		else begin
			booth_done <= '0;
		end
	end


	always_ff @(posedge clk) begin
		if(~rst) begin
			mult_y <= '0;
		end else if(cnt == 3'b100) begin
			mult_y <= mult_sum;
		end
		else begin
			mult_y <= '0;
		end
	end	
endmodule 