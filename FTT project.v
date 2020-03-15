`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//top module takes input for 10 bit ADC
module project(input clk,input start,input [9:0] number,output reg [1:0] state,output [31:0] real_num,output [31:0] img_num);
reg [5:0] counter;

 //
//reg [1:0] st;
//assign state=st;
reg [31:0]output_img,output_real;
assign real_num=output_real;
assign img_num=output_img;
//memory  to hold converted floats
wire [31:0] float [0:15];
reg [31:0]in [0:15];
reg [31:0] float_real [0:15];
reg [31:0] float_img [0:15];
//wires that pass the float values 
//arranging the inputs according to the butterfly technique requirements
assign float[0]=in[0]; assign float[1]=in[8]; assign float[2]=in[4]; assign float[3]=in[12];
assign float[4]=in[2]; assign float[5]=in[10]; assign float[6]=in[6]; assign float[7]=in[14];
assign float[8]=in[1]; assign float[9]=in[9]; assign float[10]=in[5]; assign float[11]=in[13];
assign float[12]=in[3]; assign float[13]=in[11]; assign float[14]=in[7]; assign float[15]=in[15];
//convert in[ numbers to 32 bit floating point
wire [31:0] outConv;
hexConv conv(number,outConv);


//tracking the state
always@(*) begin
if(((counter==5'd0)&&~start))begin state=2'b00; end//waiting
else if(((counter==5'd0)&&start))begin state=2'b01; end//taking in inputs
else if((counter > 5'd16)&&(counter<6'd21))begin state=2'b10; end//calculating
else if((counter>=6'd21))begin state=2'b11;end //outputting
else state=0;
end


//taking in values  and outputting values
always @(posedge clk)
    begin
    if(((counter==6'd0)&&~start))
    begin
    counter=0;
    end
    if(((counter==6'd0)&&start))
    begin
    counter=0;
    in[counter]=outConv;
    counter=counter+1;
    end
    else if((counter < 6'd16)&&(counter>0))
    begin
    in[counter]=outConv;
    counter=counter+1;
    end
    else if ((counter<6'd20)&&(counter>=6'd16))
    begin
    counter=counter+1;
    end
    else if((counter >= 6'd20)&&(counter<6'd36)&&(counter>0))
    begin
    //output numbers
    output_img=float_img[counter-6'd20];
    output_real=float_real[counter-6'd20];
    counter=counter+1;
    end
    else if ((counter>=6'd36)&&(counter>0))
    begin
    counter=5'd0;
    end
    else 
    begin
    counter=0;
    end
    
    
    end
    
//registers to hol dthe passed values 
reg [31:0] firstMult_real[0:15];
reg [31:0] firstMult_img[0:15];
reg [31:0] secondMult_real[0:15];
reg [31:0] secondMult_img[0:15];
reg [31:0] firstAdd_real[0:15];
reg [31:0] firstAdd_img[0:15];
reg sign[0:15];
//outputs from CFMAs
wire[31:0] outAdd_real[0:15];
wire[31:0] outAdd_img[0:15];


//values are fed through following complex fused multiply adders
CFMA cfa_0(firstMult_real[0],firstMult_img[0],secondMult_real[0],secondMult_img[0],firstAdd_real[0],firstAdd_img[0],outAdd_real[0],outAdd_img[0],sign[0]);
CFMA cfa_1(firstMult_real[1],firstMult_img[1],secondMult_real[1],secondMult_img[1],firstAdd_real[1],firstAdd_img[1],outAdd_real[1],outAdd_img[1],sign[1]);
CFMA cfa_2(firstMult_real[2],firstMult_img[2],secondMult_real[2],secondMult_img[2],firstAdd_real[2],firstAdd_img[2],outAdd_real[2],outAdd_img[2],sign[2]);
CFMA cfa_3(firstMult_real[3],firstMult_img[3],secondMult_real[3],secondMult_img[3],firstAdd_real[3],firstAdd_img[3],outAdd_real[3],outAdd_img[3],sign[3]);
CFMA cfa_4(firstMult_real[4],firstMult_img[4],secondMult_real[4],secondMult_img[4],firstAdd_real[4],firstAdd_img[4],outAdd_real[4],outAdd_img[4],sign[4]);
CFMA cfa_5(firstMult_real[5],firstMult_img[5],secondMult_real[5],secondMult_img[5],firstAdd_real[5],firstAdd_img[5],outAdd_real[5],outAdd_img[5],sign[5]);
CFMA cfa_6(firstMult_real[6],firstMult_img[6],secondMult_real[6],secondMult_img[6],firstAdd_real[6],firstAdd_img[6],outAdd_real[6],outAdd_img[6],sign[6]);
CFMA cfa_7(firstMult_real[7],firstMult_img[7],secondMult_real[7],secondMult_img[7],firstAdd_real[7],firstAdd_img[7],outAdd_real[7],outAdd_img[7],sign[7]);
CFMA cfa_8(firstMult_real[8],firstMult_img[8],secondMult_real[8],secondMult_img[8],firstAdd_real[8],firstAdd_img[8],outAdd_real[8],outAdd_img[8],sign[8]);
CFMA cfa_9(firstMult_real[9],firstMult_img[9],secondMult_real[9],secondMult_img[9],firstAdd_real[9],firstAdd_img[9],outAdd_real[9],outAdd_img[9],sign[9]);
CFMA cfa_10(firstMult_real[10],firstMult_img[10],secondMult_real[10],secondMult_img[10],firstAdd_real[10],firstAdd_img[10],outAdd_real[10],outAdd_img[10],sign[10]);
CFMA cfa_11(firstMult_real[11],firstMult_img[11],secondMult_real[11],secondMult_img[11],firstAdd_real[11],firstAdd_img[11],outAdd_real[11],outAdd_img[11],sign[11]);
CFMA cfa_12(firstMult_real[12],firstMult_img[12],secondMult_real[12],secondMult_img[12],firstAdd_real[12],firstAdd_img[12],outAdd_real[12],outAdd_img[12],sign[12]);
CFMA cfa_13(firstMult_real[13],firstMult_img[13],secondMult_real[13],secondMult_img[13],firstAdd_real[13],firstAdd_img[13],outAdd_real[13],outAdd_img[13],sign[13]);
CFMA cfa_14(firstMult_real[14],firstMult_img[14],secondMult_real[14],secondMult_img[14],firstAdd_real[14],firstAdd_img[14],outAdd_real[14],outAdd_img[14],sign[14]);
CFMA cfa_15(firstMult_real[15],firstMult_img[15],secondMult_real[15],secondMult_img[15],firstAdd_real[15],firstAdd_img[15],outAdd_real[15],outAdd_img[15],sign[15]);

always@(posedge clk)
begin
//passing value from stage 1
if(counter==5'd17)
    begin
    firstAdd_real[0]<=float[0];firstAdd_img[0]<=0;firstMult_real[0]<=float[1];firstMult_img[0]<=0;sign[0]<=1'b0;
    firstAdd_real[1]<=float[0];firstAdd_img[1]<=0;firstMult_real[1]<=float[1];firstMult_img[1]<=0;sign[1]<=1'b1;
    firstAdd_real[2]<=float[2];firstAdd_img[2]<=0;firstMult_real[2]<=float[3];firstMult_img[2]<=0;sign[2]<=1'b0;
    firstAdd_real[3]<=float[2];firstAdd_img[3]<=0;firstMult_real[3]<=float[3];firstMult_img[3]<=0;sign[3]<=1'b1;
    firstAdd_real[4]<=float[4];firstAdd_img[4]<=0;firstMult_real[4]<=float[5];firstMult_img[4]<=0;sign[4]<=1'b0;
    firstAdd_real[5]<=float[4];firstAdd_img[5]<=0;firstMult_real[5]<=float[5];firstMult_img[5]<=0;sign[5]<=1'b1;
    firstAdd_real[6]<=float[6];firstAdd_img[6]<=0;firstMult_real[6]<=float[7];firstMult_img[6]<=0;sign[6]<=1'b0;
    firstAdd_real[7]<=float[6];firstAdd_img[7]<=0;firstMult_real[7]<=float[7];firstMult_img[7]<=0;sign[7]<=1'b1;
    firstAdd_real[8]<=float[8];firstAdd_img[8]<=0;firstMult_real[8]<=float[9];firstMult_img[8]<=0;sign[8]<=1'b0;
    firstAdd_real[9]<=float[8];firstAdd_img[9]<=0;firstMult_real[9]<=float[9];firstMult_img[9]<=0;sign[9]<=1'b1;
    firstAdd_real[10]<=float[10];firstAdd_img[10]<=0;firstMult_real[10]<=float[11];firstMult_img[10]<=0;sign[10]<=1'b0;
    firstAdd_real[11]<=float[10];firstAdd_img[11]<=0;firstMult_real[11]<=float[11];firstMult_img[11]<=0;sign[11]<=1'b1;
    firstAdd_real[12]<=float[12];firstAdd_img[12]<=0;firstMult_real[12]<=float[13];firstMult_img[12]<=0;sign[12]<=1'b0;
    firstAdd_real[13]<=float[12];firstAdd_img[13]<=0;firstMult_real[13]<=float[13];firstMult_img[13]<=0;sign[13]<=1'b1;
    firstAdd_real[14]<=float[14];firstAdd_img[14]<=0;firstMult_real[14]<=float[15];firstMult_img[14]<=0;sign[14]<=1'b0;
    firstAdd_real[15]<=float[14];firstAdd_img[15]<=0;firstMult_real[15]<=float[15];firstMult_img[15]<=0;sign[15]<=1'b1;
    //3 7 11 15
    secondMult_real[0]<=32'h3f800000;secondMult_img[0]<=0;
    secondMult_real[1]<=32'h3f800000;secondMult_img[1]<=0;
    secondMult_real[2]<=32'h3f800000;secondMult_img[2]<=0;
    secondMult_real[3]<=32'h3f800000;secondMult_img[3]<=0;//
    secondMult_real[4]<=32'h3f800000;secondMult_img[4]<=0;
    secondMult_real[5]<=32'h3f800000;secondMult_img[5]<=0;
    secondMult_real[6]<=32'h3f800000;secondMult_img[6]<=0;
    secondMult_real[7]<=32'h3f800000;secondMult_img[7]<=0;//
    secondMult_real[8]<=32'h3f800000;secondMult_img[8]<=0;
    secondMult_real[9]<=32'h3f800000;secondMult_img[9]<=0;
    secondMult_real[10]<=32'h3f800000;secondMult_img[10]<=0;
    secondMult_real[11]<=32'h3f800000;secondMult_img[11]<=0;//
    secondMult_real[12]<=32'h3f800000;secondMult_img[12]<=0;
    secondMult_real[13]<=32'h3f800000;secondMult_img[13]<=0;
    secondMult_real[14]<=32'h3f800000;secondMult_img[14]<=0;
    secondMult_real[15]<=32'h3f800000;secondMult_img[15]<=0;//
        
        
    end
    //stage2
else if(counter==5'd18)
    begin
    firstAdd_real[0]<=float_real[0];firstAdd_img[0]<=float_img[0];firstMult_real[0]<=float_real[2];firstMult_img[0]<=float_img[2];sign[0]<=1'b0;
    firstAdd_real[1]<=float_real[1];firstAdd_img[1]<=float_img[1];firstMult_real[1]<=float_real[3];firstMult_img[1]<=float_img[3];sign[1]<=1'b0;
    firstAdd_real[2]<=float_real[0];firstAdd_img[2]<=float_img[0];firstMult_real[2]<=float_real[2];firstMult_img[2]<=float_img[2];sign[2]<=1'b1;
    firstAdd_real[3]<=float_real[1];firstAdd_img[3]<=float_img[1];firstMult_real[3]<=float_real[3];firstMult_img[3]<=float_img[3];sign[3]<=1'b1;
    firstAdd_real[4]<=float_real[4];firstAdd_img[4]<=float_img[4];firstMult_real[4]<=float_real[6];firstMult_img[4]<=float_img[6];sign[4]<=1'b0;
    firstAdd_real[5]<=float_real[5];firstAdd_img[5]<=float_img[5];firstMult_real[5]<=float_real[7];firstMult_img[5]<=float_img[7];sign[5]<=1'b0;
    firstAdd_real[6]<=float_real[4];firstAdd_img[6]<=float_img[4];firstMult_real[6]<=float_real[6];firstMult_img[6]<=float_img[6];sign[6]<=1'b1;
    firstAdd_real[7]<=float_real[5];firstAdd_img[7]<=float_img[5];firstMult_real[7]<=float_real[7];firstMult_img[7]<=float_img[7];sign[7]<=1'b1;
    firstAdd_real[8]<=float_real[8];firstAdd_img[8]<=float_img[8];firstMult_real[8]<=float_real[10];firstMult_img[8]<=float_img[10];sign[8]<=1'b0;
    firstAdd_real[9]<=float_real[9];firstAdd_img[9]<=float_img[9];firstMult_real[9]<=float_real[11];firstMult_img[9]<=float_img[11];sign[9]<=1'b0;
    firstAdd_real[10]<=float_real[8];firstAdd_img[10]<=float_img[8];firstMult_real[10]<=float_real[10];firstMult_img[10]<=float_img[10];sign[10]<=1'b1;
    firstAdd_real[11]<=float_real[9];firstAdd_img[11]<=float_img[9];firstMult_real[11]<=float_real[11];firstMult_img[11]<=float_img[11];sign[11]<=1'b1;
    firstAdd_real[12]<=float_real[12];firstAdd_img[12]<=float_img[12];firstMult_real[12]<=float_real[14];firstMult_img[12]<=float_img[14];sign[12]<=1'b0;
    firstAdd_real[13]<=float_real[13];firstAdd_img[13]<=float_img[13];firstMult_real[13]<=float_real[15];firstMult_img[13]<=float_img[15];sign[13]<=1'b0;
    firstAdd_real[14]<=float_real[12];firstAdd_img[14]<=float_img[12];firstMult_real[14]<=float_real[14];firstMult_img[14]<=float_img[14];sign[14]<=1'b1;
    firstAdd_real[15]<=float_real[13];firstAdd_img[15]<=float_img[13];firstMult_real[15]<=float_real[15];firstMult_img[15]<=float_img[15];sign[15]<=1'b1;

   
    secondMult_real[0]<=32'h3f800000;secondMult_img[0]<=0;
    secondMult_real[1]<=32'h248d3132;secondMult_img[1]<=32'hbf800000;
    secondMult_real[2]<=32'h3f800000;secondMult_img[2]<=0;
    secondMult_real[3]<=32'h248d3132;secondMult_img[3]<=32'hbf800000;//
    secondMult_real[4]<=32'h3f800000;secondMult_img[4]<=0;
    secondMult_real[5]<=32'h248d3132;secondMult_img[5]<=32'hbf800000;
    secondMult_real[6]<=32'h3f800000;secondMult_img[6]<=0;
    secondMult_real[7]<=32'h248d3132;secondMult_img[7]<=32'hbf800000;
    secondMult_real[8]<=32'h3f800000;secondMult_img[8]<=0;
    secondMult_real[9]<=32'h248d3132;secondMult_img[9]<=32'hbf800000;
    secondMult_real[10]<=32'h3f800000;secondMult_img[10]<=0;
    secondMult_real[11]<=32'h248d3132;secondMult_img[11]<=32'hbf800000;
    secondMult_real[12]<=32'h3f800000;secondMult_img[12]<=0;
    secondMult_real[13]<=32'h248d3132;secondMult_img[13]<=32'hbf800000;
    secondMult_real[14]<=32'h3f800000;secondMult_img[14]<=0;
    secondMult_real[15]<=32'h248d3132;secondMult_img[15]<=32'hbf800000;
 
    
    end
    //stage 3
else if(counter==5'd19)
    begin
    firstAdd_real[0]<=float_real[0];firstAdd_img[0]<=float_img[0];firstMult_real[0]<=float_real[4];firstMult_img[0]<=float_img[4];sign[0]<=1'b0;
    firstAdd_real[1]<=float_real[1];firstAdd_img[1]<=float_img[1];firstMult_real[1]<=float_real[5];firstMult_img[1]<=float_img[5];sign[1]<=1'b0;
    firstAdd_real[2]<=float_real[2];firstAdd_img[2]<=float_img[2];firstMult_real[2]<=float_real[6];firstMult_img[2]<=float_img[6];sign[2]<=1'b0;
    firstAdd_real[3]<=float_real[3];firstAdd_img[3]<=float_img[3];firstMult_real[3]<=float_real[7];firstMult_img[3]<=float_img[7];sign[3]<=1'b0;
    firstAdd_real[4]<=float_real[0];firstAdd_img[4]<=float_img[0];firstMult_real[4]<=float_real[4];firstMult_img[4]<=float_img[4];sign[4]<=1'b1;
    firstAdd_real[5]<=float_real[1];firstAdd_img[5]<=float_img[1];firstMult_real[5]<=float_real[5];firstMult_img[5]<=float_img[5];sign[5]<=1'b1;
    firstAdd_real[6]<=float_real[2];firstAdd_img[6]<=float_img[2];firstMult_real[6]<=float_real[6];firstMult_img[6]<=float_img[6];sign[6]<=1'b1;
    firstAdd_real[7]<=float_real[3];firstAdd_img[7]<=float_img[3];firstMult_real[7]<=float_real[7];firstMult_img[7]<=float_img[7];sign[7]<=1'b1;
    firstAdd_real[8]<=float_real[8];firstAdd_img[8]<=float_img[8];firstMult_real[8]<=float_real[12];firstMult_img[8]<=float_img[12];sign[8]<=1'b0;
    firstAdd_real[9]<=float_real[9];firstAdd_img[9]<=float_img[9];firstMult_real[9]<=float_real[13];firstMult_img[9]<=float_img[13];sign[9]<=1'b0;
    firstAdd_real[10]<=float_real[10];firstAdd_img[10]<=float_img[10];firstMult_real[10]<=float_real[14];firstMult_img[10]<=float_img[14];sign[10]<=1'b0;
    firstAdd_real[11]<=float_real[11];firstAdd_img[11]<=float_img[11];firstMult_real[11]<=float_real[15];firstMult_img[11]<=float_img[15];sign[11]<=1'b0;
    firstAdd_real[12]<=float_real[8];firstAdd_img[12]<=float_img[8];firstMult_real[12]<=float_real[12];firstMult_img[12]<=float_img[12];sign[12]<=1'b1;
    firstAdd_real[13]<=float_real[9];firstAdd_img[13]<=float_img[9];firstMult_real[13]<=float_real[13];firstMult_img[13]<=float_img[13];sign[13]<=1'b1;
    firstAdd_real[14]<=float_real[10];firstAdd_img[14]<=float_img[10];firstMult_real[14]<=float_real[14];firstMult_img[14]<=float_img[14];sign[14]<=1'b1;
    firstAdd_real[15]<=float_real[11];firstAdd_img[15]<=float_img[11];firstMult_real[15]<=float_real[15];firstMult_img[15]<=float_img[15];sign[15]<=1'b1;

    
    secondMult_real[0]<=32'h3f800000;secondMult_img[0]<=0;
    secondMult_real[1]<=32'h3f3504f3;secondMult_img[1]<=32'hbf3504f3;
    secondMult_real[2]<=32'h248d4000;secondMult_img[2]<=32'hbf800000;
    secondMult_real[3]<=32'hbf3504f3;secondMult_img[3]<=32'hbf3504f3;///
    secondMult_real[4]<=32'h3f800000;secondMult_img[4]<=0;
    secondMult_real[5]<=32'h3f3504f3;secondMult_img[5]<=32'hbf3504f3;
    secondMult_real[6]<=32'h248d4000;secondMult_img[6]<=32'hbf800000; 
    secondMult_real[7]<=32'hbf3504f3;secondMult_img[7]<=32'hbf3504f3;///
    secondMult_real[8]<=32'h3f800000;secondMult_img[8]<=0;
    secondMult_real[9]<=32'h3f3504f3;secondMult_img[9]<=32'hbf3504f3;
    secondMult_real[10]<=32'h248d4000;secondMult_img[10]<=32'hbf800000; 
    secondMult_real[11]<=32'hbf3504f3;secondMult_img[11]<=32'hbf3504f3;///
    secondMult_real[12]<=32'h3f800000;secondMult_img[12]<=0;
    secondMult_real[13]<=32'h3f3504f3;secondMult_img[13]<=32'hbf3504f3;
    secondMult_real[14]<=32'h248d4000;secondMult_img[14]<=32'hbf800000; 
    secondMult_real[15]<=32'hbf3504f3;secondMult_img[15]<=32'hbf3504f3;///
  
    
    
    
    end
    //stage4
else if(counter==5'd20)
    begin
    firstAdd_real[0]<=float_real[0];firstAdd_img[0]<=float_img[0];firstMult_real[0]<=float_real[8];firstMult_img[0]<=float_img[8];sign[0]<=1'b0;
    firstAdd_real[1]<=float_real[1];firstAdd_img[1]<=float_img[1];firstMult_real[1]<=float_real[9];firstMult_img[1]<=float_img[9];sign[1]<=1'b0;
    firstAdd_real[2]<=float_real[2];firstAdd_img[2]<=float_img[2];firstMult_real[2]<=float_real[10];firstMult_img[2]<=float_img[10];sign[2]<=1'b0;
    firstAdd_real[3]<=float_real[3];firstAdd_img[3]<=float_img[3];firstMult_real[3]<=float_real[11];firstMult_img[3]<=float_img[11];sign[3]<=1'b0;
    firstAdd_real[4]<=float_real[4];firstAdd_img[4]<=float_img[4];firstMult_real[4]<=float_real[12];firstMult_img[4]<=float_img[12];sign[4]<=1'b0;
    firstAdd_real[5]<=float_real[5];firstAdd_img[5]<=float_img[5];firstMult_real[5]<=float_real[13];firstMult_img[5]<=float_img[13];sign[5]<=1'b0;
    firstAdd_real[6]<=float_real[6];firstAdd_img[6]<=float_img[6];firstMult_real[6]<=float_real[14];firstMult_img[6]<=float_img[14];sign[6]<=1'b0;
    firstAdd_real[7]<=float_real[7];firstAdd_img[7]<=float_img[7];firstMult_real[7]<=float_real[15];firstMult_img[7]<=float_img[15];sign[7]<=1'b0;
    firstAdd_real[8]<=float_real[0];firstAdd_img[8]<=float_img[0];firstMult_real[8]<=float_real[8];firstMult_img[8]<=float_img[8];sign[8]<=1'b1;
    firstAdd_real[9]<=float_real[1];firstAdd_img[9]<=float_img[1];firstMult_real[9]<=float_real[9];firstMult_img[9]<=float_img[9];sign[9]<=1'b1;
    firstAdd_real[10]<=float_real[2];firstAdd_img[10]<=float_img[2];firstMult_real[10]<=float_real[10];firstMult_img[10]<=float_img[10];sign[10]<=1'b1;
    firstAdd_real[11]<=float_real[3];firstAdd_img[11]<=float_img[3];firstMult_real[11]<=float_real[11];firstMult_img[11]<=float_img[11];sign[11]<=1'b1;
    firstAdd_real[12]<=float_real[4];firstAdd_img[12]<=float_img[4];firstMult_real[12]<=float_real[12];firstMult_img[12]<=float_img[12];sign[12]<=1'b1;
    firstAdd_real[13]<=float_real[5];firstAdd_img[13]<=float_img[5];firstMult_real[13]<=float_real[13];firstMult_img[13]<=float_img[13];sign[13]<=1'b1;
    firstAdd_real[14]<=float_real[6];firstAdd_img[14]<=float_img[6];firstMult_real[14]<=float_real[14];firstMult_img[14]<=float_img[14];sign[14]<=1'b1;
    firstAdd_real[15]<=float_real[7];firstAdd_img[15]<=float_img[7];firstMult_real[15]<=float_real[15];firstMult_img[15]<=float_img[15];sign[15]<=1'b1;

    
	secondMult_real[0]<=32'h3f800000;secondMult_img[0]<=0;
    secondMult_real[1]<=32'h3f6c835e;secondMult_img[1]<=32'hbec3ef15;
    secondMult_real[2]<=32'h3f3504f3;secondMult_img[2]<=32'hbf3504f3;
    secondMult_real[3]<=32'h3ec3ef15;secondMult_img[3]<=32'hbf6c835e;////////////
    secondMult_real[4]<=32'h248d4000;secondMult_img[4]<=32'hbf800000;
    secondMult_real[5]<=32'hbec3ef15;secondMult_img[5]<=32'hbf6c835e;
    secondMult_real[6]<=32'hbf3504f3;secondMult_img[6]<=32'hbf3504f3;
    secondMult_real[7]<=32'hbf6c835e;secondMult_img[7]<=32'hbec3ef15;
    secondMult_real[8]<=32'h3f800000;secondMult_img[8]<=0;
    secondMult_real[9]<=32'h3f6c835e;secondMult_img[9]<=32'hbec3ef15;
    secondMult_real[10]<=32'h3f3504f3;secondMult_img[10]<=32'hbf3504f3;//
    secondMult_real[11]<=32'h3ec3ef15;secondMult_img[11]<=32'hbf6c835e;////////
    secondMult_real[12]<=32'h248d4000;secondMult_img[12]<=32'hbf800000;
    secondMult_real[13]<=32'hbec3ef15;secondMult_img[13]<=32'hbf6c835e;
    secondMult_real[14]<=32'hbf3504f3;secondMult_img[14]<=32'hbf3504f3;
    secondMult_real[15]<=32'hbf6c835e;secondMult_img[15]<=32'hbec3ef15;
    end
    else 
    begin
    firstAdd_real[0]<=firstAdd_real[0];
    end
    
    
end
///////////end of first half
//////////star of second half
//updates the values on falling clock edge
always@(negedge clk)
begin
//stage 1
if(counter>5'd16)
    begin
        float_real[0]<=outAdd_real[0];float_img[0]<=outAdd_img[0];
        float_real[1]<=outAdd_real[1];float_img[1]<=outAdd_img[1];
        float_real[2]<=outAdd_real[2];float_img[2]<=outAdd_img[2];
        float_real[3]<=outAdd_real[3];float_img[3]<=outAdd_img[3];
        float_real[4]<=outAdd_real[4];float_img[4]<=outAdd_img[4];
        float_real[5]<=outAdd_real[5];float_img[5]<=outAdd_img[5];
        float_real[6]<=outAdd_real[6];float_img[6]<=outAdd_img[6];
        float_real[7]<=outAdd_real[7];float_img[7]<=outAdd_img[7];
        float_real[8]<=outAdd_real[8];float_img[8]<=outAdd_img[8];
        float_real[9]<=outAdd_real[9];float_img[9]<=outAdd_img[9];
        float_real[10]<=outAdd_real[10];float_img[10]<=outAdd_img[10];
        float_real[11]<=outAdd_real[11];float_img[11]<=outAdd_img[11];
        float_real[12]<=outAdd_real[12];float_img[12]<=outAdd_img[12];
        float_real[13]<=outAdd_real[13];float_img[13]<=outAdd_img[13];
        float_real[14]<=outAdd_real[14];float_img[14]<=outAdd_img[14];
        float_real[15]<=outAdd_real[15];float_img[15]<=outAdd_img[15];
    end
end

endmodule

//takes a 10 bit integer attained by an ADC and converts it to floating point. 
//assume all positive integers
module hexConv(input [9:0] num,output [31:0] float);
wire [3:0] count;


wire noZero=(num[9]==1'b1);
wire oneZero=(num[8]==1'b1)&&(num[9]==0);
wire twoZero=(num[7]==1'b1)&&(num[9:8]==0);
wire threeZero=(num[6]==1'b1)&&(num[9:7]==0);
wire fourZero=(num[5]==1'b1)&&(num[9:6]==0);
wire fiveZero=(num[4]==1'b1)&&(num[9:5]==0);
wire sixZero=(num[3]==1'b1)&&(num[9:4]==0);
wire sevenZero=(num[2]==1'b1)&&(num[9:3]==0);
wire eightZero=(num[1]==1'b1)&&(num[9:2]==0);
wire nineZero=(num[0]==1'b1)&&(num[9:1]==0);


//count the number of zeroes
wire [3:0] firstMask,secondMask,thirdMask,fourthMask;
assign firstMask[0]=oneZero||threeZero||fourZero||fiveZero||sevenZero||nineZero;
assign firstMask[3:1]=0;

assign secondMask[0]=0;
assign secondMask[1]=twoZero||threeZero||sixZero||sevenZero;
assign secondMask[3:2]=0;

assign thirdMask[1:0]=0;
assign thirdMask[2]=fourZero||fiveZero||sixZero||sevenZero;
assign thirdMask[3]=0;

assign fourthMask[3]=eightZero|nineZero;
assign fourthMask[2:0]=3'd0;
assign count={4{~noZero}}&(firstMask|secondMask|thirdMask|fourthMask);

//assume all positive
wire sign=1'b0;
wire [8:0] count2=9'd10-count;
wire [7:0] exponent=count2+8'd126;
//shift by count
wire [22:0] num2;
assign num2 [9:0]=num;
assign num2 [22:10]=0;
wire [22:0] shifted=num2<<(count+7'd14);

//zeromask
wire isZero=(num==0);
wire [31:0] ZeroMask={32{~isZero}};
//build float
wire [31:0] build;
assign build[31]=sign;
assign build[30:23]=exponent;
assign build[22:0]=shifted;

assign float=build&ZeroMask;
endmodule 

//fused complex multiply adders with one bit input to indicate addition or subtraction
module CFMA(input [31:0] A_real,A_img,B_real,B_img,C_real,C_img,output [31:0] real_out,img_out,input sign);
//take the exponents
wire [9:0] expA_real,expA_img;
wire [9:0] expB_real,expB_img;
assign expA_real[9:8]=0;
assign expA_img[9:8]=0;
assign expB_real[9:8]=0;
assign expB_img[9:8]=0;

assign expA_real[7:0]=A_real[30:23];
assign expA_img[7:0]=A_img[30:23];
assign expB_real[7:0]=B_real[30:23];
assign expB_img[7:0]=B_img[30:23];



//take mantissas
wire [48:0] MA_real,MA_img, MB_real,MB_img;
//t zero padding;
assign MA_real[48:24]=0;
assign MA_img[48:24]=0;
assign MB_real[48:24]=0;
assign MB_img[48:24]=0;
//take mantissas
assign MA_real[22:0]=A_real[22:0];
assign MA_img[22:0]=A_img[22:0];
assign MB_real[22:0]=B_real[22:0];
assign MB_img[22:0]=B_img[22:0];

//assign lead digit 
assign MA_real[23]=~(expA_real==0);
assign MA_img[23]=~(expA_img==0);
assign MB_real[23]=~(expB_real==0);
assign MB_img[23]=~(expB_img==0);

//multiply them together
wire [47:0] MR1,MR2,MI1,MI2;
assign MR1=MA_real*MB_real;
assign MR2=MA_img*MB_img;
assign MI1=MA_real*MB_img;
assign MI2=MB_real*MA_img;
//calculate exponents
wire SR1,SR2,SI1,SI2;
assign SR1=(A_real[31]^B_real[31])^sign;
assign SR2=(~(A_img[31]^B_img[31]))^sign;
assign SI1=(A_real[31]^B_img[31])^sign;
assign SI2=(B_real[31]^A_img[31])^sign;
//calculate exponents
wire [9:0] ER1,ER2,EI1,EI2;
//create zero masks first
wire ER1Z,ER2Z,EI1Z,EI2Z;
assign ER1Z=((expA_real+expB_real)<10'd126)||((expA_real==0)&&(MA_real==0))||((expB_real==0)&&(MB_real==0));
assign ER2Z=((expA_img+expB_img)<10'd126)||((expA_img==0)&&(MA_img==0))||((expB_img==0)&&(MB_img==0));
assign EI1Z=((expA_real+expB_img)<10'd126)||((expA_real==0)&&(MA_real==0))||((expB_img==0)&&(MB_img==0));
assign EI2Z=((expB_real+expA_img)<10'd126)||((expB_real==0)&&(MB_real==0))||((expA_img==0)&&(MA_img==0));


assign ER1=(expA_real+expB_real-10'd126)&{10{~ER1Z}};
assign ER2=(expA_img+expB_img-10'd126)&{10{~ER2Z}};
assign EI1=(expA_real+expB_img-10'd126)&{10{~EI1Z}};
assign EI2=(expB_real+expA_img-10'd126)&{10{~EI2Z}};


/////////////////////////////////////////////////////
//real   PART
//take in the values from C
//first the real values 
//take signs
wire SCR;
assign SCR=C_real[31];
wire [9:0] ECR;
assign ECR[7:0]=C_real[30:23];
assign ECR[9:8]=0;
//take mantissas
wire[48:0] MCR;
assign MCR[47]=~(ECR==0);
assign MCR[46:24]=C_real[22:0];
assign MCR[23:0]=0;
//extra padding at the end
assign MCR[48]=0;
//arrange by biggest exponents=
wire cFirstR=(ECR>=ER1)&&(ECR>=ER2);
wire cSecondR=((ECR<ER1)&&(ECR>=ER2))||((ECR<ER2)&&(ECR>=ER1));
wire cThirdR=(ECR<ER1)&&(ECR<ER2);


wire R1First=(ER1>ECR)&&(ER1>=ER2);
wire R1Second=((ER1<=ECR)&&(ER1>=ER2))||((ER1<ER2)&&(ER1>ECR));
wire R1Third=(ER1<=ECR)&&(ER1<ER2);


wire R2First=(ER2>ECR)&&(ER2>ER1);
wire R2Second=((ER2<=ECR)&&(ER2>ER1))||((ER2<=ER1)&&(ER2>ECR));
wire R2Third=(ER2<=ER1)&&(ER2<=ECR);


///arranged by order
wire [48:0] firstMR=(MCR&{49{cFirstR}})|(MR1&{49{R1First}})|(MR2&{49{R2First}});
wire [48:0] secondMR=(MCR&{49{cSecondR}})|(MR1&{49{R1Second}})|(MR2&{49{R2Second}});
wire [48:0] thirdMR=(MCR&{49{cThirdR}})|(MR1&{49{R1Third}})|(MR2&{49{R2Third}});

wire [7:0] firstER=(ECR&{10{cFirstR}})|(ER1&{10{R1First}})|(ER2&{10{R2First}});
wire [7:0] secondER=(ECR&{10{cSecondR}})|(ER1&{10{R1Second}})|(ER2&{10{R2Second}});
wire [7:0] thirdER=(ECR&{10{cThirdR}})|(ER1&{10{R1Third}})|(ER2&{10{R2Third}});


wire  firstSR=(SCR&{1{cFirstR}})|(SR1&{1{R1First}})|(SR2&{1{R2First}});
wire  secondSR=(SCR&{1{cSecondR}})|(SR1&{1{R1Second}})|(SR2&{1{R2Second}});
wire  thirdSR=(SCR&{1{cThirdR}})|(SR1&{1{R1Third}})|(SR2&{1{R2Third}});

//determine difference in exponents
wire [9:0] secondERdiff=firstER-secondER;
wire [9:0] thirdERdiff=firstER-thirdER;


//assign to stages
wire [50:0] firstMR_stage1;
wire [50:0] secondMR_stage1;
wire [50:0] thirdMR_stage1;
assign firstMR_stage1[48:0]=firstMR;
assign secondMR_stage1[48:0]=secondMR;
assign thirdMR_stage1[48:0]=thirdMR;
//zero padding
assign firstMR_stage1[50:49]=0;
assign secondMR_stage1[50:49]=0;
assign thirdMR_stage1[50:49]=0;


//stage 2
wire [50:0] firstMR_stage2=firstMR_stage1;
wire [50:0] secondMR_stage2=secondMR_stage1>>secondERdiff;
wire [50:0] thirdMR_stage2=thirdMR_stage1>>thirdERdiff;
//next change to 2s complicment
wire[50:0] signed_firstMR=((firstMR_stage2^{51{firstSR}})+firstSR);
wire[50:0] signed_secondMR=((secondMR_stage2^{51{secondSR}})+secondSR);
wire[50:0] signed_thirdMR=((thirdMR_stage2^{51{thirdSR}})+thirdSR);
//add them togther 
wire [50:0] signedSumR=signed_firstMR+signed_secondMR+signed_thirdMR;
wire sumSignR=signedSumR[50];
//find absolute value of product 
wire[50:0] absSumR=((signedSumR^{51{sumSignR}})+sumSignR);
wire [7:0] zR;
//count the number of zeroes
countZeroes zedR(absSumR,zR);
wire allZeroR=(zR==8'd51);
wire [9:0] zShiftR=zR&{10{~allZeroR}};
wire [9:0] eOffsetR=10'd3&{10{~allZeroR}};
wire [9:0] EXR0=firstER+eOffsetR-zShiftR;
wire[50:0] endShiftedR=absSumR<<(zShiftR-1);
wire[50:0] expShiftedR=absSumR<<firstER;
wire [50:0] rounderR;
wire [50:0] roundedR;
assign rounderR[23]=endShiftedR[23];
assign rounderR[50:24]=0;
assign rounderR[22:0]=0;
assign roundedR=endShiftedR+rounderR;
wire [50:0] roundedShiftR=roundedR<<(2-roundedR[50]);
wire [7:0] EXR=EXR0[7:0]+roundedR[50];
wire SR=sumSignR;
wire [22:0] MR=roundedShiftR[50:28];//+endShiftedR[74];

//////final result read
wire [31:0] finalR,preR;
assign preR[31]=SR;
assign preR[30:23]=EXR;
assign preR[22:0]=MR;
//mask if sum was all zero
assign finalR=preR&{32{~allZeroR}};

/////////////////////////////////////////////////////
//imaginary  PAIT
//take in the values from C
//first the real values 
//take signs
wire SCI;
assign SCI=C_img[31];
wire [9:0] ECI;
assign ECI[7:0]=C_img[30:23];
assign ECI[9:8]=0;
//take mantissas
wire[48:0] MCI;
assign MCI[47]=~(ECI==0);
assign MCI[46:24]=C_img[22:0];
assign MCI[23:0]=0;
//extra padding at the end
assign MCI[48]=0;
//arrange by biggest exponents=
wire cFirstI=(ECI>=EI1)&&(ECI>=EI2);
wire cSecondI=((ECI<EI1)&&(ECI>=EI2))||((ECI<EI2)&&(ECI>=EI1));
wire cThirdI=(ECI<EI1)&&(ECI<EI2);


wire I1First=(EI1>ECI)&&(EI1>=EI2);
wire I1Second=((EI1<=ECI)&&(EI1>=EI2))||((EI1<EI2)&&(EI1>ECI));
wire I1Third=(EI1<=ECI)&&(EI1<EI2);


wire I2First=(EI2>ECI)&&(EI2>EI1);
wire I2Second=((EI2<=ECI)&&(EI2>EI1))||((EI2<=EI1)&&(EI2>ECI));
wire I2Third=(EI2<=EI1)&&(EI2<=ECI);


///arranged by order
wire [48:0] firstMI=(MCI&{49{cFirstI}})|(MI1&{49{I1First}})|(MI2&{49{I2First}});
wire [48:0] secondMI=(MCI&{49{cSecondI}})|(MI1&{49{I1Second}})|(MI2&{49{I2Second}});
wire [48:0] thirdMI=(MCI&{49{cThirdI}})|(MI1&{49{I1Third}})|(MI2&{49{I2Third}});

wire [7:0] firstEI=(ECI&{10{cFirstI}})|(EI1&{10{I1First}})|(EI2&{10{I2First}});
wire [7:0] secondEI=(ECI&{10{cSecondI}})|(EI1&{10{I1Second}})|(EI2&{10{I2Second}});
wire [7:0] thirdEI=(ECI&{10{cThirdI}})|(EI1&{10{I1Third}})|(EI2&{10{I2Third}});


wire  firstSI=(SCI&{1{cFirstI}})|(SI1&{1{I1First}})|(SI2&{1{I2First}});
wire  secondSI=(SCI&{1{cSecondI}})|(SI1&{1{I1Second}})|(SI2&{1{I2Second}});
wire  thirdSI=(SCI&{1{cThirdI}})|(SI1&{1{I1Third}})|(SI2&{1{I2Third}});

//determine difference in exponents
wire [9:0] secondEIdiff=firstEI-secondEI;
wire [9:0] thirdEIdiff=firstEI-thirdEI;


//assign to stages
wire [50:0] firstMI_stage1;
wire [50:0] secondMI_stage1;
wire [50:0] thirdMI_stage1;
assign firstMI_stage1[48:0]=firstMI;
assign secondMI_stage1[48:0]=secondMI;
assign thirdMI_stage1[48:0]=thirdMI;
//zero padding
assign firstMI_stage1[50:49]=0;
assign secondMI_stage1[50:49]=0;
assign thirdMI_stage1[50:49]=0;


//stage 2
wire [50:0] firstMI_stage2=firstMI_stage1;
wire [50:0] secondMI_stage2=secondMI_stage1>>secondEIdiff;
wire [50:0] thirdMI_stage2=thirdMI_stage1>>thirdEIdiff;
//next change to 2s complicment
wire[50:0] signed_firstMI=((firstMI_stage2^{51{firstSI}})+firstSI);
wire[50:0] signed_secondMI=((secondMI_stage2^{51{secondSI}})+secondSI);
wire[50:0] signed_thirdMI=((thirdMI_stage2^{51{thirdSI}})+thirdSI);
//add them togther 
wire [50:0] signedSumI=signed_firstMI+signed_secondMI+signed_thirdMI;
wire sumSignI=signedSumI[50];
//find absolute value of product 
wire[50:0] absSumI=((signedSumI^{51{sumSignI}})+sumSignI);
wire [7:0] zI;
//count the number of zeroes
countZeroes zedI(absSumI,zI);
wire allZeroI=(zI==8'd51);
wire [9:0] zShiftI=zI&{10{~allZeroI}};
wire [9:0] eOffsetI=10'd3&{10{~allZeroI}};
wire [9:0] EXI0=firstEI+eOffsetI-zShiftI;
wire[50:0] endShiftedI=absSumI<<(zShiftI-1);
wire[50:0] expShiftedI=absSumI<<firstEI;
wire [50:0] rounderI;
wire [50:0] roundedI;
assign rounderI[23]=endShiftedI[23];
assign rounderI[50:24]=0;
assign rounderI[22:0]=0;
assign roundedI=endShiftedI+rounderI;
wire [50:0] roundedShiftI=roundedI<<(2-roundedI[50]);
wire [7:0] EXI=EXI0[7:0]+roundedI[50];
wire SI=sumSignI;
wire [22:0] MI=roundedShiftI[50:28];//+endShiftedI[74];

//////final result read
wire [31:0] finalI,preI;
assign preI[31]=SI;
assign preI[30:23]=EXI;
assign preI[22:0]=MI;
//mask if sum was all zero
assign finalI=preI&{32{~allZeroI}};



assign real_out=finalR;
assign img_out=finalI;
//assign img_out=0;

endmodule

module countZeroes(input [50:0] m,output [7:0] zeroes);
//26

reg [7:0] count;
assign zeroes=count;
always@(*)
begin
if(m[50])begin count=8'd0; end
else if(m[49])begin count=8'd1;end
else if(m[48])begin count=8'd2;end
else if(m[47])begin count=8'd3;end
else if(m[46])begin count=8'd4;end
else if(m[45])begin count=8'd5;end
else if(m[44])begin count=8'd6;end
else if(m[43])begin count=8'd7;end
else if(m[42])begin count=8'd8;end
else if(m[41])begin count=8'd9;end
else if(m[40])begin count=8'd10;end
else if(m[39])begin count=8'd11;end
else if(m[38])begin count=8'd12;end
else if(m[37])begin count=8'd13;end
else if(m[36])begin count=8'd14;end
else if(m[35])begin count=8'd15;end
else if(m[34])begin count=8'd16;end
else if(m[33])begin count=8'd17;end
else if(m[32])begin count=8'd18;end
else if(m[31])begin count=8'd19;end
else if(m[30])begin count=8'd20;end
else if(m[29])begin count=8'd21;end
else if(m[28])begin count=8'd22;end
else if(m[27])begin count=8'd23;end
else if(m[26])begin count=8'd24;end
else if(m[25])begin count=8'd25;end
else if(m[24])begin count=8'd26;end
else if(m[23])begin count=8'd27;end
else if(m[22])begin count=8'd28;end
else if(m[21])begin count=8'd29;end
else if(m[20])begin count=8'd30;end
else if(m[19])begin count=8'd31;end
else if(m[18])begin count=8'd32;end
else if(m[17])begin count=8'd33;end
else if(m[16])begin count=8'd34;end
else if(m[15])begin count=8'd35;end
else if(m[14])begin count=8'd36;end
else if(m[13])begin count=8'd37;end
else if(m[12])begin count=8'd38;end
else if(m[11])begin count=8'd39;end
else if(m[10])begin count=8'd40;end
else if(m[9])begin count=8'd41;end
else if(m[8])begin count=8'd42;end
else if(m[7])begin count=8'd43;end
else if(m[6])begin count=8'd44;end
else if(m[5])begin count=8'd45;end
else if(m[4])begin count=8'd46;end
else if(m[3])begin count=8'd47;end
else if(m[2])begin count=8'd48;end
else if(m[1])begin count=8'd49;end
else if(m[0])begin count=8'd50;end
else begin count=8'd51; end 
end
endmodule


