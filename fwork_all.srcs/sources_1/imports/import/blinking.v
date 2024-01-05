`timescale 1ns / 1ps
//控制led[6]闪烁；
module blinking(
        hour,
        thousand,
        hundred,
        ten,
        one,
        led,
        clk1
        
    );
    
            input     [4:0] hour;
            input     [3:0] thousand,hundred,ten,one;
            input          clk1;
            reg    [3:0] clk1_cnt;//计时；
            output  reg led;
            
            
            initial begin 
            clk1_cnt=4'b0000;//初始化；
            end
            
            always@(posedge clk1)
            begin
                  if(!thousand&&!hundred&&!ten&&!one)//判断是否整点到来；
                  begin 
                        led=1;
                  end
                  if(led)//若led亮起，则让其亮三秒；
                  begin 
                        clk1_cnt=clk1_cnt+1;
                  end
                  if(clk1_cnt>3)
                  begin 
                        led<=0;
                        clk1_cnt<=0;
                  end
            end

endmodule

