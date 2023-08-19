module Mix_ColNew(
    input clk,reset,enable,
input [7:0] state_in_array [3:0][3:0],
//input clk,reset,enable,
output reg [7:0] state_output [3:0][3:0] ,
output reg done);

/*force -freeze {sim:/Mix_ColNew/state_in_array[0][0]} 'h63 0
force -freeze {sim:/Mix_ColNew/state_in_array[1][0]} 'h9c 0
force -freeze {sim:/Mix_ColNew/state_in_array[2][0]} 'h7b 0
force -freeze {sim:/Mix_ColNew/state_in_array[3][0]} 'hca 0*/

wire [127:0] state_in;
reg [127:0] state_out;
wire [7:0] state_out_array[3:0][3:0];


//to transform input from array to 128 bits
assign state_in[127:96]={state_in_array [0][0],state_in_array [1][0],state_in_array [2][0],state_in_array [3][0]};
assign state_in[95:64]={state_in_array [0][1],state_in_array [1][1],state_in_array [2][1],state_in_array [3][1]};
assign state_in[63:32]={state_in_array [0][2],state_in_array [1][2],state_in_array [2][2],state_in_array [3][2]};
assign state_in[31:0]={state_in_array [0][3],state_in_array [1][3],state_in_array [2][3],state_in_array [3][3]};

function [7:0] mb2; //multiply by 2
	input [7:0] x;
	begin 
			/* multiplication by 2 is shifting on bit to the left, and if the original 8 bits had a 1 @ MSB,
			xor the result with {1b}*/
			if(x[7] == 1) mb2 = ((x << 1) ^ 8'h1b);
			else mb2 = x << 1; 
	end 	
endfunction


/* 
	multiplication by 3 is done by:
		multiplication by {02} xor(the original x)
		so that 2+1=3. where xor is the addition of elements in finite fields
*/
function [7:0] mb3; //multiply by 3
	input [7:0] x;
	begin 
			
			mb3 = mb2(x) ^ x;
	end 
endfunction




genvar i;

generate 
for(i=0;i< 4;i=i+1) begin : m_col

	assign state_out[(i*32 + 24)+:8]= mb2(state_in[(i*32 + 24)+:8]) ^ mb3(state_in[(i*32 + 16)+:8]) ^ state_in[(i*32 + 8)+:8] ^ state_in[i*32+:8];
	assign state_out[(i*32 + 16)+:8]= state_in[(i*32 + 24)+:8] ^ mb2(state_in[(i*32 + 16)+:8]) ^ mb3(state_in[(i*32 + 8)+:8]) ^ state_in[i*32+:8];
	assign state_out[(i*32 + 8)+:8]= state_in[(i*32 + 24)+:8] ^ state_in[(i*32 + 16)+:8] ^ mb2(state_in[(i*32 + 8)+:8]) ^ mb3(state_in[i*32+:8]);
   assign state_out[i*32+:8]= mb3(state_in[(i*32 + 24)+:8]) ^ state_in[(i*32 + 16)+:8] ^ state_in[(i*32 + 8)+:8] ^ mb2(state_in[i*32+:8]);

end

endgenerate

//to transform output from 128 bits to array
assign state_out_array[0][0]=state_out[127:120];
assign state_out_array[1][0]=state_out[119:112];
assign state_out_array[2][0]=state_out[111:104];
assign state_out_array[3][0]=state_out[103:96];

assign state_out_array[0][1]=state_out[95:88];
assign state_out_array[1][1]=state_out[87:80];
assign state_out_array[2][1]=state_out[79:72];
assign state_out_array[3][1]=state_out[71:64];

assign state_out_array[0][2]=state_out[63:56];
assign state_out_array[1][2]=state_out[55:48];
assign state_out_array[2][2]=state_out[47:40];
assign state_out_array[3][2]=state_out[39:32];

assign state_out_array[0][3]=state_out[31:24];
assign state_out_array[1][3]=state_out[23:16];
assign state_out_array[2][3]=state_out[15:8];
assign state_out_array[3][3]=state_out[7:0];

initial done <= 0;
initial state_out <= '{default: '0};
always@(posedge clk) 
begin
	if (reset)
	begin
		state_output<= '{default: '0};
		done <= 0;
	end 
	else if (enable)
	begin 
        state_output <= state_out_array;
        done <= 1;
	end else done <= 0;
end



endmodule