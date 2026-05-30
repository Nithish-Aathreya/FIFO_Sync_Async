`include"fifo_design.v" //include design file,using compiler directive

module tb;

parameter WIDTH=8;
parameter DEPTH=16; 
parameter PTR_WIDTH=$clog2(DEPTH); 

//declarations of signals
reg clk,rst;s
reg[WIDTH-1:0]data_i;
wire[WIDTH-1:0]data_o;
reg wr_valid,rd_valid;
wire fifo_full,fifo_empty,error;
integer i,j,k,delay;
reg[200:1]testname; //to apply differernt testcases

//Instantiation of design file as DUT-connection by name is follwed here
fifo_design dut(clk, rst, data_i, data_o, wr_valid, rd_valid, fifo_full, fifo_empty, error);

initial //clock generation block, TP=10ns
begin
    clk=0;
    forever #5 clk=~clk;
end

initial
begin
    reset();//calling reset task->drives all inputs to zero(initial state)
    $value$plusargs("testname=%0s",testname);//will get this from run file as user argument
    $display("testname=%0s",testname);
//    write(DEPTH);
  //read(DEPTH);
case(testname)
    "FIFO_FULL":begin
        write(DEPTH);//FUll flag should go high ==>1
    end

    "FIFO_EMPTY":begin//Empty flag should go high ==>1
        write(DEPTH);
        read(DEPTH);
    end
    
    "FIFO_FULL_ERROR":begin//Error flag go high =>indicating overflow 
    write(DEPTH+1);
    end
    
    "FIFO_EMPTY_ERROR":begin//Error flag go high =>indicating underflow
    write(DEPTH);
    read(DEPTH+1);
    end
    
    "random_write_random_read":begin//This is complete random scenarios
            for(j=0;j<DEPTH;j=j+1)//Runs for all fifo locations
            begin
        fork//concurrent execution
        begin
              delay = $urandom_range(1,10);//generating random delay value
        #delay    write(1);//applying random value==>delaying write operation randomly
            end
    begin
              delay = $urandom_range(15,30);//generating random delay value
         #delay   read(1);//applying random value==> delaying read operation randomly
    end
join
end

end
endcase
#100; //allowing some time for signals to settle down==>not cutting off simulation abruptly
$finish;//stop the simulaton
end

task reset();//Reset task
    begin
    rst=1;
    data_i=0;
    wr_valid=0;
    rd_valid=0;
    @(posedge clk)
    rst=0;
    end
endtask

task write(input integer num_loc);//input argument is to have control on number of fifo locations
    begin
for(i=0;i<num_loc;i=i+1)
begin
    @(posedge clk)
wr_valid=1;
data_i=$random;
end
@(posedge clk)
wr_valid=0;
data_i=0;
    end
endtask

task read(input integer num_loc);//input argument is to have control on number of fifo locations 
    begin

for(i=0;i<num_loc;i=i+1)
begin
    @(posedge clk)
rd_valid=1;
end
@(posedge clk)
rd_valid=0;
    end
endtask


endmodule
