/********************************************************************************************************************************
This confidential and proprietary software may be used only as authorized by a licensing agreement from Ulkasemi Pvt Ltd.
In the event of publication, the following notice is applicable:
(C)COPYRIGHT 2007 Ulkasemi Pvt Ltd.
ALL RIGHTS RESERVED
The entire notice above must be reproduced on all authorized copies.
*********************************************************************************************************************************/

module apb_sub_memory #(
  APB_DATA_WIDTH = 32,
  APB_ADDR_WIDTH = 8
)
(
  // APB signals from/to manager
  input logic pclk,                                          // APB clock
  input logic preset_b,                                      // APB reset
  input logic [APB_ADDR_WIDTH - 1 : 0] paddr,                // APB address
  input logic pwrite,                                        // write signal, 0 for read, 1 for write
  input logic psel,                                          // sub select signal
  input logic penable,                                       // enable signal during read or write access of manager
  input logic [APB_DATA_WIDTH - 1 : 0] pwdata,               // write data provided by apb manager

  output logic pready,                                       // required if transfer extension is necessary by the sub
  output logic [APB_DATA_WIDTH - 1 : 0] prdata,              //  read data provided by the sub
 
  input logic apb_sub_flop_en
);

`pragma protect begin_protected
`pragma protect encrypt_agent="NCPROTECT"
`pragma protect encrypt_agent_info="ncprotect	15.20-s086	 Oct 08, 2024 at 15:03:44 +06"
`pragma protect data_keyowner="Cadence Design Systems."
`pragma protect data_keyname="CDS_DATA_KEY"
`pragma protect data_method="AES256-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 3600)
`pragma protect data_block
H[CJ<\@a][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
WyP/020kqEXFo2Fjgby+SQeqXTi0


`pragma protect end_protected
endmodule


