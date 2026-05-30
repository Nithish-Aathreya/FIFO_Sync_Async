`include"async.v"
//Testbench of async fifo is almost same except applying of write and read
//clock
module tb;

parameter WIDTH=8;
parameter DEPTH=16; 
parameter PTR_WIDTH=$clog2(DEPTH); 


reg wr_clk,rd_clk,rst;
reg[WIDTH-1:0]data_i;
wire[WIDTH-1:0]data_o;
reg wr_valid,rd_valid;
wire fifo_full,fifo_empty,error;
integer i,j,k,delay1,delay2;
reg[200:1]testname;


async dut(wr_clk,rd_clk, rst, data_i, data_o, wr_valid, rd_valid, fifo_full, fifo_empty, error);

initial//generation of write clock
begin
    wr_clk=0;
    forever #7 wr_clk=~wr_clk;
end

initial //generation of read clock
begin
    rd_clk=0;
    forever #5 rd_clk=~rd_clk;
end

initial
begin
    reset();
    $value$plusargs("testname=%s",testname);
//   write(DEPTH);
  //read(DEPTH);
case(testname)
    "FIFO_FULL":begin
        write(DEPTH);
    end

    "FIFO_EMPTY":begin
        write(DEPTH);
        read(DEPTH);
    end
    
    "FIFO_FULL_ERROR":begin
    write(DEPTH+1);
    end
    
    "FIFO_EMPTY_ERROR":begin
    write(DEPTH);
    read(DEPTH+1);
    end
    
    "random_write_random_read":begin
        fork
        begin
            for(j=0;j<10;j=j+1)
            begin
                delay1 = $urandom_range(1,10);
        #delay1    write(1);
            end
        end
    begin
            for(k=0;k<10;k=k+1)
            begin
              delay2 = $urandom_range(15,30);
         #delay2   read(1);
     end
    end
join
end
endcase

#100;
$finish;
end

task reset();
    begin
    rst=1;
    data_i=0;
    wr_valid=0;
    rd_valid=0;
    @(posedge wr_clk)
    rst=0;
    end
endtask

task write(input integer num_loc);
    begin
for(i=0;i<num_loc;i=i+1)
begin
    @(posedge wr_clk)
wr_valid=1;
data_i=$random;
end
@(posedge wr_clk)
wr_valid=0;
data_i=0;
    end
endtask

task read(input integer num_loc);
    begin

for(i=0;i<num_loc;i=i+1)
begin
    @(posedge rd_clk)
rd_valid=1;
end
@(posedge rd_clk)
rd_valid=0;
    end
endtask


endmodule

