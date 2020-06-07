module pc_reg(input clk,rst,pc_write,input [31:0] in,output reg[31:0] out);
  always@(posedge clk,posedge rst)begin
    if(rst)
      out<=0;
  else if(pc_write)
    out<=in;
  else
    out<=out;
  end
endmodule

module instruction_memory(input[31:0] address,output[31:0] instruction);
  reg[31:0] ins_mem[0:1999];
  initial begin $readmemb("instruction_set.txt",ins_mem); end 
  assign instruction=ins_mem[address];
endmodule

module pc_adder(input [31:0] pc,output [31:0] out);
  assign out=pc+1;
endmodule

module mux_2(input [31:0] a,b,input select,output [31:0] out);
  assign out=(select)?a:b;
endmodule

module if_id_reg(input clk,rst,flush,write,input [31:0] instruction,pc,output reg[31:0] instruction_o,pc_o);
  always@(posedge clk)begin
    if(rst)begin pc_o<=0;instruction_o<=0;end
    else begin
      if(flush) begin instruction_o<=32'b0;pc_o<=32'b0;end
      else if(write) begin pc_o<=pc;instruction_o<=instruction;end
      else begin pc_o<=pc_o;instruction_o<=instruction_o;end
    end
  end
endmodule

module register_file(input clk,rst,regwrite,input[4:0] r1,r2,wr,input[31:0]wd,output[31:0] rd1,rd2);
  reg[31:0] reg_file[31:0];
  integer j;
  always@(negedge clk)begin
    if(rst) begin
      for(j=0;j<32;j=j+1)
        reg_file[j]=32'b0;
    end
    else begin
      if(regwrite && ~(wr==4'b0000))
        reg_file[wr]<=wd;
    end
  end
  assign rd1=reg_file[r1];
  assign rd2=reg_file[r2];
endmodule

module is_equal(input[31:0] a,b,output equal);
  assign equal=(a==b)?1'b1:1'b0;
endmodule

module mux_if_id(input [10:0] a,input select,output [10:0] out);
  //wire [1:0]test;
  //assign test={1'b1,1'b0};
  //assign test_test=test[0];
  assign out=(select)?a:11'b0;
endmodule

module id_ex_reg(input clk,rst,memtoreg,regwrite,memread,memwrite,branch,jump,regdst,alusrc,input[2:0] aluop,input[31:0] rd1,rd2,offset,pc,jump_address,input[4:0] rt,rd,rs,output reg memtoreg_o,regwrite_o,memread_o,memwrite_o,branch_o,jump_o,regdst_o,alusrc_o,output reg[2:0] aluop_o,output reg[31:0] rd1_o,rd2_o,offset_o,pc_o,jump_address_o,output reg[4:0] rt_o,rd_o,rs_o);
  always@(posedge clk) begin
    if(rst)
      {memtoreg_o,regwrite_o,memread_o,memwrite_o,branch_o,jump_o,regdst_o,alusrc_o,aluop_o,rd1_o,rd2_o,offset_o,pc_o,jump_address_o,rt_o,rd_o,rs_o}=0;
    else begin
      memtoreg_o<=memtoreg;
      regwrite_o<=regwrite;
      memread_o<=memread;
      memwrite_o=memwrite;
      branch_o<=branch;
      jump_o<=jump;
      regdst_o<=regdst;
      alusrc_o<=alusrc;
      aluop_o<=aluop;
      rd1_o<=rd1;
      rd2_o<=rd2;
      offset_o<=offset;
      pc_o<=pc;
      jump_address_o<=jump_address;
      rt_o<=rt;
      rd_o<=rd;
      rs_o<=rs;
    end
  end
endmodule

module mux_3(input [31:0] a,b,c,input[1:0] select,output [31:0] out);
  assign out=(select==2'b00)?a:(select==2'b01)?b:c;
endmodule

module adder(input [31:0] a,b,output[31:0] out);
  assign out=a+b;
endmodule

module alu(input signed[31:0] a,b,input[2:0] aluop,output reg[31:0] out);
  always@(a,b,aluop) begin
    out=32'b0;
    case(aluop)
      3'b000:out=a+b;
      3'b001:out=a-b;
      3'b010:out=a & b;
      3'b011:out=a | b;
      3'b100:out=(a<b);
      endcase
    end
endmodule

module ex_mem_reg(input clk,rst,regwrite,memtoreg,memread,memwrite,input[31:0] aluin,src2in,input[4:0] regdes,output reg regwrite_o,memtoreg_o,memread_o,memwrite_o,output reg[31:0] aluin_o,src2in_o,output reg[4:0] regdes_o);
     always@(posedge clk)begin
        if(rst)
          {regwrite_o,memtoreg_o,memread_o,memwrite_o,aluin_o,src2in_o,regdes_o}=0;
        else begin
          regwrite_o<=regwrite;
          memtoreg_o<=memtoreg;
          memread_o<=memread;
          memwrite_o<=memwrite;
          aluin_o<=aluin;
          src2in_o<=src2in;
          regdes_o<=regdes;
        end
      end
endmodule

module data_memory(input[31:0] address,input[31:0] wd,input memread,memwrite,clk,output[31:0] rd);
  reg[31:0] data_mem[0:1999];
  initial begin $readmemb("memory_set.txt",data_mem); end 
  assign rd=memread?data_mem[address]:32'bz;
  always@(posedge clk) begin
    if(memwrite)
      data_mem[address]<=wd;
   end 
endmodule

module mem_wb_reg(input clk,rst,regwrite,memtoreg,input [31:0] data_memory,alu_in,input[4:0] regdes,output reg regwrite_o,memtoreg_o,output reg[31:0] data_memory_o,alu_in_o,output reg[4:0] regdes_o);
  always@(posedge clk)begin
    if(rst)
      {regwrite_o,memtoreg_o,data_memory_o,alu_in_o,regdes_o}=0;
    else begin
      regwrite_o<=regwrite;
      memtoreg_o<=memtoreg;
      data_memory_o<=data_memory;
      alu_in_o<=alu_in;
      regdes_o<=regdes;
    end
  end
endmodule

module forwarding_unit(input [4:0] rs_exe,rt_exe,regdes_mem,regdes_wb,input regwrite_mem,regwrite_wb,output reg[1:0] src1_sel,src2_sel);
    always@(*)begin
      {src1_sel,src2_sel}<=0;
      if(rs_exe==regdes_mem && regwrite_mem==1'b1) 
        src1_sel<=2'b01;
      else if(rs_exe==regdes_wb && regwrite_wb==1'b1) 
        src1_sel<=2'b10;
      if(rt_exe==regdes_mem && regwrite_mem==1'b1)   
        src2_sel<=2'b01;
      else if(rt_exe==regdes_wb && regwrite_wb==1'b1)
        src2_sel<=2'b10;
    end
endmodule

module hazard_unuit(input jump,j_exe,b_exe,input [4:0] regdes_exe,regdes_mem,rs_id,rt_id,input memread_exe,regwrite_exe,regwrite_mem,branch_type,output reg pcwrite,if_id_write,select,flush);
  always@(*)begin
    {pcwrite,if_id_write,select}=3'b111;
    flush=0;
    if(memread_exe==1'b1 && (rs_id==regdes_exe || rt_id==regdes_exe))
      {pcwrite,if_id_write,select}=0;
    if((branch_type==1'b1 && regwrite_exe==1'b1) && (rs_id==regdes_exe || rt_id==regdes_exe))
      begin{pcwrite,if_id_write,select}=0;end
    if((branch_type==1'b1 && regwrite_mem==1'b1) && (rs_id==regdes_mem || rt_id==regdes_mem))
      begin{pcwrite,if_id_write,select}=0;end
    if(b_exe)
      begin select=0;flush=1;pcwrite=1;end
    if(jump || j_exe)
      begin if_id_write=0;flush=1;end
  end
endmodule

module controller(input [5:0] opcode,func,output reg beq,bneq,j,alusrc,regdst,output reg[2:0] aluop,output reg memread,memwrite,memtoreg,regwrite);
  always@(opcode,func)begin
    {beq,bneq,j,alusrc,regdst,aluop,memread,memwrite,memtoreg,regwrite}=0;
    case(opcode)
      6'b000000:begin
        case(func)
          6'b100000:begin aluop=3'b000;regdst=1;regwrite=1;end
          6'b100010:begin aluop=3'b001;regdst=1;regwrite=1;end
          6'b100101:begin aluop=3'b011;regdst=1;regwrite=1;end
          6'b100100:begin aluop=3'b010;regdst=1;regwrite=1;end
          6'b101010:begin aluop=3'b100;regdst=1;regwrite=1;end
        endcase
      end
      6'b100011:begin aluop=3'b000;alusrc=1;memread=1;memtoreg=1;regwrite=1;end
      6'b101011:begin aluop=3'b000;alusrc=1;memwrite=1;end
      6'b000010:begin j=1;end
      6'b000100:begin beq=1;end
      6'b000101:begin bneq=1;end
      6'b000000:{beq,bneq,j,alusrc,regdst,aluop,memread,memwrite,memtoreg,regwrite}=0;
    endcase
  end
endmodule

module datapath(input flush,clk,rst,pcwrite,if_id_write,input [1:0] forward_sel1,forward_sel2,input regwrite,memtoreg,memread,memwrite,alusrc,regdst,input[2:0] aluop,input j,input b,output equal,output[4:0] rs_exe,rt_exe,regdes_mem,regdes_wb,output regwrite_wb,output [4:0] regdes_exe,rs_id,rt_id,output memread_exe,regwrite_exe,regwrite_mem,output[31:0] instruction_id,output j_exe,b_exe);
  wire [31:0] pcin,pcout,j_id,instruction,pcnext,branch,jump,out,pcnext_id,wd_wb,rd1,rd2,rd1_exe,rd2_exe,b_offset_exe,pcnext_exe,b_offset;
  wire[31:0] aluout_mem,out1,writedata,out2,aluout,writedata_mem,rd_mem,rd_wb,aluout_wb;
  wire memtoreg_exe,memwrite_exe,regdst_exe,alusrc_exe;
  wire memtoreg_mem,memread_mem,memwrite_mem,memtoreg_wb;
  wire [4:0] rd_exe,rd_id;
  wire[2:0] aluop_exe;
  assign rs_id=instruction_id[25:21];
  assign rt_id=instruction_id[20:16];
  assign rd_id=instruction_id[15:11];
  assign b_offset=instruction_id[15]?{16'b1111111111111111,instruction_id[15:0]}:{16'b0000000000000000,instruction_id[15:0]};
  assign j_id=instruction_id[25]?{6'b111111,instruction_id[25:0]}:{6'b000000,instruction_id[25:0]};
  pc_reg a1(clk,rst,pcwrite,pcin,pcout);
  instruction_memory a2(pcout,instruction);
  pc_adder a3(pcout,pcnext);
  mux_2 a4(branch,pcnext,b_exe,out);
  mux_2 a5(jump,out,j_exe,pcin);
  if_id_reg a6(clk,rst,flush,if_id_write,instruction,pcnext,instruction_id,pcnext_id);
  register_file a7(clk,rst,regwrite_wb,rs_id,rt_id,regdes_wb,wd_wb,rd1,rd2);
  is_equal a8(rd1,rd2,equal);
  id_ex_reg a9(clk,rst,memtoreg,regwrite,memread,memwrite,b,j,regdst,alusrc,aluop,rd1,rd2,b_offset,pcnext_id,j_id,rt_id,rd_id,rs_id,memtoreg_exe,regwrite_exe,memread_exe,memwrite_exe,b_exe,j_exe,regdst_exe,alusrc_exe,aluop_exe,rd1_exe,rd2_exe,b_offset_exe,pcnext_exe,jump,rt_exe,rd_exe,rs_exe);
  mux_3 a10(rd1_exe,aluout_mem,wd_wb,forward_sel1,out1);
  mux_3 a11(rd2_exe,aluout_mem,wd_wb,forward_sel2,writedata);
  adder a12(b_offset_exe,pcnext_exe,branch);
  mux_2 a13(b_offset_exe,writedata,alusrc_exe,out2);
  mux_2 a14(rd_exe,rt_exe,regdst_exe,regdes_exe);
  alu a15(out1,out2,aluop_exe,aluout);
  ex_mem_reg a16(clk,rst,regwrite_exe,memtoreg_exe,memread_exe,memwrite_exe,aluout,writedata,regdes_exe,regwrite_mem,memtoreg_mem,memread_mem,memwrite_mem,aluout_mem,writedata_mem,regdes_mem);
  data_memory a17(aluout_mem,writedata_mem,memread_mem,memwrite_mem,clk,rd_mem);
  mem_wb_reg a18(clk,rst,regwrite_mem,memtoreg_mem,rd_mem,aluout_mem,regdes_mem,regwrite_wb,memtoreg_wb,rd_wb,aluout_wb,regdes_wb);
  mux_2 a19(rd_wb,aluout_wb,memtoreg_wb,wd_wb);
endmodule

module pipeline(input clk,rst);
  wire[31:0] instruction;
  wire branch_type,select,b_checker;
  wire pcwrite,if_id_write,regwrite,memtoreg,memread,memwrite,alusrc,regdst,j,b,equal,regwrite_wb,flush;
  wire  memread_exe,regwrite_exe,regwrite_mem,j_exe,b_exe;
  wire beq,bneq,j_c,alusrc_c,regdst_c,memread_c,memwrite_c,memtoreg_c,regwrite_c;
  wire [1:0] forward_sel1,forward_sel2;
  wire [2:0] aluop, aluop_c;
  wire [4:0] rs_exe,rt_exe,regdes_mem,regdes_wb,regdes_exe,rs_id,rt_id;
  wire [5:0] opcode,func;
  assign opcode=instruction[31:26];
  assign func=instruction[5:0];
  assign b_checker=(beq && equal)||(bneq && ~equal);
  assign branch_type=beq||bneq;
  datapath DATAPATH(flush,clk,rst,pcwrite,if_id_write,forward_sel1,forward_sel2,regwrite,memtoreg,memread,memwrite,alusrc,regdst,aluop,j,b,equal,rs_exe,rt_exe,regdes_mem,regdes_wb,regwrite_wb,regdes_exe,rs_id,rt_id,memread_exe,regwrite_exe,regwrite_mem,instruction,j_exe,b_exe);
  controller CONTROLLER(opcode,func,beq,bneq,j_c,alusrc_c,regdst_c,aluop_c,memread_c,memwrite_c,memtoreg_c,regwrite_c);
  forwarding_unit FORWARDING(rs_exe,rt_exe,regdes_mem,regdes_wb,regwrite_mem,regwrite_wb,forward_sel1,forward_sel2);
  hazard_unuit HAZARD(j_c,j_exe,b_exe,regdes_exe,regdes_mem,rs_id,rt_id,memread_exe,regwrite_exe,regwrite_mem,branch_type,pcwrite,if_id_write,select,flush);
  mux_if_id MUX({regwrite_c,memtoreg_c,memread_c,memwrite_c,alusrc_c,regdst_c,aluop_c,j_c,b_checker},select,{regwrite,memtoreg,memread,memwrite,alusrc,regdst,aluop,j,b});
endmodule

module test();
  reg clk,rst;
  pipeline uut(clk,rst);
  always #100 clk=~clk;
  initial begin
    clk=0;
    rst=1;
    #200
    rst=0;
    #200
    #100000
    $stop;
  end
endmodule
