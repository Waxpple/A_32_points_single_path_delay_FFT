module shift_register_8(
    input clk,
    input in_valid,
    input rst_n,
    input signed [21:0] data_real_in,
    input signed [21:0] data_imag_in,
    output signed [21:0] data_real_out,
    output signed [21:0] data_imag_out
);
reg [5:0] nxt_counter,counter;
reg valid,nxt_valid;

reg [175:0] shift_register_real,shift_register_imag;
reg [175:0] t_shift_register_real,t_shift_register_imag;
assign data_real_out = shift_register_real[175:154];
assign data_imag_out = shift_register_imag[175:154];


always@(*)begin
    nxt_valid = (counter<38)?valid:'d0;
    nxt_counter = (valid || in_valid)?counter + 'd1:counter;
    t_shift_register_real = shift_register_real;
    t_shift_register_imag = shift_register_imag;
end


always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        counter <= 0;
        valid <= 0;
        shift_register_real <= 0;
        shift_register_imag <= 0;
    end
    else begin
        if(in_valid)begin
            shift_register_real <= (t_shift_register_real<<22) + data_real_in;
            shift_register_imag <= (t_shift_register_imag<<22) + data_imag_in;
            counter <= nxt_counter;
            valid <= in_valid;

        end
        else if(valid)begin
            shift_register_real <= (t_shift_register_real<<22) + data_real_in;
            shift_register_imag <= (t_shift_register_imag<<22) + data_imag_in;
            counter <= nxt_counter;
            valid <= nxt_valid;
        end
    end
end
endmodule


