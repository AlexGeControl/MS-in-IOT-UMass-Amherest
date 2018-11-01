// ---------
// Input Buffer
// ---------
module InputBuffer(
	input wire Reset,
	input wire Done,
	input wire [5:0] Input,
	output reg Empty,
	output reg [2:0] Button
);	
	// declare highest priority button encoding:
	localparam Input_1U = 6'b000001,
		Input_2U = 6'b000010,
		Input_3U = 6'b000100,
		Input_2D = 6'b001000,
		Input_3D = 6'b010000,
		Input_4D = 6'b100000;
	
	// declare output encoding:
	localparam Button_1U = 3'd0,
		Button_2U = 3'd1,
		Button_3U = 3'd2,
		Button_2D = 3'd3,
		Button_3D = 3'd4,
		Button_4D = 3'd5;
	
	// declare buffer:
	reg [5:0] Buffer;
	reg [5:0] CurrentCommand;
	
	// ---------
	// reset
	// ---------
	always @(Reset) begin
		if (Reset) begin
			Buffer <= 6'b0;
			CurrentCommand <= 6'b0;
		end
	end
	
	// ---------
	// input priority buffer
	// ---------
	always @(
		Input
	) begin			
		// input enqueue: only the button of highest priority
		Buffer = Buffer | (Input & ((~Input) + 1));
		CurrentCommand = Buffer & ((~Buffer) + 1);
	end
	
	// ---------
	//	current command update
	// ---------	
	always @(
		posedge Done
	) begin
		// buffer dequeue:
		if (!Empty) begin
			Buffer = Buffer & ~CurrentCommand;
			CurrentCommand = Buffer & ((~Buffer) + 1);
		end
	end
	
	// ---------
	// output decoder
	// ---------
	always @(Buffer) begin
		Empty = (Buffer == 6'b000000);
	end
	
	always @(CurrentCommand) begin
		if (CurrentCommand) begin
			case (CurrentCommand)
				Input_1U: begin
					Button <= Button_1U;
				end
				Input_2U: begin
					Button <= Button_2U;
				end
				Input_3U: begin
					Button <= Button_3U;
				end
				Input_2D: begin
					Button <= Button_2D;
				end
				Input_3D: begin
					Button <= Button_3D;
				end
				Input_4D: begin
					Button <= Button_4D;
				end
				default: begin
					Button <= 3'bz;
				end
			endcase
		end else begin
			Button <= 3'bz;
		end
	end
endmodule

// ---------
// Lift FSM
// ---------
module LiftFSM(
	input wire Clock,
	input wire Reset,
	input wire Empty,
	input wire [2:0] Button,
	output wire Done,
	output reg [1:0] Action
);
	// declare button control encoding:
	localparam Button_1U = 3'd0,
		Button_2U = 3'd1,
		Button_3U = 3'd2,
		Button_2D = 3'd3,
		Button_3D = 3'd4,
		Button_4D = 3'd5,
		Button_6_Placeholder = 3'd6,
		Button_7_Placeholder = 3'd7;

	// declare action encoding:
	localparam Action_Up = 2'd0,
		Action_Down = 2'd1,
		Action_Stay = 2'd2,
		Action_Reset = 2'd3;
		
	// declare state encoding:
	localparam STATE_Initial = 4'd0,
		STATE_Idle_on_1st = 4'd1,
		STATE_Idle_on_2nd = 4'd2, 
		STATE_Idle_on_3rd = 4'd3, 
		STATE_Idle_on_4th = 4'd4, 
		STATE_Busy_1st_to_2nd = 4'd5, 
		STATE_Busy_2nd_to_3rd = 4'd6, 
		STATE_Busy_3rd_to_4th = 4'd7, 
		STATE_Busy_2nd_to_1st = 4'd8, 
		STATE_Busy_3rd_to_2nd = 4'd9, 
		STATE_Busy_4th_to_3rd = 4'd10, 
		STATE_11_Placeholder = 4'd11, 
		STATE_12_Placeholder = 4'd12, 
		STATE_13_Placeholder = 4'd13, 
		STATE_14_Placeholder = 4'd14, 
		STATE_15_Placeholder = 4'd15;	
		
	// declare state variable:
	reg [3:0] CurrentState;
	reg [3:0] NextState;
	
	// next state decoder:
	always @(CurrentState or Button) begin
		// default: stay at current state
		NextState = CurrentState;
		
		// ---------
		// state transition
		// ---------
		case (CurrentState)
			// 0. initial:
			STATE_Initial: begin
				NextState = STATE_Idle_on_1st;
			end
			// 1. on the 1st floor:
			STATE_Idle_on_1st: begin
				case (Button)
					Button_1U: begin
						NextState = STATE_Idle_on_2nd;
					end
					Button_2U: begin
						NextState = STATE_Busy_2nd_to_3rd;
					end
					Button_3U: begin
						NextState = STATE_Busy_3rd_to_4th;
					end
					Button_2D: begin
						NextState = STATE_Busy_2nd_to_1st;
					end
					Button_3D: begin
						NextState = STATE_Busy_3rd_to_2nd;
					end
					Button_4D: begin
						NextState = STATE_Busy_4th_to_3rd;
					end
					Button_6_Placeholder: begin
					end
					Button_7_Placeholder: begin
					end
					default: begin
					end
				endcase
			end
			// 2. on the 2nd floor:
			STATE_Idle_on_2nd: begin
				case (Button)
					Button_1U: begin
						NextState = STATE_Busy_1st_to_2nd;
					end
					Button_2U: begin
						NextState = STATE_Idle_on_3rd;
					end
					Button_3U: begin
						NextState = STATE_Busy_3rd_to_4th;
					end
					Button_2D: begin
						NextState = STATE_Idle_on_1st;
					end
					Button_3D: begin
						NextState = STATE_Busy_3rd_to_2nd;
					end
					Button_4D: begin
						NextState = STATE_Busy_4th_to_3rd;
					end
					Button_6_Placeholder: begin
					end
					Button_7_Placeholder: begin
					end
					default: begin
					end
				endcase				
			end
			// 3. on the 3rd floor:
			STATE_Idle_on_3rd: begin
				case (Button)
					Button_1U: begin
						NextState = STATE_Busy_1st_to_2nd;
					end
					Button_2U: begin
						NextState = STATE_Busy_2nd_to_3rd;
					end
					Button_3U: begin
						NextState = STATE_Idle_on_4th;
					end
					Button_2D: begin
						NextState = STATE_Busy_2nd_to_1st;
					end
					Button_3D: begin
						NextState = STATE_Idle_on_2nd;
					end
					Button_4D: begin
						NextState = STATE_Busy_4th_to_3rd;
					end		
					Button_6_Placeholder: begin
					end
					Button_7_Placeholder: begin
					end
					default: begin
					end
				endcase		
			end
			// 4. on the 4th floor:
			STATE_Idle_on_4th: begin
				case (Button)
					Button_1U: begin
						NextState = STATE_Busy_1st_to_2nd;
					end
					Button_2U: begin
						NextState = STATE_Busy_2nd_to_3rd;
					end
					Button_3U: begin
						NextState = STATE_Busy_3rd_to_4th;
					end
					Button_2D: begin
						NextState = STATE_Busy_2nd_to_1st;
					end
					Button_3D: begin
						NextState = STATE_Busy_3rd_to_2nd;
					end
					Button_4D: begin
						NextState = STATE_Idle_on_3rd;
					end	
					Button_6_Placeholder: begin
					end
					Button_7_Placeholder: begin
					end
					default: begin
					end
				endcase			
			end
			// ---------
			//	transient states: to terminal 
			// ---------
			STATE_Busy_1st_to_2nd: begin
				NextState = STATE_Idle_on_2nd;
			end
			STATE_Busy_2nd_to_3rd: begin
				NextState = STATE_Idle_on_3rd;
			end
			STATE_Busy_3rd_to_4th: begin
				NextState = STATE_Idle_on_4th;
			end
			STATE_Busy_2nd_to_1st: begin
				NextState = STATE_Idle_on_1st;
			end
			STATE_Busy_3rd_to_2nd: begin
				NextState = STATE_Idle_on_2nd;
			end
			STATE_Busy_4th_to_3rd: begin
				NextState = STATE_Idle_on_3rd;
			end
			// ---------
			// place-holder states: lock to indicate error
			// ---------
			STATE_11_Placeholder: begin
				NextState = STATE_Initial;
			end
			STATE_12_Placeholder: begin
				NextState = STATE_Initial;
			end
			STATE_13_Placeholder: begin
				NextState = STATE_Initial;
			end
			STATE_14_Placeholder: begin
				NextState = STATE_Initial;
			end
			STATE_15_Placeholder: begin
				NextState = STATE_Initial;
			end
			default: begin
				NextState = STATE_Initial;
			end
		endcase
	end
	
	// next-state memory:
	always @(posedge Clock) begin
		if (Reset) begin 
			CurrentState <= STATE_Initial;
		end else begin
			CurrentState <= NextState;
		end
	end
	
	// output decoder:
	assign Done = (
	(
		(CurrentState == STATE_Idle_on_1st) ||
		(CurrentState == STATE_Idle_on_2nd) ||
		(CurrentState == STATE_Idle_on_3rd) ||
		(CurrentState == STATE_Idle_on_4th)
	) && Clock) || (
		(CurrentState == STATE_Busy_1st_to_2nd) ||
		(CurrentState == STATE_Busy_2nd_to_3rd) ||
		(CurrentState == STATE_Busy_3rd_to_4th) ||
		(CurrentState == STATE_Busy_2nd_to_1st) ||
		(CurrentState == STATE_Busy_3rd_to_2nd) ||
		(CurrentState == STATE_Busy_4th_to_3rd)
	);
	
	always @(CurrentState or Button) begin
		case (CurrentState)
			// 0. initial:
			STATE_Initial: begin
				Action = Action_Reset;
			end
			// 1. on the 1st floor:
			STATE_Idle_on_1st: begin
				case (Button)
					Button_1U, Button_2U, Button_3U, Button_2D, Button_3D, Button_4D: begin
						Action = Action_Up;
					end
					Button_6_Placeholder, Button_7_Placeholder: begin
						Action = Action_Stay;
					end
					default: begin
						Action = Action_Stay;
					end
				endcase
			end
			// 2. on the 2nd floor:
			STATE_Idle_on_2nd: begin
				case (Button)
					Button_1U, Button_2D: begin
						Action = Action_Down;
					end
					Button_2U, Button_3U, Button_3D, Button_4D: begin
						Action = Action_Up;
					end
					Button_6_Placeholder, Button_7_Placeholder: begin
						Action = Action_Stay;
					end
					default: begin
						Action = Action_Stay;
					end
				endcase				
			end
			// 3. on the 3rd floor:
			STATE_Idle_on_3rd: begin
				case (Button)
					Button_1U, Button_2U, Button_2D, Button_3D: begin
						Action = Action_Down;
					end
					Button_3U, Button_4D: begin
						Action = Action_Up;
					end
					Button_6_Placeholder, Button_7_Placeholder: begin
						Action = Action_Stay;
					end
					default: begin
						Action = Action_Stay;
					end
				endcase		
			end
			// 4. on the 4th floor:
			STATE_Idle_on_4th: begin
				case (Button)
					Button_1U, Button_2U, Button_3U, Button_2D, Button_3D, Button_4D: begin
						Action = Action_Down;
					end	
					Button_6_Placeholder, Button_7_Placeholder: begin
						Action = Action_Stay;
					end
					default: begin
						Action = Action_Stay;
					end
				endcase			
			end
			// ---------
			//	transient states: to terminal 
			// ---------
			STATE_Busy_1st_to_2nd, STATE_Busy_2nd_to_3rd, STATE_Busy_3rd_to_4th: begin
				Action = Action_Up;
			end
			STATE_Busy_2nd_to_1st, STATE_Busy_3rd_to_2nd, STATE_Busy_4th_to_3rd: begin
				Action = Action_Down;
			end
			// ---------
			// place-holder states: stay
			// ---------
			STATE_11_Placeholder, STATE_12_Placeholder, STATE_13_Placeholder, STATE_14_Placeholder, STATE_15_Placeholder: begin
				Action = Action_Reset;
			end
			// ---------
			// default:
			// ---------
			default: begin
				Action = Action_Reset;
			end
		endcase
	end
endmodule

// ---------
// Lift Controller
// ---------
module LiftController(
	input wire Clock,
	input wire Reset,
	input wire [5:0] Input,
	output wire [1:0] Action
);
	// declare internal control nodes:
	wire Done, Empty;
	// declare internal data nodes:
	wire [2:0] Button;
	
	// component 1: input buffer:
	InputBuffer input_buffer(
		.Reset(Reset),
		.Done(Done),
		.Input(Input),
		.Empty(Empty),
		.Button(Button)
	);
	
	// component 2: lift FSM
	LiftFSM lift_fsm(
		.Clock(Clock), 
		.Reset(Reset),
		.Empty(Empty),
		.Button(Button), 
		.Done(Done),
		.Action(Action)		
	);
endmodule