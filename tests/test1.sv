//*****************************************************************************
// Licensed under the Apache License, Version 2.0 (the "License"); you may not 
// use this file except in compliance with the License. You may obtain a copy 
// of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
// License for the specific language governing permissions and limitations 
// under the License.

// Date:      9/26/2026
// Description: basic SHA3 test vectors
//
//*****************************************************************************
module test1;

   reg   [1087:0] sin;                       // Input string        
   reg    [255:0] md[3];                     // Message Digest
   int            vec_num;                   // Vector number
   
// Instance the testbench
   sha3_256_tb   tb();

// Expected messgage digest   
  initial
  begin
    md[0] = 256'hA7FFC6F8BF1ED76651C14756A061D662F580FF4DE43B49FA82D80A4B80F8434A;
    md[1] = 256'h7B0047CF5A456882363CBF0FB05322CF65F4B7059A46365E830132E3B5D957AF;
    md[2] = 256'hC8242FEF409E5AE9D1F1C857AE4DC624B92B19809F62AA8C07411C54A078B1D0;
  end    
  //7B_00_47_CF_5A_45_68_82_36_3C_BF_0F_B0_53_22_CF
  //65 F4 B7 05 9A 46 36 5E 83 01 32 E3 B5 D9 57 AF
  
  //C8 24 2F EF 40 9E 5A E9 D1 F1 C8 57 AE 4D C6 24
  //B9 2B 19 80 9F 62 AA 8C 07 41 1C 54 A0 78 B1 D0
//Start the test   
  initial 
  begin
    tb.rst_dev(20);
    tb.num_inputs = 1;
    tb.max_done = 'd0;
    tb.perf_match = 1;
  
/******************************************************************************
   Test vectors for HASH generation 
*******************************************************************************/    
   // vector 1 pass
   vec_num = 0;
   tb.max_done = tb.max_done+1;
   sin = {64'h8000_0000_0000_0000,{7{128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00}},128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_06};
   tb.send_word(1'b1, 1'b1, sin); 
   tb.expected_value = md[vec_num];
   wait (tb.digest_valid)
   @(posedge tb.clk);
   
   $display($time, "\tVector 1 Finished");
 
   // vector 2 pass
   vec_num = vec_num+1;
   tb.max_done = tb.max_done+1;
   sin = {64'h8000_0000_0000_0000,{7{128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00}},128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_d3};
   tb.send_word(1'b1, 1'b1, sin); 
   tb.expected_value = md[vec_num];
   wait (tb.digest_valid)
   @(posedge tb.clk);
   
   $display($time, "\tVector 2 Finished");

   // vector 3 pass
   vec_num = vec_num+1;
   tb.max_done = tb.max_done+1;
   //1 1 0 0_1 0 1 0_0 0 0 1_1 0 1 0_1 1 0 1_1 1 1 0_1 0 0 1_1 0
   //110_10_1001_1110_1101_1010_0001_0101_0011
   sin = {64'h8000_0000_0000_0000,{7{128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00}},128'h00_00_00_00_00_00_00_00_00_00_00_01_99_7b_58_53};
   tb.send_word(1'b1, 1'b1, sin); 
   tb.expected_value = md[vec_num];
   wait (tb.digest_valid)
   @(posedge tb.clk);
   
   $display($time, "\tVector 3 Finished");
   end
   
endmodule //test1
