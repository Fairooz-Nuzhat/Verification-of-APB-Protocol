class apb_walking_test extends apb_base_test;
    `uvm_component_utils(apb_walking_test)

    function new(string name = "apb_walking_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name,"run phase has started",UVM_HIGH)

        phase.raise_objection(this);
        begin
            apb_reset();
            for (int i=0; i<2**`ADDR_WIDTH; i++) begin       
                bit [`DATA_WIDTH-1:0] mem_data = `DATA_WIDTH'h1;
                for(int j=0; j<`DATA_WIDTH; j++) begin
                    apb_write_data(i,mem_data,1);       //patterned data is sent instead of random one
                    apb_read(i);
                    mem_data = mem_data << 1;
                end
            end

            apb_reset(); 
            for (int i=0; i<2**`ADDR_WIDTH; i++) begin
                apb_write_data(i,`DATA_WIDTH'hFFFFFFFF,1);
                apb_read(i);
            end
            for (int i=0; i<2**`ADDR_WIDTH; i++) begin    
                bit [`DATA_WIDTH-1:0] mem_data = `DATA_WIDTH'hFFFFFFFF;
                for(int j=0; j<`DATA_WIDTH; j++) begin
                    mem_data[j] = 0;
                    apb_write_data(i,mem_data,1);       //patterned data is sent instead of random one
                    apb_read(i);
                    mem_data[j] = 1;
                end
            end 
        end
        phase.drop_objection(this);
    endtask

endclass
