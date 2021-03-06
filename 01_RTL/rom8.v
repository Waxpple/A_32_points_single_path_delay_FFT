module Rom8(
    input clk,
    input rst_n,
    input [5:0] address,
    output reg [21:0] data_real_out,
    output reg [21:0] data_imag_out
);
always@(*)begin
    case (address)
//16 
    6'b010000:begin
//1 
        data_real_out=22'b0000000000000001000000;
//0 
        data_imag_out=22'b0000000000000000000000;
    end
//17 
    6'b010001:begin
//0.92188 
        data_real_out=22'b0000000000000000111011;
//-0.375 
        data_imag_out=22'b1111111111111111101000;
    end
//18 
    6'b010010:begin
//0.70312 
        data_real_out=22'b0000000000000000101101;
//-0.70312 
        data_imag_out=22'b1111111111111111010011;
    end
//19 
    6'b010011:begin
//0.375 
        data_real_out=22'b0000000000000000011000;
//-0.92188 
        data_imag_out=22'b1111111111111111000101;
    end
//20 
    6'b010100:begin
//0 
        data_real_out=22'b0000000000000000000000;
//-1 
        data_imag_out=22'b1111111111111111000000;
    end
//21 
    6'b010101:begin
//-0.375 
        data_real_out=22'b1111111111111111101000;
//-0.92188 
        data_imag_out=22'b1111111111111111000101;
    end
//22 
    6'b010110:begin
//-0.70312 
        data_real_out=22'b1111111111111111010011;
//-0.70312 
        data_imag_out=22'b1111111111111111010011;
    end
//23 
    6'b010111:begin
//-0.92188 
        data_real_out=22'b1111111111111111000101;
//-0.375 
        data_imag_out=22'b1111111111111111101000;
    end
//32 
    6'b100000:begin
//1 
        data_real_out=22'b0000000000000001000000;
//0 
        data_imag_out=22'b0000000000000000000000;
    end
//33 
    6'b100001:begin
//0.92188 
        data_real_out=22'b0000000000000000111011;
//-0.375 
        data_imag_out=22'b1111111111111111101000;
    end
//34 
    6'b100010:begin
//0.70312 
        data_real_out=22'b0000000000000000101101;
//-0.70312 
        data_imag_out=22'b1111111111111111010011;
    end
//35 
    6'b100011:begin
//0.375 
        data_real_out=22'b0000000000000000011000;
//-0.92188 
        data_imag_out=22'b1111111111111111000101;
    end
//36 
    6'b100100:begin
//0 
        data_real_out=22'b0000000000000000000000;
//-1 
        data_imag_out=22'b1111111111111111000000;
    end
//37 
    6'b100101:begin
//-0.375 
        data_real_out=22'b1111111111111111101000;
//-0.92188 
        data_imag_out=22'b1111111111111111000101;
    end
//38 
    6'b100110:begin
//-0.70312 
        data_real_out=22'b1111111111111111010011;
//-0.70312 
        data_imag_out=22'b1111111111111111010011;
    end
//39 
    6'b100111:begin
//-0.92188 
        data_real_out=22'b1111111111111111000101;
//-0.375 
        data_imag_out=22'b1111111111111111101000;
    end
//1 
    default:begin
        data_real_out=23'b0000000000000001000000;
//1 
        data_imag_out=23'b0000000000000000000000;
    end
    endcase
end
endmodule
