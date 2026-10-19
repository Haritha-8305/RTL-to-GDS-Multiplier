module mult_array(
    input clk,
    input rst_n,
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] p
);

reg [3:0] a_reg;
reg [3:0] b_reg;

wire [3:0] pp0;
wire [3:0] pp1;
wire [3:0] pp2;
wire [3:0] pp3;

wire [3:0] r0;
wire [3:0] r1;
wire [3:0] r2;

wire [3:0] s1;
wire [3:0] s2;
wire [3:0] s3;

wire [4:0] c1;
wire [4:0] c2;
wire [4:0] c3;

wire [7:0] product;

assign pp0=a_reg&{4{b_reg[0]}};
assign pp1=a_reg&{4{b_reg[1]}};
assign pp2=a_reg&{4{b_reg[2]}};
assign pp3=a_reg&{4{b_reg[3]}};

assign product[0]=pp0[0];
assign r0={1'b0,pp0[3:1]};

assign c1[0]=1'b0;
genvar j;
generate
    for(j=0;j<4;j=j+1) begin: row1
        full_adder fa(pp1[j],r0[j],c1[j],s1[j],c1[j+1]);
    end
endgenerate
assign product[1]=s1[0];
assign r1={c1[4],s1[3:1]};

assign c2[0]=1'b0;
generate
    for(j=0;j<4;j=j+1) begin: row2
        full_adder fa(pp2[j],r1[j],c2[j],s2[j],c2[j+1]);
    end
endgenerate
assign product[2]=s2[0];
assign r2={c2[4],s2[3:1]};

assign c3[0]=1'b0;
generate
    for(j=0;j<4;j=j+1) begin: row3
        full_adder fa(pp3[j],r2[j],c3[j],s3[j],c3[j+1]);
    end
endgenerate
assign product[3]=s3[0];
assign product[7:4]={c3[4],s3[3:1]};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        a_reg<=4'b0;
        b_reg<=4'b0;
        p<=8'b0;
    end
    else begin
        a_reg<=a;
        b_reg<=b;
        p<=product;
    end
end

endmodule
