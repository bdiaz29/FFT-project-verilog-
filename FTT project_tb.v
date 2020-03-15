`timescale 1ns / 1ps


module project_tb(

    );
    
    reg clk;reg start;reg [9:0] number;wire[1:0] state;wire [31:0] real_num;wire [31:0] img_num;
    project UUT1( clk, start, number, state,real_num, img_num);
    initial begin
    //start the data transfer by sending the start signal
    start=1'b1;
    clk=0;
    #10
    //send in the data
    number=10'd10;
    #10
    start=1'b0;
    number=10'd18;
    #10
    number=10'd19;
    #10
    number=10'd12;
    #10
    number=10'd3;
    #10
    number=10'd0;
    #10
    number=10'd6;
    #10
    start=1'b0;
    number=10'd15;
    #10
    number=10'd20;
    #10
    number=10'd16;
    #10
    number=10'd7;
    #10
    number=10'd0;
    #10
    number=10'd2;
    #10
    number=10'd11;
    #10
    number=10'd19;
    #10
    number=10'd19;
    end
  
  
//clock  
    always begin
     #5 clk=~clk;
      end
endmodule
