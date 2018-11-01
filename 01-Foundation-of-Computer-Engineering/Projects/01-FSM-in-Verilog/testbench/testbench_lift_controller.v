`timescale 1ns/100ps 
module TestbenchInputBuffer;
	// declare input signals:
	reg Clock;
	reg Reset;
	reg Done;
	reg [5:0] Input;
	// declare actual output signals:
	wire Empty;
	wire [2:0] Button;
	// declare expected output signals:
	reg Empty_Expected;
	reg [2:0] Button_Expected;
	// declare testvectors:
	integer vector_id, num_error;
	reg [10:0] testvectors[127:0];
	
	// instantiate the input buffer:
	InputBuffer dut(
		.Reset(Reset),
		.Done(Done),
		.Input(Input),
		.Empty(Empty),
		.Button(Button)
	);
	
	// generate events:
	always begin
		Clock <= 1; #25;
		Clock <= 0; #25;
	end
	
	// initialize:
	initial begin
		// load test vectors:
		$readmemb("C:/intelFPGA/18.0/workspace/01-lift-controller/input_buffer_tv.txt", testvectors);
		vector_id = 0; num_error = 0;
		
		// reset device:
		Reset = 1;
		#50;
		
		// turn reset off:
		Reset = 0;
	end

	// apply input at posive edge:
	always @(posedge Clock) begin
		#1;
		{Done, Input, Empty_Expected, Button_Expected} = testvectors[vector_id];
	end

	// check output at negative edge:
	always @(negedge Clock) begin
		if (!Reset) begin // skip during reset
			// update error statistics:
			if ((Empty !== Empty_Expected) || (Button !== Button_Expected)) begin
				$display("Testcase: %d", vector_id + 1);
				$display("\tErrror: Input = %b", Input);
				$display("\tOutput: Empty = %b(%b expected), Button = %b(%b expected)", 
					Empty, Empty_Expected, 
					Button, Button_Expected
				);
				num_error = num_error + 1;
			end
			
			// next test vector:
			vector_id = vector_id + 1;
			
			// terminates when all testvectors are fetched:
			if (testvectors[vector_id] === 11'bx) begin
				$display("%d tests completed with %d errors", vector_id, num_error);
				$finish;
			end
		end
	end
endmodule

module TestbenchLiftFSM;
	// declare input signals:
	reg Clock, Reset;
	reg Empty;
	reg [2:0] Button;
	// declare actual output signals:
	wire Done;
	wire [1:0] Action;
	// declare expected output signals:
	reg Done_Expected;
	reg [1:0] Action_Expected;
	// declare testvectors:
	integer vector_id, num_error;
	reg [6:0] testvectors[127:0];
	
	// instantiate the lift FSM:
	LiftFSM dut(
		.Clock(Clock), 
		.Reset(Reset),
		.Empty(Empty),
		.Button(Button), 
		.Done(Done),
		.Action(Action)
	);
	
	// generate clock
	always begin
		Clock <= 1; #25;
		Clock <= 0; #25;
	end
	
	// initialize:
	initial begin
		// load test vectors:
		$readmemb("C:/intelFPGA/18.0/workspace/01-lift-controller/lift_fsm_tv.txt", testvectors);
		vector_id = 0; num_error = 0;
		
		// reset device:
		Reset <= 1;
		Empty <= 0;
		#50;
		
		// turn reset off:
		Reset = 0;
	end
	
	// apply input at posive edge:
	always @(posedge Clock) begin
		#1;
		{Empty, Button, Done_Expected, Action_Expected} = testvectors[vector_id];
	end

	// check output at negative edge:
	always @(negedge Clock) begin
		if (!Reset) begin // skip during reset
			// update error statistics:
			if ((Done !== Done_Expected) || (Action !== Action_Expected)) begin
				$display("Testcase: %d", vector_id + 1);
				$display("\tErrror: Empty = %b, Input = %b", Empty, Button);
				$display("\tOutput: Done = %b(%b expected), Action = %d(%d expected)", Done, Done_Expected, Action, Action_Expected);
				num_error = num_error + 1;
			end
			
			// next test vector:
			vector_id = vector_id + 1;
			
			// terminates when all testvectors are fetched:
			if (testvectors[vector_id] === 7'bx) begin
				$display("%d tests completed with %d errors", vector_id, num_error);
				$finish;
			end
		end
	end
endmodule

module TestbenchLiftController;
	// declare input signals:
	reg Clock, Reset;
	reg [5:0] Input;
	// declare actual output signals:
	wire [1:0] Action;
	// declare expected output signals:
	reg [1:0] Action_Expected;
	// declare testvectors:
	integer vector_id, num_error;
	reg [7:0] testvectors[127:0];
	
	// instantiate the lift FSM:
	LiftController dut(
		.Clock(Clock), 
		.Reset(Reset),
		.Input(Input),
		.Action(Action)
	);
	
	// generate clock
	always begin
		Clock <= 1; #25;
		Clock <= 0; #25;
	end
	
	// initialize:
	initial begin
		// load test vectors:
		$readmemb("C:/intelFPGA/18.0/workspace/01-lift-controller/lift_controller_tv.txt", testvectors);
		vector_id = 0; num_error = 0;
		
		// reset device:
		Reset = 1;
		#50;
		
		// turn reset off:
		Reset = 0;
	end

	// apply input at posive edge:
	always @(posedge Clock) begin
		#1 {Input, Action_Expected} = testvectors[vector_id];
	end

	// check output at negative edge:
	always @(negedge Clock) begin
		if (!Reset) begin // skip during reset
			// update error statistics:
			if ((Action !== Action_Expected)) begin
				$display("Testcase: %d", vector_id + 1);
				$display("\tErrror: Input = %b", Input);
				$display("\tOutput: Action = %b(%b expected)", 
					Action, Action_Expected
				);
				num_error = num_error + 1;
			end
			
			// next test vector:
			vector_id = vector_id + 1;
			
			// terminates when all testvectors are fetched:
			if (testvectors[vector_id] === 8'bx) begin
				$display("%d tests completed with %d errors", vector_id, num_error);
				$finish;
			end
		end
	end
endmodule