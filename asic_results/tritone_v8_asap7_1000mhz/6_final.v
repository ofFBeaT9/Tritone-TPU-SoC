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
 wire _139_;
 wire _140_;
 wire _141_;
 wire _142_;
 wire _143_;
 wire _144_;
 wire _145_;
 wire _146_;
 wire net229;
 wire _149_;
 wire _150_;
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
 wire _237_;
 wire _238_;
 wire _239_;
 wire _240_;
 wire _241_;
 wire _242_;
 wire _243_;
 wire _244_;
 wire _245_;
 wire _246_;
 wire _247_;
 wire _248_;
 wire _249_;
 wire _250_;
 wire _251_;
 wire _252_;
 wire _253_;
 wire net68;
 wire net95;
 wire net96;
 wire net97;
 wire net98;
 wire net99;
 wire net100;
 wire net101;
 wire net102;
 wire net103;
 wire net104;
 wire net105;
 wire net106;
 wire net107;
 wire net108;
 wire net109;
 wire net110;
 wire net111;
 wire \u_cpu.ex_wb_reg_write_a ;
 wire net94;
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
 wire net112;
 wire net243;
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
 wire net227;
 wire net233;
 wire net235;
 wire net228;
 wire net226;
 wire net225;
 wire net224;
 wire net223;
 wire net242;
 wire net221;
 wire net220;
 wire clknet_1_0__leaf_clk;
 wire net222;
 wire net219;
 wire net218;
 wire net217;
 wire net216;
 wire net215;
 wire net214;
 wire net213;
 wire net69;
 wire net70;
 wire net71;
 wire net72;
 wire net73;
 wire net74;
 wire net75;
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
 wire net93;
 wire net230;
 wire net240;
 wire net231;
 wire net232;
 wire net237;
 wire net236;
 wire net234;
 wire net238;
 wire net239;
 wire net241;
 wire net244;
 wire clknet_0_clk;
 wire net211;
 wire clknet_1_1__leaf_clk;
 wire net212;

 INVx1_ASAP7_75t_R _256_ (.A(_014_),
    .Y(_010_));
 OR3x1_ASAP7_75t_R _257_ (.A(net236),
    .B(net239),
    .C(_014_),
    .Y(_137_));
 INVx1_ASAP7_75t_R _258_ (.A(_137_),
    .Y(_015_));
 INVx1_ASAP7_75t_R _259_ (.A(_013_),
    .Y(_009_));
 INVx1_ASAP7_75t_R _260_ (.A(_000_),
    .Y(net112));
 INVx1_ASAP7_75t_R _261_ (.A(_001_),
    .Y(\u_cpu.ex_wb_reg_write_a ));
 INVx2_ASAP7_75t_R _263_ (.A(net241),
    .Y(net95));
 INVx1_ASAP7_75t_R _264_ (.A(_067_),
    .Y(net96));
 INVx1_ASAP7_75t_R _265_ (.A(_110_),
    .Y(net97));
 INVx1_ASAP7_75t_R _266_ (.A(_003_),
    .Y(net98));
 INVx1_ASAP7_75t_R _267_ (.A(_122_),
    .Y(net99));
 INVx1_ASAP7_75t_R _268_ (.A(_004_),
    .Y(net100));
 INVx1_ASAP7_75t_R _269_ (.A(_129_),
    .Y(net101));
 INVx1_ASAP7_75t_R _270_ (.A(_005_),
    .Y(net102));
 INVx1_ASAP7_75t_R _271_ (.A(_071_),
    .Y(net103));
 INVx1_ASAP7_75t_R _272_ (.A(_078_),
    .Y(net104));
 INVx1_ASAP7_75t_R _273_ (.A(_081_),
    .Y(net105));
 INVx1_ASAP7_75t_R _274_ (.A(_077_),
    .Y(net106));
 INVx1_ASAP7_75t_R _275_ (.A(_006_),
    .Y(net107));
 INVx1_ASAP7_75t_R _276_ (.A(_088_),
    .Y(net108));
 INVx1_ASAP7_75t_R _277_ (.A(_007_),
    .Y(net109));
 INVx1_ASAP7_75t_R _278_ (.A(_098_),
    .Y(net110));
 INVx1_ASAP7_75t_R _279_ (.A(_008_),
    .Y(net111));
 NOR2x2_ASAP7_75t_R _280_ (.A(_080_),
    .B(_079_),
    .Y(_139_));
 INVx1_ASAP7_75t_R _281_ (.A(_139_),
    .Y(_022_));
 INVx1_ASAP7_75t_R _282_ (.A(_076_),
    .Y(_140_));
 OA31x2_ASAP7_75t_R _283_ (.A1(_068_),
    .A2(net238),
    .A3(_009_),
    .B1(net237),
    .Y(_141_));
 NAND2x1_ASAP7_75t_R _284_ (.A(net232),
    .B(_141_),
    .Y(_027_));
 INVx1_ASAP7_75t_R _285_ (.A(net237),
    .Y(_074_));
 NOR2x1_ASAP7_75t_R _286_ (.A(_090_),
    .B(_089_),
    .Y(_085_));
 OR3x1_ASAP7_75t_R _287_ (.A(net239),
    .B(_139_),
    .C(net234),
    .Y(_093_));
 OR2x2_ASAP7_75t_R _288_ (.A(_141_),
    .B(net234),
    .Y(_101_));
 NOR2x1_ASAP7_75t_R _289_ (.A(_100_),
    .B(_099_),
    .Y(_096_));
 OAI22x1_ASAP7_75t_R _290_ (.A1(_090_),
    .A2(_089_),
    .B1(_099_),
    .B2(_100_),
    .Y(_142_));
 OR3x2_ASAP7_75t_R _291_ (.A(net239),
    .B(_139_),
    .C(net233),
    .Y(_105_));
 OR2x4_ASAP7_75t_R _292_ (.A(_141_),
    .B(net233),
    .Y(_113_));
 OR2x2_ASAP7_75t_R _293_ (.A(_112_),
    .B(_111_),
    .Y(_143_));
 INVx2_ASAP7_75t_R _294_ (.A(_143_),
    .Y(_108_));
 OR2x2_ASAP7_75t_R _295_ (.A(_105_),
    .B(_108_),
    .Y(_117_));
 OR3x1_ASAP7_75t_R _296_ (.A(_141_),
    .B(net233),
    .C(_108_),
    .Y(_125_));
 NOR2x2_ASAP7_75t_R _297_ (.A(_124_),
    .B(_123_),
    .Y(_120_));
 OR2x2_ASAP7_75t_R _298_ (.A(net233),
    .B(_120_),
    .Y(_144_));
 OR4x2_ASAP7_75t_R _299_ (.A(net239),
    .B(_139_),
    .C(_108_),
    .D(_144_),
    .Y(_130_));
 OR4x2_ASAP7_75t_R _300_ (.A(_141_),
    .B(net233),
    .C(_108_),
    .D(_120_),
    .Y(_134_));
 INVx1_ASAP7_75t_R _301_ (.A(_068_),
    .Y(_070_));
 AND3x1_ASAP7_75t_R _302_ (.A(_070_),
    .B(net237),
    .C(_013_),
    .Y(_145_));
 AO21x1_ASAP7_75t_R _303_ (.A1(_074_),
    .A2(_139_),
    .B(_145_),
    .Y(_083_));
 INVx1_ASAP7_75t_R _304_ (.A(net239),
    .Y(_146_));
 OR2x2_ASAP7_75t_R _305_ (.A(_146_),
    .B(_139_),
    .Y(_086_));
 NAND2x1_ASAP7_75t_R _306_ (.A(_076_),
    .B(_141_),
    .Y(_091_));
 OR2x2_ASAP7_75t_R _307_ (.A(_139_),
    .B(net234),
    .Y(_094_));
 AO21x1_ASAP7_75t_R _308_ (.A1(net232),
    .A2(_141_),
    .B(net234),
    .Y(_102_));
 OR2x4_ASAP7_75t_R _309_ (.A(_139_),
    .B(net233),
    .Y(_106_));
 AO21x1_ASAP7_75t_R _310_ (.A1(net232),
    .A2(_141_),
    .B(net233),
    .Y(_114_));
 AO21x1_ASAP7_75t_R _311_ (.A1(_139_),
    .A2(_143_),
    .B(net233),
    .Y(_118_));
 AO31x2_ASAP7_75t_R _312_ (.A1(net232),
    .A2(_141_),
    .A3(_143_),
    .B(net233),
    .Y(_126_));
 AO21x1_ASAP7_75t_R _313_ (.A1(_139_),
    .A2(_143_),
    .B(_144_),
    .Y(_131_));
 AO31x2_ASAP7_75t_R _314_ (.A1(net232),
    .A2(_141_),
    .A3(_143_),
    .B(_144_),
    .Y(_135_));
 INVx1_ASAP7_75t_R _315_ (.A(_095_),
    .Y(_032_));
 INVx1_ASAP7_75t_R _316_ (.A(_040_),
    .Y(_038_));
 INVx1_ASAP7_75t_R _317_ (.A(_103_),
    .Y(_037_));
 INVx1_ASAP7_75t_R _318_ (.A(_107_),
    .Y(_042_));
 INVx1_ASAP7_75t_R _319_ (.A(_115_),
    .Y(_045_));
 INVx1_ASAP7_75t_R _320_ (.A(_051_),
    .Y(_049_));
 INVx1_ASAP7_75t_R _321_ (.A(_119_),
    .Y(_048_));
 INVx1_ASAP7_75t_R _322_ (.A(_056_),
    .Y(_054_));
 INVx1_ASAP7_75t_R _323_ (.A(_127_),
    .Y(_053_));
 INVx1_ASAP7_75t_R _324_ (.A(_132_),
    .Y(_059_));
 INVx1_ASAP7_75t_R _325_ (.A(_065_),
    .Y(_058_));
 INVx1_ASAP7_75t_R _326_ (.A(_066_),
    .Y(_062_));
 INVx1_ASAP7_75t_R _327_ (.A(_021_),
    .Y(_018_));
 INVx1_ASAP7_75t_R _328_ (.A(_023_),
    .Y(_025_));
 INVx1_ASAP7_75t_R _329_ (.A(_028_),
    .Y(_030_));
 INVx1_ASAP7_75t_R _330_ (.A(_035_),
    .Y(_033_));
 BUFx3_ASAP7_75t_R place230 (.A(_024_),
    .Y(net229));
 NAND2x1_ASAP7_75t_R _333_ (.A(net236),
    .B(net242),
    .Y(_149_));
 OA21x2_ASAP7_75t_R _334_ (.A1(net242),
    .A2(_010_),
    .B(_149_),
    .Y(\u_cpu.next_pc[0] ));
 INVx1_ASAP7_75t_R _335_ (.A(_044_),
    .Y(_150_));
 OR3x1_ASAP7_75t_R _336_ (.A(_150_),
    .B(net223),
    .C(net244),
    .Y(_151_));
 NAND2x1_ASAP7_75t_R _337_ (.A(net223),
    .B(net244),
    .Y(_152_));
 INVx1_ASAP7_75t_R _338_ (.A(_047_),
    .Y(_153_));
 OR3x1_ASAP7_75t_R _339_ (.A(_153_),
    .B(net216),
    .C(_116_),
    .Y(_154_));
 AOI21x1_ASAP7_75t_R _340_ (.A1(net216),
    .A2(_116_),
    .B(net242),
    .Y(_155_));
 AO32x1_ASAP7_75t_R _341_ (.A1(net242),
    .A2(_151_),
    .A3(_152_),
    .B1(_154_),
    .B2(_155_),
    .Y(\u_cpu.next_pc[10] ));
 INVx1_ASAP7_75t_R _342_ (.A(net223),
    .Y(_156_));
 AND3x1_ASAP7_75t_R _343_ (.A(_044_),
    .B(_156_),
    .C(_109_),
    .Y(_157_));
 AO21x1_ASAP7_75t_R _344_ (.A1(_150_),
    .A2(net223),
    .B(net240),
    .Y(_158_));
 INVx1_ASAP7_75t_R _345_ (.A(net216),
    .Y(_159_));
 AND3x1_ASAP7_75t_R _346_ (.A(_047_),
    .B(_159_),
    .C(_116_),
    .Y(_160_));
 AO21x1_ASAP7_75t_R _347_ (.A1(_153_),
    .A2(net216),
    .B(net242),
    .Y(_161_));
 OAI22x1_ASAP7_75t_R _348_ (.A1(_157_),
    .A2(_158_),
    .B1(_160_),
    .B2(_161_),
    .Y(\u_cpu.next_pc[11] ));
 OR3x1_ASAP7_75t_R _349_ (.A(net213),
    .B(net222),
    .C(_121_),
    .Y(_162_));
 NAND2x1_ASAP7_75t_R _350_ (.A(net222),
    .B(_121_),
    .Y(_163_));
 OR3x1_ASAP7_75t_R _351_ (.A(net211),
    .B(net215),
    .C(net219),
    .Y(_164_));
 AOI21x1_ASAP7_75t_R _352_ (.A1(net215),
    .A2(net219),
    .B(net241),
    .Y(_165_));
 AO32x1_ASAP7_75t_R _353_ (.A1(net241),
    .A2(_162_),
    .A3(_163_),
    .B1(_164_),
    .B2(_165_),
    .Y(\u_cpu.next_pc[12] ));
 INVx1_ASAP7_75t_R _354_ (.A(_121_),
    .Y(_166_));
 OR3x1_ASAP7_75t_R _355_ (.A(net213),
    .B(net222),
    .C(_166_),
    .Y(_167_));
 NAND2x1_ASAP7_75t_R _356_ (.A(net213),
    .B(net222),
    .Y(_168_));
 INVx1_ASAP7_75t_R _357_ (.A(net219),
    .Y(_169_));
 OR3x1_ASAP7_75t_R _358_ (.A(net211),
    .B(net215),
    .C(_169_),
    .Y(_170_));
 AOI21x1_ASAP7_75t_R _359_ (.A1(net211),
    .A2(net215),
    .B(net241),
    .Y(_171_));
 AO32x1_ASAP7_75t_R _360_ (.A1(net241),
    .A2(_167_),
    .A3(_168_),
    .B1(_170_),
    .B2(_171_),
    .Y(\u_cpu.next_pc[13] ));
 INVx1_ASAP7_75t_R _361_ (.A(_061_),
    .Y(_172_));
 OR3x1_ASAP7_75t_R _362_ (.A(_172_),
    .B(net221),
    .C(_133_),
    .Y(_173_));
 NAND2x1_ASAP7_75t_R _363_ (.A(net221),
    .B(_133_),
    .Y(_174_));
 INVx1_ASAP7_75t_R _364_ (.A(_064_),
    .Y(_175_));
 OR3x1_ASAP7_75t_R _365_ (.A(_175_),
    .B(net214),
    .C(_136_),
    .Y(_176_));
 AOI21x1_ASAP7_75t_R _366_ (.A1(net214),
    .A2(_136_),
    .B(net241),
    .Y(_177_));
 AO32x1_ASAP7_75t_R _367_ (.A1(net241),
    .A2(_173_),
    .A3(_174_),
    .B1(_176_),
    .B2(_177_),
    .Y(\u_cpu.next_pc[14] ));
 INVx1_ASAP7_75t_R _368_ (.A(net221),
    .Y(_178_));
 AND3x1_ASAP7_75t_R _369_ (.A(_061_),
    .B(_178_),
    .C(_133_),
    .Y(_179_));
 AO21x1_ASAP7_75t_R _370_ (.A1(_172_),
    .A2(net221),
    .B(net240),
    .Y(_180_));
 INVx1_ASAP7_75t_R _371_ (.A(net214),
    .Y(_181_));
 AND3x1_ASAP7_75t_R _372_ (.A(_064_),
    .B(_181_),
    .C(_136_),
    .Y(_182_));
 AO21x1_ASAP7_75t_R _373_ (.A1(_175_),
    .A2(net214),
    .B(net241),
    .Y(_183_));
 OAI22x1_ASAP7_75t_R _374_ (.A1(_179_),
    .A2(_180_),
    .B1(_182_),
    .B2(_183_),
    .Y(\u_cpu.next_pc[15] ));
 AND2x2_ASAP7_75t_R _375_ (.A(net242),
    .B(net238),
    .Y(_184_));
 AOI21x1_ASAP7_75t_R _376_ (.A1(net236),
    .A2(net240),
    .B(_184_),
    .Y(\u_cpu.next_pc[1] ));
 INVx1_ASAP7_75t_R _377_ (.A(_075_),
    .Y(_185_));
 INVx1_ASAP7_75t_R _378_ (.A(_011_),
    .Y(_186_));
 AND3x1_ASAP7_75t_R _379_ (.A(_185_),
    .B(_186_),
    .C(net231),
    .Y(_187_));
 AO21x1_ASAP7_75t_R _380_ (.A1(_075_),
    .A2(_011_),
    .B(net242),
    .Y(_188_));
 OAI22x1_ASAP7_75t_R _381_ (.A1(net240),
    .A2(net238),
    .B1(_187_),
    .B2(_188_),
    .Y(\u_cpu.next_pc[2] ));
 AND3x1_ASAP7_75t_R _382_ (.A(_075_),
    .B(_186_),
    .C(net231),
    .Y(_189_));
 OAI21x1_ASAP7_75t_R _383_ (.A1(_186_),
    .A2(net231),
    .B(net240),
    .Y(_190_));
 OAI22x1_ASAP7_75t_R _384_ (.A1(net240),
    .A2(_137_),
    .B1(_189_),
    .B2(_190_),
    .Y(\u_cpu.next_pc[3] ));
 INVx1_ASAP7_75t_R _385_ (.A(_017_),
    .Y(_191_));
 OR3x1_ASAP7_75t_R _386_ (.A(net239),
    .B(net230),
    .C(_191_),
    .Y(_192_));
 NAND2x1_ASAP7_75t_R _387_ (.A(net239),
    .B(net230),
    .Y(_193_));
 INVx1_ASAP7_75t_R _388_ (.A(_084_),
    .Y(_194_));
 INVx1_ASAP7_75t_R _389_ (.A(_020_),
    .Y(_195_));
 OR3x1_ASAP7_75t_R _390_ (.A(_194_),
    .B(net226),
    .C(_195_),
    .Y(_196_));
 AOI21x1_ASAP7_75t_R _391_ (.A1(_194_),
    .A2(net226),
    .B(net242),
    .Y(_197_));
 AO32x1_ASAP7_75t_R _392_ (.A1(net242),
    .A2(_192_),
    .A3(_193_),
    .B1(_196_),
    .B2(_197_),
    .Y(\u_cpu.next_pc[4] ));
 OR3x1_ASAP7_75t_R _393_ (.A(_146_),
    .B(net230),
    .C(_191_),
    .Y(_198_));
 NAND2x1_ASAP7_75t_R _394_ (.A(net230),
    .B(_191_),
    .Y(_199_));
 OR3x1_ASAP7_75t_R _395_ (.A(_084_),
    .B(net226),
    .C(_195_),
    .Y(_200_));
 AOI21x1_ASAP7_75t_R _396_ (.A1(net226),
    .A2(_195_),
    .B(net242),
    .Y(_201_));
 AO32x1_ASAP7_75t_R _397_ (.A1(net242),
    .A2(_198_),
    .A3(_199_),
    .B1(_200_),
    .B2(_201_),
    .Y(\u_cpu.next_pc[5] ));
 INVx1_ASAP7_75t_R _398_ (.A(_087_),
    .Y(_202_));
 AND3x1_ASAP7_75t_R _399_ (.A(net228),
    .B(net229),
    .C(_202_),
    .Y(_203_));
 OAI21x1_ASAP7_75t_R _400_ (.A1(net228),
    .A2(_202_),
    .B(net241),
    .Y(_204_));
 INVx1_ASAP7_75t_R _401_ (.A(_092_),
    .Y(_205_));
 AND3x1_ASAP7_75t_R _402_ (.A(net225),
    .B(net227),
    .C(_205_),
    .Y(_206_));
 OAI21x1_ASAP7_75t_R _403_ (.A1(net225),
    .A2(_205_),
    .B(net240),
    .Y(_207_));
 OAI22x1_ASAP7_75t_R _404_ (.A1(_203_),
    .A2(_204_),
    .B1(_206_),
    .B2(_207_),
    .Y(\u_cpu.next_pc[6] ));
 AND3x1_ASAP7_75t_R _405_ (.A(net228),
    .B(net229),
    .C(_087_),
    .Y(_208_));
 OAI21x1_ASAP7_75t_R _406_ (.A1(net228),
    .A2(net229),
    .B(net241),
    .Y(_209_));
 AND3x1_ASAP7_75t_R _407_ (.A(net225),
    .B(net227),
    .C(_092_),
    .Y(_210_));
 OAI21x1_ASAP7_75t_R _408_ (.A1(net225),
    .A2(net227),
    .B(net240),
    .Y(_211_));
 OAI22x1_ASAP7_75t_R _409_ (.A1(_208_),
    .A2(_209_),
    .B1(_210_),
    .B2(_211_),
    .Y(\u_cpu.next_pc[7] ));
 OR3x1_ASAP7_75t_R _410_ (.A(net218),
    .B(net224),
    .C(_097_),
    .Y(_212_));
 NAND2x1_ASAP7_75t_R _411_ (.A(net224),
    .B(_097_),
    .Y(_213_));
 OR3x1_ASAP7_75t_R _412_ (.A(net212),
    .B(net217),
    .C(net220),
    .Y(_214_));
 AOI21x1_ASAP7_75t_R _413_ (.A1(net217),
    .A2(net220),
    .B(net242),
    .Y(_215_));
 AO32x1_ASAP7_75t_R _414_ (.A1(net242),
    .A2(_212_),
    .A3(_213_),
    .B1(_214_),
    .B2(_215_),
    .Y(\u_cpu.next_pc[8] ));
 INVx1_ASAP7_75t_R _415_ (.A(_097_),
    .Y(_216_));
 OR3x1_ASAP7_75t_R _416_ (.A(net218),
    .B(net224),
    .C(_216_),
    .Y(_217_));
 NAND2x1_ASAP7_75t_R _417_ (.A(net218),
    .B(net224),
    .Y(_218_));
 INVx1_ASAP7_75t_R _418_ (.A(net220),
    .Y(_219_));
 OR3x1_ASAP7_75t_R _419_ (.A(net212),
    .B(net217),
    .C(_219_),
    .Y(_220_));
 AOI21x1_ASAP7_75t_R _420_ (.A1(net212),
    .A2(net217),
    .B(net242),
    .Y(_221_));
 AO32x1_ASAP7_75t_R _421_ (.A1(net242),
    .A2(_217_),
    .A3(_218_),
    .B1(_220_),
    .B2(_221_),
    .Y(\u_cpu.next_pc[9] ));
 FAx1_ASAP7_75t_R _422_ (.SN(_012_),
    .A(_222_),
    .B(_009_),
    .CI(_010_),
    .CON(_011_));
 FAx1_ASAP7_75t_R _423_ (.SN(_017_),
    .A(net),
    .B(net68),
    .CI(_015_),
    .CON(_016_));
 FAx1_ASAP7_75t_R _424_ (.SN(_020_),
    .A(net1),
    .B(_018_),
    .CI(net69),
    .CON(_019_));
 FAx1_ASAP7_75t_R _425_ (.SN(_024_),
    .A(net70),
    .B(_022_),
    .CI(_023_),
    .CON(_223_));
 FAx1_ASAP7_75t_R _426_ (.SN(_224_),
    .A(net71),
    .B(_022_),
    .CI(_025_),
    .CON(_026_));
 FAx1_ASAP7_75t_R _427_ (.SN(_029_),
    .A(net72),
    .B(_027_),
    .CI(_028_),
    .CON(_225_));
 FAx1_ASAP7_75t_R _428_ (.SN(_226_),
    .A(net73),
    .B(_027_),
    .CI(_030_),
    .CON(_031_));
 FAx1_ASAP7_75t_R _429_ (.SN(_034_),
    .A(net2),
    .B(_032_),
    .CI(_033_),
    .CON(_227_));
 FAx1_ASAP7_75t_R _430_ (.SN(_228_),
    .A(net3),
    .B(_032_),
    .CI(_035_),
    .CON(_036_));
 FAx1_ASAP7_75t_R _431_ (.SN(_039_),
    .A(net4),
    .B(_037_),
    .CI(_038_),
    .CON(_229_));
 FAx1_ASAP7_75t_R _432_ (.SN(_230_),
    .A(net5),
    .B(_037_),
    .CI(_040_),
    .CON(_041_));
 FAx1_ASAP7_75t_R _433_ (.SN(_044_),
    .A(net6),
    .B(_042_),
    .CI(_231_),
    .CON(_043_));
 FAx1_ASAP7_75t_R _434_ (.SN(_047_),
    .A(net7),
    .B(_045_),
    .CI(_232_),
    .CON(_046_));
 FAx1_ASAP7_75t_R _435_ (.SN(_050_),
    .A(net8),
    .B(_048_),
    .CI(_049_),
    .CON(_233_));
 FAx1_ASAP7_75t_R _436_ (.SN(_234_),
    .A(net9),
    .B(_048_),
    .CI(_051_),
    .CON(_052_));
 FAx1_ASAP7_75t_R _437_ (.SN(_055_),
    .A(net10),
    .B(_053_),
    .CI(_054_),
    .CON(_235_));
 FAx1_ASAP7_75t_R _438_ (.SN(_236_),
    .A(net11),
    .B(_053_),
    .CI(_056_),
    .CON(_057_));
 FAx1_ASAP7_75t_R _439_ (.SN(_061_),
    .A(_058_),
    .B(_059_),
    .CI(_237_),
    .CON(_060_));
 FAx1_ASAP7_75t_R _440_ (.SN(_064_),
    .A(_058_),
    .B(_062_),
    .CI(_238_),
    .CON(_063_));
 HAxp5_ASAP7_75t_R _441_ (.A(_067_),
    .B(net103),
    .CON(_068_),
    .SN(_069_));
 HAxp5_ASAP7_75t_R _442_ (.A(_067_),
    .B(net103),
    .CON(_014_),
    .SN(_239_));
 HAxp5_ASAP7_75t_R _443_ (.A(net96),
    .B(_071_),
    .CON(_072_),
    .SN(_240_));
 HAxp5_ASAP7_75t_R _444_ (.A(net96),
    .B(_071_),
    .CON(_073_),
    .SN(_241_));
 HAxp5_ASAP7_75t_R _445_ (.A(_074_),
    .B(_070_),
    .CON(_222_),
    .SN(_075_));
 HAxp5_ASAP7_75t_R _446_ (.A(_013_),
    .B(_010_),
    .CON(_076_),
    .SN(_242_));
 HAxp5_ASAP7_75t_R _447_ (.A(_078_),
    .B(net105),
    .CON(_079_),
    .SN(_080_));
 HAxp5_ASAP7_75t_R _448_ (.A(net104),
    .B(_081_),
    .CON(_082_),
    .SN(_243_));
 HAxp5_ASAP7_75t_R _449_ (.A(net104),
    .B(_081_),
    .CON(_013_),
    .SN(_244_));
 HAxp5_ASAP7_75t_R _450_ (.A(net237),
    .B(_083_),
    .CON(_021_),
    .SN(_084_));
 HAxp5_ASAP7_75t_R _451_ (.A(net234),
    .B(_086_),
    .CON(_023_),
    .SN(_087_));
 HAxp5_ASAP7_75t_R _452_ (.A(_088_),
    .B(net109),
    .CON(_089_),
    .SN(_090_));
 HAxp5_ASAP7_75t_R _453_ (.A(net234),
    .B(_091_),
    .CON(_028_),
    .SN(_092_));
 HAxp5_ASAP7_75t_R _454_ (.A(_093_),
    .B(_094_),
    .CON(_095_),
    .SN(_245_));
 HAxp5_ASAP7_75t_R _455_ (.A(_096_),
    .B(_245_),
    .CON(_035_),
    .SN(_097_));
 HAxp5_ASAP7_75t_R _456_ (.A(_098_),
    .B(net111),
    .CON(_099_),
    .SN(_100_));
 HAxp5_ASAP7_75t_R _457_ (.A(_101_),
    .B(_102_),
    .CON(_103_),
    .SN(_246_));
 HAxp5_ASAP7_75t_R _458_ (.A(_096_),
    .B(_246_),
    .CON(_040_),
    .SN(_104_));
 HAxp5_ASAP7_75t_R _459_ (.A(_105_),
    .B(_106_),
    .CON(_107_),
    .SN(_247_));
 HAxp5_ASAP7_75t_R _460_ (.A(_108_),
    .B(_247_),
    .CON(_231_),
    .SN(_109_));
 HAxp5_ASAP7_75t_R _461_ (.A(_110_),
    .B(net98),
    .CON(_111_),
    .SN(_112_));
 HAxp5_ASAP7_75t_R _462_ (.A(_113_),
    .B(_114_),
    .CON(_115_),
    .SN(_248_));
 HAxp5_ASAP7_75t_R _463_ (.A(_108_),
    .B(_248_),
    .CON(_232_),
    .SN(_116_));
 HAxp5_ASAP7_75t_R _464_ (.A(_117_),
    .B(_118_),
    .CON(_119_),
    .SN(_249_));
 HAxp5_ASAP7_75t_R _465_ (.A(_120_),
    .B(_249_),
    .CON(_051_),
    .SN(_121_));
 HAxp5_ASAP7_75t_R _466_ (.A(_122_),
    .B(net100),
    .CON(_123_),
    .SN(_124_));
 HAxp5_ASAP7_75t_R _467_ (.A(_125_),
    .B(_126_),
    .CON(_127_),
    .SN(_250_));
 HAxp5_ASAP7_75t_R _468_ (.A(_120_),
    .B(_250_),
    .CON(_056_),
    .SN(_128_));
 HAxp5_ASAP7_75t_R _469_ (.A(_129_),
    .B(net102),
    .CON(_065_),
    .SN(_251_));
 HAxp5_ASAP7_75t_R _470_ (.A(_130_),
    .B(_131_),
    .CON(_132_),
    .SN(_252_));
 HAxp5_ASAP7_75t_R _471_ (.A(net235),
    .B(_252_),
    .CON(_237_),
    .SN(_133_));
 HAxp5_ASAP7_75t_R _472_ (.A(_134_),
    .B(_135_),
    .CON(_066_),
    .SN(_253_));
 HAxp5_ASAP7_75t_R _473_ (.A(net235),
    .B(_253_),
    .CON(_238_),
    .SN(_136_));
 TIEHIx1_ASAP7_75t_R _423__69 (.H(net68));
 BUFx3_ASAP7_75t_R place228 (.A(_029_),
    .Y(net227));
 BUFx3_ASAP7_75t_R place234 (.A(_142_),
    .Y(net233));
 BUFx3_ASAP7_75t_R place236 (.A(_251_),
    .Y(net235));
 BUFx3_ASAP7_75t_R place229 (.A(_026_),
    .Y(net228));
 BUFx3_ASAP7_75t_R place227 (.A(_019_),
    .Y(net226));
 BUFx3_ASAP7_75t_R place226 (.A(_031_),
    .Y(net225));
 BUFx3_ASAP7_75t_R place225 (.A(_036_),
    .Y(net224));
 BUFx3_ASAP7_75t_R place224 (.A(_043_),
    .Y(net223));
 BUFx3_ASAP7_75t_R place243 (.A(_002_),
    .Y(net242));
 BUFx3_ASAP7_75t_R place222 (.A(_060_),
    .Y(net221));
 BUFx3_ASAP7_75t_R place221 (.A(_104_),
    .Y(net220));
 BUFx2_ASAP7_75t_R clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .Y(clknet_1_0__leaf_clk));
 BUFx3_ASAP7_75t_R place223 (.A(_052_),
    .Y(net222));
 BUFx3_ASAP7_75t_R place220 (.A(_128_),
    .Y(net219));
 BUFx3_ASAP7_75t_R place219 (.A(_034_),
    .Y(net218));
 BUFx3_ASAP7_75t_R place218 (.A(_041_),
    .Y(net217));
 BUFx3_ASAP7_75t_R place217 (.A(_046_),
    .Y(net216));
 BUFx3_ASAP7_75t_R place216 (.A(_057_),
    .Y(net215));
 BUFx3_ASAP7_75t_R place215 (.A(_063_),
    .Y(net214));
 BUFx3_ASAP7_75t_R place214 (.A(_050_),
    .Y(net213));
 BUFx2_ASAP7_75t_R output114 (.A(net112),
    .Y(valid_out_b));
 BUFx2_ASAP7_75t_R output113 (.A(net112),
    .Y(valid_out_a));
 BUFx2_ASAP7_75t_R output112 (.A(net111),
    .Y(pc_out[9]));
 BUFx2_ASAP7_75t_R output111 (.A(net110),
    .Y(pc_out[8]));
 BUFx2_ASAP7_75t_R output110 (.A(net109),
    .Y(pc_out[7]));
 BUFx2_ASAP7_75t_R output109 (.A(net108),
    .Y(pc_out[6]));
 BUFx2_ASAP7_75t_R output108 (.A(net107),
    .Y(pc_out[5]));
 BUFx2_ASAP7_75t_R output107 (.A(net106),
    .Y(pc_out[4]));
 BUFx2_ASAP7_75t_R output106 (.A(net105),
    .Y(pc_out[3]));
 BUFx2_ASAP7_75t_R output105 (.A(net104),
    .Y(pc_out[2]));
 BUFx2_ASAP7_75t_R output104 (.A(net103),
    .Y(pc_out[1]));
 BUFx2_ASAP7_75t_R output103 (.A(net102),
    .Y(pc_out[15]));
 BUFx2_ASAP7_75t_R output102 (.A(net101),
    .Y(pc_out[14]));
 BUFx2_ASAP7_75t_R output101 (.A(net100),
    .Y(pc_out[13]));
 BUFx2_ASAP7_75t_R output100 (.A(net99),
    .Y(pc_out[12]));
 BUFx2_ASAP7_75t_R output99 (.A(net98),
    .Y(pc_out[11]));
 BUFx2_ASAP7_75t_R output98 (.A(net97),
    .Y(pc_out[10]));
 BUFx2_ASAP7_75t_R output97 (.A(net96),
    .Y(pc_out[0]));
 BUFx2_ASAP7_75t_R output96 (.A(net240),
    .Y(ipc_out[1]));
 BUFx2_ASAP7_75t_R input95 (.A(rst_n),
    .Y(net94));
 BUFx3_ASAP7_75t_R place244 (.A(net94),
    .Y(net243));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.id_ex_valid_a$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(net240),
    .QN(_001_),
    .RESETN(net243),
    .SETN(net74));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.if_id_valid_b$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(net75),
    .QN(_002_),
    .RESETN(net243),
    .SETN(net76));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[0]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[0] ),
    .QN(_067_),
    .RESETN(net243),
    .SETN(net77));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[10]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[10] ),
    .QN(_110_),
    .RESETN(net243),
    .SETN(net78));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[11]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[11] ),
    .QN(_003_),
    .RESETN(net243),
    .SETN(net79));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[12]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[12] ),
    .QN(_122_),
    .RESETN(net243),
    .SETN(net80));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[13]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[13] ),
    .QN(_004_),
    .RESETN(net243),
    .SETN(net81));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[14]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[14] ),
    .QN(_129_),
    .RESETN(net243),
    .SETN(net82));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[15]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[15] ),
    .QN(_005_),
    .RESETN(net243),
    .SETN(net83));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[1]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[1] ),
    .QN(_071_),
    .RESETN(net243),
    .SETN(net84));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[2]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[2] ),
    .QN(_078_),
    .RESETN(net94),
    .SETN(net85));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[3]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[3] ),
    .QN(_081_),
    .RESETN(net94),
    .SETN(net86));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[4]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[4] ),
    .QN(_077_),
    .RESETN(net94),
    .SETN(net87));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[5]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[5] ),
    .QN(_006_),
    .RESETN(net94),
    .SETN(net88));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[6]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[6] ),
    .QN(_088_),
    .RESETN(net243),
    .SETN(net89));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[7]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[7] ),
    .QN(_007_),
    .RESETN(net243),
    .SETN(net90));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[8]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[8] ),
    .QN(_098_),
    .RESETN(net94),
    .SETN(net91));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[9]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[9] ),
    .QN(_008_),
    .RESETN(net94),
    .SETN(net92));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.valid_out_a$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.ex_wb_reg_write_a ),
    .QN(_000_),
    .RESETN(net243),
    .SETN(net93));
 TIELOx1_ASAP7_75t_R _423__1 (.L(net));
 TIELOx1_ASAP7_75t_R _424__2 (.L(net1));
 TIELOx1_ASAP7_75t_R _429__3 (.L(net2));
 TIELOx1_ASAP7_75t_R _430__4 (.L(net3));
 TIELOx1_ASAP7_75t_R _431__5 (.L(net4));
 TIELOx1_ASAP7_75t_R _432__6 (.L(net5));
 TIELOx1_ASAP7_75t_R _433__7 (.L(net6));
 TIELOx1_ASAP7_75t_R _434__8 (.L(net7));
 TIELOx1_ASAP7_75t_R _435__9 (.L(net8));
 TIELOx1_ASAP7_75t_R _436__10 (.L(net9));
 TIELOx1_ASAP7_75t_R _437__11 (.L(net10));
 TIELOx1_ASAP7_75t_R _438__12 (.L(net11));
 TIELOx1_ASAP7_75t_R _476__13 (.L(debug_reg_data[0]));
 TIELOx1_ASAP7_75t_R _477__14 (.L(debug_reg_data[1]));
 TIELOx1_ASAP7_75t_R _478__15 (.L(debug_reg_data[2]));
 TIELOx1_ASAP7_75t_R _479__16 (.L(debug_reg_data[3]));
 TIELOx1_ASAP7_75t_R _480__17 (.L(debug_reg_data[4]));
 TIELOx1_ASAP7_75t_R _481__18 (.L(debug_reg_data[5]));
 TIELOx1_ASAP7_75t_R _482__19 (.L(debug_reg_data[6]));
 TIELOx1_ASAP7_75t_R _483__20 (.L(debug_reg_data[7]));
 TIELOx1_ASAP7_75t_R _484__21 (.L(debug_reg_data[8]));
 TIELOx1_ASAP7_75t_R _485__22 (.L(debug_reg_data[9]));
 TIELOx1_ASAP7_75t_R _486__23 (.L(debug_reg_data[10]));
 TIELOx1_ASAP7_75t_R _487__24 (.L(debug_reg_data[11]));
 TIELOx1_ASAP7_75t_R _488__25 (.L(debug_reg_data[12]));
 TIELOx1_ASAP7_75t_R _489__26 (.L(debug_reg_data[13]));
 TIELOx1_ASAP7_75t_R _490__27 (.L(debug_reg_data[14]));
 TIELOx1_ASAP7_75t_R _491__28 (.L(debug_reg_data[15]));
 TIELOx1_ASAP7_75t_R _492__29 (.L(debug_reg_data[16]));
 TIELOx1_ASAP7_75t_R _493__30 (.L(debug_reg_data[17]));
 TIELOx1_ASAP7_75t_R _494__31 (.L(debug_reg_data[18]));
 TIELOx1_ASAP7_75t_R _495__32 (.L(debug_reg_data[19]));
 TIELOx1_ASAP7_75t_R _496__33 (.L(debug_reg_data[20]));
 TIELOx1_ASAP7_75t_R _497__34 (.L(debug_reg_data[21]));
 TIELOx1_ASAP7_75t_R _498__35 (.L(debug_reg_data[22]));
 TIELOx1_ASAP7_75t_R _499__36 (.L(debug_reg_data[23]));
 TIELOx1_ASAP7_75t_R _500__37 (.L(debug_reg_data[24]));
 TIELOx1_ASAP7_75t_R _501__38 (.L(debug_reg_data[25]));
 TIELOx1_ASAP7_75t_R _502__39 (.L(debug_reg_data[26]));
 TIELOx1_ASAP7_75t_R _503__40 (.L(debug_reg_data[27]));
 TIELOx1_ASAP7_75t_R _504__41 (.L(debug_reg_data[28]));
 TIELOx1_ASAP7_75t_R _505__42 (.L(debug_reg_data[29]));
 TIELOx1_ASAP7_75t_R _506__43 (.L(debug_reg_data[30]));
 TIELOx1_ASAP7_75t_R _507__44 (.L(debug_reg_data[31]));
 TIELOx1_ASAP7_75t_R _508__45 (.L(debug_reg_data[32]));
 TIELOx1_ASAP7_75t_R _509__46 (.L(debug_reg_data[33]));
 TIELOx1_ASAP7_75t_R _510__47 (.L(debug_reg_data[34]));
 TIELOx1_ASAP7_75t_R _511__48 (.L(debug_reg_data[35]));
 TIELOx1_ASAP7_75t_R _512__49 (.L(debug_reg_data[36]));
 TIELOx1_ASAP7_75t_R _513__50 (.L(debug_reg_data[37]));
 TIELOx1_ASAP7_75t_R _514__51 (.L(debug_reg_data[38]));
 TIELOx1_ASAP7_75t_R _515__52 (.L(debug_reg_data[39]));
 TIELOx1_ASAP7_75t_R _516__53 (.L(debug_reg_data[40]));
 TIELOx1_ASAP7_75t_R _517__54 (.L(debug_reg_data[41]));
 TIELOx1_ASAP7_75t_R _518__55 (.L(debug_reg_data[42]));
 TIELOx1_ASAP7_75t_R _519__56 (.L(debug_reg_data[43]));
 TIELOx1_ASAP7_75t_R _520__57 (.L(debug_reg_data[44]));
 TIELOx1_ASAP7_75t_R _521__58 (.L(debug_reg_data[45]));
 TIELOx1_ASAP7_75t_R _522__59 (.L(debug_reg_data[46]));
 TIELOx1_ASAP7_75t_R _523__60 (.L(debug_reg_data[47]));
 TIELOx1_ASAP7_75t_R _524__61 (.L(debug_reg_data[48]));
 TIELOx1_ASAP7_75t_R _525__62 (.L(debug_reg_data[49]));
 TIELOx1_ASAP7_75t_R _526__63 (.L(debug_reg_data[50]));
 TIELOx1_ASAP7_75t_R _527__64 (.L(debug_reg_data[51]));
 TIELOx1_ASAP7_75t_R _528__65 (.L(debug_reg_data[52]));
 TIELOx1_ASAP7_75t_R _529__66 (.L(debug_reg_data[53]));
 TIELOx1_ASAP7_75t_R _530__67 (.L(halted));
 TIELOx1_ASAP7_75t_R _531__68 (.L(ipc_out[0]));
 TIEHIx1_ASAP7_75t_R _424__70 (.H(net69));
 TIEHIx1_ASAP7_75t_R _425__71 (.H(net70));
 TIEHIx1_ASAP7_75t_R _426__72 (.H(net71));
 TIEHIx1_ASAP7_75t_R _427__73 (.H(net72));
 TIEHIx1_ASAP7_75t_R _428__74 (.H(net73));
 TIEHIx1_ASAP7_75t_R \u_cpu.id_ex_valid_a$_DFF_PN0__75  (.H(net74));
 TIEHIx1_ASAP7_75t_R \u_cpu.if_id_valid_b$_DFF_PN0__76  (.H(net75));
 TIEHIx1_ASAP7_75t_R \u_cpu.if_id_valid_b$_DFF_PN0__77  (.H(net76));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[0]$_DFF_PN0__78  (.H(net77));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[10]$_DFF_PN0__79  (.H(net78));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[11]$_DFF_PN0__80  (.H(net79));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[12]$_DFF_PN0__81  (.H(net80));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[13]$_DFF_PN0__82  (.H(net81));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[14]$_DFF_PN0__83  (.H(net82));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[15]$_DFF_PN0__84  (.H(net83));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[1]$_DFF_PN0__85  (.H(net84));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[2]$_DFF_PN0__86  (.H(net85));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[3]$_DFF_PN0__87  (.H(net86));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[4]$_DFF_PN0__88  (.H(net87));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[5]$_DFF_PN0__89  (.H(net88));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[6]$_DFF_PN0__90  (.H(net89));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[7]$_DFF_PN0__91  (.H(net90));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[8]$_DFF_PN0__92  (.H(net91));
 TIEHIx1_ASAP7_75t_R \u_cpu.imem_addr[9]$_DFF_PN0__93  (.H(net92));
 TIEHIx1_ASAP7_75t_R \u_cpu.valid_out_a$_DFF_PN0__94  (.H(net93));
 BUFx3_ASAP7_75t_R place231 (.A(_016_),
    .Y(net230));
 BUFx3_ASAP7_75t_R place241 (.A(net95),
    .Y(net240));
 BUFx3_ASAP7_75t_R place232 (.A(_012_),
    .Y(net231));
 BUFx3_ASAP7_75t_R place233 (.A(_140_),
    .Y(net232));
 BUFx3_ASAP7_75t_R place238 (.A(_082_),
    .Y(net237));
 BUFx3_ASAP7_75t_R place237 (.A(_069_),
    .Y(net236));
 BUFx3_ASAP7_75t_R place235 (.A(_085_),
    .Y(net234));
 BUFx3_ASAP7_75t_R place239 (.A(_073_),
    .Y(net238));
 BUFx3_ASAP7_75t_R place240 (.A(_072_),
    .Y(net239));
 BUFx3_ASAP7_75t_R place242 (.A(_002_),
    .Y(net241));
 BUFx12_ASAP7_75t_R clkload0 (.A(clknet_1_0__leaf_clk));
 BUFx2_ASAP7_75t_R clkbuf_0_clk (.A(clk),
    .Y(clknet_0_clk));
 BUFx2_ASAP7_75t_R wire245 (.A(_109_),
    .Y(net244));
 BUFx3_ASAP7_75t_R place212 (.A(_055_),
    .Y(net211));
 BUFx2_ASAP7_75t_R clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .Y(clknet_1_1__leaf_clk));
 BUFx3_ASAP7_75t_R place213 (.A(_039_),
    .Y(net212));
endmodule
