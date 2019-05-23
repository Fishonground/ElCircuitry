module device( 
input [15:0] SW, 
input OSC, 
input BTN, 
output [15:0] LEDS 
); 
func dev(.x_i(SW[7:0]), .start_i(SW[8]), .clk(OSC), .rst(BTN), .y_o(LEDS)); 
endmodule 
