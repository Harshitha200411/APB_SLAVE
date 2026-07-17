`include "define.sv"
class apb_generator;
apb_transaction apb_gen;
mailbox #(apb_transaction) mb_gd;
function new (mailbox #(apb_transaction) mb_gd);
	this.mb_gd = mb_gd;
	apb_gen = new();
endfunction
task start();
	for(int i = 0; i < `num_trans; i++)
	begin
		assert(apb_gen.randomize() == 1)
		mb_gd.put(apb_gen.copy());
		$display("GENERATOR \t PADDR = %0d  PSEL = %b  PENABLE = %b  PWRITE = %b  PWDATA = %h  PSTRB = %0d",apb_gen.PADDR, apb_gen.PSEL, apb_gen.PENABLE, apb_gen.PWRITE, apb_gen.PWDATA, apb_gen.PSTRB,$time);
	end
endtask
endclass
