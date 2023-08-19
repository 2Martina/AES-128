module Encrypt(
    input clk,reset,enable,
    input [127:0] key,data,
    output reg [127:0] cipher
);


integer i,j;
reg [1:0] state_FSM1;
reg[2:0] state_FSM2;
reg load_signal,load_finish,finish_encrypt,ready;
reg [127:0] key_reg,cipher_reg,data_encrypt,data_encrypt_reg,data_reg;
reg [7:0]data_encrypt_array[3:0][3:0];

//-----------------------------------------------------
reg mixColumnsEn,keyExpansionEn,roundKeyEn,shiftRowsEn,subBytesEn;
wire roundKeyFinish,subBytesFinish,shiftRowsFinish,mixColumnsFinish; 
reg [3:0] keyNum; //from 0 to 10
reg [127:0] key_reg2,cipher_reg2;

reg [7:0] modulesIn[3:0][3:0];
reg [7:0] modulesKeyIn[3:0][3:0];
wire [7:0] keyExpansionOut[3:0][3:0];
wire [7:0]roundKeyOut[3:0][3:0];
wire [7:0]subByteOut[3:0][3:0];
wire [7:0]shiftRowsOut[3:0][3:0];
wire [7:0]mixColumnsOut[3:0][3:0];
reg [7:0]data_reg_array[3:0][3:0];
reg [7:0]key_array[3:0][3:0];


Add_Round_Key uut1 (clk,reset,roundKeyEn,modulesKeyIn,modulesIn,roundKeyOut,roundKeyFinish);

Sub_Bytes subByteInst (roundKeyOut , subByteOut);
      	
Shift_Rows uut2(clk,reset,shiftRowsEn,subByteOut, shiftRowsOut,shiftRowsFinish);

Mix_ColNew uut3(clk,reset,mixColumnsEn,modulesIn ,mixColumnsOut ,mixColumnsFinish);

Key_Expansion uut4(clk,reset,keyExpansionEn,modulesKeyIn,keyNum,keyExpansionOut);


//fsm1
    // state 0 : wait for the enable signal 
    // state 1 : recieving the data and the key and store them in a 128 bit registers 
    // state 2 : send the ready signal when finish
    // state 3 : send the data out byte by byte

initial begin
key_reg<=128'h0;

//data_encrypt<=128'h0;
data_encrypt_reg<=128'h0;
cipher<=128'h0;
//data_encrypt_array<='{default: '0};
load_signal<=0;
load_finish<=0;

ready<=0;
state_FSM1<=0;

i <= 128;
j <= 128; 
end

    always @(posedge clk)
    begin
        if(reset)
        begin
key_reg<=8'h0;

data_encrypt<=8'h0;
cipher<=8'h0;
data_encrypt_reg<=8'h0;
//data_encrypt_array<='{default: '0};
load_signal<=0;
load_finish<=0;

ready<=0;
state_FSM1<=0;

i <= 128;
j <= 128; 
        end

        else if (enable)
        begin
            
        case(state_FSM1)
			0: // state 0 : wait for the enable signal 
			begin 
              state_FSM1<=1;
              load_finish<=0;
              i<=128;
            end
             
			1:  // state 1 : recieving the ctr,data,key and store them in a 128 bit registers 
			begin 
              
              //  if (i>0)
                //   begin
                  //  load_signal<=1;
                    //load_finish<=0;
                    key_reg<=key;
                    data_reg<=data;
                    i<=i-8;
              //     end

               // else 
                 //  begin
                    load_signal<=0;
                    load_finish<=1;
                    state_FSM1<=2;

                   //end
            end

            2:       // state 2 : send load_finish signal when finish
			begin 
                if(finish_encrypt)
                begin
                   state_FSM1<=3 ;
                   ready<=1;
                   j<=128;
                   load_finish<=1;      
                end
                else
                begin 
                    state_FSM1<=2;
                    ready<=0;
                end
                
            end

            3:   // state 3 : send the data 
			begin 
					//	if ( j > 0)
					//	begin
							ready<=1; 
                            data_encrypt_reg<=data_encrypt; 
                              //to transform from array to 128 bits
 data_encrypt[127:96]<={data_encrypt_array [0][0],data_encrypt_array [1][0],data_encrypt_array [2][0],data_encrypt_array [3][0]};
 data_encrypt[95:64]<={data_encrypt_array [0][1],data_encrypt_array [1][1],data_encrypt_array [2][1],data_encrypt_array [3][1]};
 data_encrypt[63:32]<={data_encrypt_array [0][2],data_encrypt_array [1][2],data_encrypt_array [2][2],data_encrypt_array [3][2]};
 data_encrypt[31:0]<={data_encrypt_array [0][3],data_encrypt_array [1][3],data_encrypt_array [2][3],data_encrypt_array [3][3]};
					
                            j<=j-8;
                            state_FSM1<=3;
					//	end 
					//	else begin 	//for the next encryption
					//			ready <= 0;
							
					//	end 
                    load_finish <= 1; 
                   cipher = data_encrypt_reg;
            end
        endcase
        end else
         state_FSM1<=0;
        end
   
    




 // 2nd FSM for running the encryption 10 cycles (provide inputs and enable signals to the modules )  
    // state 0 : wait for the load finish signal to come then run the 1st AddroundKey key 0 
    // state 1 : run sub bytes
    // state 2 : run shift rows
    // state 3 : run mix columns 


    // When the keynum reaches 11, then we finished all the steps
  

initial begin
    state_FSM2<=0;
    mixColumnsEn <= 0;
	keyExpansionEn <= 0;
	roundKeyEn <= 0;
    shiftRowsEn <= 0;
    subBytesEn <= 0;
    finish_encrypt <= 0;
    keyNum <=0;
    cipher_reg<=0;
