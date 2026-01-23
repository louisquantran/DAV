`timescale 1ns / 1ps

module top (
    input logic clk,
    input logic rst,
    input logic start_stop_btn,
    
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic led_sig_1,
    output logic led_sig_2,
    output logic led_sig_3
);  
    logic clk_1khz;
    logic clk_1khz_en;
    
    // FSM
    logic set, score;
    logic set_next, score_next;
    logic led_sig_1_next;
    logic led_sig_2_next;
    logic led_sig_3_next;
    
    // Random number from generator
    logic generate_num;
    logic generate_num_next;
    logic [7:0] rand_num;
    logic generated; 
    
    // start watch signal
    logic start_watch;
    logic start_watch_next;
    logic [7:0] delay;
    logic [7:0] delay_next;
    logic delay_done;
    
    logic start_stop_btn_1khz;
    always_ff @(posedge clk_1khz or posedge rst) begin
        if (rst) begin
            start_stop_btn_1khz <= 1'b0;
            delay <= '0;
        end else begin
            if (start_stop_btn && !start_stop_btn_1khz) begin
                start_stop_btn_1khz <= 1'b1;
            end else if (!start_stop_btn && start_stop_btn_1khz) begin
                start_stop_btn_1khz <= 1'b0;
            end
            
            if (!delay_done) begin
                delay <= delay_next + 1;
            end
        end
    end
    
    always_comb begin
        set_next = set;
        score_next = score;
        delay_next = delay;
        start_watch_next = start_watch;
        led_sig_1_next = led_sig_1;
        led_sig_2_next = led_sig_2;
        led_sig_3_next = led_sig_3;
        generate_num_next = 1'b0;
        if (start_stop_btn_1khz) begin
            if (!set) begin // SET state
                led_sig_1_next = 1'b1;
                set_next = 1'b1;
                generate_num_next = 1'b1;
            end else if (set && !score) begin // SCORE state
                set_next = 1'b0;
                score_next = 1'b1;
                start_watch_next = 1'b0;
                led_sig_2_next = 1'b0;
                led_sig_3_next = 1'b1;
            end
        end else if (generated && set && delay != 8'b10000000 && !delay_done) begin // delay period 
            generate_num_next = 1'b0;
        end else if (generated && set && delay == 8'b10000000 && !delay_done) begin // GO state
            delay_done = 1'b1;
            start_watch_next = 1'b1;
            led_sig_1_next = 1'b0;
            led_sig_2_next = 1'b1;
        end
    end
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            set <= 1'b0;
            score <= 1'b0;
            delay <= '0;
            start_watch <= 1'b0;
            led_sig_1 <= 1'b0;
            led_sig_2 <= 1'b0;
            led_sig_3 <= 1'b0;
            generate_num <= 1'b0;
        end else begin 
            set <= set_next;
            score <= score_next;
            start_watch <= start_watch_next;
            led_sig_1 <= led_sig_1_next;
            led_sig_2 <= led_sig_2_next;
            led_sig_3 <= led_sig_3_next;
            generate_num <= generate_num_next;
        end
    end
    
    random_gen u_gen (
        .clk(clk),
        .reset(rst),
        .generate_num(generate_num),
        .rand_num(rand_num),
        .generated(generated)
    );
    
    stopwatch u_sw(
        .clk(clk),
        .reset(rst),
        .start_watch(start_watch),
        .elapsed_time(),
        //sevenseg display
        .an(an),
        .seg(seg),
        .clk_1khz(clk_1khz)
    );
endmodule