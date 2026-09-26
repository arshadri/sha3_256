
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
// Description: SHA3 testbench
//
//*****************************************************************************
`timescale 1ns / 1ps


 `define M16 1087:1024
 `define M15 1023:960
 `define M14 959:896
 `define M13 895:832
 `define M12 831:768
 `define M11 767:704
 `define M10 703:640
 `define M9  639:576
 `define M8  575:512
 `define M7  511:448
 `define M6  447:384
 `define M5  383:320
 `define M4  319:256
 `define M3  255:192
 `define M2  191:128
 `define M1  127:64
 `define M0  63:0
 
module sha3_256_tb;

  logic         clk;                    // Clock
  logic         rst_n;                  // Reset
  logic         start;                  // Start Calculation
  logic         word_valid;             // Input word valid
  logic         word_ready;             // Output word ready
  logic [63:0]  word_data;              // Input word data
  logic         last_block;             // Last Block
  logic         digest_valid;           // Output hash valid
  logic         digest_valid_d;         // Output hash valid delayed
  logic [255:0] digest;                 // Output hash digest 
    
  logic [255:0]  expected_value;         // Expected HASH value
  int            num_inputs;             // Number of input rounds for a msg
  int            max_done;               // Number of done to be expected in TB
  int            cnt_done;               // Number of done counted
  int            cnt_hash;               // Count data valid out assertion
  bit            perf_match;             // Match output

  // Generate clock
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end
    
    
  always @(*)
  begin
    if (rst_n & (cnt_hash == max_done))
    begin
      $display($time, "\tAll done's received %d", cnt_hash);
      #100 $finish;
    end
  end
  
  always @(posedge clk)
  begin
    if ((num_inputs != 1) & word_valid)
    begin
      num_inputs <= num_inputs - 1;
    end
  end
  
  
/******************************************************************************
   Logic to compare expected and actual hash data
*******************************************************************************/      
   always @ (posedge clk)
   begin
     if (digest_valid & ~digest_valid_d & (expected_value === digest) & perf_match)
          $display("[%d]\tPASS: DUT Hash %d Matches: hash = %h", $time,cnt_hash,digest);
     else if (digest_valid & ~digest_valid_d & (expected_value !== digest) & perf_match)
          $display("[%d]\tFAIL: DUT Hash %d MisMatches: hash = %h expected_hash = %h", $time,cnt_hash,digest,expected_value);   
   end

   always @ (posedge clk)
   begin    
     if (~rst_n)
       cnt_hash <= 'd0;
     else if (digest_valid & ~digest_valid_d)
     begin
       cnt_hash <= cnt_hash+1'b1;
     end
   end
   
   always @ (posedge clk)
   begin    
     if (~rst_n)
       cnt_done <= 'd0;
     else if (digest_valid  & ~digest_valid_d)
       cnt_done <= cnt_done+1'b1;
   end
   
   always @ (posedge clk)
   begin    
     if (~rst_n)
       digest_valid_d <= 'd0;
     else 
       digest_valid_d <= digest_valid;
   end
   
/******************************************************************************
   Task to feed data into DUT
*******************************************************************************/
   task automatic send_word;
   input         ld_ntmsg;
   input         last_in;
   input [1087:0] in;

   begin
     @(posedge clk) start <= ld_ntmsg;
     @(posedge clk) start <= 0;
     wait (word_ready);
     @(posedge clk);
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M0];  last_block <= last_in; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M1];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M2];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M3];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M4];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M5];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M6];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M7];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M8];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M9];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M10];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M11];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M12];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M13];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M14];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M15];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 1; word_data <= in[`M16];  last_block <= 1'b0; end
     @ (posedge clk) begin word_valid <= 0; last_block <= 1'b0; end
   end
   endtask

/******************************************************************************
   Task to generate reset
*******************************************************************************/
   task rst_dev;
   input [31:0]  i;

   begin
     rst_n = 1'b0;
     start = 0;
     word_valid = 0;
     word_data = 64'h0;
     cnt_hash = 3'h0;
     max_done = 'd0;
     num_inputs = 1;
     last_block = 0;
     perf_match = 0;
     repeat (i) @(posedge clk);
     rst_n = 1'b1;

      $display($time, "\t Reset finished i= %d", i);
   end
   endtask

/******************************************************************************
   Device under test
******************************************************************************/
    sha3_256_top dut (
      // Outputs
        .word_ready   (word_ready),
        .digest_valid (digest_valid),
        .digest       (digest),
      // Inputs
        .start        (start),
        .word_valid   (word_valid),
        .word_data    (word_data),
        .last_block   (last_block),
        .rst_n        (rst_n),
        .clk          (clk)
    );

endmodule
