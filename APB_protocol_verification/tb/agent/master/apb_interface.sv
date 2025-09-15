interface apb_interface (input wire clk);

    logic PRESETn;
    logic PSELx;
    logic PENABLE;
    logic PWRITE;
    logic [`DATA_WIDTH-1:0] PWDATA; 
    logic [`ADDR_WIDTH-1:0] PADDR;

    logic PREADY;
    logic [`DATA_WIDTH-1:0] PRDATA;  

endinterface
