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
// Description: Verifies vectors taken from following
//#  CAVS 19.0
//#  "SHA3-256 Monte" information for "SHA3AllBytes1-28-16"
//#  SHA3-256 tests are configured for BYTE oriented implementations
//#  Length values represented in bits
//#  Generated on Thu Jan 28 13:32:45 2016
//
// SHA3VS Monte Carlo (byte-oriented SHA3-256):
//   MD0 = Seed
//   for COUNT j = 0 .. 99
//     for i = 1 .. 1000
//       Msg_i = MD_{i-1}          // 32-byte message
//       MD_i  = SHA3-256(Msg_i)
//     output MD_1000 as md[j]
//     MD0 = MD_1000
// This test developed with the help of Cursor AI
//*****************************************************************************
module test4;

   reg   [1087:0] sin;                       // Input string
   reg    [255:0] md[100];                   // Message Digest checkpoints
   reg    [255:0] msg;                       // Chained 32-byte Monte Carlo message
   int            vec_num;                   // COUNT / vector number
   int            inner;                     // Inner hash 1..1000
   
// Instance the testbench
   sha3_256_tb   tb();

// Byte-reverse a 256-bit NIST digest so the first MD byte is sin[7:0]
   function automatic [255:0] byte_rev256(input [255:0] d);
      integer k;
      begin
         for (k = 0; k < 32; k = k + 1)
            byte_rev256[k*8 +: 8] = d[(31-k)*8 +: 8];
      end
   endfunction

