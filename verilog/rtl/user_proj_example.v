// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

    /*counter #(
        .BITS(BITS)
    ) counter(
        .clk(clk),
        .reset(rst),
        .ready(wbs_ack_o),
        .valid(valid),
        .rdata(rdata),
        .wdata(wbs_dat_i),
        .wstrb(wstrb),
        .la_write(la_write),
        .la_input(la_data_in[63:32]),
        .count(count)
    );*/
    
    wht16tm dut(.Y(count[11:0]),.X(rdata[7:0]),.sin(rdata[3:0]),.sout(rdata[3:0]));

endmodule

module wht16tm#
    ( parameter bi = 7)
    (
     output signed [bi+4:0] Y,//16bit hdmd tx
     input signed [bi:0] X,
     input [3:0] sin,sout
    );
 wire signed [bi:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15;
 wire signed [bi+4:0]y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15;
   
demux16 a1(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,sin,X);
wht16 a2 (y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15);
mux16 a3 (Y,y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,sout);
endmodule

module demux16#
  ( parameter bi = 7)
  (  
    output reg signed [bi:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,
    input [3:0]s,
    input signed [bi:0]in
  );
  
always@(*)
begin
case(s)
4'b0000 : x0 = in; 
4'b0001 : x1 = in; 
4'b0010 : x2 = in; 
4'b0011 : x3 = in; 
4'b0100 : x4 = in; 
4'b0101 : x5 = in; 
4'b0110 : x6 = in; 
4'b0111 : x7 = in; 
4'b1000 : x8 = in; 
4'b1001 : x9 = in; 
4'b1010 : x10 = in; 
4'b1011 : x11 = in; 
4'b1100 : x12 = in; 
4'b1101 : x13 = in; 
4'b1110 : x14 = in; 
4'b1111 : x15 = in; 
endcase
end
    
endmodule

module mux16#
  ( parameter bi = 7)
  (  
    output reg signed [bi+4:0]out,
    input signed [bi+4:0]y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,
    input [3:0]s
  );
    
always@(*)
begin
case(s)
4'b0000 : out = y0 ;                  
4'b0001 : out = y1 ;                  
4'b0010 : out = y2 ;                   
4'b0011 : out = y3 ;                  
4'b0100 : out = y4 ;                  
4'b0101 : out = y5 ;                  
4'b0110 : out = y6 ;                  
4'b0111 : out = y7 ;                 
4'b1000 : out = y8 ;                  
4'b1001 : out = y9 ;                  
4'b1010 : out = y10;                 
4'b1011 : out = y11;                  
4'b1100 : out = y12;                 
4'b1101 : out = y13;                 
4'b1110 : out = y14;                 
4'b1111 : out = y15; 
endcase
end
    
endmodule  
  
module wht16#
    ( parameter bi = 7)
    (
    output signed [bi+4:0]y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13,y14,y15,//m+log(n)_base2
    input signed [bi:0]x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15
    );

wire signed [bi+1:0]t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15;//temporary stage 1  
wire signed [bi+4:0]pf0,pf1,pf2,pf3,pf4,pf5,pf6,pf7,pf8,pf9,pf10,pf11,pf12,pf13,pf14,pf15;

add #(bi+1) sa0(t0,x0,x8,1'b0);
add #(bi+1) sa1(t1,x1,x9,1'b0);
add #(bi+1) sa2(t2,x2,x10,1'b0);
add #(bi+1) sa3(t3,x3,x11,1'b0);
add #(bi+1) sa4(t4,x4,x12,1'b0);
add #(bi+1) sa5(t5,x5,x13,1'b0);
add #(bi+1) sa6(t6,x6,x14,1'b0);
add #(bi+1) sa7(t7,x7,x15,1'b0);

add #(bi+1) sb0(t8,x0,x8,1'b1);
add #(bi+1) sb1(t9,x1,x9,1'b1);
add #(bi+1) sb2(t10,x2,x10,1'b1);
add #(bi+1) sb3(t11,x3,x11,1'b1);
add #(bi+1) sb4(t12,x4,x12,1'b1);
add #(bi+1) sb5(t13,x5,x13,1'b1);
add #(bi+1) sb6(t14,x6,x14,1'b1);
add #(bi+1) sb7(t15,x7,x15,1'b1);

wht8 d80(pf0,pf1,pf2,pf3,pf4,pf5,pf6,pf7,t0,t1,t2,t3,t4,t5,t6,t7);
wht8 d81(pf8,pf9,pf10,pf11,pf12,pf13,pf14,pf15,t8,t9,t10,t11,t12,t13,t14,t15);

assign y0 = pf0;
assign y1 = pf4;
assign y2 = pf6;
assign y3 = pf8;
assign y4 = pf10;
assign y5 = pf12;
assign y6 = pf14;
assign y7 = pf2;

assign y8 = pf3;
assign y9 = pf15;
assign y10 = pf13;
assign y11 = pf11;
assign y12 = pf9;
assign y13 = pf7;
assign y14 = pf5;
assign y15 = pf1;

endmodule

module wht8#
    ( parameter bi = 8)
    (
    output signed [bi+3:0]y0,y1,y2,y3,y4,y5,y6,y7,
    input signed [bi:0]x0,x1,x2,x3,x4,x5,x6,x7
    );
    
wire signed [bi+1:0]t0,t1,t2,t3,t4,t5,t6,t7;//temporary stage 1

add# (bi+1) ea0(t0,x0,x4,1'b0);
add# (bi+1) ea1(t1,x1,x5,1'b0);
add# (bi+1) ea2(t2,x2,x6,1'b0);
add# (bi+1) ea3(t3,x3,x7,1'b0);
      
add# (bi+1) eb0(t4,x0,x4,1'b1);
add# (bi+1) eb1(t5,x1,x5,1'b1);
add# (bi+1) eb2(t6,x2,x6,1'b1);
add# (bi+1) ec3(t7,x3,x7,1'b1);

wht4 d40(y0,y1,y2,y3,t0,t1,t2,t3);
wht4 d41(y4,y5,y6,y7,t4,t5,t6,t7);

endmodule

module wht4#
    ( parameter bi = 9)
    (
    output signed [bi+2:0]y0,y1,y2,y3,
    input signed [bi:0]x0,x1,x2,x3
    );
    
wire signed [bi+1:0]t0,t1,t2,t3;//temporary stages in stage1

//stage1
add #(bi+1) fa0(t0,x0,x2,1'b0);
add #(bi+1) fa1(t1,x1,x3,1'b0);
        
add #(bi+1) fb2(t2,x0,x2,1'b1);
add #(bi+1) fb3(t3,x1,x3,1'b1);

//stage2 final
wht2 d0(y0,y1,t0,t1);
wht2 d1(y2,y3,t2,t3);

endmodule

module wht2(A,B,a,b);

parameter bi = 10;

output signed [bi+1:0] A,B;
input signed [bi:0] a,b;

wire signed [bi+1:0] A1,B1;

add #(bi+1) t0(A,a,b,1'b0);
add #(bi+1) t1(B,a,b,1'b1);

endmodule

module add#
    (parameter  bits = 4)
    (sum,p,q,mode);

output signed [bits:0] sum;
input signed [bits-1:0] p,q;
input mode;

assign sum[bits:0] = mode ? p-q : p+q;

endmodule

/*module counter #(
    parameter BITS = 32
)(
    input clk,
    input reset,
    input valid,
    input [3:0] wstrb,
    input [BITS-1:0] wdata,
    input [BITS-1:0] la_write,
    input [BITS-1:0] la_input,
    output ready,
    output [BITS-1:0] rdata,
    output [BITS-1:0] count
);
    reg ready;
    reg [BITS-1:0] count;
    reg [BITS-1:0] rdata;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            ready <= 0;
        end else begin
            ready <= 1'b0;
            if (~|la_write) begin
                count <= count + 1;
            end
            if (valid && !ready) begin
                ready <= 1'b1;
                rdata <= count;
                if (wstrb[0]) count[7:0]   <= wdata[7:0];
                if (wstrb[1]) count[15:8]  <= wdata[15:8];
                if (wstrb[2]) count[23:16] <= wdata[23:16];
                if (wstrb[3]) count[31:24] <= wdata[31:24];
            end else if (|la_write) begin
                count <= la_write & la_input;
            end
        end
    end

endmodule*/
`default_nettype wire
