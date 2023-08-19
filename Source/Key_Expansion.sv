module Key_Expansion(input clk,reset,enable,
input [7:0] key_array [3:0][3:0],

input [3:0] keyNum,
output [7:0] key_out [3:0][3:0] 
);
wire [127:0] keyInput;
//subkey 0 = w[1407:1280]
wire [1407:0] w;
wire [31:0] g_out;
reg [31:0] result;

wire [31:0] sbox_out;
reg [31:0] data;
reg [31:0] r;
reg [127:0] keyOutput; 


//to transform input from array to 128 bits
assign keyInput[127:96]={key_array [0][0],key_array [1][0],key_array [2][0],key_array [3][0]};
assign keyInput[95:64]={key_array [0][1],key_array [1][1],key_array [2][1],key_array [3][1]};
assign keyInput[63:32]={key_array [0][2],key_array [1][2],key_array [2][2],key_array [3][2]};
assign keyInput[31:0]={key_array [0][3],key_array [1][3],key_array [2][3],key_array [3][3]};



assign result = {keyInput[23:0], keyInput[31:24]};
genvar i;
generate 
for(i=31;i>0;i=i-8) begin :g 
	sbox s(result[i -:8],sbox_out[i -:8]);
	end
endgenerate
assign g_out= sbox_out^r;

R_con rr(keyNum,r);

// initial keyOutput = 0;
    always @(posedge clk) 
     begin
        if ( reset == 1 )
        begin 
        keyOutput = 0;
        end 
        else 
        begin 
            if(enable)
                begin 
                    keyOutput[127:96] = keyInput[127:96] ^ g_out; 	
                    keyOutput[95:64] = keyInput[95:64] ^ keyOutput[127:96];
                    keyOutput[63:32] = keyInput[63:32] ^ keyOutput[95:64];
                    keyOutput[31:0] = keyInput[31:0] ^ keyOutput[63:32];
                end
        end 
    end



    
//to transform output from 128 bits to array
assign key_out[0][0]=keyOutput[127:120];
assign key_out[1][0]=keyOutput[119:112];
assign key_out[2][0]=keyOutput[111:104];
assign key_out[3][0]=keyOutput[103:96];

assign key_out[0][1]=keyOutput[95:88];
assign key_out[1][1]=keyOutput[87:80];
assign key_out[2][1]=keyOutput[79:72];
assign key_out[3][1]=keyOutput[71:64];

assign key_out[0][2]=keyOutput[63:56];
assign key_out[1][2]=keyOutput[55:48];
assign key_out[2][2]=keyOutput[47:40];
assign key_out[3][2]=keyOutput[39:32];

assign key_out[0][3]=keyOutput[31:24];
assign key_out[1][3]=keyOutput[23:16];
assign key_out[2][3]=keyOutput[15:8];
assign key_out[3][3]=keyOutput[7:0];




/*assign w[1407:1376]= key[127:96];  //w0
assign w[1375:1344]= key[95:64];   //w1
assign w[1343:1312]= key[63:32];   //w2
assign w[1311:1280]= key[31:0];    //w3



   initial keyOutput = 0;
    always @(posedge clk) 
     begin
        if ( reset == 1 )
        begin 
        keyOutput = 0;
         
        end 
        else 
        begin 
            if(enable)
                begin 
                    keyOutput[127:96] = keyInput[127:96] ^ stp2 ^ Rcon; 	
                    keyOutput[95:64] = keyInput[95:64] ^ keyOutput[127:96];
                    keyOutput[63:32] = keyInput[63:32] ^ keyOutput[95:64];
                    keyOutput[31:0] = keyInput[31:0] ^ keyOutput[63:32];
                end
        end 
    end*/

/*genvar i;
generate 
for(i=31;i>0;i=i-8) begin :gg
      g func(clk,reset,w[1311:1280],r1,out_g);
	end
endgenerate

//subkey 1 = w[1279:1152]
assign w[1279:1248]= w[1407:1376] ^ out_g;    //w4
assign w[1247:1216]= w[1279:1248] ^ w[1407:1376] ;    //w5=W4^W1
assign w[1215:1184]= w[1247:1216] ^ w[1343:1312] ;    //w6=W5^W2
assign w[1183:1152]= w[1215:1184] ^ w[1311:1289] ;    //w7=W6^W3

//just for testinggggg noww
assign w[1247:0]=0;*/
endmodule
