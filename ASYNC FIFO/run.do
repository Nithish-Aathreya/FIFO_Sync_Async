vlog tb.v
vsim tb +testname=random_write_random_read
add wave -position insertpoint -radix hex sim:/tb/dut/*
run -all
