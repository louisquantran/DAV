`timescale 1ns/1ps

module tb_lab_2_top;

  // 100 MHz clock = 10 ns period
  logic clk = 0;
  always #5 clk = ~clk;

  logic rst;
  logic start_stop_btn;

  wire [3:0] an;
  wire [6:0] seg;
  wire led_sig_1;
  wire led_sig_2;

  int t_before_react;
  int t_after_react_1, t_after_react_2;

  // DUT
  top dut (
    .clk(clk),
    .rst(rst),
    .start_stop_btn(start_stop_btn),
    .an(an),
    .seg(seg),
    .led_sig_1(led_sig_1),
    .led_sig_2(led_sig_2)
  );

  // --- Helpers ---
  task automatic press_button_ms(int ms);
    $display("[%0t] BUTTON pressed for %0d ms", $time, ms);
    start_stop_btn = 1'b1;
    #(ms * 1_000_000);
    start_stop_btn = 1'b0;
    $display("[%0t] BUTTON released", $time);
    #(1_000_000);
  endtask

  task automatic wait_khz_edges(int n);
    repeat (n) begin
      @(posedge dut.clk_1khz);
      $display("[%0t] clk_1khz tick", $time);
    end
  endtask

  task automatic check(input bit cond, input string msg);
    if (!cond) begin
      $error("[%0t] CHECK FAILED: %s", $time, msg);
      $finish;
    end
    else begin
      $display("[%0t] CHECK PASSED: %s", $time, msg);
    end
  endtask

  // --- LED monitors ---
  always @(posedge led_sig_1)
    $display("[%0t] led_sig_1 ASSERTED (SET state)", $time);

  always @(negedge led_sig_1)
    $display("[%0t] led_sig_1 DEASSERTED", $time);

  always @(posedge led_sig_2)
    $display("[%0t] led_sig_2 ASSERTED (GO state)", $time);

  always @(negedge led_sig_2)
    $display("[%0t] led_sig_2 DEASSERTED (SCORE state)", $time);

  // --- Elapsed time monitor ---
  always @(posedge dut.clk_1khz) begin
    if (dut.start_watch)
      $display("[%0t] elapsed_time = %0d ms", $time, dut.u_sw.elapsed_time);
  end

  // --- Main test ---
  initial begin
    $timeformat(-9, 3, " ns", 12);
    $display("[%0t] TB start", $time);

    rst = 1'b1;
    start_stop_btn = 1'b0;

    $display("[%0t] RESET asserted", $time);
    #200;
    rst = 1'b0;
    $display("[%0t] RESET deasserted", $time);

    #(2_000_000);

    $display("[%0t] Checking elapsed_time after reset", $time);
    check(dut.u_sw.elapsed_time == 0,
          "elapsed_time should be 0 after reset");

    // RESET -> SET
    $display("[%0t] ---- RESET -> SET ----", $time);
    press_button_ms(2);

    #200;
    check(led_sig_1 == 1'b1,
          "led_sig_1 high in SET");

    // SET -> GO
    $display("[%0t] Waiting for GO state", $time);
    @(posedge led_sig_2);

    // GO running
    wait_khz_edges(15);

    t_before_react = dut.u_sw.elapsed_time;
    $display("[%0t] elapsed_time before react = %0d ms",
             $time, t_before_react);

    // GO -> SCORE
    $display("[%0t] ---- GO -> SCORE ----", $time);
    press_button_ms(2);

    #200;
    check(dut.start_watch == 1'b0,
          "start_watch deasserted in SCORE");

    t_after_react_1 = dut.u_sw.elapsed_time;
    wait_khz_edges(5);
    t_after_react_2 = dut.u_sw.elapsed_time;

    $display("[%0t] elapsed_time after react = %0d -> %0d",
             $time, t_after_react_1, t_after_react_2);

    check(t_after_react_1 == t_after_react_2,
          "elapsed_time stopped counting in SCORE");

    check((t_after_react_1 >= 12) && (t_after_react_1 <= 25),
          "reaction time roughly ~15ms");

    $display("[%0t] ALL TESTS PASSED 🎉", $time);
    $finish;
  end

endmodule
