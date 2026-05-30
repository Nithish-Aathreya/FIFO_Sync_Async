module fifo_design(clk, rst, data_i, data_o, wr_valid, rd_valid, fifo_full, fifo_empty, error);


parameter WIDTH=8;//width of fifo
parameter DEPTH=16; //depth of fifo
parameter PTR_WIDTH=$clog2(DEPTH);//address to fifo location 


input clk,rst;
input [WIDTH-1:0]data_i;//data input
output reg[WIDTH-1:0]data_o;//data output
input wr_valid,rd_valid;//valid signals
output reg fifo_full,fifo_empty,error;//flags,error-indicates both underflow & overflow
integer i;

reg [PTR_WIDTH-1:0]wr_ptr;//ptr signals act as address of fifo
reg [PTR_WIDTH-1:0]rd_ptr;
reg wr_t_f,rd_t_f;

reg[WIDTH-1:0]mem[DEPTH-1:0];//FIFO model

always@(posedge clk)
    begin
        if(rst) //Reset every reg & outputs
        begin
        data_o=0;
        fifo_full=0;
        fifo_empty=1;
        error=0;
        wr_ptr<=0;
        rd_ptr<=0;
        rd_t_f<=0;
        wr_t_f<=0;
        for(i=0;i<DEPTH;i=i+1)
            mem[i]=0;
        end
        else     //rst==0
        begin
            error=0;
            if(wr_valid)//indicates write operation is about to perform
                begin
                    if(fifo_full) begin//check if fifo is full?
                        error=1; //indicates OVERFLOW(writing to full fifo)
                    end
                    else
                    begin
                        mem[wr_ptr]=data_i;
                        if(wr_ptr==DEPTH-1)//check if ptr is @last location of fifo??
                        begin
                            //Toggles flag,whose combination with rd_t_f generates empty/full condition
                            wr_t_f=~wr_t_f; 
                          //  wr_ptr=0;
                        end
                            wr_ptr=wr_ptr+1;//if not??, just increment ptr 
                    end
                end //wr_valid

            if(rd_valid)//indicates read operation is about to perform
                begin
                    if(fifo_empty) begin//check if fifo is empty??
                        error=1;//if it is ===> indicates UNDERFLOW(Reading from empty fifo)
                    end
                    else
                    begin
                        data_o=mem[rd_ptr];
                        if(rd_ptr==DEPTH-1)//check if ptr is@last location of fifo??
                        begin
                            //Toggles flag,whose combination with wr_t_f generates empty/full condition
                            rd_t_f=~rd_t_f;
                            //rd_ptr=0;
                        end
                            rd_ptr=rd_ptr+1;//if not?,just increment ptr 
                        end
                    end  //rd_valid

        end  //rst==0
    end  //always block

always@(*) //combinational block to generate empty & full condition in fifo
begin
    fifo_empty=0;
    fifo_full=0;
    //Both pointer @same location
    if(wr_ptr==rd_ptr && wr_t_f==rd_t_f ) begin
    fifo_empty=1;
end
    //write pointer @different location
if(wr_ptr==rd_ptr && wr_t_f!=rd_t_f)
begin
    fifo_full=1;
end
end
    endmodule
