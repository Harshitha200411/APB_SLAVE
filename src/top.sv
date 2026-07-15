`include "define.sv"
`include "apb_if.sv"
`include "apb_pkg.sv"
`include "apb_slave.sv"
module top;
import apb_pkg ::*;
logic PCLK;
logic PRESETn;
initial begin
	PCLK = 0;
	forever #10 PCLK = ~PCLK;
end
initial begin
	@(posedge PCLK);
	PRESETn = 0;
	@(posedge PCLK);
	PRESETn = 1;
	@(posedge PCLK);
	PRESETn = 0;
	@(posedge PCLK);
	PRESETn = 1;
end
apb_if intf (PCLK, PRESETn);
apb_slave #(.ADDR_WIDTH(`ADDR_WIDTH),.DATA_WIDTH(`DATA_WIDTH),.MEM_DEPTH(`MEM_DEPTH)) DUV (.PCLK(intf.PCLK), .PRESETn(intf.PRESETn), .PADDR(intf.PADDR), .PSEL(intf.PSEL), .PENABLE(intf.PENABLE), .PWRITE(intf.PWRITE), .PWDATA(intf.PWDATA), .PSTRB(intf.PSTRB), 
.PRDATA(intf.PRDATA), .PREADY(intf.PREADY), .PSLVERR(intf.PSLVERR));    

apb_test test = new(intf.DRV, intf.IP_MON, intf.MON);
test_write t1 = new(intf.DRV, intf.IP_MON, intf.MON);
test_read t2 = new(intf.DRV, intf.IP_MON, intf.MON);
test_illegal_addr_wrt t3 = new(intf.DRV, intf.IP_MON, intf.MON);
test_illegal_addr_rd t4 = new(intf.DRV, intf.IP_MON, intf.MON);
test_regression reg_tb = new(intf.DRV, intf.IP_MON, intf.MON); 

initial begin
	test.run();
	t1.run();
	t2.run();
	t3.run();
	t4.run();
	reg_tb.run(); 
	$finish();
end
endmodule
