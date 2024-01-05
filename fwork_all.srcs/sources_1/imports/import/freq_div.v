`timescale 1ns / 1ps

module freq_div(
	clk_24MHz,
	reset,
    clk_48kHz
);

input clk_24MHz, reset;
output reg clk_48kHz;
reg [30:0] count1;

initial
begin
    count1 <= 0;
    clk_48kHz <= 0;
end

always @(posedge clk_24MHz or posedge reset)
begin
if(reset)
	begin
		count1 <= 0;  //初始化count1为0
		clk_48kHz <= 0;  //初始化clk_48kHz为0
	end
else
	begin
		if (count1 < 256)      //clk_12MHz是24Hz，产生占空比50%，频率为48kHz的时钟clk_48kHz
			begin
				count1 <= count1 + 1;   //频率计数加一
				clk_48kHz <= 1;   //clk_48kHz迎来上升沿，clk_48kHz=1持续0.5周期，总共256个1
			end
		else if (count1 < 512-1)
			begin
				count1 <= count1 + 1;   //频率计数加一
				clk_48kHz <= 0;   //clk_48kHz迎来下降沿，clk_48kHz=0持续约0.5周期，总共255个0
			end
		else
			begin
				count1 <= 0;    //clk_48kHz历经一个完整周期，计数器清零
				clk_48kHz <= 0;    //这是clk_48kHz第256个0，clk_48kHz=0持续满0.5周期
			end
	end
end

endmodule
