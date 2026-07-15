`include "define.sv"
interface apb_if(input bit PCLK, PRESETn);
logic [`ADDR_WIDTH - 1 : 0] PADDR;
logic PSEL, PENABLE, PWRITE, PREADY, PSLVERR;
logic [`DATA_WIDTH - 1 : 0] PWDATA, PRDATA;
logic [(`DATA_WIDTH/8) - 1 : 0] PSTRB;

clocking drv_cb @(posedge PCLK);
	default input #0 output #0;
	output PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB;
endclocking

clocking mon_cb @(posedge PCLK);
	default input #0 output #0;
	input PRDATA, PREADY, PSLVERR;
endclocking

clocking ip_mon_cb @(posedge PCLK);
	default input #0 output #0;
	input PADDR, PSEL, PENABLE, PWRITE, PWDATA, PSTRB;
endclocking

modport DRV (clocking drv_cb, input PRESETn);
modport MON (clocking mon_cb);
modport IP_MON (clocking ip_mon_cb);

endinterface
