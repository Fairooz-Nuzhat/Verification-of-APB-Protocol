class apb_reset_test extends apb_base_test;
    `uvm_component_utils(apb_reset_test)

    function new(string name = "apb_reset_test", uvm_component parent = null);
    super.new(name,parent);
    `uvm_info(get_full_name(),"apb_reset_test is created",UVM_HIGH)
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_name,"run phase has started",UVM_HIGH)
    phase.raise_objection(this);
    begin
      apb_reset();
        for (int i=0; i<2**5; i++) begin
            apb_read(i);
        end
    end
    phase.drop_objection(this);
  endtask

endclass