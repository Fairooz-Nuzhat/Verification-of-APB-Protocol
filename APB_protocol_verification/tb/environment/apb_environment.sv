class apb_environment extends uvm_env;
    `uvm_component_utils(apb_environment)

    apb_env_config apb_env_cfg;
    apb_agent_config apb_agent_cfg;
    apb_scoreboard apb_scb;
    apb_agent apb_agnt;

        function new(string name = "apb_environment", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            `uvm_info(get_full_name(),"build phase has started",UVM_HIGH)
            if (!uvm_config_db #(apb_env_config):: get(this,"","apb_env_config",apb_env_cfg)) begin
                `uvm_fatal(get_name(), "unable to get apb_env_config from base test")
            end
            if (apb_env_cfg.has_apb_scb == 1) begin
                apb_scb = apb_scoreboard :: type_id :: create("apb_scb",this); 
            end
            else begin
                `uvm_info(get_full_name(),"APB scoreboard not required",UVM_HIGH)
            end
            if (apb_env_cfg.has_apb_agent) begin
                uvm_config_db #(apb_agent_config) :: set(this,"apb_agnt","apb_agent_config",apb_env_cfg.apb_agent_cfg);
                apb_agnt = apb_agent :: type_id :: create("apb_agnt",this);
            end
            else begin
                `uvm_info(get_full_name(),"APB agent not required",UVM_HIGH)
            end
        endfunction
 
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            `uvm_info(get_full_name(),"connect phase has started",UVM_HIGH)
             //connection for apb monitor to scoreboard
            if (apb_env_cfg.has_apb_scb && apb_env_cfg.has_apb_agent) begin
                apb_agnt.apb_mntr.apb_mntr2scb_port.connect(apb_scb.apb_mntr2scb_imp);
                `uvm_info(get_full_name(),"connection from APB_monitor to APB scoreboard done",UVM_HIGH)
            end
        endfunction

endclass
