`timescale 1ns/1ps

module tb_random_gen;

  // 100 MHz clock
  logic clk = 0;
  always #5 clk = ~clk;

  logic reset;
  logic generate_num;
  wire [7:0] rand_num;
  wire generated;

  // DUT
  random_gen dut (
    .clk(clk),
    .reset(reset),
    .generate_num(generate_num),
    .rand_num(rand_num),
    .generated(generated)
  );

  // Simple check helper
  task automatic check(input bit cond, input string msg);
    if (!cond) begin
      $error("[%0t] CHECK FAILED: %s", $time, msg);
      $finish;
    end else begin
      $display("[%0t] CHECK PASSED: %s", $time, msg);
    end
  endtask

  // Pulse generate_num for exactly 1 clk cycle
  task automatic pulse_generate;
    @(negedge clk);
    generate_num = 1'b1;
    @(negedge clk);
    generate_num = 1'b0;
  endtask

  // Monitor
  always @(posedge clk) begin
    $display("[%0t] gen=%0b generated=%0b rand_num=0x%02h",
             $time, generate_num, generated, rand_num);
  end

    logic [7:0] hold_val;
  initial begin
    $timeformat(-9, 3, " ns", 12);
    $display("[%0t] TB start", $time);

    // init
    reset = 1'b1;
    generate_num = 1'b0;

    // reset for a couple cycles
    repeat (3) @(posedge clk);
    reset = 1'b0;
    $display("[%0t] reset deasserted", $time);

    // After reset, your module sets rand_num=0x80 and generated=0
    repeat (1) @(posedge clk);
    check(rand_num == 8'h80, "After reset rand_num should be 0x80");
    check(generated == 1'b0, "After reset generated should be 0");

    // --- Test 1: first pulse should update rand_num and set generated ---
    $display("\n[%0t] TEST 1: First generate pulse", $time);
    pulse_generate();

    // allow 1 posedge to capture update
    @(posedge clk);

    // With initial 0x80, taps (7,5,4,3) => feedback = 1, next = 0x01
    check(generated == 1'b1, "generated should become 1 after first generation");
    check(rand_num == 8'h01, "rand_num should advance from 0x80 to 0x01 on first pulse");

    // --- Test 2: second pulse should NOT change (because generated stays 1) ---
    $display("\n[%0t] TEST 2: Second generate pulse (should NOT change)", $time);
    hold_val = rand_num;

    pulse_generate();
    @(posedge clk);

    check(generated == 1'b1, "generated should still be 1 (never clears without reset)");
    check(rand_num == hold_val, "rand_num should remain unchanged on subsequent pulses");

    // --- Test 3: reset clears generated, then a pulse works again ---
    $display("\n[%0t] TEST 3: Reset then generate again", $time);
    reset = 1'b1;
    repeat (2) @(posedge clk);
    reset = 1'b0;
    @(posedge clk);

    check(rand_num == 8'h80, "After reset rand_num should return to 0x80");
    check(generated == 1'b0, "After reset generated should return to 0");

    pulse_generate();
    @(posedge clk);

    check(generated == 1'b1, "generated should become 1 again after reset + pulse");
    check(rand_num == 8'h01, "rand_num should again become 0x01 after reset + first pulse");

    $display("\n[%0t] ALL RNG TESTS PASSED ✅", $time);
    $finish;
  end

endmodule
