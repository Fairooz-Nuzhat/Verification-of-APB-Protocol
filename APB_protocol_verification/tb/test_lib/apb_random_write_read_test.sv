class apb_random_write_read_test extends apb_base_test;
    `uvm_component_utils(apb_random_write_read_test)

    function new(string name = "apb_random_write_read_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name,"run phase has started",UVM_HIGH)

        phase.raise_objection(this);
        begin
            apb_reset();
            repeat(3000) apb_random();
        end
        phase.drop_objection(this);
    endtask

endclass
