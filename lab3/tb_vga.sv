`timescale 1ns/1ps

module tb_vga;

  // --- VGA 640x480@60 timing constants (pixel clock 25.175MHz nominal; 25MHz often used in class/labs)
  localparam int HPIXELS = 640;
  localparam int HFP     = 16;
  localparam int HSPULSE = 96;
  localparam int HBP     = 48;
  localparam int HTOTAL  = HPIXELS + HFP + HSPULSE + HBP; // 800

  localparam int VPIXELS = 480;
  localparam int VFP     = 10;
  localparam int VSPULSE = 2;
  localparam int VBP     = 33;
  localparam int VTOTAL  = VPIXELS + VFP + VSPULSE + VBP; // 525

  // --- DUT signals
  logic vgaclk;
  logic rst;

  logic [2:0] input_red;
  logic [2:0] input_green;
  logic [1:0] input_blue;

  logic [9:0] hc_out;
  logic [9:0] vc_out;

  logic hsync, vsync;
  logic [3:0] red, green, blue;

  // --- Instantiate DUT
  vga dut (
    .vgaclk      (vgaclk),
    .rst         (rst),
    .input_red   (input_red),
    .input_green (input_green),
    .input_blue  (input_blue),
    .hc_out      (hc_out),
    .vc_out      (vc_out),
    .hsync       (hsync),
    .vsync       (vsync),
    .red         (red),
    .green       (green),
    .blue        (blue)
  );

  // --- 25 MHz clock => 40 ns period
  initial vgaclk = 1'b0;
  always #20 vgaclk = ~vgaclk;

  // --- Simple stimulus: change colors occasionally
  task automatic drive_color(input [2:0] r, input [2:0] g, input [1:0] b);
    input_red   = r;
    input_green = g;
    input_blue  = b;
  endtask

  // --- Helpers to compute expected sync polarities (VGA 640x480 uses negative sync)
  function automatic logic exp_hsync(input int hc);
    // hsync low during [HPIXELS+HFP, HPIXELS+HFP+HSPULSE)
    if (hc >= (HPIXELS + HFP) && hc < (HPIXELS + HFP + HSPULSE)) exp_hsync = 1'b0;
    else                                                       exp_hsync = 1'b1;
  endfunction

  function automatic logic exp_vsync(input int vc);
    // vsync low during [VPIXELS+VFP, VPIXELS+VFP+VSPULSE)
    if (vc >= (VPIXELS + VFP) && vc < (VPIXELS + VFP + VSPULSE)) exp_vsync = 1'b0;
    else                                                       exp_vsync = 1'b1;
  endfunction

  function automatic logic in_active(input int hc, input int vc);
    return (hc < HPIXELS) && (vc < VPIXELS);
  endfunction

  // --- Scoreboarding / checks
  int unsigned cycles;
  int unsigned line_wraps;
  int unsigned frame_wraps;

  // Check counters wrap at correct totals
  // Expect hc: 0..HTOTAL-1 then back to 0
  // Expect vc: 0..VTOTAL-1 then back to 0 (incremented once per hc wrap)
  logic [9:0] prev_hc, prev_vc;

  // Main checking on each pixel clock
  always_ff @(posedge vgaclk) begin
    cycles++;

    if (rst) begin
      prev_hc     <= 0;
      prev_vc     <= 0;
      line_wraps  <= 0;
      frame_wraps <= 0;
    end else begin
      // --- Counter wrap tracking
      if (prev_hc == HTOTAL-1) begin
        // should wrap to 0
        assert (hc_out == 0)
          else $error("HC did not wrap to 0 at end of line. prev_hc=%0d hc_out=%0d time=%0t",
                      prev_hc, hc_out, $time);

        line_wraps++;

        // VC should increment (or wrap if end of frame)
        if (prev_vc == VTOTAL-1) begin
          assert (vc_out == 0)
            else $error("VC did not wrap to 0 at end of frame. prev_vc=%0d vc_out=%0d time=%0t",
                        prev_vc, vc_out, $time);
          frame_wraps++;
        end else begin
          assert (vc_out == prev_vc + 1)
            else $error("VC did not increment on line wrap. prev_vc=%0d vc_out=%0d time=%0t",
                        prev_vc, vc_out, $time);
        end
      end else begin
        // normal pixel increment
        assert (hc_out == prev_hc + 1)
          else $error("HC did not increment by 1. prev_hc=%0d hc_out=%0d vc_out=%0d time=%0t",
                      prev_hc, hc_out, vc_out, $time);

        // VC should remain constant mid-line
        assert (vc_out == prev_vc)
          else $error("VC changed mid-line. prev_vc=%0d vc_out=%0d hc_out=%0d time=%0t",
                      prev_vc, vc_out, hc_out, $time);
      end

      // --- Sync checks
      assert (hsync == exp_hsync(hc_out))
        else $error("HSYNC mismatch. hc=%0d expected=%0b got=%0b time=%0t",
                    hc_out, exp_hsync(hc_out), hsync, $time);

      assert (vsync == exp_vsync(vc_out))
        else $error("VSYNC mismatch. vc=%0d expected=%0b got=%0b time=%0t",
                    vc_out, exp_vsync(vc_out), vsync, $time);

      // --- Blanking / RGB checks
      if (in_active(hc_out, vc_out)) begin
        // Should reflect shifted inputs
        assert (red   == {input_red,   1'b0})
          else $error("RED mismatch in active region. in=%0b out=%0b hc=%0d vc=%0d",
                      input_red, red, hc_out, vc_out);

        assert (green == {input_green, 1'b0})
          else $error("GREEN mismatch in active region. in=%0b out=%0b hc=%0d vc=%0d",
                      input_green, green, hc_out, vc_out);

        assert (blue  == {input_blue,  2'b00})
          else $error("BLUE mismatch in active region. in=%0b out=%0b hc=%0d vc=%0d",
                      input_blue, blue, hc_out, vc_out);
      end else begin
        assert (red == 0 && green == 0 && blue == 0)
          else $error("RGB not blanked during blanking interval. rgb=%0h%0h%0h hc=%0d vc=%0d",
                      red, green, blue, hc_out, vc_out);
      end

      prev_hc <= hc_out;
      prev_vc <= vc_out;
    end
  end

  // --- Stimulus / run control
  initial begin
    cycles      = 0;
    line_wraps  = 0;
    frame_wraps = 0;

    // init inputs
    rst = 1'b1;
    drive_color(3'b000, 3'b000, 2'b00);

    // hold reset a few cycles
    repeat (5) @(posedge vgaclk);
    rst = 1'b0;

    // Run for a bit: a few lines, then a full frame if you want
    // Quick sanity: run for ~3 lines
    repeat (HTOTAL * 3) begin
      // change colors occasionally
      if ($urandom_range(0, 31) == 0) begin
        drive_color($urandom_range(0,7), $urandom_range(0,7), $urandom_range(0,3));
      end
      @(posedge vgaclk);
    end

    $display("Ran %0d cycles, saw %0d line wraps, %0d frame wraps so far.", cycles, line_wraps, frame_wraps);

    // Full frame test (uncomment if you want to validate end-to-end)
    repeat (HTOTAL * VTOTAL) begin
      if ($urandom_range(0, 63) == 0) begin
        drive_color($urandom_range(0,7), $urandom_range(0,7), $urandom_range(0,3));
      end
      @(posedge vgaclk);
    end

    $display("After full-frame run: cycles=%0d line_wraps=%0d frame_wraps=%0d", cycles, line_wraps, frame_wraps);

    // Expect at least 1 frame wrap after full-frame run
    if (frame_wraps < 1) $error("Did not observe a frame wrap as expected.");

    $display("TB completed.");
    $finish;
  end

endmodule