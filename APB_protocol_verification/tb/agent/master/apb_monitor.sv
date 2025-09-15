class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  uvm_analysis_port #(apb_sequence_item) apb_mntr2scb_port;
  uvm_analysis_port #(apb_sequence_item) apb_mntr2cov_port;

  virtual apb_interface apb_vif;

  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),"build phase has started",UVM_HIGH)
    
    apb_mntr2scb_port = new("apb_mntr2scb_port",this);
    apb_mntr2cov_port = new("apb_mntr2cov_port",this);
  endfunction

  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(),"run phase has started",UVM_HIGH)
    fork 
      mntr2cov();
      mntr2scb();
    join
  endtask

  task mntr2cov();
    apb_sequence_item apb_cov_item;
    forever begin
      apb_cov_item = apb_sequence_item :: type_id :: create("apb_cov_item");
      @(negedge apb_vif.clk);
      apb_cov_item.PRESETn = apb_vif.PRESETn;
      apb_cov_item.PSELx = apb_vif.PSELx;
      apb_cov_item.PENABLE = apb_vif.PENABLE;
      apb_cov_item.PWRITE = apb_vif.PWRITE;
      apb_cov_item.PADDR = apb_vif.PADDR;
      apb_cov_item.PWDATA = apb_vif.PWDATA;
      apb_cov_item.PRDATA = apb_vif.PRDATA;
      apb_cov_item.PREADY = apb_vif.PREADY;
      apb_mntr2cov_port.write(apb_cov_item); 
    end
  endtask

  task mntr2scb();
    apb_sequence_item apb_scb_item;
    forever begin
      apb_scb_item = apb_sequence_item :: type_id :: create("apb_scb_item");
      @(negedge apb_vif.clk);
      apb_scb_item.PRESETn = apb_vif.PRESETn;
      if (apb_vif.PRESETn === 0) begin
        apb_mntr2scb_port.write(apb_scb_item);
        `uvm_info(get_full_name(),"SENT SEQ_ITEM TO SCB",UVM_HIGH)
      end
      else begin
        if (apb_vif.PSELx === 1) begin
          if (apb_vif.PENABLE === 0) begin
            apb_scb_item.PWRITE = apb_vif.PWRITE;
            apb_scb_item.PADDR = apb_vif.PADDR;
            if (apb_vif.PWRITE === 1) begin
              apb_scb_item.PWDATA = apb_vif.PWDATA;
              // `uvm_info(get_full_name(),$sformatf(" Written on ADDR = %0h and DATA = %0h", apb_scb_item.PADDR, apb_scb_item.PWDATA),UVM_LOW)
            end
            @(negedge apb_vif.clk);
            if (apb_vif.PENABLE === 1) begin
              while (apb_vif.PREADY === 0) begin
                @(negedge apb_vif.clk);
              end
              if (apb_vif.PWRITE === 0) begin
                apb_scb_item.PRDATA = apb_vif.PRDATA;
                // `uvm_info(get_full_name(),$sformatf(" Read from ADDR = %0h and DATA = %0h", apb_scb_item.PADDR, apb_scb_item.PRDATA),UVM_LOW)
              end
              `uvm_info(get_full_name(), "SENT SEQ_ITEM TO SCB", UVM_HIGH)
              apb_mntr2scb_port.write(apb_scb_item);
            end 
            else begin
              `uvm_error("PROTOCOL VIOLATED", "PENABLE not asserted after PSELx")
            end
          end 
          else begin
            `uvm_error("PROTOCOL VIOLATED", "PENABLE should be 0 in SETUP PHASE when PSELx is 1")
          end
        end
        else begin 
          if (apb_vif.PENABLE === 0) begin
            `uvm_info("IDLE", "IN IDLE STATE", UVM_HIGH);
          end
          else begin
            `uvm_error("PROTOCOL VIOLATED", "PENABLE should be 0 when PSELx is 0") 
          end 
        end
      end
    end
  endtask


endclass