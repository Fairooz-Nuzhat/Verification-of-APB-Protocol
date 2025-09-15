class apb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(apb_scoreboard)

    apb_sequence_item apb_captured_item;
    uvm_analysis_imp #(apb_sequence_item,apb_scoreboard) apb_mntr2scb_imp;

    bit [`DATA_WIDTH-1:0] apb_expected_mem [bit [`ADDR_WIDTH-1:0]];    
    int pass = 0;
    int fail = 0;

    function new(string name = "apb_scoreboard", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(),"build phase has started",UVM_HIGH)
        apb_mntr2scb_imp = new("apb_mntr2scb_imp",this);
    endfunction

    function void write(apb_sequence_item apb_captured_item);
        `uvm_info(get_full_name(),"starting apb_write_func",UVM_HIGH)
        if (apb_captured_item.PRESETn === 0) begin
            apb_expected_mem.delete();
            `uvm_info("SCB_RESET","Reset is done in Scoreboard",UVM_HIGH)
        end
        else begin
            if (apb_captured_item.PWRITE === 1) begin
                apb_expected_mem[apb_captured_item.PADDR] = apb_captured_item.PWDATA;    
               `uvm_info("SCB_WRITE","STORING EXPECTED VALUE",UVM_HIGH)
            end
            else begin
                compare_read(apb_captured_item);    
            end
        end
    endfunction

    function void compare_read(apb_sequence_item apb_captured_item);
        `uvm_info("SCB_COMPARE","Comparing",UVM_HIGH)
        if (apb_expected_mem.exists(apb_captured_item.PADDR)) begin
            if (apb_captured_item.PRDATA !== apb_expected_mem[apb_captured_item.PADDR]) begin
                `uvm_error("READ_MISMATCH", $sformatf("Failed reading: PADDR = %0h: Expected PRDATA = %0h, got %0h", apb_captured_item.PADDR, apb_expected_mem[apb_captured_item.PADDR], apb_captured_item.PRDATA))
                fail++;
            end
            else begin
                `uvm_info("PASS",$sformatf("Passed reading: PADDR = %0h: Expected PRDATA = %0h, got = %0h", apb_captured_item.PADDR, apb_expected_mem[apb_captured_item.PADDR], apb_captured_item.PRDATA),UVM_NONE)
                pass++;
            end
        end
        else begin
            if (apb_captured_item.PRDATA !== 0) begin
                `uvm_error("DEFAULT_READ_FAIL", $sformatf("Failed reading: PADDR = %0h: Expected PRDATA = 0, got = %0h", apb_captured_item.PADDR, apb_captured_item.PRDATA))
                fail++;
            end
            else begin
                `uvm_info("DEFAULT_READ_PASS",$sformatf("Passed reading: PADDR = %0h: Expected PRDATA = 0, got %0h", apb_captured_item.PADDR, apb_captured_item.PRDATA),UVM_NONE)
                pass++;
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_full_name(),"#########################################################",UVM_NONE)
        `uvm_info("SCOREBOARD TEST SUMMARY",$sformatf("Total APB passed tests: %0d, Total APB failed tests: %0d",pass,fail),UVM_NONE)
    endfunction
endclass

