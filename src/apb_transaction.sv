`include "define.sv"
class apb_transaction;
rand bit [`ADDR_WIDTH - 1 : 0] PADDR;
rand bit PSEL, PENABLE, PWRITE;
rand bit [`DATA_WIDTH - 1 : 0] PWDATA;
rand bit [(`DATA_WIDTH/8) - 1 : 0] PSTRB;
bit [`DATA_WIDTH - 1 : 0] PRDATA;
bit PREADY, PSLVERR;
constraint addr_range { PADDR inside {[0:256]}; }
constraint pwdata_range { PWDATA inside {[0:2**(`DATA_WIDTH)-1]}; }
virtual function apb_transaction copy();
	copy = new();
	copy.PADDR = this.PADDR;
	copy.PSEL = this.PSEL;
	copy.PENABLE = this.PENABLE;
	copy.PWRITE = this.PWRITE;
	copy.PWDATA = this.PWDATA;
	copy.PSTRB = this.PSTRB;
endfunction
endclass

class apb_transaction_write extends apb_transaction; 
constraint wr_rd_constraint {PWRITE == 1;} 
constraint enable_sel { PENABLE == 1;  PSEL == 1;}
virtual function apb_transaction copy(); 
	apb_transaction_write copy1; 
	copy1=new(); 
	copy1.PADDR = this.PADDR;
	copy1.PSEL = this.PSEL;
	copy1.PENABLE = this.PENABLE;
	copy1.PWRITE = this.PWRITE;
	copy1.PWDATA = this.PWDATA;
	copy1.PSTRB = this.PSTRB;
	return copy1; 
endfunction 
endclass 

class apb_transaction_read extends apb_transaction; 
constraint wr_rd_constraint {PWRITE == 0;} 
constraint enable_sel { PENABLE == 1;  PSEL == 1; PSTRB == 0;}
virtual function apb_transaction copy(); 
	apb_transaction_read copy2; 
	copy2=new(); 
	copy2.PADDR = this.PADDR;
	copy2.PSEL = this.PSEL;
	copy2.PENABLE = this.PENABLE;
	copy2.PWRITE = this.PWRITE;
	copy2.PWDATA = this.PWDATA;
	copy2.PSTRB = this.PSTRB;
	return copy2; 
endfunction 
endclass 

class apb_transaction_illegal_addr_wrt extends apb_transaction; 
constraint addr_range { PADDR > 255; }
constraint wr_rd_constraint {PWRITE == 1;}
virtual function apb_transaction copy(); 
	apb_transaction_read copy3; 
	copy3=new(); 
	copy3.PADDR = this.PADDR;
	copy3.PSEL = this.PSEL;
	copy3.PENABLE = this.PENABLE;
	copy3.PWRITE = this.PWRITE;
	copy3.PWDATA = this.PWDATA;
	copy3.PSTRB = this.PSTRB;
	return copy3; 
endfunction 
endclass 

class apb_transaction_illegal_addr_rd extends apb_transaction; 
constraint addr_range { PADDR > 255; }
constraint wr_rd_constraint {PWRITE == 0;} 
constraint enable_sel { PENABLE == 1;  PSEL == 1; PSTRB == 0; }
virtual function apb_transaction copy(); 
	apb_transaction_read copy4; 
	copy4=new(); 
	copy4.PADDR = this.PADDR;
	copy4.PSEL = this.PSEL;
	copy4.PENABLE = this.PENABLE;
	copy4.PWRITE = this.PWRITE;
	copy4.PWDATA = this.PWDATA;
	copy4.PSTRB = this.PSTRB;
	return copy4; 
endfunction 
endclass 
