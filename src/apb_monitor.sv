`include "define.sv"
class apb_monitor;
apb_transaction apb_mon;
mailbox #(apb_transaction) mb_ms;
virtual apb_if.MON vif;
covergroup mon_cg;
	prdata_cp : coverpoint apb_mon.PRDATA { bins a1 = {[0:2**(`DATA_WIDTH) - 1]}; }
	pready_cp : coverpoint apb_mon.PREADY { bins b = {1}; }
	pslverr_cp : coverpoint apb_mon.PSLVERR { bins c[] = {0,1}; }
endgroup
function new (virtual apb_if.MON vif, mailbox #(apb_transaction) mb_ms);
	this.vif = vif;
	this.mb_ms = mb_ms;
	mon_cg = new();
endfunction 
task start();
	repeat(5) @(vif.mon_cb);
	for(int i = 0; i < `num_trans; i++)
	begin
		apb_mon = new();
		repeat(1) @(vif.mon_cb)
		begin
			apb_mon.PRDATA = vif.mon_cb.PRDATA;
			apb_mon.PREADY = vif.mon_cb.PREADY;
			apb_mon.PSLVERR = vif.mon_cb.PSLVERR;
		end
		$display("OUTPUT MONITOR \t PRDATA = %h PREADY = %b PSLVERR = %b",apb_mon.PRDATA, apb_mon.PREADY, apb_mon.PSLVERR);
		mb_ms.put(apb_mon);
		mon_cg.sample();
		repeat(1) @(vif.mon_cb);
	end
endtask
endclass
		
			 
	
