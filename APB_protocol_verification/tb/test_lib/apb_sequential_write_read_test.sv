class apb_sequential_write_read_test extends apb_base_test;
    `uvm_component_utils(apb_sequential_write_read_test)

    function new(string name = "apb_seq_write_read_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name,"run phase has started",UVM_HIGH)

        phase.raise_objection(this);
        begin
            apb_reset();
            for (int i=0; i<2**`ADDR_WIDTH; i++) begin
                apb_write(i,0);         //write data is randomized
                apb_read(i);
            end
        end
        phase.drop_objection(this);
    endtask

endclass
