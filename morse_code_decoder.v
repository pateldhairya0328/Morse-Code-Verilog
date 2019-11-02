module morse_code_decoder(BINARY_INPUT, SET, ASYNC_RESET, LEDR, CLOCK_50);
	input [5:0] BINARY_INPUT; //6 Bit input corresponding to 0-9 (000000-001001) and A-Z (001010-100100)
	input SET; //Active low set, when activated sets the morse CODE on the binary input and allows it to be displayed
	input ASYNC_RESET; //Asynchronous active low reset, stops morse CODE output 
	input CLOCK_50; //50 MHz Clock
	output LEDR; //Red LED to output morse CODE
	
	reg [26:0] FAST_COUNTER = 26'b0; //Counts at clock speed (50 MHz)
	reg [4:0] SLOW_COUNTER = 5'b0; //Counts at 0.5 seconds
	reg ENABLE = 1'b0; //Enables Morse CODE output and slow counter
	reg [12:0] CODE; //Stores morse CODE
	reg [1:0] STORE_EDGE; //stores the current and past input on SET
	
	wire DET_EDGE; //detect a negative edge on SET
	assign DET_EDGE = (STORE_EDGE == 2'b01);
	
	always@(posedge CLOCK_50 or negedge ASYNC_RESET) begin
		if (~ASYNC_RESET) begin
			CODE <= 'b0;
			ENABLE <= 'b0;
		end
		else begin
			FAST_COUNTER <= FAST_COUNTER + 1;
			if (FAST_COUNTER >= 'd25000000) begin
				SLOW_COUNTER <= (SLOW_COUNTER + 1) & {5{ENABLE}};
				CODE <= (CODE >> 1);
				FAST_COUNTER <= 'b0;
			end
			if (SLOW_COUNTER >= 'd19) begin
				SLOW_COUNTER <= 'b0;
				ENABLE <= 'b0;
			end
			STORE_EDGE <= {STORE_EDGE[0], SET};
			if (DET_EDGE) begin //assigns code based on binary input when edge detected on SET
				ENABLE <= 1'b1;
				case(BINARY_INPUT)
					5'd0: CODE <= 19'b1110111011101110111; //0
					5'd1: CODE <= 13'b0011101110111011101; //1
					5'd2: CODE <= 13'b0000111011101110101; //2
					5'd3: CODE <= 13'b0000001110111011101; //3
					5'd4: CODE <= 13'b0000000011101010101; //4
					5'd5: CODE <= 13'b0000000000101010101; //5
					5'd6: CODE <= 13'b0000000010101010111; //6
					5'd7: CODE <= 13'b0000001010101110111; //7
					5'd8: CODE <= 13'b0000101011101110111; //8
					5'd9: CODE <= 13'b0010111011101110111; //9
					5'd10: CODE <= 13'b0000000000000011101; //A
					5'd11: CODE <= 13'b0000000000101010111; //B
					5'd12: CODE <= 13'b0000000010111010111; //C
					5'd13: CODE <= 13'b0000000000001010111; //D
					5'd14: CODE <= 13'b0000000000000000001; //E
					5'd15: CODE <= 13'b0000000000101110101; //F
					5'd16: CODE <= 13'b0000000000101110111; //G
					5'd17: CODE <= 13'b0000000000001010101; //H
					5'd18: CODE <= 13'b0000000000000000101; //I
					5'd19: CODE <= 13'b0000001110111011101; //J
					5'd20: CODE <= 13'b0000000000111010111; //K
					5'd21: CODE <= 13'b0000000000101011101; //L
					5'd22: CODE <= 13'b0000000000001110111; //M
					5'd23: CODE <= 13'b0000000000000010111; //N
					5'd24: CODE <= 13'b0000000011101110111; //O
					5'd25: CODE <= 13'b0000000010111011101; //P
					5'd26: CODE <= 13'b0000001110101110111; //Q
					5'd27: CODE <= 13'b0000000000001011101; //R
					5'd28: CODE <= 13'b0000000000000010101; //S
					5'd29: CODE <= 13'b0000000000000000111; //T
					5'd30: CODE <= 13'b0000000000001110101; //U
					5'd31: CODE <= 13'b0000000000111010101; //V
					5'd32: CODE <= 13'b0000000000111011101; //W
					5'd33: CODE <= 13'b0000000011101010111; //X
					5'd34: CODE <= 13'b0000001110111010111; //Y
					5'd35: CODE <= 13'b0000000010101110111; //Z
					default: CODE <= 13'b0;
				endcase
				end
		end
	end
	
	assign LEDR = CODE[0];
endmodule
