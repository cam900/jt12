`timescale 1ns / 1ps

module jt12_test;

reg	rst;


`include "../common/dump.vh"

/*
reg	clk;
initial begin
	clk = 0;
    forever #62.5 clk=~clk;
end
*/

reg mclk;

initial begin
	mclk = 0;
    forever #9.26 mclk=~mclk;
end

reg [2:0] clkcnt;
reg vclk;

reg rst0;

initial begin
	rst0=0;
    #10 rst0=1;
    #10 rst0=0;
end

always @(posedge mclk or posedge rst0)
	if( rst0 ) begin
    	clkcnt <= 3'd0;
    end
    else begin
    	if ( clkcnt== 3'b110 ) begin
        	clkcnt <= 3'd0;
        end
        else clkcnt <= clkcnt+1'b1;
        vclk <= clkcnt <= 3'd3;
    end

wire clk = vclk;



initial begin
	rst = 0;
    #500 rst = 1;
    #600 rst = 0;
	`ifdef LIMITTIME
	#(60*1000*1000) $finish;
    `endif
end


wire	cs_n, wr_n, prog_done;
wire	[ 7:0]	din, dout;
wire signed	[13:0]	right, left;
wire	[ 1:0]	addr;

jt12_testdata #(.rand_wait(`RANDWAIT)) u_testdata(
	.rst	( rst	),
	.clk	( clk	),
	.cs_n	( cs_n	),
	.wr_n	( wr_n	),
	.dout	( din	),
	.din	( dout	),
	.addr	( addr	),
	.prog_done(prog_done)
);

always @(posedge clk)
	if( prog_done ) begin
    	#(2000*1000);
        `ifdef DUMPSOUND
        $display("DUMP END");
        `endif
        $finish;
     end

jt12 uut(
	.rst	( rst	),
	.clk	( clk	),
	.din	( din	),
	.addr	( addr	),
	.cs_n	( cs_n	),
	.wr_n	( wr_n	),	
	
	.dout	( dout	),	
	.snd_right	( right	),
	.snd_left	( left	),
    .irq_n	( irq_n	)
);

`ifdef DUMPSOUND
initial $display("DUMP START");
`endif

endmodule
