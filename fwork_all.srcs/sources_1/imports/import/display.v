`timescale 1ns / 1ps
//控制数码管，led显示情况；
module display(
        sel,
        clk,
        Hour,
        Thousand,
        Hundred,
        Ten,
        One,
        seg,
        led
    );
    input clk;
    input  [4:0] Hour;
    input  [3:0]  Thousand,Hundred,Ten,One;
    output reg [7:0] seg;
    output reg [4:0] led;
    output reg [3:0] sel;
    
    reg [3:0] data_dis;
    reg [20:0] m;
         
    always@(posedge clk) 
    begin
        m<=m+1;
    end
  
    always@(m[15]) //截取一个频率信号；
    begin
        case(m[17:15])
        0:  begin
                data_dis<=4'b1111;//四个数码管都工作，但不显示数值；
                sel<=4'b0000;
            end
        1:  begin
                data_dis<=Thousand;//分钟十位数码管被赋值；
                sel<=4'b0111;//分钟十位数码管工作；
            end
        2:  begin
                data_dis<=Hundred;//分钟个位数码管被赋值；
                sel<=4'b1011; //分钟个位数码管工作；       
            end
        3:  begin
                data_dis<=Ten;//秒钟十位数码管被赋值；
                sel<=4'b1101;//秒钟十位数码管工作；
            end
        4:  begin
                data_dis<=One; //秒钟个位数码管被赋值；  
                sel<=4'b1110;  //秒钟个位数码管工作；      
            end
        5:  begin
                led <= Hour;//小时led被赋值；
            end
        default:  begin//led，数码管全不亮；
                data_dis<=4'b1111;
                led <=5'b00000;
                sel<=4'b0000;
            end    
        endcase
    end

    always@(data_dis)
    begin
        case(data_dis)                //�߶�����
            4'h0:seg = 8'b11000000;        //��ʾ0
            4'h1:seg = 8'b11111001;        //��ʾ1
            4'h2:seg = 8'b10100100;        //��ʾ2
            4'h3:seg = 8'b10110000;        //��ʾ3
            4'h4:seg = 8'b10011001;        //��ʾ4
            4'h5:seg = 8'b10010010;        //��ʾ5
            4'h6:seg = 8'b10000010;        //��ʾ6
            4'h7:seg = 8'b11111000;        //��ʾ7
            4'h8:seg = 8'b10000000;        //��ʾ8
            4'h9:seg = 8'b10010000;        //��ʾ9
            4'hF:seg = 8'b11111111;        //����ʾ
            default seg = 8'hxx;
        endcase
    end
    
endmodule
