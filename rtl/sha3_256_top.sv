
//*****************************************************************************
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy
// of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations
// under the License.
//
// Date:      8/27/2026
// Description: SHA3 top integerate the modules
//
//*****************************************************************************
  module sha3_256_top (
    // Outputs
      word_ready,         // To top
      digest_valid,       // To top
      digest,             // To top
    // Inputs
      start,              // From top
      word_valid,         // From top
      word_data,          // From top
      last_block,         // From top
      rst_n,              // From top
      clk                 // From top
  );

/******************************************************************************
   Outputs
******************************************************************************/
    output           word_ready;      // Word ready
    output           digest_valid;    // Hash output valid
    output   [255:0] digest;          // Hash data
/******************************************************************************
   Inputs
******************************************************************************/
    input          start;            // New Message
    input          word_valid;       // Input Valid
    input   [63:0] word_data;        // Input Data
    input          last_block;       // Last Block
    input          rst_n;            // Reset
    input          clk;              // Clock

/******************************************************************************
   Local variables
******************************************************************************/
    logic          word_ready;      // Word ready
    logic          digest_valid;    // Hash output valid
    logic  [255:0] digest;          // Hash data
    logic   [63:0] rom_dout;        // ROM data out
    logic    [4:0] round_cnt_w;     // ROM data out
    logic   [63:0] lane_00_out;     // 1600-bit Keccak state
    logic   [63:0] lane_10_out;     // 1600-bit Keccak state
    logic   [63:0] lane_20_out;     // 1600-bit Keccak state
    logic   [63:0] lane_30_out;     // 1600-bit Keccak state
    logic   [63:0] lane_40_out;     // 1600-bit Keccak state
    logic   [63:0] lane_01_out;     // 1600-bit Keccak state
    logic   [63:0] lane_11_out;     // 1600-bit Keccak state
    logic   [63:0] lane_21_out;     // 1600-bit Keccak state
    logic   [63:0] lane_31_out;     // 1600-bit Keccak state
    logic   [63:0] lane_41_out;     // 1600-bit Keccak state
    logic   [63:0] lane_02_out;     // 1600-bit Keccak state
    logic   [63:0] lane_12_out;     // 1600-bit Keccak state
    logic   [63:0] lane_22_out;     // 1600-bit Keccak state
    logic   [63:0] lane_32_out;     // 1600-bit Keccak state
    logic   [63:0] lane_42_out;     // 1600-bit Keccak state
    logic   [63:0] lane_03_out;     // 1600-bit Keccak state
    logic   [63:0] lane_13_out;     // 1600-bit Keccak state
    logic   [63:0] lane_23_out;     // 1600-bit Keccak state
    logic   [63:0] lane_33_out;     // 1600-bit Keccak state
    logic   [63:0] lane_43_out;     // 1600-bit Keccak state
    logic   [63:0] lane_04_out;     // 1600-bit Keccak state
    logic   [63:0] lane_14_out;     // 1600-bit Keccak state
    logic   [63:0] lane_24_out;     // 1600-bit Keccak state
    logic   [63:0] lane_34_out;     // 1600-bit Keccak state
    logic   [63:0] lane_44_out;     // 1600-bit Keccak state
    logic   [63:0] lane_00_in;      // 1600-bit Keccak state
    logic   [63:0] lane_10_in;      // 1600-bit Keccak state
    logic   [63:0] lane_20_in;      // 1600-bit Keccak state
    logic   [63:0] lane_30_in;      // 1600-bit Keccak state
    logic   [63:0] lane_40_in;      // 1600-bit Keccak state
    logic   [63:0] lane_01_in;      // 1600-bit Keccak state
    logic   [63:0] lane_11_in;      // 1600-bit Keccak state
    logic   [63:0] lane_21_in;      // 1600-bit Keccak state
    logic   [63:0] lane_31_in;      // 1600-bit Keccak state
    logic   [63:0] lane_41_in;      // 1600-bit Keccak state
    logic   [63:0] lane_02_in;      // 1600-bit Keccak state
    logic   [63:0] lane_12_in;      // 1600-bit Keccak state
    logic   [63:0] lane_22_in;      // 1600-bit Keccak state
    logic   [63:0] lane_32_in;      // 1600-bit Keccak state
    logic   [63:0] lane_42_in;      // 1600-bit Keccak state
    logic   [63:0] lane_03_in;      // 1600-bit Keccak state
    logic   [63:0] lane_13_in;      // 1600-bit Keccak state
    logic   [63:0] lane_23_in;      // 1600-bit Keccak state
    logic   [63:0] lane_33_in;      // 1600-bit Keccak state
    logic   [63:0] lane_43_in;      // 1600-bit Keccak state
    logic   [63:0] lane_04_in;      // 1600-bit Keccak state
    logic   [63:0] lane_14_in;      // 1600-bit Keccak state
    logic   [63:0] lane_24_in;      // 1600-bit Keccak state
    logic   [63:0] lane_34_in;      // 1600-bit Keccak state
    logic   [63:0] lane_44_in;      // 1600-bit Keccak state

