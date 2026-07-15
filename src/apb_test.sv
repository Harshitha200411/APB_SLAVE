`include "define.sv"
class apb_test;
virtual apb_if dr_if;
virtual apb_if ip_mn_if;
virtual apb_if mn_if;
apb_env envn;
function new (virtual apb_if dr_if, virtual apb_if ip_mn_if, virtual apb_if mn_if);
	this.dr_if = dr_if;
	this.ip_mn_if = ip_mn_if;
	this.mn_if = mn_if;
endfunction
task run();
	envn = new (dr_if, ip_mn_if, mn_if);
	envn.build;
	envn.start;
endtask;
endclass

class test_write extends apb_test; 
  apb_transaction_write  trans_write; 
  function new(virtual apb_if dr_if, virtual apb_if ip_mn_if, virtual apb_if mn_if); 
     super.new(dr_if, ip_mn_if, mn_if); 
  endfunction 
  task run(); 
    envn=new(dr_if, ip_mn_if, mn_if); 
    envn.build; 
    begin  
      trans_write = new(); 
      envn.gen.apb_gen = trans_write; 
    end 
    envn.start; 
  endtask 
endclass 
 
class test_read extends apb_test; 
  apb_transaction_read  trans_read; 
  function new(virtual apb_if dr_if, virtual apb_if ip_mn_if, virtual apb_if mn_if); 
     super.new(dr_if, ip_mn_if, mn_if); 
  endfunction 
  task run(); 
    envn=new(dr_if, ip_mn_if, mn_if); 
    envn.build; 
    begin  
      trans_read = new(); 
      envn.gen.apb_gen = trans_read; 
    end 
    envn.start; 
  endtask 
endclass 

class test_illegal_addr_wrt extends apb_test; 
  apb_transaction_illegal_addr_wrt  trans_addr_wrt; 
  function new(virtual apb_if dr_if, virtual apb_if ip_mn_if, virtual apb_if mn_if); 
     super.new(dr_if, ip_mn_if, mn_if); 
  endfunction 
  task run(); 
    envn=new(dr_if, ip_mn_if, mn_if); 
    envn.build; 
    begin  
      trans_addr_wrt = new(); 
      envn.gen.apb_gen = trans_addr_wrt; 
    end 
    envn.start; 
  endtask 
endclass 

class test_illegal_addr_rd extends apb_test; 
  apb_transaction_illegal_addr_rd  trans_addr_rd; 
  function new(virtual apb_if dr_if, virtual apb_if ip_mn_if, virtual apb_if mn_if); 
     super.new(dr_if, ip_mn_if, mn_if); 
  endfunction 
  task run(); 
    envn=new(dr_if, ip_mn_if, mn_if); 
    envn.build; 
    begin  
      trans_addr_rd = new(); 
      envn.gen.apb_gen = trans_addr_rd; 
    end 
    envn.start; 
  endtask 
endclass 

class test_regression extends apb_test; 
apb_transaction  trans; 
apb_transaction_write trans_write; 
apb_transaction_read trans_read; 
apb_transaction_illegal_addr_wrt trans_addr_wrt; 
apb_transaction_illegal_addr_rd  trans_addr_rd; 
function new(virtual apb_if dr_if, virtual apb_if ip_mn_if, virtual apb_if mn_if); 
super.new(dr_if, ip_mn_if, mn_if); 
endfunction 
task run(); 
envn = new(dr_if, ip_mn_if, mn_if); 
envn.build(); 

trans = new(); 
envn.gen.apb_gen = trans; 
envn.start(); 

trans_write = new(); 
envn.gen.apb_gen = trans_write; 
envn.start(); 
 
trans_read = new(); 
envn.gen.apb_gen = trans_read; 
envn.start(); 

trans_addr_wrt = new(); 
envn.gen.apb_gen = trans_addr_wrt; 
envn.start(); 

trans_addr_rd = new(); 
envn.gen.apb_gen = trans_addr_rd; 
envn.start(); 
endtask 
endclass 
