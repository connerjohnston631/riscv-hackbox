module memdessertQueue(input clk, input reset,
    output io_enq_ready,
    input  io_enq_valid,
    input [127:0] io_enq_bits_data,
    input [5:0] io_enq_bits_tag,
    input  io_deq_ready,
    output io_deq_valid,
    output[127:0] io_deq_bits_data,
    output[5:0] io_deq_bits_tag,
    output[2:0] io_count
);

  wire[2:0] T0;
  wire[1:0] ptr_diff;
  reg [1:0] R1;
  wire[1:0] T19;
  wire[1:0] T2;
  wire[1:0] T3;
  wire do_deq;
  reg [1:0] R4;
  wire[1:0] T20;
  wire[1:0] T5;
  wire[1:0] T6;
  wire do_enq;
  wire T7;
  wire ptr_match;
  reg  maybe_full;
  wire T21;
  wire T8;
  wire T9;
  wire[5:0] T10;
  wire[133:0] T11;
  reg [133:0] ram [3:0];
  wire[133:0] T12;
  wire[133:0] T13;
  wire[133:0] T14;
  wire[127:0] T15;
  wire T16;
  wire empty;
  wire T17;
  wire T18;
  wire full;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    R1 = {1{$random}};
    R4 = {1{$random}};
    maybe_full = {1{$random}};
    for (initvar = 0; initvar < 4; initvar = initvar+1)
      ram[initvar] = {5{$random}};
  end
// synthesis translate_on
`endif

  assign io_count = T0;
  assign T0 = {T7, ptr_diff};
  assign ptr_diff = R4 - R1;
  assign T19 = reset ? 2'h0 : T2;
  assign T2 = do_deq ? T3 : R1;
  assign T3 = R1 + 2'h1;
  assign do_deq = io_deq_ready & io_deq_valid;
  assign T20 = reset ? 2'h0 : T5;
  assign T5 = do_enq ? T6 : R4;
  assign T6 = R4 + 2'h1;
  assign do_enq = io_enq_ready & io_enq_valid;
  assign T7 = maybe_full & ptr_match;
  assign ptr_match = R4 == R1;
  assign T21 = reset ? 1'h0 : T8;
  assign T8 = T9 ? do_enq : maybe_full;
  assign T9 = do_enq != do_deq;
  assign io_deq_bits_tag = T10;
  assign T10 = T11[3'h5:1'h0];
  assign T11 = ram[R1];
  assign T13 = T14;
  assign T14 = {io_enq_bits_data, io_enq_bits_tag};
  assign io_deq_bits_data = T15;
  assign T15 = T11[8'h85:3'h6];
  assign io_deq_valid = T16;
  assign T16 = empty ^ 1'h1;
  assign empty = ptr_match & T17;
  assign T17 = maybe_full ^ 1'h1;
  assign io_enq_ready = T18;
  assign T18 = full ^ 1'h1;
  assign full = ptr_match & maybe_full;

  always @(posedge clk) begin
    if(reset) begin
      R1 <= 2'h0;
    end else if(do_deq) begin
      R1 <= T3;
    end
    if(reset) begin
      R4 <= 2'h0;
    end else if(do_enq) begin
      R4 <= T6;
    end
    if(reset) begin
      maybe_full <= 1'h0;
    end else if(T9) begin
      maybe_full <= do_enq;
    end
    if (do_enq)
      ram[R4] <= T13;
  end
endmodule

module memdessertMemDesser(input clk, input reset,
    output io_narrow_req_ready,
    input  io_narrow_req_valid,
    input [15:0] io_narrow_req_bits,
    output io_narrow_resp_valid,
    output[15:0] io_narrow_resp_bits,
    input  io_wide_req_cmd_ready,
    output io_wide_req_cmd_valid,
    output[25:0] io_wide_req_cmd_bits_addr,
    output[5:0] io_wide_req_cmd_bits_tag,
    output io_wide_req_cmd_bits_rw,
    input  io_wide_req_data_ready,
    output io_wide_req_data_valid,
    output[127:0] io_wide_req_data_bits_data,
    output io_wide_resp_ready,
    input  io_wide_resp_valid,
    input [127:0] io_wide_resp_bits_data,
    input [5:0] io_wide_resp_bits_tag
);

  wire T0;
  reg [3:0] recv_cnt;
  wire[3:0] T50;
  wire[3:0] T1;
  wire[3:0] T2;
  wire[3:0] T3;
  wire[3:0] T4;
  wire[3:0] T5;
  wire T6;
  wire T7;
  wire T8;
  wire adone;
  wire T9;
  wire T10;
  reg [2:0] state;
  wire[2:0] T51;
  wire[2:0] T11;
  wire[2:0] T12;
  wire[2:0] T13;
  wire[2:0] T14;
  wire[2:0] T15;
  wire[2:0] T16;
  wire[2:0] T17;
  wire T18;
  wire T19;
  wire T20;
  wire T21;
  wire T22;
  wire T23;
  reg [1:0] data_recv_cnt;
  wire[1:0] T52;
  wire[1:0] T24;
  wire[1:0] T25;
  wire[1:0] T26;
  wire[1:0] T27;
  wire T28;
  wire T29;
  wire T30;
  wire ddone;
  wire T31;
  wire T32;
  wire rdone;
  wire T33;
  wire[127:0] T34;
  reg [143:0] in_buf;
  wire[143:0] T35;
  wire[143:0] T36;
  wire[127:0] T37;
  wire T38;
  wire T39;
  wire[47:0] req_cmd;
  wire[5:0] T40;
  wire[25:0] T41;
  wire T42;
  wire[15:0] T53;
  wire[133:0] T43;
  wire[8:0] T44;
  wire[133:0] T45;
  wire[133:0] T46;
  wire T47;
  wire T48;
  wire T49;
  wire dataq_io_enq_ready;
  wire dataq_io_deq_valid;
  wire[127:0] dataq_io_deq_bits_data;
  wire[5:0] dataq_io_deq_bits_tag;

`ifndef SYNTHESIS
// synthesis translate_off
  integer initvar;
  initial begin
    #0.002;
    recv_cnt = {1{$random}};
    state = {1{$random}};
    data_recv_cnt = {1{$random}};
    in_buf = {5{$random}};
  end
