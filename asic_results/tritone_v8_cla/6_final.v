module ternary_cpu_system (clk,
    halted,
    prog_mode,
    prog_we,
    rst_n,
    valid_out_a,
    valid_out_b,
    debug_reg_addr,
    debug_reg_data,
    ipc_out,
    pc_out,
    prog_addr,
    prog_data);
 input clk;
 output halted;
 input prog_mode;
 input prog_we;
 input rst_n;
 output valid_out_a;
 output valid_out_b;
 input [3:0] debug_reg_addr;
 output [53:0] debug_reg_data;
 output [1:0] ipc_out;
 output [15:0] pc_out;
 input [7:0] prog_addr;
 input [17:0] prog_data;

 wire _000_;
 wire _001_;
 wire _002_;
 wire _003_;
 wire _004_;
 wire _005_;
 wire _006_;
 wire _007_;
 wire _008_;
 wire _009_;
 wire _010_;
 wire _011_;
 wire _012_;
 wire _013_;
 wire _014_;
 wire _015_;
 wire _016_;
 wire _017_;
 wire _018_;
 wire _019_;
 wire _020_;
 wire _021_;
 wire _022_;
 wire _023_;
 wire _024_;
 wire _025_;
 wire _026_;
 wire _027_;
 wire _028_;
 wire _029_;
 wire _030_;
 wire _031_;
 wire _032_;
 wire _033_;
 wire _034_;
 wire _035_;
 wire _036_;
 wire _037_;
 wire _038_;
 wire _039_;
 wire _040_;
 wire _041_;
 wire _042_;
 wire _043_;
 wire _044_;
 wire _045_;
 wire _046_;
 wire _047_;
 wire _048_;
 wire _049_;
 wire _050_;
 wire _051_;
 wire _052_;
 wire _053_;
 wire _054_;
 wire _055_;
 wire _056_;
 wire _057_;
 wire _058_;
 wire _059_;
 wire _060_;
 wire _061_;
 wire _062_;
 wire _063_;
 wire _064_;
 wire _065_;
 wire _066_;
 wire _067_;
 wire _068_;
 wire _069_;
 wire _070_;
 wire _071_;
 wire _072_;
 wire _073_;
 wire _074_;
 wire _075_;
 wire _076_;
 wire _077_;
 wire _078_;
 wire _079_;
 wire _080_;
 wire _081_;
 wire _082_;
 wire _083_;
 wire _084_;
 wire _085_;
 wire _086_;
 wire _087_;
 wire _088_;
 wire _089_;
 wire _090_;
 wire _091_;
 wire _092_;
 wire _093_;
 wire _094_;
 wire _095_;
 wire _096_;
 wire _097_;
 wire _098_;
 wire _099_;
 wire _100_;
 wire _101_;
 wire _102_;
 wire _103_;
 wire _104_;
 wire _105_;
 wire _106_;
 wire _107_;
 wire _108_;
 wire _109_;
 wire _110_;
 wire _111_;
 wire _112_;
 wire _113_;
 wire _114_;
 wire _115_;
 wire _116_;
 wire _117_;
 wire _118_;
 wire _119_;
 wire _120_;
 wire _121_;
 wire _122_;
 wire _123_;
 wire _124_;
 wire _125_;
 wire _126_;
 wire _127_;
 wire _128_;
 wire _129_;
 wire _130_;
 wire _131_;
 wire _132_;
 wire _133_;
 wire _134_;
 wire _135_;
 wire _136_;
 wire _137_;
 wire _138_;
 wire _139_;
 wire _140_;
 wire _141_;
 wire _142_;
 wire _144_;
 wire _145_;
 wire _147_;
 wire _148_;
 wire _149_;
 wire _151_;
 wire _152_;
 wire _153_;
 wire _154_;
 wire _155_;
 wire _156_;
 wire _157_;
 wire _158_;
 wire _159_;
 wire _160_;
 wire _161_;
 wire _162_;
 wire _163_;
 wire _164_;
 wire _165_;
 wire _166_;
 wire _167_;
 wire _168_;
 wire _169_;
 wire _170_;
 wire _171_;
 wire _172_;
 wire _173_;
 wire _174_;
 wire _175_;
 wire _176_;
 wire _177_;
 wire _178_;
 wire _179_;
 wire _180_;
 wire _181_;
 wire _182_;
 wire _183_;
 wire _184_;
 wire _185_;
 wire _186_;
 wire _187_;
 wire _188_;
 wire _189_;
 wire _190_;
 wire _191_;
 wire _192_;
 wire _193_;
 wire _194_;
 wire _195_;
 wire _196_;
 wire _197_;
 wire _198_;
 wire _199_;
 wire _200_;
 wire _201_;
 wire _202_;
 wire _203_;
 wire _204_;
 wire _205_;
 wire _206_;
 wire _207_;
 wire _208_;
 wire _209_;
 wire _210_;
 wire _211_;
 wire _212_;
 wire _213_;
 wire _214_;
 wire _215_;
 wire _216_;
 wire _217_;
 wire _218_;
 wire _219_;
 wire _220_;
 wire _221_;
 wire _222_;
 wire _223_;
 wire _224_;
 wire _225_;
 wire _226_;
 wire _227_;
 wire _228_;
 wire _229_;
 wire _230_;
 wire _231_;
 wire _232_;
 wire _233_;
 wire _234_;
 wire _235_;
 wire _236_;
 wire net68;
 wire net76;
 wire net77;
 wire net78;
 wire net79;
 wire net80;
 wire net81;
 wire net82;
 wire net83;
 wire net84;
 wire net85;
 wire net86;
 wire net87;
 wire net88;
 wire net89;
 wire net90;
 wire net91;
 wire net92;
 wire \u_cpu.ex_wb_reg_write_a ;
 wire net75;
 wire \u_cpu.next_pc[0] ;
 wire \u_cpu.next_pc[10] ;
 wire \u_cpu.next_pc[11] ;
 wire \u_cpu.next_pc[12] ;
 wire \u_cpu.next_pc[13] ;
 wire \u_cpu.next_pc[14] ;
 wire \u_cpu.next_pc[15] ;
 wire \u_cpu.next_pc[1] ;
 wire \u_cpu.next_pc[2] ;
 wire \u_cpu.next_pc[3] ;
 wire \u_cpu.next_pc[4] ;
 wire \u_cpu.next_pc[5] ;
 wire \u_cpu.next_pc[6] ;
 wire \u_cpu.next_pc[7] ;
 wire \u_cpu.next_pc[8] ;
 wire \u_cpu.next_pc[9] ;
 wire net93;
 wire clknet_0_clk;
 wire net;
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net9;
 wire net10;
 wire net11;
 wire clknet_1_1__leaf_clk;
 wire clknet_1_0__leaf_clk;
 wire net98;
 wire net97;
 wire net96;
 wire net69;
 wire net70;
 wire net71;
 wire net72;
 wire net73;
 wire net74;

 sky130_fd_sc_hd__nand3_1 _239_ (.A(_002_),
    .B(_055_),
    .C(_057_),
    .Y(_133_));
 sky130_fd_sc_hd__inv_1 _240_ (.A(_133_),
    .Y(_006_));
 sky130_fd_sc_hd__inv_1 _241_ (.A(_059_),
    .Y(_067_));
 sky130_fd_sc_hd__inv_1 _242_ (.A(_060_),
    .Y(_000_));
 sky130_fd_sc_hd__nand2_1 _243_ (.A(_064_),
    .B(_065_),
    .Y(_011_));
 sky130_fd_sc_hd__nand3b_1 _244_ (.A_N(_001_),
    .B(_058_),
    .C(_054_),
    .Y(_134_));
 sky130_fd_sc_hd__nand3_1 _245_ (.A(_067_),
    .B(_062_),
    .C(_134_),
    .Y(_016_));
 sky130_fd_sc_hd__inv_1 _246_ (.A(_014_),
    .Y(_012_));
 sky130_fd_sc_hd__inv_1 _247_ (.A(_019_),
    .Y(_017_));
 sky130_fd_sc_hd__inv_1 _248_ (.A(_021_),
    .Y(_023_));
 sky130_fd_sc_hd__inv_1 _249_ (.A(_025_),
    .Y(_027_));
 sky130_fd_sc_hd__inv_1 _250_ (.A(_037_),
    .Y(_039_));
 sky130_fd_sc_hd__inv_1 _251_ (.A(_041_),
    .Y(_043_));
 sky130_fd_sc_hd__inv_1 _252_ (.A(net77),
    .Y(_053_));
 sky130_fd_sc_hd__inv_1 _253_ (.A(_001_),
    .Y(_005_));
 sky130_fd_sc_hd__inv_1 _254_ (.A(net85),
    .Y(_063_));
 sky130_fd_sc_hd__inv_1 _255_ (.A(net89),
    .Y(_073_));
 sky130_fd_sc_hd__nand2_1 _256_ (.A(_074_),
    .B(_075_),
    .Y(_135_));
 sky130_fd_sc_hd__inv_1 _257_ (.A(_135_),
    .Y(_070_));
 sky130_fd_sc_hd__nand3_1 _258_ (.A(_057_),
    .B(net96),
    .C(_135_),
    .Y(_078_));
 sky130_fd_sc_hd__inv_1 _259_ (.A(net91),
    .Y(_084_));
 sky130_fd_sc_hd__nand2_1 _260_ (.A(_067_),
    .B(_134_),
    .Y(_136_));
 sky130_fd_sc_hd__nand2_1 _261_ (.A(_136_),
    .B(_135_),
    .Y(_087_));
 sky130_fd_sc_hd__and2_2 _262_ (.A(_085_),
    .B(_086_),
    .X(_081_));
 sky130_fd_sc_hd__a22oi_4 _263_ (.A1(_085_),
    .A2(_086_),
    .B1(_075_),
    .B2(_074_),
    .Y(_137_));
 sky130_fd_sc_hd__and3_4 _264_ (.A(_057_),
    .B(_011_),
    .C(_137_),
    .X(_138_));
 sky130_fd_sc_hd__inv_1 _265_ (.A(_138_),
    .Y(_092_));
 sky130_fd_sc_hd__inv_1 _266_ (.A(net78),
    .Y(_098_));
 sky130_fd_sc_hd__nand2_1 _267_ (.A(_136_),
    .B(_137_),
    .Y(_101_));
 sky130_fd_sc_hd__nand2_1 _268_ (.A(_099_),
    .B(_100_),
    .Y(_139_));
 sky130_fd_sc_hd__inv_1 _269_ (.A(_139_),
    .Y(_095_));
 sky130_fd_sc_hd__nand2_1 _270_ (.A(_138_),
    .B(_139_),
    .Y(_106_));
 sky130_fd_sc_hd__inv_1 _271_ (.A(net80),
    .Y(_112_));
 sky130_fd_sc_hd__nand3_1 _272_ (.A(_136_),
    .B(_137_),
    .C(_139_),
    .Y(_115_));
 sky130_fd_sc_hd__nand2_1 _273_ (.A(_113_),
    .B(_114_),
    .Y(_140_));
 sky130_fd_sc_hd__inv_1 _274_ (.A(_140_),
    .Y(_109_));
 sky130_fd_sc_hd__inv_1 _275_ (.A(net82),
    .Y(_120_));
 sky130_fd_sc_hd__nand3_2 _276_ (.A(_138_),
    .B(_139_),
    .C(_140_),
    .Y(_122_));
 sky130_fd_sc_hd__inv_1 _277_ (.A(_121_),
    .Y(_125_));
 sky130_fd_sc_hd__nand4_1 _278_ (.A(_136_),
    .B(_137_),
    .C(_139_),
    .D(_140_),
    .Y(_128_));
 sky130_fd_sc_hd__inv_1 _279_ (.A(net84),
    .Y(_056_));
 sky130_fd_sc_hd__inv_1 _280_ (.A(net86),
    .Y(_066_));
 sky130_fd_sc_hd__nand3_1 _281_ (.A(_005_),
    .B(_067_),
    .C(_054_),
    .Y(_141_));
 sky130_fd_sc_hd__o21ai_0 _282_ (.A1(_067_),
    .A2(net96),
    .B1(_141_),
    .Y(_068_));
 sky130_fd_sc_hd__nand2b_1 _283_ (.A_N(_057_),
    .B(net96),
    .Y(_071_));
 sky130_fd_sc_hd__or2_2 _284_ (.A(_062_),
    .B(_136_),
    .X(_076_));
 sky130_fd_sc_hd__nand2_1 _285_ (.A(net96),
    .B(_135_),
    .Y(_079_));
 sky130_fd_sc_hd__inv_1 _286_ (.A(_080_),
    .Y(_082_));
 sky130_fd_sc_hd__nand2_1 _287_ (.A(_016_),
    .B(_135_),
    .Y(_088_));
 sky130_fd_sc_hd__inv_1 _288_ (.A(_089_),
    .Y(_090_));
 sky130_fd_sc_hd__nand2_1 _289_ (.A(net96),
    .B(_137_),
    .Y(_093_));
 sky130_fd_sc_hd__inv_1 _290_ (.A(_094_),
    .Y(_096_));
 sky130_fd_sc_hd__nand2_1 _291_ (.A(_016_),
    .B(_137_),
    .Y(_102_));
 sky130_fd_sc_hd__inv_1 _292_ (.A(_103_),
    .Y(_104_));
 sky130_fd_sc_hd__nand3_1 _293_ (.A(_064_),
    .B(_065_),
    .C(_139_),
    .Y(_142_));
 sky130_fd_sc_hd__nand2_1 _294_ (.A(_137_),
    .B(_142_),
    .Y(_107_));
 sky130_fd_sc_hd__inv_1 _295_ (.A(_108_),
    .Y(_110_));
 sky130_fd_sc_hd__o21ai_0 _296_ (.A1(_016_),
    .A2(_095_),
    .B1(_137_),
    .Y(_116_));
 sky130_fd_sc_hd__inv_1 _297_ (.A(_117_),
    .Y(_118_));
 sky130_fd_sc_hd__nand3_1 _298_ (.A(_137_),
    .B(_140_),
    .C(_142_),
    .Y(_123_));
 sky130_fd_sc_hd__inv_1 _299_ (.A(_124_),
    .Y(_126_));
 sky130_fd_sc_hd__o211ai_1 _300_ (.A1(_016_),
    .A2(_095_),
    .B1(_140_),
    .C1(_137_),
    .Y(_129_));
 sky130_fd_sc_hd__inv_1 _301_ (.A(_130_),
    .Y(_131_));
 sky130_fd_sc_hd__inv_1 _302_ (.A(_032_),
    .Y(_029_));
 sky130_fd_sc_hd__inv_1 _303_ (.A(_036_),
    .Y(_033_));
 sky130_fd_sc_hd__inv_1 _304_ (.A(_048_),
    .Y(_045_));
 sky130_fd_sc_hd__inv_1 _305_ (.A(_052_),
    .Y(_049_));
 sky130_fd_sc_hd__mux2_2 _307_ (.A0(_055_),
    .A1(_002_),
    .S(net76),
    .X(\u_cpu.next_pc[0] ));
 sky130_fd_sc_hd__inv_1 _308_ (.A(_035_),
    .Y(_144_));
 sky130_fd_sc_hd__and3_1 _309_ (.A(_105_),
    .B(_034_),
    .C(_144_),
    .X(_145_));
 sky130_fd_sc_hd__o21ai_0 _311_ (.A1(_105_),
    .A2(_034_),
    .B1(net97),
    .Y(_147_));
 sky130_fd_sc_hd__nand3b_1 _312_ (.A_N(_031_),
    .B(_030_),
    .C(_097_),
    .Y(_148_));
 sky130_fd_sc_hd__o21ai_0 _313_ (.A1(_097_),
    .A2(_030_),
    .B1(_148_),
    .Y(_149_));
 sky130_fd_sc_hd__o22ai_1 _315_ (.A1(_145_),
    .A2(_147_),
    .B1(_149_),
    .B2(net97),
    .Y(\u_cpu.next_pc[10] ));
 sky130_fd_sc_hd__nor3b_1 _316_ (.A(_097_),
    .B(_031_),
    .C_N(_030_),
    .Y(_151_));
 sky130_fd_sc_hd__nor2b_1 _317_ (.A(_030_),
    .B_N(_031_),
    .Y(_152_));
 sky130_fd_sc_hd__nor3b_1 _318_ (.A(_105_),
    .B(_035_),
    .C_N(_034_),
    .Y(_153_));
 sky130_fd_sc_hd__o21ai_0 _319_ (.A1(_034_),
    .A2(_144_),
    .B1(net97),
    .Y(_154_));
 sky130_fd_sc_hd__o32ai_1 _320_ (.A1(net97),
    .A2(_151_),
    .A3(_152_),
    .B1(_153_),
    .B2(_154_),
    .Y(\u_cpu.next_pc[11] ));
 sky130_fd_sc_hd__nand3_1 _321_ (.A(_111_),
    .B(_040_),
    .C(_038_),
    .Y(_155_));
 sky130_fd_sc_hd__o21ai_0 _322_ (.A1(_111_),
    .A2(_040_),
    .B1(_155_),
    .Y(_156_));
 sky130_fd_sc_hd__nand3_1 _323_ (.A(_119_),
    .B(_044_),
    .C(_042_),
    .Y(_157_));
 sky130_fd_sc_hd__o211ai_1 _324_ (.A1(_119_),
    .A2(_044_),
    .B1(net97),
    .C1(_157_),
    .Y(_158_));
 sky130_fd_sc_hd__o21ai_0 _325_ (.A1(net97),
    .A2(_156_),
    .B1(_158_),
    .Y(\u_cpu.next_pc[12] ));
 sky130_fd_sc_hd__nand2_1 _326_ (.A(_044_),
    .B(_042_),
    .Y(_159_));
 sky130_fd_sc_hd__nor2_1 _327_ (.A(_119_),
    .B(_159_),
    .Y(_160_));
 sky130_fd_sc_hd__o21ai_0 _328_ (.A1(_044_),
    .A2(_042_),
    .B1(net97),
    .Y(_161_));
 sky130_fd_sc_hd__nand3b_1 _329_ (.A_N(_111_),
    .B(_040_),
    .C(_038_),
    .Y(_162_));
 sky130_fd_sc_hd__o21ai_0 _330_ (.A1(_040_),
    .A2(_038_),
    .B1(_162_),
    .Y(_163_));
 sky130_fd_sc_hd__o22ai_1 _331_ (.A1(_160_),
    .A2(_161_),
    .B1(_163_),
    .B2(net97),
    .Y(\u_cpu.next_pc[13] ));
 sky130_fd_sc_hd__inv_1 _332_ (.A(_051_),
    .Y(_164_));
 sky130_fd_sc_hd__and3_1 _333_ (.A(_132_),
    .B(_050_),
    .C(_164_),
    .X(_165_));
 sky130_fd_sc_hd__o21ai_0 _334_ (.A1(_132_),
    .A2(_050_),
    .B1(net97),
    .Y(_166_));
 sky130_fd_sc_hd__nand3b_1 _335_ (.A_N(_047_),
    .B(_046_),
    .C(_127_),
    .Y(_167_));
 sky130_fd_sc_hd__o21ai_0 _336_ (.A1(_127_),
    .A2(_046_),
    .B1(_167_),
    .Y(_168_));
 sky130_fd_sc_hd__o22ai_1 _337_ (.A1(_165_),
    .A2(_166_),
    .B1(_168_),
    .B2(net97),
    .Y(\u_cpu.next_pc[14] ));
 sky130_fd_sc_hd__nor3b_1 _338_ (.A(_127_),
    .B(_047_),
    .C_N(_046_),
    .Y(_169_));
 sky130_fd_sc_hd__nor2b_1 _339_ (.A(_046_),
    .B_N(_047_),
    .Y(_170_));
 sky130_fd_sc_hd__nor3b_1 _340_ (.A(_132_),
    .B(_051_),
    .C_N(_050_),
    .Y(_171_));
 sky130_fd_sc_hd__o21ai_0 _341_ (.A1(_050_),
    .A2(_164_),
    .B1(net97),
    .Y(_172_));
 sky130_fd_sc_hd__o32ai_1 _342_ (.A1(net97),
    .A2(_169_),
    .A3(_170_),
    .B1(_171_),
    .B2(_172_),
    .Y(\u_cpu.next_pc[15] ));
 sky130_fd_sc_hd__nand2b_1 _343_ (.A_N(net76),
    .B(_058_),
    .Y(_173_));
 sky130_fd_sc_hd__nand2_1 _344_ (.A(_055_),
    .B(net76),
    .Y(_174_));
 sky130_fd_sc_hd__nand2_1 _345_ (.A(_173_),
    .B(_174_),
    .Y(\u_cpu.next_pc[1] ));
 sky130_fd_sc_hd__o21ai_0 _346_ (.A1(_003_),
    .A2(_061_),
    .B1(net76),
    .Y(_175_));
 sky130_fd_sc_hd__inv_1 _347_ (.A(_004_),
    .Y(_176_));
 sky130_fd_sc_hd__and3_1 _348_ (.A(_176_),
    .B(_003_),
    .C(_061_),
    .X(_177_));
 sky130_fd_sc_hd__o21ai_0 _349_ (.A1(_175_),
    .A2(_177_),
    .B1(_173_),
    .Y(\u_cpu.next_pc[2] ));
 sky130_fd_sc_hd__nor3b_1 _350_ (.A(_004_),
    .B(_061_),
    .C_N(_003_),
    .Y(_178_));
 sky130_fd_sc_hd__o21ai_0 _351_ (.A1(_176_),
    .A2(_003_),
    .B1(net76),
    .Y(_179_));
 sky130_fd_sc_hd__o22ai_1 _352_ (.A1(net76),
    .A2(_133_),
    .B1(_178_),
    .B2(_179_),
    .Y(\u_cpu.next_pc[3] ));
 sky130_fd_sc_hd__nor3b_1 _353_ (.A(_069_),
    .B(_010_),
    .C_N(_009_),
    .Y(_180_));
 sky130_fd_sc_hd__inv_1 _354_ (.A(_069_),
    .Y(_181_));
 sky130_fd_sc_hd__o21ai_0 _355_ (.A1(_181_),
    .A2(_009_),
    .B1(net76),
    .Y(_182_));
 sky130_fd_sc_hd__nand3b_1 _356_ (.A_N(_008_),
    .B(_007_),
    .C(_057_),
    .Y(_183_));
 sky130_fd_sc_hd__o21ai_0 _357_ (.A1(_007_),
    .A2(_057_),
    .B1(_183_),
    .Y(_184_));
 sky130_fd_sc_hd__o22ai_1 _358_ (.A1(_180_),
    .A2(_182_),
    .B1(_184_),
    .B2(net76),
    .Y(\u_cpu.next_pc[4] ));
 sky130_fd_sc_hd__nand2b_1 _359_ (.A_N(_057_),
    .B(_007_),
    .Y(_185_));
 sky130_fd_sc_hd__mux2i_1 _360_ (.A0(_185_),
    .A1(_007_),
    .S(_008_),
    .Y(_186_));
 sky130_fd_sc_hd__nand3b_1 _361_ (.A_N(_010_),
    .B(_009_),
    .C(_069_),
    .Y(_187_));
 sky130_fd_sc_hd__nand2b_1 _362_ (.A_N(_009_),
    .B(_010_),
    .Y(_188_));
 sky130_fd_sc_hd__nand3_1 _363_ (.A(net76),
    .B(_187_),
    .C(_188_),
    .Y(_189_));
 sky130_fd_sc_hd__o21ai_0 _364_ (.A1(net76),
    .A2(_186_),
    .B1(_189_),
    .Y(\u_cpu.next_pc[5] ));
 sky130_fd_sc_hd__nor3b_1 _365_ (.A(_018_),
    .B(_020_),
    .C_N(_077_),
    .Y(_190_));
 sky130_fd_sc_hd__inv_1 _366_ (.A(_020_),
    .Y(_191_));
 sky130_fd_sc_hd__o21ai_0 _367_ (.A1(_077_),
    .A2(_191_),
    .B1(net76),
    .Y(_192_));
 sky130_fd_sc_hd__nand2b_1 _368_ (.A_N(_013_),
    .B(_072_),
    .Y(_193_));
 sky130_fd_sc_hd__mux2i_1 _369_ (.A0(_193_),
    .A1(_072_),
    .S(_015_),
    .Y(_194_));
 sky130_fd_sc_hd__o22ai_1 _370_ (.A1(_190_),
    .A2(_192_),
    .B1(_194_),
    .B2(net76),
    .Y(\u_cpu.next_pc[6] ));
 sky130_fd_sc_hd__nor3_1 _371_ (.A(_018_),
    .B(_077_),
    .C(_020_),
    .Y(_195_));
 sky130_fd_sc_hd__nand2_1 _372_ (.A(_018_),
    .B(_020_),
    .Y(_196_));
 sky130_fd_sc_hd__nand2_1 _373_ (.A(net76),
    .B(_196_),
    .Y(_197_));
 sky130_fd_sc_hd__a21oi_1 _374_ (.A1(_013_),
    .A2(_015_),
    .B1(net76),
    .Y(_198_));
 sky130_fd_sc_hd__o31ai_1 _375_ (.A1(_013_),
    .A2(_072_),
    .A3(_015_),
    .B1(_198_),
    .Y(_199_));
 sky130_fd_sc_hd__o21ai_0 _376_ (.A1(_195_),
    .A2(_197_),
    .B1(_199_),
    .Y(\u_cpu.next_pc[7] ));
 sky130_fd_sc_hd__nand3_1 _377_ (.A(_083_),
    .B(_024_),
    .C(_022_),
    .Y(_200_));
 sky130_fd_sc_hd__o21ai_0 _378_ (.A1(_083_),
    .A2(_024_),
    .B1(_200_),
    .Y(_201_));
 sky130_fd_sc_hd__nand3_1 _379_ (.A(_091_),
    .B(_028_),
    .C(_026_),
    .Y(_202_));
 sky130_fd_sc_hd__o211ai_1 _380_ (.A1(_091_),
    .A2(_028_),
    .B1(net97),
    .C1(_202_),
    .Y(_203_));
 sky130_fd_sc_hd__o21ai_0 _381_ (.A1(net97),
    .A2(_201_),
    .B1(_203_),
    .Y(\u_cpu.next_pc[8] ));
 sky130_fd_sc_hd__nand2_1 _382_ (.A(_028_),
    .B(_026_),
    .Y(_204_));
 sky130_fd_sc_hd__nor2_1 _383_ (.A(_091_),
    .B(_204_),
    .Y(_205_));
 sky130_fd_sc_hd__o21ai_0 _384_ (.A1(_028_),
    .A2(_026_),
    .B1(net97),
    .Y(_206_));
 sky130_fd_sc_hd__nand3b_1 _385_ (.A_N(_083_),
    .B(_024_),
    .C(_022_),
    .Y(_207_));
 sky130_fd_sc_hd__o21ai_0 _386_ (.A1(_024_),
    .A2(_022_),
    .B1(_207_),
    .Y(_208_));
 sky130_fd_sc_hd__o22ai_1 _387_ (.A1(_205_),
    .A2(_206_),
    .B1(_208_),
    .B2(net97),
    .Y(\u_cpu.next_pc[9] ));
 sky130_fd_sc_hd__fa_1 _388_ (.A(_000_),
    .B(_001_),
    .CIN(_002_),
    .COUT(_003_),
    .SUM(_004_));
 sky130_fd_sc_hd__fa_1 _389_ (.A(net),
    .B(net68),
    .CIN(_006_),
    .COUT(_007_),
    .SUM(_008_));
 sky130_fd_sc_hd__fa_1 _390_ (.A(net1),
    .B(_209_),
    .CIN(net69),
    .COUT(_009_),
    .SUM(_010_));
 sky130_fd_sc_hd__fa_1 _391_ (.A(net70),
    .B(net96),
    .CIN(_012_),
    .COUT(_210_),
    .SUM(_013_));
 sky130_fd_sc_hd__fa_1 _392_ (.A(net71),
    .B(net96),
    .CIN(_014_),
    .COUT(_015_),
    .SUM(_211_));
 sky130_fd_sc_hd__fa_1 _393_ (.A(net72),
    .B(_016_),
    .CIN(_017_),
    .COUT(_212_),
    .SUM(_018_));
 sky130_fd_sc_hd__fa_1 _394_ (.A(net73),
    .B(_016_),
    .CIN(_019_),
    .COUT(_020_),
    .SUM(_213_));
 sky130_fd_sc_hd__fa_1 _395_ (.A(net2),
    .B(_214_),
    .CIN(_021_),
    .COUT(_215_),
    .SUM(_022_));
 sky130_fd_sc_hd__fa_1 _396_ (.A(net3),
    .B(_214_),
    .CIN(_023_),
    .COUT(_024_),
    .SUM(_216_));
 sky130_fd_sc_hd__fa_1 _397_ (.A(net4),
    .B(_217_),
    .CIN(_025_),
    .COUT(_218_),
    .SUM(_026_));
 sky130_fd_sc_hd__fa_1 _398_ (.A(net5),
    .B(_217_),
    .CIN(_027_),
    .COUT(_028_),
    .SUM(_219_));
 sky130_fd_sc_hd__fa_1 _399_ (.A(net6),
    .B(_220_),
    .CIN(_029_),
    .COUT(_030_),
    .SUM(_031_));
 sky130_fd_sc_hd__fa_1 _400_ (.A(net7),
    .B(_221_),
    .CIN(_033_),
    .COUT(_034_),
    .SUM(_035_));
 sky130_fd_sc_hd__fa_1 _401_ (.A(net8),
    .B(_222_),
    .CIN(_037_),
    .COUT(_223_),
    .SUM(_038_));
 sky130_fd_sc_hd__fa_1 _402_ (.A(net9),
    .B(_222_),
    .CIN(_039_),
    .COUT(_040_),
    .SUM(_224_));
 sky130_fd_sc_hd__fa_1 _403_ (.A(net10),
    .B(_225_),
    .CIN(_041_),
    .COUT(_226_),
    .SUM(_042_));
 sky130_fd_sc_hd__fa_1 _404_ (.A(net11),
    .B(_225_),
    .CIN(_043_),
    .COUT(_044_),
    .SUM(_227_));
 sky130_fd_sc_hd__fa_1 _405_ (.A(_228_),
    .B(_229_),
    .CIN(_045_),
    .COUT(_046_),
    .SUM(_047_));
 sky130_fd_sc_hd__fa_1 _406_ (.A(_228_),
    .B(_230_),
    .CIN(_049_),
    .COUT(_050_),
    .SUM(_051_));
 sky130_fd_sc_hd__ha_1 _407_ (.A(_053_),
    .B(net84),
    .COUT(_054_),
    .SUM(_055_));
 sky130_fd_sc_hd__ha_1 _408_ (.A(_053_),
    .B(net84),
    .COUT(_002_),
    .SUM(_231_));
 sky130_fd_sc_hd__ha_1 _409_ (.A(net77),
    .B(_056_),
    .COUT(_057_),
    .SUM(_232_));
 sky130_fd_sc_hd__ha_1 _410_ (.A(net77),
    .B(_056_),
    .COUT(_058_),
    .SUM(_233_));
 sky130_fd_sc_hd__ha_1 _411_ (.A(_059_),
    .B(_054_),
    .COUT(_060_),
    .SUM(_061_));
 sky130_fd_sc_hd__ha_1 _412_ (.A(_005_),
    .B(_002_),
    .COUT(_062_),
    .SUM(_234_));
 sky130_fd_sc_hd__ha_1 _413_ (.A(_063_),
    .B(net86),
    .COUT(_064_),
    .SUM(_065_));
 sky130_fd_sc_hd__ha_1 _414_ (.A(net85),
    .B(_066_),
    .COUT(_059_),
    .SUM(_235_));
 sky130_fd_sc_hd__ha_1 _415_ (.A(net85),
    .B(_066_),
    .COUT(_001_),
    .SUM(_236_));
 sky130_fd_sc_hd__ha_1 _416_ (.A(_067_),
    .B(_068_),
    .COUT(_209_),
    .SUM(_069_));
 sky130_fd_sc_hd__ha_1 _417_ (.A(_070_),
    .B(_071_),
    .COUT(_014_),
    .SUM(_072_));
 sky130_fd_sc_hd__ha_1 _418_ (.A(_073_),
    .B(net90),
    .COUT(_074_),
    .SUM(_075_));
 sky130_fd_sc_hd__ha_1 _419_ (.A(_070_),
    .B(_076_),
    .COUT(_019_),
    .SUM(_077_));
 sky130_fd_sc_hd__ha_1 _420_ (.A(_078_),
    .B(_079_),
    .COUT(_214_),
    .SUM(_080_));
 sky130_fd_sc_hd__ha_1 _421_ (.A(_081_),
    .B(_082_),
    .COUT(_021_),
    .SUM(_083_));
 sky130_fd_sc_hd__ha_1 _422_ (.A(_084_),
    .B(net92),
    .COUT(_085_),
    .SUM(_086_));
 sky130_fd_sc_hd__ha_1 _423_ (.A(_087_),
    .B(_088_),
    .COUT(_217_),
    .SUM(_089_));
 sky130_fd_sc_hd__ha_1 _424_ (.A(_081_),
    .B(_090_),
    .COUT(_025_),
    .SUM(_091_));
 sky130_fd_sc_hd__ha_1 _425_ (.A(_092_),
    .B(_093_),
    .COUT(_220_),
    .SUM(_094_));
 sky130_fd_sc_hd__ha_1 _426_ (.A(_095_),
    .B(_096_),
    .COUT(_032_),
    .SUM(_097_));
 sky130_fd_sc_hd__ha_1 _427_ (.A(_098_),
    .B(net79),
    .COUT(_099_),
    .SUM(_100_));
 sky130_fd_sc_hd__ha_1 _428_ (.A(_101_),
    .B(_102_),
    .COUT(_221_),
    .SUM(_103_));
 sky130_fd_sc_hd__ha_1 _429_ (.A(_095_),
    .B(_104_),
    .COUT(_036_),
    .SUM(_105_));
 sky130_fd_sc_hd__ha_1 _430_ (.A(_106_),
    .B(_107_),
    .COUT(_222_),
    .SUM(_108_));
 sky130_fd_sc_hd__ha_1 _431_ (.A(_109_),
    .B(_110_),
    .COUT(_037_),
    .SUM(_111_));
 sky130_fd_sc_hd__ha_1 _432_ (.A(_112_),
    .B(net81),
    .COUT(_113_),
    .SUM(_114_));
 sky130_fd_sc_hd__ha_1 _433_ (.A(_115_),
    .B(_116_),
    .COUT(_225_),
    .SUM(_117_));
 sky130_fd_sc_hd__ha_1 _434_ (.A(_109_),
    .B(_118_),
    .COUT(_041_),
    .SUM(_119_));
 sky130_fd_sc_hd__ha_1 _435_ (.A(_120_),
    .B(net83),
    .COUT(_228_),
    .SUM(_121_));
 sky130_fd_sc_hd__ha_1 _436_ (.A(_122_),
    .B(_123_),
    .COUT(_229_),
    .SUM(_124_));
 sky130_fd_sc_hd__ha_1 _437_ (.A(_125_),
    .B(_126_),
    .COUT(_048_),
    .SUM(_127_));
 sky130_fd_sc_hd__ha_1 _438_ (.A(_128_),
    .B(_129_),
    .COUT(_230_),
    .SUM(_130_));
 sky130_fd_sc_hd__ha_1 _439_ (.A(_125_),
    .B(_131_),
    .COUT(_052_),
    .SUM(_132_));
 sky130_fd_sc_hd__conb_1 _389__69 (.HI(net68));
 sky130_fd_sc_hd__clkbuf_1 clkload0 (.A(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_8 clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .X(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_8 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .X(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__buf_4 place99 (.A(net75),
    .X(net98));
 sky130_fd_sc_hd__buf_4 place98 (.A(net76),
    .X(net97));
 sky130_fd_sc_hd__buf_4 place97 (.A(_011_),
    .X(net96));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output95 (.A(net93),
    .X(valid_out_b));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output94 (.A(net93),
    .X(valid_out_a));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output93 (.A(net92),
    .X(pc_out[9]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output92 (.A(net91),
    .X(pc_out[8]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output91 (.A(net90),
    .X(pc_out[7]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output90 (.A(net89),
    .X(pc_out[6]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output89 (.A(net88),
    .X(pc_out[5]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output88 (.A(net87),
    .X(pc_out[4]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output87 (.A(net86),
    .X(pc_out[3]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output86 (.A(net85),
    .X(pc_out[2]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output85 (.A(net84),
    .X(pc_out[1]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output84 (.A(net83),
    .X(pc_out[15]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output83 (.A(net82),
    .X(pc_out[14]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output82 (.A(net81),
    .X(pc_out[13]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output81 (.A(net80),
    .X(pc_out[12]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output80 (.A(net79),
    .X(pc_out[11]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output79 (.A(net78),
    .X(pc_out[10]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output78 (.A(net77),
    .X(pc_out[0]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 output77 (.A(net97),
    .X(ipc_out[1]));
 sky130_fd_sc_hd__clkdlybuf4s50_1 input76 (.A(rst_n),
    .X(net75));
 sky130_fd_sc_hd__clkbuf_8 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.id_ex_reg_write_a$_DFF_PN0_  (.D(net74),
    .Q(net76),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.id_ex_valid_a$_DFF_PN0_  (.D(net97),
    .Q(\u_cpu.ex_wb_reg_write_a ),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[0]$_DFF_PN0_  (.D(\u_cpu.next_pc[0] ),
    .Q(net77),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[10]$_DFF_PN0_  (.D(\u_cpu.next_pc[10] ),
    .Q(net78),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[11]$_DFF_PN0_  (.D(\u_cpu.next_pc[11] ),
    .Q(net79),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[12]$_DFF_PN0_  (.D(\u_cpu.next_pc[12] ),
    .Q(net80),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[13]$_DFF_PN0_  (.D(\u_cpu.next_pc[13] ),
    .Q(net81),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[14]$_DFF_PN0_  (.D(\u_cpu.next_pc[14] ),
    .Q(net82),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[15]$_DFF_PN0_  (.D(\u_cpu.next_pc[15] ),
    .Q(net83),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[1]$_DFF_PN0_  (.D(\u_cpu.next_pc[1] ),
    .Q(net84),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[2]$_DFF_PN0_  (.D(\u_cpu.next_pc[2] ),
    .Q(net85),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[3]$_DFF_PN0_  (.D(\u_cpu.next_pc[3] ),
    .Q(net86),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[4]$_DFF_PN0_  (.D(\u_cpu.next_pc[4] ),
    .Q(net87),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[5]$_DFF_PN0_  (.D(\u_cpu.next_pc[5] ),
    .Q(net88),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[6]$_DFF_PN0_  (.D(\u_cpu.next_pc[6] ),
    .Q(net89),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[7]$_DFF_PN0_  (.D(\u_cpu.next_pc[7] ),
    .Q(net90),
    .RESET_B(net98),
    .CLK(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[8]$_DFF_PN0_  (.D(\u_cpu.next_pc[8] ),
    .Q(net91),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.imem_addr[9]$_DFF_PN0_  (.D(\u_cpu.next_pc[9] ),
    .Q(net92),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__dfrtp_1 \u_cpu.valid_out_a$_DFF_PN0_  (.D(\u_cpu.ex_wb_reg_write_a ),
    .Q(net93),
    .RESET_B(net98),
    .CLK(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__conb_1 _389__1 (.LO(net));
 sky130_fd_sc_hd__conb_1 _390__2 (.LO(net1));
 sky130_fd_sc_hd__conb_1 _395__3 (.LO(net2));
 sky130_fd_sc_hd__conb_1 _396__4 (.LO(net3));
 sky130_fd_sc_hd__conb_1 _397__5 (.LO(net4));
 sky130_fd_sc_hd__conb_1 _398__6 (.LO(net5));
 sky130_fd_sc_hd__conb_1 _399__7 (.LO(net6));
 sky130_fd_sc_hd__conb_1 _400__8 (.LO(net7));
 sky130_fd_sc_hd__conb_1 _401__9 (.LO(net8));
 sky130_fd_sc_hd__conb_1 _402__10 (.LO(net9));
 sky130_fd_sc_hd__conb_1 _403__11 (.LO(net10));
 sky130_fd_sc_hd__conb_1 _404__12 (.LO(net11));
 sky130_fd_sc_hd__conb_1 _442__13 (.LO(debug_reg_data[0]));
 sky130_fd_sc_hd__conb_1 _443__14 (.LO(debug_reg_data[1]));
 sky130_fd_sc_hd__conb_1 _444__15 (.LO(debug_reg_data[2]));
 sky130_fd_sc_hd__conb_1 _445__16 (.LO(debug_reg_data[3]));
 sky130_fd_sc_hd__conb_1 _446__17 (.LO(debug_reg_data[4]));
 sky130_fd_sc_hd__conb_1 _447__18 (.LO(debug_reg_data[5]));
 sky130_fd_sc_hd__conb_1 _448__19 (.LO(debug_reg_data[6]));
 sky130_fd_sc_hd__conb_1 _449__20 (.LO(debug_reg_data[7]));
 sky130_fd_sc_hd__conb_1 _450__21 (.LO(debug_reg_data[8]));
 sky130_fd_sc_hd__conb_1 _451__22 (.LO(debug_reg_data[9]));
 sky130_fd_sc_hd__conb_1 _452__23 (.LO(debug_reg_data[10]));
 sky130_fd_sc_hd__conb_1 _453__24 (.LO(debug_reg_data[11]));
 sky130_fd_sc_hd__conb_1 _454__25 (.LO(debug_reg_data[12]));
 sky130_fd_sc_hd__conb_1 _455__26 (.LO(debug_reg_data[13]));
 sky130_fd_sc_hd__conb_1 _456__27 (.LO(debug_reg_data[14]));
 sky130_fd_sc_hd__conb_1 _457__28 (.LO(debug_reg_data[15]));
 sky130_fd_sc_hd__conb_1 _458__29 (.LO(debug_reg_data[16]));
 sky130_fd_sc_hd__conb_1 _459__30 (.LO(debug_reg_data[17]));
 sky130_fd_sc_hd__conb_1 _460__31 (.LO(debug_reg_data[18]));
 sky130_fd_sc_hd__conb_1 _461__32 (.LO(debug_reg_data[19]));
 sky130_fd_sc_hd__conb_1 _462__33 (.LO(debug_reg_data[20]));
 sky130_fd_sc_hd__conb_1 _463__34 (.LO(debug_reg_data[21]));
 sky130_fd_sc_hd__conb_1 _464__35 (.LO(debug_reg_data[22]));
 sky130_fd_sc_hd__conb_1 _465__36 (.LO(debug_reg_data[23]));
 sky130_fd_sc_hd__conb_1 _466__37 (.LO(debug_reg_data[24]));
 sky130_fd_sc_hd__conb_1 _467__38 (.LO(debug_reg_data[25]));
 sky130_fd_sc_hd__conb_1 _468__39 (.LO(debug_reg_data[26]));
 sky130_fd_sc_hd__conb_1 _469__40 (.LO(debug_reg_data[27]));
 sky130_fd_sc_hd__conb_1 _470__41 (.LO(debug_reg_data[28]));
 sky130_fd_sc_hd__conb_1 _471__42 (.LO(debug_reg_data[29]));
 sky130_fd_sc_hd__conb_1 _472__43 (.LO(debug_reg_data[30]));
 sky130_fd_sc_hd__conb_1 _473__44 (.LO(debug_reg_data[31]));
 sky130_fd_sc_hd__conb_1 _474__45 (.LO(debug_reg_data[32]));
 sky130_fd_sc_hd__conb_1 _475__46 (.LO(debug_reg_data[33]));
 sky130_fd_sc_hd__conb_1 _476__47 (.LO(debug_reg_data[34]));
 sky130_fd_sc_hd__conb_1 _477__48 (.LO(debug_reg_data[35]));
 sky130_fd_sc_hd__conb_1 _478__49 (.LO(debug_reg_data[36]));
 sky130_fd_sc_hd__conb_1 _479__50 (.LO(debug_reg_data[37]));
 sky130_fd_sc_hd__conb_1 _480__51 (.LO(debug_reg_data[38]));
 sky130_fd_sc_hd__conb_1 _481__52 (.LO(debug_reg_data[39]));
 sky130_fd_sc_hd__conb_1 _482__53 (.LO(debug_reg_data[40]));
 sky130_fd_sc_hd__conb_1 _483__54 (.LO(debug_reg_data[41]));
 sky130_fd_sc_hd__conb_1 _484__55 (.LO(debug_reg_data[42]));
 sky130_fd_sc_hd__conb_1 _485__56 (.LO(debug_reg_data[43]));
 sky130_fd_sc_hd__conb_1 _486__57 (.LO(debug_reg_data[44]));
 sky130_fd_sc_hd__conb_1 _487__58 (.LO(debug_reg_data[45]));
 sky130_fd_sc_hd__conb_1 _488__59 (.LO(debug_reg_data[46]));
 sky130_fd_sc_hd__conb_1 _489__60 (.LO(debug_reg_data[47]));
 sky130_fd_sc_hd__conb_1 _490__61 (.LO(debug_reg_data[48]));
 sky130_fd_sc_hd__conb_1 _491__62 (.LO(debug_reg_data[49]));
 sky130_fd_sc_hd__conb_1 _492__63 (.LO(debug_reg_data[50]));
 sky130_fd_sc_hd__conb_1 _493__64 (.LO(debug_reg_data[51]));
 sky130_fd_sc_hd__conb_1 _494__65 (.LO(debug_reg_data[52]));
 sky130_fd_sc_hd__conb_1 _495__66 (.LO(debug_reg_data[53]));
 sky130_fd_sc_hd__conb_1 _496__67 (.LO(halted));
 sky130_fd_sc_hd__conb_1 _497__68 (.LO(ipc_out[0]));
 sky130_fd_sc_hd__conb_1 _390__70 (.HI(net69));
 sky130_fd_sc_hd__conb_1 _391__71 (.HI(net70));
 sky130_fd_sc_hd__conb_1 _392__72 (.HI(net71));
 sky130_fd_sc_hd__conb_1 _393__73 (.HI(net72));
 sky130_fd_sc_hd__conb_1 _394__74 (.HI(net73));
 sky130_fd_sc_hd__conb_1 \u_cpu.id_ex_reg_write_a$_DFF_PN0__75  (.HI(net74));
endmodule
