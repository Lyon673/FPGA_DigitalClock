`timescale 1ns / 1ps

module divfreq_1Hz(
        clk_in,
        rst,
        clk_1hz
    );
    
    input clk_in;
    input rst;
    output reg clk_1hz;//产生1Hz的时钟；
    
    reg [30:0] count1, count2;
    
    always @(posedge clk_in or posedge rst)
    begin
    if(rst)
        begin
            count1 <= 0; 
            clk_1hz <= 0;  
        end
    else
        begin
            if (count1 < 62500000)   //前半秒，使时钟clk_1hz为高电平；   
                begin
                    count1 <= count1 + 1; 
                    clk_1hz <= 1;   
                end
            else if (count1 < 125000000-1)//后半秒，使时钟clk_1hz为低电平；
                begin
                    count1 <= count1 + 1;   
                    clk_1hz <= 0;   
                end
            else
                begin//count1计数超出一个周期，归零，重新开始；
                    count1 <= 0;    
                    clk_1hz <= 0;   
                end
        end
    end
    
    
    
    
    
    
endmodule