// synthesis translate_on
`endif

  assign T0 = recv_cnt == 4'h8;
  assign T50 = reset ? 4'h0 : T1;
  assign T1 = rdone ? 4'h0 : T2;
  assign T2 = T30 ? 4'h0 : T3;
  assign T3 = T8 ? 4'h0 : T4;
  assign T4 = T6 ? T5 : recv_cnt;
  assign T5 = recv_cnt + 4'h1;
  assign T6 = T7 | io_narrow_resp_valid;
  assign T7 = io_narrow_req_valid & io_narrow_req_ready;
  assign T8 = T10 & adone;
  assign adone = io_narrow_req_valid & T9;
  assign T9 = recv_cnt == 4'h2;
  assign T10 = state == 3'h0;
  assign T51 = reset ? 3'h0 : T11;
  assign T11 = T28 ? 3'h0 : T12;
  assign T12 = T22 ? 3'h0 : T13;
  assign T13 = T20 ? 3'h2 : T14;
  assign T14 = T30 ? 3'h3 : T15;
  assign T15 = T18 ? T17 : T16;
  assign T16 = T8 ? 3'h1 : state;
  assign T17 = io_wide_req_cmd_bits_rw ? 3'h2 : 3'h4;
  assign T18 = T19 & io_wide_req_cmd_ready;
  assign T19 = state == 3'h1;
  assign T20 = T21 & io_wide_req_data_ready;
  assign T21 = state == 3'h3;
  assign T22 = T20 & T23;
  assign T23 = data_recv_cnt == 2'h3;
  assign T52 = reset ? 2'h0 : T24;
  assign T24 = rdone ? T27 : T25;
  assign T25 = T20 ? T26 : data_recv_cnt;
  assign T26 = data_recv_cnt + 2'h1;
  assign T27 = data_recv_cnt + 2'h1;
  assign T28 = rdone & T29;
  assign T29 = data_recv_cnt == 2'h3;
  assign T30 = T32 & ddone;
  assign ddone = io_narrow_req_valid & T31;
  assign T31 = recv_cnt == 4'h7;
  assign T32 = state == 3'h2;
  assign rdone = io_narrow_resp_valid & T33;
  assign T33 = recv_cnt == 4'h8;
  assign io_wide_resp_ready = dataq_io_enq_ready;
  assign io_wide_req_data_bits_data = T34;
  assign T34 = in_buf >> 5'h10;
  assign T35 = T6 ? T36 : in_buf;
  assign T36 = {io_narrow_req_bits, T37};
  assign T37 = in_buf[8'h8f:5'h10];
  assign io_wide_req_data_valid = T38;
  assign T38 = state == 3'h3;
  assign io_wide_req_cmd_bits_rw = T39;
  assign T39 = req_cmd[1'h0:1'h0];
  assign req_cmd = in_buf >> 7'h60;
  assign io_wide_req_cmd_bits_tag = T40;
  assign T40 = req_cmd[3'h6:1'h1];
  assign io_wide_req_cmd_bits_addr = T41;
  assign T41 = req_cmd[6'h20:3'h7];
  assign io_wide_req_cmd_valid = T42;
  assign T42 = state == 3'h1;
  assign io_narrow_resp_bits = T53;
  assign T53 = T43[4'hf:1'h0];
  assign T43 = T45 >> T44;
  assign T44 = recv_cnt * 5'h10;
  assign T45 = T46;
  assign T46 = {dataq_io_deq_bits_data, dataq_io_deq_bits_tag};
  assign io_narrow_resp_valid = dataq_io_deq_valid;
  assign io_narrow_req_ready = T47;
  assign T47 = T49 | T48;
  assign T48 = state == 3'h2;
  assign T49 = state == 3'h0;
  memdessertQueue dataq(.clk(clk), .reset(reset),
       .io_enq_ready( dataq_io_enq_ready ),
       .io_enq_valid( io_wide_resp_valid ),
       .io_enq_bits_data( io_wide_resp_bits_data ),
       .io_enq_bits_tag( io_wide_resp_bits_tag ),
       .io_deq_ready( T0 ),
       .io_deq_valid( dataq_io_deq_valid ),
       .io_deq_bits_data( dataq_io_deq_bits_data ),
       .io_deq_bits_tag( dataq_io_deq_bits_tag )
       //.io_count(  )
  );

  always @(posedge clk) begin
    if(reset) begin
      recv_cnt <= 4'h0;
    end else if(rdone) begin
      recv_cnt <= 4'h0;
    end else if(T30) begin
      recv_cnt <= 4'h0;
    end else if(T8) begin
      recv_cnt <= 4'h0;
    end else if(T6) begin
      recv_cnt <= T5;
    end
    if(reset) begin
      state <= 3'h0;
    end else if(T28) begin
      state <= 3'h0;
    end else if(T22) begin
      state <= 3'h0;
    end else if(T20) begin
      state <= 3'h2;
    end else if(T30) begin
      state <= 3'h3;
    end else if(T18) begin
      state <= T17;
    end else if(T8) begin
      state <= 3'h1;
    end
    if(reset) begin
      data_recv_cnt <= 2'h0;
    end else if(rdone) begin
      data_recv_cnt <= T27;
    end else if(T20) begin
      data_recv_cnt <= T26;
    end
    if(T6) begin
      in_buf <= T36;
    end
  end
endmodule

module memdessertMemDessert(input clk, input reset,
    output io_narrow_req_ready,
    input  io_narrow_req_valid,
    input [15:0] io_narrow_req_bits,
    output io_narrow_resp_valid,
    output[15:0] io_narrow_resp_bits,
    input  io_wide_req_cmd_ready,
    output io_wide_req_cmd_valid,
    output[25:0] io_wide_req_cmd_bits_addr,
    output[5:0] io_wide_req_cmd_bits_tag,
    output io_wide_req_cmd_bits_rw,
    input  io_wide_req_data_ready,
    output io_wide_req_data_valid,
    output[127:0] io_wide_req_data_bits_data,
    output io_wide_resp_ready,
    input  io_wide_resp_valid,
    input [127:0] io_wide_resp_bits_data,
    input [5:0] io_wide_resp_bits_tag
);

  wire x_io_narrow_req_ready;
  wire x_io_narrow_resp_valid;
  wire[15:0] x_io_narrow_resp_bits;
  wire x_io_wide_req_cmd_valid;
  wire[25:0] x_io_wide_req_cmd_bits_addr;
  wire[5:0] x_io_wide_req_cmd_bits_tag;
  wire x_io_wide_req_cmd_bits_rw;
  wire x_io_wide_req_data_valid;
  wire[127:0] x_io_wide_req_data_bits_data;
  wire x_io_wide_resp_ready;


  assign io_wide_resp_ready = x_io_wide_resp_ready;
  assign io_wide_req_data_bits_data = x_io_wide_req_data_bits_data;
  assign io_wide_req_data_valid = x_io_wide_req_data_valid;
  assign io_wide_req_cmd_bits_rw = x_io_wide_req_cmd_bits_rw;
  assign io_wide_req_cmd_bits_tag = x_io_wide_req_cmd_bits_tag;
  assign io_wide_req_cmd_bits_addr = x_io_wide_req_cmd_bits_addr;
  assign io_wide_req_cmd_valid = x_io_wide_req_cmd_valid;
  assign io_narrow_resp_bits = x_io_narrow_resp_bits;
  assign io_narrow_resp_valid = x_io_narrow_resp_valid;
  assign io_narrow_req_ready = x_io_narrow_req_ready;
  memdessertMemDesser x(.clk(clk), .reset(reset),
       .io_narrow_req_ready( x_io_narrow_req_ready ),
       .io_narrow_req_valid( io_narrow_req_valid ),
       .io_narrow_req_bits( io_narrow_req_bits ),
       .io_narrow_resp_valid( x_io_narrow_resp_valid ),
       .io_narrow_resp_bits( x_io_narrow_resp_bits ),
       .io_wide_req_cmd_ready( io_wide_req_cmd_ready ),
       .io_wide_req_cmd_valid( x_io_wide_req_cmd_valid ),
       .io_wide_req_cmd_bits_addr( x_io_wide_req_cmd_bits_addr ),
       .io_wide_req_cmd_bits_tag( x_io_wide_req_cmd_bits_tag ),
       .io_wide_req_cmd_bits_rw( x_io_wide_req_cmd_bits_rw ),
       .io_wide_req_data_ready( io_wide_req_data_ready ),
       .io_wide_req_data_valid( x_io_wide_req_data_valid ),
       .io_wide_req_data_bits_data( x_io_wide_req_data_bits_data ),
       .io_wide_resp_ready( x_io_wide_resp_ready ),
       .io_wide_resp_valid( io_wide_resp_valid ),
       .io_wide_resp_bits_data( io_wide_resp_bits_data ),
       .io_wide_resp_bits_tag( io_wide_resp_bits_tag )
  );
endmodule

