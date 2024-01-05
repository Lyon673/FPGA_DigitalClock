`timescale 1ns / 1ps
//本次数字钟的顶层设计模块
module top(
           clk,         //系统时钟，125MHz
           rst,         //复位信号
           seg,         //七段数码管输出
           sel,         //七段数码管使能
           BTN,         //按钮输入
           sw,          //开关输入
           led,         //led输出
           AC_BCLK,     //AC开头的下面几个变量为音频编解码器端口
           AC_MCLK,
           AC_MUTEN,
           AC_PBDAT,
           AC_PBLRC,
           AC_RECDAT,
           AC_RECLRC,
           AC_SCL,
           AC_SDA,
           uart_rxd,    //UART端口
           uart_txd
    );
    
    //以下为声明
    input clk,rst;
    input [3:1] BTN;
    input [5:0] sw;
    output  [7:0] seg;
    output  [7:0] led;
    output  [3:0] sel;
    
    inout  wire AC_BCLK;
    output wire AC_MCLK;
    output wire AC_MUTEN;
    output wire AC_PBDAT;
    output wire AC_PBLRC;
    input  wire AC_RECDAT;
    output wire AC_RECLRC;
    output wire AC_SCL;
    inout  wire AC_SDA;
    
    input uart_rxd;
    output uart_txd;
    
    wire clk_1hz;           //1Hz的时钟信号
    wire [3:0]  set_Thousand,set_Hundred,set_Ten,set_One;           //set_time模块输出的时间数据
    //在本次设计中，名称中带Hour的变量为小时数值，Thousand,Hundred为分钟的十位和个位，Ten,One为秒的十位和个位
    wire [3:0]  clk_Thousand,clk_Hundred,clk_Ten,clk_One;           //闹铃模块输出的实时时间
    wire [3:0]  clkThousand,clkHundred,clkTen,clkOne;               //闹铃设置的值
    wire [4:0] set_Hour,clk_Hour,Hour24To12;   //从左向右分别为set_time模块输出的小时值，clocking模块输出的小时值，12和24转换的小时值
    wire en;
    wire [3:0]dBTN;
    
    //分频模块，将系统时钟分频为1Hz时钟
    divfreq_1Hz divfreq_1Hz(
           .clk_in(clk),
           .rst(rst),
           .clk_1hz(clk_1hz)
    );
    
    debounce0 dset(
                 .clk(clk), 
                 .sw_in(BTN[2]),
                 .sw_out(dBTN[2])
    );
    
    //设置时间模块，初始设置为00：00：00
    set_time set_time(  
            .clk(clk),
            .set(dBTN[2]),
            .rst(rst),
            .value(sw),
            .Hour(set_Hour),
            .Thousand(set_Thousand),
            .Hundred(set_Hundred),
            .Ten(set_Ten),
            .One(set_One)
      );
      
      //UART模块，输出en使能信号
    UART_crl UART_crl(
    
            .sys_clk(clk),
            .reset(rst),
            .uart_rxd(uart_rxd),
            .uart_txd(uart_txd),
            .en(en)
   
    );
      
      debounce0 dClocking(
             .clk(clk), 
             .sw_in(BTN[3]),
             .sw_out(dBTN[3])
      
      );
      
      //闹铃模块，设置闹铃时间，并在闹铃时间led[7]亮
    Clocking Clocking(
            .clk(clk),           
            .set(dBTN[3]),
            .value(sw),
            .oldHour(set_Hour),
            .oldThousand(set_Thousand),
            .oldHundred(set_Hundred),
            .oldTen(set_Ten),
            .oldOne(set_One),
            .en(en),
            .Hour(clk_Hour),
            .Thousand(clk_Thousand),
            .Hundred(clk_Hundred),
            .Ten(clk_Ten),
            .One(clk_One),
            .clkHour(clkHour),
            .clkThousand(clkThousand),
            .clkHundred(clkHundred),
            .clkTen(clkTen),
            .clkOne(clkOne),
            .led(led[7]) 
    );
    
    //音频播放模块，当整点或者到达设置的闹铃时播放正弦波
     music music(
             .sys_clk(clk),
             .clk_1Hz(clk_1hz),
             .Hour(clk_Hour),
             .Thousand(clk_Thousand),
             .Hundred(clk_Hundred),
             .Ten(clk_Ten),
             .One(clk_One),
             .clkHour(clkHour),
             .clkThousand(clkThousand),
             .clkHundred(clkHundred),
             .clkTen(clkTen),
             .clkOne(clkOne),
             .en(en),
             .AC_BCLK(AC_BCLK),
             .AC_MCLK(AC_MCLK),
             .AC_MUTEN(AC_MUTEN),
             .AC_PBDAT(AC_PBDAT),
             .AC_PBLRC(AC_PBLRC),
             .AC_RECDAT(AC_RECDAT),
             .AC_RECLRC(AC_RECLRC),
             .AC_SCL(AC_SCL),
             .AC_SDA(AC_SDA),
             .reset(rst)
    
    );
    
    debounce0 dtran(
                 .clk(clk), 
                 .sw_in(BTN[1]),
                 .sw_out(dBTN[1])
    );
    
    //时制转换，12小时制和24小时制转换
     time_transfrom time_transfrom(
            .clk(clk),
            .hour(clk_Hour),
            .hour2(Hour24To12),
            .led(led[5]),
            .mode(dBTN[1])
    );
    
    //显示模块，显示小时、分钟、秒
    display display(
            .sel(sel),
            .clk(clk),
            .Hour(Hour24To12),
            .Thousand(clk_Thousand),
            .Hundred(clk_Hundred),
            .Ten(clk_Ten),
            .One(clk_One),
            .seg(seg),
            .led(led[4:0])
    );
     
     //整点报时，到达整点时led亮
     blinking blinking(
           .hour(clk_Hour),
           .thousand(clk_Thousand),
           .hundred(clk_Hundred),
           .ten(clk_Ten),
           .one(clk_One),
           .led(led[6]),
           .clk1(clk_1hz)             
           
     );
     


endmodule
