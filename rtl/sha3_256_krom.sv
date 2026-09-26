//*****************************************************************************
// Licensed under the Apache License, Version 2.0 (the "License"); you may not 
// use this file except in compliance with the License. You may obtain a copy 
// of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
// License for the specific language governing permissions and limitations 
// under the License.

// Date:     21/7/2026
// Description: SHA3 KEECAK RC ROM
//
//*****************************************************************************

module sha3_256_krom  (
  // Outputs
       dout,             // To 
  // Inputs
       addr,             // From 
       rst_n,            // From 
       clk               // From 
);
   
/******************************************************************************
   Outputs
******************************************************************************/   
   output  [63:0] dout;             // Rom Data Output
   
/******************************************************************************
   Inputs
******************************************************************************/  
   input    [4:0] addr;             // Address in
   input          rst_n;            // Reset
   input          clk;              // Clock
   
/******************************************************************************
   Local variables
******************************************************************************/    
   reg     [63:0] dout;              // Rom Data Output

/******************************************************************************
   ROM implementation
   // Keccak-f[1600] round constants (iota), FIPS 202
******************************************************************************/     
   always_ff @(posedge clk or negedge rst_n) begin
     if (~rst_n)
       dout <= 64'h0000000000000001;
     else begin
       case (addr)
         'd0: dout  <= 64'h0000000000000001;
         'd1: dout  <= 64'h0000000000008082;
         'd2: dout  <= 64'h800000000000808A;
         'd3: dout  <= 64'h8000000080008000;
         'd4: dout  <= 64'h000000000000808B;
         'd5: dout  <= 64'h0000000080000001;
         'd6: dout  <= 64'h8000000080008081;
         'd7: dout  <= 64'h8000000000008009;
         'd8: dout  <= 64'h000000000000008A;
         'd9: dout  <= 64'h0000000000000088;
         'd10: dout <= 64'h0000000080008009;
         'd11: dout <= 64'h000000008000000A;
         'd12: dout <= 64'h000000008000808B;
         'd13: dout <= 64'h800000000000008B;
         'd14: dout <= 64'h8000000000008089;
         'd15: dout <= 64'h8000000000008003;
         'd16: dout <= 64'h8000000000008002;
         'd17: dout <= 64'h8000000000000080;
         'd18: dout <= 64'h000000000000800A;
         'd19: dout <= 64'h800000008000000A;
         'd20: dout <= 64'h8000000080008081;
         'd21: dout <= 64'h8000000000008080;
         'd22: dout <= 64'h0000000080000001;
         'd23: dout <= 64'h8000000080008008;
       endcase
     end
   end
   
endmodule // sha3_256_krom
