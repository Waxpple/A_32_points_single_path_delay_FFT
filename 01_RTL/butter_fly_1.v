module butter_fly_1(
    input clk,
    input rst_n,
    input in_valid,
    input signed[21:0] data_in_real,
    input signed[21:0] data_in_imag,
    input signed[21:0] data_in_delay_real,
    input signed[21:0] data_in_delay_imag,
    output [5:0] counter,
    output reg out_valid,
    output reg signed[21:0] data_out_delay_real,
    output reg signed[21:0] data_out_delay_imag,
    output signed[15:0] data_out_real,
    output signed[15:0] data_out_imag
);
reg valid,nxt_valid;
reg [1:0] curr_state;
reg [1:0] next_state;
reg [5:0] reg_counter;
reg [5:0] nxt_counter;
reg [22:0] reg_data_out_real,reg_data_out_imag;
assign counter = reg_counter;
assign data_out_real = reg_data_out_real[21:6];
assign data_out_imag = reg_data_out_imag[21:6];


always@(*)begin
    nxt_valid = (reg_counter<31)?valid:'d0;
    nxt_counter = (valid || in_valid)?reg_counter + 'd1:reg_counter;
end

always@(*)begin
    case (curr_state)//synopsys full_case
    2'b00: begin
        data_out_delay_real = data_in_real;
        data_out_delay_imag = data_in_imag;
        reg_data_out_real = data_in_delay_real;
        reg_data_out_imag = data_in_delay_imag;
        out_valid = 'd0;
        next_state = 2'b01;
    end
    2'b01: begin
        data_out_delay_real = data_in_delay_real - data_in_real;
        data_out_delay_imag = data_in_delay_imag - data_in_imag;
        reg_data_out_real = data_in_delay_real + data_in_real;
        reg_data_out_imag = data_in_delay_imag + data_in_imag;
        out_valid = 'd1;
        next_state = 2'b10;
    end
    2'b10:begin
        data_out_delay_real = data_in_real;
        data_out_delay_imag = data_in_imag;
        reg_data_out_real = data_in_delay_real;
        reg_data_out_imag = data_in_delay_imag;
        out_valid = 'd1;
        next_state = (reg_counter==32)?2'b11:2'b01;
    end
    2'b11:begin
        next_state = 2'b11;
        data_out_delay_real = 'd0;
        data_out_delay_imag = 'd0;
        reg_data_out_real = 'd0;
        reg_data_out_imag = 'd0;
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