end
    always@(posedge clk)
    begin

    if(reset)
    begin
    state_FSM2<=0;
    mixColumnsEn <= 0;
	keyExpansionEn <= 0;
	roundKeyEn <= 0;
    shiftRowsEn <= 0;
    subBytesEn <= 0;
    finish_encrypt <= 0;
    keyNum <=0;
    cipher_reg<=0;
    end


    else if (enable && load_finish) 
    begin
       
       if ( keyNum <= 10 ) 
			begin 

    case(state_FSM2)
    0:      // state 0 : wait for the load finish signal to come then run the 1st AddroundKey key 0 
    begin
        	roundKeyEn <= 1;
            keyExpansionEn <= 1; 
            mixColumnsEn <= 0; 
            shiftRowsEn <= 0; 
		    subBytesEn <= 0;
			state_FSM2<= 2'b01;
            finish_encrypt<=0;
            keyNum<=1;  
            key_reg2 <= key_reg; 
        
            modulesIn <= data_reg_array;
            modulesKeyIn <= key_array;

    end

    1:       // state 1 : run shift rows
    begin
        if (roundKeyFinish == 1)
						begin
            roundKeyEn <= 0;
            keyExpansionEn <= 0; 
            mixColumnsEn <= 0; 
            shiftRowsEn <= 1; 
		   // subBytes <= ;
			state_FSM2<= 2'b10;
            finish_encrypt<=0;
            
		modulesIn <= roundKeyOut; 
			modulesKeyIn <= keyExpansionOut;
	
							if ( keyNum < 10)  state_FSM2 <= 2'b10; // if we reached the last cycle don't mix columns
                            else state_FSM2<=2'b11; //go to add round key
						
		end 			
					finish_encrypt <= 0;
    end
    
    2:     // state 2 : run mixcol
    begin
						if (shiftRowsFinish == 1)
						begin
							modulesIn <= shiftRowsOut;
							shiftRowsEn <= 0;
							mixColumnsEn <= 1;
							state_FSM2 <= 2'b11;
						end 
						finish_encrypt <= 0;
				end 			


    3:   // state 3 : run  add riund key
    begin
				
                        if (mixColumnsFinish == 1 || (shiftRowsFinish == 1 && keyNum >= 10))
						begin
						  if(keyNum < 10) begin 
                          modulesIn <= mixColumnsOut;
                          modulesKeyIn <= keyExpansionOut; 
                          end else 
                            modulesIn <= shiftRowsOut;
							mixColumnsEn <= 0; 
							shiftRowsEn <= 0;
							keyExpansionEn <= 1;
							roundKeyEn <= 1;
							state_FSM2 <= 2'b01; // return to state 1 shift rows
                        if(keyNum<=10)   
							keyNum <= keyNum + 1;
						end 
                        if (keyNum==10) 
                        begin
                            keyExpansionEn<=1; 
                            roundKeyEn<=1;
                        end

						finish_encrypt <= 0;
    end

    endcase
   
    end  
   
    	else 
         if (keyNum==11) 
        begin
            roundKeyEn <= 0;  
            keyExpansionEn <= 0;  
            key_reg2 <= key_reg;  
    
					data_encrypt_array <= roundKeyOut;
                    finish_encrypt <= 1;
					state_FSM2 <= 2'b11; 
					mixColumnsEn <= 0;
					shiftRowsEn <= 0;
                    subBytesEn <=0;
             
      end 
            end
     else 
		begin
			finish_encrypt <= 0; 
					
                    state_FSM2 <= 0;
					mixColumnsEn <= 0;
					keyExpansionEn <= 0;
					roundKeyEn <= 0;
					shiftRowsEn <= 0;
                    subBytesEn <=0;
		end
    end

always @(*)
begin
   

                    //to transform  from 128 bits to array
data_reg_array[0][0]<=data_reg[127:120];
data_reg_array[1][0]<=data_reg[119:112];
data_reg_array[2][0]<=data_reg[111:104];
data_reg_array[3][0]<=data_reg[103:96];

 data_reg_array[0][1]<=data_reg[95:88];
 data_reg_array[1][1]<=data_reg[87:80];
 data_reg_array[2][1]<=data_reg[79:72];
 data_reg_array[3][1]<=data_reg[71:64];

 data_reg_array[0][2]<=data_reg[63:56];
 data_reg_array[1][2]<=data_reg[55:48];
 data_reg_array[2][2]<=data_reg[47:40];
 data_reg_array[3][2]<=data_reg[39:32];

 data_reg_array[0][3]<=data_reg[31:24];
 data_reg_array[1][3]<=data_reg[23:16];
 data_reg_array[2][3]<=data_reg[15:8];
 data_reg_array[3][3]<=data_reg[7:0];


                   //to transform  from 128 bits to array
key_array[0][0]<=key[127:120];
key_array[1][0]<=key[119:112];
 key_array[2][0]<=key[111:104];
key_array[3][0]<=key[103:96];

 key_array[0][1]<=key[95:88];
 key_array[1][1]<=key[87:80];
 key_array[2][1]<=key[79:72];
 key_array[3][1]<=key[71:64];

 key_array[0][2]<=key[63:56];
 key_array[1][2]<=key[55:48];
 key_array[2][2]<=key[47:40];
 key_array[3][2]<=key[39:32];

 key_array[0][3]<=key[31:24];
 key_array[1][3]<=key[23:16];
 key_array[2][3]<=key[15:8];
 key_array[3][3]<=key[7:0];
end
    
endmodule