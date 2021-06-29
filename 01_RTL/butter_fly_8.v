module butter_fly_8(
    input clk,
    input rst_n,
    input in_valid,
    input signed[21:0] data_in_real,
    input signed[21:0] data_in_imag,
    input signed[21:0] wnr_in_real,
    input signed[21:0] wnr_in_imag,
    input signed[21:0] data_in_delay_real,
    input signed[21:0] data_in_delay_imag,
    output [5:0] counter,
    output reg out_valid,
    output reg signed[21:0] data_out_delay_real,
    output reg signed[21:0] data_out_delay_imag,
    output reg signed[21:0] data_out_real,
    output reg signed[21:0] data_out_imag
);
reg valid,nxt_valid;
reg [5:0] nxt_counter;
reg [1:0] curr_state;
reg [1:0] next_state;
reg [5:0] reg_counter;
wire signed [45:0] temp_real,temp_imag;
//wire signed [45:0] temp_common;
//assign temp_common = data_in_delay_imag *(wnr_in_real-wnr_in_imag);
assign temp_real = wnr_in_real*data_in_delay_real - wnr_in_imag*data_in_delay_imag;
assign temp_imag = wnr_in_real*data_in_delay_imag + wnr_in_imag*data_in_delay_real;
assign counter = reg_counter;
always@(*)begin
    nxt_valid = (reg_counter<38)?valid:'d0;
    nxt_counter = (valid || in_valid)?reg_counter + 'd1:reg_counter;
end

always@(*)begin
    case (curr_state)//synopsys full_case
    2'b00: begin
        data_out_delay_real = data_in_real;
        data_out_delay_imag = data_in_imag;
        data_out_real = data_in_delay_real;
        data_out_imag = data_in_delay_imag;
        out_valid = 'd0;
        next_state = ((reg_counter%24) <7)?2'b00:2'b01;
    end
    2'b01: begin
        data_out_delay_real = data_in_delay_real - data_in_real;
        data_out_delay_imag = data_in_delay_imag - data_in_imag;
        data_out_real = data_in_delay_real + data_in_real;
        data_out_imag = data_in_delay_imag + data_in_imag;
        out_valid = 'd1;
        next_state = ((reg_counter%24) <15)? (reg_counter==31)?2'b10:2'b01   :2'b10;
    end
    2'b10:begin
        data_out_delay_real = data_in_real;
        data_out_delay_imag = data_in_imag;
        data_out_real = temp_real[29:6];
        data_out_imag = temp_imag[29:6];
        out_valid = 'd1;
        next_state = ((reg_counter%'d24) <23)?(reg_counter=='d39)?2'b11:2'b10:(reg_counter==23)?2'b01:2'b11;
    end
    2'b11:begin
        next_state = 2'b11;
        data_out_delay_real = 'd0;
        data_out_delay_imag = 'd0;
        data_out_real = 'd0;
        data_out_imag = 'd0;
        out_valid = 'd0;
    end
    default:begin
        next_state = 2'b11;
        data_out_delay_real = 'd0;
        data_out_delay_imag = 'd0;
        data_out_real = 'd0;
        data_out_imag = 'd0;
        out_valid = 'd0;
    end
    
    endcase
end


always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        reg_counter <= 0;
        valid <= 0;
        curr_state <= 0;
    end
    else begin
        if(in_valid)begin
            reg_counter <= nxt_counter;
            valid <= in_valid;
            curr_state <= next_state;

        end
        else if(valid)begin
            reg_counter <= nxt_counter;
            valid <= nxt_valid;
            curr_state <= next_state;
        end
        else if(next_state == 2'b11)begin
            curr_state <= 2'b11;
        end
  
    end
end
endmodule

