`timescale 1ns / 1ps

module clocking(
        clk,            //125MHz
        set,
        value,
        oldHour,
        oldThousand,
        oldHundred,
        oldTen,
        oldOne,
        en,
        Hour,
        Thousand,
        Hundred,
        Ten,
        One,
        clkHour,
        clkThousand,
        clkHundred,
        clkTen,
        clkOne,
        led 
    
    );
    
    input clk,set;
    input [5:0] value;
    input [4:0] oldHour;
    input [3:0]  oldThousand,oldHundred,oldTen,oldOne;
    input en;
    output reg [4:0] Hour,clkHour;
    output reg [3:0]  Thousand,Hundred,Ten,One,clkThousand,clkHundred,clkTen,clkOne;
    output reg led;
    
    reg setflag;//标志，表明按钮是否按下；
    reg [2:0] state;
    reg [4:0] valuehour,valuethou,valuehun,valueten,valueone;//闹钟设置，小时，分钟十位、个位，秒十位、个位；
    
    reg [30:0] count_3s;//三秒计时，控制led[7]亮的时间；
    reg flag;//标志，决定led[7]是否正常工作；
    
    always@(posedge clk)
    begin
    if(setflag&&(!set))//判断是否按下BTN3按钮;
        begin
            state=(state+1)%4; //产生4种状态，对应按下BTN3的次数
        end
    
    
      if(state==0)//状态0，即按0次BTN3
        begin
            Thousand<=oldThousand;
            Hundred<=oldHundred;
            Ten<=oldTen;
            One<=oldOne;
            Hour<=oldHour;  //不做改动，将原来的时钟赋值给现在新的变量即可；
            
            if(valuehour+valuethou+valuehun+valueten+valueone!=0)begin  //在设置值不全为0的情况下，将设置的闹铃时间赋值给clk系列变量保存；
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
