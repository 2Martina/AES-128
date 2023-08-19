add wave -position insertpoint sim:/Encrypt/*

force -freeze sim:/Encrypt/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/Encrypt/reset 1 0
force -freeze sim:/Encrypt/enable 1 0

run
force -freeze sim:/Encrypt/reset 0 0
force -freeze sim:/Encrypt/key 'h3243f6a8885a308d313198a2e0370734 0

force -freeze sim:/Encrypt/data 'h2b7e151628aed2a6abf7158809cf4f3c 0

run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
