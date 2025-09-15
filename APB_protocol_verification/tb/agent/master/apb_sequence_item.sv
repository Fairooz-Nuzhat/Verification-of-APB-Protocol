class apb_sequence_item extends uvm_sequence_item;

  logic PRESETn = 1'b1;
  rand logic PSELx;
  rand logic PENABLE;
  rand logic PWRITE;
  rand logic [`DATA_WIDTH-1:0] PWDATA; 
  rand logic [`ADDR_WIDTH-1:0] PADDR;

  logic PREADY;
  logic [`DATA_WIDTH-1:0] PRDATA;

  `uvm_object_utils_begin(apb_sequence_item)
  `uvm_field_int(PRESETn, UVM_DEFAULT)
  `uvm_field_int(PSELx, UVM_DEFAULT)
  `uvm_field_int(PENABLE, UVM_DEFAULT)
  `uvm_field_int(PWRITE, UVM_DEFAULT)
  `uvm_field_int(PWDATA, UVM_DEFAULT)
  `uvm_field_int(PADDR, UVM_DEFAULT)
  `uvm_field_int(PREADY, UVM_DEFAULT)
  `uvm_field_int(PRDATA, UVM_DEFAULT)
  `uvm_object_utils_end

  constraint c1 {PADDR inside {[`ADDR_WIDTH'h0:`ADDR_WIDTH'hFF]};}

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction 

endclass
