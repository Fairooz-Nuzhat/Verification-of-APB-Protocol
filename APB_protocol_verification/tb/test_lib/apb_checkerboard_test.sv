class apb_checkerboard_test extends apb_base_test;
    `uvm_component_utils(apb_checkerboard_test)

    function new(string name = "apb_checkerboard_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name,"run phase has started",UVM_HIGH)

        phase.raise_objection(this);
        begin
            apb_reset();
            for (int i=0; i<2**`ADDR_WIDTH;i++) begin
                if (i%2 == 0) apb_write_data(i,`DATA_WIDTH'hAAAAAAAA,1);
                else apb_write_data(i,`DATA_WIDTH'h0,1);    //writes patterned data
            end
            for (int i=0; i<2**`ADDR_WIDTH;i++) begin
                apb_read(i);
            end

            apb_reset();
            for (int i=0; i<2**`ADDR_WIDTH;i++) begin
                if (i%2 != 0) apb_write_data(i,`DATA_WIDTH'hAAAAAAAA,1);   //writes patterned data
                else apb_write_data(i,`DATA_WIDTH'h0,1);        //writes patterned data
            end
            for (int i=0; i<2**`ADDR_WIDTH;i++) begin
                apb_read(i);
            end  
        end
        phase.drop_objection(this);
    endtask

endclass
