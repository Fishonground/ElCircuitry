module func( 
input clk, 
input rst, 
input start_i, 
input [7:0] x_i, 
output reg [15:0] y_o, 
output busy_o 
); 

localparam IDLE = 1'b0; 
localparam WORK = 1'b1; 

wire busy; 
reg [7:0] a; 
reg [7:0] b; 
reg start; 
wire [15:0] y_bo; 
reg [15:0] temp_res; 
reg state; 
reg [2:0] cnt; 

wire [15:0] x; 
wire [15:0] y; 
wire [15:0] sum_res; 

wire [15:0] sum2_res; 


mult mul(.clk_i(clk), .rst_i(rst), .a_bi(a), 
.b_bi(b), .busy_o(busy), .start_i(start), .y_bo(y_bo)); 

sum summer1(.a(x), .b(y), .res(sum_res)); 
sum summer2(.a(temp_res), .b(y_bo), .res(sum2_res)); 


assign x = {3'b001, ~y_bo[13:1]}; 
assign y = 15'd1; 

assign busy_o = state; 

always @(posedge clk) begin 
if (rst) begin 
y_o <= 0; 
start <= 0; 
cnt <= 0; 
state <= IDLE; 
end else begin 
case (state) 
IDLE: 
begin 
if (start_i) begin 
start <= 0; 
cnt <= 0; 
state <= WORK; 
end 
end 
WORK: 
begin 

if (!busy && !start) begin 
case (cnt) 

3'd0: 
begin 
a <= x_i; 
b <= x_i; 
start <= 1; 
end 




3'd1: 
begin 

temp_res <= sum_res; 


a <= {2'b00, y_bo[13:8]}; 
b <= {2'b00, y_bo[13:8]}; 
start <= 1; 
end 


3'd2: 
begin 
a <= {y_bo[15],y_bo[13:7]}; 
b <= 8'h05; 
start <= 1; 
end 


3'd3: 
begin 
y_o <= sum2_res; 
state <= IDLE; 
end 
endcase 
cnt = cnt + 3'd1; 
end else 
start <= 0; 
end 
endcase 
end 
end 

endmodule 
