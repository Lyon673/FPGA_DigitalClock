module uart_tx(
    input               clk         , //ϵͳʱ��
    input               reset       , //ϵͳ��λ������Ч
    input               uart_tx_en  , //UART�ķ���ʹ��
    input     [7:0]     uart_tx_data, //UARTҪ���͵�����
    output  reg         uart_txd    , //UART���Ͷ˿�
    output  reg         uart_tx_busy  //����æ״̬�ź�
    );

//parameter define
parameter CLK_FREQ = 125000000;               //ϵͳʱ��Ƶ��
parameter UART_BPS = 115200  ;               //���ڲ�����
localparam BAUD_CNT_MAX = CLK_FREQ/UART_BPS; //Ϊ�õ�ָ�������ʣ���ϵͳʱ�Ӽ���BPS_CNT��

//reg define
reg  [7:0]  tx_data_t;  //�������ݼĴ���
reg  [3:0]  tx_cnt   ;  //�������ݼ�����
reg  [15:0] baud_cnt ;  //�����ʼ�����

//*****************************************************
//**                    main code
//*****************************************************

//��uart_tx_enΪ��ʱ�����淢�����ݵ���ʱ�Ĵ���tx_data_t��������uart_tx_busy�ź�
always @(posedge clk or posedge reset) begin
    if(reset) begin
        tx_data_t <= 8'b0;
        uart_tx_busy <= 1'b0;
    end
    //����ʹ��ʱ���Ĵ�Ҫ���͵����ݣ�������BUSY�ź�
    else if(uart_tx_en) begin
        tx_data_t <= uart_tx_data;
        uart_tx_busy <= 1'b1;
    end
    //��������ֹͣλ����ʱ��ֹͣ���͹���
    else if(tx_cnt == 4'd9 && baud_cnt == BAUD_CNT_MAX - BAUD_CNT_MAX/16) begin
        tx_data_t <= 8'b0;     //��շ���������ʱ�Ĵ���
        uart_tx_busy <= 1'b0;  //������uart_tx_busy�ź�
    end
    else begin
        tx_data_t <= tx_data_t;
        uart_tx_busy <= uart_tx_busy;
    end
end

//�����ʵļ�����ѭ������
always @(posedge clk or posedge reset) begin
    if(reset) 
        baud_cnt <= 16'd0;
    //�����ڷ��͹���ʱ�������ʼ�������baud_cnt������ѭ������
    else if(uart_tx_busy) begin
        if(baud_cnt < BAUD_CNT_MAX - 1'b1)
            baud_cnt <= baud_cnt + 16'b1;
        else 
            baud_cnt <= 16'd0; //�����ﵽһ�����������ں�����
    end    
    else
        baud_cnt <= 16'd0;     //���͹��̽���ʱ����������
end

//tx_cnt���и�ֵ
always @(posedge clk or posedge reset) begin
    if(reset) 
        tx_cnt <= 4'd0;
    else if(uart_tx_busy) begin             //���ڷ��͹���ʱtx_cnt�Ž��м���
        if(baud_cnt == BAUD_CNT_MAX - 1'b1) //�������ʼ�����������һ������������ʱ
            tx_cnt <= tx_cnt + 1'b1;        //�������ݼ�������1
        else
            tx_cnt <= tx_cnt;
    end
    else
        tx_cnt <= 4'd0;                     //���͹��̽���ʱ����������
end

//����tx_cnt����uart���Ͷ˿ڸ�ֵ
always @(posedge clk or posedge reset) begin
    if(reset) 
        uart_txd <= 1'b1;
    else if(uart_tx_busy) begin
        case(tx_cnt) 
            4'd0 : uart_txd <= 1'b0        ; //��ʼλ
            4'd1 : uart_txd <= tx_data_t[0]; //����λ���λ
            4'd2 : uart_txd <= tx_data_t[1];
            4'd3 : uart_txd <= tx_data_t[2];
            4'd4 : uart_txd <= tx_data_t[3];
            4'd5 : uart_txd <= tx_data_t[4];
            4'd6 : uart_txd <= tx_data_t[5];
            4'd7 : uart_txd <= tx_data_t[6];
            4'd8 : uart_txd <= tx_data_t[7]; //����λ���λ
            4'd9 : uart_txd <= 1'b1        ; //ֹͣλ
            default : uart_txd <= 1'b1;
        endcase
    end
    else
        uart_txd <= 1'b1;                    //����ʱ���Ͷ˿�Ϊ�ߵ�ƽ
end

endmodule