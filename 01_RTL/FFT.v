`include "butter_fly_1.v"
`include "butter_fly_2.v"
`include "butter_fly_4.v"
`include "butter_fly_8.v"
`include "butter_fly_16.v"
`include "rom2.v"
`include "rom4.v"
`include "rom8.v"
`include "rom16.v"
`include "shift_register_1.v"
`include "shift_register_2.v"
`include "shift_register_4.v"
`include "shift_register_8.v"
`include "shift_register_16.v"
module FFT(
input clk,
input rst_n,
input in_valid,
input signed [11:0] din_r,
input signed [11:0] din_i,
output out_valid,
output signed [15:0] dout_r,
output signed [15:0] dout_i
);


wire signed [21:0] data_real_in_16,data_imag_in_16;
wire signed [21:0] data_real_in_8,data_imag_in_8;
wire signed [21:0] data_real_in_4,data_imag_in_4;
wire signed [21:0] data_real_in_2,data_imag_in_2;
wire signed [21:0] data_real_in_1,data_imag_in_1;

wire signed [21:0] stage5_data_real_out,stage5_data_imag_out;
wire signed [21:0] stage4_data_real_out,stage4_data_imag_out;
wire signed [21:0] stage3_data_real_out,stage3_data_imag_out;
wire signed [21:0] stage2_data_real_out,stage2_data_imag_out;
wire signed [15:0] stage1_data_real_out,stage1_data_imag_out;

wire signed [21:0] data_real_out_16,data_imag_out_16;
wire signed [21:0] data_real_out_8,data_imag_out_8;
wire signed [21:0] data_real_out_4,data_imag_out_4;
wire signed [21:0] data_real_out_2,data_imag_out_2;
wire signed [21:0] data_real_out_1,data_imag_out_1;

wire signed [21:0] wnr_real_out_16,wnr_imag_out_16;
wire signed [21:0] wnr_real_out_8,wnr_imag_out_8;
wire signed [21:0] wnr_real_out_4,wnr_imag_out_4;
wire signed [21:0] wnr_real_out_2,wnr_imag_out_2;
wire signed [21:0] wnr_real_out_1,wnr_imag_out_1;


reg signed [21:0] reg_din_r,reg_din_i;
reg reg_valid;
reg reg_valid_16;
reg reg_valid_8;
reg reg_valid_4;
reg reg_valid_2;
reg reg_valid_1;
wire [5:0] counter_16,counter_8,counter_4,counter_2,counter_1;
wire [4:0] counter;
assign counter = counter_1[4:0]-1;
wire out_valid_16,out_valid_8,out_valid_4,out_valid_2,out_valid_1;

reg reg_out_valid;
reg signed [15:0] r_dout_r,r_dout_i;
assign out_valid = reg_out_valid;
assign dout_r = r_dout_r;
assign dout_i = r_dout_i;

reg signed [21:0] reg_stage5_data_real_out,reg_stage5_data_imag_out;
reg signed [21:0] reg_stage4_data_real_out,reg_stage4_data_imag_out;
reg signed [21:0] reg_stage3_data_real_out,reg_stage3_data_imag_out;
reg signed [21:0] reg_stage2_data_real_out,reg_stage2_data_imag_out;
reg signed [15:0] reg_stage1_data_real_out,reg_stage1_data_imag_out;



reg signed [15:0] reg_dout_r[0:31];
reg signed [15:0] reg_dout_i[0:31];

reg [4:0] nxt_output_counter,output_counter;
reg ordering_done;

always @(*) begin
    nxt_output_counter = output_counter + 'd1;
