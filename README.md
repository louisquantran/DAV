# Digital-Audio-Visualizer-DAV
This project is currently in progress (DAV at IEEE)

## Lab 1 — Beep Boop (Mini ALU + Seven-Segment Display)

### Goal
Implement and verify a simple **ALU (Arithmetic Logic Unit)** and display its result on the Basys 3 **four-digit seven-segment display**.

### What I Built
- **`miniALU.sv`** (combinational)
  - Operates on two 4-bit operands (`op1`, `op2`)
  - Mode select:
    - Add/Sub mode
    - Arithmetic Shift Left/Right mode
- **Display pipeline**
  - **`displayEncoder.sv`**: converts ALU result into four display digits
  - **`sevenSegDigit.sv`**: maps a 0–9 digit to active-low seven-seg segments
  - **`seg_driver.sv`** (provided): multiplexes across 4 digits at a refresh rate suitable for human viewing
- **Top-level integration**
  - **`calculator_top.sv`**: wires ALU + display modules to FPGA I/O (switches, clock, seven-seg pins)

### Verification
- Simulation using the provided testbenches (e.g., `miniALU_tb.sv`, `display_tb.sv`)
- Expected behaviors include:
  - `7 + 5 = 12`
  - `7 - 5 = 2`
  - `7 << 5 = 224`
  - `7 >> 5 = 0`

### How to Run (Vivado)
1. Create a Vivado project for Basys 3.
2. Add RTL sources for Lab 1 modules.
3. Add simulation sources (testbenches) and run simulation.
4. Set `calculator_top.sv` as top, add `.xdc` constraints, then:
   - Run Synthesis → Run Implementation → Generate Bitstream
5. Program the board via Hardware Manager.

---

## Lab 2 — Reaction Time Tester (Clocking + Stopwatch + RNG + FSM)

### Goal
Build a reaction-time game:
1. Press button to start  
2. Wait a random delay  
3. “GO” signal appears (LED)  
4. Press button ASAP  
5. FPGA measures reaction time and shows it on the seven-seg display

### Key Components
- **Clocking**
  - **`clock_divider.sv`**: parameterized divider (default: 100 MHz → 1 kHz, ~50% duty cycle)
- **Timing**
  - **`stopwatch.sv`**: counts elapsed time in **milliseconds**, gated by `start_watch`, saturating at `9999`
- **Seven-segment display stack**
  - **`seven_segment_digit.sv`**: digit → 7-bit active-low segments
  - **`binary_to_ssd.sv`**: converts binary time value into 4 decimal digits
  - **`basys_ssd.sv`**: multiplexes four digits using active-low one-hot `an[3:0]`
- **Random delay generation**
  - **`random_number_generator.sv`**: 8-bit Fibonacci LFSR
    - feedback = `bit[7] ^ bit[5] ^ bit[4] ^ bit[3]`
    - must reset to a **non-zero seed**
- **System control**
  - **`lab_2_top.sv`**: integrates all modules and implements the FSM:
    - `RESET` → `SET` → `GO` → `SCORE`
    - `GO` asserts an LED and starts timing
    - `SCORE` freezes and displays the final reaction time
