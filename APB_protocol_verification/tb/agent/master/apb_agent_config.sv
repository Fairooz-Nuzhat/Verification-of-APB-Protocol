class apb_agent_config extends uvm_object;
  `uvm_object_utils(apb_agent_config)

  uvm_active_passive_enum agent_state = UVM_ACTIVE;
  bit has_apb_cov;

  function new(string name = "apb_agnt_config");
    super.new(name);
    `uvm_info(get_full_name(),"APB agent_config created",UVM_HIGH)
  endfunction 

endclass