// Expected messgage digest   
  initial
  begin

    md[0] = 256'h225cbac2be6f329d94228c5360a1c177bc495a761c442a1771b1d18555c309a5;
    md[1] = 256'h96d364a1b1ced3dbbce6380093fb1ac77221abcee30faf16546ffad8fe1eef8c;
    md[2] = 256'h8d81a67598ff73e2305ed53b1e6d58c799a1d1908abf81a15eab4bfd35b96e51;
    md[3] = 256'hc71b506211ad3814e5d6f596a452c94dda511d6d3f3cda77041882aca3363708;
    md[4] = 256'h804fb2ae90fe2d1a2f995b9d424f1ee4d92ceb6462d71fe05d3bc3275687c8ac;
    md[5] = 256'h872265e74370558a0caf5bed4663a40a36ea14b3ab498d54d0d4d29cdd18c1c9;
    md[6] = 256'h0d3e8b1276fb39ead94ee69a120e56ea3e8cd0436a4b46de58ed8db5cc02e2e1;
    md[7] = 256'h5281ee56dd7e7b6d1bbebcd2393eb8de6b3dcbce38f1f892d80ed7015b36ae3d;
    md[8] = 256'hac9381ebd23f32a57b811c541506b340875454a0cfe303b6a93a691d01f39e22;
    md[9] = 256'hbf7d7f341568aa0fbdc63e5f931185e0c6a6d522c5d86cd44cb27b1956d3a47e;
    md[10] = 256'h13a0ea2b7c01f5da5120d86cb626e222a137fd53b60a87391183effc7332dcdd;
    md[11] = 256'h0997572374ff8711539840f5c32fcab923b32a94c101f709b214386cf9e28c55;
    md[12] = 256'h68dcc06346d43c34e39428839586228ca03a6afc87101a35a92508e7ddd97b2c;
    md[13] = 256'h6d3f08f8d5d53cc092980c75d8992825d564b1f0557ccdba3d36dacda649a0d2;
    md[14] = 256'hacb740956b0c297c7ba93ed75c9ae2d770ceccaa268671cb6c5f779ea337edb5;
    md[15] = 256'hbca776fc02c138ae1aa9c7bad9c326f478d90f320232f270488bedf81c4e1d62;
    md[16] = 256'hc6170ed6a1cd137a56b88ea49931da5703fd0068c579a1ec59b5be9e63f2e6df;
    md[17] = 256'h725333b1a3a9a460ea4ac73cd60c7e65b30740bc7c345cedeecfc2ed377ce484;
    md[18] = 256'hc81f200c8c101682f123b44d2608d2cea270fb3e7e8aa395f016810ba89b27ad;
    md[19] = 256'hd79a6f3dde5e053f342a2a2a9f844ddac71e5ff468a0d3276c81bd8126b3ee17;
    md[20] = 256'h0c7f14428ee35003728ef697073f3422129653768ff4e5861d8d79a93e364b6a;
    md[21] = 256'h7644dfdcf6f8ea827762c8a230bad47ce730a02f1845e669ba21f2f191493dce;
    md[22] = 256'hd2df3503c8f619d271384bed3987100a6ca9faf5a7592e7ff557898486956f1f;
    md[23] = 256'h9e37d7ef189e6eac81770eb692926e9a3d2c5d578187689c31eeb3da5d7c5183;
    md[24] = 256'h9e32047d1790838fc89ce97e3614f31c3da2f863ce7b3a68f3847c7f97f9272e;
    md[25] = 256'hc9b89d136d2b860fe892b4e37de8b7a4e19c49114b3457cba3bef8bb117d14c7;
    md[26] = 256'ha01e4086adc45a9944aedf333954b24daf813215ffed38bc0ba5667a4c19d9ef;
    md[27] = 256'hcce16e645ae14a6d0cdcf4c35627353c8ad3fbfef50c3fbd6205ca1959c1dca8;
    md[28] = 256'h5c25e7747283c51709adb8058fe0a80626dd30c18f3c872e715e09081f487b2d;
    md[29] = 256'he645d82344734a50fab4c5304452658f95c46b7fd2ce4acd9cbd9ecff5b69d9c;
    md[30] = 256'h5165cebc2429ed67a52c33121afc784d39c4b062bc2ba996ef1de6d7dde9e657;
    md[31] = 256'h3467af2ef9dad19c23aaeccdb0da0447e2b66821c02caa05ecd5e58bad2c9852;
    md[32] = 256'hc9cdfb5e41544b0111293181d2178e46b3a579e27e7d459d9b7fbf19f277b1e4;
    md[33] = 256'hfd6f6126f221f04b119f1b42da4a37eb96c304d993ef4dd9a80ad23948bc4683;
    md[34] = 256'hce7b435ee9c83df626f1fec815d40bce5bf2763e13b69d556730dfb146b91b6d;
    md[35] = 256'ha733d5fc621a65b365fbf59fea7163e683bf5348e5552c55c9cea3b01f61a73c;
    md[36] = 256'hd2b076cfb5d715d47d62a46599c322ccf4ad75af93a2e5d6c2cea99cc3e02ea7;
    md[37] = 256'hf9292341cabcd4db57974ba7a0bf193bb831e4733b78b121d59c002d2bdded27;
    md[38] = 256'h8de979b00f2aa1337dfc6f4d0faa4a795932267a9455cffb6c03c3d1d6c99ef4;
    md[39] = 256'h5a1db7c17f6da1c5205404c62f658cb0d986e2ef29137c5a987c81b86e24431c;
    md[40] = 256'had37dc164141f0161a20cc41ad06c5bf96a0cd07d33756377c1d78a878fb3bb9;
    md[41] = 256'h01b5f604094a5a61a4013d2ce7aabf2c1d1845fe9a1f4ffc778452ae5309a67a;
    md[42] = 256'h17e58ccea2d2adc7b93805b54dfc76db06f078c312d9986b69a6c8fe97037dd1;
    md[43] = 256'h8e16f09e24f926e7990588e6bc68f7d844d6e05cd865e10f5a3ba87cac2bc6ad;
    md[44] = 256'hf95518a1d7233b7af4e6d205adcae0ac26d74f70f9342d0221d65b8d73ad53bc;
    md[45] = 256'hbed31e5554b01582e2ed0c2ccc01028e535b2034a2f6292b60e591f861176e11;
    md[46] = 256'hb5b6a97f320a21ae56b14c704d8e704e4bead893e87a1cc02a8cde81366c033d;
    md[47] = 256'h4ecc5e0426865bfa15b72d237bcb27840d318667701995cbde243ffe63a22f5a;
    md[48] = 256'hcdf72b4a14845cd0b4988d9c4985d08c2ab8f673885154c93ae85d6db15a25b7;
    md[49] = 256'h9a757015d251d4e17eb7543843ad7e1dab88a6c488e359cbdac84d4c55371c00;
    md[50] = 256'hacda904cdf58c03e33add74668188a818b3ba12a19bbf8ed8ddb105503e90ab7;
    md[51] = 256'hd5a8450ab0d16402c0053a434e61acff3a0e136a7e82d85c74f456f4c92a70a9;
    md[52] = 256'h74b23ba36cffdc0e3d88e457760c7157db667f95b6a48ba97aed7bdee95553b3;
    md[53] = 256'h25a3b8de6e93e29bbec3538bb54491cd2afee1f9bd55d4bfd1f49197920d9562;
    md[54] = 256'h8c9ffe70ccaa2305d72e46ac93a43cd512b1666fd336856c46e13b7bdb08a2e2;
    md[55] = 256'h39b3516f8d3e6c8c0e6d5ac9e0098a44d63ab6514b848de4b654805a0cfefa76;
    md[56] = 256'hbf6a8f025e49e8a64e92cd16f71773866db3bb048a05b29fb02d9846c9fbc9f5;
    md[57] = 256'h3f41fec1eb39ee06d0850353e483374e7bf34bb47febca616aaee067a28734b4;
    md[58] = 256'hbe70c51e75ca2ae611b80bbe9c1720cdc1b8250e73399296851eadedcdc4f963;
    md[59] = 256'hc00ce2788f5ab3d14a492240ea54d05bac108353a2203436d3e0701c1b088262;
    md[60] = 256'h26e5b345b7f8efd7d91ddc6ed602646450bedd3f6b20d77de02beb327be2d9bb;
    md[61] = 256'h6978ad4035a5180a0781c656482fecbe7b9f1c430672b2135448148185a40e36;
    md[62] = 256'h5b542f6a1e761632b3b48c2c40972f64ab0c5b80c0057e3cf9924324456f6d31;
    md[63] = 256'hebc7da12bdfd0dd2d6fd09babcaf3ab9626a5ccb2e9a4f492dd15652fd2771f3;
    md[64] = 256'h5db04d00d3dfd9be76b2c9694f6d5d8e720c5c79b29729e0c1631747c2cb9988;
    md[65] = 256'hb2788851c73b8c368e7f44e832e2913004a66131216da5ea0b12a1efe30f8979;
    md[66] = 256'h667e4498275bdb7701883d22dc988e86aa419d8475329e199238d2121f819d28;
    md[67] = 256'h6cad7e7563819f1a24269e3f031795185ce013d48e8fe3f9dee2a6f9e690c490;
    md[68] = 256'h5224ec473d778622c13d93d285cab5704442ab6d8e8a5b93f272cd1018973951;
    md[69] = 256'hef3896defc3f927251b4c790ce8f43e12a7ae465de5ee1db48c1ab7248978a16;
    md[70] = 256'hd3849407870aaf0fb2c49562e55da86557ad883dc0e96f9677e23658643c7a44;
    md[71] = 256'hfff968a20003fa69db3d10122c0ebca2cdfb6b39a32051bddd192f41d8636506;
    md[72] = 256'ha8c43a4c99884c145f133adbc2ee69ebe7a78baf43ad58335452284c334a1889;
    md[73] = 256'hd6ed4ac4975a0a990c4e58f5bddb28136967f935800a94c223582480142fd889;
    md[74] = 256'h1f7644067012e64b7869d12b8ccd1f2d3a56bb3e872a138cc46ecefa7e59fd75;
    md[75] = 256'h9e07c3aeda2c5a411ab7db4033e6d3e8637aa14373ed26daf8db20b41f986af0;
    md[76] = 256'h09ef93fa940101e661b671957de823f08268a7475d3ac6e09316ada01adb75fc;
    md[77] = 256'h8fd9f1b5b9d50ad1498d09306eafb4409e374c51b5e84901ee6650f0eb35a137;
    md[78] = 256'h70674b941ea3fb733e8582948ae87c1ab47a0f6f3d7789399a6249bd45dc64da;
    md[79] = 256'h93778d9f385f055b656638025cb6efb2f3f026e01c5af80ac02f8358f578a3fc;
    md[80] = 256'hc088ca1d2ec6ac466cec58fb1e8bfbaaa6909c5ce72c3de1b94b18405c4fce90;
    md[81] = 256'h86e02620845de786fa19b92d7bd2b94a5e38972ca731496645bd3123faf44019;
    md[82] = 256'hb14fdb5df8e85263cfb82738f07dcfa3de5a76c9780bc67146d143bc94e8d17a;
    md[83] = 256'h4b18899eb0e52fc7513251853b30d8bf17e772e469cae4a5a891660c585e208e;
    md[84] = 256'h136dfe4353b42990906254b9215934c2569c5f31a6a25edccc896c6feda3bc0f;
    md[85] = 256'h364ea962632ded4a9fa91fcd873c415bd5ec87ff80c688f23fbd5ec940fb44d9;
    md[86] = 256'h90e2711334bdcea7778f296dfb7128c67c475863114f26747bab2abd4b7c67d7;
    md[87] = 256'h641d974f46a605c7f806194206c671dc1e865386241e296228a8a70c58df122c;
    md[88] = 256'h1a4e32585da9eddc7a6c05ee632587f6f7e5c269eda63f6bb67d662175e8ecbe;
    md[89] = 256'h28150a432ffdc9bf6891a069153f1fffeb4515864713d1a01c2adce17d51d400;
    md[90] = 256'h0bd9a7f5c0d89f7542013e323848442ada3a2b871d481188eb5bc060aeb82455;
    md[91] = 256'hb5797704dc1f661de1eefe865a42fb50809cd41ea7560770ddddb9f06427908d;
    md[92] = 256'h6af71d9d6485d0fc51e91c2c226e365b8c981efd9c1bbbe1bd8da297f15aad3f;
    md[93] = 256'hc4b16828582f18fc90e06e3c9dbb4cf27e8a9b667f248e0a4578d68b8e0c3b3e;
    md[94] = 256'ha2911ec65759af2381fbaf933b122f2cfc8a2f5bf65400742264189cdb684e41;
    md[95] = 256'hda068cc480e629e65dca9c77c62465f8531ca8ab8d4b538cde556619113a6589;
    md[96] = 256'hb7c3a05dae2e7c5c046020e133ed5647f87d714a22c2a9bde947fbe2dc805c16;
    md[97] = 256'ha9da515a8324f3084b2b704148f0c529262d3a96d8dd9713cec21af5853d2583;
    md[98] = 256'hd202a76db6797ba1b6d3a01890d91305c84a27f7b3469e97692597caaffe246e;
    md[99] = 256'h456f2ed7f5433bb4e56d7780a21a953e95d6a5eb53bb4c974c57a90e677f3197;

  end
  
