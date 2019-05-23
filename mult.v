module mult ( 
input clk_i, 
input rst_i, 

input [7:0] a_bi, 
input [7:0] b_bi, 
input start_i, 

output reg busy_o, 
output reg [15:0] y_bo 
); 

localparam IDLE = 1'b0; 
localparam WORK = 1'b1; 

reg [2:0] ctr; 
wire end_step; 
wire [6:0] part_sum; 
reg sign_a; 
reg sign_b; 
wire [14:0] shifted_part_sum; 
reg [6:0] a, b; 
reg [14:0] part_res; 
reg state; 

assign part_sum = a & {7{b[ctr]}}; 
assign shifted_part_sum = part_sum « ctr; 
assign end_step = (ctr == 3'h6); 


always@(posedge clk_i) 
if(rst_i) begin 
ctr <= 0; 
part_res <= 0; 
y_bo <= 0; 
busy_o <= 0; 

state <= IDLE; 
end else begin 

case(state) 
IDLE: 
if(start_i) begin 
state <= WORK; 

busy_o = 1'b1; 

{sign_a, a} <= a_bi; 
{sign_b, b} <= b_bi; 
ctr <= 0; 
part_res <= 0; 

end 
WORK: 
begin 
part_res = part_res + shifted_part_sum; 
ctr <= ctr + 1; 

if(end_step) begin 
state <= IDLE; 
y_bo <= {sign_a != sign_b, part_res}; 
busy_o <= 0; 
end 
end 
endcase 
end 

endmodule 
