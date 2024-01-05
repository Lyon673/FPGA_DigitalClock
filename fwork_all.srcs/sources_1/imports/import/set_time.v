`timescale 1ns / 1ps

module set_time(
    clk,            //125MHz，系统时钟
    set,	    //设置时间的按钮
    rst,      	    //复位键
    value,	    //要设置的时间值，为sw输入
    Hour,	    //见下方解释
    Thousand,
    Hundred,
    Ten,
    One
);


//**************************************************************************************
//
// 在本次项目设计中，基本计时模块由一个计数变量进行逐秒的计数，再分别求模得到小时、分钟、秒钟的数值。
// 该时间数据在后续模块中传递时都是以00：00：00的方式传递
// 其中带有Hour名称的变量都是表示小时的二进制值，在不同模块有前后缀区分
// 带有Thousand和Hundred名称的变量分别表示分钟的十位和个位的值，在不同模块有前后缀区分
// 带有Ten和One名称的变量分别表示秒钟的十位和个位的值，在不同模块有前后缀区分
//
//**************************************************************************************




    input clk,set,rst;
    input [5:0] value;
    output reg [4:0] Hour;
    output reg [3:0]  Thousand,Hundred,Ten,One;

    
    reg setflag;//标志，存储set上一个时钟的值，用于实现set的下降沿触发；
    reg [2:0] state;
    reg [4:0] valuehour,valuethou,valuehun,valueten,valueone;
    reg [20:0] data;//用于计时；
    
    reg [30:0] count_1hz;
    
    reg [20:0] d0;
    reg [20:0] d1;   
    reg [20:0] d2;
    reg [20:0] d3;
    reg [20:0] d4;
    
    reg [20:0] data_add_hour,data_add_thou,data_add_hun,data_add_ten,data_add_one;
    
    always@(posedge clk )
    begin
    
        if(setflag&&(!set))//判断按钮BTN2是否按下，下降沿触发；
        begin
            state=(state+1)%5;//产生5种状态，对应按下BTN2的次数
        end
        
        if(state==0)//状态0，相当于一次不按；
        begin
            
            if(rst)//检查复位信号；
            begin
                data=0;
            end
            
            count_1hz=count_1hz+1;
            if(count_1hz==125000000-1)//1秒钟；
                begin
                data=data+1;//每隔1秒，data+1；即data用来计时；
                count_1hz=0;
                end
                
            d0 = data;
            d1 = d0%60%10;//分离秒钟个位；
            One = d1[3:0];
            d2 = (d0%60)/10;//分离秒钟十位；
            Ten = d2[3:0];
            d0 = d0/60;
            d3 = (d0%60)%10;//分离分钟个位；
            Hundred = d3[3:0];
            d4 = (d0%60)/10;//分离分钟十位；
            Thousand = d4[3:0];
            d0 = d0/60;//分离小时；
            Hour = d0[4:0];
            
            
        end
        
        if(state==1)//状态1，即按一次BTN2，四个数码管全不亮，led亮，设置小时；
        begin
            Thousand<=4'b1111;
            Hundred<=4'b1111;
            Ten<=4'b1111;
            One<=4'b1111;
            valuehour<=value[4:0];
            Hour<=valuehour;
            
        end 
        
        if(state==2)//状态2，即按两次BTN2，秒钟数码管不亮，led不亮，设置分钟；
        begin
            valuethou=value/10;
            valuehun=value%10;
            Thousand<=valuethou[3:0];
            Hundred<=valuehun[3:0];
            Ten<=4'b1111;
            One<=4'b1111;
            Hour<=5'b00000;
         
        end 
        
        if(state==3)//状态3，即按三次BTN2，分钟数码管不亮，led不亮，设置秒钟；
        begin
            valueten=value/10;
            valueone=value%10;
            Thousand<=4'b1111;
            Hundred<=4'b1111;
            Ten<=valueten[3:0];
            One<=valueone[3:0];
            Hour<=5'b00000;
          
        end 
            
        if(state==4)//状态4，即按四次BTN2，显示当前时间，从设置值开始计时；
        begin
            state=0;
            data_add_hour[4:0]=valuehour;
            data_add_thou[4:0]=valuethou;
            data_add_hun[4:0]=valuehun;
            data_add_ten[4:0]=valueten;
            data_add_one[4:0]=valueone;
            data=data_add_hour*3600+data_add_thou*600+data_add_hun*60+data_add_ten*10+data_add_one;//将data更新为设置值，以便时钟从设置值开始计时；
         end
        
        setflag=set;
    end   
    
endmodule
