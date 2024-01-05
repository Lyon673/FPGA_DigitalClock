module debounce(
    input clk, //125MHz
    input sw_in,
    output reg sw_out
);

reg sw_mid_r1, sw_mid_r2, sw_valid;

always@(posedge clk) begin
    sw_mid_r1 <= sw_in;
    sw_mid_r2 <= sw_mid_r1;
    sw_valid <= (~sw_mid_r2) & (sw_mid_r1);
end

reg [21:0] key_cnt;

always@(posedge clk) begin
    if(sw_valid) begin
        key_cnt <= 0;
    end else begin
        key_cnt <= key_cnt + 1;
    end
end

always@(posedge clk) begin
    if(key_cnt == 22'd2500000) begin     //20ms: 125000000Hz*0.020s=2500000
        sw_out <= sw_in;
    end
end

endmodule


//module debounce(
//    input clk,
//    input i_btn,
//    output reg o_state,
//    output o_ondn,
//    output o_onup
//    );

//    // sync with clock and combat metastability
//    reg sync_0, sync_1;
//    always @(posedge clk) sync_0 <= i_btn;
//    always @(posedge clk) sync_1 <= sync_0;

//    // 2.1 ms counter at 125 MHz
//    reg [18:0] counter;
//    wire idle = (o_state == sync_1);
//    wire max = &counter;

//    always @(posedge clk)
//    begin
//        if (idle)
//            counter <= 0;
//        else
//        begin
//            counter <= counter + 1;
//            if (max)
//                o_state <= ~o_state;
//        end
//    end

//    assign o_ondn = ~idle & max & ~o_state;
//    assign o_onup = ~idle & max & o_state;
//endmodule