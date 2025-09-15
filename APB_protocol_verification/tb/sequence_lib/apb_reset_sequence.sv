class apb_reset_sequence extends apb_base_sequence;
  `uvm_object_utils(apb_reset_sequence)

  function new(string name = "apb_reset_seq");
    super.new(name);
  endfunction 

  task body();
    apb_sequence_item apb_seq_item;
    apb_seq_item = apb_sequence_item :: type_id :: create("apb_seq_item");

    apb_seq_item.PRESETn = 0;
    start_item(apb_seq_item);
    `uvm_info(get_full_name(),"apb_reset_seq item started",UVM_HIGH)

    if (!(apb_seq_item.randomize())) begin
      `uvm_error(get_full_name(), "Randomization for reset sequence failed")
    end
    else begin 
      `uvm_info(get_full_name(),"Randomization for reset sequence succeed",UVM_HIGH)
    end  
    `uvm_info(get_full_name(),"RESET done",UVM_HIGH)

    finish_item(apb_seq_item);
    `uvm_info(get_full_name(),"seq item task finished",UVM_HIGH)

  endtask

endclass


