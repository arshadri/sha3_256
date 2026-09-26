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
// Description: SHA3 State Machine
//    last_block may be asserted with any accepted word of the final block;
//    start (single-cycle pulse, honored in IDLE or DONE) clears the state
//    and begins a new message.
//    digest_valid rises after the final permutation and holds until the
//    next start.
// 
//*****************************************************************************

`include "sha3_256_defines.h"
  module sha3_256_sm (
    // Outputs
      round_cnt_w,        // To sha3_256_krom
      word_ready,         // To top
      digest_valid,       // To top
      digest,             // To top
      lane_00,            // To sha3_256_keccak_round
      lane_10,            // To sha3_256_keccak_round
      lane_20,            // To sha3_256_keccak_round
      lane_30,            // To sha3_256_keccak_round
      lane_40,            // To sha3_256_keccak_round
      lane_01,            // To sha3_256_keccak_round
      lane_11,            // To sha3_256_keccak_round
      lane_21,            // To sha3_256_keccak_round
      lane_31,            // To sha3_256_keccak_round
      lane_41,            // To sha3_256_keccak_round
      lane_02,            // To sha3_256_keccak_round
      lane_12,            // To sha3_256_keccak_round
      lane_22,            // To sha3_256_keccak_round
      lane_32,            // To sha3_256_keccak_round
      lane_42,            // To sha3_256_keccak_round
      lane_03,            // To sha3_256_keccak_round
      lane_13,            // To sha3_256_keccak_round
      lane_23,            // To sha3_256_keccak_round
      lane_33,            // To sha3_256_keccak_round
      lane_43,            // To sha3_256_keccak_round
      lane_04,            // To sha3_256_keccak_round
      lane_14,            // To sha3_256_keccak_round
      lane_24,            // To sha3_256_keccak_round
      lane_34,            // To sha3_256_keccak_round
      lane_44,            // To sha3_256_keccak_round
    // Inputs
      lane_00_in,         // From sha3_256_keccak_round
      lane_10_in,         // From sha3_256_keccak_round
      lane_20_in,         // From sha3_256_keccak_round
      lane_30_in,         // From sha3_256_keccak_round
      lane_40_in,         // From sha3_256_keccak_round
      lane_01_in,         // From sha3_256_keccak_round
      lane_11_in,         // From sha3_256_keccak_round
      lane_21_in,         // From sha3_256_keccak_round
      lane_31_in,         // From sha3_256_keccak_round
      lane_41_in,         // From sha3_256_keccak_round
      lane_02_in,         // From sha3_256_keccak_round
      lane_12_in,         // From sha3_256_keccak_round
      lane_22_in,         // From sha3_256_keccak_round
      lane_32_in,         // From sha3_256_keccak_round
      lane_42_in,         // From sha3_256_keccak_round
      lane_03_in,         // From sha3_256_keccak_round
      lane_13_in,         // From sha3_256_keccak_round
      lane_23_in,         // From sha3_256_keccak_round
      lane_33_in,         // From sha3_256_keccak_round
      lane_43_in,         // From sha3_256_keccak_round
      lane_04_in,         // From sha3_256_keccak_round
      lane_14_in,         // From sha3_256_keccak_round
      lane_24_in,         // From sha3_256_keccak_round
      lane_34_in,         // From sha3_256_keccak_round
      lane_44_in,         // From sha3_256_keccak_round
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
    output     [4:0] round_cnt_w;      // Round Count
    output           word_ready;       // Word ready
    output           digest_valid;     // Hash output valid
    output   [255:0] digest;           // Hash data
    output    [63:0] lane_00;          // Lane 0
    output    [63:0] lane_10;          // Lane 0
    output    [63:0] lane_20;          // Lane 0
    output    [63:0] lane_30;          // Lane 0
    output    [63:0] lane_40;          // Lane 0
    output    [63:0] lane_01;          // Lane 1
    output    [63:0] lane_11;          // Lane 1
    output    [63:0] lane_21;          // Lane 1
    output    [63:0] lane_31;          // Lane 1
    output    [63:0] lane_41;          // Lane 1
    output    [63:0] lane_02;          // Lane 2
    output    [63:0] lane_12;          // Lane 2
    output    [63:0] lane_22;          // Lane 2
    output    [63:0] lane_32;          // Lane 2
    output    [63:0] lane_42;          // Lane 2
    output    [63:0] lane_03;          // Lane 3
    output    [63:0] lane_13;          // Lane 3
    output    [63:0] lane_23;          // Lane 3
    output    [63:0] lane_33;          // Lane 3
    output    [63:0] lane_43;          // Lane 3
    output    [63:0] lane_04;          // Lane 4
    output    [63:0] lane_14;          // Lane 4
    output    [63:0] lane_24;          // Lane 4
    output    [63:0] lane_34;          // Lane 4
    output    [63:0] lane_44;          // Lane 4

/******************************************************************************
   Inputs
******************************************************************************/
    input    [63:0] lane_00_in;        // Lane 0
    input    [63:0] lane_10_in;        // Lane 0
    input    [63:0] lane_20_in;        // Lane 0
    input    [63:0] lane_30_in;        // Lane 0
    input    [63:0] lane_40_in;        // Lane 0
    input    [63:0] lane_01_in;        // Lane 1
    input    [63:0] lane_11_in;        // Lane 1
    input    [63:0] lane_21_in;        // Lane 1
    input    [63:0] lane_31_in;        // Lane 1
    input    [63:0] lane_41_in;        // Lane 1
    input    [63:0] lane_02_in;        // Lane 2
    input    [63:0] lane_12_in;        // Lane 2
    input    [63:0] lane_22_in;        // Lane 2
    input    [63:0] lane_32_in;        // Lane 2
    input    [63:0] lane_42_in;        // Lane 2
    input    [63:0] lane_03_in;        // Lane 3
    input    [63:0] lane_13_in;        // Lane 3
    input    [63:0] lane_23_in;        // Lane 3
    input    [63:0] lane_33_in;        // Lane 3
    input    [63:0] lane_43_in;        // Lane 3
    input    [63:0] lane_04_in;        // Lane 4
    input    [63:0] lane_14_in;        // Lane 4
    input    [63:0] lane_24_in;        // Lane 4
    input    [63:0] lane_34_in;        // Lane 4
    input    [63:0] lane_44_in;        // Lane 4
    input            start;            // Input Valid
    input            word_valid;       // Word Valid
    input     [63:0] word_data;        // Input Data
    input            last_block;       // Last Block
    input            rst_n;            // Reset
    input            clk;              // Clock

/******************************************************************************
   Local variables
******************************************************************************/
    logic      [2:0] lx;              // lane x index, 0..4
    logic      [1:0] ly;              // lane y index, 0..3 (17 lanes max)
    logic      [4:0] round_cnt;       // 0..23
    logic      [4:0] round_cnt_w;     // 0..23
    logic            final_blk;       // latched last_block for this block
    logic            word_ready;      // Word ready
    logic            digest_valid;    // Hash output valid
    logic    [255:0] digest;          // Hash data
    logic     [63:0] lane_00;         // Lane 0
    logic     [63:0] lane_10;         // Lane 0
    logic     [63:0] lane_20;         // Lane 0
    logic     [63:0] lane_30;         // Lane 0
    logic     [63:0] lane_40;         // Lane 0
    logic     [63:0] lane_01;         // Lane 1
    logic     [63:0] lane_11;         // Lane 1
    logic     [63:0] lane_21;         // Lane 1
    logic     [63:0] lane_31;         // Lane 1
    logic     [63:0] lane_41;         // Lane 1
    logic     [63:0] lane_02;         // Lane 2
    logic     [63:0] lane_12;         // Lane 2
    logic     [63:0] lane_22;         // Lane 2
    logic     [63:0] lane_32;         // Lane 2
    logic     [63:0] lane_42;         // Lane 2
    logic     [63:0] lane_03;         // Lane 3
    logic     [63:0] lane_13;         // Lane 3
    logic     [63:0] lane_23;         // Lane 3
    logic     [63:0] lane_33;         // Lane 3
    logic     [63:0] lane_43;         // Lane 3
    logic     [63:0] lane_04;         // Lane 4
    logic     [63:0] lane_14;         // Lane 4
    logic     [63:0] lane_24;         // Lane 4
    logic     [63:0] lane_34;         // Lane 4
    logic     [63:0] lane_44;         // Lane 4
    logic     [63:0] lane_00_t;       // Lane 0 transposed
    logic     [63:0] lane_10_t;       // Lane 0 transposed
    logic     [63:0] lane_20_t;       // Lane 0 transposed
    logic     [63:0] lane_30_t;       // Lane 0 transposed
    // State machine variables
    typedef enum logic [1:0] {IDLE, LOAD, PERMUTE, DONE} state_e;
    state_e          curr_st;
    state_e          nxt_st;

/******************************************************************************
  Round Counter.
  Generate round_cnt_w one clock early as ROM outputs data on clock.
  To maintain cycle count.
******************************************************************************/
    always_comb
    begin
       round_cnt_w = (curr_st == PERMUTE) ? round_cnt+1 : '0;
    end

    always_ff @(posedge clk or negedge rst_n)
    begin
      if (~rst_n)
        round_cnt <= '0;
      else if (round_cnt == 'd23)
        round_cnt <= '0;
      else
        round_cnt <= round_cnt_w;
    end

/******************************************************************************
  Lane Counters.
******************************************************************************/
    always_ff @(posedge clk or negedge rst_n)
    begin
      if (~rst_n)
        lx <= '0;
      else if (start)
        lx <= '0;
      else if (((lx == 3'd4) | (lx == 3'd1 & ly == 2'd3)) & word_valid)
        lx <= '0;
      else if ((curr_st == LOAD) & word_valid)
        lx <= lx + 1'b1;
    end

    always_ff @(posedge clk or negedge rst_n)
    begin
      if (~rst_n)
        ly <= '0;
      else if (start)
        ly <= '0;
      else if ((lx == 3'd1 & ly == 2'd3) & word_valid)
        ly <= '0;
      else if ((lx == 3'd4) & word_valid)
        ly <= ly + 1'b1;
    end

/******************************************************************************
  Generate the digest.
******************************************************************************/
    assign lane_00_t = {lane_00[7:0], lane_00[15:8], lane_00[23:16], lane_00[31:24], lane_00[39:32], lane_00[47:40], lane_00[55:48], lane_00[63:56]};
    assign lane_10_t = {lane_10[7:0], lane_10[15:8], lane_10[23:16], lane_10[31:24], lane_10[39:32], lane_10[47:40], lane_10[55:48], lane_10[63:56]};
    assign lane_20_t = {lane_20[7:0], lane_20[15:8], lane_20[23:16], lane_20[31:24], lane_20[39:32], lane_20[47:40], lane_20[55:48], lane_20[63:56]};
    assign lane_30_t = {lane_30[7:0], lane_30[15:8], lane_30[23:16], lane_30[31:24], lane_30[39:32], lane_30[47:40], lane_30[55:48], lane_30[63:56]};
    // Each 64-bit lane is little-endian with respect to the digest bytes.
    assign digest = {lane_00_t, lane_10_t, lane_20_t, lane_30_t};

/******************************************************************************
  State Machine.
******************************************************************************/
    assign word_ready   = (curr_st == LOAD);
    assign digest_valid = (curr_st == DONE);

    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        curr_st <= IDLE;
      end
      else
        curr_st <= nxt_st;
    end

    always_comb begin
      case (curr_st)
        IDLE: begin
          if (start) begin
            nxt_st = LOAD;
          end
          else begin
            nxt_st = IDLE;
          end
        end

        LOAD: begin
          if ((lx == 3'd1 & ly == 2'd3) & word_valid) begin
            nxt_st = PERMUTE;
          end
          else begin
            nxt_st = LOAD;
          end
        end

        PERMUTE: begin
          if (round_cnt == 5'd23) begin
            nxt_st = final_blk ? DONE : LOAD;
          end
          else begin
            nxt_st = PERMUTE;
          end
        end

        DONE: begin
            // digest held stable; restart on demand
          if (start) begin
            nxt_st = LOAD;
          end
          else begin
            nxt_st = DONE;
          end
        end
        default: begin
          nxt_st = IDLE;
        end
      endcase
    end

    always_ff @(posedge clk or negedge rst_n)
    begin
      if (~rst_n) begin
          lane_00 <= '0;
          lane_01 <= '0;
          lane_02 <= '0;
          lane_03 <= '0;
          lane_04 <= '0;
          lane_10 <= '0;
          lane_11 <= '0;
          lane_12 <= '0;
          lane_13 <= '0;
          lane_14 <= '0;
          lane_20 <= '0;
          lane_21 <= '0;
          lane_22 <= '0;
          lane_23 <= '0;
          lane_24 <= '0;
          lane_30 <= '0;
          lane_31 <= '0;
          lane_32 <= '0;
          lane_33 <= '0;
          lane_34 <= '0;
          lane_40 <= '0;
          lane_41 <= '0;
          lane_42 <= '0;
          lane_43 <= '0;
          lane_44 <= '0;
      end
      else if ((curr_st == DONE) & start) begin
          lane_00 <= '0;
          lane_01 <= '0;
          lane_02 <= '0;
          lane_03 <= '0;
          lane_04 <= '0;
          lane_10 <= '0;
          lane_11 <= '0;
          lane_12 <= '0;
          lane_13 <= '0;
          lane_14 <= '0;
          lane_20 <= '0;
          lane_21 <= '0;
          lane_22 <= '0;
          lane_23 <= '0;
          lane_24 <= '0;
          lane_30 <= '0;
          lane_31 <= '0;
          lane_32 <= '0;
          lane_33 <= '0;
          lane_34 <= '0;
          lane_40 <= '0;
          lane_41 <= '0;
          lane_42 <= '0;
          lane_43 <= '0;
          lane_44 <= '0;
      end
      else if (curr_st == PERMUTE) begin
          lane_00 <= lane_00_in;
          lane_01 <= lane_01_in;
          lane_02 <= lane_02_in;
          lane_03 <= lane_03_in;
          lane_04 <= lane_04_in;
          lane_10 <= lane_10_in;
          lane_11 <= lane_11_in;
          lane_12 <= lane_12_in;
          lane_13 <= lane_13_in;
          lane_14 <= lane_14_in;
          lane_20 <= lane_20_in;
          lane_21 <= lane_21_in;
          lane_22 <= lane_22_in;
          lane_23 <= lane_23_in;
          lane_24 <= lane_24_in;
          lane_30 <= lane_30_in;
          lane_31 <= lane_31_in;
          lane_32 <= lane_32_in;
          lane_33 <= lane_33_in;
          lane_34 <= lane_34_in;
          lane_40 <= lane_40_in;
          lane_41 <= lane_41_in;
          lane_42 <= lane_42_in;
          lane_43 <= lane_43_in;
          lane_44 <= lane_44_in;
      end
      else if ((curr_st == LOAD) & word_valid) begin
          case ({lx,ly})
          {3'd0,2'd0}: lane_00 <= lane_00 ^ word_data;
          {3'd1,2'd0}: lane_10 <= lane_10 ^ word_data;
          {3'd2,2'd0}: lane_20 <= lane_20 ^ word_data;
          {3'd3,2'd0}: lane_30 <= lane_30 ^ word_data;
          {3'd4,2'd0}: lane_40 <= lane_40 ^ word_data;
          {3'd0,2'd1}: lane_01 <= lane_01 ^ word_data;
          {3'd1,2'd1}: lane_11 <= lane_11 ^ word_data;
          {3'd2,2'd1}: lane_21 <= lane_21 ^ word_data;
          {3'd3,2'd1}: lane_31 <= lane_31 ^ word_data;
          {3'd4,2'd1}: lane_41 <= lane_41 ^ word_data;
          {3'd0,2'd2}: lane_02 <= lane_02 ^ word_data;
          {3'd1,2'd2}: lane_12 <= lane_12 ^ word_data;
          {3'd2,2'd2}: lane_22 <= lane_22 ^ word_data;
          {3'd3,2'd2}: lane_32 <= lane_32 ^ word_data;
          {3'd4,2'd2}: lane_42 <= lane_42 ^ word_data;
          {3'd0,2'd3}: lane_03 <= lane_03 ^ word_data;
          {3'd1,2'd3}: lane_13 <= lane_13 ^ word_data;
        endcase
      end
    end

    always_ff @(posedge clk or negedge rst_n)
    begin
      if (~rst_n) begin
        final_blk <= '0;
      end
      else if (start) begin
        final_blk <= '0;
      end
      else if ((curr_st == LOAD) & word_valid) begin
        final_blk <= final_blk | last_block;
      end
    end

endmodule  // sha3_256_sm
