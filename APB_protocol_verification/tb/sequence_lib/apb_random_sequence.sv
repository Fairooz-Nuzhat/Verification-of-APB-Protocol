class apb_random_sequence extends apb_base_sequence;
  `uvm_object_utils(apb_random_sequence)

  function new(string name = "apb_random_seq");
    super.new(name);
  endfunction 

  task body();
    apb_sequence_item apb_seq_item;
    apb_seq_item = apb_sequence_item :: type_id :: create("apb_seq_item");

        start_item(apb_seq_item);
        `uvm_info(get_full_name(),"apb_random_seq item started",UVM_HIGH)
        if (!(apb_seq_item.randomize() with {apb_seq_item.PSELx == 1; 
                                         apb_seq_item.PENABLE == 0;})) begin                     
            `uvm_error(get_full_name(), "Randomization for random sequence failed")
        end
        else begin 
            `uvm_info(get_full_name(),"Randomization for random sequence succeed",UVM_HIGH)
        end
    
        finish_item(apb_seq_item);
        `uvm_info(get_full_name(),"seq item task finished",UVM_HIGH)
  endtask

endclass

    
    



