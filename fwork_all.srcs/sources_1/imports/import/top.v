`timescale 1ns / 1ps
//���������ӵĶ������ģ��
module top(
           clk,         //ϵͳʱ�ӣ�125MHz
           rst,         //��λ�ź�
           seg,         //�߶���������
           sel,         //�߶������ʹ��
           BTN,         //��ť����
           sw,          //��������
           led,         //led���
           AC_BCLK,     //AC��ͷ�����漸������Ϊ��Ƶ��������˿�
           AC_MCLK,
           AC_MUTEN,
           AC_PBDAT,
           AC_PBLRC,
           AC_RECDAT,
           AC_RECLRC,
           AC_SCL,
           AC_SDA,
           uart_rxd,    //UART�˿�
           uart_txd
    );
    
    //����Ϊ����
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
    
    wire clk_1hz;           //1Hz��ʱ���ź�
    wire [3:0]  set_Thousand,set_Hundred,set_Ten,set_One;           //set_timeģ�������ʱ������
    //�ڱ�������У������д�Hour�ı���ΪСʱ��ֵ��Thousand,HundredΪ���ӵ�ʮλ�͸�λ��Ten,OneΪ���ʮλ�͸�λ
    wire [3:0]  clk_Thousand,clk_Hundred,clk_Ten,clk_One;           //����ģ�������ʵʱʱ��
    wire [3:0]  clkThousand,clkHundred,clkTen,clkOne;               //�������õ�ֵ
    wire [4:0] set_Hour,clk_Hour,Hour24To12;   //�������ҷֱ�Ϊset_timeģ�������Сʱֵ��clockingģ�������Сʱֵ��12��24ת����Сʱֵ
    wire en;
    wire [3:0]dBTN;
    
    //��Ƶģ�飬��ϵͳʱ�ӷ�ƵΪ1Hzʱ��
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
    
    //����ʱ��ģ�飬��ʼ����Ϊ00��00��00
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
      
      //UARTģ�飬���enʹ���ź�
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
      
      //����ģ�飬��������ʱ�䣬��������ʱ��led[7]��
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
    
    //��Ƶ����ģ�飬��������ߵ������õ�����ʱ�������Ҳ�
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
    
    //ʱ��ת����12Сʱ�ƺ�24Сʱ��ת��
     time_transfrom time_transfrom(
            .clk(clk),
            .hour(clk_Hour),
            .hour2(Hour24To12),
            .led(led[5]),
            .mode(dBTN[1])
    );
    
    //��ʾģ�飬��ʾСʱ�����ӡ���
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
     
     //���㱨ʱ����������ʱled��
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
