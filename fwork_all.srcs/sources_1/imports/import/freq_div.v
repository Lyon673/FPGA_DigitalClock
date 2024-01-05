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
		count1 <= 0;  //��ʼ��count1Ϊ0
		clk_48kHz <= 0;  //��ʼ��clk_48kHzΪ0
	end
else
	begin
		if (count1 < 256)      //clk_12MHz��24Hz������ռ�ձ�50%��Ƶ��Ϊ48kHz��ʱ��clk_48kHz
			begin
				count1 <= count1 + 1;   //Ƶ�ʼ�����һ
				clk_48kHz <= 1;   //clk_48kHzӭ�������أ�clk_48kHz=1����0.5���ڣ��ܹ�256��1
			end
		else if (count1 < 512-1)
			begin
				count1 <= count1 + 1;   //Ƶ�ʼ�����һ
				clk_48kHz <= 0;   //clk_48kHzӭ���½��أ�clk_48kHz=0����Լ0.5���ڣ��ܹ�255��0
			end
		else
			begin
				count1 <= 0;    //clk_48kHz����һ���������ڣ�����������
				clk_48kHz <= 0;    //����clk_48kHz��256��0��clk_48kHz=0������0.5����
			end
	end
end

endmodule
