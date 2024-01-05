`timescale 1ns / 1ps

module time_transfrom(
    clk,
    hour,
    hour2,
    led,
    mode//转换按钮，BTN1；
);
    input clk;
    input mode;
    input [4:0] hour;
    output reg [4:0] hour2;
    output reg led;

    reg  modeflag = 0;//标志，表明按钮是否被按下；
    reg  state;//表明状态；

    always@(posedge clk)    
    begin 
        if(modeflag&&(!mode))//判断按钮是否按下，下降沿触发；
        begin
            state = !state;//按下则状态反转；
        end
        if(state)//12小时显示；
        begin
            hour2<=hour%12;
            led<=hour/12;//决定led[5]是否亮起
        end else begin//24小时显示；
            hour2<=hour;
            led<=0;
        end
        modeflag=mode;//每个时钟上升沿到来，将mode的值赋给modeflag,表明按钮是否按下；
    end

endmodule

    
