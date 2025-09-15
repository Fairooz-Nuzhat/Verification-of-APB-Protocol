class apb_driver extends uvm_driver #(apb_sequence_item);
    `uvm_component_utils(apb_driver)

    virtual apb_interface apb_vif;
    apb_sequence_item apb_seq_item;

        function new(string name = "apb_driver", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            `uvm_info(get_name(),"build phase has started",UVM_HIGH)
            // if (!uvm_config_db #(virtual apb_interface):: get(this,"","apb_vif",apb_vif)) 
            //     `uvm_fatal(get_name(), "unable to get interface from driver")
        endfunction

        task run_phase(uvm_phase phase);
            `uvm_info(get_name(),"run phase has started",UVM_HIGH)
            forever begin
                `uvm_info(get_name(),"waiting for item from APB sequencer",UVM_DEBUG)
                seq_item_port.get_next_item(apb_seq_item);
                if(apb_seq_item.PRESETn === 0) reset();
                else drive(apb_seq_item);         
                seq_item_port.item_done(apb_seq_item);
                `uvm_info(get_name(),"item is received from APB sequencer",UVM_DEBUG)
            end
        endtask

    task reset();
        apb_vif.PRESETn <= 1'b0;
        apb_vif.PSELx <= 1'b0;
        apb_vif.PENABLE <= 1'b0;
        apb_vif.PWRITE <= 1'b0;
        apb_vif.PADDR <= `ADDR_WIDTH'b0;
        apb_vif.PWDATA <= `DATA_WIDTH'b0; 
        @(negedge apb_vif.clk);  
        apb_vif.PRESETn <= 1'b1;
        // @(negedge apb_vif.clk);
    endtask

    task drive(apb_sequence_item apb_seq_item);
        apb_vif.PSELx <= 1'b1;
        apb_vif.PENABLE <= 1'b0;
        apb_vif.PWRITE <= apb_seq_item.PWRITE;
        apb_vif.PADDR <= apb_seq_item.PADDR;
        if (apb_seq_item.PWRITE === 1) begin     
            apb_vif.PWDATA <= apb_seq_item.PWDATA;   
        end
        @(negedge apb_vif.clk);
        apb_vif.PENABLE <= 1'b1; 
        do begin
            @(negedge apb_vif.clk);
        end 
        while(apb_vif.PREADY === 0);
        apb_vif.PSELx <= 1'b0;
        apb_vif.PENABLE <= 1'b0;
    endtask

endclass