/******************************************************************************
  Instance Keecak ROM
******************************************************************************/
    sha3_256_krom sha3_krom (
      // Outputs
        .dout             (rom_dout),           // To sha3_keccak_round
      // Inputs
        .addr             (round_cnt_w),        // From sha3_256_sm
        .rst_n            (rst_n),              // From top
        .clk              (clk)                 // From top
    );

 /******************************************************************************
  Instance Keecak Round
******************************************************************************/
    sha3_256_keccak_round u_round (
      // Outputs
        .lane_00_out      (lane_00_out),        // To sha3_256_sm
        .lane_10_out      (lane_10_out),        // To sha3_256_sm
        .lane_20_out      (lane_20_out),        // To sha3_256_sm
        .lane_30_out      (lane_30_out),        // To sha3_256_sm
        .lane_40_out      (lane_40_out),        // To sha3_256_sm
        .lane_01_out      (lane_01_out),        // To sha3_256_sm
        .lane_11_out      (lane_11_out),        // To sha3_256_sm
        .lane_21_out      (lane_21_out),        // To sha3_256_sm
        .lane_31_out      (lane_31_out),        // To sha3_256_sm
        .lane_41_out      (lane_41_out),        // To sha3_256_sm
        .lane_02_out      (lane_02_out),        // To sha3_256_sm
        .lane_12_out      (lane_12_out),        // To sha3_256_sm
        .lane_22_out      (lane_22_out),        // To sha3_256_sm
        .lane_32_out      (lane_32_out),        // To sha3_256_sm
        .lane_42_out      (lane_42_out),        // To sha3_256_sm
        .lane_03_out      (lane_03_out),        // To sha3_256_sm
        .lane_13_out      (lane_13_out),        // To sha3_256_sm
        .lane_23_out      (lane_23_out),        // To sha3_256_sm
        .lane_33_out      (lane_33_out),        // To sha3_256_sm
        .lane_43_out      (lane_43_out),        // To sha3_256_sm
        .lane_04_out      (lane_04_out),        // To sha3_256_sm
        .lane_14_out      (lane_14_out),        // To sha3_256_sm
        .lane_24_out      (lane_24_out),        // To sha3_256_sm
        .lane_34_out      (lane_34_out),        // To sha3_256_sm
        .lane_44_out      (lane_44_out),        // To sha3_256_sm
      // Inputs
        .lane_00_in       (lane_00_in),         // From sha3_256_sm
        .lane_10_in       (lane_10_in),         // From sha3_256_sm
        .lane_20_in       (lane_20_in),         // From sha3_256_sm
        .lane_30_in       (lane_30_in),         // From sha3_256_sm
        .lane_40_in       (lane_40_in),         // From sha3_256_sm
        .lane_01_in       (lane_01_in),         // From sha3_256_sm
        .lane_11_in       (lane_11_in),         // From sha3_256_sm
        .lane_21_in       (lane_21_in),         // From sha3_256_sm
        .lane_31_in       (lane_31_in),         // From sha3_256_sm
        .lane_41_in       (lane_41_in),         // From sha3_256_sm
        .lane_02_in       (lane_02_in),         // From sha3_256_sm
        .lane_12_in       (lane_12_in),         // From sha3_256_sm
        .lane_22_in       (lane_22_in),         // From sha3_256_sm
        .lane_32_in       (lane_32_in),         // From sha3_256_sm
        .lane_42_in       (lane_42_in),         // From sha3_256_sm
        .lane_03_in       (lane_03_in),         // From sha3_256_sm
        .lane_13_in       (lane_13_in),         // From sha3_256_sm
        .lane_23_in       (lane_23_in),         // From sha3_256_sm
        .lane_33_in       (lane_33_in),         // From sha3_256_sm
        .lane_43_in       (lane_43_in),         // From sha3_256_sm
        .lane_04_in       (lane_04_in),         // From sha3_256_sm
        .lane_14_in       (lane_14_in),         // From sha3_256_sm
        .lane_24_in       (lane_24_in),         // From sha3_256_sm
        .lane_34_in       (lane_34_in),         // From sha3_256_sm
        .lane_44_in       (lane_44_in),         // From sha3_256_sm
        .rc               (rom_dout)            // From sha3_krom
    );

