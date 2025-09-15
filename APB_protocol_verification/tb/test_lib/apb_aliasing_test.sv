class apb_aliasing_test extends apb_base_test;
    `uvm_component_utils(apb_aliasing_test)

    function new(string name = "apb_aliasing_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name,"run phase has started",UVM_HIGH)

        phase.raise_objection(this);
        begin
            apb_reset();
            for (int i=0; i<2**`ADDR_WIDTH; i++) begin
                apb_write_data(i,`DATA_WIDTH'h0,1);
            end
            for (int j=0; j<2**`ADDR_WIDTH; j++) begin
                apb_write(j,0);
                apb_read(j);
                if (j == 2**`ADDR_WIDTH-1) apb_read(0);
                else apb_read(j+1);
                if (j == 0) apb_read(2**`ADDR_WIDTH-1);
                else apb_read(j-1);    
            end
        end
        phase.drop_objection(this);
    endtask

endclass
