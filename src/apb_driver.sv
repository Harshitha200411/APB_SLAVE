`include "define.sv"

class apb_driver;
  apb_transaction apb_drv;
  mailbox #(apb_transaction) mb_gd;
  virtual apb_if.DRV vif;

  function new(mailbox #(apb_transaction) mb_gd, virtual apb_if.DRV vif);
    this.mb_gd = mb_gd;
    this.vif   = vif;
  endfunction

  task start();
    fork
      reset_handler();
      drive();
    join_none
  endtask

  task reset_handler();
    forever begin
      @(negedge vif.PRESETn);
      vif.drv_cb.PADDR   <= 0;
      vif.drv_cb.PSEL    <= 0;
      vif.drv_cb.PENABLE <= 0;
      vif.drv_cb.PWRITE  <= 0;
      vif.drv_cb.PWDATA  <= 0;
      vif.drv_cb.PSTRB   <= 0;
      $display("DRIVER \t RESET ASSERTED \t PADDR = %0d  PSEL = %b  PENABLE = %b  PWRITE = %b  PWDATA = %h  PSTRB = %0d  TIME = %0t",
                vif.drv_cb.PADDR, vif.drv_cb.PSEL, vif.drv_cb.PENABLE, vif.drv_cb.PWRITE, vif.drv_cb.PWDATA, vif.drv_cb.PSTRB, $time);
      @(posedge vif.PRESETn);
    end
  endtask

  task drive();
    repeat(3) @(vif.drv_cb);
    for (int i = 0; i < `num_trans; i++) begin
      apb_drv = new();
      mb_gd.get(apb_drv);
      if (vif.PRESETn == 0) begin
        @(vif.drv_cb);
      end
      else begin
        @(vif.drv_cb);
        vif.drv_cb.PADDR   <= apb_drv.PADDR;
        vif.drv_cb.PSEL    <= apb_drv.PSEL;
        vif.drv_cb.PENABLE <= apb_drv.PENABLE;
        vif.drv_cb.PWRITE  <= apb_drv.PWRITE;
        vif.drv_cb.PWDATA  <= apb_drv.PWDATA;
        vif.drv_cb.PSTRB   <= apb_drv.PSTRB;
        @(vif.drv_cb);
        $display("DRIVER \t PADDR = %0d  PSEL = %b  PENABLE = %b  PWRITE = %b  PWDATA = %h  PSTRB = %0d  TIME = %0t",
                  vif.drv_cb.PADDR, vif.drv_cb.PSEL, vif.drv_cb.PENABLE, vif.drv_cb.PWRITE, vif.drv_cb.PWDATA, vif.drv_cb.PSTRB, $time);
      end
    end
  endtask
endclass
