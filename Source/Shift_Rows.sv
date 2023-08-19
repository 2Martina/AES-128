module Shift_Rows (
    input clk,reset,enable,
	input [7:0] in [3:0][3:0],
	output reg [7:0] shifted_array_out [3:0][3:0],
    output reg done);
wire  [127:0] shifted;
wire [7:0] shifted_array [3:0][3:0];

//1st row no shift
assign shifted_array[0][0] = in [0][0];
assign shifted_array[0][1] = in [0][1];
assign shifted_array[0][2]= in [0][2];
assign shifted_array[0][3] = in [0][3];

//2nd row shift by 1
assign shifted_array[1][0] = in [1][1];
assign shifted_array[1][1] = in [1][2];
assign shifted_array[1][2]= in [1][3];
assign shifted_array[1][3] = in [1][0];

//3rd row shift by 2
assign shifted_array[2][0] = in [2][2];
assign shifted_array[2][1] = in [2][3];
assign shifted_array[2][2]= in [2][0];
assign shifted_array[2][3] = in [2][1];

//4th row shift by 3
assign shifted_array[3][0] = in [3][3];
assign shifted_array[3][1] = in [3][0];
assign shifted_array[3][2]= in [3][1];
assign shifted_array[3][3] = in [3][2];


initial done <= 0;
initial shifted_array_out <=  '{default: '0};
always @(posedge clk)
  begin
    if (reset)
		begin
	       shifted_array_out<=  '{default: '0};;
		    done <= 0;
		end
  else if (enable) begin

	    shifted_array_out <= shifted_array;
		done <= 1;
	end		
	else done <= 0;
end

endmodule