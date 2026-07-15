`include "define.sv"
class apb_ip_monitor;
apb_transaction apb_ip_mon;
mailbox #(apb_transaction) mb_ims;
virtual apb_if.IP_MON ip_vif;
covergroup ip_mon_cg;
	paddr_cp : coverpoint apb_ip_mon.PADDR { bins low = {[0:64]};  bins mid = {[65:128]};  bins high = {[129:255]}; bins invalid = {[`MEM_DEPTH : 2**(`ADDR_WIDTH) - 1]}; }
	psel_cp : coverpoint apb_ip_mon.PSEL { bins b[] = {0,1}; }
	penable_cp : coverpoint apb_ip_mon.PENABLE { bins c[] = {0,1}; }
	pwrite_cp : coverpoint apb_ip_mon.PWRITE { bins d[] = {0,1}; }
	pwdata_cp : coverpoint apb_ip_mon.PWDATA { bins e = {[0:2**(`DATA_WIDTH) - 1]}; }
	pstrb_cp : coverpoint apb_ip_mon.PSTRB {bins byte_1 = {1,2,4,8}; bins byte_2 = {3,5,6,9,10,12}; bins byte_4 = {0,15}; bins byte_3 = {7,11,13,14};
	}
	psel_x_penable : cross psel_cp, penable_cp;
	pwrite_x_pstrb : cross pwrite_cp, pstrb_cp;
	paddr_x_pwrite : cross paddr_cp, pwrite_cp;
endgroup
function new (virtual apb_if.IP_MON ip_vif,mailbox #(apb_transaction) mb_ims);
	this.ip_vif = ip_vif;
	this.mb_ims = mb_ims;
	ip_mon_cg = new();
endfunction
task start();
	repeat(4) @(ip_vif.ip_mon_cb);
	for(int i = 0; i < `num_trans; i++)
	begin
		apb_ip_mon = new();
		repeat(1) @(ip_vif.ip_mon_cb)
		begin
			apb_ip_mon.PADDR = ip_vif.ip_mon_cb.PADDR;
			apb_ip_mon.PSEL = ip_vif.ip_mon_cb.PSEL;
			apb_ip_mon.PENABLE = ip_vif.ip_mon_cb.PENABLE;
			apb_ip_mon.PWRITE = ip_vif.ip_mon_cb.PWRITE;
			apb_ip_mon.PWDATA = ip_vif.ip_mon_cb.PWDATA;
			apb_ip_mon.PSTRB = ip_vif.ip_mon_cb.PSTRB;
		end
		$display("INPUT MONITOR \t PADDR = %0d  PSEL = %b  PENABLE = %b  PWRITE = %b  PWDATA = %0d  PSTRB = %0d",apb_ip_mon.PADDR, apb_ip_mon.PSEL, apb_ip_mon.PENABLE, apb_ip_mon.PWRITE, apb_ip_mon.PWDATA, apb_ip_mon.PSTRB);
		mb_ims.put(apb_ip_mon);
		ip_mon_cg.sample();
		repeat(1) @(ip_vif.ip_mon_cb);
	end
endtask
endclass
