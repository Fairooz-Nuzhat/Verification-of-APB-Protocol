`include "uvm_macros.svh"
import uvm_pkg :: *;
import apb_test_package ::*;

module tb_top;
    //clock generation
    int freq;
    int delay;

    initial begin
        freq = ($value$plusargs("FREQUENCY=%0d",freq) && freq>0) ? freq : 100;
        delay = 1000/(2*freq);
    end

    bit clk;
    always #(delay) clk = ~clk;

    apb_interface apb_vif(clk);

    //DUT instantiation
    apb_sub_memory DUT(
        .pclk(clk),
        .preset_b(apb_vif.PRESETn),
        .paddr(apb_vif.PADDR),
        .pwrite(apb_vif.PWRITE),
        .psel(apb_vif.PSELx),
        .penable(apb_vif.PENABLE),
        .pwdata(apb_vif.PWDATA),
        .pready(apb_vif.PREADY),
        .prdata(apb_vif.PRDATA),
        .apb_sub_flop_en(1'b1)
        );

    initial begin
        uvm_config_db #(virtual apb_interface):: set(null,"uvm_test_top.apb_env.apb_agnt","apb_vif",apb_vif); 
        run_test();
    end

endmodule
