module async(wr_clk,rd_clk, rst, data_i, data_o, wr_valid, rd_valid, fifo_full, fifo_empty, error);

parameter WIDTH=8;//width of fifo 
parameter DEPTH=16;//depth of fifo 
parameter PTR_WIDTH=$clog2(DEPTH);//address to fifo locations 

//ASYNC design = write and read clocks
input wr_clk,rd_clk,rst;
input [WIDTH-1:0]data_i;//data input
output reg[WIDTH-1:0]data_o;//data output
input wr_valid,rd_valid;//valid signals
output reg fifo_full,fifo_empty,error;//flags,error-indicates both underflow & overflow  
integer i;


reg [PTR_WIDTH-1:0]wr_ptr;//ptr signals act as address of fifo
 
reg [PTR_WIDTH-1:0]rd_ptr;
reg wr_t_f,rd_t_f;

//respective toggle flags for write and read clks
reg wr_t_f_rd_clk,rd_t_f_wr_clk;

//reg [PTR_WIDTH-1:0]wr_ptr_rd_clk;
//reg [PTR_WIDTH-1:0]rd_ptr_wr_clk;

//Gray counter is used to avoid glitch of multiple bit switching, when
//synthesized
reg [PTR_WIDTH-1:0]wr_ptr_gray_rd_clk;
reg [PTR_WIDTH-1:0]rd_ptr_gray_wr_clk;
reg [PTR_WIDTH-1:0]wr_ptr_gray;
reg [PTR_WIDTH-1:0]rd_ptr_gray;





reg[WIDTH-1:0]mem[DEPTH-1:0];//FIFO model

always@(posedge wr_clk)
    begin
        if(rst)//Reset every reg & outputs 
        begin
        data_o=0;
        fifo_full=0;
        fifo_empty=1;
        error=0;
        wr_ptr<=0;
        rd_ptr<=0;
        rd_t_f<=0;
        wr_t_f<=0;
        wr_t_f_rd_clk=0;
        rd_t_f_wr_clk=0;
        wr_ptr_gray_rd_clk=0;
        rd_ptr_gray_wr_clk=0;
        wr_ptr_gray=0;
        rd_ptr_gray=0;
        for(i=0;i<DEPTH;i=i+1)
            mem[i]=0;
        end
        else     //rst==0
        begin
            error=0;
            if(wr_valid)//indicates write operation is about to perform
 
                begin
                    if(fifo_full) begin//check if fifo is full?
 
                        error=1;//indicates OVERFLOW(writing to full fifo)
 
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
                        //convert ptr to gray code 
                        wr_ptr_gray={wr_ptr[3],wr_ptr[3:1]^wr_ptr[2:0]};
                    end //else
                end //wr_valid
                end //rst==0
            
            end //always block

always@(posedge rd_clk)
begin
    if(rst==0)
    begin
                        error=0;
            if(rd_valid)
                begin
                    if(fifo_empty) begin
                        error=1;
                    end
                    else
                    begin
                        data_o=mem[rd_ptr];
                        if(rd_ptr==DEPTH-1)
                        begin
                            rd_t_f=~rd_t_f;
                            //rd_ptr=0;
                        end
                            rd_ptr=rd_ptr+1; 
                        rd_ptr_gray={rd_ptr[3],rd_ptr[3:1]^rd_ptr[2:0]};
                        end //else
                    end  //rd_valid

        end  //rst==0
    end  //always block

//synchronisation
    always@(posedge rd_clk) //for empty condition 
    begin
    wr_ptr_gray_rd_clk<=wr_ptr_gray;
    wr_t_f_rd_clk<=wr_t_f;
    end

    always@(posedge wr_clk) //for full condition 
    begin
    rd_ptr_gray_wr_clk<=rd_ptr_gray;
    rd_t_f_wr_clk<=rd_t_f;
    end

always@(*)
begin
    fifo_empty=0;
    if(wr_ptr_gray_rd_clk==rd_ptr_gray && wr_t_f_rd_clk==rd_t_f ) begin
    fifo_empty=1;
end
end

always@(*)//combinational block to generate empty & full condition in fifo 
begin
    fifo_full=0;
if(wr_ptr_gray==rd_ptr_gray_wr_clk && wr_t_f!=rd_t_f_wr_clk)
begin
    fifo_full=1;
end
end
    endmodule

