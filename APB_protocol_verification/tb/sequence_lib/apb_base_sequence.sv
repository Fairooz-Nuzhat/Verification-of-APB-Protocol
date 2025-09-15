class apb_base_sequence extends uvm_sequence;
  `uvm_object_utils(apb_base_sequence)

  bit [`ADDR_WIDTH - 1:0] addr;
  bit [`DATA_WIDTH - 1:0] data;
  bit data_flag;

  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction 

  task body();

  endtask 

endclass
