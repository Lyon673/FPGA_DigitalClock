`timescale 1ns / 1ps

module music(
    input wire sys_clk,			//125MHz
    input wire clk_1Hz,
    input wire [4:0] Hour,		//从Clocking模块传递的实时时间数据
    input wire [3:0] Thousand,
    input wire [3:0] Hundred,
    input wire [3:0] Ten,
    input wire [3:0] One,
    input wire [4:0] clkHour,		//从Clocking模块传入的设置好的闹铃时间,以clk开头
    input wire [3:0] clkThousand,
    input wire [3:0] clkHundred,
    input wire [3:0] clkTen,
    input wire [3:0] clkOne,
    input wire en,
    // SSM2603
    inout  wire AC_BCLK,
    output wire AC_MCLK,
    output wire AC_MUTEN,
    output wire AC_PBDAT,
    output wire AC_PBLRC,
    input  wire AC_RECDAT,
    output wire AC_RECLRC,
    output wire AC_SCL,
    inout  wire AC_SDA,

    input wire reset

    );

    wire clk_24M;

    
    reg enable;
    
    
    reg [2:0]cnt;//计时，控制音乐播放为3秒；
    reg [30:0] count_1hz=0;
    reg flag;//标志，表明整点和闹铃是否到来；
        always @(posedge sys_clk)begin
            if(reset)begin
                enable=0;//控制正弦波音乐信号；
            end
            
            else if(!Thousand&&!Hundred&&!Ten&&!One)begin//判断整点是否到来；
            flag=1;
            end
            
            
            //判断闹铃是否到来，以及串口通信使能信号是否输出为0（常态下，en=0，表明闹铃正常工作）
             if((Hour==clkHour)&&(Thousand==clkThousand)&&(Hundred==clkHundred)&&(Ten==clkTen)&&(One==clkOne)&&(clkThousand+clkHundred+clkTen+clkOne!=0)&&(en==0))begin
                flag=1;
                end
                
                
       
                
            if(flag==1)begin
                count_1hz=count_1hz+1;
                enable=1;//正弦波正常播放；
                    if(count_1hz==125000000*3-1)//三秒到来
                        begin
                        flag=0;
                        enable=0;//正弦波播放被阻断；
                        count_1hz=0;
                        end
            
            end
        end
        
    
    
    recorder recoder(//音频录放机，我们只使用播放音乐的部分，录音和音量控制部分不进行例化，引脚悬空；
         .en(enable),
        .clk(sys_clk),
        .reset(reset),
        .AC_BCLK(AC_BCLK),
        .AC_MCLK(AC_MCLK),
        .AC_MUTEN(AC_MUTEN),
        .AC_PBDAT(AC_PBDAT),
        .AC_PBLRC(AC_PBLRC),
        .AC_RECDAT(AC_RECDAT),
        .AC_RECLRC(AC_RECLRC),
        .AC_SCL(AC_SCL),
        .AC_SDA(AC_SDA), 
        .LEDREC(),
        .LEDTONE(), 
        .LEDPLAY(), 
        .LEDFEEDBACK(), 
        .t_node()
        );
    
   
    
endmodule
