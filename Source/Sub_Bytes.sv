module Sub_Bytes
(//input clk,reset,
input [7:0] data [3:0][3:0],
//[0:127] in,

output wire [7:0] sb [3:0][3:0]);

// [0:127] data_out);

/*genvar i;
generate 
//for(i=127;i>0;i=i-8) begin :sub_Bytes


//for(i=0;i<127;i=i+8) begin :sub_Bytes 
//	S_box s(clk,reset,in[i +:8],data_out[i +:8]);

for(i=0;i<3;i=i+1) begin :sub_Bytes 
    for (j=0;j<3;j+1) begin: sub_bytes2
	    S_box s(clk,reset,in[i][j],data_out[i][j]);
	end
end
endgenerate*/
     sbox q0(data[0][0],sb[0][0]);
     sbox q1(data[0][1],sb[0][1]) ;
     sbox q2(data[0][2],sb[0][2]) ;
     sbox q3(data[0][3],sb[0][3]) ;
     
     sbox q4(data[1][0],sb[1][0]) ;
     sbox q5(data[1][1],sb[1][1]) ;
     sbox q6(data[1][2],sb[1][2]) ;
     sbox q7(data[1][3],sb[1][3]) ;
     
     sbox q8(data[2][0],sb[2][0]) ;
     sbox q9(data[2][1],sb[2][1]) ;
     sbox q10(data[2][2],sb[2][2]) ;
     sbox q11(data[2][3],sb[2][3] );
     
     sbox q12(data[3][0],sb[3][0]) ;
     sbox q13(data[3][1],sb[3][1]) ;
     sbox q14(data[3][2],sb[3][2]) ;
     sbox q16(data[3][3],sb[3][3]) ;
	  

endmodule
