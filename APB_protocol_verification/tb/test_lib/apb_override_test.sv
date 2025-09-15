class apb_override_test extends apb_base_test;
    `uvm_component_utils(apb_override_test)

    function new(string name = "apb_override_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name,"run phase has started",UVM_HIGH)

        phase.raise_objection(this);
        begin
            apb_reset();
            for (int i=0; i<2**`ADDR_WIDTH; i++) begin
                repeat(3) apb_write(i,0);      //random data write
                apb_read(i);
            end
        end
        phase.drop_objection(this);
    endtask

endclass
