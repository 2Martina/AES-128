module g(
input clk,reset,
input [31:0] data,
input [31:0] r,
output [31:0] out_g
);


wire [31:0] result;
wire [31:0] sbox_out;


assign result = {data[23:0], data[31:24]};
genvar i;
generate 
for(i=31;i>0;i=i-8) begin :g 
	S_box s(clk,reset,result[i -:8],sbox_out[i -:8]);
	end
endgenerate

assign out_g= sbox_out^r;

endmodule

 