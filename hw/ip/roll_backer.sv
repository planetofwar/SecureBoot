module roll_backer
(
  input  clk_i,
  input  rst_ni,
  input  logic [31:0] input_main_core_prf,
  input  logic [31:0] input_shadow_core_prf,
  input  logic comperator_mismatch,
  output logic [31:0] output_main_core_prf,
  output logic [31:0] output_shadow_core_prf
);
logic [31:0] main_saved_data;  // Declare a variable to hold the saved data
logic [31:0] shadow_saved_data;
logic [5:0] count = 0;    // Declare a counter variable to count 50 clock cycles
// typedef enum logic [2:0] {idle_state, save_state, load_safe_state} state_t;  // Define the state type as an enumerated type
// state_t current_state, next_state;


  always_ff @(posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin  // Asynchronous reset
      main_saved_data <= 0; // Initialize the saved data to 0
      shadow_saved_data <= 0;
      count <= 0;       // Reset the counter to 0
    end
    else begin
      if(count == 49) begin  // If 50 clock cycles have elapsed
        count <= 0; // Reset the counter to 0
        if(comperator_mismatch == 0) begin
            main_saved_data <= input_main_core_prf;
            shadow_saved_data <= input_shadow_core_prf;    
        end                  
      end
      else begin
        count <= count + 1;        // Increment the counter
      end
    end
  end
  
  
  assign output_main_core_prf = main_saved_data;  // Assign the saved data to the output  
  assign output_shadow_core_prf = shadow_saved_data;


input logic clk,
input logic rst_n,
input logic event,
output logic [1:0] fsm_output

  state_t current_state, next_state;  // Declare the current and next state variables
  
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin  // Asynchronous reset
      current_state <= STATE_A;  // Initialize the current state to STATE_A
    end
    else begin
      current_state <= next_state;  // Update the current state to the next state
    end
  end
  
  always_comb begin
    case(current_state)
      save_state: begin
        if(comperator_mismatch == 0) begin
          next_state = STATE_B;
        end
        else begin
          next_state = STATE_A;
        end
      end
      STATE_B: begin
        if(event) begin
          next_state = STATE_C;
        end
        else begin
          next_state = STATE_A;
        end
      end
      STATE_C: begin
        if(event) begin
          next_state = STATE_A;
        end
        else begin
          next_state = STATE_B;
        end
      end
      default: begin
        next_state = STATE_A;  // Default case: Go to STATE_A if current state is invalid
      end
    endcase
  end
  
  assign fsm_output = current_state;  // Assign the current state to the output

endmodule