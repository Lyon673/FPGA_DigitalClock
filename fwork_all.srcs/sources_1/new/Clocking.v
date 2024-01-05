`timescale 1ns / 1ps
//�������õ�����ʱ��led
module Clocking(
        clk,            //125MHz
        set,            //��������İ�ťBTN[3]
        value,          //��switch�����Ԥ������ֵ
        oldHour,        //���ϸ�ģ�鴫������ʱ��ֵ����old��ͷ
        oldThousand,
        oldHundred,
        oldTen,
        oldOne,
        en,             //��UARTģ�������ʹ���ź�
        Hour,           //���ݳ���ʱ��ֵ��û�ж���ǰ��׺
        Thousand,
        Hundred,
        Ten,
        One,
        clkHour,        //���õ�����ֵ����clk��ͷ
        clkThousand,
        clkHundred,
        clkTen,
        clkOne,
        led             //��־��������״̬��led���
    
    );
    
    input clk,set;
    input [5:0] value;
    input [4:0] oldHour;
    input [3:0]  oldThousand,oldHundred,oldTen,oldOne;
    input en;
    output reg [4:0] Hour,clkHour;
    output reg [3:0]  Thousand,Hundred,Ten,One,clkThousand,clkHundred,clkTen,clkOne;
    output reg led;
    
    reg setflag;            //����set���½��ش���
    reg [2:0] state;        //�浱ǰ���������4��״̬��Ϊ�������ã�����Сʱ�����÷��ӣ���������
    reg [4:0] valuehour,valuethou,valuehun,valueten,valueone;   //�����õ�����ʱ��ֵ
    
    reg [40:0] count_3s=0;    //3�������Ϊ����led������
    reg flag;               //��enʹ���ź����
    
    always@(posedge clk)
    begin
    if(setflag&&(!set))     //set�½��ش�����ÿ�ΰ�set�л�״̬��0~3
        begin
            state=(state+1)%4;
        end
    
    
      if(state==0)//״̬0������0��BTN3
        begin
            Thousand<=oldThousand;
            Hundred<=oldHundred;
            Ten<=oldTen;
            One<=oldOne;
            Hour<=oldHour;//�����Ķ�����ԭ����ʱ�Ӹ�ֵ�������µı������ɣ�����ǰһ�������Ϊ��һ������
            
            if(valuehour+valuethou+valuehun+valueten+valueone!=0)begin//������ֵ��ȫΪ0������£������õ�����ʱ�丳ֵ��clkϵ�б�����������ݸ�����musicģ��
                clkHour<=valuehour;
                clkThousand<=valuethou[3:0];
                clkHundred<=valuehun[3:0];
                clkTen<=valueten[3:0];
                clkOne<=valueone[3:0];
            end
             
             if( (oldThousand==valuethou[3:0])&&(oldHundred==valuehun[3:0])&&(oldTen==valueten[3:0])&&(oldOne==valueone[3:0])&&(oldHour==valuehour)&&(valuehour+valuethou+valuehun+valueten+valueone!=0))
             begin//�жϵ�ǰʱ���Ƿ�������������ʱ�䣻
             if(en==0)begin//����߸�Ҫ�󴮿�ͨ���йأ�ʹ���ź�Ϊ0������ʱ����������ָʾ�ơ�����������ָʾ������������
             flag=1;
             end
             end
             
             if(flag==1)//����������������led[7]�����룻
             begin
                 count_3s=count_3s+1;
                 led=1;
                 if(count_3s==125000000*3-1)//����ʱ��Ϊ125MHz��3s��Ϊ125000000*3-1��
                 begin
                 led=0;             
                 count_3s=0;
                 flag=0;
                 end
             end
        end
        
        if(state==1)//״̬1������һ��BTN3���ĸ������ȫ���������������Сʱ��
        begin
            Thousand<=4'b1111;
            Hundred<=4'b1111;
            Ten<=4'b1111;
            One<=4'b1111;
            valuehour<=value[4:0];
            Hour<=valuehour;
            
        end 
        
        if(state==2)//״̬2����������BTN3��Сʱled������������������ܲ�������������ķ��ӣ�
        begin
            valuethou=value/10;
            valuehun=value%10;
            Thousand<=valuethou[3:0];
            Hundred<=valuehun[3:0];
            Ten<=4'b1111;
            One<=4'b1111;
            Hour<=5'b00000;
         
        end 
        
        if(state==3)//״̬3����������BTN3��Сʱled������������������ܲ�����������������ӣ�
        begin
            valueten=value/10;
            valueone=value%10;
            Thousand<=4'b1111;
            Hundred<=4'b1111;
            Ten<=valueten[3:0];
            One<=valueone[3:0];
            Hour<=5'b00000;
          
        end 
            
        
        setflag=set;//ÿ��ʱ�������ص�������setֵ����setflag����־set��ť���������
    end   
    
    
    
    
endmodule
