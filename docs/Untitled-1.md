PS E:\ternary cmos compile\tritone-complete\OpenROAD-flow-scripts-master>   docker run --rm -it -v "E:/ternary cmos compile/tritone-complete/OpenROAD-flow-scripts-master/flow/designs/asap7/tritone:/OpenROAD-flow-scripts/flow/designs/asap7/tritone" -v "E:/ternary cmos compile/tritone-complete/OpenROAD-flow-scripts-master/flow/designs/src/tritone:/OpenROAD-flow-scripts/flow/designs/src/tritone" -w /OpenROAD-flow-scripts/flow openroad/orfs:latest make DESIGN_CONFIG=./designs/asap7/tritone/config.mk
mkdir -p results/asap7/tritone/base/
echo 3330 > results/asap7/tritone/base/clock_period.txt
/OpenROAD-flow-scripts/flow/scripts/synth.sh /OpenROAD-flow-scripts/flow/scripts/synth_canonicalize.tcl ./logs/asap7/tritone/base/1_1_yosys_canonicalize.log
Using ABC speed script.
Extracting clock period from SDC file: ./results/asap7/tritone/base/clock_period.txt
Setting clock period to 3330
1. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
2. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
3. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
4. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
5. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
6. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
7. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
8. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
9. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
10. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
11. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/btfa.sv
12. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/btisa_decoder.sv
13. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/clock_gate.sv
14. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_adder.sv
15. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_alu.sv
16. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_cpu.sv
17. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_cpu_system.sv
18. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_forward_unit.sv
19. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_hazard_unit.sv
20. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_memory.sv
21. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_regfile.sv
22. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_clkgate_R.v
23. Executing HIERARCHY pass (managing design hierarchy).
24. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_cpu_system'.
24.1. Analyzing design hierarchy..
24.2. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_memory'.
24.3. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_cpu'.
24.4. Analyzing design hierarchy..
24.5. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_forward_unit'.
24.6. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_hazard_unit'.
24.7. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_alu'.
24.8. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_regfile'.
Warning: Replacing memory \regs with list of registers. See /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_regfile.sv:129
24.9. Executing AST frontend in derive mode using pre-parsed AST for module `\btisa_decoder'.
24.10. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_adder'.
24.11. Analyzing design hierarchy..
24.12. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_adder'.
24.13. Executing AST frontend in derive mode using pre-parsed AST for module `\btfa'.
24.14. Analyzing design hierarchy..
24.15. Analyzing design hierarchy..
24.16. Analyzing design hierarchy..
25. Executing OPT_CLEAN pass (remove unused cells and wires).
Warning: Ignoring module $paramod\ternary_adder\WIDTH=s32'00000000000000000000000000001000 because it contains processes (run 'proc' command first).
Warning: Ignoring module btfa because it contains processes (run 'proc' command first).
Warning: Ignoring module btisa_decoder because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod$4a12332018d758461ddf52371bdc2df23dae4fbf\ternary_regfile because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod\ternary_alu\WIDTH=s32'00000000000000000000000000011011 because it contains processes (run 'proc' command first).
Warning: Ignoring module ternary_hazard_unit because it contains processes (run 'proc' command first).
Warning: Ignoring module ternary_forward_unit because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod\ternary_cpu\TRIT_WIDTH=s32'00000000000000000000000000011011 because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod$21963defc1890383001fc13d5c5c8630a07bb93b\ternary_memory because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod\ternary_adder\WIDTH=s32'00000000000000000000000000011011 because it contains processes (run 'proc' command first).
26. Executing RTLIL backend.
Warnings: 11 unique messages, 11 total
End of script. Logfile hash: b647dcb46a, CPU: user 0.57s system 0.04s, MEM: 75.50 MB peak
Yosys 0.60 (git sha1 UNKNOWN, g++ 11.4.0-1ubuntu1~22.04.2 -fPIC -O3)
Time spent: 84% 12x read_liberty (0 sec), 9% 1x hierarchy (0 sec), ...
Elapsed time: 0:01.40[h:]min:sec. CPU time: user 0.61 sys 0.05 (47%). Peak memory: 80396KB.
/OpenROAD-flow-scripts/flow/scripts/synth.sh /OpenROAD-flow-scripts/flow/scripts/synth.tcl ./logs/asap7/tritone/base/1_2_yosys.log
Using ABC speed script.
Extracting clock period from SDC file: ./results/asap7/tritone/base/clock_period.txt
Setting clock period to 3330
1. Executing RTLIL frontend.
2. Executing HIERARCHY pass (managing design hierarchy).
2.1. Analyzing design hierarchy..
2.2. Analyzing design hierarchy..
3. Executing SYNTH pass.
3.1. Executing HIERARCHY pass (managing design hierarchy).
3.1.1. Analyzing design hierarchy..
3.1.2. Analyzing design hierarchy..
3.2. Executing PROC pass (convert processes to netlists).
3.2.1. Executing PROC_CLEAN pass (remove empty switches from decision trees).
3.2.2. Executing PROC_RMDEAD pass (remove dead branches from decision trees).
3.2.3. Executing PROC_PRUNE pass (remove redundant assignments in processes).
3.2.4. Executing PROC_INIT pass (extract init attributes).
3.2.5. Executing PROC_ARST pass (detect async resets in processes).
3.2.6. Executing PROC_ROM pass (convert switches to ROMs).
3.2.7. Executing PROC_MUX pass (convert decision trees to multiplexers).
3.2.8. Executing PROC_DLATCH pass (convert process syncs to latches).
3.2.9. Executing PROC_DFF pass (convert process syncs to FFs).
3.2.10. Executing PROC_MEMWR pass (convert process memory writes to cells).
3.2.11. Executing PROC_CLEAN pass (remove empty switches from decision trees).
3.2.12. Executing OPT_EXPR pass (perform const folding).
3.3. Executing FLATTEN pass (flatten design).
3.4. Executing OPT_EXPR pass (perform const folding).
3.5. Executing OPT_CLEAN pass (remove unused cells and wires).
3.6. Executing CHECK pass (checking for obvious problems).
3.7. Executing OPT pass (performing simple optimizations).
3.7.1. Executing OPT_EXPR pass (perform const folding).
3.7.2. Executing OPT_MERGE pass (detect identical cells).
3.7.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.5. Executing OPT_MERGE pass (detect identical cells).
3.7.6. Executing OPT_DFF pass (perform DFF optimizations).
3.7.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.8. Executing OPT_EXPR pass (perform const folding).
3.7.9. Rerunning OPT passes. (Maybe there is more to do..)
3.7.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.12. Executing OPT_MERGE pass (detect identical cells).
3.7.13. Executing OPT_DFF pass (perform DFF optimizations).
3.7.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.15. Executing OPT_EXPR pass (perform const folding).
3.7.16. Rerunning OPT passes. (Maybe there is more to do..)
3.7.17. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.18. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.19. Executing OPT_MERGE pass (detect identical cells).
3.7.20. Executing OPT_DFF pass (perform DFF optimizations).
3.7.21. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.22. Executing OPT_EXPR pass (perform const folding).
3.7.23. Finished fast OPT passes. (There is nothing left to do.)
3.8. Executing FSM pass (extract and optimize FSM).
3.8.1. Executing FSM_DETECT pass (finding FSMs in design).
3.8.2. Executing FSM_EXTRACT pass (extracting FSM from design).
3.8.3. Executing FSM_OPT pass (simple optimizations of FSMs).
3.8.4. Executing OPT_CLEAN pass (remove unused cells and wires).
3.8.5. Executing FSM_OPT pass (simple optimizations of FSMs).
3.8.6. Executing FSM_RECODE pass (re-assigning FSM state encoding).
3.8.7. Executing FSM_INFO pass (dumping all available information on FSM cells).
3.8.8. Executing FSM_MAP pass (mapping FSMs to basic logic).
3.9. Executing OPT pass (performing simple optimizations).
3.9.1. Executing OPT_EXPR pass (perform const folding).
3.9.2. Executing OPT_MERGE pass (detect identical cells).
3.9.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.5. Executing OPT_MERGE pass (detect identical cells).
3.9.6. Executing OPT_DFF pass (perform DFF optimizations).
3.9.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.8. Executing OPT_EXPR pass (perform const folding).
3.9.9. Rerunning OPT passes. (Maybe there is more to do..)
3.9.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.12. Executing OPT_MERGE pass (detect identical cells).
3.9.13. Executing OPT_DFF pass (perform DFF optimizations).
3.9.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.15. Executing OPT_EXPR pass (perform const folding).
3.9.16. Rerunning OPT passes. (Maybe there is more to do..)
3.9.17. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.18. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.19. Executing OPT_MERGE pass (detect identical cells).
3.9.20. Executing OPT_DFF pass (perform DFF optimizations).
3.9.21. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.22. Executing OPT_EXPR pass (perform const folding).
3.9.23. Finished fast OPT passes. (There is nothing left to do.)
3.10. Executing WREDUCE pass (reducing word size of cells).
3.11. Executing PEEPOPT pass (run peephole optimizers).
3.12. Executing OPT_CLEAN pass (remove unused cells and wires).
3.13. Executing ALUMACC pass (create $alu and $macc cells).
3.14. Executing SHARE pass (SAT-based resource sharing).
3.15. Executing OPT pass (performing simple optimizations).
3.15.1. Executing OPT_EXPR pass (perform const folding).
3.15.2. Executing OPT_MERGE pass (detect identical cells).
3.15.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.15.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.15.5. Executing OPT_MERGE pass (detect identical cells).
3.15.6. Executing OPT_DFF pass (perform DFF optimizations).
3.15.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.15.8. Executing OPT_EXPR pass (perform const folding).
3.15.9. Rerunning OPT passes. (Maybe there is more to do..)
3.15.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.15.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.15.12. Executing OPT_MERGE pass (detect identical cells).
3.15.13. Executing OPT_DFF pass (perform DFF optimizations).
3.15.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.15.15. Executing OPT_EXPR pass (perform const folding).
3.15.16. Finished fast OPT passes. (There is nothing left to do.)
3.16. Executing MEMORY pass.
3.16.1. Executing OPT_MEM pass (optimize memories).
3.16.2. Executing OPT_MEM_PRIORITY pass (removing unnecessary memory write priority relations).
3.16.3. Executing OPT_MEM_FEEDBACK pass (finding memory read-to-write feedback paths).
3.16.4. Executing MEMORY_BMUX2ROM pass (converting muxes to ROMs).
3.16.5. Executing MEMORY_DFF pass (merging $dff cells to $memrd).
3.16.6. Executing OPT_CLEAN pass (remove unused cells and wires).
3.16.7. Executing MEMORY_SHARE pass (consolidating $memrd/$memwr cells).
3.16.8. Executing OPT_MEM_WIDEN pass (optimize memories where all ports are wide).
3.16.9. Executing OPT_CLEAN pass (remove unused cells and wires).
3.16.10. Executing MEMORY_COLLECT pass (generating $mem cells).
3.17. Executing OPT_CLEAN pass (remove unused cells and wires).
4. Executing SYNTH pass.
4.1. Executing OPT pass (performing simple optimizations).
4.1.1. Executing OPT_EXPR pass (perform const folding).
4.1.2. Executing OPT_MERGE pass (detect identical cells).
4.1.3. Executing OPT_DFF pass (perform DFF optimizations).
4.1.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.5. Rerunning OPT passes. (Removed registers in this run.)
4.1.6. Executing OPT_EXPR pass (perform const folding).
4.1.7. Executing OPT_MERGE pass (detect identical cells).
4.1.8. Executing OPT_DFF pass (perform DFF optimizations).
4.1.9. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.10. Rerunning OPT passes. (Removed registers in this run.)
4.1.11. Executing OPT_EXPR pass (perform const folding).
4.1.12. Executing OPT_MERGE pass (detect identical cells).
4.1.13. Executing OPT_DFF pass (perform DFF optimizations).
4.1.14. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.15. Rerunning OPT passes. (Removed registers in this run.)
4.1.16. Executing OPT_EXPR pass (perform const folding).
4.1.17. Executing OPT_MERGE pass (detect identical cells).
4.1.18. Executing OPT_DFF pass (perform DFF optimizations).
4.1.19. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.20. Finished fast OPT passes.
4.2. Executing MEMORY_MAP pass (converting memories to logic and flip-flops).
4.3. Executing OPT pass (performing simple optimizations).
4.3.1. Executing OPT_EXPR pass (perform const folding).
4.3.2. Executing OPT_MERGE pass (detect identical cells).
4.3.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.5. Executing OPT_MERGE pass (detect identical cells).
4.3.6. Executing OPT_SHARE pass.
4.3.7. Executing OPT_DFF pass (perform DFF optimizations).
4.3.8. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.9. Executing OPT_EXPR pass (perform const folding).
4.3.10. Rerunning OPT passes. (Maybe there is more to do..)
4.3.11. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.12. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.13. Executing OPT_MERGE pass (detect identical cells).
4.3.14. Executing OPT_SHARE pass.
4.3.15. Executing OPT_DFF pass (perform DFF optimizations).
4.3.16. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.17. Executing OPT_EXPR pass (perform const folding).
4.3.18. Rerunning OPT passes. (Maybe there is more to do..)
4.3.19. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.20. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.21. Executing OPT_MERGE pass (detect identical cells).
4.3.22. Executing OPT_SHARE pass.
4.3.23. Executing OPT_DFF pass (perform DFF optimizations).
4.3.24. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.25. Executing OPT_EXPR pass (perform const folding).
4.3.26. Finished fast OPT passes. (There is nothing left to do.)
4.4. Executing TECHMAP pass (map to technology primitives).
4.4.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/tools/install/yosys/bin/../share/yosys/techmap.v
4.4.2. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/common/lcu_kogge_stone.v
4.4.3. Continuing TECHMAP pass.
4.5. Executing OPT pass (performing simple optimizations).
4.5.1. Executing OPT_EXPR pass (perform const folding).
4.5.2. Executing OPT_MERGE pass (detect identical cells).
4.5.3. Executing OPT_DFF pass (perform DFF optimizations).
4.5.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.5.5. Finished fast OPT passes.
4.6. Executing ABC pass (technology mapping using ABC).
4.6.1. Extracting gate netlist of module `\ternary_cpu_system' to `<abc-temp-dir>/input.blif'..
4.7. Executing OPT pass (performing simple optimizations).
4.7.1. Executing OPT_EXPR pass (perform const folding).
4.7.2. Executing OPT_MERGE pass (detect identical cells).
4.7.3. Executing OPT_DFF pass (perform DFF optimizations).
4.7.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.7.5. Finished fast OPT passes.
4.8. Executing HIERARCHY pass (managing design hierarchy).
4.8.1. Analyzing design hierarchy..
4.8.2. Analyzing design hierarchy..
4.9. Printing statistics.
4.10. Executing CHECK pass (checking for obvious problems).
5. Executing OPT pass (performing simple optimizations).
5.1. Executing OPT_EXPR pass (perform const folding).
5.2. Executing OPT_MERGE pass (detect identical cells).
5.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
5.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
5.5. Executing OPT_MERGE pass (detect identical cells).
5.6. Executing OPT_DFF pass (perform DFF optimizations).
5.7. Executing OPT_CLEAN pass (remove unused cells and wires).
5.8. Executing OPT_EXPR pass (perform const folding).
5.9. Rerunning OPT passes. (Maybe there is more to do..)
5.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
5.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
5.12. Executing OPT_MERGE pass (detect identical cells).
5.13. Executing OPT_DFF pass (perform DFF optimizations).
5.14. Executing OPT_CLEAN pass (remove unused cells and wires).
5.15. Executing OPT_EXPR pass (perform const folding).
5.16. Finished fast OPT passes. (There is nothing left to do.)
6. Executing EXTRACT_FA pass (find and extract full/half adders).
7. Executing TECHMAP pass (map to technology primitives).
7.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_adders_R.v
7.2. Continuing TECHMAP pass.
8. Executing TECHMAP pass (map to technology primitives).
8.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/tools/install/yosys/bin/../share/yosys/techmap.v
8.2. Continuing TECHMAP pass.
9. Executing OPT pass (performing simple optimizations).
9.1. Executing OPT_EXPR pass (perform const folding).
9.2. Executing OPT_MERGE pass (detect identical cells).
9.3. Executing OPT_DFF pass (perform DFF optimizations).
9.4. Executing OPT_CLEAN pass (remove unused cells and wires).
9.5. Finished fast OPT passes.
10. Executing TECHMAP pass (map to technology primitives).
10.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_latch_R.v
10.2. Continuing TECHMAP pass.
11. Executing DFFLIBMAP pass (mapping DFF cells to sequential cells from liberty file).
11.1. Executing DFFLEGALIZE pass (convert FFs to types supported by the target).
12. Executing OPT pass (performing simple optimizations).
12.1. Executing OPT_EXPR pass (perform const folding).
12.2. Executing OPT_MERGE pass (detect identical cells).
12.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
12.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
12.5. Executing OPT_MERGE pass (detect identical cells).
12.6. Executing OPT_DFF pass (perform DFF optimizations).
12.7. Executing OPT_CLEAN pass (remove unused cells and wires).
12.8. Executing OPT_EXPR pass (perform const folding).
12.9. Rerunning OPT passes. (Maybe there is more to do..)
12.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
12.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
12.12. Executing OPT_MERGE pass (detect identical cells).
12.13. Executing OPT_DFF pass (perform DFF optimizations).
12.14. Executing OPT_CLEAN pass (remove unused cells and wires).
12.15. Executing OPT_EXPR pass (perform const folding).
12.16. Finished fast OPT passes. (There is nothing left to do.)
13. Executing SETUNDEF pass (replace undef values with defined constants).
abc -script /OpenROAD-flow-scripts/flow/scripts/abc_speed.script -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib -dont_use *x1p*_ASAP7* -dont_use *xp*_ASAP7* -dont_use SDF* -dont_use ICG* -constr ./objects/asap7/tritone/base/abc.constr -D 3330
14. Executing ABC pass (technology mapping using ABC).
14.1. Extracting gate netlist of module `\ternary_cpu_system' to `<abc-temp-dir>/input.blif'..
14.1.1. Executed ABC.
14.1.2. Re-integrating ABC results.
15. Executing SPLITNETS pass (splitting up multi-bit signals).
16. Executing OPT_CLEAN pass (remove unused cells and wires).
17. Executing HILOMAP pass (mapping to constant drivers).
18. Executing INSBUF pass (insert buffer cells for connected wires).
19. Executing CHECK pass (checking for obvious problems).
20. Printing statistics.
21. Executing CHECK pass (checking for obvious problems).
22. Executing Verilog backend.
22.1. Executing BMUXMAP pass.
22.2. Executing DEMUXMAP pass.
exec cp /OpenROAD-flow-scripts/flow/designs/asap7/tritone/constraint.sdc ./results/asap7/tritone/base/1_synth.sdc
End of script. Logfile hash: 13bfefbd35, CPU: user 2.69s system 0.41s, MEM: 152.23 MB peak
Yosys 0.60 (git sha1 UNKNOWN, g++ 11.4.0-1ubuntu1~22.04.2 -fPIC -O3)
Time spent: 20% 2x abc (0 sec), 14% 1x dfflibmap (0 sec), ...
Elapsed time: 0:04.03[h:]min:sec. CPU time: user 3.30 sys 0.70 (99%). Peak memory: 156864KB.
cp /OpenROAD-flow-scripts/flow/designs/asap7/tritone/constraint.sdc ./results/asap7/tritone/base/1_2_yosys.sdc
OpenROAD 24Q3-11661-g86b9236cdd
Features included (+) or not (-): +GPU +GUI +Python
This program is licensed under the BSD-3 license. See the LICENSE file for details.
Components of this program may be licensed under more restrictive licenses which must be honored.
[INFO ORD-0030] Using 32 thread(s).
mkdir -p ./objects/asap7/tritone/base
/OpenROAD-flow-scripts/flow/scripts/flow.sh 1_synth synth_odb
Running synth_odb.tcl, stage 1_synth
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
[INFO ODB-0227] LEF file: /OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7_tech_1x_201209.lef, created 30 layers, 9 vias
[INFO ODB-0227] LEF file: /OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7sc7p5t_28_R_1x_220121a.lef, created 212 library cells
link_design ternary_cpu_system
Elapsed time: 0:00.90[h:]min:sec. CPU time: user 0.82 sys 0.09 (101%). Peak memory: 195304KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
1_synth                            0            190 c4e3057fbeda64364de9
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_1_floorplan floorplan
Running floorplan.tcl, stage 2_1_floorplan
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/1_synth.odb

==========================================================================
Floorplan check_setup
--------------------------------------------------------------------------
number instances in verilog is 359
[WARNING IFP-0028] Core area lower left (2.000, 2.000) snapped to (2.052, 2.160).
[INFO IFP-0001] Added 41 rows of 208 site asap7sc7p5t.
source /OpenROAD-flow-scripts/flow/platforms/asap7/openRoad/make_tracks.tcl
source /OpenROAD-flow-scripts/flow/platforms/asap7/fastroute.tcl
Repair tie lo fanout...
[INFO RSZ-0042] Inserted 56 tie TIELOx1_ASAP7_75t_R instances.
Repair tie hi fanout...
[INFO RSZ-0042] Inserted 20 tie TIEHIx1_ASAP7_75t_R instances.
repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -setup -skip_last_gasp -sequence unbuffer,sizeup,swap,buffer,vt_swap -verbose
[WARNING EST-0027] no estimated parasitics. Using wire load models.
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove
[INFO RSZ-0098] No setup violations found
Default units for flow
 time 1ps
 capacitance 1fF
 resistance 1kohm
 voltage 1v
 current 1mA
 power 1pW
 distance 1um
Report metrics stage 2, floorplan final...

==========================================================================
floorplan final report_design_area
--------------------------------------------------------------------------
Design area 42 um^2 34% utilization.
Elapsed time: 0:01.02[h:]min:sec. CPU time: user 0.92 sys 0.10 (100%). Peak memory: 215592KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_1_floorplan                      1            210 d30f639000c655c76a51
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_2_floorplan_macro macro_place
Running macro_place.tcl, stage 2_2_floorplan_macro
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/2_1_floorplan.odb
No macros found: Skipping macro_placement
Elapsed time: 0:00.88[h:]min:sec. CPU time: user 0.80 sys 0.08 (100%). Peak memory: 192624KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_2_floorplan_macro                0            188 d30f639000c655c76a51
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_3_floorplan_tapcell tapcell
Running tapcell.tcl, stage 2_3_floorplan_tapcell
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/2_2_floorplan_macro.odb
Tap and End Cap cell insertion
  TAP Cell          : TAPCELL_ASAP7_75t_R
  ENDCAP Cell       : TAPCELL_ASAP7_75t_R
  Halo Around Macro : 2 2
  TAP Cell Distance : 25
[INFO TAP-0004] Inserted 82 endcaps.
[INFO TAP-0005] Inserted 0 tapcells.
Elapsed time: 0:00.84[h:]min:sec. CPU time: user 0.80 sys 0.04 (100%). Peak memory: 193460KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_3_floorplan_tapcell              0            188 d94e2b7b3bc316500acf
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_4_floorplan_pdn pdn
Running pdn.tcl, stage 2_4_floorplan_pdn
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/2_3_floorplan_tapcell.odb
[INFO PDN-0001] Inserting grid: top
Elapsed time: 0:00.87[h:]min:sec. CPU time: user 0.80 sys 0.07 (100%). Peak memory: 195296KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_4_floorplan_pdn                  0            190 23fde6d58e287e59c506
cp ./results/asap7/tritone/base/2_4_floorplan_pdn.odb ./results/asap7/tritone/base/2_floorplan.odb
cp ./results/asap7/tritone/base/2_1_floorplan.sdc ./results/asap7/tritone/base/2_floorplan.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_1_place_gp_skip_io global_place_skip_io
Running global_place_skip_io.tcl, stage 3_1_place_gp_skip_io
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/2_floorplan.odb
[INFO GPL-0022] Initialize gpl and calculate uniform density.
Placement density is 0.4430000042915344, computed from PLACE_DENSITY_LB_ADDON  0.10 and lower bound 0.3700000047683716
global_placement -skip_io -density 0.4430000042915344 -pad_left 0 -pad_right 0
[INFO GPL-0005] Execute conjugate gradient initial placement.
[INFO GPL-0002] DBU: 1000
[INFO GPL-0003] SiteSize: (  0.054  0.270 ) um
[INFO GPL-0004] CoreBBox: (  2.052  2.160 ) ( 13.284 13.230 ) um
[INFO GPL-0032] Initializing region: Top-level
[INFO GPL-0006] Number of instances:               515
[INFO GPL-0007] Movable instances:                 433
[INFO GPL-0008] Fixed instances:                    82
[INFO GPL-0009] Dummy instances:                     0
[INFO GPL-0010] Number of nets:                    521
[INFO GPL-0011] Number of pins:                   1224
[INFO GPL-0012] Die BBox:  (  0.000  0.000 ) ( 15.327 15.327 ) um
[INFO GPL-0013] Core BBox: (  2.052  2.160 ) ( 13.284 13.230 ) um
[INFO GPL-0016] Core area:                     124.338 um^2
[INFO GPL-0014] Region name: top-level.
[INFO GPL-0015] Region area:                   124.338 um^2
[INFO GPL-0017] Fixed instances area:            2.391 um^2
[INFO GPL-0018] Movable instances area:         44.310 um^2
[INFO GPL-0019] Utilization:                    36.336 %
[INFO GPL-0020] Standard cells area:            44.310 um^2
[INFO GPL-0021] Large instances area:            0.000 um^2
[INFO GPL-0033] Initializing Nesterov region: Top-level
[INFO GPL-0023] Placement target density:       0.4430
[INFO GPL-0024] Movable insts average area:      0.102 um^2
[INFO GPL-0025] Ideal bin area:                  0.231 um^2
[INFO GPL-0026] Ideal bin count:                   538
[INFO GPL-0027] Total bin area:                124.338 um^2
[INFO GPL-0028] Bin count (X, Y):          16 ,     16
[INFO GPL-0029] Bin size (W * H):       0.702 *  0.692 um
[INFO GPL-0030] Number of bins:                    256
[INFO GPL-0007] Execute nesterov global placement.
[INFO GPL-0031] HPWL: Half-Perimeter Wirelength
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
        0 |   0.8796 |  3.377410e+02 |   +0.00% |  2.36e-11 |
       10 |   0.9049 |  6.861600e+01 |  -79.68% |  3.85e-11 |
       20 |   0.9114 |  6.401100e+01 |   -6.71% |  6.27e-11 |
       30 |   0.9118 |  6.321500e+01 |   -1.24% |  1.02e-10 |
       40 |   0.9121 |  6.330400e+01 |   +0.14% |  1.66e-10 |
       50 |   0.9102 |  6.355000e+01 |   +0.39% |  2.71e-10 |
       60 |   0.9075 |  6.394500e+01 |   +0.62% |  4.41e-10 |
       70 |   0.8987 |  6.461000e+01 |   +1.04% |  7.19e-10 |
       80 |   0.8957 |  6.568100e+01 |   +1.66% |  1.17e-09 |
       90 |   0.8852 |  6.718900e+01 |   +2.30% |  1.91e-09 |
      100 |   0.8533 |  6.980800e+01 |   +3.90% |  3.11e-09 |
      110 |   0.8155 |  8.147700e+01 |  +16.72% |  5.06e-09 |
      120 |   0.7695 |  1.052240e+02 |  +29.15% |  8.25e-09 |
      130 |   0.7302 |  1.258580e+02 |  +19.61% |  1.34e-08 |
      140 |   0.7109 |  1.408850e+02 |  +11.94% |  2.19e-08 |
      150 |   0.6699 |  1.573610e+02 |  +11.69% |  3.56e-08 |
      160 |   0.6377 |  1.678950e+02 |   +6.69% |  5.80e-08 |
      170 |   0.5813 |  1.882900e+02 |  +12.15% |  9.45e-08 |
      180 |   0.5563 |  2.014380e+02 |   +6.98% |  1.54e-07 |
      190 |   0.5156 |  2.272010e+02 |  +12.79% |  2.51e-07 |
      200 |   0.4812 |  2.418270e+02 |   +6.44% |  4.09e-07 |
      210 |   0.4387 |  2.598570e+02 |   +7.46% |  6.66e-07 |
      220 |   0.4005 |  2.749530e+02 |   +5.81% |  1.08e-06 |
      230 |   0.3605 |  2.864580e+02 |   +4.18% |  1.77e-06 |
      240 |   0.3301 |  3.007830e+02 |   +5.00% |  2.74e-06 |
      250 |   0.3022 |  3.131790e+02 |   +4.12% |  4.03e-06 |
      260 |   0.2725 |  3.212300e+02 |   +2.57% |  5.94e-06 |
      270 |   0.2414 |  3.307120e+02 |   +2.95% |  8.75e-06 |
      280 |   0.2115 |  3.373970e+02 |   +2.02% |  1.29e-05 |
      290 |   0.1828 |  3.461160e+02 |   +2.58% |  1.90e-05 |
      300 |   0.1555 |  3.518700e+02 |   +1.66% |  2.80e-05 |
      310 |   0.1327 |  3.594560e+02 |   +2.16% |  4.12e-05 |
      320 |   0.1096 |  3.637340e+02 |   +1.19% |  6.07e-05 |
      325 |   0.0995 |  3.662480e+02 |          |  7.66e-05 |
---------------------------------------------------------------
[INFO GPL-1001] Global placement finished at iteration 325
[INFO GPL-1002] Placed Cell Area               44.3105
[INFO GPL-1003] Available Free Area           121.9471
[INFO GPL-1004] Minimum Feasible Density        0.3700 (cell_area / free_area)
[INFO GPL-1006]   Suggested Target Densities:
[INFO GPL-1007]     - For 90% usage of free space: 0.4037
[INFO GPL-1008]     - For 80% usage of free space: 0.4542
[INFO GPL-1009]     - For 50% usage of free space: 0.7267
[INFO GPL-1014] Final placement area: 44.31 (+0.00%)
Took 10 seconds: global_placement -skip_io -density 0.4430000042915344 -pad_left 0 -pad_right 0
Elapsed time: 0:10.96[h:]min:sec. CPU time: user 325.68 sys 0.17 (2972%). Peak memory: 194296KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_1_place_gp_skip_io              10            189 0a300f68f856bf89a87c
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_2_place_iop io_placement
Running io_placement.tcl, stage 3_2_place_iop
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_1_place_gp_skip_io.odb
place_pins -hor_layers M4 -ver_layers M5
Found 0 macro blocks.
Using 2 tracks default min distance between IO pins.
[INFO PPL-0001] Number of available slots 576
[INFO PPL-0002] Number of I/O             109
[INFO PPL-0003] Number of I/O w/sink      77
[INFO PPL-0004] Number of I/O w/o sink    32
[INFO PPL-0005] Slots per section         200
[INFO PPL-0008] Successfully assigned pins to sections.
[INFO PPL-0012] I/O nets HPWL: 282.73 um.
Elapsed time: 0:00.87[h:]min:sec. CPU time: user 0.82 sys 0.05 (100%). Peak memory: 194000KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_2_place_iop                      0            189 be7f26d0769054260412
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_3_place_gp global_place
Running global_place.tcl, stage 3_3_place_gp
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_2_place_iop.odb
[INFO RSZ-0026] Removed 63 buffers.
Perform port buffering...
[INFO RSZ-0027] Inserted 1 BUFx2_ASAP7_75t_R input buffers.
[INFO RSZ-0028] Inserted 19 BUFx2_ASAP7_75t_R output buffers.
[INFO GPL-0022] Initialize gpl and calculate uniform density.
Placement density is 0.4160000032186508, computed from PLACE_DENSITY_LB_ADDON  0.10 and lower bound 0.3400000035762787
global_placement -density 0.4160000032186508 -pad_left 0 -pad_right 0 -routability_driven -timing_driven
[INFO GPL-0005] Execute conjugate gradient initial placement.
[INFO GPL-0002] DBU: 1000
[INFO GPL-0003] SiteSize: (  0.054  0.270 ) um
[INFO GPL-0004] CoreBBox: (  2.052  2.160 ) ( 13.284 13.230 ) um
[INFO GPL-0032] Initializing region: Top-level
[INFO GPL-0006] Number of instances:               472
[INFO GPL-0007] Movable instances:                 390
[INFO GPL-0008] Fixed instances:                    82
[INFO GPL-0009] Dummy instances:                     0
[INFO GPL-0010] Number of nets:                    478
[INFO GPL-0011] Number of pins:                   1247
[INFO GPL-0012] Die BBox:  (  0.000  0.000 ) ( 15.327 15.327 ) um
[INFO GPL-0013] Core BBox: (  2.052  2.160 ) ( 13.284 13.230 ) um
[INFO GPL-0016] Core area:                     124.338 um^2
[INFO GPL-0014] Region name: top-level.
[INFO GPL-0015] Region area:                   124.338 um^2
[INFO GPL-0017] Fixed instances area:            2.391 um^2
[INFO GPL-0018] Movable instances area:         41.118 um^2
[INFO GPL-0019] Utilization:                    33.718 %
[INFO GPL-0020] Standard cells area:            41.118 um^2
[INFO GPL-0021] Large instances area:            0.000 um^2
[InitialPlace]  Iter: 1 conjugate gradient residual: 0.00000009 HPWL: 940202
[InitialPlace]  Iter: 2 conjugate gradient residual: 0.00000007 HPWL: 699907
[InitialPlace]  Iter: 3 conjugate gradient residual: 0.00000009 HPWL: 701113
[InitialPlace]  Iter: 4 conjugate gradient residual: 0.00000011 HPWL: 707945
[InitialPlace]  Iter: 5 conjugate gradient residual: 0.00000005 HPWL: 702719
[INFO GPL-0033] Initializing Nesterov region: Top-level
[INFO GPL-0023] Placement target density:       0.4160
[INFO GPL-0024] Movable insts average area:      0.105 um^2
[INFO GPL-0025] Ideal bin area:                  0.253 um^2
[INFO GPL-0026] Ideal bin count:                   490
[INFO GPL-0027] Total bin area:                124.338 um^2
[INFO GPL-0028] Bin count (X, Y):          16 ,     16
[INFO GPL-0029] Bin size (W * H):       0.702 *  0.692 um
[INFO GPL-0030] Number of bins:                    256
[INFO GPL-0007] Execute nesterov global placement.
[INFO GPL-0031] HPWL: Half-Perimeter Wirelength
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
        0 |   0.6505 |  5.140870e+02 |   +0.00% |  8.25e-11 |
       10 |   0.6932 |  4.081000e+02 |  -20.62% |  1.34e-10 |
       20 |   0.6945 |  4.049550e+02 |   -0.77% |  2.19e-10 |
       30 |   0.7019 |  4.048120e+02 |   -0.04% |  3.57e-10 |
       40 |   0.7003 |  4.059350e+02 |   +0.28% |  5.81e-10 |
       50 |   0.6949 |  4.071680e+02 |   +0.30% |  9.46e-10 |
       60 |   0.6874 |  4.079890e+02 |   +0.20% |  1.54e-09 |
       70 |   0.6851 |  4.088150e+02 |   +0.20% |  2.51e-09 |
       80 |   0.6821 |  4.101580e+02 |   +0.33% |  4.09e-09 |
       90 |   0.6765 |  4.127130e+02 |   +0.62% |  6.66e-09 |
      100 |   0.6623 |  4.165740e+02 |   +0.94% |  1.08e-08 |
      110 |   0.6475 |  4.198650e+02 |   +0.79% |  1.77e-08 |
      120 |   0.6430 |  4.243300e+02 |   +1.06% |  2.88e-08 |
[INFO GPL-0100] Timing-driven iteration 1/2, virtual: false.
[INFO GPL-0101]    Iter: 124, overflow: 0.635, keep resizer changes at: 1, HPWL: 425724
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |       478
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
   Iter   |    Area   | Removed | Inserted |   Pins
          |           | Buffers | Buffers  | Remaining
-------------------------------------------------------
        0 |     +0.0% |       0 |        0 |       367
       36 |     +0.0% |       0 |        0 |       331
       72 |     +0.0% |       0 |        0 |       295
      108 |     +0.0% |       0 |        0 |       259
      144 |     +0.0% |       0 |        0 |       223
      180 |     +0.0% |       0 |        0 |       187
      216 |     +0.0% |       0 |        0 |       151
      252 |     +0.0% |       0 |        0 |       115
      288 |     +0.0% |       0 |        0 |        79
      324 |     +0.0% |       0 |        0 |        43
      360 |     -0.2% |       1 |        0 |         7
    final |     -0.2% |       1 |        0 |         0
-------------------------------------------------------
[INFO GPL-0106] Timing-driven: worst slack -6.66e-10
[INFO GPL-0107] Timing-driven: repair_design delta area: -0.073 um^2 (-0.18%)
[INFO GPL-0108] Timing-driven: repair_design, gpl delta gcells: -1 (-0.26%)
[INFO GPL-0109] Timing-driven: repair_design, gcells created: 0, deleted: 1
[INFO GPL-0110] Timing-driven: new target density: 0.4154022
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      130 |   0.6076 |  4.307910e+02 |   +1.52% |  4.69e-08 |
      140 |   0.6012 |  4.384280e+02 |   +1.77% |  7.64e-08 |
[INFO GPL-0038] Routability snapshot saved at iter = 142
      141 |   0.5999 |  4.390140e+02 |          |           |
      150 |   0.5765 |  4.477020e+02 |   +2.12% |  1.24e-07 |
      160 |   0.5396 |  4.559390e+02 |   +1.84% |  2.03e-07 |
      170 |   0.5098 |  4.642900e+02 |   +1.83% |  3.30e-07 |
      180 |   0.4789 |  4.758120e+02 |   +2.48% |  5.38e-07 |
      190 |   0.4335 |  4.878050e+02 |   +2.52% |  8.76e-07 |
      200 |   0.3882 |  5.014090e+02 |   +2.79% |  1.43e-06 |
      210 |   0.3527 |  5.127800e+02 |   +2.27% |  2.32e-06 |
      220 |   0.3233 |  5.210460e+02 |   +1.61% |  3.49e-06 |
[INFO GPL-0040] Routability iteration: 1
[INFO GPL-0041] Total routing overflow: 0.0000
[INFO GPL-0042] Number of overflowed tiles: 0 (0.00%)
[INFO GPL-0043] Average top 0.5% routing congestion: 0.5692
[INFO GPL-0044] Average top 1.0% routing congestion: 0.5601
[INFO GPL-0045] Average top 2.0% routing congestion: 0.5434
[INFO GPL-0046] Average top 5.0% routing congestion: 0.5117
[INFO GPL-0047] Routability iteration weighted routing congestion: 0.5647
[INFO GPL-0050] Weighted routing congestion is lower than target routing congestion(1.0100), end routability optimization.
[INFO GPL-0090] Routability finished. Target routing congestion achieved succesfully.
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      230 |   0.2953 |  5.307730e+02 |   +1.87% |  5.15e-06 |
      240 |   0.2712 |  5.375950e+02 |   +1.29% |  7.58e-06 |
      250 |   0.2390 |  5.468170e+02 |   +1.72% |  1.12e-05 |
      260 |   0.2104 |  5.529660e+02 |   +1.12% |  1.64e-05 |
[INFO GPL-0100] Timing-driven iteration 2/2, virtual: false.
[INFO GPL-0101]    Iter: 268, overflow: 0.193, keep resizer changes at: 1, HPWL: 556483
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |       477
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
   Iter   |    Area   | Removed | Inserted |   Pins
          |           | Buffers | Buffers  | Remaining
-------------------------------------------------------
        0 |     +0.0% |       0 |        0 |       367
       36 |     +0.0% |       0 |        0 |       331
       72 |     +0.0% |       0 |        0 |       295
      108 |     +0.0% |       0 |        0 |       259
      144 |     +0.0% |       0 |        0 |       223
      180 |     +0.0% |       0 |        0 |       187
      216 |     +0.0% |       0 |        0 |       151
      252 |     +0.0% |       0 |        0 |       115
      288 |     +0.0% |       0 |        0 |        79
      324 |     +0.0% |       0 |        0 |        43
      360 |     +0.0% |       0 |        0 |         7
    final |     +0.0% |       0 |        0 |         0
-------------------------------------------------------
[INFO GPL-0106] Timing-driven: worst slack -6.66e-10
[INFO GPL-0107] Timing-driven: repair_design delta area: 0.000 um^2 (+0.00%)
[INFO GPL-0108] Timing-driven: repair_design, gpl delta gcells: 0 (+0.00%)
[INFO GPL-0109] Timing-driven: repair_design, gcells created: 0, deleted: 0
[INFO GPL-0110] Timing-driven: new target density: 0.4154022
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      270 |   0.1872 |  5.586790e+02 |   +1.03% |  2.42e-05 |
      280 |   0.1605 |  5.673200e+02 |   +1.55% |  3.57e-05 |
      290 |   0.1264 |  5.726070e+02 |   +0.93% |  5.26e-05 |
      300 |   0.1064 |  5.760110e+02 |   +0.59% |  7.75e-05 |
      305 |   0.0999 |  5.797970e+02 |          |  9.77e-05 |
---------------------------------------------------------------
[INFO GPL-1001] Global placement finished at iteration 305
[INFO GPL-1003] Routability mode iteration count: 87
[INFO GPL-1005] Routability final weighted congestion: 0.5693
[INFO GPL-1002] Placed Cell Area               41.0454
[INFO GPL-1003] Available Free Area           121.9471
[INFO GPL-1004] Minimum Feasible Density        0.3400 (cell_area / free_area)
[INFO GPL-1006]   Suggested Target Densities:
[INFO GPL-1007]     - For 90% usage of free space: 0.3740
[INFO GPL-1008]     - For 80% usage of free space: 0.4207
[INFO GPL-1009]     - For 50% usage of free space: 0.6732
[INFO GPL-1011] Original area (um^2): 41.12
[INFO GPL-1012] Total routability artificial inflation: -0.07 (-0.18%)
[INFO GPL-1013] Total timing-driven delta area: -0.07 (-0.18%)
[INFO GPL-1014] Final placement area: 41.05 (-0.18%)
Took 11 seconds: global_placement -density 0.4160000032186508 -pad_left 0 -pad_right 0 -routability_driven -timing_driven
Report metrics stage 3, global place...

==========================================================================
global place report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Elapsed time: 0:11.73[h:]min:sec. CPU time: user 330.05 sys 0.59 (2818%). Peak memory: 288200KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_3_place_gp                      11            281 4699b0d523198ad52423
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_4_place_resized resize
Running resize.tcl, stage 3_4_place_resized
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_3_place_gp.odb
Perform buffer insertion and gate resizing...
repair_design -verbose
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |       477
       10 |     +0.0% |       0 |       0 |             0 |       467
       20 |     +0.0% |       0 |       0 |             0 |       457
       30 |     +0.0% |       0 |       0 |             0 |       447
       40 |     +0.0% |       0 |       0 |             0 |       437
       50 |     +0.0% |       0 |       0 |             0 |       427
       60 |     +0.0% |       0 |       0 |             0 |       417
       70 |     +0.0% |       0 |       0 |             0 |       407
       80 |     +0.0% |       0 |       0 |             0 |       397
       90 |     +0.0% |       0 |       0 |             0 |       387
      100 |     +0.0% |       0 |       0 |             0 |       377
      110 |     +0.0% |       0 |       0 |             0 |       367
      120 |     +0.0% |       0 |       0 |             0 |       357
      130 |     +0.0% |       0 |       0 |             0 |       347
      140 |     +0.0% |       0 |       0 |             0 |       337
      150 |     +0.0% |       0 |       0 |             0 |       327
      160 |     +0.0% |       0 |       0 |             0 |       317
      170 |     +0.0% |       0 |       0 |             0 |       307
      180 |     +0.0% |       0 |       0 |             0 |       297
      190 |     +0.0% |       0 |       0 |             0 |       287
      200 |     +0.0% |       0 |       0 |             0 |       277
      210 |     +0.0% |       0 |       0 |             0 |       267
      220 |     +0.0% |       0 |       0 |             0 |       257
      230 |     +0.0% |       0 |       0 |             0 |       247
      240 |     +0.0% |       0 |       0 |             0 |       237
      250 |     +0.0% |       0 |       0 |             0 |       227
      260 |     +0.0% |       0 |       0 |             0 |       217
      270 |     +0.0% |       0 |       0 |             0 |       207
      280 |     +0.0% |       0 |       0 |             0 |       197
      290 |     +0.0% |       0 |       0 |             0 |       187
      300 |     +0.0% |       0 |       0 |             0 |       177
      310 |     +0.0% |       0 |       0 |             0 |       167
      320 |     +0.0% |       0 |       0 |             0 |       157
      330 |     +0.0% |       0 |       0 |             0 |       147
      340 |     +0.0% |       0 |       0 |             0 |       137
      350 |     +0.0% |       0 |       0 |             0 |       127
      360 |     +0.0% |       0 |       0 |             0 |       117
      370 |     +0.0% |       0 |       0 |             0 |       107
      380 |     +0.0% |       0 |       0 |             0 |        97
      390 |     +0.0% |       0 |       0 |             0 |        87
      400 |     +0.0% |       0 |       0 |             0 |        77
      410 |     +0.0% |       0 |       0 |             0 |        67
      420 |     +0.0% |       0 |       0 |             0 |        57
      430 |     +0.0% |       0 |       0 |             0 |        47
      440 |     +0.0% |       0 |       0 |             0 |        37
      450 |     +0.0% |       0 |       0 |             0 |        27
      460 |     +0.0% |       0 |       0 |             0 |        17
      470 |     +0.0% |       0 |       0 |             0 |         7
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
Floating nets:
Report metrics stage 3, resizer...

==========================================================================
resizer report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Instance count before 471, after 471
Pin count before 1136, after 1136
Elapsed time: 0:01.04[h:]min:sec. CPU time: user 0.89 sys 0.15 (101%). Peak memory: 214544KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_4_place_resized                  1            209 4699b0d523198ad52423
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_5_place_dp detail_place
Running detail_place.tcl, stage 3_5_place_dp
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_4_place_resized.odb
Placement Analysis
---------------------------------
total displacement         72.7 u
average displacement        0.2 u
max displacement            0.7 u
original HPWL             583.4 u
legalized HPWL            644.9 u
delta HPWL                   11 %

Detailed placement improvement.
[INFO DPL-0401] Setting random seed to 1.
[INFO DPL-0402] Setting maximum displacement 5 1 to 1350 270 units.
[INFO DPL-0320] Collected 191 fixed cells.
[INFO DPL-0318] Collected 389 single height cells.
[INFO DPL-0321] Collected 0 wide cells.
[INFO DPL-0322] Image (2052, 2160) - (13284, 13230)
[INFO DPL-0310] Assigned 389 cells into segments.  Movement in X-direction is 0.000000, movement in Y-direction is 0.000000.
[INFO DPL-0313] Found 0 cells in wrong regions.
[INFO DPL-0315] Found 0 row alignment problems.
[INFO DPL-0314] Found 0 site alignment problems.
[INFO DPL-0311] Found 0 overlaps between adjacent cells.
[INFO DPL-0312] Found 0 edge spacing violations and 0 padding violations.
[INFO DPL-0303] Running algorithm for independent set matching.
[INFO DPL-0300] Set matching objective is wirelength.
[INFO DPL-0301] Pass   1 of matching; objective is 6.437010e+05.
[INFO DPL-0302] End of matching; objective is 6.430920e+05, improvement is 0.09 percent.
[INFO DPL-0303] Running algorithm for global swaps.
[INFO DPL-0306] Pass   1 of global swaps; hpwl is 6.266170e+05.
[INFO DPL-0306] Pass   2 of global swaps; hpwl is 6.256570e+05.
[INFO DPL-0307] End of global swaps; objective is 6.256570e+05, improvement is 2.71 percent.
[INFO DPL-0303] Running algorithm for vertical swaps.
[INFO DPL-0308] Pass   1 of vertical swaps; hpwl is 6.227700e+05.
[INFO DPL-0309] End of vertical swaps; objective is 6.227700e+05, improvement is 0.46 percent.
[INFO DPL-0303] Running algorithm for reordering.
[INFO DPL-0304] Pass   1 of reordering; objective is 6.225640e+05.
[INFO DPL-0305] End of reordering; objective is 6.225640e+05, improvement is 0.03 percent.
[INFO DPL-0303] Running algorithm for random improvement.
[INFO DPL-0324] Random improver is using random generator.
[INFO DPL-0325] Random improver is using hpwl objective.
[INFO DPL-0326] Random improver cost string is (a).
[INFO DPL-0332] End of pass, Generator random called 7780 times.
[INFO DPL-0335] Generator random, Cumulative attempts 7780, swaps 777, moves  3321 since last reset.
[INFO DPL-0333] End of pass, Objective hpwl, Initial cost 6.225640e+05, Scratch cost 6.086330e+05, Incremental cost 6.086330e+05, Mismatch? N
[INFO DPL-0338] End of pass, Total cost is 6.086330e+05.
[INFO DPL-0327] Pass   1 of random improver; improvement in cost is 2.24 percent.
[INFO DPL-0332] End of pass, Generator random called 7780 times.
[INFO DPL-0335] Generator random, Cumulative attempts 15560, swaps 1672, moves  6487 since last reset.
[INFO DPL-0333] End of pass, Objective hpwl, Initial cost 6.086330e+05, Scratch cost 6.061870e+05, Incremental cost 6.061870e+05, Mismatch? N
[INFO DPL-0338] End of pass, Total cost is 6.061870e+05.
[INFO DPL-0327] Pass   2 of random improver; improvement in cost is 0.40 percent.
[INFO DPL-0328] End of random improver; improvement is 2.630573 percent.
[INFO DPL-0380] Cell flipping.
[INFO DPL-0382] Changed 0 cell orientations for row compatibility.
[INFO DPL-0383] Performed 130 cell flips.
[INFO DPL-0384] End of flipping; objective is 5.884960e+05, improvement is 2.92 percent.
[INFO DPL-0313] Found 0 cells in wrong regions.
[INFO DPL-0315] Found 0 row alignment problems.
[INFO DPL-0314] Found 0 site alignment problems.
[INFO DPL-0311] Found 0 overlaps between adjacent cells.
[INFO DPL-0312] Found 0 edge spacing violations and 0 padding violations.
Detailed Improvement Results
------------------------------------------
Original HPWL              644.9 u (     303.8,      341.1)
Final HPWL                 587.4 u (     268.7,      318.8)
Delta HPWL                  -8.9 % (     -11.6,       -6.5)

[INFO DPL-0020] Mirrored 51 instances
[INFO DPL-0021] HPWL before             587.4 u
[INFO DPL-0022] HPWL after              585.9 u
[INFO DPL-0023] HPWL delta               -0.3 %
[INFO FLW-0012] Placement violations .
Report metrics stage 3, detailed place...

==========================================================================
detailed place report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Elapsed time: 0:01.00[h:]min:sec. CPU time: user 0.95 sys 0.06 (101%). Peak memory: 199072KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_5_place_dp                       1            194 19b1386384311d96a2e0
cp ./results/asap7/tritone/base/3_5_place_dp.odb ./results/asap7/tritone/base/3_place.odb
cp ./results/asap7/tritone/base/2_floorplan.sdc ./results/asap7/tritone/base/3_place.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 4_1_cts cts
Running cts.tcl, stage 4_1_cts
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_place.odb
clock_tree_synthesis -sink_clustering_enable -repair_clock_nets
[INFO CTS-0050] Root buffer is BUFx4_ASAP7_75t_R.
[INFO CTS-0051] Sink buffer is BUFx8_ASAP7_75t_R.
[INFO CTS-0052] The following clock buffers will be used for CTS:
                    BUFx4_ASAP7_75t_R
                    BUFx10_ASAP7_75t_R
[INFO CTS-0049] Characterization buffer is BUFx10_ASAP7_75t_R.
[INFO CTS-0007] Net "clk" found for clock "core_clock".
[INFO CTS-0010]  Clock net "clk" has 19 sinks.
[INFO CTS-0008] TritonCTS found 1 clock nets.
[INFO CTS-0097] Characterization used 2 buffer(s) types.
[INFO CTS-0201] 0 blockages from hard placement blockages and placed macros will be used.
[INFO CTS-0027] Generating H-Tree topology for net clk.
[INFO CTS-0028]  Total number of sinks: 19.
[INFO CTS-0090]  Sinks will be clustered based on buffer max cap.
[INFO CTS-0030]  Number of static layers: 0.
[INFO CTS-0020]  Wire segment unit: 1350  dbu (1 um).
[INFO CTS-0023]  Original sink region: [(5008, 4498), (11704, 12598)].
[INFO CTS-0024]  Normalized sink region: [(3.70963, 3.33185), (8.66963, 9.33185)].
[INFO CTS-0025]     Width:  4.9600.
[INFO CTS-0026]     Height: 6.0000.
 Level 1
    Direction: Vertical
    Sinks per sub-region: 10
    Sub-region size: 4.9600 X 3.0000
[INFO CTS-0034]     Segment length (rounded): 1.
[INFO CTS-0032]  Stop criterion found. Max number of sinks is 15.
[INFO CTS-0035]  Number of sinks covered: 19.
[INFO CTS-0018]     Created 3 clock buffers.
[INFO CTS-0012]     Minimum number of buffers in the clock path: 2.
[INFO CTS-0013]     Maximum number of buffers in the clock path: 2.
[INFO CTS-0015]     Created 3 clock nets.
[INFO CTS-0016]     Fanout distribution for the current clock = 9:1, 10:1..
[INFO CTS-0017]     Max level of the clock tree: 1.
[INFO CTS-0098] Clock net "clk"
[INFO CTS-0099]  Sinks 20
[INFO CTS-0100]  Leaf buffers 0
[INFO CTS-0101]  Average sink wire length 14.05 um
[INFO CTS-0102]  Path depth 2 - 2
[INFO CTS-0207]  Dummy loads inserted 1
Placement Analysis
---------------------------------
total displacement          0.5 u
average displacement        0.0 u
max displacement            0.3 u
original HPWL             600.6 u
legalized HPWL            622.8 u
delta HPWL                    4 %

repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -verbose
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove CloneMove SplitLoadMove
[INFO RSZ-0098] No setup violations found
[INFO RSZ-0033] No hold violations found.
Placement Analysis
---------------------------------
total displacement          0.0 u
average displacement        0.0 u
max displacement            0.0 u
original HPWL             622.8 u
legalized HPWL            622.8 u
delta HPWL                    0 %

Report metrics stage 4, cts final...

==========================================================================
cts final report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Elapsed time: 0:02.08[h:]min:sec. CPU time: user 2.00 sys 0.10 (101%). Peak memory: 237408KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
4_1_cts                            2            231 cea6bd01096b6d40dafb
cp ./results/asap7/tritone/base/4_1_cts.odb ./results/asap7/tritone/base/4_cts.odb
/OpenROAD-flow-scripts/flow/scripts/flow.sh 5_1_grt global_route
Running global_route.tcl, stage 5_1_grt
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/4_cts.odb
pin_access
[INFO DRT-0149] Reading tech and libs.

Units:                1000
Number of layers:     21
Number of macros:     212
Number of vias:       14
Number of viarulegen: 11

[INFO DRT-0150] Reading design.

Design:                   ternary_cpu_system
Die area:                 ( 0 0 ) ( 15327 15327 )
Number of track patterns: 32
Number of DEF vias:       0
Number of components:     475
Number of terminals:      111
Number of snets:          2
Number of nets:           480

[INFO DRT-0167] List of default vias:
  Layer V2
    default via: VIA23
  Layer V3
    default via: VIA34
  Layer V4
    default via: VIA45
  Layer V5
    default via: VIA56
  Layer V6
    default via: VIA67
  Layer V7
    default via: VIA78
  Layer V8
    default via: VIA89
  Layer V9
    default via: VIA9Pad
[INFO DRT-0162] Library cell analysis.
[INFO DRT-0163] Instance analysis.
[INFO DRT-0164] Number of unique instances = 79.
[INFO DRT-0168] Init region query.
[INFO DRT-0024]   Complete Active.
[INFO DRT-0024]   Complete V0.
[INFO DRT-0024]   Complete M1.
[INFO DRT-0024]   Complete V1.
[INFO DRT-0024]   Complete M2.
[INFO DRT-0024]   Complete V2.
[INFO DRT-0024]   Complete M3.
[INFO DRT-0024]   Complete V3.
[INFO DRT-0024]   Complete M4.
[INFO DRT-0024]   Complete V4.
[INFO DRT-0024]   Complete M5.
[INFO DRT-0024]   Complete V5.
[INFO DRT-0024]   Complete M6.
[INFO DRT-0024]   Complete V6.
[INFO DRT-0024]   Complete M7.
[INFO DRT-0024]   Complete V7.
[INFO DRT-0024]   Complete M8.
[INFO DRT-0024]   Complete V8.
[INFO DRT-0024]   Complete M9.
[INFO DRT-0024]   Complete V9.
[INFO DRT-0024]   Complete Pad.
[INFO DRT-0033] Active shape region query size = 0.
[INFO DRT-0033] V0 shape region query size = 0.
[INFO DRT-0033] M1 shape region query size = 6144.
[INFO DRT-0033] V1 shape region query size = 13668.
[INFO DRT-0033] M2 shape region query size = 401.
[INFO DRT-0033] V2 shape region query size = 315.
[INFO DRT-0033] M3 shape region query size = 315.
[INFO DRT-0033] V3 shape region query size = 210.
[INFO DRT-0033] M4 shape region query size = 243.
[INFO DRT-0033] V4 shape region query size = 210.
[INFO DRT-0033] M5 shape region query size = 196.
[INFO DRT-0033] V5 shape region query size = 20.
[INFO DRT-0033] M6 shape region query size = 18.
[INFO DRT-0033] V6 shape region query size = 0.
[INFO DRT-0033] M7 shape region query size = 0.
[INFO DRT-0033] V7 shape region query size = 0.
[INFO DRT-0033] M8 shape region query size = 0.
[INFO DRT-0033] V8 shape region query size = 0.
[INFO DRT-0033] M9 shape region query size = 0.
[INFO DRT-0033] V9 shape region query size = 0.
[INFO DRT-0033] Pad shape region query size = 0.
[INFO DRT-0165] Start pin access.
[INFO DRT-0078]   Complete 415 pins.
[INFO DRT-0081]   Complete 79 unique inst patterns.
[INFO DRT-0084]   Complete 276 groups.
#scanned instances     = 475
#unique  instances     = 79
#stdCellGenAp          = 1887
#stdCellValidPlanarAp  = 52
#stdCellValidViaAp     = 1483
#stdCellPinNoAp        = 0
#stdCellPinCnt         = 1067
#instTermValidViaApCnt = 0
#macroGenAp            = 0
#macroValidPlanarAp    = 0
#macroValidViaAp       = 0
#macroNoAp             = 0
[INFO DRT-0166] Complete pin access.
[INFO DRT-0267] cpu time = 00:00:11, elapsed time = 00:00:01, memory = 202.93 (MB), peak = 202.93 (MB)
global_route -congestion_report_file ./reports/asap7/tritone/base/congestion.rpt -congestion_iterations 30 -congestion_report_iter_step 5 -verbose
[INFO GRT-0020] Min routing layer: M2
[INFO GRT-0021] Max routing layer: M7
[INFO GRT-0022] Global adjustment: 0%
[INFO GRT-0023] Grid origin: (0, 0)
[INFO GRT-0088] Layer M1      Track-Pitch = 0.0360  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M2      Track-Pitch = 0.0390  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M3      Track-Pitch = 0.0360  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M4      Track-Pitch = 0.0480  line-2-Via Pitch: 0.0480
[INFO GRT-0088] Layer M5      Track-Pitch = 0.0480  line-2-Via Pitch: 0.0480
[INFO GRT-0088] Layer M6      Track-Pitch = 0.0640  line-2-Via Pitch: 0.0640
[INFO GRT-0088] Layer M7      Track-Pitch = 0.0640  line-2-Via Pitch: 0.0640
[INFO GRT-0003] Macros: 0
[INFO GRT-0004] Blockages: 114
[INFO GRT-0019] Found 4 clock nets.
[INFO GRT-0001] Minimum degree: 2
[INFO GRT-0002] Maximum degree: 27

[INFO GRT-0053] Routing resources analysis:
          Routing      Original      Derated      Resource
Layer     Direction    Resources     Resources    Reduction (%)
---------------------------------------------------------------
M1         Vertical            0             0          0.00%
M2         Horizontal       8691          6273          27.82%
M3         Vertical        10310          7650          25.80%
M4         Horizontal       7865          5840          25.75%
M5         Vertical         7655          5669          25.94%
M6         Horizontal       5565          3824          31.28%
M7         Vertical         5975          4050          32.22%
---------------------------------------------------------------

[INFO GRT-0197] Via related to pin nodes: 1880
[INFO GRT-0198] Via related Steiner nodes: 35
[INFO GRT-0199] Via filling finished.
[INFO GRT-0111] Final number of vias: 2351
[INFO GRT-0112] Final usage 3D: 8256

[INFO GRT-0096] Final congestion report:
Layer         Resource        Demand        Usage (%)    Max H / Max V / Total Overflow
---------------------------------------------------------------------------------------
M1                   0             0            0.00%             0 /  0 /  0
M2                6273           506            8.07%             0 /  0 /  0
M3                7650           576            7.53%             0 /  0 /  0
M4                5840            82            1.40%             0 /  0 /  0
M5                5669            39            0.69%             0 /  0 /  0
M6                3824             0            0.00%             0 /  0 /  0
M7                4050             0            0.00%             0 /  0 /  0
---------------------------------------------------------------------------------------
Total            33306          1203            3.61%             0 /  0 /  0

[INFO GRT-0018] Total wirelength: 1121 um
[INFO GRT-0014] Routed nets: 441
Perform buffer insertion and gate resizing...
repair_design -verbose
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |       481
       10 |     +0.0% |       0 |       0 |             0 |       471
       20 |     +0.0% |       0 |       0 |             0 |       461
       30 |     +0.0% |       0 |       0 |             0 |       451
       40 |     +0.0% |       0 |       0 |             0 |       441
       50 |     +0.0% |       0 |       0 |             0 |       431
       60 |     +0.0% |       0 |       0 |             0 |       421
       70 |     +0.0% |       0 |       0 |             0 |       411
       80 |     +0.0% |       0 |       0 |             0 |       401
       90 |     +0.0% |       0 |       0 |             0 |       391
      100 |     +0.0% |       0 |       0 |             0 |       381
      110 |     +0.0% |       0 |       0 |             0 |       371
      120 |     +0.0% |       0 |       0 |             0 |       361
      130 |     +0.0% |       0 |       0 |             0 |       351
      140 |     +0.0% |       0 |       0 |             0 |       341
      150 |     +0.0% |       0 |       0 |             0 |       331
      160 |     +0.0% |       0 |       0 |             0 |       321
      170 |     +0.0% |       0 |       0 |             0 |       311
      180 |     +0.0% |       0 |       0 |             0 |       301
      190 |     +0.0% |       0 |       0 |             0 |       291
      200 |     +0.0% |       0 |       0 |             0 |       281
      210 |     +0.0% |       0 |       0 |             0 |       271
      220 |     +0.0% |       0 |       0 |             0 |       261
      230 |     +0.0% |       0 |       0 |             0 |       251
      240 |     +0.0% |       0 |       0 |             0 |       241
      250 |     +0.0% |       0 |       0 |             0 |       231
      260 |     +0.0% |       0 |       0 |             0 |       221
      270 |     +0.0% |       0 |       0 |             0 |       211
      280 |     +0.0% |       0 |       0 |             0 |       201
      290 |     +0.0% |       0 |       0 |             0 |       191
      300 |     +0.0% |       0 |       0 |             0 |       181
      310 |     +0.0% |       0 |       0 |             0 |       171
      320 |     +0.0% |       0 |       0 |             0 |       161
      330 |     +0.0% |       0 |       0 |             0 |       151
      340 |     +0.0% |       0 |       0 |             0 |       141
      350 |     +0.0% |       0 |       0 |             0 |       131
      360 |     +0.0% |       0 |       0 |             0 |       121
      370 |     +0.0% |       0 |       0 |             0 |       111
      380 |     +0.0% |       0 |       0 |             0 |       101
      390 |     +0.0% |       0 |       0 |             0 |        91
      400 |     +0.0% |       0 |       0 |             0 |        81
      410 |     +0.0% |       0 |       0 |             0 |        71
      420 |     +0.0% |       0 |       0 |             0 |        61
      430 |     +0.0% |       0 |       0 |             0 |        51
      440 |     +0.0% |       0 |       0 |             0 |        41
      450 |     +0.0% |       0 |       0 |             0 |        31
      460 |     +0.0% |       0 |       0 |             0 |        21
      470 |     +0.0% |       0 |       0 |             0 |        11
      480 |     +0.0% |       0 |       0 |             0 |         1
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
global_route -start_incremental
detailed_placement
Placement Analysis
---------------------------------
total displacement          0.0 u
average displacement        0.0 u
max displacement            0.0 u
original HPWL             622.8 u
legalized HPWL            622.8 u
delta HPWL                    0 %

global_route -end_incremental -congestion_report_file ./reports/asap7/tritone/base/congestion_post_repair_design.rpt
Repair setup and hold violations...
repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -verbose
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove CloneMove SplitLoadMove
[INFO RSZ-0098] No setup violations found
[INFO RSZ-0033] No hold violations found.
global_route -start_incremental
detailed_placement
Placement Analysis
---------------------------------
total displacement          0.0 u
average displacement        0.0 u
max displacement            0.0 u
original HPWL             622.8 u
legalized HPWL            622.8 u
delta HPWL                    0 %

global_route -end_incremental -congestion_report_file ./reports/asap7/tritone/base/congestion_post_repair_timing.rpt
global_route -start_incremental
global_route -end_incremental -congestion_report_file ./reports/asap7/tritone/base/congestion_post_recover_power.rpt
Repair antennas...
[WARNING GRT-0246] No diode with LEF class CORE ANTENNACELL found.
[INFO ANT-0002] Found 0 net violations.
[INFO ANT-0001] Found 0 pin violations.
Estimate parasitics...
Report metrics stage 5, global route...

==========================================================================
global route report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
[INFO FLW-0007] clock core_clock period 3330.000000
[INFO FLW-0008] Clock core_clock period 1544.523
[INFO FLW-0009] Clock core_clock slack 1704.187
[INFO FLW-0011] Path endpoint path count 63
Elapsed time: 0:02.90[h:]min:sec. CPU time: user 29.65 sys 0.32 (1032%). Peak memory: 302100KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
5_1_grt                            2            295 22989f632b7db45d1ab8
/OpenROAD-flow-scripts/flow/scripts/flow.sh 5_2_route detail_route
Running detail_route.tcl, stage 5_2_route
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/5_1_grt.odb
detailed_route -output_drc ./reports/asap7/tritone/base/5_route_drc.rpt -output_maze ./results/asap7/tritone/base/maze.log -droute_end_iter 64 -verbose 1 -drc_report_iter_step 5
[INFO DRT-0149] Reading tech and libs.

Units:                1000
Number of layers:     21
Number of macros:     212
Number of vias:       14
Number of viarulegen: 11

[INFO DRT-0150] Reading design.

Design:                   ternary_cpu_system
Die area:                 ( 0 0 ) ( 15327 15327 )
Number of track patterns: 32
Number of DEF vias:       0
Number of components:     475
Number of terminals:      111
Number of snets:          2
Number of nets:           480

[INFO DRT-0167] List of default vias:
  Layer V2
    default via: VIA23
  Layer V3
    default via: VIA34
  Layer V4
    default via: VIA45
  Layer V5
    default via: VIA56
  Layer V6
    default via: VIA67
  Layer V7
    default via: VIA78
  Layer V8
    default via: VIA89
  Layer V9
    default via: VIA9Pad
[INFO DRT-0162] Library cell analysis.
[INFO DRT-0163] Instance analysis.
[INFO DRT-0164] Number of unique instances = 79.
[INFO DRT-0168] Init region query.
[INFO DRT-0024]   Complete Active.
[INFO DRT-0024]   Complete V0.
[INFO DRT-0024]   Complete M1.
[INFO DRT-0024]   Complete V1.
[INFO DRT-0024]   Complete M2.
[INFO DRT-0024]   Complete V2.
[INFO DRT-0024]   Complete M3.
[INFO DRT-0024]   Complete V3.
[INFO DRT-0024]   Complete M4.
[INFO DRT-0024]   Complete V4.
[INFO DRT-0024]   Complete M5.
[INFO DRT-0024]   Complete V5.
[INFO DRT-0024]   Complete M6.
[INFO DRT-0024]   Complete V6.
[INFO DRT-0024]   Complete M7.
[INFO DRT-0024]   Complete V7.
[INFO DRT-0024]   Complete M8.
[INFO DRT-0024]   Complete V8.
[INFO DRT-0024]   Complete M9.
[INFO DRT-0024]   Complete V9.
[INFO DRT-0024]   Complete Pad.
[INFO DRT-0033] Active shape region query size = 0.
[INFO DRT-0033] V0 shape region query size = 0.
[INFO DRT-0033] M1 shape region query size = 6144.
[INFO DRT-0033] V1 shape region query size = 13668.
[INFO DRT-0033] M2 shape region query size = 401.
[INFO DRT-0033] V2 shape region query size = 315.
[INFO DRT-0033] M3 shape region query size = 315.
[INFO DRT-0033] V3 shape region query size = 210.
[INFO DRT-0033] M4 shape region query size = 243.
[INFO DRT-0033] V4 shape region query size = 210.
[INFO DRT-0033] M5 shape region query size = 196.
[INFO DRT-0033] V5 shape region query size = 20.
[INFO DRT-0033] M6 shape region query size = 18.
[INFO DRT-0033] V6 shape region query size = 0.
[INFO DRT-0033] M7 shape region query size = 0.
[INFO DRT-0033] V7 shape region query size = 0.
[INFO DRT-0033] M8 shape region query size = 0.
[INFO DRT-0033] V8 shape region query size = 0.
[INFO DRT-0033] M9 shape region query size = 0.
[INFO DRT-0033] V9 shape region query size = 0.
[INFO DRT-0033] Pad shape region query size = 0.
[INFO DRT-0165] Start pin access.
[INFO DRT-0078]   Complete 415 pins.
[INFO DRT-0081]   Complete 79 unique inst patterns.
[INFO DRT-0084]   Complete 276 groups.
#scanned instances     = 475
#unique  instances     = 79
#stdCellGenAp          = 1887
#stdCellValidPlanarAp  = 52
#stdCellValidViaAp     = 1483
#stdCellPinNoAp        = 0
#stdCellPinCnt         = 1067
#instTermValidViaApCnt = 0
#macroGenAp            = 0
#macroValidPlanarAp    = 0
#macroValidViaAp       = 0
#macroNoAp             = 0
[INFO DRT-0166] Complete pin access.
[INFO DRT-0267] cpu time = 00:00:12, elapsed time = 00:00:01, memory = 268.68 (MB), peak = 268.68 (MB)

[INFO DRT-0157] Number of guides:     2638

[INFO DRT-0169] Post process guides.
[INFO DRT-0176] GCELLGRID X 0 DO 26 STEP 570 ;
[INFO DRT-0177] GCELLGRID Y 0 DO 26 STEP 570 ;
[INFO DRT-0028]   Complete Active.
[INFO DRT-0028]   Complete V0.
[INFO DRT-0028]   Complete M1.
[INFO DRT-0028]   Complete V1.
[INFO DRT-0028]   Complete M2.
[INFO DRT-0028]   Complete V2.
[INFO DRT-0028]   Complete M3.
[INFO DRT-0028]   Complete V3.
[INFO DRT-0028]   Complete M4.
[INFO DRT-0028]   Complete V4.
[INFO DRT-0028]   Complete M5.
[INFO DRT-0028]   Complete V5.
[INFO DRT-0028]   Complete M6.
[INFO DRT-0028]   Complete V6.
[INFO DRT-0028]   Complete M7.
[INFO DRT-0028]   Complete V7.
[INFO DRT-0028]   Complete M8.
[INFO DRT-0028]   Complete V8.
[INFO DRT-0028]   Complete M9.
[INFO DRT-0028]   Complete V9.
[INFO DRT-0028]   Complete Pad.
[INFO DRT-0178] Init guide query.
[INFO DRT-0035]   Complete Active (guide).
[INFO DRT-0035]   Complete V0 (guide).
[INFO DRT-0035]   Complete M1 (guide).
[INFO DRT-0035]   Complete V1 (guide).
[INFO DRT-0035]   Complete M2 (guide).
[INFO DRT-0035]   Complete V2 (guide).
[INFO DRT-0035]   Complete M3 (guide).
[INFO DRT-0035]   Complete V3 (guide).
[INFO DRT-0035]   Complete M4 (guide).
[INFO DRT-0035]   Complete V4 (guide).
[INFO DRT-0035]   Complete M5 (guide).
[INFO DRT-0035]   Complete V5 (guide).
[INFO DRT-0035]   Complete M6 (guide).
[INFO DRT-0035]   Complete V6 (guide).
[INFO DRT-0035]   Complete M7 (guide).
[INFO DRT-0035]   Complete V7 (guide).
[INFO DRT-0035]   Complete M8 (guide).
[INFO DRT-0035]   Complete V8 (guide).
[INFO DRT-0035]   Complete M9 (guide).
[INFO DRT-0035]   Complete V9 (guide).
[INFO DRT-0035]   Complete Pad (guide).
[INFO DRT-0036] Active guide region query size = 0.
[INFO DRT-0036] V0 guide region query size = 0.
[INFO DRT-0036] M1 guide region query size = 849.
[INFO DRT-0036] V1 guide region query size = 0.
[INFO DRT-0036] M2 guide region query size = 731.
[INFO DRT-0036] V2 guide region query size = 0.
[INFO DRT-0036] M3 guide region query size = 366.
[INFO DRT-0036] V3 guide region query size = 0.
[INFO DRT-0036] M4 guide region query size = 80.
[INFO DRT-0036] V4 guide region query size = 0.
[INFO DRT-0036] M5 guide region query size = 46.
[INFO DRT-0036] V5 guide region query size = 0.
[INFO DRT-0036] M6 guide region query size = 0.
[INFO DRT-0036] V6 guide region query size = 0.
[INFO DRT-0036] M7 guide region query size = 0.
[INFO DRT-0036] V7 guide region query size = 0.
[INFO DRT-0036] M8 guide region query size = 0.
[INFO DRT-0036] V8 guide region query size = 0.
[INFO DRT-0036] M9 guide region query size = 0.
[INFO DRT-0036] V9 guide region query size = 0.
[INFO DRT-0036] Pad guide region query size = 0.
[INFO DRT-0179] Init gr pin query.
[INFO DRT-0267] cpu time = 00:00:00, elapsed time = 00:00:00, memory = 268.93 (MB), peak = 268.93 (MB)
[INFO DRT-0245] skipped writing guide updates to database.
[INFO DRT-0185] Post process initialize RPin region query.
[INFO DRT-0181] Start track assignment.
[INFO DRT-0184] Done with 1261 vertical wires in 1 frboxes and 811 horizontal wires in 1 frboxes.
[INFO DRT-0186] Done with 67 vertical wires in 1 frboxes and 130 horizontal wires in 1 frboxes.
[INFO DRT-0182] Complete track assignment.
[INFO DRT-0267] cpu time = 00:00:00, elapsed time = 00:00:00, memory = 277.18 (MB), peak = 277.18 (MB)
[INFO DRT-0187] Start routing data preparation.
[INFO DRT-0267] cpu time = 00:00:00, elapsed time = 00:00:00, memory = 277.43 (MB), peak = 277.43 (MB)
[INFO DRT-0194] Start detail routing.
[INFO DRT-0195] Start 0th optimization iteration.
    Completing 10% with 0 violations.
    elapsed time = 00:00:00, memory = 584.05 (MB).
    Completing 20% with 0 violations.
    elapsed time = 00:00:01, memory = 345.82 (MB).
    Completing 30% with 1 violations.
    elapsed time = 00:00:01, memory = 705.15 (MB).
    Completing 40% with 1 violations.
    elapsed time = 00:00:01, memory = 571.02 (MB).
    Completing 50% with 1 violations.
    elapsed time = 00:00:02, memory = 419.52 (MB).
    Completing 60% with 11 violations.
    elapsed time = 00:00:03, memory = 766.04 (MB).
    Completing 70% with 11 violations.
    elapsed time = 00:00:03, memory = 501.24 (MB).
    Completing 80% with 12 violations.
    elapsed time = 00:00:04, memory = 893.74 (MB).
    Completing 90% with 12 violations.
    elapsed time = 00:00:04, memory = 710.11 (MB).
    Completing 100% with 17 violations.
    elapsed time = 00:00:05, memory = 541.65 (MB).
[INFO DRT-0199]   Number of violations = 34.
Viol/Layer          M1     M2     M3
EOL                  0      2      0
Metal Spacing        3      1      1
Recheck              0     13      4
Short                0      1      0
eolKeepOut           0      9      0
[INFO DRT-0267] cpu time = 00:00:14, elapsed time = 00:00:05, memory = 1083.83 (MB), peak = 1095.65 (MB)
Total wire length = 699 um.
Total wire length on LAYER M1 = 0 um.
Total wire length on LAYER M2 = 272 um.
Total wire length on LAYER M3 = 335 um.
Total wire length on LAYER M4 = 57 um.
Total wire length on LAYER M5 = 34 um.
Total wire length on LAYER M6 = 0 um.
Total wire length on LAYER M7 = 0 um.
Total wire length on LAYER M8 = 0 um.
Total wire length on LAYER M9 = 0 um.
Total wire length on LAYER Pad = 0 um.
Total number of vias = 2626.
Up-via summary (total 2626):

---------------
 Active       0
     M1    1045
     M2    1412
     M3     123
     M4      46
     M5       0
     M6       0
     M7       0
     M8       0
     M9       0
---------------
       2626


[INFO DRT-0195] Start 1st optimization iteration.
    Completing 10% with 34 violations.
    elapsed time = 00:00:00, memory = 1310.70 (MB).
    Completing 20% with 34 violations.
    elapsed time = 00:00:01, memory = 1133.01 (MB).
    Completing 30% with 32 violations.
    elapsed time = 00:00:02, memory = 1457.62 (MB).
    Completing 40% with 32 violations.
    elapsed time = 00:00:02, memory = 1372.33 (MB).
    Completing 50% with 32 violations.
    elapsed time = 00:00:03, memory = 1218.76 (MB).
    Completing 60% with 20 violations.
    elapsed time = 00:00:03, memory = 1511.33 (MB).
    Completing 70% with 20 violations.
    elapsed time = 00:00:04, memory = 1255.40 (MB).
    Completing 80% with 6 violations.
    elapsed time = 00:00:05, memory = 1667.88 (MB).
    Completing 90% with 6 violations.
    elapsed time = 00:00:05, memory = 1450.10 (MB).
    Completing 100% with 0 violations.
    elapsed time = 00:00:05, memory = 1309.15 (MB).
[INFO DRT-0199]   Number of violations = 0.
[INFO DRT-0267] cpu time = 00:00:15, elapsed time = 00:00:05, memory = 1310.30 (MB), peak = 1752.90 (MB)
Total wire length = 691 um.
Total wire length on LAYER M1 = 0 um.
Total wire length on LAYER M2 = 267 um.
Total wire length on LAYER M3 = 331 um.
Total wire length on LAYER M4 = 57 um.
Total wire length on LAYER M5 = 35 um.
Total wire length on LAYER M6 = 0 um.
Total wire length on LAYER M7 = 0 um.
Total wire length on LAYER M8 = 0 um.
Total wire length on LAYER M9 = 0 um.
Total wire length on LAYER Pad = 0 um.
Total number of vias = 2564.
Up-via summary (total 2564):

---------------
 Active       0
     M1    1039
     M2    1365
     M3     114
     M4      46
     M5       0
     M6       0
     M7       0
     M8       0
     M9       0
---------------
       2564


[INFO DRT-0198] Complete detail routing.
Total wire length = 691 um.
Total wire length on LAYER M1 = 0 um.
Total wire length on LAYER M2 = 267 um.
Total wire length on LAYER M3 = 331 um.
Total wire length on LAYER M4 = 57 um.
Total wire length on LAYER M5 = 35 um.
Total wire length on LAYER M6 = 0 um.
Total wire length on LAYER M7 = 0 um.
Total wire length on LAYER M8 = 0 um.
Total wire length on LAYER M9 = 0 um.
Total wire length on LAYER Pad = 0 um.
Total number of vias = 2564.
Up-via summary (total 2564):

---------------
 Active       0
     M1    1039
     M2    1365
     M3     114
     M4      46
     M5       0
     M6       0
     M7       0
     M8       0
     M9       0
---------------
       2564


[INFO DRT-0267] cpu time = 00:00:30, elapsed time = 00:00:11, memory = 1310.30 (MB), peak = 1752.90 (MB)

[INFO DRT-0180] Post processing.
Took 13 seconds: detailed_route -output_drc ./reports/asap7/tritone/base/5_route_drc.rpt -output_maze ./results/asap7/tritone/base/maze.log -droute_end_iter 64 -verbose 1 -drc_report_iter_step 5
[WARNING GRT-0246] No diode with LEF class CORE ANTENNACELL found.
[INFO ANT-0002] Found 0 net violations.
[INFO ANT-0001] Found 0 pin violations.
[INFO ANT-0002] Found 0 net violations.
[INFO ANT-0001] Found 0 pin violations.
Report metrics stage 5, detailed route...

==========================================================================
detailed route report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Elapsed time: 0:14.03[h:]min:sec. CPU time: user 36.92 sys 8.25 (321%). Peak memory: 1794968KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
5_2_route                         14           1752 52effd812754d9ef7704
/OpenROAD-flow-scripts/flow/scripts/flow.sh 5_3_fillcell fillcell
Running fillcell.tcl, stage 5_3_fillcell
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/5_2_route.odb
filler_placement "FILLERxp5_ASAP7_75t_R FILLER_ASAP7_75t_R DECAPx1_ASAP7_75t_R DECAPx2_ASAP7_75t_R DECAPx4_ASAP7_75t_R DECAPx6_ASAP7_75t_R DECAPx10_ASAP7_75t_R"
[INFO DPL-0001] Placed 676 filler instances.
Elapsed time: 0:00.94[h:]min:sec. CPU time: user 0.85 sys 0.09 (100%). Peak memory: 196368KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
5_3_fillcell                       0            191 b924d4d2e5ae2ff50094
cp ./results/asap7/tritone/base/5_3_fillcell.odb ./results/asap7/tritone/base/5_route.odb
cp ./results/asap7/tritone/base/5_1_grt.sdc ./results/asap7/tritone/base/5_route.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 6_1_fill density_fill
Running density_fill.tcl, stage 6_1_fill
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/5_route.odb
exec cp ./results/asap7/tritone/base/5_route.odb ./results/asap7/tritone/base/6_1_fill.odb
Elapsed time: 0:00.94[h:]min:sec. CPU time: user 0.82 sys 0.11 (99%). Peak memory: 194368KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
6_1_fill                           0            189 b924d4d2e5ae2ff50094
cp ./results/asap7/tritone/base/5_route.sdc ./results/asap7/tritone/base/6_1_fill.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 6_report final_report
Running final_report.tcl, stage 6_report
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/6_1_fill.odb
Deleted 0 routing obstructions
[INFO RCX-0431] Defined process_corner X with ext_model_index 0
[INFO RCX-0029] Defined extraction corner X
[INFO RCX-0435] Reading extraction model file /OpenROAD-flow-scripts/flow/platforms/asap7/rcx_patterns.rules ...
[INFO RCX-0436] RC segment generation ternary_cpu_system (max_merge_res 50.0) ...
[INFO RCX-0040] Final 1939 rc segments
[INFO RCX-0439] Coupling Cap extraction ternary_cpu_system ...
[INFO RCX-0440] Coupling threshhold is 0.1000 fF, coupling capacitance less than 0.1000 fF will be grounded.
[INFO RCX-0442] 56% of 2017 wires extracted
[INFO RCX-0442] 100% of 2017 wires extracted
[INFO RCX-0045] Extract 480 nets, 2380 rsegs, 2380 caps, 1635 ccs
[INFO RCX-0443] 480 nets finished
[INFO PSM-0040] All shapes on net VDD are connected.
########## IR report #################
Net              : VDD
Corner           : default
Total power      : 7.86e-06 W
Supply voltage   : 7.70e-01 V
Worstcase voltage: 7.70e-01 V
Average voltage  : 7.70e-01 V
Average IR drop  : 2.14e-05 V
Worstcase IR drop: 1.26e-04 V
Percentage drop  : 0.02 %
######################################
[INFO PSM-0040] All shapes on net VSS are connected.
########## IR report #################
Net              : VSS
Corner           : default
Total power      : 7.86e-06 W
Supply voltage   : 0.00e+00 V
Worstcase voltage: 8.92e-05 V
Average voltage  : 1.29e-05 V
Average IR drop  : 1.29e-05 V
Worstcase IR drop: 8.92e-05 V
Percentage drop  : 0.01 %
######################################
Cell type report:                       Count       Area
  Fill cell                               676      83.05
  Tap cell                                 82       2.39
  Tie cell                                 76       3.32
  Clock buffer                              4       0.38
  Timing Repair Buffer                     20       1.46
  Inverter                                 84       3.67
  Sequential cell                          19       7.20
  Multi-Input combinational cell          190      22.86
  Total                                  1151     124.34
Report metrics stage 6, finish...

==========================================================================
finish report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
[WARNING GUI-0076] QStandardPaths: XDG_RUNTIME_DIR not set, defaulting to '/tmp/runtime-root'
Elapsed time: 0:01.93[h:]min:sec. CPU time: user 1.71 sys 0.18 (98%). Peak memory: 261476KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
6_report                           1            255                  N/A
cp ./results/asap7/tritone/base/5_route.sdc ./results/asap7/tritone/base/6_final.sdc
cp /OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7_tech_1x_201209.lef ./objects/asap7/tritone/base/klayout_tech.lef
SC_LEF_RELATIVE_PATH="../../../../platforms/asap7/lef/asap7sc7p5t_28_R_1x_220121a.lef"; \
OTHER_LEFS_RELATIVE_PATHS=$(echo "<lef-files>$(realpath --relative-to=./results/asap7/tritone/base ./objects/asap7/tritone/base/klayout_tech.lef)</lef-files>"); \
sed 's,<lef-files>.*</lef-files>,<lef-files>'"$SC_LEF_RELATIVE_PATH"'</lef-files>'"$OTHER_LEFS_RELATIVE_PATHS"',g' /OpenROAD-flow-scripts/flow/platforms/asap7/KLayout/asap7.lyt > ./objects/asap7/tritone/base/klayout.lyt
sed -i 's,<map-file>.*</map-file>,<map-file>/OpenROAD-flow-scripts/flow/platforms/asap7/*map</map-file>,g' ./objects/asap7/tritone/base/klayout.lyt
(env time -f 'Elapsed time: %E[h:]min:sec. CPU time: user %U sys %S (%P). Peak memory: %MKB.' stdbuf -o L /OpenROAD-flow-scripts/flow/scripts/klayout.sh -zz -rd design_name=ternary_cpu_system \
        -rd in_def=./results/asap7/tritone/base/6_final.def \
        -rd in_files="/OpenROAD-flow-scripts/flow/platforms/asap7/gds/asap7sc7p5t_28_R_220121a.gds  " \
        -rd seal_file="" \
        -rd out_file=./results/asap7/tritone/base/6_1_merged.gds \
        -rd tech_file=./objects/asap7/tritone/base/klayout.lyt \
        -rd layer_map= \
        -r /OpenROAD-flow-scripts/flow/util/def2stream.py) 2>&1 | tee /OpenROAD-flow-scripts/flow/logs/asap7/tritone/base/6_1_merge.log
KLayout 0.30.3
Warning: DEF UNITS does not match reader DBU (DEF UNITS is 1000 and corresponds to a DBU of 0.001, but reader DBU is set to 0.00025) (line=5, cell=, file=6_final.def)
[INFO] Reporting cells prior to loading DEF ...
        /OpenROAD-flow-scripts/flow/platforms/asap7/gds/asap7sc7p5t_28_R_220121a.gds
[INFO] GDS_ALLOW_EMPTY=fakeram.*
[INFO] All LEF cells have matching GDS/OAS cells
[INFO] No orphan cells in the final layout
Elapsed time: 0:01.27[h:]min:sec. CPU time: user 0.96 sys 0.14 (87%). Peak memory: 433064KB.
cp results/asap7/tritone/base/6_1_merged.gds results/asap7/tritone/base/6_final.gds
./logs/asap7/tritone/base
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
1_1_yosys_canonicalize             1             78 9166070e25fb86adda93
1_2_yosys                          4            153 c338f4409e396fe16a6d
1_synth                            0            190 c4e3057fbeda64364de9
2_1_floorplan                      1            210 d30f639000c655c76a51
2_2_floorplan_macro                0            188 d30f639000c655c76a51
2_3_floorplan_tapcell              0            188 d94e2b7b3bc316500acf
2_4_floorplan_pdn                  0            190 23fde6d58e287e59c506
3_1_place_gp_skip_io              10            189 0a300f68f856bf89a87c
3_2_place_iop                      0            189 be7f26d0769054260412
3_3_place_gp                      11            281 4699b0d523198ad52423
3_4_place_resized                  1            209 4699b0d523198ad52423
3_5_place_dp                       1            194 19b1386384311d96a2e0
4_1_cts                            2            231 cea6bd01096b6d40dafb
5_1_grt                            2            295 22989f632b7db45d1ab8
5_2_route                         14           1752 52effd812754d9ef7704
5_3_fillcell                       0            191 b924d4d2e5ae2ff50094
6_1_fill                           0            189 b924d4d2e5ae2ff50094
6_1_merge                          1            422                  N/A
6_report                           1            255                  N/A
Total                             49           1752
PS E:\ternary cmos compile\tritone-complete\OpenROAD-flow-scripts-master>   docker run --rm -it -v "E:/ternary cmos compile/tritone-complete/OpenROAD-flow-scripts-master/flow/designs/asap7/tritone:/OpenROAD-flow-scripts/flow/designs/asap7/tritone" -v "E:/ternary cmos compile/tritone-complete/OpenROAD-flow-scripts-master/flow/designs/src/tritone:/OpenROAD-flow-scripts/flow/designs/src/tritone" -w /OpenROAD-flow-scripts/flow openroad/orfs:latest bash -c "make DESIGN_CONFIG=./designs/asap7/tritone/config.mk && cat results/asap7/tritone/base/6_final_metrics.json"
mkdir -p results/asap7/tritone/base/
echo 3330 > results/asap7/tritone/base/clock_period.txt
/OpenROAD-flow-scripts/flow/scripts/synth.sh /OpenROAD-flow-scripts/flow/scripts/synth_canonicalize.tcl ./logs/asap7/tritone/base/1_1_yosys_canonicalize.log
Using ABC speed script.
Extracting clock period from SDC file: ./results/asap7/tritone/base/clock_period.txt
Setting clock period to 3330
1. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
2. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
3. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
4. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
5. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
6. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
7. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
8. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
9. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
10. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
11. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/btfa.sv
12. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/btisa_decoder.sv
13. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/clock_gate.sv
14. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_adder.sv
15. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_alu.sv
16. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_cpu.sv
17. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_cpu_system.sv
18. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_forward_unit.sv
19. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_hazard_unit.sv
20. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_memory.sv
21. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_regfile.sv
22. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_clkgate_R.v
23. Executing HIERARCHY pass (managing design hierarchy).
24. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_cpu_system'.
24.1. Analyzing design hierarchy..
24.2. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_memory'.
24.3. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_cpu'.
24.4. Analyzing design hierarchy..
24.5. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_forward_unit'.
24.6. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_hazard_unit'.
24.7. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_alu'.
24.8. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_regfile'.
Warning: Replacing memory \regs with list of registers. See /OpenROAD-flow-scripts/flow/designs/src/tritone/ternary_regfile.sv:129
24.9. Executing AST frontend in derive mode using pre-parsed AST for module `\btisa_decoder'.
24.10. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_adder'.
24.11. Analyzing design hierarchy..
24.12. Executing AST frontend in derive mode using pre-parsed AST for module `\ternary_adder'.
24.13. Executing AST frontend in derive mode using pre-parsed AST for module `\btfa'.
24.14. Analyzing design hierarchy..
24.15. Analyzing design hierarchy..
24.16. Analyzing design hierarchy..
25. Executing OPT_CLEAN pass (remove unused cells and wires).
Warning: Ignoring module $paramod\ternary_adder\WIDTH=s32'00000000000000000000000000001000 because it contains processes (run 'proc' command first).
Warning: Ignoring module btfa because it contains processes (run 'proc' command first).
Warning: Ignoring module btisa_decoder because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod$4a12332018d758461ddf52371bdc2df23dae4fbf\ternary_regfile because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod\ternary_alu\WIDTH=s32'00000000000000000000000000011011 because it contains processes (run 'proc' command first).
Warning: Ignoring module ternary_hazard_unit because it contains processes (run 'proc' command first).
Warning: Ignoring module ternary_forward_unit because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod\ternary_cpu\TRIT_WIDTH=s32'00000000000000000000000000011011 because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod$21963defc1890383001fc13d5c5c8630a07bb93b\ternary_memory because it contains processes (run 'proc' command first).
Warning: Ignoring module $paramod\ternary_adder\WIDTH=s32'00000000000000000000000000011011 because it contains processes (run 'proc' command first).
26. Executing RTLIL backend.
Warnings: 11 unique messages, 11 total
End of script. Logfile hash: b647dcb46a, CPU: user 0.57s system 0.02s, MEM: 75.75 MB peak
Yosys 0.60 (git sha1 UNKNOWN, g++ 11.4.0-1ubuntu1~22.04.2 -fPIC -O3)
Time spent: 85% 12x read_liberty (0 sec), 9% 1x hierarchy (0 sec), ...
Elapsed time: 0:00.82[h:]min:sec. CPU time: user 0.61 sys 0.02 (78%). Peak memory: 80952KB.
/OpenROAD-flow-scripts/flow/scripts/synth.sh /OpenROAD-flow-scripts/flow/scripts/synth.tcl ./logs/asap7/tritone/base/1_2_yosys.log
Using ABC speed script.
Extracting clock period from SDC file: ./results/asap7/tritone/base/clock_period.txt
Setting clock period to 3330
1. Executing RTLIL frontend.
2. Executing HIERARCHY pass (managing design hierarchy).
2.1. Analyzing design hierarchy..
2.2. Analyzing design hierarchy..
3. Executing SYNTH pass.
3.1. Executing HIERARCHY pass (managing design hierarchy).
3.1.1. Analyzing design hierarchy..
3.1.2. Analyzing design hierarchy..
3.2. Executing PROC pass (convert processes to netlists).
3.2.1. Executing PROC_CLEAN pass (remove empty switches from decision trees).
3.2.2. Executing PROC_RMDEAD pass (remove dead branches from decision trees).
3.2.3. Executing PROC_PRUNE pass (remove redundant assignments in processes).
3.2.4. Executing PROC_INIT pass (extract init attributes).
3.2.5. Executing PROC_ARST pass (detect async resets in processes).
3.2.6. Executing PROC_ROM pass (convert switches to ROMs).
3.2.7. Executing PROC_MUX pass (convert decision trees to multiplexers).
3.2.8. Executing PROC_DLATCH pass (convert process syncs to latches).
3.2.9. Executing PROC_DFF pass (convert process syncs to FFs).
3.2.10. Executing PROC_MEMWR pass (convert process memory writes to cells).
3.2.11. Executing PROC_CLEAN pass (remove empty switches from decision trees).
3.2.12. Executing OPT_EXPR pass (perform const folding).
3.3. Executing FLATTEN pass (flatten design).
3.4. Executing OPT_EXPR pass (perform const folding).
3.5. Executing OPT_CLEAN pass (remove unused cells and wires).
3.6. Executing CHECK pass (checking for obvious problems).
3.7. Executing OPT pass (performing simple optimizations).
3.7.1. Executing OPT_EXPR pass (perform const folding).
3.7.2. Executing OPT_MERGE pass (detect identical cells).
3.7.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.5. Executing OPT_MERGE pass (detect identical cells).
3.7.6. Executing OPT_DFF pass (perform DFF optimizations).
3.7.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.8. Executing OPT_EXPR pass (perform const folding).
3.7.9. Rerunning OPT passes. (Maybe there is more to do..)
3.7.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.12. Executing OPT_MERGE pass (detect identical cells).
3.7.13. Executing OPT_DFF pass (perform DFF optimizations).
3.7.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.15. Executing OPT_EXPR pass (perform const folding).
3.7.16. Rerunning OPT passes. (Maybe there is more to do..)
3.7.17. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.18. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.19. Executing OPT_MERGE pass (detect identical cells).
3.7.20. Executing OPT_DFF pass (perform DFF optimizations).
3.7.21. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.22. Executing OPT_EXPR pass (perform const folding).
3.7.23. Finished fast OPT passes. (There is nothing left to do.)
3.8. Executing FSM pass (extract and optimize FSM).
3.8.1. Executing FSM_DETECT pass (finding FSMs in design).
3.8.2. Executing FSM_EXTRACT pass (extracting FSM from design).
3.8.3. Executing FSM_OPT pass (simple optimizations of FSMs).
3.8.4. Executing OPT_CLEAN pass (remove unused cells and wires).
3.8.5. Executing FSM_OPT pass (simple optimizations of FSMs).
3.8.6. Executing FSM_RECODE pass (re-assigning FSM state encoding).
3.8.7. Executing FSM_INFO pass (dumping all available information on FSM cells).
3.8.8. Executing FSM_MAP pass (mapping FSMs to basic logic).
3.9. Executing OPT pass (performing simple optimizations).
3.9.1. Executing OPT_EXPR pass (perform const folding).
3.9.2. Executing OPT_MERGE pass (detect identical cells).
3.9.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.5. Executing OPT_MERGE pass (detect identical cells).
3.9.6. Executing OPT_DFF pass (perform DFF optimizations).
3.9.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.8. Executing OPT_EXPR pass (perform const folding).
3.9.9. Rerunning OPT passes. (Maybe there is more to do..)
3.9.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.12. Executing OPT_MERGE pass (detect identical cells).
3.9.13. Executing OPT_DFF pass (perform DFF optimizations).
3.9.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.15. Executing OPT_EXPR pass (perform const folding).
3.9.16. Rerunning OPT passes. (Maybe there is more to do..)
3.9.17. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.18. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.19. Executing OPT_MERGE pass (detect identical cells).
3.9.20. Executing OPT_DFF pass (perform DFF optimizations).
3.9.21. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.22. Executing OPT_EXPR pass (perform const folding).
3.9.23. Finished fast OPT passes. (There is nothing left to do.)
3.10. Executing WREDUCE pass (reducing word size of cells).
3.11. Executing PEEPOPT pass (run peephole optimizers).
3.12. Executing OPT_CLEAN pass (remove unused cells and wires).
3.13. Executing ALUMACC pass (create $alu and $macc cells).
3.14. Executing SHARE pass (SAT-based resource sharing).
3.15. Executing OPT pass (performing simple optimizations).
3.15.1. Executing OPT_EXPR pass (perform const folding).
3.15.2. Executing OPT_MERGE pass (detect identical cells).
3.15.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.15.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.15.5. Executing OPT_MERGE pass (detect identical cells).
3.15.6. Executing OPT_DFF pass (perform DFF optimizations).
3.15.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.15.8. Executing OPT_EXPR pass (perform const folding).
3.15.9. Rerunning OPT passes. (Maybe there is more to do..)
3.15.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.15.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.15.12. Executing OPT_MERGE pass (detect identical cells).
3.15.13. Executing OPT_DFF pass (perform DFF optimizations).
3.15.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.15.15. Executing OPT_EXPR pass (perform const folding).
3.15.16. Finished fast OPT passes. (There is nothing left to do.)
3.16. Executing MEMORY pass.
3.16.1. Executing OPT_MEM pass (optimize memories).
3.16.2. Executing OPT_MEM_PRIORITY pass (removing unnecessary memory write priority relations).
3.16.3. Executing OPT_MEM_FEEDBACK pass (finding memory read-to-write feedback paths).
3.16.4. Executing MEMORY_BMUX2ROM pass (converting muxes to ROMs).
3.16.5. Executing MEMORY_DFF pass (merging $dff cells to $memrd).
3.16.6. Executing OPT_CLEAN pass (remove unused cells and wires).
3.16.7. Executing MEMORY_SHARE pass (consolidating $memrd/$memwr cells).
3.16.8. Executing OPT_MEM_WIDEN pass (optimize memories where all ports are wide).
3.16.9. Executing OPT_CLEAN pass (remove unused cells and wires).
3.16.10. Executing MEMORY_COLLECT pass (generating $mem cells).
3.17. Executing OPT_CLEAN pass (remove unused cells and wires).
4. Executing SYNTH pass.
4.1. Executing OPT pass (performing simple optimizations).
4.1.1. Executing OPT_EXPR pass (perform const folding).
4.1.2. Executing OPT_MERGE pass (detect identical cells).
4.1.3. Executing OPT_DFF pass (perform DFF optimizations).
4.1.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.5. Rerunning OPT passes. (Removed registers in this run.)
4.1.6. Executing OPT_EXPR pass (perform const folding).
4.1.7. Executing OPT_MERGE pass (detect identical cells).
4.1.8. Executing OPT_DFF pass (perform DFF optimizations).
4.1.9. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.10. Rerunning OPT passes. (Removed registers in this run.)
4.1.11. Executing OPT_EXPR pass (perform const folding).
4.1.12. Executing OPT_MERGE pass (detect identical cells).
4.1.13. Executing OPT_DFF pass (perform DFF optimizations).
4.1.14. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.15. Rerunning OPT passes. (Removed registers in this run.)
4.1.16. Executing OPT_EXPR pass (perform const folding).
4.1.17. Executing OPT_MERGE pass (detect identical cells).
4.1.18. Executing OPT_DFF pass (perform DFF optimizations).
4.1.19. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.20. Finished fast OPT passes.
4.2. Executing MEMORY_MAP pass (converting memories to logic and flip-flops).
4.3. Executing OPT pass (performing simple optimizations).
4.3.1. Executing OPT_EXPR pass (perform const folding).
4.3.2. Executing OPT_MERGE pass (detect identical cells).
4.3.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.5. Executing OPT_MERGE pass (detect identical cells).
4.3.6. Executing OPT_SHARE pass.
4.3.7. Executing OPT_DFF pass (perform DFF optimizations).
4.3.8. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.9. Executing OPT_EXPR pass (perform const folding).
4.3.10. Rerunning OPT passes. (Maybe there is more to do..)
4.3.11. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.12. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.13. Executing OPT_MERGE pass (detect identical cells).
4.3.14. Executing OPT_SHARE pass.
4.3.15. Executing OPT_DFF pass (perform DFF optimizations).
4.3.16. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.17. Executing OPT_EXPR pass (perform const folding).
4.3.18. Rerunning OPT passes. (Maybe there is more to do..)
4.3.19. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.20. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.21. Executing OPT_MERGE pass (detect identical cells).
4.3.22. Executing OPT_SHARE pass.
4.3.23. Executing OPT_DFF pass (perform DFF optimizations).
4.3.24. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.25. Executing OPT_EXPR pass (perform const folding).
4.3.26. Finished fast OPT passes. (There is nothing left to do.)
4.4. Executing TECHMAP pass (map to technology primitives).
4.4.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/tools/install/yosys/bin/../share/yosys/techmap.v
4.4.2. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/common/lcu_kogge_stone.v
4.4.3. Continuing TECHMAP pass.
4.5. Executing OPT pass (performing simple optimizations).
4.5.1. Executing OPT_EXPR pass (perform const folding).
4.5.2. Executing OPT_MERGE pass (detect identical cells).
4.5.3. Executing OPT_DFF pass (perform DFF optimizations).
4.5.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.5.5. Finished fast OPT passes.
4.6. Executing ABC pass (technology mapping using ABC).
4.6.1. Extracting gate netlist of module `\ternary_cpu_system' to `<abc-temp-dir>/input.blif'..
4.7. Executing OPT pass (performing simple optimizations).
4.7.1. Executing OPT_EXPR pass (perform const folding).
4.7.2. Executing OPT_MERGE pass (detect identical cells).
4.7.3. Executing OPT_DFF pass (perform DFF optimizations).
4.7.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.7.5. Finished fast OPT passes.
4.8. Executing HIERARCHY pass (managing design hierarchy).
4.8.1. Analyzing design hierarchy..
4.8.2. Analyzing design hierarchy..
4.9. Printing statistics.
4.10. Executing CHECK pass (checking for obvious problems).
5. Executing OPT pass (performing simple optimizations).
5.1. Executing OPT_EXPR pass (perform const folding).
5.2. Executing OPT_MERGE pass (detect identical cells).
5.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
5.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
5.5. Executing OPT_MERGE pass (detect identical cells).
5.6. Executing OPT_DFF pass (perform DFF optimizations).
5.7. Executing OPT_CLEAN pass (remove unused cells and wires).
5.8. Executing OPT_EXPR pass (perform const folding).
5.9. Rerunning OPT passes. (Maybe there is more to do..)
5.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
5.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
5.12. Executing OPT_MERGE pass (detect identical cells).
5.13. Executing OPT_DFF pass (perform DFF optimizations).
5.14. Executing OPT_CLEAN pass (remove unused cells and wires).
5.15. Executing OPT_EXPR pass (perform const folding).
5.16. Finished fast OPT passes. (There is nothing left to do.)
6. Executing EXTRACT_FA pass (find and extract full/half adders).
7. Executing TECHMAP pass (map to technology primitives).
7.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_adders_R.v
7.2. Continuing TECHMAP pass.
8. Executing TECHMAP pass (map to technology primitives).
8.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/tools/install/yosys/bin/../share/yosys/techmap.v
8.2. Continuing TECHMAP pass.
9. Executing OPT pass (performing simple optimizations).
9.1. Executing OPT_EXPR pass (perform const folding).
9.2. Executing OPT_MERGE pass (detect identical cells).
9.3. Executing OPT_DFF pass (perform DFF optimizations).
9.4. Executing OPT_CLEAN pass (remove unused cells and wires).
9.5. Finished fast OPT passes.
10. Executing TECHMAP pass (map to technology primitives).
10.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_latch_R.v
10.2. Continuing TECHMAP pass.
11. Executing DFFLIBMAP pass (mapping DFF cells to sequential cells from liberty file).
11.1. Executing DFFLEGALIZE pass (convert FFs to types supported by the target).
12. Executing OPT pass (performing simple optimizations).
12.1. Executing OPT_EXPR pass (perform const folding).
12.2. Executing OPT_MERGE pass (detect identical cells).
12.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
12.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
12.5. Executing OPT_MERGE pass (detect identical cells).
12.6. Executing OPT_DFF pass (perform DFF optimizations).
12.7. Executing OPT_CLEAN pass (remove unused cells and wires).
12.8. Executing OPT_EXPR pass (perform const folding).
12.9. Rerunning OPT passes. (Maybe there is more to do..)
12.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
12.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
12.12. Executing OPT_MERGE pass (detect identical cells).
12.13. Executing OPT_DFF pass (perform DFF optimizations).
12.14. Executing OPT_CLEAN pass (remove unused cells and wires).
12.15. Executing OPT_EXPR pass (perform const folding).
12.16. Finished fast OPT passes. (There is nothing left to do.)
13. Executing SETUNDEF pass (replace undef values with defined constants).
abc -script /OpenROAD-flow-scripts/flow/scripts/abc_speed.script -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib -dont_use *x1p*_ASAP7* -dont_use *xp*_ASAP7* -dont_use SDF* -dont_use ICG* -constr ./objects/asap7/tritone/base/abc.constr -D 3330
14. Executing ABC pass (technology mapping using ABC).
14.1. Extracting gate netlist of module `\ternary_cpu_system' to `<abc-temp-dir>/input.blif'..
14.1.1. Executed ABC.
14.1.2. Re-integrating ABC results.
15. Executing SPLITNETS pass (splitting up multi-bit signals).
16. Executing OPT_CLEAN pass (remove unused cells and wires).
17. Executing HILOMAP pass (mapping to constant drivers).
18. Executing INSBUF pass (insert buffer cells for connected wires).
19. Executing CHECK pass (checking for obvious problems).
20. Printing statistics.
21. Executing CHECK pass (checking for obvious problems).
22. Executing Verilog backend.
22.1. Executing BMUXMAP pass.
22.2. Executing DEMUXMAP pass.
exec cp /OpenROAD-flow-scripts/flow/designs/asap7/tritone/constraint.sdc ./results/asap7/tritone/base/1_synth.sdc
End of script. Logfile hash: 569b6050a5, CPU: user 2.76s system 0.05s, MEM: 151.73 MB peak
Yosys 0.60 (git sha1 UNKNOWN, g++ 11.4.0-1ubuntu1~22.04.2 -fPIC -O3)
Time spent: 17% 2x abc (0 sec), 16% 30x opt_clean (0 sec), ...
Elapsed time: 0:03.48[h:]min:sec. CPU time: user 3.35 sys 0.12 (99%). Peak memory: 156736KB.
cp /OpenROAD-flow-scripts/flow/designs/asap7/tritone/constraint.sdc ./results/asap7/tritone/base/1_2_yosys.sdc
OpenROAD 24Q3-11661-g86b9236cdd
Features included (+) or not (-): +GPU +GUI +Python
This program is licensed under the BSD-3 license. See the LICENSE file for details.
Components of this program may be licensed under more restrictive licenses which must be honored.
[INFO ORD-0030] Using 32 thread(s).
mkdir -p ./objects/asap7/tritone/base
/OpenROAD-flow-scripts/flow/scripts/flow.sh 1_synth synth_odb
Running synth_odb.tcl, stage 1_synth
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
[INFO ODB-0227] LEF file: /OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7_tech_1x_201209.lef, created 30 layers, 9 vias
[INFO ODB-0227] LEF file: /OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7sc7p5t_28_R_1x_220121a.lef, created 212 library cells
link_design ternary_cpu_system
Elapsed time: 0:00.85[h:]min:sec. CPU time: user 0.81 sys 0.04 (100%). Peak memory: 195760KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
1_synth                            0            191 c4e3057fbeda64364de9
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_1_floorplan floorplan
Running floorplan.tcl, stage 2_1_floorplan
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/1_synth.odb

==========================================================================
Floorplan check_setup
--------------------------------------------------------------------------
number instances in verilog is 359
[WARNING IFP-0028] Core area lower left (2.000, 2.000) snapped to (2.052, 2.160).
[INFO IFP-0001] Added 41 rows of 208 site asap7sc7p5t.
source /OpenROAD-flow-scripts/flow/platforms/asap7/openRoad/make_tracks.tcl
source /OpenROAD-flow-scripts/flow/platforms/asap7/fastroute.tcl
Repair tie lo fanout...
[INFO RSZ-0042] Inserted 56 tie TIELOx1_ASAP7_75t_R instances.
Repair tie hi fanout...
[INFO RSZ-0042] Inserted 20 tie TIEHIx1_ASAP7_75t_R instances.
repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -setup -skip_last_gasp -sequence unbuffer,sizeup,swap,buffer,vt_swap -verbose
[WARNING EST-0027] no estimated parasitics. Using wire load models.
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove
[INFO RSZ-0098] No setup violations found
Default units for flow
 time 1ps
 capacitance 1fF
 resistance 1kohm
 voltage 1v
 current 1mA
 power 1pW
 distance 1um
Report metrics stage 2, floorplan final...

==========================================================================
floorplan final report_design_area
--------------------------------------------------------------------------
Design area 42 um^2 34% utilization.
Elapsed time: 0:00.95[h:]min:sec. CPU time: user 0.86 sys 0.10 (100%). Peak memory: 216240KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_1_floorplan                      0            211 d30f639000c655c76a51
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_2_floorplan_macro macro_place
Running macro_place.tcl, stage 2_2_floorplan_macro
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/2_1_floorplan.odb
No macros found: Skipping macro_placement
Elapsed time: 0:00.83[h:]min:sec. CPU time: user 0.80 sys 0.04 (100%). Peak memory: 193268KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_2_floorplan_macro                0            188 d30f639000c655c76a51
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_3_floorplan_tapcell tapcell
Running tapcell.tcl, stage 2_3_floorplan_tapcell
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/2_2_floorplan_macro.odb
Tap and End Cap cell insertion
  TAP Cell          : TAPCELL_ASAP7_75t_R
  ENDCAP Cell       : TAPCELL_ASAP7_75t_R
  Halo Around Macro : 2 2
  TAP Cell Distance : 25
[INFO TAP-0004] Inserted 82 endcaps.
[INFO TAP-0005] Inserted 0 tapcells.
Elapsed time: 0:00.83[h:]min:sec. CPU time: user 0.77 sys 0.06 (100%). Peak memory: 192336KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_3_floorplan_tapcell              0            187 d94e2b7b3bc316500acf
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_4_floorplan_pdn pdn
Running pdn.tcl, stage 2_4_floorplan_pdn
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/2_3_floorplan_tapcell.odb
[INFO PDN-0001] Inserting grid: top
Elapsed time: 0:00.86[h:]min:sec. CPU time: user 0.80 sys 0.06 (100%). Peak memory: 195308KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_4_floorplan_pdn                  0            190 23fde6d58e287e59c506
cp ./results/asap7/tritone/base/2_4_floorplan_pdn.odb ./results/asap7/tritone/base/2_floorplan.odb
cp ./results/asap7/tritone/base/2_1_floorplan.sdc ./results/asap7/tritone/base/2_floorplan.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_1_place_gp_skip_io global_place_skip_io
Running global_place_skip_io.tcl, stage 3_1_place_gp_skip_io
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/2_floorplan.odb
[INFO GPL-0022] Initialize gpl and calculate uniform density.
Placement density is 0.4430000042915344, computed from PLACE_DENSITY_LB_ADDON  0.10 and lower bound 0.3700000047683716
global_placement -skip_io -density 0.4430000042915344 -pad_left 0 -pad_right 0
[INFO GPL-0005] Execute conjugate gradient initial placement.
[INFO GPL-0002] DBU: 1000
[INFO GPL-0003] SiteSize: (  0.054  0.270 ) um
[INFO GPL-0004] CoreBBox: (  2.052  2.160 ) ( 13.284 13.230 ) um
[INFO GPL-0032] Initializing region: Top-level
[INFO GPL-0006] Number of instances:               515
[INFO GPL-0007] Movable instances:                 433
[INFO GPL-0008] Fixed instances:                    82
[INFO GPL-0009] Dummy instances:                     0
[INFO GPL-0010] Number of nets:                    521
[INFO GPL-0011] Number of pins:                   1224
[INFO GPL-0012] Die BBox:  (  0.000  0.000 ) ( 15.327 15.327 ) um
[INFO GPL-0013] Core BBox: (  2.052  2.160 ) ( 13.284 13.230 ) um
[INFO GPL-0016] Core area:                     124.338 um^2
[INFO GPL-0014] Region name: top-level.
[INFO GPL-0015] Region area:                   124.338 um^2
[INFO GPL-0017] Fixed instances area:            2.391 um^2
[INFO GPL-0018] Movable instances area:         44.310 um^2
[INFO GPL-0019] Utilization:                    36.336 %
[INFO GPL-0020] Standard cells area:            44.310 um^2
[INFO GPL-0021] Large instances area:            0.000 um^2
[INFO GPL-0033] Initializing Nesterov region: Top-level
[INFO GPL-0023] Placement target density:       0.4430
[INFO GPL-0024] Movable insts average area:      0.102 um^2
[INFO GPL-0025] Ideal bin area:                  0.231 um^2
[INFO GPL-0026] Ideal bin count:                   538
[INFO GPL-0027] Total bin area:                124.338 um^2
[INFO GPL-0028] Bin count (X, Y):          16 ,     16
[INFO GPL-0029] Bin size (W * H):       0.702 *  0.692 um
[INFO GPL-0030] Number of bins:                    256
[INFO GPL-0007] Execute nesterov global placement.
[INFO GPL-0031] HPWL: Half-Perimeter Wirelength
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
        0 |   0.8796 |  3.377410e+02 |   +0.00% |  2.36e-11 |
       10 |   0.9049 |  6.861600e+01 |  -79.68% |  3.85e-11 |
       20 |   0.9114 |  6.401100e+01 |   -6.71% |  6.27e-11 |
       30 |   0.9118 |  6.321500e+01 |   -1.24% |  1.02e-10 |
       40 |   0.9121 |  6.330400e+01 |   +0.14% |  1.66e-10 |
       50 |   0.9102 |  6.355000e+01 |   +0.39% |  2.71e-10 |
       60 |   0.9075 |  6.394500e+01 |   +0.62% |  4.41e-10 |
       70 |   0.8987 |  6.461000e+01 |   +1.04% |  7.19e-10 |
       80 |   0.8957 |  6.568100e+01 |   +1.66% |  1.17e-09 |
       90 |   0.8852 |  6.718900e+01 |   +2.30% |  1.91e-09 |
      100 |   0.8533 |  6.980800e+01 |   +3.90% |  3.11e-09 |
      110 |   0.8155 |  8.147700e+01 |  +16.72% |  5.06e-09 |
      120 |   0.7695 |  1.052240e+02 |  +29.15% |  8.25e-09 |
      130 |   0.7302 |  1.258580e+02 |  +19.61% |  1.34e-08 |
      140 |   0.7109 |  1.408850e+02 |  +11.94% |  2.19e-08 |
      150 |   0.6699 |  1.573610e+02 |  +11.69% |  3.56e-08 |
      160 |   0.6377 |  1.678950e+02 |   +6.69% |  5.80e-08 |
      170 |   0.5813 |  1.882900e+02 |  +12.15% |  9.45e-08 |
      180 |   0.5563 |  2.014380e+02 |   +6.98% |  1.54e-07 |
      190 |   0.5156 |  2.272010e+02 |  +12.79% |  2.51e-07 |
      200 |   0.4812 |  2.418270e+02 |   +6.44% |  4.09e-07 |
      210 |   0.4387 |  2.598570e+02 |   +7.46% |  6.66e-07 |
      220 |   0.4005 |  2.749530e+02 |   +5.81% |  1.08e-06 |
      230 |   0.3605 |  2.864580e+02 |   +4.18% |  1.77e-06 |
      240 |   0.3301 |  3.007830e+02 |   +5.00% |  2.74e-06 |
      250 |   0.3022 |  3.131790e+02 |   +4.12% |  4.03e-06 |
      260 |   0.2725 |  3.212300e+02 |   +2.57% |  5.94e-06 |
      270 |   0.2414 |  3.307120e+02 |   +2.95% |  8.75e-06 |
      280 |   0.2115 |  3.373970e+02 |   +2.02% |  1.29e-05 |
      290 |   0.1828 |  3.461160e+02 |   +2.58% |  1.90e-05 |
      300 |   0.1555 |  3.518700e+02 |   +1.66% |  2.80e-05 |
      310 |   0.1327 |  3.594560e+02 |   +2.16% |  4.12e-05 |
      320 |   0.1096 |  3.637340e+02 |   +1.19% |  6.07e-05 |
      325 |   0.0995 |  3.662480e+02 |          |  7.66e-05 |
---------------------------------------------------------------
[INFO GPL-1001] Global placement finished at iteration 325
[INFO GPL-1002] Placed Cell Area               44.3105
[INFO GPL-1003] Available Free Area           121.9471
[INFO GPL-1004] Minimum Feasible Density        0.3700 (cell_area / free_area)
[INFO GPL-1006]   Suggested Target Densities:
[INFO GPL-1007]     - For 90% usage of free space: 0.4037
[INFO GPL-1008]     - For 80% usage of free space: 0.4542
[INFO GPL-1009]     - For 50% usage of free space: 0.7267
[INFO GPL-1014] Final placement area: 44.31 (+0.00%)
Took 13 seconds: global_placement -skip_io -density 0.4430000042915344 -pad_left 0 -pad_right 0
Elapsed time: 0:13.68[h:]min:sec. CPU time: user 408.63 sys 0.41 (2988%). Peak memory: 195364KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_1_place_gp_skip_io              13            190 0a300f68f856bf89a87c
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_2_place_iop io_placement
Running io_placement.tcl, stage 3_2_place_iop
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_1_place_gp_skip_io.odb
place_pins -hor_layers M4 -ver_layers M5
Found 0 macro blocks.
Using 2 tracks default min distance between IO pins.
[INFO PPL-0001] Number of available slots 576
[INFO PPL-0002] Number of I/O             109
[INFO PPL-0003] Number of I/O w/sink      77
[INFO PPL-0004] Number of I/O w/o sink    32
[INFO PPL-0005] Slots per section         200
[INFO PPL-0008] Successfully assigned pins to sections.
[INFO PPL-0012] I/O nets HPWL: 282.73 um.
Elapsed time: 0:00.88[h:]min:sec. CPU time: user 0.81 sys 0.05 (99%). Peak memory: 193668KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_2_place_iop                      0            189 be7f26d0769054260412
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_3_place_gp global_place
Running global_place.tcl, stage 3_3_place_gp
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_2_place_iop.odb
[INFO RSZ-0026] Removed 63 buffers.
Perform port buffering...
[INFO RSZ-0027] Inserted 1 BUFx2_ASAP7_75t_R input buffers.
[INFO RSZ-0028] Inserted 19 BUFx2_ASAP7_75t_R output buffers.
[INFO GPL-0022] Initialize gpl and calculate uniform density.
Placement density is 0.4160000032186508, computed from PLACE_DENSITY_LB_ADDON  0.10 and lower bound 0.3400000035762787
global_placement -density 0.4160000032186508 -pad_left 0 -pad_right 0 -routability_driven -timing_driven
[INFO GPL-0005] Execute conjugate gradient initial placement.
[INFO GPL-0002] DBU: 1000
[INFO GPL-0003] SiteSize: (  0.054  0.270 ) um
[INFO GPL-0004] CoreBBox: (  2.052  2.160 ) ( 13.284 13.230 ) um
[INFO GPL-0032] Initializing region: Top-level
[INFO GPL-0006] Number of instances:               472
[INFO GPL-0007] Movable instances:                 390
[INFO GPL-0008] Fixed instances:                    82
[INFO GPL-0009] Dummy instances:                     0
[INFO GPL-0010] Number of nets:                    478
[INFO GPL-0011] Number of pins:                   1247
[INFO GPL-0012] Die BBox:  (  0.000  0.000 ) ( 15.327 15.327 ) um
[INFO GPL-0013] Core BBox: (  2.052  2.160 ) ( 13.284 13.230 ) um
[INFO GPL-0016] Core area:                     124.338 um^2
[INFO GPL-0014] Region name: top-level.
[INFO GPL-0015] Region area:                   124.338 um^2
[INFO GPL-0017] Fixed instances area:            2.391 um^2
[INFO GPL-0018] Movable instances area:         41.118 um^2
[INFO GPL-0019] Utilization:                    33.718 %
[INFO GPL-0020] Standard cells area:            41.118 um^2
[INFO GPL-0021] Large instances area:            0.000 um^2
[InitialPlace]  Iter: 1 conjugate gradient residual: 0.00000009 HPWL: 940202
[InitialPlace]  Iter: 2 conjugate gradient residual: 0.00000007 HPWL: 699907
[InitialPlace]  Iter: 3 conjugate gradient residual: 0.00000009 HPWL: 701113
[InitialPlace]  Iter: 4 conjugate gradient residual: 0.00000011 HPWL: 707945
[InitialPlace]  Iter: 5 conjugate gradient residual: 0.00000005 HPWL: 702719
[INFO GPL-0033] Initializing Nesterov region: Top-level
[INFO GPL-0023] Placement target density:       0.4160
[INFO GPL-0024] Movable insts average area:      0.105 um^2
[INFO GPL-0025] Ideal bin area:                  0.253 um^2
[INFO GPL-0026] Ideal bin count:                   490
[INFO GPL-0027] Total bin area:                124.338 um^2
[INFO GPL-0028] Bin count (X, Y):          16 ,     16
[INFO GPL-0029] Bin size (W * H):       0.702 *  0.692 um
[INFO GPL-0030] Number of bins:                    256
[INFO GPL-0007] Execute nesterov global placement.
[INFO GPL-0031] HPWL: Half-Perimeter Wirelength
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
        0 |   0.6505 |  5.140870e+02 |   +0.00% |  8.25e-11 |
       10 |   0.6932 |  4.081000e+02 |  -20.62% |  1.34e-10 |
       20 |   0.6945 |  4.049550e+02 |   -0.77% |  2.19e-10 |
       30 |   0.7019 |  4.048120e+02 |   -0.04% |  3.57e-10 |
       40 |   0.7003 |  4.059350e+02 |   +0.28% |  5.81e-10 |
       50 |   0.6949 |  4.071680e+02 |   +0.30% |  9.46e-10 |
       60 |   0.6874 |  4.079890e+02 |   +0.20% |  1.54e-09 |
       70 |   0.6851 |  4.088150e+02 |   +0.20% |  2.51e-09 |
       80 |   0.6821 |  4.101580e+02 |   +0.33% |  4.09e-09 |
       90 |   0.6765 |  4.127130e+02 |   +0.62% |  6.66e-09 |
      100 |   0.6623 |  4.165740e+02 |   +0.94% |  1.08e-08 |
      110 |   0.6475 |  4.198650e+02 |   +0.79% |  1.77e-08 |
      120 |   0.6430 |  4.243300e+02 |   +1.06% |  2.88e-08 |
[INFO GPL-0100] Timing-driven iteration 1/2, virtual: false.
[INFO GPL-0101]    Iter: 124, overflow: 0.635, keep resizer changes at: 1, HPWL: 425724
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |       478
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
   Iter   |    Area   | Removed | Inserted |   Pins
          |           | Buffers | Buffers  | Remaining
-------------------------------------------------------
        0 |     +0.0% |       0 |        0 |       367
       36 |     +0.0% |       0 |        0 |       331
       72 |     +0.0% |       0 |        0 |       295
      108 |     +0.0% |       0 |        0 |       259
      144 |     +0.0% |       0 |        0 |       223
      180 |     +0.0% |       0 |        0 |       187
      216 |     +0.0% |       0 |        0 |       151
      252 |     +0.0% |       0 |        0 |       115
      288 |     +0.0% |       0 |        0 |        79
      324 |     +0.0% |       0 |        0 |        43
      360 |     -0.2% |       1 |        0 |         7
    final |     -0.2% |       1 |        0 |         0
-------------------------------------------------------
[INFO GPL-0106] Timing-driven: worst slack -6.66e-10
[INFO GPL-0107] Timing-driven: repair_design delta area: -0.073 um^2 (-0.18%)
[INFO GPL-0108] Timing-driven: repair_design, gpl delta gcells: -1 (-0.26%)
[INFO GPL-0109] Timing-driven: repair_design, gcells created: 0, deleted: 1
[INFO GPL-0110] Timing-driven: new target density: 0.4154022
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      130 |   0.6076 |  4.307910e+02 |   +1.52% |  4.69e-08 |
      140 |   0.6012 |  4.384280e+02 |   +1.77% |  7.64e-08 |
[INFO GPL-0038] Routability snapshot saved at iter = 142
      141 |   0.5999 |  4.390140e+02 |          |           |
      150 |   0.5765 |  4.477020e+02 |   +2.12% |  1.24e-07 |
      160 |   0.5396 |  4.559390e+02 |   +1.84% |  2.03e-07 |
      170 |   0.5098 |  4.642900e+02 |   +1.83% |  3.30e-07 |
      180 |   0.4789 |  4.758120e+02 |   +2.48% |  5.38e-07 |
      190 |   0.4335 |  4.878050e+02 |   +2.52% |  8.76e-07 |
      200 |   0.3882 |  5.014090e+02 |   +2.79% |  1.43e-06 |
      210 |   0.3527 |  5.127800e+02 |   +2.27% |  2.32e-06 |
      220 |   0.3233 |  5.210460e+02 |   +1.61% |  3.49e-06 |
[INFO GPL-0040] Routability iteration: 1
[INFO GPL-0041] Total routing overflow: 0.0000
[INFO GPL-0042] Number of overflowed tiles: 0 (0.00%)
[INFO GPL-0043] Average top 0.5% routing congestion: 0.5692
[INFO GPL-0044] Average top 1.0% routing congestion: 0.5601
[INFO GPL-0045] Average top 2.0% routing congestion: 0.5434
[INFO GPL-0046] Average top 5.0% routing congestion: 0.5117
[INFO GPL-0047] Routability iteration weighted routing congestion: 0.5647
[INFO GPL-0050] Weighted routing congestion is lower than target routing congestion(1.0100), end routability optimization.
[INFO GPL-0090] Routability finished. Target routing congestion achieved succesfully.
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      230 |   0.2953 |  5.307730e+02 |   +1.87% |  5.15e-06 |
      240 |   0.2712 |  5.375950e+02 |   +1.29% |  7.58e-06 |
      250 |   0.2390 |  5.468170e+02 |   +1.72% |  1.12e-05 |
      260 |   0.2104 |  5.529660e+02 |   +1.12% |  1.64e-05 |
[INFO GPL-0100] Timing-driven iteration 2/2, virtual: false.
[INFO GPL-0101]    Iter: 268, overflow: 0.193, keep resizer changes at: 1, HPWL: 556483
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |       477
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
   Iter   |    Area   | Removed | Inserted |   Pins
          |           | Buffers | Buffers  | Remaining
-------------------------------------------------------
        0 |     +0.0% |       0 |        0 |       367
       36 |     +0.0% |       0 |        0 |       331
       72 |     +0.0% |       0 |        0 |       295
      108 |     +0.0% |       0 |        0 |       259
      144 |     +0.0% |       0 |        0 |       223
      180 |     +0.0% |       0 |        0 |       187
      216 |     +0.0% |       0 |        0 |       151
      252 |     +0.0% |       0 |        0 |       115
      288 |     +0.0% |       0 |        0 |        79
      324 |     +0.0% |       0 |        0 |        43
      360 |     +0.0% |       0 |        0 |         7
    final |     +0.0% |       0 |        0 |         0
-------------------------------------------------------
[INFO GPL-0106] Timing-driven: worst slack -6.66e-10
[INFO GPL-0107] Timing-driven: repair_design delta area: 0.000 um^2 (+0.00%)
[INFO GPL-0108] Timing-driven: repair_design, gpl delta gcells: 0 (+0.00%)
[INFO GPL-0109] Timing-driven: repair_design, gcells created: 0, deleted: 0
[INFO GPL-0110] Timing-driven: new target density: 0.4154022
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      270 |   0.1872 |  5.586790e+02 |   +1.03% |  2.42e-05 |
      280 |   0.1605 |  5.673200e+02 |   +1.55% |  3.57e-05 |
      290 |   0.1264 |  5.726070e+02 |   +0.93% |  5.26e-05 |
      300 |   0.1064 |  5.760110e+02 |   +0.59% |  7.75e-05 |
      305 |   0.0999 |  5.797970e+02 |          |  9.77e-05 |
---------------------------------------------------------------
[INFO GPL-1001] Global placement finished at iteration 305
[INFO GPL-1003] Routability mode iteration count: 87
[INFO GPL-1005] Routability final weighted congestion: 0.5693
[INFO GPL-1002] Placed Cell Area               41.0454
[INFO GPL-1003] Available Free Area           121.9471
[INFO GPL-1004] Minimum Feasible Density        0.3400 (cell_area / free_area)
[INFO GPL-1006]   Suggested Target Densities:
[INFO GPL-1007]     - For 90% usage of free space: 0.3740
[INFO GPL-1008]     - For 80% usage of free space: 0.4207
[INFO GPL-1009]     - For 50% usage of free space: 0.6732
[INFO GPL-1011] Original area (um^2): 41.12
[INFO GPL-1012] Total routability artificial inflation: -0.07 (-0.18%)
[INFO GPL-1013] Total timing-driven delta area: -0.07 (-0.18%)
[INFO GPL-1014] Final placement area: 41.05 (-0.18%)
Took 11 seconds: global_placement -density 0.4160000032186508 -pad_left 0 -pad_right 0 -routability_driven -timing_driven
Report metrics stage 3, global place...

==========================================================================
global place report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Elapsed time: 0:11.93[h:]min:sec. CPU time: user 346.42 sys 0.53 (2907%). Peak memory: 288984KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_3_place_gp                      11            282 4699b0d523198ad52423
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_4_place_resized resize
Running resize.tcl, stage 3_4_place_resized
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_3_place_gp.odb
Perform buffer insertion and gate resizing...
repair_design -verbose
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |       477
       10 |     +0.0% |       0 |       0 |             0 |       467
       20 |     +0.0% |       0 |       0 |             0 |       457
       30 |     +0.0% |       0 |       0 |             0 |       447
       40 |     +0.0% |       0 |       0 |             0 |       437
       50 |     +0.0% |       0 |       0 |             0 |       427
       60 |     +0.0% |       0 |       0 |             0 |       417
       70 |     +0.0% |       0 |       0 |             0 |       407
       80 |     +0.0% |       0 |       0 |             0 |       397
       90 |     +0.0% |       0 |       0 |             0 |       387
      100 |     +0.0% |       0 |       0 |             0 |       377
      110 |     +0.0% |       0 |       0 |             0 |       367
      120 |     +0.0% |       0 |       0 |             0 |       357
      130 |     +0.0% |       0 |       0 |             0 |       347
      140 |     +0.0% |       0 |       0 |             0 |       337
      150 |     +0.0% |       0 |       0 |             0 |       327
      160 |     +0.0% |       0 |       0 |             0 |       317
      170 |     +0.0% |       0 |       0 |             0 |       307
      180 |     +0.0% |       0 |       0 |             0 |       297
      190 |     +0.0% |       0 |       0 |             0 |       287
      200 |     +0.0% |       0 |       0 |             0 |       277
      210 |     +0.0% |       0 |       0 |             0 |       267
      220 |     +0.0% |       0 |       0 |             0 |       257
      230 |     +0.0% |       0 |       0 |             0 |       247
      240 |     +0.0% |       0 |       0 |             0 |       237
      250 |     +0.0% |       0 |       0 |             0 |       227
      260 |     +0.0% |       0 |       0 |             0 |       217
      270 |     +0.0% |       0 |       0 |             0 |       207
      280 |     +0.0% |       0 |       0 |             0 |       197
      290 |     +0.0% |       0 |       0 |             0 |       187
      300 |     +0.0% |       0 |       0 |             0 |       177
      310 |     +0.0% |       0 |       0 |             0 |       167
      320 |     +0.0% |       0 |       0 |             0 |       157
      330 |     +0.0% |       0 |       0 |             0 |       147
      340 |     +0.0% |       0 |       0 |             0 |       137
      350 |     +0.0% |       0 |       0 |             0 |       127
      360 |     +0.0% |       0 |       0 |             0 |       117
      370 |     +0.0% |       0 |       0 |             0 |       107
      380 |     +0.0% |       0 |       0 |             0 |        97
      390 |     +0.0% |       0 |       0 |             0 |        87
      400 |     +0.0% |       0 |       0 |             0 |        77
      410 |     +0.0% |       0 |       0 |             0 |        67
      420 |     +0.0% |       0 |       0 |             0 |        57
      430 |     +0.0% |       0 |       0 |             0 |        47
      440 |     +0.0% |       0 |       0 |             0 |        37
      450 |     +0.0% |       0 |       0 |             0 |        27
      460 |     +0.0% |       0 |       0 |             0 |        17
      470 |     +0.0% |       0 |       0 |             0 |         7
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
Floating nets:
Report metrics stage 3, resizer...

==========================================================================
resizer report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Instance count before 471, after 471
Pin count before 1136, after 1136
Elapsed time: 0:01.04[h:]min:sec. CPU time: user 0.92 sys 0.13 (102%). Peak memory: 214032KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_4_place_resized                  1            209 4699b0d523198ad52423
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_5_place_dp detail_place
Running detail_place.tcl, stage 3_5_place_dp
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_4_place_resized.odb
Placement Analysis
---------------------------------
total displacement         72.7 u
average displacement        0.2 u
max displacement            0.7 u
original HPWL             583.4 u
legalized HPWL            644.9 u
delta HPWL                   11 %

Detailed placement improvement.
[INFO DPL-0401] Setting random seed to 1.
[INFO DPL-0402] Setting maximum displacement 5 1 to 1350 270 units.
[INFO DPL-0320] Collected 191 fixed cells.
[INFO DPL-0318] Collected 389 single height cells.
[INFO DPL-0321] Collected 0 wide cells.
[INFO DPL-0322] Image (2052, 2160) - (13284, 13230)
[INFO DPL-0310] Assigned 389 cells into segments.  Movement in X-direction is 0.000000, movement in Y-direction is 0.000000.
[INFO DPL-0313] Found 0 cells in wrong regions.
[INFO DPL-0315] Found 0 row alignment problems.
[INFO DPL-0314] Found 0 site alignment problems.
[INFO DPL-0311] Found 0 overlaps between adjacent cells.
[INFO DPL-0312] Found 0 edge spacing violations and 0 padding violations.
[INFO DPL-0303] Running algorithm for independent set matching.
[INFO DPL-0300] Set matching objective is wirelength.
[INFO DPL-0301] Pass   1 of matching; objective is 6.437010e+05.
[INFO DPL-0302] End of matching; objective is 6.430920e+05, improvement is 0.09 percent.
[INFO DPL-0303] Running algorithm for global swaps.
[INFO DPL-0306] Pass   1 of global swaps; hpwl is 6.266170e+05.
[INFO DPL-0306] Pass   2 of global swaps; hpwl is 6.256570e+05.
[INFO DPL-0307] End of global swaps; objective is 6.256570e+05, improvement is 2.71 percent.
[INFO DPL-0303] Running algorithm for vertical swaps.
[INFO DPL-0308] Pass   1 of vertical swaps; hpwl is 6.227700e+05.
[INFO DPL-0309] End of vertical swaps; objective is 6.227700e+05, improvement is 0.46 percent.
[INFO DPL-0303] Running algorithm for reordering.
[INFO DPL-0304] Pass   1 of reordering; objective is 6.225640e+05.
[INFO DPL-0305] End of reordering; objective is 6.225640e+05, improvement is 0.03 percent.
[INFO DPL-0303] Running algorithm for random improvement.
[INFO DPL-0324] Random improver is using random generator.
[INFO DPL-0325] Random improver is using hpwl objective.
[INFO DPL-0326] Random improver cost string is (a).
[INFO DPL-0332] End of pass, Generator random called 7780 times.
[INFO DPL-0335] Generator random, Cumulative attempts 7780, swaps 777, moves  3321 since last reset.
[INFO DPL-0333] End of pass, Objective hpwl, Initial cost 6.225640e+05, Scratch cost 6.086330e+05, Incremental cost 6.086330e+05, Mismatch? N
[INFO DPL-0338] End of pass, Total cost is 6.086330e+05.
[INFO DPL-0327] Pass   1 of random improver; improvement in cost is 2.24 percent.
[INFO DPL-0332] End of pass, Generator random called 7780 times.
[INFO DPL-0335] Generator random, Cumulative attempts 15560, swaps 1672, moves  6487 since last reset.
[INFO DPL-0333] End of pass, Objective hpwl, Initial cost 6.086330e+05, Scratch cost 6.061870e+05, Incremental cost 6.061870e+05, Mismatch? N
[INFO DPL-0338] End of pass, Total cost is 6.061870e+05.
[INFO DPL-0327] Pass   2 of random improver; improvement in cost is 0.40 percent.
[INFO DPL-0328] End of random improver; improvement is 2.630573 percent.
[INFO DPL-0380] Cell flipping.
[INFO DPL-0382] Changed 0 cell orientations for row compatibility.
[INFO DPL-0383] Performed 130 cell flips.
[INFO DPL-0384] End of flipping; objective is 5.884960e+05, improvement is 2.92 percent.
[INFO DPL-0313] Found 0 cells in wrong regions.
[INFO DPL-0315] Found 0 row alignment problems.
[INFO DPL-0314] Found 0 site alignment problems.
[INFO DPL-0311] Found 0 overlaps between adjacent cells.
[INFO DPL-0312] Found 0 edge spacing violations and 0 padding violations.
Detailed Improvement Results
------------------------------------------
Original HPWL              644.9 u (     303.8,      341.1)
Final HPWL                 587.4 u (     268.7,      318.8)
Delta HPWL                  -8.9 % (     -11.6,       -6.5)

[INFO DPL-0020] Mirrored 51 instances
[INFO DPL-0021] HPWL before             587.4 u
[INFO DPL-0022] HPWL after              585.9 u
[INFO DPL-0023] HPWL delta               -0.3 %
[INFO FLW-0012] Placement violations .
Report metrics stage 3, detailed place...

==========================================================================
detailed place report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Elapsed time: 0:01.00[h:]min:sec. CPU time: user 0.94 sys 0.07 (101%). Peak memory: 198620KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_5_place_dp                       1            193 19b1386384311d96a2e0
cp ./results/asap7/tritone/base/3_5_place_dp.odb ./results/asap7/tritone/base/3_place.odb
cp ./results/asap7/tritone/base/2_floorplan.sdc ./results/asap7/tritone/base/3_place.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 4_1_cts cts
Running cts.tcl, stage 4_1_cts
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/3_place.odb
clock_tree_synthesis -sink_clustering_enable -repair_clock_nets
[INFO CTS-0050] Root buffer is BUFx4_ASAP7_75t_R.
[INFO CTS-0051] Sink buffer is BUFx8_ASAP7_75t_R.
[INFO CTS-0052] The following clock buffers will be used for CTS:
                    BUFx4_ASAP7_75t_R
                    BUFx10_ASAP7_75t_R
[INFO CTS-0049] Characterization buffer is BUFx10_ASAP7_75t_R.
[INFO CTS-0007] Net "clk" found for clock "core_clock".
[INFO CTS-0010]  Clock net "clk" has 19 sinks.
[INFO CTS-0008] TritonCTS found 1 clock nets.
[INFO CTS-0097] Characterization used 2 buffer(s) types.
[INFO CTS-0201] 0 blockages from hard placement blockages and placed macros will be used.
[INFO CTS-0027] Generating H-Tree topology for net clk.
[INFO CTS-0028]  Total number of sinks: 19.
[INFO CTS-0090]  Sinks will be clustered based on buffer max cap.
[INFO CTS-0030]  Number of static layers: 0.
[INFO CTS-0020]  Wire segment unit: 1350  dbu (1 um).
[INFO CTS-0023]  Original sink region: [(5008, 4498), (11704, 12598)].
[INFO CTS-0024]  Normalized sink region: [(3.70963, 3.33185), (8.66963, 9.33185)].
[INFO CTS-0025]     Width:  4.9600.
[INFO CTS-0026]     Height: 6.0000.
 Level 1
    Direction: Vertical
    Sinks per sub-region: 10
    Sub-region size: 4.9600 X 3.0000
[INFO CTS-0034]     Segment length (rounded): 1.
[INFO CTS-0032]  Stop criterion found. Max number of sinks is 15.
[INFO CTS-0035]  Number of sinks covered: 19.
[INFO CTS-0018]     Created 3 clock buffers.
[INFO CTS-0012]     Minimum number of buffers in the clock path: 2.
[INFO CTS-0013]     Maximum number of buffers in the clock path: 2.
[INFO CTS-0015]     Created 3 clock nets.
[INFO CTS-0016]     Fanout distribution for the current clock = 9:1, 10:1..
[INFO CTS-0017]     Max level of the clock tree: 1.
[INFO CTS-0098] Clock net "clk"
[INFO CTS-0099]  Sinks 20
[INFO CTS-0100]  Leaf buffers 0
[INFO CTS-0101]  Average sink wire length 14.05 um
[INFO CTS-0102]  Path depth 2 - 2
[INFO CTS-0207]  Dummy loads inserted 1
Placement Analysis
---------------------------------
total displacement          0.5 u
average displacement        0.0 u
max displacement            0.3 u
original HPWL             600.6 u
legalized HPWL            622.8 u
delta HPWL                    4 %

repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -verbose
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove CloneMove SplitLoadMove
[INFO RSZ-0098] No setup violations found
[INFO RSZ-0033] No hold violations found.
Placement Analysis
---------------------------------
total displacement          0.0 u
average displacement        0.0 u
max displacement            0.0 u
original HPWL             622.8 u
legalized HPWL            622.8 u
delta HPWL                    0 %

Report metrics stage 4, cts final...

==========================================================================
cts final report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Elapsed time: 0:02.13[h:]min:sec. CPU time: user 2.08 sys 0.08 (101%). Peak memory: 237152KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
4_1_cts                            2            231 cea6bd01096b6d40dafb
cp ./results/asap7/tritone/base/4_1_cts.odb ./results/asap7/tritone/base/4_cts.odb
/OpenROAD-flow-scripts/flow/scripts/flow.sh 5_1_grt global_route
Running global_route.tcl, stage 5_1_grt
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/4_cts.odb
pin_access
[INFO DRT-0149] Reading tech and libs.

Units:                1000
Number of layers:     21
Number of macros:     212
Number of vias:       14
Number of viarulegen: 11

[INFO DRT-0150] Reading design.

Design:                   ternary_cpu_system
Die area:                 ( 0 0 ) ( 15327 15327 )
Number of track patterns: 32
Number of DEF vias:       0
Number of components:     475
Number of terminals:      111
Number of snets:          2
Number of nets:           480

[INFO DRT-0167] List of default vias:
  Layer V2
    default via: VIA23
  Layer V3
    default via: VIA34
  Layer V4
    default via: VIA45
  Layer V5
    default via: VIA56
  Layer V6
    default via: VIA67
  Layer V7
    default via: VIA78
  Layer V8
    default via: VIA89
  Layer V9
    default via: VIA9Pad
[INFO DRT-0162] Library cell analysis.
[INFO DRT-0163] Instance analysis.
[INFO DRT-0164] Number of unique instances = 79.
[INFO DRT-0168] Init region query.
[INFO DRT-0024]   Complete Active.
[INFO DRT-0024]   Complete V0.
[INFO DRT-0024]   Complete M1.
[INFO DRT-0024]   Complete V1.
[INFO DRT-0024]   Complete M2.
[INFO DRT-0024]   Complete V2.
[INFO DRT-0024]   Complete M3.
[INFO DRT-0024]   Complete V3.
[INFO DRT-0024]   Complete M4.
[INFO DRT-0024]   Complete V4.
[INFO DRT-0024]   Complete M5.
[INFO DRT-0024]   Complete V5.
[INFO DRT-0024]   Complete M6.
[INFO DRT-0024]   Complete V6.
[INFO DRT-0024]   Complete M7.
[INFO DRT-0024]   Complete V7.
[INFO DRT-0024]   Complete M8.
[INFO DRT-0024]   Complete V8.
[INFO DRT-0024]   Complete M9.
[INFO DRT-0024]   Complete V9.
[INFO DRT-0024]   Complete Pad.
[INFO DRT-0033] Active shape region query size = 0.
[INFO DRT-0033] V0 shape region query size = 0.
[INFO DRT-0033] M1 shape region query size = 6144.
[INFO DRT-0033] V1 shape region query size = 13668.
[INFO DRT-0033] M2 shape region query size = 401.
[INFO DRT-0033] V2 shape region query size = 315.
[INFO DRT-0033] M3 shape region query size = 315.
[INFO DRT-0033] V3 shape region query size = 210.
[INFO DRT-0033] M4 shape region query size = 243.
[INFO DRT-0033] V4 shape region query size = 210.
[INFO DRT-0033] M5 shape region query size = 196.
[INFO DRT-0033] V5 shape region query size = 20.
[INFO DRT-0033] M6 shape region query size = 18.
[INFO DRT-0033] V6 shape region query size = 0.
[INFO DRT-0033] M7 shape region query size = 0.
[INFO DRT-0033] V7 shape region query size = 0.
[INFO DRT-0033] M8 shape region query size = 0.
[INFO DRT-0033] V8 shape region query size = 0.
[INFO DRT-0033] M9 shape region query size = 0.
[INFO DRT-0033] V9 shape region query size = 0.
[INFO DRT-0033] Pad shape region query size = 0.
[INFO DRT-0165] Start pin access.
[INFO DRT-0078]   Complete 415 pins.
[INFO DRT-0081]   Complete 79 unique inst patterns.
[INFO DRT-0084]   Complete 276 groups.
#scanned instances     = 475
#unique  instances     = 79
#stdCellGenAp          = 1887
#stdCellValidPlanarAp  = 52
#stdCellValidViaAp     = 1483
#stdCellPinNoAp        = 0
#stdCellPinCnt         = 1067
#instTermValidViaApCnt = 0
#macroGenAp            = 0
#macroValidPlanarAp    = 0
#macroValidViaAp       = 0
#macroNoAp             = 0
[INFO DRT-0166] Complete pin access.
[INFO DRT-0267] cpu time = 00:00:11, elapsed time = 00:00:01, memory = 203.00 (MB), peak = 203.00 (MB)
global_route -congestion_report_file ./reports/asap7/tritone/base/congestion.rpt -congestion_iterations 30 -congestion_report_iter_step 5 -verbose
[INFO GRT-0020] Min routing layer: M2
[INFO GRT-0021] Max routing layer: M7
[INFO GRT-0022] Global adjustment: 0%
[INFO GRT-0023] Grid origin: (0, 0)
[INFO GRT-0088] Layer M1      Track-Pitch = 0.0360  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M2      Track-Pitch = 0.0390  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M3      Track-Pitch = 0.0360  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M4      Track-Pitch = 0.0480  line-2-Via Pitch: 0.0480
[INFO GRT-0088] Layer M5      Track-Pitch = 0.0480  line-2-Via Pitch: 0.0480
[INFO GRT-0088] Layer M6      Track-Pitch = 0.0640  line-2-Via Pitch: 0.0640
[INFO GRT-0088] Layer M7      Track-Pitch = 0.0640  line-2-Via Pitch: 0.0640
[INFO GRT-0003] Macros: 0
[INFO GRT-0004] Blockages: 114
[INFO GRT-0019] Found 4 clock nets.
[INFO GRT-0001] Minimum degree: 2
[INFO GRT-0002] Maximum degree: 27

[INFO GRT-0053] Routing resources analysis:
          Routing      Original      Derated      Resource
Layer     Direction    Resources     Resources    Reduction (%)
---------------------------------------------------------------
M1         Vertical            0             0          0.00%
M2         Horizontal       8691          6273          27.82%
M3         Vertical        10310          7650          25.80%
M4         Horizontal       7865          5840          25.75%
M5         Vertical         7655          5669          25.94%
M6         Horizontal       5565          3824          31.28%
M7         Vertical         5975          4050          32.22%
---------------------------------------------------------------

[INFO GRT-0197] Via related to pin nodes: 1880
[INFO GRT-0198] Via related Steiner nodes: 35
[INFO GRT-0199] Via filling finished.
[INFO GRT-0111] Final number of vias: 2351
[INFO GRT-0112] Final usage 3D: 8256

[INFO GRT-0096] Final congestion report:
Layer         Resource        Demand        Usage (%)    Max H / Max V / Total Overflow
---------------------------------------------------------------------------------------
M1                   0             0            0.00%             0 /  0 /  0
M2                6273           506            8.07%             0 /  0 /  0
M3                7650           576            7.53%             0 /  0 /  0
M4                5840            82            1.40%             0 /  0 /  0
M5                5669            39            0.69%             0 /  0 /  0
M6                3824             0            0.00%             0 /  0 /  0
M7                4050             0            0.00%             0 /  0 /  0
---------------------------------------------------------------------------------------
Total            33306          1203            3.61%             0 /  0 /  0

[INFO GRT-0018] Total wirelength: 1121 um
[INFO GRT-0014] Routed nets: 441
Perform buffer insertion and gate resizing...
repair_design -verbose
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |       481
       10 |     +0.0% |       0 |       0 |             0 |       471
       20 |     +0.0% |       0 |       0 |             0 |       461
       30 |     +0.0% |       0 |       0 |             0 |       451
       40 |     +0.0% |       0 |       0 |             0 |       441
       50 |     +0.0% |       0 |       0 |             0 |       431
       60 |     +0.0% |       0 |       0 |             0 |       421
       70 |     +0.0% |       0 |       0 |             0 |       411
       80 |     +0.0% |       0 |       0 |             0 |       401
       90 |     +0.0% |       0 |       0 |             0 |       391
      100 |     +0.0% |       0 |       0 |             0 |       381
      110 |     +0.0% |       0 |       0 |             0 |       371
      120 |     +0.0% |       0 |       0 |             0 |       361
      130 |     +0.0% |       0 |       0 |             0 |       351
      140 |     +0.0% |       0 |       0 |             0 |       341
      150 |     +0.0% |       0 |       0 |             0 |       331
      160 |     +0.0% |       0 |       0 |             0 |       321
      170 |     +0.0% |       0 |       0 |             0 |       311
      180 |     +0.0% |       0 |       0 |             0 |       301
      190 |     +0.0% |       0 |       0 |             0 |       291
      200 |     +0.0% |       0 |       0 |             0 |       281
      210 |     +0.0% |       0 |       0 |             0 |       271
      220 |     +0.0% |       0 |       0 |             0 |       261
      230 |     +0.0% |       0 |       0 |             0 |       251
      240 |     +0.0% |       0 |       0 |             0 |       241
      250 |     +0.0% |       0 |       0 |             0 |       231
      260 |     +0.0% |       0 |       0 |             0 |       221
      270 |     +0.0% |       0 |       0 |             0 |       211
      280 |     +0.0% |       0 |       0 |             0 |       201
      290 |     +0.0% |       0 |       0 |             0 |       191
      300 |     +0.0% |       0 |       0 |             0 |       181
      310 |     +0.0% |       0 |       0 |             0 |       171
      320 |     +0.0% |       0 |       0 |             0 |       161
      330 |     +0.0% |       0 |       0 |             0 |       151
      340 |     +0.0% |       0 |       0 |             0 |       141
      350 |     +0.0% |       0 |       0 |             0 |       131
      360 |     +0.0% |       0 |       0 |             0 |       121
      370 |     +0.0% |       0 |       0 |             0 |       111
      380 |     +0.0% |       0 |       0 |             0 |       101
      390 |     +0.0% |       0 |       0 |             0 |        91
      400 |     +0.0% |       0 |       0 |             0 |        81
      410 |     +0.0% |       0 |       0 |             0 |        71
      420 |     +0.0% |       0 |       0 |             0 |        61
      430 |     +0.0% |       0 |       0 |             0 |        51
      440 |     +0.0% |       0 |       0 |             0 |        41
      450 |     +0.0% |       0 |       0 |             0 |        31
      460 |     +0.0% |       0 |       0 |             0 |        21
      470 |     +0.0% |       0 |       0 |             0 |        11
      480 |     +0.0% |       0 |       0 |             0 |         1
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
global_route -start_incremental
detailed_placement
Placement Analysis
---------------------------------
total displacement          0.0 u
average displacement        0.0 u
max displacement            0.0 u
original HPWL             622.8 u
legalized HPWL            622.8 u
delta HPWL                    0 %

global_route -end_incremental -congestion_report_file ./reports/asap7/tritone/base/congestion_post_repair_design.rpt
Repair setup and hold violations...
repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -verbose
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove CloneMove SplitLoadMove
[INFO RSZ-0098] No setup violations found
[INFO RSZ-0033] No hold violations found.
global_route -start_incremental
detailed_placement
Placement Analysis
---------------------------------
total displacement          0.0 u
average displacement        0.0 u
max displacement            0.0 u
original HPWL             622.8 u
legalized HPWL            622.8 u
delta HPWL                    0 %

global_route -end_incremental -congestion_report_file ./reports/asap7/tritone/base/congestion_post_repair_timing.rpt
global_route -start_incremental
global_route -end_incremental -congestion_report_file ./reports/asap7/tritone/base/congestion_post_recover_power.rpt
Repair antennas...
[WARNING GRT-0246] No diode with LEF class CORE ANTENNACELL found.
[INFO ANT-0002] Found 0 net violations.
[INFO ANT-0001] Found 0 pin violations.
Estimate parasitics...
Report metrics stage 5, global route...

==========================================================================
global route report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
[INFO FLW-0007] clock core_clock period 3330.000000
[INFO FLW-0008] Clock core_clock period 1544.523
[INFO FLW-0009] Clock core_clock slack 1704.187
[INFO FLW-0011] Path endpoint path count 63
Elapsed time: 0:02.72[h:]min:sec. CPU time: user 26.85 sys 0.30 (995%). Peak memory: 301980KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
5_1_grt                            2            294 22989f632b7db45d1ab8
/OpenROAD-flow-scripts/flow/scripts/flow.sh 5_2_route detail_route
Running detail_route.tcl, stage 5_2_route
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/5_1_grt.odb
detailed_route -output_drc ./reports/asap7/tritone/base/5_route_drc.rpt -output_maze ./results/asap7/tritone/base/maze.log -droute_end_iter 64 -verbose 1 -drc_report_iter_step 5
[INFO DRT-0149] Reading tech and libs.

Units:                1000
Number of layers:     21
Number of macros:     212
Number of vias:       14
Number of viarulegen: 11

[INFO DRT-0150] Reading design.

Design:                   ternary_cpu_system
Die area:                 ( 0 0 ) ( 15327 15327 )
Number of track patterns: 32
Number of DEF vias:       0
Number of components:     475
Number of terminals:      111
Number of snets:          2
Number of nets:           480

[INFO DRT-0167] List of default vias:
  Layer V2
    default via: VIA23
  Layer V3
    default via: VIA34
  Layer V4
    default via: VIA45
  Layer V5
    default via: VIA56
  Layer V6
    default via: VIA67
  Layer V7
    default via: VIA78
  Layer V8
    default via: VIA89
  Layer V9
    default via: VIA9Pad
[INFO DRT-0162] Library cell analysis.
[INFO DRT-0163] Instance analysis.
[INFO DRT-0164] Number of unique instances = 79.
[INFO DRT-0168] Init region query.
[INFO DRT-0024]   Complete Active.
[INFO DRT-0024]   Complete V0.
[INFO DRT-0024]   Complete M1.
[INFO DRT-0024]   Complete V1.
[INFO DRT-0024]   Complete M2.
[INFO DRT-0024]   Complete V2.
[INFO DRT-0024]   Complete M3.
[INFO DRT-0024]   Complete V3.
[INFO DRT-0024]   Complete M4.
[INFO DRT-0024]   Complete V4.
[INFO DRT-0024]   Complete M5.
[INFO DRT-0024]   Complete V5.
[INFO DRT-0024]   Complete M6.
[INFO DRT-0024]   Complete V6.
[INFO DRT-0024]   Complete M7.
[INFO DRT-0024]   Complete V7.
[INFO DRT-0024]   Complete M8.
[INFO DRT-0024]   Complete V8.
[INFO DRT-0024]   Complete M9.
[INFO DRT-0024]   Complete V9.
[INFO DRT-0024]   Complete Pad.
[INFO DRT-0033] Active shape region query size = 0.
[INFO DRT-0033] V0 shape region query size = 0.
[INFO DRT-0033] M1 shape region query size = 6144.
[INFO DRT-0033] V1 shape region query size = 13668.
[INFO DRT-0033] M2 shape region query size = 401.
[INFO DRT-0033] V2 shape region query size = 315.
[INFO DRT-0033] M3 shape region query size = 315.
[INFO DRT-0033] V3 shape region query size = 210.
[INFO DRT-0033] M4 shape region query size = 243.
[INFO DRT-0033] V4 shape region query size = 210.
[INFO DRT-0033] M5 shape region query size = 196.
[INFO DRT-0033] V5 shape region query size = 20.
[INFO DRT-0033] M6 shape region query size = 18.
[INFO DRT-0033] V6 shape region query size = 0.
[INFO DRT-0033] M7 shape region query size = 0.
[INFO DRT-0033] V7 shape region query size = 0.
[INFO DRT-0033] M8 shape region query size = 0.
[INFO DRT-0033] V8 shape region query size = 0.
[INFO DRT-0033] M9 shape region query size = 0.
[INFO DRT-0033] V9 shape region query size = 0.
[INFO DRT-0033] Pad shape region query size = 0.
[INFO DRT-0165] Start pin access.
[INFO DRT-0078]   Complete 415 pins.
[INFO DRT-0081]   Complete 79 unique inst patterns.
[INFO DRT-0084]   Complete 276 groups.
#scanned instances     = 475
#unique  instances     = 79
#stdCellGenAp          = 1887
#stdCellValidPlanarAp  = 52
#stdCellValidViaAp     = 1483
#stdCellPinNoAp        = 0
#stdCellPinCnt         = 1067
#instTermValidViaApCnt = 0
#macroGenAp            = 0
#macroValidPlanarAp    = 0
#macroValidViaAp       = 0
#macroNoAp             = 0
[INFO DRT-0166] Complete pin access.
[INFO DRT-0267] cpu time = 00:00:11, elapsed time = 00:00:01, memory = 267.68 (MB), peak = 267.68 (MB)

[INFO DRT-0157] Number of guides:     2638

[INFO DRT-0169] Post process guides.
[INFO DRT-0176] GCELLGRID X 0 DO 26 STEP 570 ;
[INFO DRT-0177] GCELLGRID Y 0 DO 26 STEP 570 ;
[INFO DRT-0028]   Complete Active.
[INFO DRT-0028]   Complete V0.
[INFO DRT-0028]   Complete M1.
[INFO DRT-0028]   Complete V1.
[INFO DRT-0028]   Complete M2.
[INFO DRT-0028]   Complete V2.
[INFO DRT-0028]   Complete M3.
[INFO DRT-0028]   Complete V3.
[INFO DRT-0028]   Complete M4.
[INFO DRT-0028]   Complete V4.
[INFO DRT-0028]   Complete M5.
[INFO DRT-0028]   Complete V5.
[INFO DRT-0028]   Complete M6.
[INFO DRT-0028]   Complete V6.
[INFO DRT-0028]   Complete M7.
[INFO DRT-0028]   Complete V7.
[INFO DRT-0028]   Complete M8.
[INFO DRT-0028]   Complete V8.
[INFO DRT-0028]   Complete M9.
[INFO DRT-0028]   Complete V9.
[INFO DRT-0028]   Complete Pad.
[INFO DRT-0178] Init guide query.
[INFO DRT-0035]   Complete Active (guide).
[INFO DRT-0035]   Complete V0 (guide).
[INFO DRT-0035]   Complete M1 (guide).
[INFO DRT-0035]   Complete V1 (guide).
[INFO DRT-0035]   Complete M2 (guide).
[INFO DRT-0035]   Complete V2 (guide).
[INFO DRT-0035]   Complete M3 (guide).
[INFO DRT-0035]   Complete V3 (guide).
[INFO DRT-0035]   Complete M4 (guide).
[INFO DRT-0035]   Complete V4 (guide).
[INFO DRT-0035]   Complete M5 (guide).
[INFO DRT-0035]   Complete V5 (guide).
[INFO DRT-0035]   Complete M6 (guide).
[INFO DRT-0035]   Complete V6 (guide).
[INFO DRT-0035]   Complete M7 (guide).
[INFO DRT-0035]   Complete V7 (guide).
[INFO DRT-0035]   Complete M8 (guide).
[INFO DRT-0035]   Complete V8 (guide).
[INFO DRT-0035]   Complete M9 (guide).
[INFO DRT-0035]   Complete V9 (guide).
[INFO DRT-0035]   Complete Pad (guide).
[INFO DRT-0036] Active guide region query size = 0.
[INFO DRT-0036] V0 guide region query size = 0.
[INFO DRT-0036] M1 guide region query size = 849.
[INFO DRT-0036] V1 guide region query size = 0.
[INFO DRT-0036] M2 guide region query size = 731.
[INFO DRT-0036] V2 guide region query size = 0.
[INFO DRT-0036] M3 guide region query size = 366.
[INFO DRT-0036] V3 guide region query size = 0.
[INFO DRT-0036] M4 guide region query size = 80.
[INFO DRT-0036] V4 guide region query size = 0.
[INFO DRT-0036] M5 guide region query size = 46.
[INFO DRT-0036] V5 guide region query size = 0.
[INFO DRT-0036] M6 guide region query size = 0.
[INFO DRT-0036] V6 guide region query size = 0.
[INFO DRT-0036] M7 guide region query size = 0.
[INFO DRT-0036] V7 guide region query size = 0.
[INFO DRT-0036] M8 guide region query size = 0.
[INFO DRT-0036] V8 guide region query size = 0.
[INFO DRT-0036] M9 guide region query size = 0.
[INFO DRT-0036] V9 guide region query size = 0.
[INFO DRT-0036] Pad guide region query size = 0.
[INFO DRT-0179] Init gr pin query.
[INFO DRT-0267] cpu time = 00:00:00, elapsed time = 00:00:00, memory = 267.93 (MB), peak = 267.93 (MB)
[INFO DRT-0245] skipped writing guide updates to database.
[INFO DRT-0185] Post process initialize RPin region query.
[INFO DRT-0181] Start track assignment.
[INFO DRT-0184] Done with 1261 vertical wires in 1 frboxes and 811 horizontal wires in 1 frboxes.
[INFO DRT-0186] Done with 67 vertical wires in 1 frboxes and 130 horizontal wires in 1 frboxes.
[INFO DRT-0182] Complete track assignment.
[INFO DRT-0267] cpu time = 00:00:00, elapsed time = 00:00:00, memory = 277.93 (MB), peak = 277.93 (MB)
[INFO DRT-0187] Start routing data preparation.
[INFO DRT-0267] cpu time = 00:00:00, elapsed time = 00:00:00, memory = 277.93 (MB), peak = 277.93 (MB)
[INFO DRT-0194] Start detail routing.
[INFO DRT-0195] Start 0th optimization iteration.
    Completing 10% with 0 violations.
    elapsed time = 00:00:00, memory = 585.86 (MB).
    Completing 20% with 0 violations.
    elapsed time = 00:00:00, memory = 346.68 (MB).
    Completing 30% with 1 violations.
    elapsed time = 00:00:00, memory = 736.96 (MB).
    Completing 40% with 1 violations.
    elapsed time = 00:00:01, memory = 571.68 (MB).
    Completing 50% with 1 violations.
    elapsed time = 00:00:02, memory = 420.11 (MB).
    Completing 60% with 11 violations.
    elapsed time = 00:00:02, memory = 745.36 (MB).
    Completing 70% with 11 violations.
    elapsed time = 00:00:03, memory = 492.48 (MB).
    Completing 80% with 12 violations.
    elapsed time = 00:00:03, memory = 934.45 (MB).
    Completing 90% with 12 violations.
    elapsed time = 00:00:03, memory = 745.02 (MB).
    Completing 100% with 17 violations.
    elapsed time = 00:00:04, memory = 572.37 (MB).
[INFO DRT-0199]   Number of violations = 34.
Viol/Layer          M1     M2     M3
EOL                  0      2      0
Metal Spacing        3      1      1
Recheck              0     13      4
Short                0      1      0
eolKeepOut           0      9      0
[INFO DRT-0267] cpu time = 00:00:11, elapsed time = 00:00:04, memory = 1112.05 (MB), peak = 1123.87 (MB)
Total wire length = 699 um.
Total wire length on LAYER M1 = 0 um.
Total wire length on LAYER M2 = 272 um.
Total wire length on LAYER M3 = 335 um.
Total wire length on LAYER M4 = 57 um.
Total wire length on LAYER M5 = 34 um.
Total wire length on LAYER M6 = 0 um.
Total wire length on LAYER M7 = 0 um.
Total wire length on LAYER M8 = 0 um.
Total wire length on LAYER M9 = 0 um.
Total wire length on LAYER Pad = 0 um.
Total number of vias = 2626.
Up-via summary (total 2626):

---------------
 Active       0
     M1    1045
     M2    1412
     M3     123
     M4      46
     M5       0
     M6       0
     M7       0
     M8       0
     M9       0
---------------
       2626


[INFO DRT-0195] Start 1st optimization iteration.
    Completing 10% with 34 violations.
    elapsed time = 00:00:00, memory = 1436.94 (MB).
    Completing 20% with 34 violations.
    elapsed time = 00:00:01, memory = 1190.68 (MB).
    Completing 30% with 32 violations.
    elapsed time = 00:00:01, memory = 1606.21 (MB).
    Completing 40% with 32 violations.
    elapsed time = 00:00:01, memory = 1433.50 (MB).
    Completing 50% with 32 violations.
    elapsed time = 00:00:02, memory = 1280.01 (MB).
    Completing 60% with 20 violations.
    elapsed time = 00:00:02, memory = 1570.99 (MB).
    Completing 70% with 20 violations.
    elapsed time = 00:00:03, memory = 1307.57 (MB).
    Completing 80% with 6 violations.
    elapsed time = 00:00:03, memory = 1695.64 (MB).
    Completing 90% with 6 violations.
    elapsed time = 00:00:03, memory = 1482.76 (MB).
    Completing 100% with 0 violations.
    elapsed time = 00:00:04, memory = 1341.80 (MB).
[INFO DRT-0199]   Number of violations = 0.
[INFO DRT-0267] cpu time = 00:00:12, elapsed time = 00:00:04, memory = 1341.93 (MB), peak = 1780.57 (MB)
Total wire length = 691 um.
Total wire length on LAYER M1 = 0 um.
Total wire length on LAYER M2 = 267 um.
Total wire length on LAYER M3 = 331 um.
Total wire length on LAYER M4 = 57 um.
Total wire length on LAYER M5 = 35 um.
Total wire length on LAYER M6 = 0 um.
Total wire length on LAYER M7 = 0 um.
Total wire length on LAYER M8 = 0 um.
Total wire length on LAYER M9 = 0 um.
Total wire length on LAYER Pad = 0 um.
Total number of vias = 2564.
Up-via summary (total 2564):

---------------
 Active       0
     M1    1039
     M2    1365
     M3     114
     M4      46
     M5       0
     M6       0
     M7       0
     M8       0
     M9       0
---------------
       2564


[INFO DRT-0198] Complete detail routing.
Total wire length = 691 um.
Total wire length on LAYER M1 = 0 um.
Total wire length on LAYER M2 = 267 um.
Total wire length on LAYER M3 = 331 um.
Total wire length on LAYER M4 = 57 um.
Total wire length on LAYER M5 = 35 um.
Total wire length on LAYER M6 = 0 um.
Total wire length on LAYER M7 = 0 um.
Total wire length on LAYER M8 = 0 um.
Total wire length on LAYER M9 = 0 um.
Total wire length on LAYER Pad = 0 um.
Total number of vias = 2564.
Up-via summary (total 2564):

---------------
 Active       0
     M1    1039
     M2    1365
     M3     114
     M4      46
     M5       0
     M6       0
     M7       0
     M8       0
     M9       0
---------------
       2564


[INFO DRT-0267] cpu time = 00:00:24, elapsed time = 00:00:09, memory = 1342.18 (MB), peak = 1780.57 (MB)

[INFO DRT-0180] Post processing.
Took 10 seconds: detailed_route -output_drc ./reports/asap7/tritone/base/5_route_drc.rpt -output_maze ./results/asap7/tritone/base/maze.log -droute_end_iter 64 -verbose 1 -drc_report_iter_step 5
[WARNING GRT-0246] No diode with LEF class CORE ANTENNACELL found.
[INFO ANT-0002] Found 0 net violations.
[INFO ANT-0001] Found 0 pin violations.
[INFO ANT-0002] Found 0 net violations.
[INFO ANT-0001] Found 0 pin violations.
Report metrics stage 5, detailed route...

==========================================================================
detailed route report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
Elapsed time: 0:11.55[h:]min:sec. CPU time: user 35.09 sys 2.99 (329%). Peak memory: 1823304KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
5_2_route                         11           1780 52effd812754d9ef7704
/OpenROAD-flow-scripts/flow/scripts/flow.sh 5_3_fillcell fillcell
Running fillcell.tcl, stage 5_3_fillcell
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/5_2_route.odb
filler_placement "FILLERxp5_ASAP7_75t_R FILLER_ASAP7_75t_R DECAPx1_ASAP7_75t_R DECAPx2_ASAP7_75t_R DECAPx4_ASAP7_75t_R DECAPx6_ASAP7_75t_R DECAPx10_ASAP7_75t_R"
[INFO DPL-0001] Placed 676 filler instances.
Elapsed time: 0:00.95[h:]min:sec. CPU time: user 0.76 sys 0.21 (101%). Peak memory: 196180KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
5_3_fillcell                       0            191 b924d4d2e5ae2ff50094
cp ./results/asap7/tritone/base/5_3_fillcell.odb ./results/asap7/tritone/base/5_route.odb
cp ./results/asap7/tritone/base/5_1_grt.sdc ./results/asap7/tritone/base/5_route.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 6_1_fill density_fill
Running density_fill.tcl, stage 6_1_fill
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/5_route.odb
exec cp ./results/asap7/tritone/base/5_route.odb ./results/asap7/tritone/base/6_1_fill.odb
Elapsed time: 0:00.87[h:]min:sec. CPU time: user 0.75 sys 0.12 (101%). Peak memory: 194372KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
6_1_fill                           0            189 b924d4d2e5ae2ff50094
cp ./results/asap7/tritone/base/5_route.sdc ./results/asap7/tritone/base/6_1_fill.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 6_report final_report
Running final_report.tcl, stage 6_report
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/tritone/base/6_1_fill.odb
Deleted 0 routing obstructions
[INFO RCX-0431] Defined process_corner X with ext_model_index 0
[INFO RCX-0029] Defined extraction corner X
[INFO RCX-0435] Reading extraction model file /OpenROAD-flow-scripts/flow/platforms/asap7/rcx_patterns.rules ...
[INFO RCX-0436] RC segment generation ternary_cpu_system (max_merge_res 50.0) ...
[INFO RCX-0040] Final 1939 rc segments
[INFO RCX-0439] Coupling Cap extraction ternary_cpu_system ...
[INFO RCX-0440] Coupling threshhold is 0.1000 fF, coupling capacitance less than 0.1000 fF will be grounded.
[INFO RCX-0442] 56% of 2017 wires extracted
[INFO RCX-0442] 100% of 2017 wires extracted
[INFO RCX-0045] Extract 480 nets, 2380 rsegs, 2380 caps, 1635 ccs
[INFO RCX-0443] 480 nets finished
[INFO PSM-0040] All shapes on net VDD are connected.
########## IR report #################
Net              : VDD
Corner           : default
Total power      : 7.86e-06 W
Supply voltage   : 7.70e-01 V
Worstcase voltage: 7.70e-01 V
Average voltage  : 7.70e-01 V
Average IR drop  : 2.14e-05 V
Worstcase IR drop: 1.26e-04 V
Percentage drop  : 0.02 %
######################################
[INFO PSM-0040] All shapes on net VSS are connected.
########## IR report #################
Net              : VSS
Corner           : default
Total power      : 7.86e-06 W
Supply voltage   : 0.00e+00 V
Worstcase voltage: 8.92e-05 V
Average voltage  : 1.29e-05 V
Average IR drop  : 1.29e-05 V
Worstcase IR drop: 8.92e-05 V
Percentage drop  : 0.01 %
######################################
Cell type report:                       Count       Area
  Fill cell                               676      83.05
  Tap cell                                 82       2.39
  Tie cell                                 76       3.32
  Clock buffer                              4       0.38
  Timing Repair Buffer                     20       1.46
  Inverter                                 84       3.67
  Sequential cell                          19       7.20
  Multi-Input combinational cell          190      22.86
  Total                                  1151     124.34
Report metrics stage 6, finish...

==========================================================================
finish report_design_area
--------------------------------------------------------------------------
Design area 39 um^2 31% utilization.
[WARNING GUI-0076] QStandardPaths: XDG_RUNTIME_DIR not set, defaulting to '/tmp/runtime-root'
Elapsed time: 0:01.75[h:]min:sec. CPU time: user 1.65 sys 0.17 (104%). Peak memory: 261040KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
6_report                           1            254                  N/A
cp ./results/asap7/tritone/base/5_route.sdc ./results/asap7/tritone/base/6_final.sdc
cp /OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7_tech_1x_201209.lef ./objects/asap7/tritone/base/klayout_tech.lef
SC_LEF_RELATIVE_PATH="../../../../platforms/asap7/lef/asap7sc7p5t_28_R_1x_220121a.lef"; \
OTHER_LEFS_RELATIVE_PATHS=$(echo "<lef-files>$(realpath --relative-to=./results/asap7/tritone/base ./objects/asap7/tritone/base/klayout_tech.lef)</lef-files>"); \
sed 's,<lef-files>.*</lef-files>,<lef-files>'"$SC_LEF_RELATIVE_PATH"'</lef-files>'"$OTHER_LEFS_RELATIVE_PATHS"',g' /OpenROAD-flow-scripts/flow/platforms/asap7/KLayout/asap7.lyt > ./objects/asap7/tritone/base/klayout.lyt
sed -i 's,<map-file>.*</map-file>,<map-file>/OpenROAD-flow-scripts/flow/platforms/asap7/*map</map-file>,g' ./objects/asap7/tritone/base/klayout.lyt
(env time -f 'Elapsed time: %E[h:]min:sec. CPU time: user %U sys %S (%P). Peak memory: %MKB.' stdbuf -o L /OpenROAD-flow-scripts/flow/scripts/klayout.sh -zz -rd design_name=ternary_cpu_system \
        -rd in_def=./results/asap7/tritone/base/6_final.def \
        -rd in_files="/OpenROAD-flow-scripts/flow/platforms/asap7/gds/asap7sc7p5t_28_R_220121a.gds  " \
        -rd seal_file="" \
        -rd out_file=./results/asap7/tritone/base/6_1_merged.gds \
        -rd tech_file=./objects/asap7/tritone/base/klayout.lyt \
        -rd layer_map= \
        -r /OpenROAD-flow-scripts/flow/util/def2stream.py) 2>&1 | tee /OpenROAD-flow-scripts/flow/logs/asap7/tritone/base/6_1_merge.log
KLayout 0.30.3
Warning: DEF UNITS does not match reader DBU (DEF UNITS is 1000 and corresponds to a DBU of 0.001, but reader DBU is set to 0.00025) (line=5, cell=, file=6_final.def)
[INFO] Reporting cells prior to loading DEF ...
        /OpenROAD-flow-scripts/flow/platforms/asap7/gds/asap7sc7p5t_28_R_220121a.gds
[INFO] GDS_ALLOW_EMPTY=fakeram.*
[INFO] All LEF cells have matching GDS/OAS cells
[INFO] No orphan cells in the final layout
Elapsed time: 0:01.06[h:]min:sec. CPU time: user 0.91 sys 0.15 (100%). Peak memory: 433040KB.
cp results/asap7/tritone/base/6_1_merged.gds results/asap7/tritone/base/6_final.gds
./logs/asap7/tritone/base
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
1_1_yosys_canonicalize             0             79 9166070e25fb86adda93
1_2_yosys                          3            153 c338f4409e396fe16a6d
1_synth                            0            191 c4e3057fbeda64364de9
2_1_floorplan                      0            211 d30f639000c655c76a51
2_2_floorplan_macro                0            188 d30f639000c655c76a51
2_3_floorplan_tapcell              0            187 d94e2b7b3bc316500acf
2_4_floorplan_pdn                  0            190 23fde6d58e287e59c506
3_1_place_gp_skip_io              13            190 0a300f68f856bf89a87c
3_2_place_iop                      0            189 be7f26d0769054260412
3_3_place_gp                      11            282 4699b0d523198ad52423
3_4_place_resized                  1            209 4699b0d523198ad52423
3_5_place_dp                       1            193 19b1386384311d96a2e0
4_1_cts                            2            231 cea6bd01096b6d40dafb
5_1_grt                            2            294 22989f632b7db45d1ab8
5_2_route                         11           1780 52effd812754d9ef7704
5_3_fillcell                       0            191 b924d4d2e5ae2ff50094
6_1_fill                           0            189 b924d4d2e5ae2ff50094
6_1_merge                          1            422                  N/A
6_report                           1            254                  N/A
Total                             46           1780
cat: results/asap7/tritone/base/6_final_metrics.json: No such file or directory
PS E:\ternary cmos compile\tritone-complete\OpenROAD-flow-scripts-master>   docker run --rm -it -w /OpenROAD-flow-scripts/flow openroad/orfs:latest make DESIGN_CONFIG=./designs/asap7/ibex/config.mk
mkdir -p results/asap7/ibex/base/
echo 1000 > results/asap7/ibex/base/clock_period.txt
/OpenROAD-flow-scripts/flow/scripts/synth.sh /OpenROAD-flow-scripts/flow/scripts/synth_canonicalize.tcl ./logs/asap7/ibex/base/1_1_yosys_canonicalize.log
Using ABC speed script.
Extracting clock period from SDC file: ./results/asap7/ibex/base/clock_period.txt
Setting clock period to 1000
1. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
2. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
3. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
4. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
5. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
6. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
7. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
8. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
9. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
10. Executing Liberty frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
11. Executing SLANG frontend.
11.1. Executing UNDRIVEN pass. (resolve undriven signals)
11.2. Executing PROC_CLEAN pass (remove empty switches from decision trees).
11.3. Executing TRIBUF pass.
11.4. Executing PROC_RMDEAD pass (remove dead branches from decision trees).
11.5. Executing PROC_PRUNE pass (remove redundant assignments in processes).
11.6. Executing PROC_INIT pass (extract init attributes).
11.7. Executing PROC_ROM pass (convert switches to ROMs).
11.8. Executing PROC_MUX pass (convert decision trees to multiplexers).
11.9. Executing PROC_CLEAN pass (remove empty switches from decision trees).
11.10. Executing OPT_EXPR pass (perform const folding).
12. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_clkgate_R.v
13. Executing HIERARCHY pass (managing design hierarchy).
13.1. Analyzing design hierarchy..
13.2. Analyzing design hierarchy..
14. Executing OPT_CLEAN pass (remove unused cells and wires).
15. Executing RTLIL backend.
End of script. Logfile hash: 3d569a2fa0, CPU: user 1.35s system 0.05s, MEM: 95.75 MB peak
Yosys 0.60 (git sha1 UNKNOWN, g++ 11.4.0-1ubuntu1~22.04.2 -fPIC -O3)
Time spent: 56% 2x read_slang (0 sec), 34% 12x read_liberty (0 sec), ...
Top level design units:
    ibex_core

Build succeeded: 0 errors, 0 warnings
Elapsed time: 0:01.33[h:]min:sec. CPU time: user 1.39 sys 0.05 (108%). Peak memory: 98048KB.
/OpenROAD-flow-scripts/flow/scripts/synth.sh /OpenROAD-flow-scripts/flow/scripts/synth.tcl ./logs/asap7/ibex/base/1_2_yosys.log
Using ABC speed script.
Extracting clock period from SDC file: ./results/asap7/ibex/base/clock_period.txt
Setting clock period to 1000
1. Executing RTLIL frontend.
2. Executing HIERARCHY pass (managing design hierarchy).
2.1. Analyzing design hierarchy..
2.2. Analyzing design hierarchy..
3. Executing SYNTH pass.
3.1. Executing HIERARCHY pass (managing design hierarchy).
3.1.1. Analyzing design hierarchy..
3.1.2. Analyzing design hierarchy..
3.2. Executing PROC pass (convert processes to netlists).
3.2.1. Executing PROC_CLEAN pass (remove empty switches from decision trees).
3.2.2. Executing PROC_RMDEAD pass (remove dead branches from decision trees).
3.2.3. Executing PROC_PRUNE pass (remove redundant assignments in processes).
3.2.4. Executing PROC_INIT pass (extract init attributes).
3.2.5. Executing PROC_ARST pass (detect async resets in processes).
3.2.6. Executing PROC_ROM pass (convert switches to ROMs).
3.2.7. Executing PROC_MUX pass (convert decision trees to multiplexers).
3.2.8. Executing PROC_DLATCH pass (convert process syncs to latches).
3.2.9. Executing PROC_DFF pass (convert process syncs to FFs).
3.2.10. Executing PROC_MEMWR pass (convert process memory writes to cells).
3.2.11. Executing PROC_CLEAN pass (remove empty switches from decision trees).
3.2.12. Executing OPT_EXPR pass (perform const folding).
3.3. Executing FLATTEN pass (flatten design).
3.4. Executing OPT_EXPR pass (perform const folding).
3.5. Executing OPT_CLEAN pass (remove unused cells and wires).
3.6. Executing CHECK pass (checking for obvious problems).
3.7. Executing OPT pass (performing simple optimizations).
3.7.1. Executing OPT_EXPR pass (perform const folding).
3.7.2. Executing OPT_MERGE pass (detect identical cells).
3.7.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.5. Executing OPT_MERGE pass (detect identical cells).
3.7.6. Executing OPT_DFF pass (perform DFF optimizations).
3.7.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.8. Executing OPT_EXPR pass (perform const folding).
3.7.9. Rerunning OPT passes. (Maybe there is more to do..)
3.7.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.12. Executing OPT_MERGE pass (detect identical cells).
3.7.13. Executing OPT_DFF pass (perform DFF optimizations).
3.7.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.15. Executing OPT_EXPR pass (perform const folding).
3.7.16. Rerunning OPT passes. (Maybe there is more to do..)
3.7.17. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.7.18. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.7.19. Executing OPT_MERGE pass (detect identical cells).
3.7.20. Executing OPT_DFF pass (perform DFF optimizations).
3.7.21. Executing OPT_CLEAN pass (remove unused cells and wires).
3.7.22. Executing OPT_EXPR pass (perform const folding).
3.7.23. Finished fast OPT passes. (There is nothing left to do.)
3.8. Executing FSM pass (extract and optimize FSM).
3.8.1. Executing FSM_DETECT pass (finding FSMs in design).
3.8.2. Executing FSM_EXTRACT pass (extracting FSM from design).
3.8.3. Executing FSM_OPT pass (simple optimizations of FSMs).
3.8.4. Executing OPT_CLEAN pass (remove unused cells and wires).
3.8.5. Executing FSM_OPT pass (simple optimizations of FSMs).
3.8.6. Executing FSM_RECODE pass (re-assigning FSM state encoding).
3.8.7. Executing FSM_INFO pass (dumping all available information on FSM cells).
3.8.8. Executing FSM_MAP pass (mapping FSMs to basic logic).
3.9. Executing OPT pass (performing simple optimizations).
3.9.1. Executing OPT_EXPR pass (perform const folding).
3.9.2. Executing OPT_MERGE pass (detect identical cells).
3.9.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.5. Executing OPT_MERGE pass (detect identical cells).
3.9.6. Executing OPT_DFF pass (perform DFF optimizations).
3.9.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.8. Executing OPT_EXPR pass (perform const folding).
3.9.9. Rerunning OPT passes. (Maybe there is more to do..)
3.9.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.12. Executing OPT_MERGE pass (detect identical cells).
3.9.13. Executing OPT_DFF pass (perform DFF optimizations).
3.9.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.15. Executing OPT_EXPR pass (perform const folding).
3.9.16. Rerunning OPT passes. (Maybe there is more to do..)
3.9.17. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.18. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.19. Executing OPT_MERGE pass (detect identical cells).
3.9.20. Executing OPT_DFF pass (perform DFF optimizations).
3.9.21. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.22. Executing OPT_EXPR pass (perform const folding).
3.9.23. Rerunning OPT passes. (Maybe there is more to do..)
3.9.24. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.9.25. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.9.26. Executing OPT_MERGE pass (detect identical cells).
3.9.27. Executing OPT_DFF pass (perform DFF optimizations).
3.9.28. Executing OPT_CLEAN pass (remove unused cells and wires).
3.9.29. Executing OPT_EXPR pass (perform const folding).
3.9.30. Finished fast OPT passes. (There is nothing left to do.)
3.10. Executing WREDUCE pass (reducing word size of cells).
3.11. Executing PEEPOPT pass (run peephole optimizers).
3.12. Executing OPT_CLEAN pass (remove unused cells and wires).
3.13. Executing ALUMACC pass (create $alu and $macc cells).
3.14. Executing SHARE pass (SAT-based resource sharing).
3.15. Executing OPT pass (performing simple optimizations).
3.15.1. Executing OPT_EXPR pass (perform const folding).
3.15.2. Executing OPT_MERGE pass (detect identical cells).
3.15.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.15.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.15.5. Executing OPT_MERGE pass (detect identical cells).
3.15.6. Executing OPT_DFF pass (perform DFF optimizations).
3.15.7. Executing OPT_CLEAN pass (remove unused cells and wires).
3.15.8. Executing OPT_EXPR pass (perform const folding).
3.15.9. Rerunning OPT passes. (Maybe there is more to do..)
3.15.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
3.15.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
3.15.12. Executing OPT_MERGE pass (detect identical cells).
3.15.13. Executing OPT_DFF pass (perform DFF optimizations).
3.15.14. Executing OPT_CLEAN pass (remove unused cells and wires).
3.15.15. Executing OPT_EXPR pass (perform const folding).
3.15.16. Finished fast OPT passes. (There is nothing left to do.)
3.16. Executing MEMORY pass.
3.16.1. Executing OPT_MEM pass (optimize memories).
3.16.2. Executing OPT_MEM_PRIORITY pass (removing unnecessary memory write priority relations).
3.16.3. Executing OPT_MEM_FEEDBACK pass (finding memory read-to-write feedback paths).
3.16.4. Executing MEMORY_BMUX2ROM pass (converting muxes to ROMs).
3.16.5. Executing MEMORY_DFF pass (merging $dff cells to $memrd).
3.16.6. Executing OPT_CLEAN pass (remove unused cells and wires).
3.16.7. Executing MEMORY_SHARE pass (consolidating $memrd/$memwr cells).
3.16.8. Executing OPT_MEM_WIDEN pass (optimize memories where all ports are wide).
3.16.9. Executing OPT_CLEAN pass (remove unused cells and wires).
3.16.10. Executing MEMORY_COLLECT pass (generating $mem cells).
3.17. Executing OPT_CLEAN pass (remove unused cells and wires).
4. Executing SYNTH pass.
4.1. Executing OPT pass (performing simple optimizations).
4.1.1. Executing OPT_EXPR pass (perform const folding).
4.1.2. Executing OPT_MERGE pass (detect identical cells).
4.1.3. Executing OPT_DFF pass (perform DFF optimizations).
4.1.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.1.5. Finished fast OPT passes.
4.2. Executing MEMORY_MAP pass (converting memories to logic and flip-flops).
4.3. Executing OPT pass (performing simple optimizations).
4.3.1. Executing OPT_EXPR pass (perform const folding).
4.3.2. Executing OPT_MERGE pass (detect identical cells).
4.3.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.5. Executing OPT_MERGE pass (detect identical cells).
4.3.6. Executing OPT_SHARE pass.
4.3.7. Executing OPT_DFF pass (perform DFF optimizations).
4.3.8. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.9. Executing OPT_EXPR pass (perform const folding).
4.3.10. Rerunning OPT passes. (Maybe there is more to do..)
4.3.11. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.12. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.13. Executing OPT_MERGE pass (detect identical cells).
4.3.14. Executing OPT_SHARE pass.
4.3.15. Executing OPT_DFF pass (perform DFF optimizations).
4.3.16. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.17. Executing OPT_EXPR pass (perform const folding).
4.3.18. Rerunning OPT passes. (Maybe there is more to do..)
4.3.19. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.20. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.21. Executing OPT_MERGE pass (detect identical cells).
4.3.22. Executing OPT_SHARE pass.
4.3.23. Executing OPT_DFF pass (perform DFF optimizations).
4.3.24. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.25. Executing OPT_EXPR pass (perform const folding).
4.3.26. Rerunning OPT passes. (Maybe there is more to do..)
4.3.27. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.28. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.29. Executing OPT_MERGE pass (detect identical cells).
4.3.30. Executing OPT_SHARE pass.
4.3.31. Executing OPT_DFF pass (perform DFF optimizations).
4.3.32. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.33. Executing OPT_EXPR pass (perform const folding).
4.3.34. Rerunning OPT passes. (Maybe there is more to do..)
4.3.35. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
4.3.36. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
4.3.37. Executing OPT_MERGE pass (detect identical cells).
4.3.38. Executing OPT_SHARE pass.
4.3.39. Executing OPT_DFF pass (perform DFF optimizations).
4.3.40. Executing OPT_CLEAN pass (remove unused cells and wires).
4.3.41. Executing OPT_EXPR pass (perform const folding).
4.3.42. Finished fast OPT passes. (There is nothing left to do.)
4.4. Executing TECHMAP pass (map to technology primitives).
4.4.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/tools/install/yosys/bin/../share/yosys/techmap.v
4.4.2. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/common/lcu_kogge_stone.v
4.4.3. Continuing TECHMAP pass.
4.5. Executing OPT pass (performing simple optimizations).
4.5.1. Executing OPT_EXPR pass (perform const folding).
4.5.2. Executing OPT_MERGE pass (detect identical cells).
4.5.3. Executing OPT_DFF pass (perform DFF optimizations).
4.5.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.5.5. Finished fast OPT passes.
4.6. Executing ABC pass (technology mapping using ABC).
4.6.1. Extracting gate netlist of module `\ibex_core' to `<abc-temp-dir>/input.blif'..
4.7. Executing OPT pass (performing simple optimizations).
4.7.1. Executing OPT_EXPR pass (perform const folding).
4.7.2. Executing OPT_MERGE pass (detect identical cells).
4.7.3. Executing OPT_DFF pass (perform DFF optimizations).
4.7.4. Executing OPT_CLEAN pass (remove unused cells and wires).
4.7.5. Finished fast OPT passes.
4.8. Executing HIERARCHY pass (managing design hierarchy).
4.8.1. Analyzing design hierarchy..
4.8.2. Analyzing design hierarchy..
4.9. Printing statistics.
4.10. Executing CHECK pass (checking for obvious problems).
5. Executing OPT pass (performing simple optimizations).
5.1. Executing OPT_EXPR pass (perform const folding).
5.2. Executing OPT_MERGE pass (detect identical cells).
5.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
5.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
5.5. Executing OPT_MERGE pass (detect identical cells).
5.6. Executing OPT_DFF pass (perform DFF optimizations).
5.7. Executing OPT_CLEAN pass (remove unused cells and wires).
5.8. Executing OPT_EXPR pass (perform const folding).
5.9. Rerunning OPT passes. (Maybe there is more to do..)
5.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
5.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
5.12. Executing OPT_MERGE pass (detect identical cells).
5.13. Executing OPT_DFF pass (perform DFF optimizations).
5.14. Executing OPT_CLEAN pass (remove unused cells and wires).
5.15. Executing OPT_EXPR pass (perform const folding).
5.16. Finished fast OPT passes. (There is nothing left to do.)
6. Executing EXTRACT_FA pass (find and extract full/half adders).
7. Executing TECHMAP pass (map to technology primitives).
7.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_adders_R.v
7.2. Continuing TECHMAP pass.
8. Executing TECHMAP pass (map to technology primitives).
8.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/tools/install/yosys/bin/../share/yosys/techmap.v
8.2. Continuing TECHMAP pass.
9. Executing OPT pass (performing simple optimizations).
9.1. Executing OPT_EXPR pass (perform const folding).
9.2. Executing OPT_MERGE pass (detect identical cells).
9.3. Executing OPT_DFF pass (perform DFF optimizations).
9.4. Executing OPT_CLEAN pass (remove unused cells and wires).
9.5. Finished fast OPT passes.
10. Executing TECHMAP pass (map to technology primitives).
10.1. Executing Verilog-2005 frontend: /OpenROAD-flow-scripts/flow/platforms/asap7/yoSys/cells_latch_R.v
10.2. Continuing TECHMAP pass.
11. Executing DFFLIBMAP pass (mapping DFF cells to sequential cells from liberty file).
11.1. Executing DFFLEGALIZE pass (convert FFs to types supported by the target).
12. Executing OPT pass (performing simple optimizations).
12.1. Executing OPT_EXPR pass (perform const folding).
12.2. Executing OPT_MERGE pass (detect identical cells).
12.3. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
12.4. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
12.5. Executing OPT_MERGE pass (detect identical cells).
12.6. Executing OPT_DFF pass (perform DFF optimizations).
12.7. Executing OPT_CLEAN pass (remove unused cells and wires).
12.8. Executing OPT_EXPR pass (perform const folding).
12.9. Rerunning OPT passes. (Maybe there is more to do..)
12.10. Executing OPT_MUXTREE pass (detect dead branches in mux trees).
12.11. Executing OPT_REDUCE pass (consolidate $*mux and $reduce_* inputs).
12.12. Executing OPT_MERGE pass (detect identical cells).
12.13. Executing OPT_DFF pass (perform DFF optimizations).
12.14. Executing OPT_CLEAN pass (remove unused cells and wires).
12.15. Executing OPT_EXPR pass (perform const folding).
12.16. Finished fast OPT passes. (There is nothing left to do.)
13. Executing SETUNDEF pass (replace undef values with defined constants).
abc -script /OpenROAD-flow-scripts/flow/scripts/abc_speed.script -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib -dont_use *x1p*_ASAP7* -dont_use *xp*_ASAP7* -dont_use SDF* -dont_use ICG* -constr ./objects/asap7/ibex/base/abc.constr -D 1000
14. Executing ABC pass (technology mapping using ABC).
14.1. Extracting gate netlist of module `\ibex_core' to `<abc-temp-dir>/input.blif'..
14.1.1. Executed ABC.
14.1.2. Re-integrating ABC results.
Took 25 seconds: abc -script /OpenROAD-flow-scripts/flow/scripts/abc_speed.script -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz -liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib -dont_use *x1p*_ASAP7* -dont_use *xp*_ASAP7* -dont_use SDF* -dont_use ICG* -constr ./objects/asap7/ibex/base/abc.constr -D 1000
15. Executing SPLITNETS pass (splitting up multi-bit signals).
16. Executing OPT_CLEAN pass (remove unused cells and wires).
17. Executing HILOMAP pass (mapping to constant drivers).
18. Executing INSBUF pass (insert buffer cells for connected wires).
19. Executing CHECK pass (checking for obvious problems).
20. Printing statistics.
21. Executing CHECK pass (checking for obvious problems).
22. Executing Verilog backend.
22.1. Executing BMUXMAP pass.
22.2. Executing DEMUXMAP pass.
exec cp /OpenROAD-flow-scripts/flow/designs/asap7/ibex/constraint.sdc ./results/asap7/ibex/base/1_synth.sdc
End of script. Logfile hash: 5be854791b, CPU: user 6.45s system 0.08s, MEM: 178.65 MB peak
Yosys 0.60 (git sha1 UNKNOWN, g++ 11.4.0-1ubuntu1~22.04.2 -fPIC -O3)
Time spent: 80% 2x abc (25 sec), 5% 1x extract_fa (1 sec), ...
Elapsed time: 0:32.11[h:]min:sec. CPU time: user 31.95 sys 0.15 (99%). Peak memory: 182936KB.
cp /OpenROAD-flow-scripts/flow/designs/asap7/ibex/constraint.sdc ./results/asap7/ibex/base/1_2_yosys.sdc
OpenROAD 24Q3-11661-g86b9236cdd
Features included (+) or not (-): +GPU +GUI +Python
This program is licensed under the BSD-3 license. See the LICENSE file for details.
Components of this program may be licensed under more restrictive licenses which must be honored.
[INFO ORD-0030] Using 32 thread(s).
mkdir -p ./objects/asap7/ibex/base
/OpenROAD-flow-scripts/flow/scripts/flow.sh 1_synth synth_odb
Running synth_odb.tcl, stage 1_synth
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
[INFO ODB-0227] LEF file: /OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7_tech_1x_201209.lef, created 30 layers, 9 vias
[INFO ODB-0227] LEF file: /OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7sc7p5t_28_R_1x_220121a.lef, created 212 library cells
link_design ibex_core
Elapsed time: 0:01.01[h:]min:sec. CPU time: user 0.92 sys 0.09 (100%). Peak memory: 234804KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
1_synth                            1            229 8efc7aebf7e169e46251
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_1_floorplan floorplan
Running floorplan.tcl, stage 2_1_floorplan
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/1_synth.odb

==========================================================================
Floorplan check_setup
--------------------------------------------------------------------------
number instances in verilog is 18760
[WARNING IFP-0028] Core area lower left (2.000, 2.000) snapped to (2.052, 2.160).
[INFO IFP-0001] Added 280 rows of 1405 site asap7sc7p5t.
source /OpenROAD-flow-scripts/flow/platforms/asap7/openRoad/make_tracks.tcl
source /OpenROAD-flow-scripts/flow/platforms/asap7/fastroute.tcl
Repair tie lo fanout...
[INFO RSZ-0042] Inserted 7 tie TIELOx1_ASAP7_75t_R instances.
Repair tie hi fanout...
[INFO RSZ-0042] Inserted 1664 tie TIEHIx1_ASAP7_75t_R instances.
repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -setup -skip_last_gasp -sequence unbuffer,sizeup,swap,buffer,vt_swap -verbose
[WARNING EST-0027] no estimated parasitics. Using wire load models.
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove
[INFO RSZ-0094] Found 699 endpoints with setup violations.
[INFO RSZ-0099] Repairing 699 out of 699 (100.00%) violating endpoints...
   Iter   | Removed | Resized | Inserted | Cloned |  Pin  |   Area   |    WNS   |   TNS      |  Viol  | Worst
          | Buffers |  Gates  | Buffers  |  Gates | Swaps |          |          |            | Endpts | Endpt
--------------------------------------------------------------------------------------------------------------
        0 |       0 |       0 |        0 |      0 |     0 |    +0.0% | -453.347 |  -140558.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
       10 |       0 |       3 |        0 |      0 |     6 |    +0.0% | -441.035 |  -133047.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
       20 |       0 |      13 |        0 |      0 |     6 |    +0.0% | -428.048 |  -127137.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
       30 |       0 |      21 |        0 |      0 |     8 |    +0.0% | -419.394 |  -121601.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
       40 |       0 |      31 |        0 |      0 |     8 |    +0.0% | -413.265 |  -119448.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
       50 |       0 |      41 |        0 |      0 |     8 |    +0.0% | -403.506 |  -113042.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33535_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33535_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33535_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
       60 |       0 |      48 |        0 |      0 |    11 |    +0.0% | -393.273 |  -109613.3 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33567_/Y
       70 |       0 |      54 |        0 |      0 |    15 |    +0.0% | -391.143 |  -108825.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
       80 |       0 |      63 |        0 |      0 |    16 |    +0.1% | -381.167 |  -103262.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33431_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33535_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19773_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
       90 |       0 |      72 |        0 |      0 |    17 |    +0.1% | -377.211 |  -100664.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33431_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33431_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
      100 |       0 |      82 |        0 |      0 |    17 |    +0.1% | -372.709 |   -98753.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
      110 |       0 |      92 |        0 |      0 |    17 |    +0.1% | -371.304 |   -98351.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _19773_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _19773_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
      120 |       0 |     101 |        0 |      0 |    18 |    +0.1% | -362.136 |   -93555.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _19773_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33567_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
      130 |       0 |     110 |        0 |      0 |    19 |    +0.1% | -355.689 |   -90169.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
      136 |       0 |     110 |        0 |      0 |    20 |    +0.1% | -355.388 |   -90150.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
      140 |       0 |     112 |        0 |      0 |    21 |    +0.1% | -356.112 |   -90383.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
      140 |       0 |     111 |        0 |      0 |    20 |    +0.1% | -355.226 |   -90098.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33400_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19533_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19760_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24189_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30280_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24094_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _33105_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _32555_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30281_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30282_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30284_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30283_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _30279_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19550_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _35617_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/CON
[WARNING RSZ-0075] makeBufferedNet failed for driver _35557_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _35891_/SN
[WARNING RSZ-0075] makeBufferedNet failed for driver _24763_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24267_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _19759_/Y
[WARNING RSZ-0075] makeBufferedNet failed for driver _24273_/Y
[WARNING RSZ-0075] message limit (1000) reached. This message will no longer print.
      144 |       0 |     112 |        0 |      0 |    21 |    +0.1% | -355.192 |   -90087.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      146 |       0 |     113 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90062.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      147 |       0 |     113 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90062.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      148 |       0 |     113 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90062.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      149 |       0 |     113 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90062.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      150 |       0 |     113 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90062.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      150 |       0 |     113 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90062.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      151 |       0 |     113 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90062.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      152 |       0 |     113 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90062.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      156 |       0 |     115 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90041.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      157 |       0 |     115 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90041.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      158 |       0 |     115 |        0 |      0 |    21 |    +0.1% | -355.116 |   -90041.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      160 |       0 |     115 |        0 |      0 |    22 |    +0.1% | -355.116 |   -90040.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      160 |       0 |     115 |        0 |      0 |    22 |    +0.1% | -355.116 |   -90040.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      161 |       0 |     115 |        0 |      0 |    22 |    +0.1% | -355.116 |   -90040.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      163 |       0 |     115 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90038.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      164 |       0 |     115 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90038.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      165 |       0 |     115 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90038.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      166 |       0 |     115 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90038.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      167 |       0 |     115 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90038.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      170 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      171 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      173 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      176 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      179 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      180 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      181 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      184 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      187 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      189 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      190 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      192 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      195 |       0 |     117 |        0 |      0 |    23 |    +0.1% | -355.116 |   -90017.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      197 |       0 |     117 |        0 |      0 |    24 |    +0.1% | -355.114 |   -90017.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      200 |       0 |     118 |        0 |      0 |    25 |    +0.1% | -355.474 |   -90014.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      206 |       0 |     118 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89985.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      209 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      210 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      210 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      211 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      212 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      213 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      214 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      215 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      216 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      217 |       0 |     120 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89990.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      220 |       0 |     122 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89965.3 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      221 |       0 |     123 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89959.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      225 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      226 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      227 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      228 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      229 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      230 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      230 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      231 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      232 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      233 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      234 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      235 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      236 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      237 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      238 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      239 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      240 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      240 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      241 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      242 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      243 |       0 |     126 |        0 |      0 |    24 |    +0.1% | -355.114 |   -89928.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      250 |       0 |     129 |        0 |      0 |    27 |    +0.1% | -355.114 |   -89687.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      252 |       0 |     129 |        0 |      0 |    27 |    +0.1% | -355.114 |   -89687.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      253 |       0 |     129 |        0 |      0 |    27 |    +0.1% | -355.114 |   -89687.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      255 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      256 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      257 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      258 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      259 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      260 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      260 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      261 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      262 |       0 |     129 |        0 |      0 |    28 |    +0.1% | -355.114 |   -89686.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      267 |       0 |     132 |        0 |      0 |    29 |    +0.2% | -355.114 |   -89625.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      269 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      270 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      270 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      271 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      272 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      273 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      274 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      275 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      276 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      277 |       0 |     132 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89624.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      280 |       0 |     134 |        0 |      0 |    30 |    +0.2% | -355.114 |   -89575.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      282 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      283 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      284 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      285 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      286 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      287 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      288 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      289 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      290 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      290 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      291 |       0 |     135 |        0 |      0 |    31 |    +0.2% | -355.114 |   -89561.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      296 |       0 |     138 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89519.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      297 |       0 |     138 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89519.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      300 |       0 |     140 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89495.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      301 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      302 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      303 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      304 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      305 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      306 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      307 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      308 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      309 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      310 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      310 |       0 |     141 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89489.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      314 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      315 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      316 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      317 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      318 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      319 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      320 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      320 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      321 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      322 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      323 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      324 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      325 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      326 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      327 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      328 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      329 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      330 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      330 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      331 |       0 |     144 |        0 |      0 |    32 |    +0.2% | -355.114 |   -89459.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      333 |       0 |     144 |        0 |      0 |    33 |    +0.2% | -355.114 |   -89457.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      340 |       0 |     148 |        0 |      0 |    35 |    +0.2% | -356.430 |   -89456.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      340 |       0 |     147 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89433.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      342 |       0 |     147 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89433.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      347 |       0 |     147 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89433.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      350 |       0 |     149 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89399.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      352 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      354 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      356 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      358 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      360 |       0 |     151 |        0 |      0 |    34 |    +0.2% | -356.430 |   -89399.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      360 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      362 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      364 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      366 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      368 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      370 |       0 |     151 |        0 |      0 |    34 |    +0.2% | -356.430 |   -89399.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      370 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      372 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      374 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      376 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      378 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      380 |       0 |     151 |        0 |      0 |    34 |    +0.2% | -356.430 |   -89399.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      380 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      382 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      384 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      386 |       0 |     150 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89390.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      390 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      391 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      393 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      395 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      397 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      399 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      400 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      401 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      403 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      405 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      407 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      409 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      410 |       0 |     153 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89348.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      416 |       0 |     156 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89321.3 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      417 |       0 |     156 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89321.3 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      418 |       0 |     156 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89321.3 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      420 |       0 |     157 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.3 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      422 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      423 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      424 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      425 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      426 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      427 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      428 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      429 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      430 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      430 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      431 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      432 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      433 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      434 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      435 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      436 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      437 |       0 |     159 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89285.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      440 |       0 |     161 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89256.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      441 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      442 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      443 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      444 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      445 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      446 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      447 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      448 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      449 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      450 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      450 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      451 |       0 |     162 |        0 |      0 |    34 |    +0.2% | -355.114 |   -89250.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      453 |       0 |     162 |        0 |      0 |    35 |    +0.2% | -355.114 |   -89231.3 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      455 |       0 |     162 |        0 |      0 |    36 |    +0.2% | -355.114 |   -89229.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      460 |       0 |     162 |        0 |      0 |    40 |    +0.2% | -355.114 |   -89228.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      461 |       0 |     162 |        0 |      0 |    36 |    +0.2% | -355.114 |   -89229.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      465 |       0 |     162 |        0 |      0 |    38 |    +0.2% | -355.114 |   -89231.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      466 |       0 |     162 |        0 |      0 |    38 |    +0.2% | -355.114 |   -89231.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      469 |       0 |     162 |        0 |      0 |    38 |    +0.2% | -355.114 |   -89231.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      470 |       0 |     162 |        0 |      0 |    38 |    +0.2% | -355.114 |   -89231.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      471 |       0 |     162 |        0 |      0 |    38 |    +0.2% | -355.114 |   -89231.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      473 |       0 |     162 |        0 |      0 |    39 |    +0.2% | -354.412 |   -89209.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      475 |       0 |     162 |        0 |      0 |    39 |    +0.2% | -354.412 |   -89209.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      480 |       0 |     165 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89185.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      480 |       0 |     165 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89185.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      481 |       0 |     165 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89185.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      482 |       0 |     165 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89185.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      486 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      487 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      488 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      489 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      490 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      490 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      491 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      492 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      493 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      494 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      495 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      496 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      497 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      498 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      499 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      500 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      500 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      501 |       0 |     168 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89146.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      505 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      506 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      507 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      508 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      509 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      510 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      510 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      511 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      512 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      513 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      514 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      515 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      517 |       0 |     171 |        0 |      0 |    40 |    +0.2% | -354.395 |   -89106.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      519 |       0 |     171 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89104.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      520 |       0 |     171 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89104.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      520 |       0 |     171 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89104.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      526 |       0 |     171 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89104.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      530 |       0 |     174 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89066.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      530 |       0 |     174 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89066.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      531 |       0 |     174 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89066.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      535 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      536 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      537 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      538 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      539 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      540 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      540 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      541 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      542 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      543 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      544 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      545 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      546 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      547 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      548 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      549 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      550 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      550 |       0 |     177 |        0 |      0 |    41 |    +0.2% | -354.395 |   -89024.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      554 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      555 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      556 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      557 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      558 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      559 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      560 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      560 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      561 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      562 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      563 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      564 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      565 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      567 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      568 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      570 |       0 |     180 |        0 |      0 |    42 |    +0.2% | -354.395 |   -89022.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      580 |       0 |     183 |        0 |      0 |    49 |    +0.2% | -357.671 |   -89999.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      581 |       0 |     180 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88981.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      585 |       0 |     183 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88948.9 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      589 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      590 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      590 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      591 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      592 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      593 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      594 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      595 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      596 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      597 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      598 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      599 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      600 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      600 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      601 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      602 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      603 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      604 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      605 |       0 |     186 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88910.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      609 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      610 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      610 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      611 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      612 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      613 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      614 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      615 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      616 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      617 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      618 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      619 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      620 |       0 |     189 |        0 |      0 |    41 |    +0.2% | -354.395 |   -88872.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      630 |       0 |     192 |        0 |      0 |    48 |    +0.2% | -351.446 |   -87721.4 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      633 |       0 |     193 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87573.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      634 |       0 |     193 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87573.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      638 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      639 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      640 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      640 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      641 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      642 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      643 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      644 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      645 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      646 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      647 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      648 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      649 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      650 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      650 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      651 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      652 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      653 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      654 |       0 |     196 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87533.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      658 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      659 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      660 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      660 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      661 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      662 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      663 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      664 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      665 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      666 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      667 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      668 |       0 |     199 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87494.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      670 |       0 |     200 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87458.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      674 |       0 |     201 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87465.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      676 |       0 |     202 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87456.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      680 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      680 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      681 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      682 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      683 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      684 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      685 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      686 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      687 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      688 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      689 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      690 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      690 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      691 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      692 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      693 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      694 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      695 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      696 |       0 |     205 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87413.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      700 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      700 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      701 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      702 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      703 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      704 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      705 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      706 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      707 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      708 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      709 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      710 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      710 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      712 |       0 |     208 |        0 |      0 |    50 |    +0.2% | -351.446 |   -87371.2 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      719 |       0 |     211 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87142.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      720 |       0 |     211 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87142.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      720 |       0 |     211 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87142.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      724 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      725 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      726 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      727 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      728 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      729 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      730 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      730 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      731 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      732 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      733 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      734 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      735 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      736 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      737 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      738 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      739 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      740 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      740 |       0 |     214 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87102.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      744 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      745 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      746 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      747 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      748 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      749 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      750 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      750 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      751 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      752 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      753 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      755 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      756 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      758 |       0 |     217 |        0 |      0 |    52 |    +0.2% | -351.446 |   -87064.7 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      760 |       0 |     217 |        0 |      0 |    53 |    +0.2% | -351.446 |   -87324.0 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      770 |       0 |     222 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85601.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      780 |       0 |     230 |        0 |      0 |    60 |    +0.2% | -351.504 |   -84954.5 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      790 |       0 |     239 |        0 |      0 |    61 |    +0.3% | -351.785 |   -84572.1 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      800 |       1 |     246 |        0 |      0 |    63 |    +0.3% | -352.340 |   -84500.6 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      810 |       1 |     253 |        0 |      0 |    66 |    +0.3% | -352.223 |   -84202.8 |    699 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      810 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    698 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      820 |       0 |     234 |        0 |      0 |    58 |    +0.3% | -351.504 |   -84580.8 |    698 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      830 |       1 |     243 |        0 |      0 |    58 |    +0.3% | -352.340 |   -84572.7 |    698 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      840 |       1 |     253 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84397.9 |    698 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      850 |       1 |     261 |        0 |      0 |    60 |    +0.3% | -353.298 |   -84645.7 |    698 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      857 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    697 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      860 |       0 |     227 |        0 |      0 |    58 |    +0.2% | -351.504 |   -85248.9 |    697 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      870 |       0 |     237 |        0 |      0 |    58 |    +0.3% | -351.509 |   -84576.9 |    697 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      880 |       1 |     246 |        0 |      0 |    58 |    +0.3% | -352.360 |   -84516.2 |    697 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      890 |       1 |     256 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84329.1 |    697 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      896 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    696 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      900 |       0 |     228 |        0 |      0 |    58 |    +0.2% | -351.504 |   -85125.0 |    696 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      910 |       0 |     238 |        0 |      0 |    58 |    +0.3% | -351.776 |   -84586.6 |    696 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      920 |       1 |     247 |        0 |      0 |    58 |    +0.3% | -352.360 |   -84506.5 |    696 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      930 |       1 |     257 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84257.7 |    696 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      930 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    695 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      940 |       0 |     234 |        0 |      0 |    58 |    +0.3% | -351.504 |   -84580.8 |    695 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      950 |       1 |     243 |        0 |      0 |    58 |    +0.3% | -352.340 |   -84571.4 |    695 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      960 |       1 |     253 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84396.1 |    695 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      964 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    694 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      970 |       0 |     230 |        0 |      0 |    58 |    +0.2% | -351.504 |   -84928.8 |    694 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      980 |       0 |     240 |        0 |      0 |    58 |    +0.3% | -351.785 |   -84583.5 |    694 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      990 |       1 |     249 |        0 |      0 |    58 |    +0.3% | -352.090 |   -84353.8 |    694 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
      998 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    693 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1000 |       0 |     226 |        0 |      0 |    58 |    +0.2% | -351.504 |   -85269.0 |    693 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1010 |       0 |     236 |        0 |      0 |    58 |    +0.3% | -351.504 |   -84499.1 |    693 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1020 |       1 |     245 |        0 |      0 |    58 |    +0.3% | -352.340 |   -84507.8 |    693 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1030 |       1 |     255 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84373.9 |    693 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1032 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    692 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1040 |       0 |     232 |        0 |      0 |    58 |    +0.3% | -351.504 |   -84683.0 |    692 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1050 |       0 |     242 |        0 |      0 |    58 |    +0.3% | -351.785 |   -84465.6 |    692 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1060 |       1 |     251 |        0 |      0 |    58 |    +0.3% | -352.101 |   -84335.4 |    692 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1066 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    691 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1070 |       0 |     228 |        0 |      0 |    58 |    +0.2% | -351.504 |   -85125.0 |    691 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1080 |       0 |     238 |        0 |      0 |    58 |    +0.3% | -351.776 |   -84586.6 |    691 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1090 |       1 |     247 |        0 |      0 |    58 |    +0.3% | -352.360 |   -84506.5 |    691 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1100 |       1 |     257 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84257.7 |    691 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1100 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    690 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1110 |       0 |     234 |        0 |      0 |    58 |    +0.3% | -351.504 |   -84580.8 |    690 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1120 |       1 |     243 |        0 |      0 |    58 |    +0.3% | -352.340 |   -84571.4 |    690 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1130 |       1 |     253 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84396.1 |    690 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1134 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    689 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1140 |       0 |     230 |        0 |      0 |    58 |    +0.2% | -351.504 |   -84928.8 |    689 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1150 |       0 |     240 |        0 |      0 |    58 |    +0.3% | -351.785 |   -84583.5 |    689 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1160 |       1 |     249 |        0 |      0 |    58 |    +0.3% | -352.090 |   -84353.8 |    689 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1168 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1170 |       0 |     226 |        0 |      0 |    58 |    +0.2% | -351.504 |   -85269.0 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1180 |       0 |     236 |        0 |      0 |    58 |    +0.3% | -351.504 |   -84499.1 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1190 |       1 |     245 |        0 |      0 |    58 |    +0.3% | -352.340 |   -84507.8 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1200 |       1 |     255 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84373.9 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1200 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1210 |       0 |     234 |        0 |      0 |    58 |    +0.3% | -351.504 |   -84580.8 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1220 |       1 |     243 |        0 |      0 |    58 |    +0.3% | -352.340 |   -84572.7 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1230 |       1 |     253 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84397.9 |    688 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1234 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    687 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1240 |       0 |     230 |        0 |      0 |    58 |    +0.2% | -351.504 |   -84928.8 |    687 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1250 |       0 |     240 |        0 |      0 |    58 |    +0.3% | -351.785 |   -84584.4 |    687 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1260 |       1 |     249 |        0 |      0 |    58 |    +0.3% | -352.090 |   -84355.6 |    687 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1268 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    686 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1270 |       0 |     226 |        0 |      0 |    58 |    +0.2% | -351.504 |   -85269.0 |    686 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1280 |       0 |     236 |        0 |      0 |    58 |    +0.3% | -351.504 |   -84500.0 |    686 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1290 |       1 |     245 |        0 |      0 |    58 |    +0.3% | -352.340 |   -84509.1 |    686 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1300 |       1 |     255 |        0 |      0 |    58 |    +0.3% | -352.318 |   -84375.5 |    686 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
     1300 |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    686 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
    final |       0 |     225 |        0 |      0 |    58 |    +0.2% | -351.446 |   -85297.4 |    686 | gen_regfile_ff.register_file_i.rf_reg[222]$_DFFE_PN0P_/D
--------------------------------------------------------------------------------------------------------------
[INFO RSZ-0051] Resized 225 instances: 225 up, 0 up match, 0 down, 0 VT
[INFO RSZ-0043] Swapped pins on 58 instances.
[WARNING RSZ-0062] Unable to repair all setup violations.
Took 31 seconds: repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -setup -skip_last_gasp -sequence unbuffer,sizeup,swap,buffer,vt_swap -verbose
Default units for flow
 time 1ps
 capacitance 1fF
 resistance 1kohm
 voltage 1v
 current 1mA
 power 1pW
 distance 1um
Report metrics stage 2, floorplan final...

==========================================================================
floorplan final report_design_area
--------------------------------------------------------------------------
Design area 2386 um^2 42% utilization.
Elapsed time: 0:37.03[h:]min:sec. CPU time: user 52.54 sys 51.58 (281%). Peak memory: 283060KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_1_floorplan                     37            276 b5bc1015a0d05b145a7d
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_2_floorplan_macro macro_place
Running macro_place.tcl, stage 2_2_floorplan_macro
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/2_1_floorplan.odb
No macros found: Skipping macro_placement
Elapsed time: 0:00.92[h:]min:sec. CPU time: user 0.83 sys 0.09 (100%). Peak memory: 222272KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_2_floorplan_macro                0            217 b5bc1015a0d05b145a7d
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_3_floorplan_tapcell tapcell
Running tapcell.tcl, stage 2_3_floorplan_tapcell
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/2_2_floorplan_macro.odb
Tap and End Cap cell insertion
  TAP Cell          : TAPCELL_ASAP7_75t_R
  ENDCAP Cell       : TAPCELL_ASAP7_75t_R
  Halo Around Macro : 2 2
  TAP Cell Distance : 25
[INFO TAP-0004] Inserted 560 endcaps.
[INFO TAP-0005] Inserted 423 tapcells.
Elapsed time: 0:00.90[h:]min:sec. CPU time: user 0.82 sys 0.08 (100%). Peak memory: 211636KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_3_floorplan_tapcell              0            206 663855292ce6f4ce0888
/OpenROAD-flow-scripts/flow/scripts/flow.sh 2_4_floorplan_pdn pdn
Running pdn.tcl, stage 2_4_floorplan_pdn
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/2_3_floorplan_tapcell.odb
[INFO PDN-0001] Inserting grid: top
Elapsed time: 0:01.04[h:]min:sec. CPU time: user 0.99 sys 0.05 (100%). Peak memory: 227052KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
2_4_floorplan_pdn                  1            221 e72781f517cb9f13ad3d
cp ./results/asap7/ibex/base/2_4_floorplan_pdn.odb ./results/asap7/ibex/base/2_floorplan.odb
cp ./results/asap7/ibex/base/2_1_floorplan.sdc ./results/asap7/ibex/base/2_floorplan.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_1_place_gp_skip_io global_place_skip_io
Running global_place_skip_io.tcl, stage 3_1_place_gp_skip_io
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/2_floorplan.odb
[INFO GPL-0022] Initialize gpl and calculate uniform density.
Placement density is 0.5859999990463257, computed from PLACE_DENSITY_LB_ADDON  0.20 and lower bound 0.4699999988079071
global_placement -skip_io -density 0.5859999990463257 -pad_left 0 -pad_right 0
[INFO GPL-0005] Execute conjugate gradient initial placement.
[INFO GPL-0002] DBU: 1000
[INFO GPL-0003] SiteSize: (  0.054  0.270 ) um
[INFO GPL-0004] CoreBBox: (  2.052  2.160 ) ( 77.922 77.760 ) um
[INFO GPL-0032] Initializing region: Top-level
[INFO GPL-0006] Number of instances:             21412
[INFO GPL-0007] Movable instances:               20429
[INFO GPL-0008] Fixed instances:                   983
[INFO GPL-0009] Dummy instances:                     0
[INFO GPL-0010] Number of nets:                  21152
[INFO GPL-0011] Number of pins:                  70960
[INFO GPL-0012] Die BBox:  (  0.000  0.000 ) ( 79.941 79.941 ) um
[INFO GPL-0013] Core BBox: (  2.052  2.160 ) ( 77.922 77.760 ) um
[INFO GPL-0016] Core area:                    5735.772 um^2
[INFO GPL-0014] Region name: top-level.
[INFO GPL-0015] Region area:                  5735.772 um^2
[INFO GPL-0017] Fixed instances area:           28.664 um^2
[INFO GPL-0018] Movable instances area:       2665.419 um^2
[INFO GPL-0019] Utilization:                    46.704 %
[INFO GPL-0020] Standard cells area:          2665.419 um^2
[INFO GPL-0021] Large instances area:            0.000 um^2
[INFO GPL-0033] Initializing Nesterov region: Top-level
[INFO GPL-0023] Placement target density:       0.5860
[INFO GPL-0024] Movable insts average area:      0.130 um^2
[INFO GPL-0025] Ideal bin area:                  0.223 um^2
[INFO GPL-0026] Ideal bin count:                 25761
[INFO GPL-0027] Total bin area:               5735.772 um^2
[INFO GPL-0028] Bin count (X, Y):         128 ,    128
[INFO GPL-0029] Bin size (W * H):       0.593 *  0.591 um
[INFO GPL-0030] Number of bins:                  16384
[INFO GPL-0007] Execute nesterov global placement.
[INFO GPL-0031] HPWL: Half-Perimeter Wirelength
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
        0 |   0.9937 |  5.762501e+04 |   +0.00% |  4.03e-13 |
       10 |   0.9959 |  7.084385e+03 |  -87.71% |  6.56e-13 |
       20 |   0.9965 |  5.255693e+03 |  -25.81% |  1.07e-12 |
       30 |   0.9967 |  4.808036e+03 |   -8.52% |  1.74e-12 |
       40 |   0.9966 |  4.599136e+03 |   -4.34% |  2.83e-12 |
       50 |   0.9965 |  4.519270e+03 |   -1.74% |  4.62e-12 |
       60 |   0.9963 |  4.583972e+03 |   +1.43% |  7.52e-12 |
       70 |   0.9956 |  4.867132e+03 |   +6.18% |  1.23e-11 |
       80 |   0.9949 |  5.442380e+03 |  +11.82% |  2.00e-11 |
       90 |   0.9935 |  6.342201e+03 |  +16.53% |  3.25e-11 |
      100 |   0.9914 |  7.599960e+03 |  +19.83% |  5.29e-11 |
      110 |   0.9880 |  9.400310e+03 |  +23.69% |  8.62e-11 |
      120 |   0.9833 |  1.159288e+04 |  +23.32% |  1.40e-10 |
      130 |   0.9769 |  1.406034e+04 |  +21.28% |  2.29e-10 |
      140 |   0.9684 |  1.701286e+04 |  +21.00% |  3.72e-10 |
      150 |   0.9563 |  2.057921e+04 |  +20.96% |  6.06e-10 |
      160 |   0.9402 |  2.473600e+04 |  +20.20% |  9.87e-10 |
      170 |   0.9202 |  2.931512e+04 |  +18.51% |  1.61e-09 |
      180 |   0.8964 |  3.430773e+04 |  +17.03% |  2.62e-09 |
      190 |   0.8691 |  3.954176e+04 |  +15.26% |  4.26e-09 |
      200 |   0.8377 |  4.493936e+04 |  +13.65% |  6.93e-09 |
      210 |   0.8038 |  5.015549e+04 |  +11.61% |  1.13e-08 |
      220 |   0.7664 |  5.496244e+04 |   +9.58% |  1.84e-08 |
      230 |   0.7246 |  5.990230e+04 |   +8.99% |  2.99e-08 |
      240 |   0.6795 |  6.448650e+04 |   +7.65% |  4.87e-08 |
      250 |   0.6295 |  6.865654e+04 |   +6.47% |  7.93e-08 |
      260 |   0.5783 |  7.228700e+04 |   +5.29% |  1.29e-07 |
      270 |   0.5236 |  7.554702e+04 |   +4.51% |  2.10e-07 |
      280 |   0.4668 |  7.832001e+04 |   +3.67% |  3.42e-07 |
      290 |   0.4167 |  8.027797e+04 |   +2.50% |  5.57e-07 |
      300 |   0.3670 |  8.177022e+04 |   +1.86% |  9.08e-07 |
      310 |   0.3282 |  8.269901e+04 |   +1.14% |  1.42e-06 |
      320 |   0.2923 |  8.313173e+04 |   +0.52% |  2.09e-06 |
      330 |   0.2604 |  8.365105e+04 |   +0.62% |  3.08e-06 |
      340 |   0.2289 |  8.402700e+04 |   +0.45% |  4.54e-06 |
      350 |   0.1993 |  8.428785e+04 |   +0.31% |  6.69e-06 |
      360 |   0.1757 |  8.450696e+04 |   +0.26% |  9.85e-06 |
      370 |   0.1516 |  8.464936e+04 |   +0.17% |  1.45e-05 |
      380 |   0.1316 |  8.476304e+04 |   +0.13% |  2.14e-05 |
      390 |   0.1140 |  8.488490e+04 |   +0.14% |  3.15e-05 |
      399 |   0.0987 |  8.498272e+04 |          |  4.64e-05 |
---------------------------------------------------------------
[INFO GPL-1001] Global placement finished at iteration 399
[INFO GPL-1002] Placed Cell Area             2665.4193
[INFO GPL-1003] Available Free Area          5707.1077
[INFO GPL-1004] Minimum Feasible Density        0.4700 (cell_area / free_area)
[INFO GPL-1006]   Suggested Target Densities:
[INFO GPL-1007]     - For 90% usage of free space: 0.5189
[INFO GPL-1008]     - For 80% usage of free space: 0.5838
[INFO GPL-1009]     - For 50% usage of free space: 0.9341
[INFO GPL-1014] Final placement area: 2665.42 (+0.00%)
Took 13 seconds: global_placement -skip_io -density 0.5859999990463257 -pad_left 0 -pad_right 0
Elapsed time: 0:14.69[h:]min:sec. CPU time: user 434.86 sys 0.34 (2962%). Peak memory: 261572KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_1_place_gp_skip_io              14            255 55433ff3c200b0e7a5e4
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_2_place_iop io_placement
Running io_placement.tcl, stage 3_2_place_iop
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/3_1_place_gp_skip_io.odb
place_pins -hor_layers M4 -ver_layers M5
Found 0 macro blocks.
Using 2 tracks default min distance between IO pins.
[INFO PPL-0001] Number of available slots 3268
[INFO PPL-0002] Number of I/O             264
[INFO PPL-0003] Number of I/O w/sink      256
[INFO PPL-0004] Number of I/O w/o sink    8
[INFO PPL-0005] Slots per section         200
[INFO PPL-0008] Successfully assigned pins to sections.
[INFO PPL-0012] I/O nets HPWL: 5393.96 um.
Elapsed time: 0:00.92[h:]min:sec. CPU time: user 0.85 sys 0.06 (100%). Peak memory: 226124KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_2_place_iop                      0            220 18e4e75cfcd77bcdc430
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_3_place_gp global_place
Running global_place.tcl, stage 3_3_place_gp
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/3_2_place_iop.odb
[INFO RSZ-0026] Removed 1685 buffers.
Perform port buffering...
[INFO RSZ-0027] Inserted 149 BUFx2_ASAP7_75t_R input buffers.
[INFO RSZ-0028] Inserted 100 BUFx2_ASAP7_75t_R output buffers.
[INFO GPL-0022] Initialize gpl and calculate uniform density.
Placement density is 0.5699999904632569, computed from PLACE_DENSITY_LB_ADDON  0.20 and lower bound 0.44999998807907104
global_placement -density 0.5699999904632569 -pad_left 0 -pad_right 0 -routability_driven -timing_driven
[INFO GPL-0005] Execute conjugate gradient initial placement.
[INFO GPL-0002] DBU: 1000
[INFO GPL-0003] SiteSize: (  0.054  0.270 ) um
[INFO GPL-0004] CoreBBox: (  2.052  2.160 ) ( 77.922 77.760 ) um
[INFO GPL-0032] Initializing region: Top-level
[INFO GPL-0006] Number of instances:             19976
[INFO GPL-0007] Movable instances:               18993
[INFO GPL-0008] Fixed instances:                   983
[INFO GPL-0009] Dummy instances:                     0
[INFO GPL-0010] Number of nets:                  19716
[INFO GPL-0011] Number of pins:                  68352
[INFO GPL-0012] Die BBox:  (  0.000  0.000 ) ( 79.941 79.941 ) um
[INFO GPL-0013] Core BBox: (  2.052  2.160 ) ( 77.922 77.760 ) um
[INFO GPL-0016] Core area:                    5735.772 um^2
[INFO GPL-0014] Region name: top-level.
[INFO GPL-0015] Region area:                  5735.772 um^2
[INFO GPL-0017] Fixed instances area:           28.664 um^2
[INFO GPL-0018] Movable instances area:       2551.943 um^2
[INFO GPL-0019] Utilization:                    44.715 %
[INFO GPL-0020] Standard cells area:          2551.943 um^2
[INFO GPL-0021] Large instances area:            0.000 um^2
[InitialPlace]  Iter: 1 conjugate gradient residual: 0.00082982 HPWL: 82048275
[InitialPlace]  Iter: 2 conjugate gradient residual: 0.00000994 HPWL: 34398667
[InitialPlace]  Iter: 3 conjugate gradient residual: 0.00000120 HPWL: 33909201
[InitialPlace]  Iter: 4 conjugate gradient residual: 0.00000113 HPWL: 33848104
[InitialPlace]  Iter: 5 conjugate gradient residual: 0.00000270 HPWL: 33774329
[INFO GPL-0033] Initializing Nesterov region: Top-level
[INFO GPL-0023] Placement target density:       0.5700
[INFO GPL-0024] Movable insts average area:      0.134 um^2
[INFO GPL-0025] Ideal bin area:                  0.236 um^2
[INFO GPL-0026] Ideal bin count:                 24332
[INFO GPL-0027] Total bin area:               5735.772 um^2
[INFO GPL-0028] Bin count (X, Y):         128 ,    128
[INFO GPL-0029] Bin size (W * H):       0.593 *  0.591 um
[INFO GPL-0030] Number of bins:                  16384
[INFO GPL-0007] Execute nesterov global placement.
[INFO GPL-0031] HPWL: Half-Perimeter Wirelength
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
        0 |   0.9723 |  2.614073e+04 |   +0.00% |  1.74e-13 |
       10 |   0.9476 |  2.230276e+04 |  -14.68% |  2.83e-13 |
       20 |   0.9330 |  2.453901e+04 |  +10.03% |  4.61e-13 |
       30 |   0.9245 |  2.546838e+04 |   +3.79% |  7.52e-13 |
       40 |   0.9200 |  2.595555e+04 |   +1.91% |  1.22e-12 |
       50 |   0.9178 |  2.632131e+04 |   +1.41% |  1.99e-12 |
       60 |   0.9163 |  2.649545e+04 |   +0.66% |  3.25e-12 |
       70 |   0.9150 |  2.658422e+04 |   +0.34% |  5.29e-12 |
       80 |   0.9140 |  2.668910e+04 |   +0.39% |  8.62e-12 |
       90 |   0.9129 |  2.683180e+04 |   +0.53% |  1.40e-11 |
      100 |   0.9118 |  2.696767e+04 |   +0.51% |  2.29e-11 |
      110 |   0.9116 |  2.706624e+04 |   +0.37% |  3.72e-11 |
      120 |   0.9106 |  2.720710e+04 |   +0.52% |  6.07e-11 |
      130 |   0.9096 |  2.750187e+04 |   +1.08% |  9.88e-11 |
      140 |   0.9069 |  2.805160e+04 |   +2.00% |  1.61e-10 |
      150 |   0.9023 |  2.892887e+04 |   +3.13% |  2.62e-10 |
      160 |   0.8958 |  3.020041e+04 |   +4.40% |  4.27e-10 |
      170 |   0.8849 |  3.190283e+04 |   +5.64% |  6.95e-10 |
      180 |   0.8713 |  3.401487e+04 |   +6.62% |  1.13e-09 |
      190 |   0.8535 |  3.644936e+04 |   +7.16% |  1.84e-09 |
      200 |   0.8321 |  3.900664e+04 |   +7.02% |  3.00e-09 |
      210 |   0.8036 |  4.153804e+04 |   +6.49% |  4.89e-09 |
      220 |   0.7691 |  4.395800e+04 |   +5.83% |  7.96e-09 |
      230 |   0.7324 |  4.631518e+04 |   +5.36% |  1.30e-08 |
      240 |   0.6925 |  4.836499e+04 |   +4.43% |  2.11e-08 |
      250 |   0.6461 |  5.026420e+04 |   +3.93% |  3.44e-08 |
[INFO GPL-0100] Timing-driven iteration 1/2, virtual: false.
[INFO GPL-0101]    Iter: 254, overflow: 0.631, keep resizer changes at: 1, HPWL: 50602995
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |     19716
    final |     +2.8% |      22 |     255 |            83 |         0
---------------------------------------------------------------------
[INFO RSZ-0034] Found 75 slew violations.
[INFO RSZ-0036] Found 68 capacitance violations.
[INFO RSZ-0037] Found 1 long wires.
[INFO RSZ-0039] Resized 22 instances.
[INFO RSZ-0038] Inserted 255 buffers in 83 nets.
   Iter   |    Area   | Removed | Inserted |   Pins
          |           | Buffers | Buffers  | Remaining
-------------------------------------------------------
        0 |     +0.0% |       0 |        0 |     17886
     1700 |     +0.4% |       4 |       99 |     16186
     3400 |     +1.5% |      12 |      394 |     14486
     5100 |     +2.3% |     103 |      751 |     12786
     6800 |     +3.4% |     106 |     1026 |     11086
     8500 |     +4.0% |     110 |     1188 |      9386
    10200 |     +5.3% |     120 |     1544 |      7686
    11900 |     +5.9% |     124 |     1690 |      5986
    13600 |     +6.2% |     130 |     1799 |      4286
    15300 |     +6.6% |     158 |     1981 |      2586
    17000 |     +8.5% |     230 |     2622 |       886
    final |    +10.4% |     255 |     3196 |         0
-------------------------------------------------------
[INFO GPL-0106] Timing-driven: worst slack -2e-10
[INFO GPL-0107] Timing-driven: repair_design delta area: 307.680 um^2 (+12.06%)
[INFO GPL-0108] Timing-driven: repair_design, gpl delta gcells: 3196 (+16.83%)
[INFO GPL-0109] Timing-driven: repair_design, gcells created: 3451, deleted: 255
[INFO GPL-0110] Timing-driven: new target density: 0.6239116
[INFO GPL-0038] Routability snapshot saved at iter = 259
      258 |   0.5932 |  6.377943e+04 |          |           |
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      260 |   0.5819 |  6.392895e+04 |  +27.19% |  5.59e-08 |
      270 |   0.5476 |  6.415909e+04 |   +0.36% |  9.11e-08 |
      280 |   0.5160 |  6.606671e+04 |   +2.97% |  1.48e-07 |
      290 |   0.4658 |  6.817173e+04 |   +3.19% |  2.42e-07 |
      300 |   0.4147 |  6.932025e+04 |   +1.68% |  3.94e-07 |
      310 |   0.3773 |  6.999890e+04 |   +0.98% |  6.41e-07 |
      320 |   0.3384 |  7.014597e+04 |   +0.21% |  1.02e-06 |
      330 |   0.3114 |  7.050429e+04 |   +0.51% |  1.51e-06 |
[INFO GPL-0040] Routability iteration: 1
[INFO GPL-0041] Total routing overflow: 0.0000
[INFO GPL-0042] Number of overflowed tiles: 0 (0.00%)
[INFO GPL-0043] Average top 0.5% routing congestion: 0.8087
[INFO GPL-0044] Average top 1.0% routing congestion: 0.7708
[INFO GPL-0045] Average top 2.0% routing congestion: 0.7341
[INFO GPL-0046] Average top 5.0% routing congestion: 0.6847
[INFO GPL-0047] Routability iteration weighted routing congestion: 0.7897
[INFO GPL-0050] Weighted routing congestion is lower than target routing congestion(1.0100), end routability optimization.
[INFO GPL-0090] Routability finished. Target routing congestion achieved succesfully.
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      340 |   0.2814 |  7.088357e+04 |   +0.54% |  2.22e-06 |
      350 |   0.2533 |  7.088814e+04 |   +0.01% |  3.27e-06 |
      360 |   0.2245 |  7.104498e+04 |   +0.22% |  4.82e-06 |
      370 |   0.1978 |  7.107401e+04 |   +0.04% |  7.10e-06 |
[INFO GPL-0100] Timing-driven iteration 2/2, virtual: false.
[INFO GPL-0101]    Iter: 372, overflow: 0.195, keep resizer changes at: 1, HPWL: 71089567
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |     22912
    final |     +0.0% |       0 |       2 |             2 |         0
---------------------------------------------------------------------
[INFO RSZ-0036] Found 2 capacitance violations.
[INFO RSZ-0038] Inserted 2 buffers in 2 nets.
   Iter   |    Area   | Removed | Inserted |   Pins
          |           | Buffers | Buffers  | Remaining
-------------------------------------------------------
        0 |     +0.0% |       0 |        0 |     17886
     1700 |     +0.0% |      99 |      100 |     16186
     3400 |     -0.4% |     394 |      271 |     14486
     5100 |     -1.6% |     751 |      368 |     12786
     6800 |     -2.4% |    1026 |      419 |     11086
     8500 |     -2.8% |    1189 |      460 |      9386
    10200 |     -3.4% |    1545 |      653 |      7686
    11900 |     -3.4% |    1691 |      780 |      5986
    13600 |     -3.6% |    1801 |      848 |      4286
    15300 |     -3.7% |    1983 |     1012 |      2586
    17000 |     -4.3% |    2624 |     1445 |       886
    final |     -5.3% |    3198 |     1737 |         0
-------------------------------------------------------
[INFO GPL-0106] Timing-driven: worst slack -2e-10
[INFO GPL-0107] Timing-driven: repair_design delta area: -136.090 um^2 (-4.76%)
[INFO GPL-0108] Timing-driven: repair_design, gpl delta gcells: -1459 (-6.58%)
[INFO GPL-0109] Timing-driven: repair_design, gcells created: 1739, deleted: 3198
[INFO GPL-0110] Timing-driven: new target density: 0.600066
Iteration | Overflow |     HPWL (um) |  HPWL(%) |   Penalty | Group
---------------------------------------------------------------
      380 |   0.1802 |  7.009487e+04 |   -1.38% |  1.05e-05 |
      390 |   0.1558 |  6.887665e+04 |   -1.74% |  1.54e-05 |
      400 |   0.1348 |  6.842006e+04 |   -0.66% |  2.27e-05 |
      410 |   0.1165 |  6.820232e+04 |   -0.32% |  3.34e-05 |
      420 |   0.1007 |  6.811793e+04 |   -0.12% |  4.92e-05 |
      421 |   0.0991 |  6.811311e+04 |          |  5.32e-05 |
---------------------------------------------------------------
[INFO GPL-1001] Global placement finished at iteration 421
[INFO GPL-1003] Routability mode iteration count: 75
[INFO GPL-1005] Routability final weighted congestion: 0.7455
[INFO GPL-1002] Placed Cell Area             2723.5330
[INFO GPL-1003] Available Free Area          5707.1077
[INFO GPL-1004] Minimum Feasible Density        0.4500 (cell_area / free_area)
[INFO GPL-1006]   Suggested Target Densities:
[INFO GPL-1007]     - For 90% usage of free space: 0.5302
[INFO GPL-1008]     - For 80% usage of free space: 0.5965
[INFO GPL-1009]     - For 50% usage of free space: 0.9544
[INFO GPL-1011] Original area (um^2): 2551.94
[INFO GPL-1012] Total routability artificial inflation: 307.68 (+12.06%)
[INFO GPL-1013] Total timing-driven delta area: 171.59 (+6.72%)
[INFO GPL-1014] Final placement area: 2723.53 (+6.72%)
Took 37 seconds: global_placement -density 0.5699999904632569 -pad_left 0 -pad_right 0 -routability_driven -timing_driven
Report metrics stage 3, global place...

==========================================================================
global place report_design_area
--------------------------------------------------------------------------
Design area 2446 um^2 43% utilization.
Elapsed time: 0:46.16[h:]min:sec. CPU time: user 810.08 sys 25.96 (1811%). Peak memory: 551160KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_3_place_gp                      46            538 492c365a5d53a33031b4
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_4_place_resized resize
Running resize.tcl, stage 3_4_place_resized
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/3_3_place_gp.odb
Perform buffer insertion and gate resizing...
repair_design -verbose
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |     21453
     1000 |     +0.0% |       0 |       0 |             0 |     20453
     2000 |     +0.0% |       0 |       0 |             0 |     19453
     3000 |     +0.0% |       0 |       0 |             0 |     18453
     4000 |     +0.0% |       0 |       0 |             0 |     17453
     5000 |     +0.0% |       0 |       0 |             0 |     16453
     6000 |     +0.0% |       0 |       0 |             0 |     15453
     7000 |     +0.0% |       0 |       0 |             0 |     14453
     8000 |     +0.0% |       0 |       0 |             0 |     13453
     9000 |     +0.0% |       0 |       0 |             0 |     12453
    10000 |     +0.0% |       0 |       0 |             0 |     11453
    11000 |     +0.0% |       0 |       0 |             0 |     10453
    12000 |     +0.0% |       0 |       0 |             0 |      9453
    13000 |     +0.0% |       0 |       0 |             0 |      8453
    14000 |     +0.0% |       0 |       0 |             0 |      7453
    15000 |     +0.0% |       0 |       0 |             0 |      6453
    16000 |     +0.0% |       0 |       0 |             0 |      5453
    17000 |     +0.0% |       0 |       0 |             0 |      4453
    18000 |     +0.0% |       0 |       0 |             0 |      3453
    19000 |     +0.0% |       0 |       0 |             0 |      2453
    20000 |     +0.0% |       0 |       0 |             0 |      1453
    21000 |     +0.0% |       0 |       0 |             0 |       453
    final |     +0.0% |       0 |       0 |             0 |         0
---------------------------------------------------------------------
Floating nets:
Report metrics stage 3, resizer...

==========================================================================
resizer report_design_area
--------------------------------------------------------------------------
Design area 2446 um^2 43% utilization.
Instance count before 21713, after 21713
Pin count before 71562, after 71562
Elapsed time: 0:11.66[h:]min:sec. CPU time: user 15.99 sys 7.43 (200%). Peak memory: 301188KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_4_place_resized                 11            294 492c365a5d53a33031b4
/OpenROAD-flow-scripts/flow/scripts/flow.sh 3_5_place_dp detail_place
Running detail_place.tcl, stage 3_5_place_dp
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/3_4_place_resized.odb
Placement Analysis
---------------------------------
total displacement       4143.4 u
average displacement        0.2 u
max displacement            0.7 u
original HPWL           68392.3 u
legalized HPWL          71884.4 u
delta HPWL                    5 %

[INFO DPL-0020] Mirrored 8416 instances
[INFO DPL-0021] HPWL before           71884.4 u
[INFO DPL-0022] HPWL after            70370.4 u
[INFO DPL-0023] HPWL delta               -2.1 %
[INFO FLW-0012] Placement violations .
Report metrics stage 3, detailed place...

==========================================================================
detailed place report_design_area
--------------------------------------------------------------------------
Design area 2446 um^2 43% utilization.
Elapsed time: 0:09.66[h:]min:sec. CPU time: user 13.62 sys 6.61 (209%). Peak memory: 333372KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
3_5_place_dp                       9            325 7afa677c84c349b0a3cf
cp ./results/asap7/ibex/base/3_5_place_dp.odb ./results/asap7/ibex/base/3_place.odb
cp ./results/asap7/ibex/base/2_floorplan.sdc ./results/asap7/ibex/base/3_place.sdc
/OpenROAD-flow-scripts/flow/scripts/flow.sh 4_1_cts cts
Running cts.tcl, stage 4_1_cts
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/3_place.odb
clock_tree_synthesis -sink_clustering_enable -repair_clock_nets
[INFO CTS-0050] Root buffer is BUFx16f_ASAP7_75t_R.
[INFO CTS-0051] Sink buffer is BUFx24_ASAP7_75t_R.
[INFO CTS-0052] The following clock buffers will be used for CTS:
                    BUFx16f_ASAP7_75t_R
                    BUFx24_ASAP7_75t_R
[INFO CTS-0049] Characterization buffer is BUFx24_ASAP7_75t_R.
[INFO CTS-0007] Net "clk_i" found for clock "core_clock".
[INFO CTS-0011]  Clock net "clk_i" for macros has 1 sinks.
[INFO CTS-0011]  Clock net "clk_i_regs" for registers has 995 sinks.
[INFO CTS-0010]  Clock net "clk" has 943 sinks.
[INFO CTS-0008] TritonCTS found 3 clock nets.
[INFO CTS-0097] Characterization used 2 buffer(s) types.
[INFO CTS-0201] 0 blockages from hard placement blockages and placed macros will be used.
[INFO CTS-0027] Generating H-Tree topology for net clk_i.
[INFO CTS-0028]  Total number of sinks: 1.
[INFO CTS-0029]  Macro  sinks will be clustered in groups of up to 4 and with maximum cluster diameter of 50.0 um.
[INFO CTS-0030]  Number of static layers: 0.
[INFO CTS-0020]  Wire segment unit: 1350  dbu (1 um).
[INFO CTS-0023]  Original sink region: [(51608, 45921), (51608, 45921)].
[INFO CTS-0024]  Normalized sink region: [(38.2281, 34.0156), (38.2281, 34.0156)].
[INFO CTS-0025]     Width:  0.0000.
[INFO CTS-0026]     Height: 0.0000.
 Level 1
    Direction: Vertical
    Sinks per sub-region: 1
    Sub-region size: 0.0000 X 0.0000
[INFO CTS-0034]     Segment length (rounded): 1.
[INFO CTS-0032]  Stop criterion found. Max number of sinks is 15.
[INFO CTS-0035]  Number of sinks covered: 1.
[INFO CTS-0201] 0 blockages from hard placement blockages and placed macros will be used.
[INFO CTS-0027] Generating H-Tree topology for net clk_i_regs.
[INFO CTS-0028]  Total number of sinks: 995.
[INFO CTS-0090]  Sinks will be clustered based on buffer max cap.
[INFO CTS-0030]  Number of static layers: 0.
[INFO CTS-0020]  Wire segment unit: 1350  dbu (1 um).
[INFO CTS-0206] Best clustering solution was found from clustering size of 10 and clustering diameter of 50.
[INFO CTS-0019]  Total number of sinks after clustering: 47.
[INFO CTS-0024]  Normalized sink region: [(3.69463, 3.90256), (31.9325, 44.9299)].
[INFO CTS-0025]     Width:  28.2379.
[INFO CTS-0026]     Height: 41.0274.
 Level 1
    Direction: Vertical
    Sinks per sub-region: 24
    Sub-region size: 28.2379 X 20.5137
[INFO CTS-0034]     Segment length (rounded): 10.
 Level 2
    Direction: Horizontal
    Sinks per sub-region: 12
    Sub-region size: 14.1189 X 20.5137
[INFO CTS-0034]     Segment length (rounded): 8.
[INFO CTS-0032]  Stop criterion found. Max number of sinks is 15.
[INFO CTS-0035]  Number of sinks covered: 47.
[INFO CTS-0201] 0 blockages from hard placement blockages and placed macros will be used.
[INFO CTS-0027] Generating H-Tree topology for net clk.
[INFO CTS-0028]  Total number of sinks: 943.
[INFO CTS-0090]  Sinks will be clustered based on buffer max cap.
[INFO CTS-0030]  Number of static layers: 0.
[INFO CTS-0020]  Wire segment unit: 1350  dbu (1 um).
[INFO CTS-0206] Best clustering solution was found from clustering size of 10 and clustering diameter of 50.
[INFO CTS-0019]  Total number of sinks after clustering: 49.
[INFO CTS-0024]  Normalized sink region: [(20.6353, 12.7996), (56.3466, 55.4895)].
[INFO CTS-0025]     Width:  35.7113.
[INFO CTS-0026]     Height: 42.6898.
 Level 1
    Direction: Vertical
    Sinks per sub-region: 25
    Sub-region size: 35.7113 X 21.3449
[INFO CTS-0034]     Segment length (rounded): 10.
 Level 2
    Direction: Horizontal
    Sinks per sub-region: 13
    Sub-region size: 17.8557 X 21.3449
[INFO CTS-0034]     Segment length (rounded): 8.
[INFO CTS-0032]  Stop criterion found. Max number of sinks is 15.
[INFO CTS-0035]  Number of sinks covered: 49.
[INFO CTS-0018]     Created 2 clock buffers.
[INFO CTS-0012]     Minimum number of buffers in the clock path: 2.
[INFO CTS-0013]     Maximum number of buffers in the clock path: 2.
[INFO CTS-0015]     Created 2 clock nets.
[INFO CTS-0016]     Fanout distribution for the current clock = 1:1..
[INFO CTS-0017]     Max level of the clock tree: 1.
[INFO CTS-0018]     Created 52 clock buffers.
[INFO CTS-0012]     Minimum number of buffers in the clock path: 3.
[INFO CTS-0013]     Maximum number of buffers in the clock path: 3.
[INFO CTS-0015]     Created 52 clock nets.
[INFO CTS-0016]     Fanout distribution for the current clock = 10:2, 11:3, 13:1, 14:1, 17:1, 18:2, 19:4, 20:5, 21:10, 22:6, 23:4, 24:3, 25:7, 26:2..
[INFO CTS-0017]     Max level of the clock tree: 2.
[INFO CTS-0018]     Created 54 clock buffers.
[INFO CTS-0012]     Minimum number of buffers in the clock path: 3.
[INFO CTS-0013]     Maximum number of buffers in the clock path: 3.
[INFO CTS-0015]     Created 54 clock nets.
[INFO CTS-0016]     Fanout distribution for the current clock = 5:1, 8:1, 10:1, 12:1, 13:2, 14:1, 15:2, 18:5, 19:9, 20:16, 21:9, 22:2, 23:1, 25:2..
[INFO CTS-0017]     Max level of the clock tree: 2.
[INFO CTS-0124] Clock net "clk_i"
[INFO CTS-0125]  Sinks 1
[INFO CTS-0098] Clock net "clk_i_regs"
[INFO CTS-0099]  Sinks 1039
[INFO CTS-0100]  Leaf buffers 47
[INFO CTS-0101]  Average sink wire length 44.41 um
[INFO CTS-0102]  Path depth 2 - 3
[INFO CTS-0207]  Dummy loads inserted 44
[INFO CTS-0098] Clock net "clk"
[INFO CTS-0099]  Sinks 989
[INFO CTS-0100]  Leaf buffers 49
[INFO CTS-0101]  Average sink wire length 40.92 um
[INFO CTS-0102]  Path depth 2 - 3
[INFO CTS-0207]  Dummy loads inserted 46
[INFO CTS-0033] Balancing latency for clock core_clock
[INFO CTS-0036]  inserted 3 delay buffers
[INFO CTS-0037] Total number of delay buffers: 3
Placement Analysis
---------------------------------
total displacement        205.3 u
average displacement        0.0 u
max displacement            0.9 u
original HPWL           72144.2 u
legalized HPWL          73791.5 u
delta HPWL                    2 %

repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -verbose
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove CloneMove SplitLoadMove
[INFO RSZ-0094] Found 738 endpoints with setup violations.
[INFO RSZ-0099] Repairing 738 out of 738 (100.00%) violating endpoints...
   Iter   | Removed | Resized | Inserted | Cloned |  Pin  |   Area   |    WNS   |   TNS      |  Viol  | Worst
          | Buffers |  Gates  | Buffers  |  Gates | Swaps |          |          |            | Endpts | Endpt
--------------------------------------------------------------------------------------------------------------
        0 |       0 |       0 |        0 |      0 |     0 |    +0.0% | -229.575 |   -68518.1 |    738 | instr_addr_o[29]
       10 |       0 |       1 |        3 |      0 |     5 |    +0.0% | -191.877 |   -68267.4 |    738 | instr_addr_o[29]
       20 |       0 |       4 |        7 |      0 |     8 |    +0.0% | -179.864 |   -67610.0 |    738 | instr_addr_o[29]
       30 |       0 |       9 |       10 |      0 |    11 |    +0.0% | -171.594 |   -64496.0 |    738 | instr_addr_o[29]
       40 |       0 |      13 |       14 |      0 |    14 |    +0.1% | -162.863 |   -64402.6 |    738 | instr_addr_o[29]
       50 |       0 |      16 |       16 |      1 |    18 |    +0.1% | -159.283 |   -62619.0 |    738 | instr_addr_o[29]
       60 |       0 |      22 |       20 |      1 |    19 |    +0.1% | -156.036 |   -59459.2 |    738 | instr_addr_o[29]
       70 |       0 |      28 |       23 |      1 |    22 |    +0.1% | -151.866 |   -59386.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
       80 |       0 |      30 |       25 |      1 |    28 |    +0.1% | -148.665 |   -53695.3 |    738 | instr_addr_o[30]
       90 |       0 |      35 |       28 |      1 |    31 |    +0.2% | -144.667 |   -53626.9 |    738 | instr_addr_o[30]
      100 |       0 |      40 |       30 |      1 |    34 |    +0.2% | -146.583 |   -55466.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      110 |       0 |      45 |       32 |      1 |    37 |    +0.2% | -138.416 |   -52462.1 |    738 | instr_addr_o[23]
      120 |       0 |      52 |       35 |      1 |    38 |    +0.2% | -137.050 |   -51725.5 |    738 | instr_addr_o[30]
      130 |       0 |      58 |       38 |      1 |    39 |    +0.2% | -134.997 |   -50496.3 |    738 | instr_addr_o[30]
      140 |       0 |      64 |       41 |      1 |    41 |    +0.2% | -132.718 |   -49126.5 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      150 |       0 |      69 |       46 |      1 |    42 |    +0.3% | -131.535 |   -48243.0 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      160 |       0 |      77 |       47 |      1 |    43 |    +0.3% | -129.715 |   -47032.0 |    738 | instr_addr_o[31]
      170 |       0 |      80 |       50 |      2 |    46 |    +0.3% | -136.172 |   -47166.5 |    738 | gen_regfile_ff.register_file_i.rf_reg[991]$_DFFE_PN0P_/D
      180 |       0 |      86 |       50 |      3 |    49 |    +0.3% | -134.139 |   -46912.1 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      190 |       0 |      93 |       51 |      3 |    51 |    +0.3% | -129.918 |   -45616.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      200 |       0 |     101 |       53 |      3 |    52 |    +0.4% | -128.563 |   -45050.5 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      210 |       0 |     105 |       57 |      3 |    54 |    +0.4% | -127.270 |   -44491.2 |    738 | instr_addr_o[31]
      220 |       0 |     114 |       58 |      3 |    54 |    +0.4% | -126.546 |   -44133.0 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      230 |       0 |     118 |       65 |      4 |    54 |    +0.4% | -126.905 |   -43439.6 |    738 | instr_addr_o[31]
      240 |       0 |     124 |       66 |      7 |    54 |    +0.5% | -126.685 |   -43470.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      250 |       0 |     133 |       68 |      7 |    54 |    +0.5% | -126.548 |   -43402.0 |    738 | instr_addr_o[31]
      260 |       0 |     137 |       71 |      9 |    55 |    +0.5% | -132.705 |   -47854.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      270 |       0 |     144 |       72 |      9 |    57 |    +0.5% | -126.070 |   -43655.8 |    738 | instr_addr_o[31]
      280 |       0 |     148 |       76 |      9 |    60 |    +0.6% | -123.035 |   -43001.1 |    738 | instr_addr_o[30]
      290 |       0 |     153 |       78 |     10 |    62 |    +0.6% | -121.933 |   -42650.0 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      300 |       0 |     158 |       81 |     10 |    64 |    +0.6% | -120.365 |   -42010.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      310 |       0 |     166 |       82 |     11 |    64 |    +0.6% | -119.779 |   -41862.5 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      320 |       0 |     170 |       85 |     12 |    66 |    +0.7% | -121.149 |   -42543.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      330 |       0 |     175 |       88 |     12 |    69 |    +0.7% | -119.494 |   -41837.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      340 |       0 |     177 |       89 |     14 |    74 |    +0.7% | -120.904 |   -42089.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      350 |       0 |     184 |       92 |     15 |    75 |    +0.7% | -118.761 |   -41597.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      360 |       0 |     188 |       94 |     15 |    79 |    +0.7% | -119.460 |   -41547.9 |    738 | instr_addr_o[27]
      370 |       0 |     191 |       96 |     15 |    84 |    +0.8% | -116.963 |   -41049.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      380 |       0 |     197 |       98 |     16 |    85 |    +0.8% | -116.403 |   -41120.1 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      390 |       0 |     202 |       98 |     17 |    89 |    +0.8% | -120.973 |   -42686.0 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      400 |       0 |     203 |      106 |     17 |    93 |    +0.8% | -121.169 |   -44230.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      410 |       0 |     207 |      107 |     17 |    98 |    +0.8% | -118.914 |   -42858.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      420 |       0 |     212 |      109 |     17 |   101 |    +0.8% | -118.649 |   -43098.2 |    738 | instr_addr_o[23]
      430 |       0 |     213 |      118 |     17 |   105 |    +0.9% | -117.233 |   -41586.2 |    738 | data_wdata_o[2]
      436 |       0 |     200 |       98 |     16 |    88 |    +0.8% | -115.840 |   -40826.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      440 |       0 |     201 |      100 |     16 |    88 |    +0.8% | -115.840 |   -40844.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      450 |       0 |     204 |      104 |     16 |    91 |    +0.8% | -115.966 |   -40829.0 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      460 |       0 |     211 |      106 |     16 |    92 |    +0.8% | -116.239 |   -40879.5 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      470 |       0 |     217 |      107 |     16 |    95 |    +0.8% | -117.371 |   -41583.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      480 |       0 |     221 |      108 |     16 |   100 |    +0.9% | -117.326 |   -41569.1 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      481 |       0 |     202 |      101 |     16 |    88 |    +0.8% | -115.840 |   -40838.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      490 |       0 |     205 |      106 |     16 |    90 |    +0.8% | -115.966 |   -40846.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      500 |       0 |     211 |      110 |     16 |    90 |    +0.8% | -116.239 |   -40865.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      510 |       0 |     219 |      111 |     16 |    91 |    +0.9% | -116.187 |   -41176.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      520 |       0 |     225 |      114 |     16 |    93 |    +0.9% | -116.896 |   -41069.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      530 |       0 |     233 |      115 |     16 |    94 |    +0.9% | -117.868 |   -41583.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      536 |       0 |     203 |      102 |     16 |    90 |    +0.8% | -115.840 |   -40829.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      540 |       0 |     204 |      103 |     16 |    91 |    +0.8% | -115.840 |   -40828.1 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      550 |       0 |     209 |      108 |     16 |    91 |    +0.8% | -116.239 |   -40899.0 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      560 |       0 |     218 |      109 |     16 |    91 |    +0.8% | -117.274 |   -41422.5 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      570 |       0 |     225 |      112 |     16 |    92 |    +0.9% | -119.009 |   -42458.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      571 |       0 |     204 |      104 |     16 |    91 |    +0.8% | -115.840 |   -40832.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      580 |       0 |     207 |      107 |     16 |    93 |    +0.8% | -115.840 |   -40802.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      590 |       0 |     215 |      108 |     16 |    94 |    +0.8% | -115.840 |   -40747.0 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      600 |       0 |     222 |      110 |     16 |    95 |    +0.9% | -115.840 |   -40749.5 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      610 |       0 |     229 |      111 |     16 |    97 |    +0.9% | -115.840 |   -40839.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      620 |       0 |     236 |      112 |     16 |    99 |    +0.9% | -115.840 |   -40834.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      630 |       0 |     242 |      114 |     17 |   101 |    +0.9% | -115.840 |   -40831.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      640 |       0 |     249 |      115 |     17 |   103 |    +0.9% | -116.741 |   -41090.1 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      650 |       0 |     254 |      119 |     17 |   105 |    +1.0% | -116.970 |   -41157.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      660 |       0 |     258 |      123 |     17 |   107 |    +1.0% | -116.970 |   -41217.1 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      670 |       0 |     264 |      124 |     17 |   110 |    +1.0% | -117.442 |   -41352.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      680 |       0 |     271 |      126 |     17 |   111 |    +1.0% | -118.056 |   -41624.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      684 |       0 |     245 |      115 |     17 |   101 |    +0.9% | -115.840 |   -40821.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      690 |       0 |     248 |      117 |     18 |   101 |    +0.9% | -119.035 |   -42222.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      700 |       0 |     253 |      121 |     18 |   103 |    +1.0% | -115.996 |   -41533.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      709 |       0 |     253 |      121 |     18 |   102 |    +1.0% | -115.645 |   -41405.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[862]$_DFFE_PN0P_/D
      710 |       0 |     253 |      121 |     18 |   102 |    +1.0% | -115.645 |   -41405.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[862]$_DFFE_PN0P_/D
      720 |       0 |     258 |      123 |     18 |   105 |    +1.0% | -116.556 |   -41451.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[862]$_DFFE_PN0P_/D
      730 |       0 |     262 |      128 |     18 |   106 |    +1.0% | -116.556 |   -41427.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[862]$_DFFE_PN0P_/D
      740 |       0 |     270 |      128 |     19 |   107 |    +1.0% | -117.435 |   -42060.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      750 |       0 |     274 |      134 |     19 |   108 |    +1.1% | -115.995 |   -41222.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      760 |       0 |     281 |      136 |     19 |   109 |    +1.1% | -116.741 |   -41526.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      770 |       0 |     289 |      138 |     19 |   109 |    +1.1% | -116.741 |   -41562.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      780 |       0 |     295 |      142 |     21 |   109 |    +1.2% | -119.259 |   -43273.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      790 |       0 |     302 |      151 |     21 |   109 |    +1.2% | -119.259 |   -43422.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      799 |       0 |     273 |      134 |     19 |   108 |    +1.1% | -115.619 |   -41091.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      800 |       0 |     273 |      134 |     19 |   108 |    +1.1% | -115.619 |   -41091.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      807 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      809 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      810 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      811 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      813 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      815 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      817 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      819 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      820 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      821 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      824 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      826 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      829 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      830 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      831 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      834 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      836 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      839 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      840 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      842 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      845 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      847 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      849 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      850 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      851 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      854 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      857 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      860 |       1 |     276 |      135 |     19 |   109 |    +1.1% | -116.219 |   -41131.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      860 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      863 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      865 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      868 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      870 |       1 |     275 |      135 |     19 |   109 |    +1.1% | -115.967 |   -41045.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      871 |       1 |     274 |      135 |     19 |   109 |    +1.1% | -115.478 |   -41043.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      880 |       1 |     276 |      136 |     19 |   114 |    +1.1% | -115.478 |   -40116.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      890 |       1 |     278 |      138 |     20 |   119 |    +1.1% | -121.550 |   -40139.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
      900 |       1 |     279 |      139 |     20 |   127 |    +1.1% | -125.621 |   -40858.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
      910 |       1 |     279 |      141 |     20 |   135 |    +1.1% | -123.718 |   -40683.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
      920 |       1 |     281 |      141 |     20 |   143 |    +1.1% | -124.032 |   -41059.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
      930 |       1 |     284 |      143 |     20 |   148 |    +1.1% | -118.976 |   -39587.3 |    738 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
      931 |       1 |     276 |      137 |     19 |   114 |    +1.1% | -115.478 |   -40070.5 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      940 |       1 |     279 |      140 |     20 |   115 |    +1.1% | -116.469 |   -40002.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      942 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      948 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      950 |       1 |     278 |      138 |     20 |   114 |    +1.1% | -115.886 |   -39963.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
      954 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      960 |       1 |     280 |      140 |     20 |   114 |    +1.1% | -116.722 |   -40109.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      960 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      966 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      968 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      970 |       1 |     278 |      138 |     20 |   114 |    +1.1% | -115.886 |   -39963.7 |    738 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
      976 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      980 |       1 |     280 |      138 |     20 |   114 |    +1.1% | -115.478 |   -39986.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      984 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      986 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      988 |       1 |     278 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39863.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      990 |       1 |     279 |      138 |     19 |   114 |    +1.1% | -115.478 |   -39829.2 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
      996 |       1 |     279 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39883.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1000 |       1 |     281 |      138 |     21 |   115 |    +1.1% | -115.478 |   -39988.1 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1004 |       1 |     279 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39883.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1010 |       1 |     282 |      139 |     21 |   115 |    +1.1% | -116.469 |   -40062.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1012 |       1 |     279 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39883.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1017 |       1 |     279 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39883.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1020 |       1 |     280 |      139 |     20 |   115 |    +1.1% | -116.469 |   -39958.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1022 |       1 |     279 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39883.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1027 |       1 |     279 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39883.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1030 |       1 |     280 |      139 |     20 |   115 |    +1.1% | -116.469 |   -39958.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1032 |       1 |     279 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39883.8 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1040 |       1 |     284 |      140 |     20 |   115 |    +1.1% | -116.722 |   -40030.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1040 |       1 |     282 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39884.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1045 |       1 |     282 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39884.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1050 |       1 |     284 |      140 |     20 |   115 |    +1.1% | -116.722 |   -40030.4 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1050 |       1 |     282 |      138 |     20 |   115 |    +1.1% | -115.478 |   -39884.9 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1060 |       1 |     286 |      141 |     20 |   117 |    +1.1% | -115.478 |   -37502.6 |    738 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1069 |       1 |     291 |      145 |     22 |   117 |    +1.1% | -115.478 |   -37630.4 |    736 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1070 |       1 |     291 |      145 |     22 |   117 |    +1.1% | -115.478 |   -37630.4 |    736 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1074 |       1 |     293 |      146 |     22 |   118 |    +1.1% | -115.478 |   -37369.9 |    734 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1078 |       1 |     295 |      148 |     22 |   118 |    +1.1% | -115.478 |   -37168.2 |    732 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1080 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    732 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1084 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    732 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1089 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    732 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1090 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    732 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1097 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    732 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1100 |       1 |     296 |      149 |     23 |   118 |    +1.2% | -116.469 |   -37272.9 |    732 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1102 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    732 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1103 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1108 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1110 |       1 |     296 |      148 |     23 |   118 |    +1.1% | -116.469 |   -37331.0 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1113 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1118 |       1 |     295 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37198.2 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1120 |       1 |     296 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37178.7 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1126 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1130 |       1 |     299 |      150 |     23 |   118 |    +1.2% | -116.469 |   -37189.3 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1131 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    731 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1132 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    730 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1137 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    730 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1140 |       1 |     299 |      149 |     23 |   118 |    +1.2% | -116.469 |   -37254.6 |    730 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1142 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    730 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1147 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    730 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1150 |       1 |     299 |      149 |     23 |   118 |    +1.2% | -116.469 |   -37254.6 |    730 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1152 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    730 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1153 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    729 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1154 |       1 |     298 |      148 |     23 |   118 |    +1.1% | -115.478 |   -37179.8 |    728 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1160 |       1 |     301 |      150 |     23 |   118 |    +1.2% | -115.995 |   -37447.9 |    728 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1170 |       1 |     308 |      153 |     23 |   118 |    +1.2% | -116.741 |   -37893.8 |    728 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1180 |       1 |     316 |      154 |     23 |   119 |    +1.2% | -116.741 |   -37865.8 |    728 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1190 |       1 |     323 |      156 |     23 |   120 |    +1.2% | -115.478 |   -37186.1 |    728 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1200 |       2 |     330 |      163 |     23 |   120 |    +1.3% | -115.478 |   -37186.0 |    728 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1204 |       2 |     331 |      163 |     23 |   120 |    +1.3% | -115.478 |   -37184.4 |    728 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1207 |       2 |     333 |      163 |     23 |   120 |    +1.3% | -115.478 |   -37144.3 |    726 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1208 |       2 |     333 |      163 |     23 |   120 |    +1.3% | -115.478 |   -37144.3 |    725 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1209 |       2 |     333 |      163 |     23 |   120 |    +1.3% | -115.478 |   -37144.3 |    724 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1210 |       2 |     333 |      163 |     23 |   120 |    +1.3% | -115.478 |   -37144.3 |    724 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1210 |       2 |     333 |      163 |     23 |   120 |    +1.3% | -115.478 |   -37144.3 |    723 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1211 |       2 |     333 |      163 |     23 |   120 |    +1.3% | -115.478 |   -37144.3 |    722 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1220 |       2 |     336 |      164 |     23 |   124 |    +1.3% | -115.478 |   -37248.9 |    722 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1225 |       2 |     336 |      165 |     23 |   124 |    +1.3% | -115.478 |   -37219.7 |    722 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1226 |       2 |     336 |      165 |     23 |   124 |    +1.3% | -115.478 |   -37219.7 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1228 |       2 |     336 |      165 |     23 |   124 |    +1.3% | -115.478 |   -37219.7 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1230 |       2 |     337 |      165 |     23 |   124 |    +1.3% | -115.478 |   -37211.2 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1240 |       2 |     342 |      169 |     23 |   125 |    +1.3% | -115.478 |   -37146.1 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1250 |       2 |     349 |      172 |     23 |   125 |    +1.3% | -115.478 |   -37395.4 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1260 |       2 |     354 |      176 |     23 |   127 |    +1.4% | -116.826 |   -38452.8 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1263 |       2 |     349 |      170 |     23 |   125 |    +1.3% | -115.478 |   -37252.7 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1267 |       2 |     351 |      170 |     23 |   125 |    +1.3% | -115.478 |   -37218.3 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1270 |       2 |     353 |      170 |     23 |   125 |    +1.3% | -115.478 |   -37201.9 |    721 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1271 |       2 |     354 |      170 |     23 |   125 |    +1.3% | -115.478 |   -37201.5 |    719 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1273 |       2 |     354 |      170 |     23 |   125 |    +1.3% | -115.478 |   -37201.5 |    719 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1280 |       2 |     357 |      172 |     23 |   126 |    +1.4% | -115.478 |   -37190.8 |    719 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1290 |       2 |     362 |      177 |     23 |   127 |    +1.4% | -116.826 |   -38357.0 |    719 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1291 |       2 |     357 |      173 |     23 |   127 |    +1.4% | -115.478 |   -37217.6 |    719 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1300 |       2 |     360 |      175 |     24 |   129 |    +1.4% | -115.404 |   -37229.0 |    719 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1300 |       2 |     360 |      175 |     24 |   129 |    +1.4% | -115.404 |   -37229.0 |    719 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1305 |       2 |     363 |      175 |     24 |   130 |    +1.4% | -115.404 |   -37227.8 |    717 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1306 |       2 |     363 |      175 |     24 |   130 |    +1.4% | -115.404 |   -37227.8 |    716 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1308 |       2 |     363 |      175 |     24 |   130 |    +1.4% | -115.404 |   -37228.1 |    716 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1310 |       2 |     364 |      175 |     24 |   130 |    +1.4% | -115.656 |   -37369.5 |    716 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1310 |       2 |     363 |      175 |     24 |   130 |    +1.4% | -115.404 |   -37228.1 |    716 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1312 |       2 |     363 |      175 |     24 |   130 |    +1.4% | -115.404 |   -37228.1 |    716 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1313 |       2 |     363 |      175 |     24 |   130 |    +1.4% | -115.404 |   -37228.1 |    715 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1314 |       2 |     363 |      175 |     24 |   130 |    +1.4% | -115.404 |   -37228.1 |    714 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1316 |       2 |     363 |      175 |     24 |   130 |    +1.4% | -115.404 |   -37228.1 |    714 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1320 |       2 |     364 |      176 |     24 |   131 |    +1.4% | -115.404 |   -37218.0 |    714 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1330 |       2 |     370 |      180 |     24 |   132 |    +1.4% | -116.752 |   -38239.6 |    714 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1333 |       2 |     366 |      180 |     24 |   132 |    +1.4% | -115.404 |   -37292.0 |    714 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1334 |       2 |     366 |      180 |     24 |   132 |    +1.4% | -115.404 |   -37292.0 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1336 |       2 |     366 |      180 |     24 |   132 |    +1.4% | -115.404 |   -37292.0 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1339 |       2 |     367 |      180 |     24 |   132 |    +1.4% | -115.404 |   -37318.9 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1340 |       2 |     367 |      180 |     24 |   132 |    +1.4% | -115.404 |   -37318.9 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1343 |       2 |     368 |      180 |     25 |   132 |    +1.4% | -115.404 |   -37376.3 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1350 |       2 |     372 |      181 |     25 |   133 |    +1.4% | -115.404 |   -37321.6 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1360 |       2 |     377 |      184 |     25 |   136 |    +1.4% | -115.404 |   -37258.0 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1370 |       2 |     381 |      187 |     25 |   139 |    +1.5% | -115.404 |   -37265.2 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1380 |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1390 |       3 |     393 |      192 |     25 |   141 |    +1.5% | -115.404 |   -37285.1 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1400 |       3 |     398 |      196 |     25 |   142 |    +1.5% | -115.404 |   -37332.3 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
     1400 |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    713 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1400* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1401* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1402* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1403* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1404* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1405* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1406* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1407* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1408* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1409* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1410* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1410* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1411* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1412* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1413* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1414* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1415* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1416* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1417* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1418* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1419* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1420* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1420* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1421* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1422* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1423* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1424* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1425* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1426* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1427* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1428* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1429* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1430* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1430* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1431* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1432* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1433* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1434* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1435* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1436* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1437* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1438* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1439* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1440* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1440* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1441* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1442* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1443* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1444* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1445* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1446* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1447* |       3 |     386 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37238.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1450* |       3 |     388 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37215.4 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1451* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1452* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1453* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1454* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1455* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1456* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1457* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1458* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1459* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1460* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1460* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1461* |       3 |     389 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37194.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1464* |       3 |     391 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37178.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1465* |       3 |     391 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37178.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1466* |       3 |     391 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37178.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1467* |       3 |     391 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37178.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1468* |       3 |     391 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37178.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1469* |       3 |     391 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37178.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1470* |       3 |     391 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37178.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1472* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1473* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1474* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1475* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1476* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1477* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1478* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1479* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1480* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1480* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1481* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1482* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1483* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1484* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1485* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1486* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1487* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1488* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1489* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1490* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1490* |       3 |     393 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37170.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1493* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1494* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1495* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1496* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1497* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1498* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1499* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1500* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1501* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1502* |       3 |     395 |      191 |     25 |   139 |    +1.5% | -115.404 |   -37162.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1504* |       3 |     396 |      191 |     25 |   139 |    +1.5% | -115.404 |   -36978.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1505* |       3 |     396 |      191 |     25 |   139 |    +1.5% | -115.404 |   -36978.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1506* |       3 |     396 |      191 |     25 |   139 |    +1.5% | -115.404 |   -36978.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1509* |       3 |     398 |      191 |     25 |   139 |    +1.5% | -115.404 |   -36962.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1510* |       3 |     398 |      191 |     25 |   139 |    +1.5% | -115.404 |   -36962.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1510* |       3 |     398 |      191 |     25 |   139 |    +1.5% | -115.404 |   -36962.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1511* |       3 |     398 |      191 |     25 |   139 |    +1.5% | -115.404 |   -36962.1 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1513* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1514* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1515* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1516* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1517* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1518* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1519* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1520* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1520* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1521* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1522* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1523* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1524* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1525* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1526* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1527* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1528* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1529* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1530* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1530* |       3 |     398 |      191 |     25 |   140 |    +1.5% | -115.404 |   -36949.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1532* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1533* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1534* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1535* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1536* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1537* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1538* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1539* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1540* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1540* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1541* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1542* |       3 |     398 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36948.7 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1544* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1545* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1546* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1547* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1548* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1549* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1550* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1550* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1551* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1552* |       3 |     399 |      191 |     25 |   141 |    +1.5% | -115.404 |   -36924.3 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1554* |       3 |     399 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36923.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1555* |       3 |     399 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36923.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1556* |       3 |     399 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36923.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1557* |       3 |     399 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36923.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1558* |       3 |     399 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36923.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1559* |       3 |     399 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36923.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1560* |       3 |     399 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36923.9 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1562* |       3 |     401 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36901.0 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1563* |       3 |     401 |      191 |     25 |   142 |    +1.5% | -115.404 |   -36901.0 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1567* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1568* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1569* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1570* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1570* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1571* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1572* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1573* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1574* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1575* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1576* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1577* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1578* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1579* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1580* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1580* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1581* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1582* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1583* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1584* |       3 |     402 |      191 |     25 |   144 |    +1.5% | -115.404 |   -36893.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1586* |       3 |     402 |      191 |     25 |   145 |    +1.5% | -115.404 |   -36878.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1587* |       3 |     402 |      191 |     25 |   145 |    +1.5% | -115.404 |   -36878.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1588* |       3 |     402 |      191 |     25 |   145 |    +1.5% | -115.404 |   -36878.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1589* |       3 |     402 |      191 |     25 |   145 |    +1.5% | -115.404 |   -36878.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1590* |       3 |     402 |      191 |     25 |   145 |    +1.5% | -115.404 |   -36878.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1591* |       3 |     402 |      191 |     25 |   146 |    +1.5% | -115.404 |   -36878.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1593* |       3 |     402 |      191 |     25 |   147 |    +1.5% | -115.404 |   -36877.5 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1595* |       3 |     402 |      191 |     25 |   148 |    +1.5% | -115.404 |   -36876.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1596* |       3 |     402 |      191 |     25 |   148 |    +1.5% | -115.404 |   -36876.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1597* |       3 |     402 |      191 |     25 |   148 |    +1.5% | -115.404 |   -36876.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1598* |       3 |     402 |      191 |     25 |   148 |    +1.5% | -115.404 |   -36876.6 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    1600* |       3 |     403 |      191 |     25 |   148 |    +1.5% | -115.404 |   -36867.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
    final |       3 |     403 |      191 |     25 |   148 |    +1.5% | -115.404 |   -36867.8 |    710 | gen_regfile_ff.register_file_i.rf_reg[159]$_DFFE_PN0P_/D
--------------------------------------------------------------------------------------------------------------
[INFO RSZ-0059] Removed 3 buffers.
[INFO RSZ-0045] Inserted 191 buffers, 1 to split loads.
[INFO RSZ-0051] Resized 403 instances: 403 up, 0 up match, 0 down, 0 VT
[INFO RSZ-0043] Swapped pins on 148 instances.
[INFO RSZ-0049] Cloned 25 instances.
[WARNING RSZ-0062] Unable to repair all setup violations.
[INFO RSZ-0033] No hold violations found.
Took 114 seconds: repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -verbose
Placement Analysis
---------------------------------
total displacement        152.4 u
average displacement        0.0 u
max displacement            1.0 u
original HPWL           74689.7 u
legalized HPWL          74785.4 u
delta HPWL                    0 %

Report metrics stage 4, cts final...

==========================================================================
cts final report_design_area
--------------------------------------------------------------------------
Design area 2546 um^2 44% utilization.
Elapsed time: 2:08.59[h:]min:sec. CPU time: user 343.81 sys 207.97 (429%). Peak memory: 390036KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
4_1_cts                          128            380 a0afb06af424e80e1b6b
cp ./results/asap7/ibex/base/4_1_cts.odb ./results/asap7/ibex/base/4_cts.odb
/OpenROAD-flow-scripts/flow/scripts/flow.sh 5_1_grt global_route
Running global_route.tcl, stage 5_1_grt
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/4_cts.odb
pin_access
[INFO DRT-0149] Reading tech and libs.

Units:                1000
Number of layers:     21
Number of macros:     212
Number of vias:       14
Number of viarulegen: 11

[INFO DRT-0150] Reading design.

Design:                   ibex_core
Die area:                 ( 0 0 ) ( 79941 79941 )
Number of track patterns: 32
Number of DEF vias:       0
Number of components:     22128
Number of terminals:      266
Number of snets:          2
Number of nets:           21778

[INFO DRT-0167] List of default vias:
  Layer V2
    default via: VIA23
  Layer V3
    default via: VIA34
  Layer V4
    default via: VIA45
  Layer V5
    default via: VIA56
  Layer V6
    default via: VIA67
  Layer V7
    default via: VIA78
  Layer V8
    default via: VIA89
  Layer V9
    default via: VIA9Pad
[INFO DRT-0162] Library cell analysis.
[INFO DRT-0163] Instance analysis.
[INFO DRT-0164] Number of unique instances = 293.
[INFO DRT-0168] Init region query.
[INFO DRT-0024]   Complete Active.
[INFO DRT-0024]   Complete V0.
[INFO DRT-0024]   Complete M1.
[INFO DRT-0024]   Complete V1.
[INFO DRT-0024]   Complete M2.
[INFO DRT-0024]   Complete V2.
[INFO DRT-0024]   Complete M3.
[INFO DRT-0024]   Complete V3.
[INFO DRT-0024]   Complete M4.
[INFO DRT-0024]   Complete V4.
[INFO DRT-0024]   Complete M5.
[INFO DRT-0024]   Complete V5.
[INFO DRT-0024]   Complete M6.
[INFO DRT-0024]   Complete V6.
[INFO DRT-0024]   Complete M7.
[INFO DRT-0024]   Complete V7.
[INFO DRT-0024]   Complete M8.
[INFO DRT-0024]   Complete V8.
[INFO DRT-0024]   Complete M9.
[INFO DRT-0024]   Complete V9.
[INFO DRT-0024]   Complete Pad.
[INFO DRT-0033] Active shape region query size = 0.
[INFO DRT-0033] V0 shape region query size = 0.
[INFO DRT-0033] M1 shape region query size = 352650.
[INFO DRT-0033] V1 shape region query size = 633238.
[INFO DRT-0033] M2 shape region query size = 19998.
[INFO DRT-0033] V2 shape region query size = 11802.
[INFO DRT-0033] M3 shape region query size = 11802.
[INFO DRT-0033] V3 shape region query size = 7868.
[INFO DRT-0033] M4 shape region query size = 7956.
[INFO DRT-0033] V4 shape region query size = 7868.
[INFO DRT-0033] M5 shape region query size = 4530.
[INFO DRT-0033] V5 shape region query size = 784.
[INFO DRT-0033] M6 shape region query size = 448.
[INFO DRT-0033] V6 shape region query size = 0.
[INFO DRT-0033] M7 shape region query size = 0.
[INFO DRT-0033] V7 shape region query size = 0.
[INFO DRT-0033] M8 shape region query size = 0.
[INFO DRT-0033] V8 shape region query size = 0.
[INFO DRT-0033] M9 shape region query size = 0.
[INFO DRT-0033] V9 shape region query size = 0.
[INFO DRT-0033] Pad shape region query size = 0.
[INFO DRT-0165] Start pin access.
[INFO DRT-0076]   Complete 1000 pins.
[INFO DRT-0078]   Complete 1682 pins.
[INFO DRT-0079]   Complete 100 unique inst patterns.
[INFO DRT-0079]   Complete 200 unique inst patterns.
[INFO DRT-0081]   Complete 293 unique inst patterns.
[INFO DRT-0082]   Complete 10000 groups.
[INFO DRT-0084]   Complete 14628 groups.
#scanned instances     = 22128
#unique  instances     = 293
#stdCellGenAp          = 8300
#stdCellValidPlanarAp  = 66
#stdCellValidViaAp     = 6944
#stdCellPinNoAp        = 0
#stdCellPinCnt         = 70631
#instTermValidViaApCnt = 0
#macroGenAp            = 0
#macroValidPlanarAp    = 0
#macroValidViaAp       = 0
#macroNoAp             = 0
[INFO DRT-0166] Complete pin access.
[INFO DRT-0267] cpu time = 00:05:54, elapsed time = 00:00:11, memory = 320.95 (MB), peak = 320.95 (MB)
Took 12 seconds: pin_access
global_route -congestion_report_file ./reports/asap7/ibex/base/congestion.rpt -congestion_iterations 30 -congestion_report_iter_step 5 -verbose
[INFO GRT-0020] Min routing layer: M2
[INFO GRT-0021] Max routing layer: M7
[INFO GRT-0022] Global adjustment: 0%
[INFO GRT-0023] Grid origin: (0, 0)
[INFO GRT-0088] Layer M1      Track-Pitch = 0.0360  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M2      Track-Pitch = 0.0390  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M3      Track-Pitch = 0.0360  line-2-Via Pitch: 0.0360
[INFO GRT-0088] Layer M4      Track-Pitch = 0.0480  line-2-Via Pitch: 0.0480
[INFO GRT-0088] Layer M5      Track-Pitch = 0.0480  line-2-Via Pitch: 0.0480
[INFO GRT-0088] Layer M6      Track-Pitch = 0.0640  line-2-Via Pitch: 0.0640
[INFO GRT-0088] Layer M7      Track-Pitch = 0.0640  line-2-Via Pitch: 0.0640
[INFO GRT-0003] Macros: 0
[INFO GRT-0004] Blockages: 10806
[INFO GRT-0019] Found 114 clock nets.
[INFO GRT-0001] Minimum degree: 2
[INFO GRT-0002] Maximum degree: 85

[INFO GRT-0053] Routing resources analysis:
          Routing      Original      Derated      Resource
Layer     Direction    Resources     Resources    Reduction (%)
---------------------------------------------------------------
M1         Vertical            0             0          0.00%
M2         Horizontal     228680        164440          28.09%
M3         Vertical       297281        220890          25.70%
M4         Horizontal     227291        168804          25.73%
M5         Vertical       219995        163196          25.82%
M6         Horizontal     154193        104270          32.38%
M7         Vertical       173611        117038          32.59%
---------------------------------------------------------------

[INFO GRT-0197] Via related to pin nodes: 130440
[INFO GRT-0198] Via related Steiner nodes: 4667
[INFO GRT-0199] Via filling finished.
[INFO GRT-0111] Final number of vias: 169285
[INFO GRT-0112] Final usage 3D: 668217

[INFO GRT-0096] Final congestion report:
Layer         Resource        Demand        Usage (%)    Max H / Max V / Total Overflow
---------------------------------------------------------------------------------------
M1                   0             0            0.00%             0 /  0 /  0
M2              164440         58102           35.33%             0 /  0 /  0
M3              220890         72752           32.94%             0 /  0 /  0
M4              168804         18578           11.01%             0 /  0 /  0
M5              163196         10882            6.67%             0 /  0 /  0
M6              104270            48            0.05%             0 /  0 /  0
M7              117038             0            0.00%             0 /  0 /  0
---------------------------------------------------------------------------------------
Total           938638        160362           17.08%             0 /  0 /  0

[INFO GRT-0018] Total wirelength: 126057 um
[INFO GRT-0014] Routed nets: 21724
Perform buffer insertion and gate resizing...
repair_design -verbose
Iteration |   Area    | Resized | Buffers | Nets repaired | Remaining
---------------------------------------------------------------------
        0 |     +0.0% |       0 |       0 |             0 |     21868
     1000 |     +0.0% |       0 |       0 |             0 |     20868
     2000 |     +0.0% |       0 |       0 |             0 |     19868
     3000 |     +0.0% |       0 |       0 |             0 |     18868
     4000 |     +0.0% |       0 |       0 |             0 |     17868
     5000 |     +0.0% |       0 |       0 |             0 |     16868
     6000 |     +0.0% |       0 |       0 |             0 |     15868
     7000 |     +0.0% |       0 |       0 |             0 |     14868
     8000 |     +0.0% |       0 |       0 |             0 |     13868
     9000 |     +0.0% |       0 |       0 |             0 |     12868
    10000 |     +0.0% |       0 |       0 |             0 |     11868
    11000 |     +0.0% |       0 |       0 |             0 |     10868
    12000 |     +0.0% |       0 |       0 |             0 |      9868
    13000 |     +0.0% |       0 |       0 |             0 |      8868
    14000 |     +0.0% |       0 |       0 |             0 |      7868
    15000 |     +0.0% |       0 |       0 |             0 |      6868
    16000 |     +0.0% |       0 |       0 |             0 |      5868
    17000 |     +0.0% |       0 |       0 |             0 |      4868
    18000 |     +0.0% |       0 |       0 |             0 |      3868
    19000 |     +0.0% |       0 |       0 |             0 |      2868
    20000 |     +0.0% |       0 |       1 |             1 |      1868
    21000 |     +0.0% |       0 |       1 |             1 |       868
    final |     +0.0% |       0 |       1 |             1 |         0
---------------------------------------------------------------------
[INFO RSZ-0034] Found 1 slew violations.
[INFO RSZ-0038] Inserted 1 buffers in 1 nets.
global_route -start_incremental
detailed_placement
Placement Analysis
---------------------------------
total displacement          0.6 u
average displacement        0.0 u
max displacement            0.3 u
original HPWL           74802.2 u
legalized HPWL          74802.9 u
delta HPWL                    0 %

global_route -end_incremental -congestion_report_file ./reports/asap7/ibex/base/congestion_post_repair_design.rpt
Repair setup and hold violations...
repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -verbose
[INFO RSZ-0100] Repair move sequence: UnbufferMove SizeUpMove SwapPinsMove BufferMove CloneMove SplitLoadMove
[INFO RSZ-0094] Found 874 endpoints with setup violations.
[INFO RSZ-0099] Repairing 874 out of 874 (100.00%) violating endpoints...
   Iter   | Removed | Resized | Inserted | Cloned |  Pin  |   Area   |    WNS   |   TNS      |  Viol  | Worst
          | Buffers |  Gates  | Buffers  |  Gates | Swaps |          |          |            | Endpts | Endpt
--------------------------------------------------------------------------------------------------------------
        0 |       0 |       0 |        0 |      0 |     0 |    +0.0% | -158.810 |   -71821.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[1023]$_DFFE_PN0P_/D
       10 |       0 |       0 |        0 |      0 |     9 |    +0.0% | -164.768 |   -71602.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
       20 |       0 |       1 |        1 |      0 |    17 |    +0.0% | -155.393 |   -67818.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
       30 |       0 |       2 |        1 |      0 |    26 |    +0.0% | -163.681 |   -71090.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[606]$_DFFE_PN0P_/D
       40 |       0 |       3 |        2 |      2 |    32 |    +0.0% | -161.389 |   -64729.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
       50 |       0 |       4 |        2 |      2 |    41 |    +0.0% | -154.878 |   -62917.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
       60 |       0 |       8 |        3 |      2 |    46 |    +0.0% | -154.001 |   -62645.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
       70 |       0 |       8 |        4 |      2 |    55 |    +0.0% | -155.057 |   -62855.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
       80 |       0 |      14 |        6 |      2 |    57 |    +0.1% | -154.671 |   -62954.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
       90 |       0 |      16 |        8 |      2 |    63 |    +0.1% | -154.272 |   -63395.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
       92 |       0 |      15 |        6 |      2 |    61 |    +0.1% | -152.456 |   -62309.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      100 |       0 |      19 |        8 |      2 |    62 |    +0.1% | -153.406 |   -62934.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      100 |       0 |      18 |        8 |      2 |    61 |    +0.1% | -152.089 |   -62181.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      103 |       0 |      19 |        8 |      2 |    62 |    +0.1% | -151.967 |   -62113.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      110 |       0 |      20 |        8 |      2 |    67 |    +0.1% | -151.952 |   -63287.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      120 |       0 |      21 |       10 |      3 |    73 |    +0.1% | -163.086 |   -69521.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[1023]$_DFFE_PN0P_/D
      130 |       0 |      21 |       20 |      3 |    79 |    +0.1% | -161.938 |   -67160.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[1023]$_DFFE_PN0P_/D
      140 |       0 |      24 |       24 |      3 |    82 |    +0.2% | -172.405 |   -73469.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[1023]$_DFFE_PN0P_/D
      150 |       0 |      29 |       27 |      3 |    85 |    +0.2% | -166.583 |   -70020.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[1023]$_DFFE_PN0P_/D
      160 |       0 |      32 |       33 |      3 |    89 |    +0.2% | -164.379 |   -69249.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[1023]$_DFFE_PN0P_/D
      160 |       0 |      20 |        8 |      2 |    67 |    +0.1% | -154.664 |   -64603.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      170 |       0 |      22 |       18 |      4 |    67 |    +0.1% | -156.717 |   -65142.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      180 |       0 |      28 |       19 |      5 |    69 |    +0.2% | -153.608 |   -62641.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      190 |       1 |      31 |       21 |      7 |    71 |    +0.2% | -151.940 |   -61859.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      200 |       1 |      31 |       23 |      9 |    78 |    +0.2% | -151.940 |   -63153.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      203 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      204 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      205 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      206 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      207 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      208 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      209 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      210 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      210 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      211 |       1 |      33 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61710.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      213 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      214 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      216 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      218 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      220 |       1 |      35 |       23 |     10 |    78 |    +0.2% | -153.465 |   -61741.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      220 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      221 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      223 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      224 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      225 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      226 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      227 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      228 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      229 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      230 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      230 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      231 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      232 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      233 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      234 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      235 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      236 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      237 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      238 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      239 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      240 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      240 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      241 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      242 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      244 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      245 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      246 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      247 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      248 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      249 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      250 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      250 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      251 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      252 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      253 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      254 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      255 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      256 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      257 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      258 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      259 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      260 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      260 |       1 |      34 |       23 |     10 |    78 |    +0.2% | -151.940 |   -61713.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      264 |       1 |      34 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61519.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      265 |       1 |      34 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61519.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      266 |       1 |      34 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61519.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      268 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      269 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      270 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      270 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      271 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      272 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      273 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      274 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      275 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      276 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      277 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      278 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      279 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      280 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      280 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      281 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      282 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      283 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      284 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      285 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      286 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      287 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      288 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      289 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      290 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      290 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      291 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      292 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      293 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      294 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      295 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      296 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      297 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      298 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      299 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      300 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      300 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      301 |       1 |      35 |       23 |     10 |    80 |    +0.2% | -151.940 |   -61521.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      309 |       1 |      36 |       23 |     12 |    81 |    +0.2% | -151.940 |   -61546.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      310 |       1 |      36 |       23 |     12 |    81 |    +0.2% | -151.940 |   -61546.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      312 |       1 |      36 |       23 |     12 |    81 |    +0.2% | -151.940 |   -61546.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      315 |       1 |      36 |       23 |     12 |    81 |    +0.2% | -151.940 |   -61546.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      320 |       1 |      39 |       24 |     12 |    81 |    +0.2% | -152.967 |   -61561.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      322 |       1 |      38 |       23 |     12 |    81 |    +0.2% | -151.940 |   -61557.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      326 |       1 |      38 |       24 |     12 |    81 |    +0.2% | -151.940 |   -61557.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      330 |       1 |      41 |       24 |     12 |    81 |    +0.2% | -153.555 |   -61523.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      330 |       1 |      38 |       24 |     12 |    81 |    +0.2% | -151.940 |   -61557.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      337 |       1 |      41 |       24 |     13 |    81 |    +0.2% | -151.940 |   -61547.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      340 |       1 |      43 |       24 |     13 |    81 |    +0.2% | -153.555 |   -61520.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      341 |       1 |      41 |       24 |     13 |    81 |    +0.2% | -151.940 |   -61547.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      344 |       1 |      41 |       24 |     13 |    81 |    +0.2% | -151.940 |   -61547.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      347 |       1 |      41 |       24 |     13 |    81 |    +0.2% | -151.940 |   -61547.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      350 |       1 |      43 |       24 |     13 |    81 |    +0.2% | -151.940 |   -61558.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      353 |       1 |      44 |       24 |     13 |    81 |    +0.2% | -151.940 |   -61565.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      356 |       1 |      44 |       24 |     13 |    81 |    +0.2% | -151.940 |   -61565.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      360 |       1 |      44 |       24 |     14 |    83 |    +0.2% | -151.940 |   -61661.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      360 |       1 |      44 |       24 |     14 |    82 |    +0.2% | -151.940 |   -61625.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      363 |       1 |      44 |       24 |     14 |    82 |    +0.2% | -151.940 |   -61625.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      366 |       1 |      44 |       24 |     14 |    82 |    +0.2% | -151.940 |   -61625.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      370 |       1 |      47 |       24 |     14 |    82 |    +0.2% | -153.555 |   -61591.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      370 |       1 |      44 |       24 |     14 |    82 |    +0.2% | -151.940 |   -61625.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      374 |       1 |      44 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61687.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      377 |       1 |      44 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61687.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      380 |       1 |      46 |       24 |     15 |    82 |    +0.2% | -153.555 |   -61659.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      380 |       1 |      44 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61687.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      383 |       1 |      44 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61687.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      386 |       1 |      44 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61687.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      389 |       1 |      44 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61687.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      390 |       1 |      44 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61687.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      392 |       1 |      44 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61687.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      399 |       1 |      47 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61686.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      400 |       1 |      47 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61686.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      400 |       1 |      47 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61686.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      401 |       1 |      47 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61686.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      402 |       1 |      47 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61686.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      406 |       1 |      47 |       24 |     15 |    82 |    +0.2% | -151.940 |   -61686.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      410 |       1 |      49 |       25 |     15 |    82 |    +0.2% | -153.555 |   -61665.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      410 |       1 |      47 |       25 |     15 |    82 |    +0.2% | -151.940 |   -61693.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      411 |       1 |      47 |       25 |     15 |    82 |    +0.2% | -151.940 |   -61693.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      412 |       1 |      47 |       25 |     15 |    82 |    +0.2% | -151.940 |   -61693.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      413 |       1 |      47 |       25 |     15 |    82 |    +0.2% | -151.940 |   -61693.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      420 |       1 |      48 |       25 |     15 |    87 |    +0.2% | -151.940 |   -61860.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      430 |       1 |      51 |       25 |     15 |    94 |    +0.2% | -153.722 |   -62874.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      440 |       4 |      55 |       28 |     15 |    94 |    +0.2% | -153.722 |   -62051.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      450 |       4 |      60 |       29 |     15 |    98 |    +0.2% | -155.328 |   -63187.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      460 |       4 |      65 |       30 |     15 |   102 |    +0.3% | -156.669 |   -64188.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      460 |       1 |      47 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61684.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      463 |       1 |      47 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61684.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      464 |       1 |      47 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61684.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      468 |       1 |      50 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61656.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      470 |       1 |      51 |       25 |     15 |    83 |    +0.2% | -152.967 |   -61661.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      471 |       1 |      50 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61656.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      474 |       1 |      50 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61656.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      475 |       1 |      50 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61656.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      476 |       1 |      50 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61656.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      477 |       1 |      50 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61656.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      480 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      480 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      483 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      484 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      485 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      486 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      487 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      490 |       1 |      54 |       25 |     15 |    83 |    +0.2% | -153.555 |   -61635.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      490 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      491 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      492 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      495 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      496 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      497 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      498 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      499 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      500 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      500 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      501 |       1 |      52 |       25 |     15 |    83 |    +0.2% | -151.940 |   -61662.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      510 |       1 |      53 |       25 |     17 |    88 |    +0.2% | -151.940 |   -61889.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      520 |       1 |      56 |       26 |     17 |    94 |    +0.3% | -153.177 |   -62706.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      527 |       1 |      55 |       26 |     17 |    89 |    +0.3% | -151.940 |   -61830.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      528 |       1 |      55 |       26 |     17 |    89 |    +0.3% | -151.940 |   -61830.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      530 |       1 |      56 |       26 |     17 |    89 |    +0.3% | -151.940 |   -61794.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      540 |       1 |      62 |       26 |     17 |    93 |    +0.3% | -154.942 |   -64049.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      547 |       1 |      60 |       26 |     17 |    91 |    +0.3% | -151.886 |   -62650.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      550 |       1 |      62 |       26 |     17 |    91 |    +0.3% | -154.587 |   -63858.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      555 |       1 |      60 |       26 |     17 |    91 |    +0.3% | -151.886 |   -62650.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      560 |       1 |      61 |       27 |     17 |    93 |    +0.3% | -151.886 |   -62649.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      570 |       3 |      66 |       28 |     17 |    95 |    +0.3% | -153.486 |   -62476.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      580 |       4 |      70 |       31 |     17 |    97 |    +0.3% | -153.486 |   -62095.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      590 |       4 |      75 |       33 |     17 |   100 |    +0.3% | -153.486 |   -61949.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      600 |       4 |      78 |       36 |     17 |   104 |    +0.3% | -154.318 |   -62710.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      609 |       1 |      60 |       27 |     17 |    93 |    +0.3% | -151.886 |   -62647.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      610 |       1 |      60 |       27 |     17 |    93 |    +0.3% | -151.886 |   -62647.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      617 |       1 |      60 |       27 |     17 |    93 |    +0.3% | -151.886 |   -62647.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      620 |       1 |      62 |       27 |     17 |    93 |    +0.3% | -154.587 |   -63855.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      628 |       1 |      60 |       27 |     17 |    93 |    +0.3% | -151.886 |   -62647.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      630 |       1 |      61 |       27 |     17 |    93 |    +0.3% | -151.703 |   -62601.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      630 |       1 |      61 |       27 |     17 |    93 |    +0.3% | -151.703 |   -62601.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      640 |       2 |      65 |       27 |     17 |    97 |    +0.3% | -153.486 |   -62646.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      650 |       4 |      70 |       30 |     17 |    97 |    +0.3% | -153.486 |   -62108.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      660 |       4 |      76 |       33 |     17 |    98 |    +0.3% | -153.486 |   -61956.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      670 |       4 |      79 |       37 |     17 |   101 |    +0.3% | -155.092 |   -63144.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      676 |       1 |      61 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62599.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      680 |       1 |      64 |       27 |     17 |    95 |    +0.3% | -151.816 |   -62585.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      687 |       1 |      61 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62599.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      690 |       1 |      63 |       27 |     17 |    95 |    +0.3% | -154.587 |   -63844.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      698 |       1 |      61 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62599.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      699 |       1 |      61 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62599.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      700 |       1 |      61 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62599.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      700 |       1 |      61 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62599.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      710 |       1 |      69 |       28 |     17 |    95 |    +0.3% | -153.016 |   -62355.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      711 |       1 |      61 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62599.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      720 |       1 |      67 |       28 |     17 |    96 |    +0.3% | -153.016 |   -62371.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      720 |       1 |      61 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62599.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      730 |       1 |      69 |       28 |     17 |    95 |    +0.3% | -152.404 |   -62073.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      731 |       1 |      64 |       27 |     17 |    95 |    +0.3% | -151.703 |   -62546.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      740 |       1 |      68 |       28 |     17 |    98 |    +0.3% | -153.486 |   -62894.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      750 |       4 |      73 |       30 |     17 |    98 |    +0.3% | -153.486 |   -62137.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      760 |       4 |      79 |       34 |     17 |    98 |    +0.3% | -153.486 |   -61926.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      770 |       4 |      85 |       39 |     17 |    98 |    +0.3% | -155.092 |   -63093.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      776 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      780 |       1 |      68 |       28 |     17 |    98 |    +0.3% | -151.816 |   -62532.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      784 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      785 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      790 |       1 |      68 |       29 |     17 |    98 |    +0.3% | -151.816 |   -62445.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      793 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      800 |       1 |      70 |       29 |     17 |    98 |    +0.3% | -152.404 |   -62073.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      801 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      802 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      810 |       1 |      70 |       29 |     18 |    98 |    +0.3% | -152.404 |   -62165.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      811 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      820 |       1 |      71 |       29 |     18 |    98 |    +0.3% | -153.016 |   -62409.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      820 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      828 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      830 |       1 |      66 |       28 |     17 |    98 |    +0.3% | -154.968 |   -65233.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      837 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      840 |       1 |      66 |       28 |     18 |    98 |    +0.3% | -154.968 |   -65325.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      846 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      850 |       1 |      67 |       28 |     18 |    98 |    +0.3% | -154.587 |   -63883.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      855 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      860 |       1 |      68 |       28 |     18 |    98 |    +0.3% | -151.816 |   -62624.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      864 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      870 |       1 |      68 |       29 |     18 |    98 |    +0.3% | -151.816 |   -62537.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      873 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      880 |       1 |      69 |       30 |     18 |    98 |    +0.3% | -154.968 |   -65344.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      886 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      890 |       1 |      68 |       28 |     17 |    98 |    +0.3% | -151.816 |   -62532.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      894 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      900 |       1 |      69 |       28 |     18 |    98 |    +0.3% | -154.968 |   -65289.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      907 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62540.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      910 |       1 |      66 |       28 |     18 |    98 |    +0.3% | -154.968 |   -65325.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      920 |       1 |      74 |       31 |     18 |    98 |    +0.3% | -153.016 |   -62428.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      920 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      928 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      930 |       1 |      66 |       28 |     17 |    98 |    +0.3% | -154.968 |   -65233.4 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      936 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62546.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      940 |       1 |      67 |       28 |     18 |    98 |    +0.3% | -154.968 |   -65289.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      949 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62540.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      950 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62540.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      960 |       1 |      72 |       31 |     18 |    98 |    +0.3% | -152.185 |   -62422.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      962 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62534.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      970 |       1 |      70 |       30 |     18 |    98 |    +0.3% | -154.587 |   -63874.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      975 |       1 |      65 |       28 |     17 |    98 |    +0.3% | -151.703 |   -62540.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      980 |       1 |      66 |       28 |     17 |   101 |    +0.3% | -151.703 |   -63411.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      990 |       1 |      69 |       29 |     18 |   106 |    +0.3% | -151.703 |   -61797.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
      992 |       1 |      69 |       29 |     18 |   108 |    +0.3% | -151.703 |   -61751.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1000 |       1 |      74 |       31 |     19 |   108 |    +0.3% | -154.587 |   -63225.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1005 |       1 |      69 |       29 |     18 |   108 |    +0.3% | -151.703 |   -61745.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1007 |       1 |      69 |       29 |     19 |   108 |    +0.3% | -151.703 |   -61819.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1008 |       1 |      69 |       29 |     19 |   108 |    +0.3% | -151.703 |   -61819.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1009 |       1 |      69 |       29 |     19 |   108 |    +0.3% | -151.703 |   -61819.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1010 |       1 |      69 |       29 |     19 |   108 |    +0.3% | -151.703 |   -61819.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1010 |       1 |      69 |       29 |     19 |   108 |    +0.3% | -151.703 |   -61819.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1011 |       1 |      69 |       29 |     19 |   108 |    +0.3% | -151.703 |   -61819.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1020 |       1 |      71 |       35 |     19 |   110 |    +0.3% | -151.703 |   -61749.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1030 |       1 |      77 |       37 |     19 |   112 |    +0.3% | -153.486 |   -62220.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1040 |       4 |      83 |       37 |     19 |   113 |    +0.3% | -153.486 |   -61267.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1050 |       4 |      88 |       42 |     19 |   115 |    +0.3% | -153.486 |   -61431.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1060 |       4 |      93 |       49 |     19 |   115 |    +0.4% | -156.075 |   -64926.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1067 |       1 |      71 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61740.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1068 |       1 |      71 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61740.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1069 |       1 |      71 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61740.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1070 |       1 |      71 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61740.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1070 |       1 |      71 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61740.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1074 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1075 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1076 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1077 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1078 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1079 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1080 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1080 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1081 |       1 |      74 |       34 |     19 |   110 |    +0.3% | -151.703 |   -61724.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1090 |       1 |      78 |       35 |     19 |   113 |    +0.3% | -153.486 |   -62057.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1100 |       4 |      81 |       37 |     19 |   115 |    +0.3% | -153.486 |   -61598.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1110 |       5 |      86 |       41 |     19 |   115 |    +0.3% | -153.486 |   -61173.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1120 |       5 |      92 |       44 |     19 |   116 |    +0.4% | -155.092 |   -62273.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1128 |       1 |      74 |       35 |     19 |   112 |    +0.3% | -151.703 |   -61723.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1130 |       1 |      74 |       35 |     19 |   113 |    +0.3% | -151.703 |   -61724.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1140 |       1 |      81 |       36 |     19 |   115 |    +0.3% | -153.486 |   -62063.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1150 |       4 |      87 |       37 |     19 |   115 |    +0.3% | -155.092 |   -62504.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1154 |       1 |      76 |       36 |     19 |   113 |    +0.3% | -151.703 |   -61707.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1160 |       1 |      80 |       36 |     19 |   114 |    +0.3% | -153.486 |   -62044.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1170 |       4 |      83 |       40 |     19 |   114 |    +0.3% | -153.486 |   -61515.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1180 |       5 |      89 |       43 |     19 |   114 |    +0.3% | -153.486 |   -61154.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1190 |       5 |      94 |       47 |     19 |   116 |    +0.4% | -153.486 |   -61031.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1200 |       5 |     100 |       50 |     19 |   117 |    +0.4% | -154.318 |   -61615.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1200 |       1 |      76 |       36 |     19 |   113 |    +0.3% | -151.703 |   -61707.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1201 |       1 |      76 |       36 |     19 |   113 |    +0.3% | -151.703 |   -61707.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1202 |       1 |      76 |       36 |     19 |   113 |    +0.3% | -151.703 |   -61707.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1203 |       1 |      76 |       36 |     19 |   113 |    +0.3% | -151.703 |   -61707.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1204 |       1 |      76 |       36 |     19 |   113 |    +0.3% | -151.703 |   -61707.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1210 |       1 |      79 |       36 |     19 |   115 |    +0.3% | -153.486 |   -62043.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1220 |       3 |      84 |       39 |     19 |   115 |    +0.3% | -153.486 |   -61509.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1230 |       4 |      90 |       42 |     19 |   115 |    +0.3% | -153.486 |   -61092.6 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1240 |       4 |      96 |       46 |     19 |   115 |    +0.4% | -155.092 |   -62284.1 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1245 |       1 |      76 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61705.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1246 |       1 |      76 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61705.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1247 |       1 |      76 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61705.9 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1250 |       1 |      78 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61684.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1251 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61682.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1252 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61682.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1253 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61682.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1254 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61682.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1255 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61682.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1260 |       1 |      81 |       36 |     20 |   115 |    +0.3% | -154.587 |   -63330.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1266 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61670.2 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1270 |       1 |      81 |       36 |     20 |   114 |    +0.3% | -154.587 |   -63132.8 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1275 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61664.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1276 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61664.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1280 |       1 |      81 |       36 |     20 |   114 |    +0.3% | -154.587 |   -63132.3 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1285 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61664.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1286 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61664.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1290 |       1 |      81 |       36 |     20 |   114 |    +0.3% | -154.968 |   -64652.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1298 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61664.7 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1300 |       1 |      80 |       36 |     19 |   114 |    +0.3% | -154.968 |   -64580.5 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
     1300 |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    874 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1300* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1301* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1302* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1303* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1304* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1305* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1306* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1307* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1308* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1309* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1310* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1310* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1311* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1312* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1313* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1314* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1315* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1316* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1317* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1318* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1319* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1320* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1320* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1321* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1322* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1323* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1324* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1325* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1326* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1327* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1328* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1329* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1330* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1330* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1331* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1332* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1333* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1334* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1335* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1336* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1337* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1338* |       1 |      79 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61677.0 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1340* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1340* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1341* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1342* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1343* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1344* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1345* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1346* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1347* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1348* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1349* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1350* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1350* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1351* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1352* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1353* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1354* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1355* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1356* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1357* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1358* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1359* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1360* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1360* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1361* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1362* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1363* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1364* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1365* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1366* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1367* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1368* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1369* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1370* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1370* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1371* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1372* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1373* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1374* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1375* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1376* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1377* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1378* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1379* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1380* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1380* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1381* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1382* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1383* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1384* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1385* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1386* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1387* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1388* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1389* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1390* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1390* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1391* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1392* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1393* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1394* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1395* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1396* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1397* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1398* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1399* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1400* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1401* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1402* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1403* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1404* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1405* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1406* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1407* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1408* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1409* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1410* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1410* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1411* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1412* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1413* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1414* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1415* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1416* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1417* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1418* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1419* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1420* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1420* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1421* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1422* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1423* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1424* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1425* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1426* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1427* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1428* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1429* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1430* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1430* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1431* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1432* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1433* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1434* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1435* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1436* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1437* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1438* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1439* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1440* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1440* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1441* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1442* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1443* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1444* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1445* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1446* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1447* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1448* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1449* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1450* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1450* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1451* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1452* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1453* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1454* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1455* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1456* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1457* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1458* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1459* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1460* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1460* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1461* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1462* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1463* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1464* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1465* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1466* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1467* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1468* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1469* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1470* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1470* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1471* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1472* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1473* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1474* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1475* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1476* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1477* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1478* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1479* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1480* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1480* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1481* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1482* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1483* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1484* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1485* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1486* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1487* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1488* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1489* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1490* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1490* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1491* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1492* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1493* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1494* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1495* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1496* |       1 |      80 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61676.2 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1498* |       1 |      81 |       36 |     19 |   114 |    +0.3% | -151.703 |   -61668.9 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    1500* |       1 |      81 |       36 |     19 |   115 |    +0.3% | -151.703 |   -61658.3 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
    final |       1 |      81 |       36 |     19 |   115 |    +0.3% | -151.703 |   -61658.3 |    842 | gen_regfile_ff.register_file_i.rf_reg[542]$_DFFE_PN0P_/D
--------------------------------------------------------------------------------------------------------------
[INFO RSZ-0059] Removed 1 buffers.
[INFO RSZ-0040] Inserted 36 buffers.
[INFO RSZ-0051] Resized 81 instances: 81 up, 0 up match, 0 down, 0 VT
[INFO RSZ-0043] Swapped pins on 115 instances.
[INFO RSZ-0049] Cloned 19 instances.
[WARNING RSZ-0062] Unable to repair all setup violations.
[INFO RSZ-0033] No hold violations found.
Took 126 seconds: repair_timing -setup_margin 0 -hold_margin 0 -repair_tns 100 -verbose
global_route -start_incremental
detailed_placement
Placement Analysis
---------------------------------
total displacement         37.9 u
average displacement        0.0 u
max displacement            0.7 u
original HPWL           75175.0 u
legalized HPWL          75203.6 u
delta HPWL                    0 %

global_route -end_incremental -congestion_report_file ./reports/asap7/ibex/base/congestion_post_repair_timing.rpt
global_route -start_incremental
global_route -end_incremental -congestion_report_file ./reports/asap7/ibex/base/congestion_post_recover_power.rpt
Repair antennas...
[WARNING GRT-0246] No diode with LEF class CORE ANTENNACELL found.
[INFO ANT-0002] Found 0 net violations.
[INFO ANT-0001] Found 0 pin violations.
Estimate parasitics...
Report metrics stage 5, global route...

==========================================================================
global route report_design_area
--------------------------------------------------------------------------
Design area 2555 um^2 45% utilization.
[INFO FLW-0007] clock core_clock period 1000.000000
[INFO FLW-0008] Clock core_clock period 1097.727
[INFO FLW-0009] Clock core_clock slack -155.502
[INFO FLW-0011] Path endpoint path count 3836
Elapsed time: 2:37.48[h:]min:sec. CPU time: user 1580.66 sys 175.60 (1115%). Peak memory: 718540KB.
Log                        Elapsed/s Peak Memory/MB  sha1sum .odb [0:20)
5_1_grt                          157            701 6f296a53c34c2a5850da
/OpenROAD-flow-scripts/flow/scripts/flow.sh 5_2_route detail_route
Running detail_route.tcl, stage 5_2_route
source /OpenROAD-flow-scripts/flow/platforms/asap7/liberty_suppressions.tcl
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib.gz
read_liberty /OpenROAD-flow-scripts/flow/platforms/asap7/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_db ./results/asap7/ibex/base/5_1_grt.odb
detailed_route -output_drc ./reports/asap7/ibex/base/5_route_drc.rpt -output_maze ./results/asap7/ibex/base/maze.log -droute_end_iter 64 -verbose 1 -drc_report_iter_step 5
[INFO DRT-0149] Reading tech and libs.

Units:                1000
Number of layers:     21
Number of macros:     212
Number of vias:       14
Number of viarulegen: 11

[INFO DRT-0150] Reading design.

Design:                   ibex_core
Die area:                 ( 0 0 ) ( 79941 79941 )
Number of track patterns: 32
Number of DEF vias:       0
Number of components:     22183
Number of terminals:      266
Number of snets:          2
Number of nets:           21833

[INFO DRT-0167] List of default vias:
  Layer V2
    default via: VIA23
  Layer V3
    default via: VIA34
  Layer V4
    default via: VIA45
  Layer V5
    default via: VIA56
  Layer V6
    default via: VIA67
  Layer V7
    default via: VIA78
  Layer V8
    default via: VIA89
  Layer V9
    default via: VIA9Pad
[INFO DRT-0162] Library cell analysis.
[INFO DRT-0163] Instance analysis.
[INFO DRT-0164] Number of unique instances = 293.
[INFO DRT-0168] Init region query.
[INFO DRT-0024]   Complete Active.
[INFO DRT-0024]   Complete V0.
[INFO DRT-0024]   Complete M1.
[INFO DRT-0024]   Complete V1.
[INFO DRT-0024]   Complete M2.
[INFO DRT-0024]   Complete V2.
[INFO DRT-0024]   Complete M3.
[INFO DRT-0024]   Complete V3.
[INFO DRT-0024]   Complete M4.
[INFO DRT-0024]   Complete V4.
[INFO DRT-0024]   Complete M5.
[INFO DRT-0024]   Complete V5.
[INFO DRT-0024]   Complete M6.
[INFO DRT-0024]   Complete V6.
[INFO DRT-0024]   Complete M7.
[INFO DRT-0024]   Complete V7.
[INFO DRT-0024]   Complete M8.
[INFO DRT-0024]   Complete V8.
[INFO DRT-0024]   Complete M9.
[INFO DRT-0024]   Complete V9.
[INFO DRT-0024]   Complete Pad.
[INFO DRT-0033] Active shape region query size = 0.
[INFO DRT-0033] V0 shape region query size = 0.
[INFO DRT-0033] M1 shape region query size = 353408.
[INFO DRT-0033] V1 shape region query size = 633238.
[INFO DRT-0033] M2 shape region query size = 19998.
[INFO DRT-0033] V2 shape region query size = 11802.
[INFO DRT-0033] M3 shape region query size = 11802.
[INFO DRT-0033] V3 shape region query size = 7868.
[INFO DRT-0033] M4 shape region query size = 7956.
[INFO DRT-0033] V4 shape region query size = 7868.
[INFO DRT-0033] M5 shape region query size = 4530.
[INFO DRT-0033] V5 shape region query size = 784.
[INFO DRT-0033] M6 shape region query size = 448.
[INFO DRT-0033] V6 shape region query size = 0.
[INFO DRT-0033] M7 shape region query size = 0.
[INFO DRT-0033] V7 shape region query size = 0.
[INFO DRT-0033] M8 shape region query size = 0.
[INFO DRT-0033] V8 shape region query size = 0.
[INFO DRT-0033] M9 shape region query size = 0.
[INFO DRT-0033] V9 shape region query size = 0.
[INFO DRT-0033] Pad shape region query size = 0.
[INFO DRT-0165] Start pin access.
[INFO DRT-0076]   Complete 1000 pins.
[INFO DRT-0078]   Complete 1682 pins.
[INFO DRT-0079]   Complete 100 unique inst patterns.
[INFO DRT-0079]   Complete 200 unique inst patterns.
[INFO DRT-0081]   Complete 293 unique inst patterns.
[INFO DRT-0082]   Complete 10000 groups.
[INFO DRT-0084]   Complete 14639 groups.
#scanned instances     = 22183
#unique  instances     = 293
#stdCellGenAp          = 8300
#stdCellValidPlanarAp  = 66
#stdCellValidViaAp     = 6944
#stdCellPinNoAp        = 0
#stdCellPinCnt         = 70741
#instTermValidViaApCnt = 0
#macroGenAp            = 0
#macroValidPlanarAp    = 0
#macroValidViaAp       = 0
#macroNoAp             = 0
[INFO DRT-0166] Complete pin access.
[INFO DRT-0267] cpu time = 00:06:04, elapsed time = 00:00:12, memory = 467.60 (MB), peak = 467.60 (MB)
[INFO DRT-0156] guideIn read 100000 guides.

[INFO DRT-0157] Number of guides:     185698

[INFO DRT-0169] Post process guides.
[INFO DRT-0176] GCELLGRID X 0 DO 140 STEP 570 ;
[INFO DRT-0177] GCELLGRID Y 0 DO 140 STEP 570 ;
[INFO DRT-0026]   Complete 100000 origin guides.
[INFO DRT-0028]   Complete Active.
[INFO DRT-0028]   Complete V0.
[INFO DRT-0028]   Complete M1.
[INFO DRT-0028]   Complete V1.
[INFO DRT-0028]   Complete M2.
[INFO DRT-0028]   Complete V2.
[INFO DRT-0028]   Complete M3.
[INFO DRT-0028]   Complete V3.
[INFO DRT-0028]   Complete M4.
[INFO DRT-0028]   Complete V4.
[INFO DRT-0028]   Complete M5.
[INFO DRT-0028]   Complete V5.
[INFO DRT-0028]   Complete M6.
[INFO DRT-0028]   Complete V6.
[INFO DRT-0028]   Complete M7.
[INFO DRT-0028]   Complete V7.
[INFO DRT-0028]   Complete M8.
[INFO DRT-0028]   Complete V8.
[INFO DRT-0028]   Complete M9.
[INFO DRT-0028]   Complete V9.
[INFO DRT-0028]   Complete Pad.
[INFO DRT-0178] Init guide query.
[INFO DRT-0035]   Complete Active (guide).
[INFO DRT-0035]   Complete V0 (guide).
[INFO DRT-0035]   Complete M1 (guide).
[INFO DRT-0035]   Complete V1 (guide).
[INFO DRT-0035]   Complete M2 (guide).
[INFO DRT-0035]   Complete V2 (guide).
[INFO DRT-0035]   Complete M3 (guide).
[INFO DRT-0035]   Complete V3 (guide).
[INFO DRT-0035]   Complete M4 (guide).
[INFO DRT-0035]   Complete V4 (guide).
[INFO DRT-0035]   Complete M5 (guide).
[INFO DRT-0035]   Complete V5 (guide).
[INFO DRT-0035]   Complete M6 (guide).
[INFO DRT-0035]   Complete V6 (guide).
[INFO DRT-0035]   Complete M7 (guide).
[INFO DRT-0035]   Complete V7 (guide).
[INFO DRT-0035]   Complete M8 (guide).
[INFO DRT-0035]   Complete V8 (guide).
[INFO DRT-0035]   Complete M9 (guide).
[INFO DRT-0035]   Complete V9 (guide).
[INFO DRT-0035]   Complete Pad (guide).
[INFO DRT-0036] Active guide region query size = 0.
[INFO DRT-0036] V0 guide region query size = 0.
[INFO DRT-0036] M1 guide region query size = 59126.
[INFO DRT-0036] V1 guide region query size = 0.
[INFO DRT-0036] M2 guide region query size = 56745.
[INFO DRT-0036] V2 guide region query size = 0.
[INFO DRT-0036] M3 guide region query size = 30181.
[INFO DRT-0036] V3 guide region query size = 0.
[INFO DRT-0036] M4 guide region query size = 2358.
[INFO DRT-0036] V4 guide region query size = 0.
[INFO DRT-0036] M5 guide region query size = 686.
[INFO DRT-0036] V5 guide region query size = 0.
[INFO DRT-0036] M6 guide region query size = 5.
[INFO DRT-0036] V6 guide region query size = 0.
[INFO DRT-0036] M7 guide region query size = 0.
[INFO DRT-0036] V7 guide region query size = 0.
[INFO DRT-0036] M8 guide region query size = 0.
[INFO DRT-0036] V8 guide region query size = 0.
[INFO DRT-0036] M9 guide region query size = 0.
[INFO DRT-0036] V9 guide region query size = 0.
[INFO DRT-0036] Pad guide region query size = 0.
[INFO DRT-0179] Init gr pin query.
[INFO DRT-0267] cpu time = 00:00:01, elapsed time = 00:00:00, memory = 519.85 (MB), peak = 519.85 (MB)
[INFO DRT-0245] skipped writing guide updates to database.
[INFO DRT-0185] Post process initialize RPin region query.
[INFO DRT-0181] Start track assignment.
[INFO DRT-0184] Done with 89993 vertical wires in 3 frboxes and 59108 horizontal wires in 3 frboxes.
[INFO DRT-0186] Done with 10189 vertical wires in 3 frboxes and 15748 horizontal wires in 3 frboxes.
[INFO DRT-0182] Complete track assignment.
[INFO DRT-0267] cpu time = 00:00:06, elapsed time = 00:00:03, memory = 1046.68 (MB), peak = 1046.68 (MB)
[INFO DRT-0187] Start routing data preparation.
[INFO DRT-0267] cpu time = 00:00:00, elapsed time = 00:00:00, memory = 1046.68 (MB), peak = 1046.68 (MB)
[INFO DRT-0194] Start detail routing.
[INFO DRT-0195] Start 0th optimization iteration.
    Completing 10% with 0 violations.
    elapsed time = 00:00:15, memory = 6448.49 (MB).
time="2025-12-22T07:58:32-08:00" level=error msg="error waiting for container: unexpected EOF"
PS E:\ternary cmos compile\tritone-complete\OpenROAD-flow-scripts-master>   docker run --rm -w /OpenROAD-flow-scripts/flow openroad/orfs:latest cat results/asap7/ibex/base/6_final_metrics.json
cat: results/asap7/ibex/base/6_final_metrics.json: No such file or directory
PS E:\ternary cmos compile\tritone-complete\OpenROAD-flow-scripts-master>