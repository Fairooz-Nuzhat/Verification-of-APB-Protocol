class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

  apb_agent_config apb_agent_cfg;
  apb_monitor apb_mntr;
  apb_driver apb_drvr;
  apb_sequencer apb_seq_er;
  apb_coverage apb_cov;

  virtual apb_interface apb_vif;

  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),"build phase has started",UVM_HIGH);      

    //receiving configs from environment
    if (!uvm_config_db #(apb_agent_config):: get(this,"","apb_agent_config",apb_agent_cfg)) begin
      `uvm_fatal(get_full_name(), "unable to get agent_config from environment")
    end
    else begin
      `uvm_info(get_full_name(),"Configs received from apb2spi env",UVM_HIGH)
    end
    //checking if agent is active or passive
    if (apb_agent_cfg.agent_state == UVM_ACTIVE) begin  
      //if active then create driver and sequencer
      apb_drvr = apb_driver :: type_id :: create("apb_drvr",this);
      apb_seq_er = apb_sequencer :: type_id :: create("apb_seq_er",this);
    end
    else begin
      `uvm_info(get_full_name(),"APB agent is passive",UVM_HIGH)
    end
    //create monitor for both active or passive agents
    apb_mntr = apb_monitor :: type_id :: create("apb_mntr",this);
    //create coverage if required
    if (apb_agent_cfg.has_apb_cov == 1)  begin 
      apb_cov = apb_coverage :: type_id :: create("apb_cov",this);
    end
    //interface can be received here from tb_top and then assign them to monitor and driver interfaces
    if(!uvm_config_db #(virtual apb_interface) :: get (this,"","apb_vif",apb_vif)) begin
      `uvm_error(get_full_name(), "unable to get interface from tb_top to APB driver")
    end
    //assigning to monitor and driver
    apb_drvr.apb_vif = apb_vif;
    apb_mntr.apb_vif = apb_vif;

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_full_name(),"connect phase has started",UVM_HIGH)
    if (apb_agent_cfg.agent_state == UVM_ACTIVE) begin
      //connecting from driver to sequencer
      apb_drvr.seq_item_port.connect(apb_seq_er.seq_item_export);
      `uvm_info(get_full_name(),"Connection done from driver to sequencer",UVM_HIGH)
    end
    if (apb_agent_cfg.has_apb_cov == 1) begin
      apb_mntr.apb_mntr2cov_port.connect(apb_cov.apb_mntr2cov_imp);  
      `uvm_info(get_full_name(),"monitor coverage connection done",UVM_HIGH)
    end
  endfunction

endclass
