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

  //internal signals required for flopping the inputs meow
  logic pwrite_q;
  logic psel_q;
  logic penable_q;
  logic pready_int;

  logic [APB_DATA_WIDTH-1 : 0] mem [2**APB_ADDR_WIDTH]; 

  logic write_enb;
  logic read_enb;
  logic [APB_DATA_WIDTH - 1 : 0] pwdata_q;
  logic [APB_ADDR_WIDTH - 1 : 0] paddr_q;

  // All flops for input and output signals
  dffr #(.FLOP_COUNT (APB_ADDR_WIDTH)) u_address_flop ( .clk ( pclk ), .reset_b ( preset_b ),.en(apb_sub_flop_en ),  .d ( paddr[APB_ADDR_WIDTH - 1 : 0] ), .q ( paddr_q[APB_ADDR_WIDTH - 1 : 0] ) );
  dffr                                 u_pwrite_flop  ( .clk ( pclk ), .reset_b ( preset_b ),.en(apb_sub_flop_en ), .d ( pwrite ), .q ( pwrite_q ) );
  dffr                                 u_psel_flop    ( .clk ( pclk ), .reset_b ( preset_b ),.en(apb_sub_flop_en ), .d ( psel ), .q ( psel_q ) );
  dffr                                 u_penable_flop ( .clk ( pclk ), .reset_b ( preset_b ),.en(apb_sub_flop_en ), .d ( penable ), .q ( penable_q ) );
  dffr #(.FLOP_COUNT (APB_DATA_WIDTH)) u_pwdata_flop  ( .clk ( pclk ), .reset_b ( preset_b ),.en(apb_sub_flop_en ), .d ( pwdata[APB_DATA_WIDTH - 1 : 0] ), .q ( pwdata_q[APB_DATA_WIDTH - 1 : 0] ) );
  dffr                                 u_pready_flop  ( .clk ( pclk ), .reset_b ( preset_b ),.en(apb_sub_flop_en ), .d ( pready_int ), .q ( pready ) );

  //read and write enable logic 
  assign write_enb = psel_q & ~penable_q & pwrite_q;
  assign read_enb =  psel_q & ~penable_q & ~pwrite_q;
 
  //pready logic --> it will cause 1 wait state for both write and read 
  assign pready_int = psel_q & ~penable_q; 

//  +-----------------------+
//  |     Memory Module     |
//  +-----------------------+

  always @(posedge pclk ) begin
    if (write_enb)
      mem[paddr_q] <= pwdata_q;
    else
      mem[paddr_q] <= mem[paddr_q];
  end

  always @(posedge pclk ) begin
    if(read_enb)
      prdata <= mem[paddr_q];
    else
      prdata <= 'b0;
  end
endmodule

module dffr #(
    parameter FLOP_COUNT = 1
)
(
    input                           clk,
    input                           reset_b,
    input                           en,
    input  logic [FLOP_COUNT - 1:0] d,
    
    output logic [FLOP_COUNT - 1:0] q
);

    always @ (posedge clk or negedge reset_b)
    begin
        if(~reset_b)
            begin
            q[FLOP_COUNT - 1:0] <= 'b0;
            end
        else
            begin  
            q[FLOP_COUNT - 1:0] <= en? d [FLOP_COUNT - 1:0] : q [FLOP_COUNT - 1 :0];
            end
    end

endmodule


