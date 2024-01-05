`timescale 1ns / 1ps

module time_transfrom(
    clk,
    hour,
    hour2,
    led,
    mode
);
    input clk;
    input mode;
    input [4:0] hour;
    output reg [4:0] hour2;
    output reg led;

    reg  modeflag = 0;
    reg  state;

    always@(posedge clk)    
    begin 
        if(modeflag&&(!mode))
        begin
            state = !state;
        end
        if(state)
        begin
            hour2<=hour%12;
            led<=hour/12;
        end else begin
            hour2<=hour;
            led<=0;
        end
        modeflag=mode;
    end

endmodule

    
