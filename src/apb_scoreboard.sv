`include "define.sv"
class apb_scoreboard;
apb_transaction apb_ims, apb_ms;
mailbox #(apb_transaction) mb_ims;
mailbox #(apb_transaction) mb_ms;
bit [`DATA_WIDTH - 1 : 0] mem [0 : `MEM_DEPTH - 1];
int match = 0;
int mismatch = 0;
function new (mailbox #(apb_transaction) mb_ims, mailbox #(apb_transaction) mb_ms);
	this.mb_ims = mb_ims;
	this.mb_ms = mb_ms;
endfunction
task start();
	for(int i = 0; i < `num_trans; i++)
	begin
		apb_ims = new();
		apb_ms = new();
		mb_ims.get(apb_ims);
		mb_ms.get(apb_ms);
		apb_ims.PREADY = 1;
		if(apb_ims.PSEL	&& apb_ims.PENABLE && apb_ims.PADDR > `MEM_DEPTH)
		begin
			if(apb_ims.PWRITE)
			begin
				apb_ims.PSLVERR = 1;
				apb_ims.PRDATA = 0;
			end
			else
			begin
				apb_ims.PSLVERR = 1;
				apb_ims.PRDATA = 32'hFFFFFFFF;
			end
		end
		else
		begin
			if(apb_ims.PSEL	&& apb_ims.PENABLE && apb_ims.PWRITE)
			begin
				for(int b = 0; b < `DATA_WIDTH/8; b++)
				begin
					if (apb_ims.PSTRB[b])
						mem[apb_ims.PADDR][b*8 +: 8] = apb_ims.PWDATA[b*8 +: 8];
				end
			end
			else if(apb_ims.PSEL && apb_ims.PENABLE && !apb_ims.PWRITE)
			begin
				apb_ims.PRDATA = mem[apb_ims.PADDR];
			end
			else
			begin
				apb_ims.PRDATA = 0;
			end
		end
		if(i != `num_trans)
			compare();	
	end
endtask
task compare();
	if((apb_ims.PRDATA == apb_ms.PRDATA) && (apb_ims.PREADY = apb_ms.PREADY) && (apb_ims.PSLVERR == apb_ms.PSLVERR))
	begin
		$display("REFERENCE MATCHED DATA \t PRDATA = %0d PREADY = %b PSLVERR = %b", apb_ims.PRDATA, apb_ims.PREADY, apb_ims.PSLVERR);
		$display("DUT MATCHED DATA \t PRDATA = %0d PREADY = %b PSLVERR = %b", apb_ms.PRDATA, apb_ms.PREADY, apb_ms.PSLVERR);
		match++;
		$display("MATCHED COUNT = %d",match);
	end
	else
	begin
		$display("REFERENCE MISMATCHED DATA \t PRDATA = %0d PREADY = %b PSLVERR = %b", apb_ims.PRDATA, apb_ims.PREADY, apb_ims.PSLVERR);
		$display("DUT MISMATCHED DATA \t PRDATA = %0d PREADY = %b PSLVERR = %b", apb_ms.PRDATA, apb_ms.PREADY, apb_ms.PSLVERR);
		match++;
		$display("MISMATCHED COUNT = %d",match);
	end
endtask
endclass
