class apb_coverage extends uvm_subscriber #(apb_sequence_item);
  `uvm_component_utils(apb_coverage)
  uvm_analysis_imp #(apb_sequence_item,apb_coverage) apb_mntr2cov_imp;
  apb_sequence_item apb_seq_item;

  covergroup cg;
    RESET: coverpoint apb_seq_item.PRESETn {
      bins ACTIVE = {0};
      bins INACTIVE = {1};
    }
    SELECT: coverpoint apb_seq_item.PSELx {
      bins DESELECTED = {0};
      bins SELECTED = {1};
    }
    ENABLE: coverpoint apb_seq_item.PENABLE {
      bins DISABLED = {0};
      bins ENABLED = {1};
    }
    OPERATION: coverpoint apb_seq_item.PWRITE {
      bins READ = {0};
      bins WRITE = {1};
    }
    ADDRESS: coverpoint apb_seq_item.PADDR {
      bins BOUNDARY[] = {`ADDR_WIDTH'h0, `ADDR_WIDTH'hFF};
      bins NIBBLE[] = {[`ADDR_WIDTH'h1 :`ADDR_WIDTH'hF]};
      bins BYTE[] = {[`ADDR_WIDTH'h10 :`ADDR_WIDTH'hFE]};
    }
    WRITE_DATA: coverpoint apb_seq_item.PWDATA{
      bins BOUNDARY[] = {`DATA_WIDTH'h0, `DATA_WIDTH'hFFFFFFFF};
      bins LOW = {[`DATA_WIDTH'h1 : `DATA_WIDTH'h3FFFFFFF]};
      bins LOWER_MID = {[`DATA_WIDTH'h40000000 : `DATA_WIDTH'h7FFFFFFF]};
      bins UPPER_MID = {[`DATA_WIDTH'h80000000 : `DATA_WIDTH'hBFFFFFFF]};
      bins HIGH = {[`DATA_WIDTH'hC0000000 : `DATA_WIDTH'hFFFFFFFE]};
    }
    READ_DATA: coverpoint apb_seq_item.PRDATA{
      bins BOUNDARY[] = {`DATA_WIDTH'h0, `DATA_WIDTH'hFFFFFFFF};
      bins LOW = {[`DATA_WIDTH'h1 : `DATA_WIDTH'h3FFFFFFF]};
      bins LOWER_MID = {[`DATA_WIDTH'h40000000 : `DATA_WIDTH'h7FFFFFFF]};
      bins UPPER_MID = {[`DATA_WIDTH'h80000000 : `DATA_WIDTH'hBFFFFFFF]};
      bins HIGH = {[`DATA_WIDTH'hC0000000 : `DATA_WIDTH'hFFFFFFFE]};
    }
    PREADY: coverpoint apb_seq_item.PREADY{
      bins ZERO = {0};
      bins ONE = {1};
    }

    WRITE: cross RESET,SELECT,ENABLE,OPERATION,PREADY,ADDRESS {
      ignore_bins b1 = binsof(RESET.ACTIVE);
      ignore_bins b2 = binsof(SELECT.DESELECTED);
      ignore_bins b3 = binsof(ENABLE.DISABLED);
      ignore_bins b4 = binsof(OPERATION.READ);
      ignore_bins b5 = binsof(PREADY.ZERO);
    }

    READ: cross RESET,SELECT,ENABLE,OPERATION,PREADY,ADDRESS {
      ignore_bins b1 = binsof(RESET.ACTIVE);
      ignore_bins b2 = binsof(SELECT.DESELECTED);
      ignore_bins b3 = binsof(ENABLE.DISABLED);
      ignore_bins b4 = binsof(OPERATION.WRITE);
      ignore_bins b5 = binsof(PREADY.ZERO);
    }

    STATE: cross RESET,SELECT,ENABLE {
      ignore_bins b1 = binsof(RESET.ACTIVE);
      ignore_bins b2 = binsof(SELECT.DESELECTED) && binsof(ENABLE.ENABLED);   
      bins IDLE = binsof(SELECT.DESELECTED) && binsof(ENABLE.DISABLED);
      bins SETUP = binsof(SELECT.SELECTED) && binsof(ENABLE.DISABLED);
      bins ACCESS = binsof(SELECT.SELECTED) && binsof(ENABLE.ENABLED);
    }
  endgroup

  function new(string name = "apb_coverage", uvm_component parent = null);
    super.new(name,parent);
    apb_mntr2cov_imp = new("apb_mntr2cov_imp",this);
    cg = new();
  endfunction

  function void write(apb_sequence_item t);   
    apb_seq_item = t;
    cg.sample();
  endfunction

endclass
