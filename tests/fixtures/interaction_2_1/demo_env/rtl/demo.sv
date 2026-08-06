module demo #(
  parameter WIDTH = 8
)(
  clk,
  reset_n,
  demo_in,
  demo_out
);

input                  clk;
input                  reset_n;
input      [WIDTH-1:0] demo_in;
output     [WIDTH-1:0] demo_out;

assign demo_out = demo_in;

endmodule
