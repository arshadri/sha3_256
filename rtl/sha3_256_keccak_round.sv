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
// Description: Keecak Round functionality of SHA3
//
//*****************************************************************************

`include "sha3_256_defines.h"
  module sha3_256_keccak_round (
    // Outputs
      lane_00_out,        // To sha3_256_sm
      lane_10_out,        // To sha3_256_sm
      lane_20_out,        // To sha3_256_sm
      lane_30_out,        // To sha3_256_sm
      lane_40_out,        // To sha3_256_sm
      lane_01_out,        // To sha3_256_sm
      lane_11_out,        // To sha3_256_sm
      lane_21_out,        // To sha3_256_sm
      lane_31_out,        // To sha3_256_sm
      lane_41_out,        // To sha3_256_sm
      lane_02_out,        // To sha3_256_sm
      lane_12_out,        // To sha3_256_sm
      lane_22_out,        // To sha3_256_sm
      lane_32_out,        // To sha3_256_sm
      lane_42_out,        // To sha3_256_sm
      lane_03_out,        // To sha3_256_sm
      lane_13_out,        // To sha3_256_sm
      lane_23_out,        // To sha3_256_sm
      lane_33_out,        // To sha3_256_sm
      lane_43_out,        // To sha3_256_sm
      lane_04_out,        // To sha3_256_sm
      lane_14_out,        // To sha3_256_sm
      lane_24_out,        // To sha3_256_sm
      lane_34_out,        // To sha3_256_sm
      lane_44_out,        // To sha3_256_sm
    // Inputs
      lane_00_in,         // From sha3_256_sm
      lane_10_in,         // From sha3_256_sm
      lane_20_in,         // From sha3_256_sm
      lane_30_in,         // From sha3_256_sm
      lane_40_in,         // From sha3_256_sm
      lane_01_in,         // From sha3_256_sm
      lane_11_in,         // From sha3_256_sm
      lane_21_in,         // From sha3_256_sm
      lane_31_in,         // From sha3_256_sm
      lane_41_in,         // From sha3_256_sm
      lane_02_in,         // From sha3_256_sm
      lane_12_in,         // From sha3_256_sm
      lane_22_in,         // From sha3_256_sm
      lane_32_in,         // From sha3_256_sm
      lane_42_in,         // From sha3_256_sm
      lane_03_in,         // From sha3_256_sm
      lane_13_in,         // From sha3_256_sm
      lane_23_in,         // From sha3_256_sm
      lane_33_in,         // From sha3_256_sm
      lane_43_in,         // From sha3_256_sm
      lane_04_in,         // From sha3_256_sm
      lane_14_in,         // From sha3_256_sm
      lane_24_in,         // From sha3_256_sm
      lane_34_in,         // From sha3_256_sm
      lane_44_in,         // From sha3_256_sm
      rc                  // From sha3_krom
  );

/******************************************************************************
   Outputs
******************************************************************************/
    output     [63:0] lane_00_out;         // Lane 0 out
    output     [63:0] lane_10_out;         // Lane 0 out
    output     [63:0] lane_20_out;         // Lane 0 out
    output     [63:0] lane_30_out;         // Lane 0 out
    output     [63:0] lane_40_out;         // Lane 0 out
    output     [63:0] lane_01_out;         // Lane 1 out
    output     [63:0] lane_11_out;         // Lane 1 out
    output     [63:0] lane_21_out;         // Lane 1 out
    output     [63:0] lane_31_out;         // Lane 1 out
    output     [63:0] lane_41_out;         // Lane 1 out
    output     [63:0] lane_02_out;         // Lane 2 out
    output     [63:0] lane_12_out;         // Lane 2 out
    output     [63:0] lane_22_out;         // Lane 2 out
    output     [63:0] lane_32_out;         // Lane 2 out
    output     [63:0] lane_42_out;         // Lane 2 out
    output     [63:0] lane_03_out;         // Lane 3 out
    output     [63:0] lane_13_out;         // Lane 3 out
    output     [63:0] lane_23_out;         // Lane 3 out
    output     [63:0] lane_33_out;         // Lane 3 out
    output     [63:0] lane_43_out;         // Lane 3 out
    output     [63:0] lane_04_out;         // Lane 4 out
    output     [63:0] lane_14_out;         // Lane 4 out
    output     [63:0] lane_24_out;         // Lane 4 out
    output     [63:0] lane_34_out;         // Lane 4 out
    output     [63:0] lane_44_out;         // Lane 4 out

/******************************************************************************
   Inputs
******************************************************************************/
    input     [63:0] lane_00_in;         // Lane 0 in
    input     [63:0] lane_10_in;         // Lane 0 in
    input     [63:0] lane_20_in;         // Lane 0 in
    input     [63:0] lane_30_in;         // Lane 0 in
    input     [63:0] lane_40_in;         // Lane 0 in
    input     [63:0] lane_01_in;         // Lane 1 in
    input     [63:0] lane_11_in;         // Lane 1 in
    input     [63:0] lane_21_in;         // Lane 1 in
    input     [63:0] lane_31_in;         // Lane 1 in
    input     [63:0] lane_41_in;         // Lane 1 in
    input     [63:0] lane_02_in;         // Lane 2 in
    input     [63:0] lane_12_in;         // Lane 2 in
    input     [63:0] lane_22_in;         // Lane 2 in
    input     [63:0] lane_32_in;         // Lane 2 in
    input     [63:0] lane_42_in;         // Lane 2 in
    input     [63:0] lane_03_in;         // Lane 3 in
    input     [63:0] lane_13_in;         // Lane 3 in
    input     [63:0] lane_23_in;         // Lane 3 in
    input     [63:0] lane_33_in;         // Lane 3 in
    input     [63:0] lane_43_in;         // Lane 3 in
    input     [63:0] lane_04_in;         // Lane 4 in
    input     [63:0] lane_14_in;         // Lane 4 in
    input     [63:0] lane_24_in;         // Lane 4 in
    input     [63:0] lane_34_in;         // Lane 4 in
    input     [63:0] lane_44_in;         // Lane 4 in
    input     [63:0] rc;                 // round constant for iota

/******************************************************************************
   Local variables
******************************************************************************/
    logic    [63:0] c  [5];              // theta column parities
    logic    [63:0] d  [5];              //
    logic    [63:0] th_00;               // theta
    logic    [63:0] th_01;               // theta
    logic    [63:0] th_02;               // theta
    logic    [63:0] th_03;               // theta
    logic    [63:0] th_04;               // theta
    logic    [63:0] th_10;               // theta
    logic    [63:0] th_11;               // theta
    logic    [63:0] th_12;               // theta
    logic    [63:0] th_13;               // theta
    logic    [63:0] th_14;               // theta
    logic    [63:0] th_20;               // theta
    logic    [63:0] th_21;               // theta
    logic    [63:0] th_22;               // theta
    logic    [63:0] th_23;               // theta
    logic    [63:0] th_24;               // theta
    logic    [63:0] th_30;               // theta
    logic    [63:0] th_31;               // theta
    logic    [63:0] th_32;               // theta
    logic    [63:0] th_33;               // theta
    logic    [63:0] th_34;               // theta
    logic    [63:0] th_40;               // theta
    logic    [63:0] th_41;               // theta
    logic    [63:0] th_42;               // theta
    logic    [63:0] th_43;               // theta
    logic    [63:0] th_44;               // theta
    logic    [63:0] rp_00;               // rho
    logic    [63:0] rp_01;               // rho
    logic    [63:0] rp_02;               // rho
    logic    [63:0] rp_03;               // rho
    logic    [63:0] rp_04;               // rho
    logic    [63:0] rp_10;               // rho
    logic    [63:0] rp_11;               // rho
    logic    [63:0] rp_12;               // rho
    logic    [63:0] rp_13;               // rho
    logic    [63:0] rp_14;               // rho
    logic    [63:0] rp_20;               // rho
    logic    [63:0] rp_21;               // rho
    logic    [63:0] rp_22;               // rho
    logic    [63:0] rp_23;               // rho
    logic    [63:0] rp_24;               // rho
    logic    [63:0] rp_30;               // rho
    logic    [63:0] rp_31;               // rho
    logic    [63:0] rp_32;               // rho
    logic    [63:0] rp_33;               // rho
    logic    [63:0] rp_34;               // rho
    logic    [63:0] rp_40;               // rho
    logic    [63:0] rp_41;               // rho
    logic    [63:0] rp_42;               // rho
    logic    [63:0] rp_43;               // rho
    logic    [63:0] rp_44;               // rho
    logic    [63:0] ch_00;               // chi
    logic    [63:0] ch_01;               // chi
    logic    [63:0] ch_02;               // chi
    logic    [63:0] ch_03;               // chi
    logic    [63:0] ch_04;               // chi
    logic    [63:0] ch_10;               // chi
    logic    [63:0] ch_11;               // chi
    logic    [63:0] ch_12;               // chi
    logic    [63:0] ch_13;               // chi
    logic    [63:0] ch_14;               // chi
    logic    [63:0] ch_20;               // chi
    logic    [63:0] ch_21;               // chi
    logic    [63:0] ch_22;               // chi
    logic    [63:0] ch_23;               // chi
    logic    [63:0] ch_24;               // chi
    logic    [63:0] ch_30;               // chi
    logic    [63:0] ch_31;               // chi
    logic    [63:0] ch_32;               // chi
    logic    [63:0] ch_33;               // chi
    logic    [63:0] ch_34;               // chi
    logic    [63:0] ch_40;               // chi
    logic    [63:0] ch_41;               // chi
    logic    [63:0] ch_42;               // chi
    logic    [63:0] ch_43;               // chi
    logic    [63:0] ch_44;               // chi
    logic    [63:0] lane_00_out;         // Lane 0 out           
    logic    [63:0] lane_10_out;         // Lane 0 out
    logic    [63:0] lane_20_out;         // Lane 0 out
    logic    [63:0] lane_30_out;         // Lane 0 out
    logic    [63:0] lane_40_out;         // Lane 0 out
    logic    [63:0] lane_01_out;         // Lane 1 out
    logic    [63:0] lane_11_out;         // Lane 1 out
    logic    [63:0] lane_21_out;         // Lane 1 out
    logic    [63:0] lane_31_out;         // Lane 1 out
    logic    [63:0] lane_41_out;         // Lane 1 out
    logic    [63:0] lane_02_out;         // Lane 2 out
    logic    [63:0] lane_12_out;         // Lane 2 out
    logic    [63:0] lane_22_out;         // Lane 2 out
    logic    [63:0] lane_32_out;         // Lane 2 out
    logic    [63:0] lane_42_out;         // Lane 2 out
    logic    [63:0] lane_03_out;         // Lane 3 out
    logic    [63:0] lane_13_out;         // Lane 3 out
    logic    [63:0] lane_23_out;         // Lane 3 out
    logic    [63:0] lane_33_out;         // Lane 3 out
    logic    [63:0] lane_43_out;         // Lane 3 out
    logic    [63:0] lane_04_out;         // Lane 4 out
    logic    [63:0] lane_14_out;         // Lane 4 out
    logic    [63:0] lane_24_out;         // Lane 4 out
    logic    [63:0] lane_34_out;         // Lane 4 out
    logic    [63:0] lane_44_out;         // Lane 4 out

    always_comb begin
        // --- theta: mix each lane with parities of two adjacent columns ---
      c[0] = lane_00_in ^ lane_01_in ^ lane_02_in ^ lane_03_in ^ lane_04_in;
      c[1] = lane_10_in ^ lane_11_in ^ lane_12_in ^ lane_13_in ^ lane_14_in;
      c[2] = lane_20_in ^ lane_21_in ^ lane_22_in ^ lane_23_in ^ lane_24_in;
      c[3] = lane_30_in ^ lane_31_in ^ lane_32_in ^ lane_33_in ^ lane_34_in;
      c[4] = lane_40_in ^ lane_41_in ^ lane_42_in ^ lane_43_in ^ lane_44_in;

      d[0] = c[4] ^ rol64(c[1], 1);  //x=0
      d[1] = c[0] ^ rol64(c[2], 1);  //x=1
      d[2] = c[1] ^ rol64(c[3], 1);  //x=2
      d[3] = c[2] ^ rol64(c[4], 1);  //x=3
      d[4] = c[3] ^ rol64(c[0], 1);  //x=4

      th_00 = lane_00_in ^ d[0];
      th_01 = lane_01_in ^ d[0];
      th_02 = lane_02_in ^ d[0];
      th_03 = lane_03_in ^ d[0];
      th_04 = lane_04_in ^ d[0];
      th_10 = lane_10_in ^ d[1];
      th_11 = lane_11_in ^ d[1];
      th_12 = lane_12_in ^ d[1];
      th_13 = lane_13_in ^ d[1];
      th_14 = lane_14_in ^ d[1];
      th_20 = lane_20_in ^ d[2];
      th_21 = lane_21_in ^ d[2];
      th_22 = lane_22_in ^ d[2];
      th_23 = lane_23_in ^ d[2];
      th_24 = lane_24_in ^ d[2];
      th_30 = lane_30_in ^ d[3];
      th_31 = lane_31_in ^ d[3];
      th_32 = lane_32_in ^ d[3];
      th_33 = lane_33_in ^ d[3];
      th_34 = lane_34_in ^ d[3];
      th_40 = lane_40_in ^ d[4];
      th_41 = lane_41_in ^ d[4];
      th_42 = lane_42_in ^ d[4];
      th_43 = lane_43_in ^ d[4];
      th_44 = lane_44_in ^ d[4];

      rp_00 = rol64(th_00,RHO_func({3'd0,3'd0}));
      rp_01 = rol64(th_30,RHO_func({3'd3,3'd0}));
      rp_02 = rol64(th_10,RHO_func({3'd1,3'd0}));
      rp_03 = rol64(th_40,RHO_func({3'd4,3'd0}));
      rp_04 = rol64(th_20,RHO_func({3'd2,3'd0}));

      rp_10 = rol64(th_11,RHO_func({3'd1,3'd1}));
      rp_11 = rol64(th_41,RHO_func({3'd4,3'd1}));
      rp_12 = rol64(th_21,RHO_func({3'd2,3'd1}));
      rp_13 = rol64(th_01,RHO_func({3'd0,3'd1}));
      rp_14 = rol64(th_31,RHO_func({3'd3,3'd1}));

      rp_20 = rol64(th_22,RHO_func({3'd2,3'd2}));
      rp_21 = rol64(th_02,RHO_func({3'd0,3'd2}));
      rp_22 = rol64(th_32,RHO_func({3'd3,3'd2}));
      rp_23 = rol64(th_12,RHO_func({3'd1,3'd2}));
      rp_24 = rol64(th_42,RHO_func({3'd4,3'd2}));

      rp_30 = rol64(th_33,RHO_func({3'd3,3'd3}));
      rp_31 = rol64(th_13,RHO_func({3'd1,3'd3}));
      rp_32 = rol64(th_43,RHO_func({3'd4,3'd3}));
      rp_33 = rol64(th_23,RHO_func({3'd2,3'd3}));
      rp_34 = rol64(th_03,RHO_func({3'd0,3'd3}));

      rp_40 = rol64(th_44,RHO_func({3'd4,3'd4}));
      rp_41 = rol64(th_24,RHO_func({3'd2,3'd4}));
      rp_42 = rol64(th_04,RHO_func({3'd0,3'd4}));
      rp_43 = rol64(th_34,RHO_func({3'd3,3'd4}));
      rp_44 = rol64(th_14,RHO_func({3'd1,3'd4}));

      ch_00 = rp_00 ^ (~rp_10 & rp_20);
      ch_01 = rp_01 ^ (~rp_11 & rp_21);
      ch_02 = rp_02 ^ (~rp_12 & rp_22);
      ch_03 = rp_03 ^ (~rp_13 & rp_23);
      ch_04 = rp_04 ^ (~rp_14 & rp_24);
      ch_10 = rp_10 ^ (~rp_20 & rp_30);
      ch_11 = rp_11 ^ (~rp_21 & rp_31);
      ch_12 = rp_12 ^ (~rp_22 & rp_32);
      ch_13 = rp_13 ^ (~rp_23 & rp_33);
      ch_14 = rp_14 ^ (~rp_24 & rp_34);
      ch_20 = rp_20 ^ (~rp_30 & rp_40);
      ch_21 = rp_21 ^ (~rp_31 & rp_41);
      ch_22 = rp_22 ^ (~rp_32 & rp_42);
      ch_23 = rp_23 ^ (~rp_33 & rp_43);
      ch_24 = rp_24 ^ (~rp_34 & rp_44);
      ch_30 = rp_30 ^ (~rp_40 & rp_00);
      ch_31 = rp_31 ^ (~rp_41 & rp_01);
      ch_32 = rp_32 ^ (~rp_42 & rp_02);
      ch_33 = rp_33 ^ (~rp_43 & rp_03);
      ch_34 = rp_34 ^ (~rp_44 & rp_04);
      ch_40 = rp_40 ^ (~rp_00 & rp_10);
      ch_41 = rp_41 ^ (~rp_01 & rp_11);
      ch_42 = rp_42 ^ (~rp_02 & rp_12);
      ch_43 = rp_43 ^ (~rp_03 & rp_13);
      ch_44 = rp_44 ^ (~rp_04 & rp_14);

      lane_00_out = ch_00 ^ rc;
      lane_01_out = ch_01;
      lane_02_out = ch_02;
      lane_03_out = ch_03;
      lane_04_out = ch_04;
      lane_10_out = ch_10;
      lane_11_out = ch_11;
      lane_12_out = ch_12;
      lane_13_out = ch_13;
      lane_14_out = ch_14;
      lane_20_out = ch_20;
      lane_21_out = ch_21;
      lane_22_out = ch_22;
      lane_23_out = ch_23;
      lane_24_out = ch_24;
      lane_30_out = ch_30;
      lane_31_out = ch_31;
      lane_32_out = ch_32;
      lane_33_out = ch_33;
      lane_34_out = ch_34;
      lane_40_out = ch_40;
      lane_41_out = ch_41;
      lane_42_out = ch_42;
      lane_43_out = ch_43;
      lane_44_out = ch_44;
    end

// Rotate left
  function logic [63:0] rol64 (input logic [63:0] v, input logic [5:0] n);
    return (n == 0) ? v : ((v << n) | (v >> (64 - n)));
  endfunction

// RHO calculation
  function logic [5:0] RHO_func (input logic [5:0] in);
    case(in)
      {3'd0,3'd0}: RHO_func = 'd0;
      {3'd3,3'd0}: RHO_func = 'd28;
      {3'd1,3'd0}: RHO_func = 'd1;
      {3'd4,3'd0}: RHO_func = 'd27;
      {3'd2,3'd0}: RHO_func = 'd62;
      {3'd1,3'd1}: RHO_func = 'd44;
      {3'd4,3'd1}: RHO_func = 'd20;
      {3'd2,3'd1}: RHO_func = 'd6;
      {3'd0,3'd1}: RHO_func = 'd36;
      {3'd3,3'd1}: RHO_func = 'd55;
      {3'd2,3'd2}: RHO_func = 'd43;
      {3'd0,3'd2}: RHO_func = 'd3;
      {3'd3,3'd2}: RHO_func = 'd25;
      {3'd1,3'd2}: RHO_func = 'd10;
      {3'd4,3'd2}: RHO_func = 'd39;
      {3'd3,3'd3}: RHO_func = 'd21;
      {3'd1,3'd3}: RHO_func = 'd45;
      {3'd4,3'd3}: RHO_func = 'd8;
      {3'd2,3'd3}: RHO_func = 'd15;
      {3'd0,3'd3}: RHO_func = 'd41;
      {3'd4,3'd4}: RHO_func = 'd14;
      {3'd2,3'd4}: RHO_func = 'd61;
      {3'd0,3'd4}: RHO_func = 'd18;
      {3'd3,3'd4}: RHO_func = 'd56;
      {3'd1,3'd4}: RHO_func = 'd2;
    endcase
    return RHO_func;
  endfunction

endmodule // sha3_keecak_round
