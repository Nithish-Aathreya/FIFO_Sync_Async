onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb/dut/clk
add wave -noupdate -radix hexadecimal /tb/dut/rst
add wave -noupdate -group control -radix hexadecimal /tb/dut/wr_valid
add wave -noupdate -group control -radix hexadecimal /tb/dut/rd_valid
add wave -noupdate -group {fifo internal} -radix hexadecimal /tb/dut/wr_ptr
add wave -noupdate -group {fifo internal} -radix hexadecimal /tb/dut/rd_ptr
add wave -noupdate -group {fifo internal} -radix hexadecimal /tb/dut/wr_t_f
add wave -noupdate -group {fifo internal} -radix hexadecimal /tb/dut/rd_t_f
add wave -noupdate -group data -radix hexadecimal /tb/dut/data_i
add wave -noupdate -group data -radix hexadecimal /tb/dut/data_o
add wave -noupdate -group flag -radix hexadecimal /tb/dut/fifo_full
add wave -noupdate -group flag -radix hexadecimal /tb/dut/fifo_empty
add wave -noupdate -radix hexadecimal /tb/dut/error
add wave -noupdate -radix hexadecimal /tb/dut/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {193 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {472 ps}
