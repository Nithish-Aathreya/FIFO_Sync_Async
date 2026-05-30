vlog tb.v
vsim tb +testname=FIFO_FULL
do wave.do
#add wave -position insertpoint -radix hex sim:/tb/dut/*
run -all
