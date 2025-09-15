class apb_read_sequence extends apb_base_sequence;
  `uvm_object_utils(apb_read_sequence)

  function new(string name = "apb_read_seq");
    super.new(name);
  endfunction 

  task body();
    apb_sequence_item apb_seq_item;
    apb_seq_item = apb_sequence_item :: type_id :: create("apb_seq_item");

    start_item(apb_seq_item);
    `uvm_info(get_full_name(),"apb_read_seq item started",UVM_HIGH)

    if (!(apb_seq_item.randomize() with {apb_seq_item.PWRITE == 0;
                                         apb_seq_item.PSELx == 1;
                                         apb_seq_item.PENABLE == 0;
                                         apb_seq_item.PADDR == addr;})) begin
      `uvm_error(get_full_name(), "Randomization for read sequence failed")
    end
    else begin 
      `uvm_info(get_full_name(),"Randomization for read sequence succeed",UVM_HIGH)
    end
    finish_item(apb_seq_item);
    `uvm_info(get_full_name(),"seq item task finished",UVM_HIGH)
  endtask

endclass

