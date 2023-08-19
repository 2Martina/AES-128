module Add_Round_Key(
 input   clk,reset,enable,
input [7:0] subkey [3:0][3:0],
input [7:0] output_mix_columns [3:0][3:0],

//input [127:0] subkey,output_mix_columns,
output reg [7:0] out_Round_Key [3:0][3:0],
output reg done
);
wire [7:0] out[3:0][3:0];
wire [127:0] output_mix_columns_128;
wire [127:0] subkey_128;
wire [127:0] out_128;
/*genvar i,j;
generate 

/*for(i=0;i<3;i=i+1) begin :sub_Bytes 
    for (j=0;j<3;j=j+1) begin: sub_Bytes2
	assign out[i][j] = subkey[i][j]  ^  output_mix_columns[i][j];
    end

endgenerate*/
assign out_128 = subkey_128 ^  output_mix_columns_128;

//to transform input from array to 128 bits
assign output_mix_columns_128[127:96]={output_mix_columns [0][0],output_mix_columns [1][0],output_mix_columns [2][0],output_mix_columns [3][0]};
assign output_mix_columns_128[95:64]={output_mix_columns [0][1],output_mix_columns [1][1],output_mix_columns [2][1],output_mix_columns [3][1]};
assign output_mix_columns_128[63:32]={output_mix_columns [0][2],output_mix_columns [1][2],output_mix_columns [2][2],output_mix_columns [3][2]};
assign output_mix_columns_128[31:0]={output_mix_columns [0][3],output_mix_columns [1][3],output_mix_columns [2][3],output_mix_columns [3][3]};


//to transform input from array to 128 bits
assign subkey_128[127:96]={subkey [0][0],subkey [1][0],subkey [2][0],subkey [3][0]};
assign subkey_128[95:64]={subkey [0][1],subkey [1][1],subkey [2][1],subkey [3][1]};
assign subkey_128[63:32]={subkey [0][2],subkey [1][2],subkey [2][2],subkey [3][2]};
assign subkey_128[31:0]={subkey [0][3],subkey [1][3],subkey [2][3],subkey [3][3]};



//to transform output from 128 bits to array
assign out[0][0]=out_128[127:120];
assign out[1][0]=out_128[119:112];
assign out[2][0]=out_128[111:104];
assign out[3][0]=out_128[103:96];

assign out[0][1]=out_128[95:88];
assign out[1][1]=out_128[87:80];
assign out[2][1]=out_128[79:72];
assign out[3][1]=out_128[71:64];

assign out[0][2]=out_128[63:56];
assign out[1][2]=out_128[55:48];
assign out[2][2]=out_128[47:40];
assign out[3][2]=out_128[39:32];

assign out[0][3]=out_128[31:24];
assign out[1][3]=out_128[23:16];
assign out[2][3]=out_128[15:8];
assign out[3][3]=out_128[7:0];





 always@(posedge clk)
    begin
        if (reset) begin
            out_Round_Key<='{default: '0};
            done <= 0;
        end 
        else if (enable) begin 
            out_Round_Key <= out;
           done <= 1;
        end 
       else done <= 0;
    end

//assign out = subkey ^ output_mix_columns;
//
//for(
//assign out[0][0] = subkey [0][0] ^ output_mix_columns[0][0];
//assign out[0][1] = in [0][1];
//assign out[0][2]= in [0][2];
//assign out[0][3] = in [0][3];
endmodule