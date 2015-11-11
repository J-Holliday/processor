`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:37:58 11/10/2015 
// Design Name: 
// Module Name:    processor 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module processor(
	input clk0,
	input [7:0] sw,
	output [7:0] led
    );

	//--- I-O define begin ---
	assign led = {4'b0000, OUT};
	//--- I-O define end ---

	//--- register define begin ---
	reg[3:0] A = 0;
	reg[3:0] B = 0;
	reg[3:0] OUT = 0;
	reg[3:0] P_COUNT = 0;
	reg carry = 0;
	//--- register define end ---
	
	//--- wire define begin ---
	wire [3:0] y;
	wire [1:0] order_selector;
	wire [3:0] ALU_value;
	wire [1:0] ALU_address;
	wire ALU_carry;
	//--- wire define end ---
	
	//--- selector define begin ---
	selector slc(.A(A), .B(B), .IN(sw[7:4]), .order(order_selector), .y(y));
	//--- selector define end ---
	
	//--- ALU define begin ---
	ALU alu(.clk0(clk0), .y(y), .order(4'b0001), .res(ALU_value), .address(ALU_address), .carry(ALU_carry));
	//--- ALU define end ---

	always @(posedge clk0) begin
		P_COUNT <= P_COUNT + 1;
		
		
		if(ALU_address==4'b0010)
			A = ALU_value;
		
		carry = ALU_carry;
	end

endmodule

module selector(
	input[3:0] A,
	input[3:0] B,
	input[3:0] IN,
	input[1:0] order,
	output[3:0] y
);

	assign y = order[1]?order[0]?A:B:order[0]?IN:4'b0000;
		
endmodule

module ALU(
	input clk0,
	input[3:0] y,
	input[3:0] order,
	output[3:0] res,		// register value
	output[1:0] address, // register address
	output carry
);

	assign res = val_reg;
	assign address = add_reg;
	reg[3:0] val_reg = 0;
	reg[1:0] add_reg = 0;

	always @(posedge clk0) begin
		if(order==4'b0001) begin // MOV A,y
			val_reg <= y;
			add_reg <= 2'b01; // reg A
		end
		else if(order==4'b0010) begin // MOV B,y
			val_reg <= y;
			add_reg <= 2'b10; // reg B
		end
	end

endmodule

/*
	reg enable = 0;
	and_gate f1(.clk0(clk0), .enable(enable), .x1(sw[0]), .x2(sw[1]), .y(led[0]));

	reg[26:0] c=0;
	always @(posedge clk0) begin
		
		if(c[26]==27'd99999999) begin
			enable <= ~enable;
			c <= 0;
		end
		else
			c <= c + 1;
		
	end

endmodule

module and_gate(
	input clk0,
	input enable,
	input x1,
	input x2,
	output y
);

	assign y = x1 * x2;

endmodule

*/