//Start the test   
  initial 
  begin
    tb.rst_dev(20);
    tb.num_inputs = 1;
    tb.max_done = 'd0;
    tb.perf_match = 1;
  
/******************************************************************************
   Test vectors for HASH generation 
   SHA3-256 Monte Carlo, Seed = aa64f7245e2177c654eb4de360da8761a516fdc7578c3498c5e582e096b8730c
*******************************************************************************/  

    msg = 256'haa64f7245e2177c654eb4de360da8761a516fdc7578c3498c5e582e096b8730c;
    vec_num = 0;

    for (vec_num = 0; vec_num < 100; vec_num = vec_num + 1)
    begin
      for (inner = 1; inner <= 1000; inner = inner + 1)
      begin
        tb.max_done = tb.max_done+1;
        if (inner == 1000)
        begin
          tb.perf_match = 1;
          tb.expected_value = md[vec_num];
        end
        else
          tb.perf_match = 0;
        // 32-byte message + SHA3 pad10*1 (0x06 ... 0x80) in one 1088-bit rate block
        sin = {64'h8000_0000_0000_0000, {11{64'h0000_0000_0000_0000}}, 64'h0000_0000_0000_0006, byte_rev256(msg)};
        tb.send_word(1'b1, 1'b1, sin);
        wait (tb.digest_valid)
        @(posedge tb.clk);
        msg = tb.digest;
      end
      $display($time, "\tVector %d Finished", vec_num);
    end

   end //initial
   
endmodule //test4
