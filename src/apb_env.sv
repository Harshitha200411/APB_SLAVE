`include "define.sv"
class apb_env;
virtual apb_if dr_if;
virtual apb_if ip_mn_if;
virtual apb_if mn_if;
mailbox #(apb_transaction) mb_gd;
mailbox #(apb_transaction) mb_ms;
mailbox #(apb_transaction) mb_ims;
apb_generator gen;
apb_driver drv;
apb_ip_monitor ip_mon;
apb_monitor mon;
apb_scoreboard sc;
function new (virtual apb_if dr_if, virtual apb_if ip_mn_if, virtual apb_if mn_if);
	this.dr_if = dr_if;
	this.ip_mn_if = ip_mn_if;
	this.mn_if = mn_if;
endfunction
task build();
	begin
		mb_gd = new();
		mb_ms = new();
		mb_ims = new();
		gen = new(mb_gd);
		drv = new(mb_gd, dr_if);
		ip_mon = new(ip_mn_if, mb_ims);
		mon = new(mn_if, mb_ms);
		sc = new(mb_ims, mb_ms);
	end
endtask
task start();
	fork
		gen.start();
		drv.start();
		ip_mon.start();
		mon.start();
		sc.start();
	join
endtask
endclass
	