end
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        reg_din_r <= 'd0;
        reg_din_i <= 'd0;
        reg_valid <= 'd0;
        reg_valid_16 <= 'd0;
        reg_valid_8 <= 'd0;
        reg_valid_4 <= 'd0;
        reg_valid_2 <= 'd0;
        reg_valid_1 <= 'd0;
        reg_out_valid <= 'd0;
        r_dout_r <= 'd0;
        r_dout_i <= 'd0;
        reg_stage5_data_real_out <= 'd0;
        reg_stage5_data_imag_out <= 'd0;
        reg_stage4_data_real_out <= 'd0;
        reg_stage4_data_imag_out <= 'd0;
        reg_stage3_data_real_out <= 'd0;
        reg_stage3_data_imag_out <= 'd0;
        reg_stage2_data_real_out <= 'd0;
        reg_stage2_data_imag_out <= 'd0;
        reg_stage1_data_real_out <= 'd0;
        reg_stage1_data_imag_out <= 'd0;
        output_counter <= 'd0;
    end
    else begin
        reg_din_r <= { {4{din_r[11]}}, din_r, 6'b0};
        reg_din_i <= { {4{din_i[11]}}, din_i, 6'b0};
        reg_valid <= in_valid;
        reg_valid_16 <= out_valid_16;
        reg_valid_8 <= out_valid_8;
        reg_valid_4 <= out_valid_4;
        reg_valid_2 <= out_valid_2;
        reg_valid_1 <= out_valid_1;
        reg_stage5_data_real_out <= stage5_data_real_out;
        reg_stage5_data_imag_out <= stage5_data_imag_out;
        reg_stage4_data_real_out <= stage4_data_real_out;
        reg_stage4_data_imag_out <= stage4_data_imag_out;
        reg_stage3_data_real_out <= stage3_data_real_out;
        reg_stage3_data_imag_out <= stage3_data_imag_out;
        reg_stage2_data_real_out <= stage2_data_real_out;
        reg_stage2_data_imag_out <= stage2_data_imag_out;
        reg_stage1_data_real_out <= stage1_data_real_out;
        reg_stage1_data_imag_out <= stage1_data_imag_out;

        if(ordering_done)begin
            r_dout_r <= reg_dout_r[output_counter];
            r_dout_i <= reg_dout_i[output_counter];
            output_counter <= nxt_output_counter;
            reg_out_valid <= 1'd1;
        end
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        ordering_done <= 'd0;
         reg_dout_r[0]<='d0;
         reg_dout_i[0]<='d0;
         reg_dout_r[16]<='d0;
         reg_dout_i[16]<='d0;
         reg_dout_r[8]<='d0;
         reg_dout_i[8]<='d0;
         reg_dout_r[24]<='d0;
         reg_dout_i[24]<='d0;
         reg_dout_r[4]<='d0;
         reg_dout_i[4]<='d0;
         reg_dout_r[20]<='d0;
         reg_dout_i[20]<='d0;
         reg_dout_r[12]<='d0;
         reg_dout_i[12]<='d0;
         reg_dout_r[28]<='d0;
         reg_dout_i[28]<='d0;
         reg_dout_r[2]<='d0;
         reg_dout_i[2]<='d0;
         reg_dout_r[18]<='d0;
         reg_dout_i[18]<='d0;
         reg_dout_r[10]<='d0;
         reg_dout_i[10]<='d0;
         reg_dout_r[26]<='d0;
         reg_dout_i[26]<='d0;
         reg_dout_r[6]<='d0;
         reg_dout_i[6]<='d0;
         reg_dout_r[22]<='d0;
         reg_dout_i[22]<='d0;
         reg_dout_r[14]<='d0;
         reg_dout_i[14]<='d0;
         reg_dout_r[30]<='d0;
         reg_dout_i[30]<='d0;
         reg_dout_r[1]<='d0;
         reg_dout_i[1]<='d0;
         reg_dout_r[17]<='d0;
         reg_dout_i[17]<='d0;
         reg_dout_r[9]<='d0;
         reg_dout_i[9]<='d0;
         reg_dout_r[25]<='d0;
         reg_dout_i[25]<='d0;
         reg_dout_r[5]<='d0;
         reg_dout_i[5]<='d0;
         reg_dout_r[21]<='d0;
         reg_dout_i[21]<='d0;
         reg_dout_r[13]<='d0;
         reg_dout_i[13]<='d0;
         reg_dout_r[29]<='d0;
         reg_dout_i[29]<='d0;
         reg_dout_r[3]<='d0;
         reg_dout_i[3]<='d0;
         reg_dout_r[19]<='d0;
         reg_dout_i[19]<='d0;
         reg_dout_r[11]<='d0;
         reg_dout_i[11]<='d0;
         reg_dout_r[27]<='d0;
         reg_dout_i[27]<='d0;
         reg_dout_r[7]<='d0;
         reg_dout_i[7]<='d0;
         reg_dout_r[23]<='d0;
         reg_dout_i[23]<='d0;
         reg_dout_r[15]<='d0;
         reg_dout_i[15]<='d0;
         reg_dout_r[31]<='d0;
         reg_dout_i[31]<='d0;
    end
    else begin
    if (counter_1 >0 && counter_1<33)begin
    case(counter)//synopsys full_case
        5'b00000:begin
         reg_dout_r[0]<=stage1_data_real_out;
         reg_dout_i[0]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b00001:begin
         reg_dout_r[16]<=stage1_data_real_out;
         reg_dout_i[16]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b00010:begin
         reg_dout_r[8]<=stage1_data_real_out;
         reg_dout_i[8]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b00011:begin
         reg_dout_r[24]<=stage1_data_real_out;
         reg_dout_i[24]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b00100:begin
         reg_dout_r[4]<=stage1_data_real_out;
         reg_dout_i[4]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b00101:begin
         reg_dout_r[20]<=stage1_data_real_out;
         reg_dout_i[20]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b00110:begin
         reg_dout_r[12]<=stage1_data_real_out;
         reg_dout_i[12]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b00111:begin
         reg_dout_r[28]<=stage1_data_real_out;
         reg_dout_i[28]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b01000:begin
         reg_dout_r[2]<=stage1_data_real_out;
         reg_dout_i[2]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b01001:begin
         reg_dout_r[18]<=stage1_data_real_out;
         reg_dout_i[18]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b01010:begin
         reg_dout_r[10]<=stage1_data_real_out;
         reg_dout_i[10]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b01011:begin
         reg_dout_r[26]<=stage1_data_real_out;
         reg_dout_i[26]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b01100:begin
         reg_dout_r[6]<=stage1_data_real_out;
         reg_dout_i[6]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b01101:begin
         reg_dout_r[22]<=stage1_data_real_out;
         reg_dout_i[22]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b01110:begin
         reg_dout_r[14]<=stage1_data_real_out;
         reg_dout_i[14]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b01111:begin
         reg_dout_r[30]<=stage1_data_real_out;
         reg_dout_i[30]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b10000:begin
         reg_dout_r[1]<=stage1_data_real_out;
         reg_dout_i[1]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b10001:begin
         reg_dout_r[17]<=stage1_data_real_out;
         reg_dout_i[17]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b10010:begin
         reg_dout_r[9]<=stage1_data_real_out;
         reg_dout_i[9]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b10011:begin
         reg_dout_r[25]<=stage1_data_real_out;
         reg_dout_i[25]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b10100:begin
         reg_dout_r[5]<=stage1_data_real_out;
         reg_dout_i[5]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b10101:begin
         reg_dout_r[21]<=stage1_data_real_out;
         reg_dout_i[21]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b10110:begin
         reg_dout_r[13]<=stage1_data_real_out;
         reg_dout_i[13]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b10111:begin
         reg_dout_r[29]<=stage1_data_real_out;
         reg_dout_i[29]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b11000:begin
         reg_dout_r[3]<=stage1_data_real_out;
         reg_dout_i[3]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b11001:begin
         reg_dout_r[19]<=stage1_data_real_out;
         reg_dout_i[19]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b11010:begin
         reg_dout_r[11]<=stage1_data_real_out;
         reg_dout_i[11]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b11011:begin
         reg_dout_r[27]<=stage1_data_real_out;
         reg_dout_i[27]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b11100:begin
         reg_dout_r[7]<=stage1_data_real_out;
         reg_dout_i[7]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b11101:begin
         reg_dout_r[23]<=stage1_data_real_out;
         reg_dout_i[23]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b11110:begin
         reg_dout_r[15]<=stage1_data_real_out;
         reg_dout_i[15]<=stage1_data_imag_out;
         ordering_done <= 'd0;
         end
        5'b11111:begin
         reg_dout_r[31]<=stage1_data_real_out;
         reg_dout_i[31]<=stage1_data_imag_out;
         ordering_done <= 'd1;
         end
    endcase
    end
    end
end
//==== module======







butter_fly_16 butter16(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(reg_valid),
    .data_in_real(reg_din_r),
    .data_in_imag(reg_din_i),
    .wnr_in_real(wnr_real_out_16),
    .wnr_in_imag(wnr_imag_out_16),
    .data_in_delay_real(data_real_out_16),
    .data_in_delay_imag(data_imag_out_16),
    .out_valid(out_valid_16),
    .counter(counter_16),
    .data_out_delay_real(data_real_in_16),
    .data_out_delay_imag(data_imag_in_16),
    .data_out_real(stage5_data_real_out),
    .data_out_imag(stage5_data_imag_out)
);

Rom16 rom16(
    .clk(clk),
    .rst_n(rst_n),
    .address(counter_16),
    .data_real_out(wnr_real_out_16),
    .data_imag_out(wnr_imag_out_16)
);
shift_register_16 SR16 (
    .clk(clk),
    .in_valid(reg_valid),
    .rst_n(rst_n),
    .data_real_in(data_real_in_16),
    .data_imag_in(data_imag_in_16),
    .data_real_out(data_real_out_16),
    .data_imag_out(data_imag_out_16)
    
    );



butter_fly_8 butter8(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(reg_valid_16),
    .data_in_real(reg_stage5_data_real_out),
    .data_in_imag(reg_stage5_data_imag_out),
    .wnr_in_real(wnr_real_out_8),
    .wnr_in_imag(wnr_imag_out_8),
    .data_in_delay_real(data_real_out_8),
    .data_in_delay_imag(data_imag_out_8),
    .out_valid(out_valid_8),
    .counter(counter_8),
    .data_out_delay_real(data_real_in_8),
    .data_out_delay_imag(data_imag_in_8),
    .data_out_real(stage4_data_real_out),
    .data_out_imag(stage4_data_imag_out)
);
Rom8 rom8(
    .clk(clk),
    .rst_n(rst_n),
    .address(counter_8),
    .data_real_out(wnr_real_out_8),
    .data_imag_out(wnr_imag_out_8)
);
shift_register_8 SR8 (
    .clk(clk),
    .in_valid(reg_valid_16),
    .rst_n(rst_n),
    .data_real_in(data_real_in_8),
    .data_imag_in(data_imag_in_8),
    .data_real_out(data_real_out_8),
    .data_imag_out(data_imag_out_8)
    
    );
butter_fly_4 butter4(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(reg_valid_8),
    .data_in_real(reg_stage4_data_real_out),
    .data_in_imag(reg_stage4_data_imag_out),
    .wnr_in_real(wnr_real_out_4),
    .wnr_in_imag(wnr_imag_out_4),
    .data_in_delay_real(data_real_out_4),
    .data_in_delay_imag(data_imag_out_4),
    .out_valid(out_valid_4),
    .counter(counter_4),
    .data_out_delay_real(data_real_in_4),
    .data_out_delay_imag(data_imag_in_4),
    .data_out_real(stage3_data_real_out),
    .data_out_imag(stage3_data_imag_out)
);
shift_register_4 SR4 (
    .clk(clk),
    .in_valid(reg_valid_8),
    .rst_n(rst_n),
    .data_real_in(data_real_in_4),
    .data_imag_in(data_imag_in_4),
    .data_real_out(data_real_out_4),
    .data_imag_out(data_imag_out_4)
    
    );
Rom4 rom4(
    .clk(clk),
    .rst_n(rst_n),
    .address(counter_4),
    .data_real_out(wnr_real_out_4),
    .data_imag_out(wnr_imag_out_4)
);


butter_fly_2 butter2(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(reg_valid_4),
    .data_in_real(reg_stage3_data_real_out),
    .data_in_imag(reg_stage3_data_imag_out),
    .wnr_in_real(wnr_real_out_2),
    .wnr_in_imag(wnr_imag_out_2),
    .data_in_delay_real(data_real_out_2),
    .data_in_delay_imag(data_imag_out_2),
    .out_valid(out_valid_2),
    .counter(counter_2),
    .data_out_delay_real(data_real_in_2),
    .data_out_delay_imag(data_imag_in_2),
    .data_out_real(stage2_data_real_out),
    .data_out_imag(stage2_data_imag_out)
);
shift_register_2 SR2 (
    .clk(clk),
    .in_valid(reg_valid_4),
    .rst_n(rst_n),
    .data_real_in(data_real_in_2),
    .data_imag_in(data_imag_in_2),
    .data_real_out(data_real_out_2),
    .data_imag_out(data_imag_out_2)
    
    );
Rom2 rom2(
    .clk(clk),
    .rst_n(rst_n),
    .address(counter_2),
    .data_real_out(wnr_real_out_2),
    .data_imag_out(wnr_imag_out_2)
);

butter_fly_1 butter1(
    .clk(clk),
    .rst_n(rst_n),
    .in_valid(reg_valid_2),
    .data_in_real(reg_stage2_data_real_out),
    .data_in_imag(reg_stage2_data_imag_out),
    .data_in_delay_real(data_real_out_1),
    .data_in_delay_imag(data_imag_out_1),
    .out_valid(out_valid_1),
    .counter(counter_1),
    .data_out_delay_real(data_real_in_1),
    .data_out_delay_imag(data_imag_in_1),
    .data_out_real(stage1_data_real_out),
    .data_out_imag(stage1_data_imag_out)
);
shift_register_1 SR1 (
    .clk(clk),
    .in_valid(reg_valid_2),
    .rst_n(rst_n),
    .data_real_in(data_real_in_1),
    .data_imag_in(data_imag_in_1),
    .data_real_out(data_real_out_1),
    .data_imag_out(data_imag_out_1)
    
    );


endmodule



