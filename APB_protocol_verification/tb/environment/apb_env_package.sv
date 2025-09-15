package apb_env_package;

`include "uvm_macros.svh"
import uvm_pkg :: *;

import apb_agent_package ::*;
export apb_agent_package :: apb_agent_config;		//to be used in base test
export apb_agent_package :: apb_sequencer;			//to be used in base test

`include "apb_scoreboard.sv"
`include "apb_env_config.sv"
`include "apb_environment.sv"


endpackage
