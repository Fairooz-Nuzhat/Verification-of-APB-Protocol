class apb_base_test extends uvm_test;
    `uvm_component_utils(apb_base_test)

     apb_environment apb_env;
     apb_env_config apb_env_cfg;
     apb_agent_config apb_agent_cfg;
     apb_sequencer apb_seq_er;

    function new(string name = "apb_base_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(),"build phase has started",UVM_HIGH)

        //creating env config and then setting configurations
        apb_env_cfg = apb_env_config :: type_id :: create("apb_env_cfg");   
        apb_env_cfg.has_apb_scb = 1'b1;  
        apb_env_cfg.has_apb_agent = 1'b1;

        //if has agent, then create agent configuration, assign and set from environment to agent
        if (apb_env_cfg.has_apb_agent) begin
            apb_agent_cfg = apb_agent_config :: type_id :: create("apb_agent_cfg");
            apb_env_cfg.apb_agent_cfg = apb_agent_cfg;
            apb_agent_cfg.agent_state = UVM_ACTIVE; 
            apb_agent_cfg.has_apb_cov = 1'b1;
        end
        else begin
            `uvm_info(get_full_name(),"APB agent not required",UVM_HIGH)
        end

        //setting environment configuration to env
        uvm_config_db #(apb_env_config) :: set(this,"apb_env","apb_env_config",apb_env_cfg);
        //creating environment
        apb_env = apb_environment :: type_id :: create("apb_env",this);
    endfunction

    task apb_random();
        apb_random_sequence apb_random_seq = apb_random_sequence :: type_id :: create("apb_random_seq");
        apb_random_seq.start(apb_env.apb_agnt.apb_seq_er);
    endtask

    task apb_write(bit [`ADDR_WIDTH-1:0] addr, bit data_flag = 0);
        apb_write_sequence apb_write_seq = apb_write_sequence :: type_id :: create("apb_write_seq");
        apb_write_seq.addr = addr;
        apb_write_seq.data_flag = data_flag;
        apb_write_seq.start(apb_env.apb_agnt.apb_seq_er);
    endtask

    task apb_write_data(bit [`ADDR_WIDTH-1:0] addr, bit [`DATA_WIDTH-1:0] data, bit data_flag = 1);
        apb_write_sequence apb_write_seq = apb_write_sequence :: type_id :: create("apb_write_seq");
        apb_write_seq.addr = addr;
        apb_write_seq.data = data;
        apb_write_seq.data_flag = data_flag;
        apb_write_seq.start(apb_env.apb_agnt.apb_seq_er);
    endtask

    task apb_read(bit [`ADDR_WIDTH-1:0] addr);
        apb_read_sequence apb_read_seq = apb_read_sequence :: type_id :: create("apb_read_seq");
        apb_read_seq.addr = addr;
        apb_read_seq.start(apb_env.apb_agnt.apb_seq_er);
    endtask

    task apb_reset();
        apb_reset_sequence apb_reset_seq = apb_reset_sequence :: type_id :: create("apb_reset_seq");
        apb_reset_seq.start(apb_env.apb_agnt.apb_seq_er);
    endtask

endclass