class apb_env_config extends uvm_object;
    `uvm_object_utils(apb_env_config)

    bit has_apb_scb;
    bit has_apb_agent;
    apb_agent_config apb_agent_cfg;

    function new(string name ="apb_env_cfg");
        super.new(name);
        `uvm_info(get_full_name(),"apb_env_config created",UVM_HIGH)
    endfunction

endclass