/******************************************************************************
  Instance State Machine
******************************************************************************/
    sha3_256_sm sha3_256_sm (
      // Outputs
        .round_cnt_w      (round_cnt_w),        // To sha3_krom
        .word_ready       (word_ready),         // To top
        .digest_valid     (digest_valid),       // To top
        .digest           (digest),             // To top
        .lane_00          (lane_00_in),         // To sha3_256_keccak_round
        .lane_10          (lane_10_in),         // To sha3_256_keccak_round
        .lane_20          (lane_20_in),         // To sha3_256_keccak_round
        .lane_30          (lane_30_in),         // To sha3_256_keccak_round
        .lane_40          (lane_40_in),         // To sha3_256_keccak_round
        .lane_01          (lane_01_in),         // To sha3_256_keccak_round
        .lane_11          (lane_11_in),         // To sha3_256_keccak_round
        .lane_21          (lane_21_in),         // To sha3_256_keccak_round
        .lane_31          (lane_31_in),         // To sha3_256_keccak_round
        .lane_41          (lane_41_in),         // To sha3_256_keccak_round
        .lane_02          (lane_02_in),         // To sha3_256_keccak_round
        .lane_12          (lane_12_in),         // To sha3_256_keccak_round
        .lane_22          (lane_22_in),         // To sha3_256_keccak_round
        .lane_32          (lane_32_in),         // To sha3_256_keccak_round
        .lane_42          (lane_42_in),         // To sha3_256_keccak_round
        .lane_03          (lane_03_in),         // To sha3_256_keccak_round
        .lane_13          (lane_13_in),         // To sha3_256_keccak_round
        .lane_23          (lane_23_in),         // To sha3_256_keccak_round
        .lane_33          (lane_33_in),         // To sha3_256_keccak_round
        .lane_43          (lane_43_in),         // To sha3_256_keccak_round
        .lane_04          (lane_04_in),         // To sha3_256_keccak_round
        .lane_14          (lane_14_in),         // To sha3_256_keccak_round
        .lane_24          (lane_24_in),         // To sha3_256_keccak_round
        .lane_34          (lane_34_in),         // To sha3_256_keccak_round
        .lane_44          (lane_44_in),         // To sha3_256_keccak_round
      // Inputs
        .lane_00_in       (lane_00_out),        // From sha3_256_keccak_round
        .lane_10_in       (lane_10_out),        // From sha3_256_keccak_round
        .lane_20_in       (lane_20_out),        // From sha3_256_keccak_round
        .lane_30_in       (lane_30_out),        // From sha3_256_keccak_round
        .lane_40_in       (lane_40_out),        // From sha3_256_keccak_round
        .lane_01_in       (lane_01_out),        // From sha3_256_keccak_round
        .lane_11_in       (lane_11_out),        // From sha3_256_keccak_round
        .lane_21_in       (lane_21_out),        // From sha3_256_keccak_round
        .lane_31_in       (lane_31_out),        // From sha3_256_keccak_round
        .lane_41_in       (lane_41_out),        // From sha3_256_keccak_round
        .lane_02_in       (lane_02_out),        // From sha3_256_keccak_round
        .lane_12_in       (lane_12_out),        // From sha3_256_keccak_round
        .lane_22_in       (lane_22_out),        // From sha3_256_keccak_round
        .lane_32_in       (lane_32_out),        // From sha3_256_keccak_round
        .lane_42_in       (lane_42_out),        // From sha3_256_keccak_round
        .lane_03_in       (lane_03_out),        // From sha3_256_keccak_round
        .lane_13_in       (lane_13_out),        // From sha3_256_keccak_round
        .lane_23_in       (lane_23_out),        // From sha3_256_keccak_round
        .lane_33_in       (lane_33_out),        // From sha3_256_keccak_round
        .lane_43_in       (lane_43_out),        // From sha3_256_keccak_round
        .lane_04_in       (lane_04_out),        // From sha3_256_keccak_round
        .lane_14_in       (lane_14_out),        // From sha3_256_keccak_round
        .lane_24_in       (lane_24_out),        // From sha3_256_keccak_round
        .lane_34_in       (lane_34_out),        // From sha3_256_keccak_round
        .lane_44_in       (lane_44_out),        // From sha3_256_keccak_round
        .start            (start),              // From top
        .word_valid       (word_valid),         // From top
        .word_data        (word_data),          // From top
        .last_block       (last_block),         // From top
        .rst_n            (rst_n),              // From top
        .clk              (clk)                 // From top
    );


endmodule // sha3_256_top
