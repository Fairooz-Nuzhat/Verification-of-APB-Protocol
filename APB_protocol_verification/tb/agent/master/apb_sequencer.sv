class apb_sequencer extends uvm_sequencer #(apb_sequence_item);
  `uvm_component_utils(apb_sequencer)

  function new(string name = "apb_sequencer", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),"build phase has started",UVM_HIGH)
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(),"connect phase has started",UVM_HIGH)
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_full_name(),"run phase has started",UVM_HIGH)
  endtask

endclass
