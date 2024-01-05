`timescale 1ns / 1ps
//到达设置的闹铃时亮led
module Clocking(
        clk,            //125MHz
        set,            //设置闹铃的按钮BTN[3]
        value,          //从switch输入的预想设置值
        oldHour,        //从上个模块传递来的时间值，以old开头
        oldThousand,
        oldHundred,
        oldTen,
        oldOne,
        en,             //从UART模块输出的使能信号
        Hour,           //传递出的时间值，没有额外前后缀
        Thousand,
        Hundred,
        Ten,
        One,
        clkHour,        //设置的闹铃值，以clk开头
        clkThousand,
        clkHundred,
        clkTen,
        clkOne,
        led             //标志处于闹铃状态的led输出
    
    );
    
    input clk,set;
    input [5:0] value;
    input [4:0] oldHour;
    input [3:0]  oldThousand,oldHundred,oldTen,oldOne;
    input en;
    output reg [4:0] Hour,clkHour;
    output reg [3:0]  Thousand,Hundred,Ten,One,clkThousand,clkHundred,clkTen,clkOne;
    output reg led;
    
    reg setflag;            //用于set的下降沿触发
    reg [2:0] state;        //存当前设置闹铃的4个状态，为不在设置，设置小时，设置分钟，设置秒钟
    reg [4:0] valuehour,valuethou,valuehun,valueten,valueone;   //存设置的闹铃时间值
    
    reg [40:0] count_3s=0;    //3秒计数，为了让led亮三秒
    reg flag;               //与en使能信号配合
    
    always@(posedge clk)
    begin
    if(setflag&&(!set))     //set下降沿触发，每次按set切换状态，0~3
        begin
            state=(state+1)%4;
        end
    
    
      if(state==0)//状态0，即按0次BTN3
        begin
            Thousand<=oldThousand;
            Hundred<=oldHundred;
            Ten<=oldTen;
            One<=oldOne;
            Hour<=oldHour;//不做改动，将原来的时钟赋值给现在新的变量即可，仅将前一级输出作为后一级输入
            
            if(valuehour+valuethou+valuehun+valueten+valueone!=0)begin//在设置值不全为0的情况下，将设置的闹铃时间赋值给clk系列变量输出。传递给后面music模块
                clkHour<=valuehour;
                clkThousand<=valuethou[3:0];
                clkHundred<=valuehun[3:0];
                clkTen<=valueten[3:0];
                clkOne<=valueone[3:0];
            end
             
             if( (oldThousand==valuethou[3:0])&&(oldHundred==valuehun[3:0])&&(oldTen==valueten[3:0])&&(oldOne==valueone[3:0])&&(oldHour==valuehour)&&(valuehour+valuethou+valuehun+valueten+valueone!=0))
             begin//判断当前时间是否来到闹铃设置时间；
             if(en==0)begin//与第七个要求串口通信有关，使能信号为0，即此时闹铃声音，指示灯、整点声音，指示灯正常工作；
             flag=1;
             end
             end
             
             if(flag==1)//若正常工作，控制led[7]亮三秒；
             begin
                 count_3s=count_3s+1;
                 led=1;
                 if(count_3s==125000000*3-1)//内置时钟为125MHz，3s即为125000000*3-1；
                 begin
                 led=0;             
                 count_3s=0;
                 flag=0;
                 end
             end
        end
        
        if(state==1)//状态1，即按一次BTN3；四个数码管全不亮，设置闹铃的小时；
        begin
            Thousand<=4'b1111;
            Hundred<=4'b1111;
            Ten<=4'b1111;
            One<=4'b1111;
            valuehour<=value[4:0];
            Hour<=valuehour;
            
        end 
        
        if(state==2)//状态2，即按两次BTN3；小时led不亮，秒钟两个数码管不亮，设置闹铃的分钟；
        begin
            valuethou=value/10;
            valuehun=value%10;
            Thousand<=valuethou[3:0];
            Hundred<=valuehun[3:0];
            Ten<=4'b1111;
            One<=4'b1111;
            Hour<=5'b00000;
         
        end 
        
        if(state==3)//状态3，即按三次BTN3；小时led不亮，分钟两个数码管不亮，设置闹铃的秒钟；
        begin
            valueten=value/10;
            valueone=value%10;
            Thousand<=4'b1111;
            Hundred<=4'b1111;
            Ten<=valueten[3:0];
            One<=valueone[3:0];
            Hour<=5'b00000;
          
        end 
            
        
        setflag=set;//每次时钟上升沿到来，将set值赋给setflag，标志set按钮按下情况；
    end   
    
    
    
    
endmodule
