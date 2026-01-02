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
 wire net537;
 wire _139_;
 wire _140_;
 wire _141_;
 wire _142_;
 wire _143_;
 wire _144_;
 wire _145_;
 wire _146_;
 wire net633;
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
 wire net604;
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
 wire net629;
 wire net535;
 wire net631;
 wire net630;
 wire net536;
 wire net534;
 wire net639;
 wire net638;
 wire net637;
 wire net636;
 wire net635;
 wire net532;
 wire net533;
 wire net531;
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
 wire net440;
 wire net538;
 wire net539;
 wire net540;
 wire net541;
 wire net542;
 wire net543;
 wire net546;
 wire net622;
 wire net544;
 wire net623;
 wire net624;
 wire net625;
 wire net627;
 wire net545;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;
 wire net616;
 wire net617;
 wire net618;
 wire net620;
 wire net547;
 wire net548;
 wire net549;
 wire net550;
 wire net551;
 wire net552;
 wire net553;
 wire net554;
 wire net555;
 wire net556;
 wire net458;
 wire net259;
 wire net260;
 wire net261;
 wire net262;
 wire net263;
 wire net264;
 wire net265;
 wire net557;
 wire net558;
 wire net559;
 wire clknet_0_clk;
 wire net563;
 wire net560;
 wire net564;
 wire net290;
 wire net291;
 wire net292;
 wire net293;
 wire net294;
 wire net295;
 wire net296;
 wire net562;
 wire net561;
 wire net565;
 wire net566;
 wire net567;
 wire net568;
 wire net569;
 wire net571;
 wire net570;
 wire net572;
 wire net573;
 wire net574;
 wire net336;
 wire net337;
 wire net575;
 wire net576;
 wire net577;
 wire net578;
 wire net579;
 wire net580;
 wire net582;
 wire net587;
 wire net586;
 wire net583;
 wire net584;
 wire net585;
 wire net588;
 wire net589;
 wire net590;
 wire net591;
 wire net592;
 wire net593;
 wire net594;
 wire net595;
 wire net596;
 wire net597;
 wire net598;
 wire net599;
 wire net600;
 wire net601;
 wire net602;
 wire net613;
 wire net603;
 wire net612;
 wire net610;
 wire net609;
 wire net608;
 wire net607;
 wire net605;
 wire net606;
 wire net614;
 wire net619;
 wire net628;
 wire net611;
 wire net632;
 wire net626;
 wire net634;
 wire net525;
 wire net524;
 wire net621;
 wire net581;
 wire net615;
 wire net529;
 wire net530;

 INVx1_ASAP7_75t_R _256_ (.A(net600),
    .Y(_010_));
 OR3x1_ASAP7_75t_R _257_ (.A(net591),
    .B(net599),
    .C(net600),
    .Y(_137_));
 INVx1_ASAP7_75t_R _258_ (.A(_137_),
    .Y(_015_));
 INVx1_ASAP7_75t_R _259_ (.A(net595),
    .Y(_009_));
 INVx1_ASAP7_75t_R _260_ (.A(_000_),
    .Y(net112));
 INVx1_ASAP7_75t_R _261_ (.A(_001_),
    .Y(\u_cpu.ex_wb_reg_write_a ));
 BUFx3_ASAP7_75t_R place538 (.A(_041_),
    .Y(net537));
 INVx3_ASAP7_75t_R _263_ (.A(net606),
    .Y(net95));
 INVx1_ASAP7_75t_R _264_ (.A(net605),
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
 INVx1_ASAP7_75t_R _271_ (.A(net604),
    .Y(net103));
 INVx1_ASAP7_75t_R _272_ (.A(_078_),
    .Y(net104));
 INVx1_ASAP7_75t_R _273_ (.A(net603),
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
 NOR2x2_ASAP7_75t_R _280_ (.A(net590),
    .B(net597),
    .Y(_139_));
 INVx2_ASAP7_75t_R _281_ (.A(net582),
    .Y(_022_));
 INVx2_ASAP7_75t_R _282_ (.A(net575),
    .Y(_140_));
 OA31x2_ASAP7_75t_R _283_ (.A1(net601),
    .A2(net598),
    .A3(net584),
    .B1(net596),
    .Y(_141_));
 NAND2x2_ASAP7_75t_R _284_ (.A(net573),
    .B(net577),
    .Y(_027_));
 INVx1_ASAP7_75t_R _285_ (.A(net596),
    .Y(_074_));
 NOR2x2_ASAP7_75t_R _286_ (.A(net589),
    .B(net594),
    .Y(_085_));
 OR3x1_ASAP7_75t_R _287_ (.A(net599),
    .B(net582),
    .C(net581),
    .Y(_093_));
 OR2x2_ASAP7_75t_R _288_ (.A(net577),
    .B(net581),
    .Y(_101_));
 NOR2x1_ASAP7_75t_R _289_ (.A(net588),
    .B(net593),
    .Y(_096_));
 OAI22x1_ASAP7_75t_R _290_ (.A1(net589),
    .A2(net594),
    .B1(net593),
    .B2(net588),
    .Y(_142_));
 OR3x2_ASAP7_75t_R _291_ (.A(net599),
    .B(_139_),
    .C(net579),
    .Y(_105_));
 OR2x4_ASAP7_75t_R _292_ (.A(net577),
    .B(net579),
    .Y(_113_));
 OR2x2_ASAP7_75t_R _293_ (.A(_112_),
    .B(_111_),
    .Y(_143_));
 INVx2_ASAP7_75t_R _294_ (.A(net578),
    .Y(_108_));
 OR2x2_ASAP7_75t_R _295_ (.A(_105_),
    .B(_108_),
    .Y(_117_));
 OR3x1_ASAP7_75t_R _296_ (.A(_141_),
    .B(net579),
    .C(_108_),
    .Y(_125_));
 NOR2x2_ASAP7_75t_R _297_ (.A(net587),
    .B(net592),
    .Y(_120_));
 OR2x2_ASAP7_75t_R _298_ (.A(net579),
    .B(_120_),
    .Y(_144_));
 OR4x2_ASAP7_75t_R _299_ (.A(net599),
    .B(net582),
    .C(_108_),
    .D(_144_),
    .Y(_130_));
 OR4x2_ASAP7_75t_R _300_ (.A(_141_),
    .B(net579),
    .C(_108_),
    .D(_120_),
    .Y(_134_));
 INVx1_ASAP7_75t_R _301_ (.A(net601),
    .Y(_070_));
 AND3x1_ASAP7_75t_R _302_ (.A(_070_),
    .B(net596),
    .C(net595),
    .Y(_145_));
 AO21x1_ASAP7_75t_R _303_ (.A1(_074_),
    .A2(net582),
    .B(_145_),
    .Y(_083_));
 INVx1_ASAP7_75t_R _304_ (.A(net599),
    .Y(_146_));
 OR2x2_ASAP7_75t_R _305_ (.A(_146_),
    .B(net582),
    .Y(_086_));
 NAND2x1_ASAP7_75t_R _306_ (.A(net575),
    .B(net577),
    .Y(_091_));
 OR2x2_ASAP7_75t_R _307_ (.A(net582),
    .B(net581),
    .Y(_094_));
 AO21x1_ASAP7_75t_R _308_ (.A1(_140_),
    .A2(net577),
    .B(net581),
    .Y(_102_));
 OR2x4_ASAP7_75t_R _309_ (.A(_139_),
    .B(net579),
    .Y(_106_));
 AO21x1_ASAP7_75t_R _310_ (.A1(net573),
    .A2(net577),
    .B(net579),
    .Y(_114_));
 AO21x1_ASAP7_75t_R _311_ (.A1(_139_),
    .A2(net578),
    .B(net579),
    .Y(_118_));
 AO31x2_ASAP7_75t_R _312_ (.A1(net573),
    .A2(_141_),
    .A3(net578),
    .B(net579),
    .Y(_126_));
 AO21x1_ASAP7_75t_R _313_ (.A1(net582),
    .A2(net578),
    .B(_144_),
    .Y(_131_));
 AO31x2_ASAP7_75t_R _314_ (.A1(net573),
    .A2(net577),
    .A3(net578),
    .B(_144_),
    .Y(_135_));
 INVx2_ASAP7_75t_R _315_ (.A(net569),
    .Y(_032_));
 INVx1_ASAP7_75t_R _316_ (.A(net550),
    .Y(_038_));
 INVx2_ASAP7_75t_R _317_ (.A(net562),
    .Y(_037_));
 INVx1_ASAP7_75t_R _318_ (.A(_107_),
    .Y(_042_));
 INVx1_ASAP7_75t_R _319_ (.A(_115_),
    .Y(_045_));
 INVx1_ASAP7_75t_R _320_ (.A(net553),
    .Y(_049_));
 INVx1_ASAP7_75t_R _321_ (.A(_119_),
    .Y(_048_));
 INVx1_ASAP7_75t_R _322_ (.A(net547),
    .Y(_054_));
 INVx2_ASAP7_75t_R _323_ (.A(net560),
    .Y(_053_));
 INVx1_ASAP7_75t_R _324_ (.A(_132_),
    .Y(_059_));
 INVx1_ASAP7_75t_R _325_ (.A(_065_),
    .Y(_058_));
 INVx1_ASAP7_75t_R _326_ (.A(_066_),
    .Y(_062_));
 INVx1_ASAP7_75t_R _327_ (.A(_021_),
    .Y(_018_));
 INVx1_ASAP7_75t_R _328_ (.A(net570),
    .Y(_025_));
 INVx1_ASAP7_75t_R _329_ (.A(net567),
    .Y(_030_));
 INVx1_ASAP7_75t_R _330_ (.A(net563),
    .Y(_033_));
 BUFx2_ASAP7_75t_R wire633 (.A(net633),
    .Y(net632));
 NAND2x1_ASAP7_75t_R _333_ (.A(net591),
    .B(net608),
    .Y(_149_));
 OA21x2_ASAP7_75t_R _334_ (.A1(net608),
    .A2(net585),
    .B(_149_),
    .Y(\u_cpu.next_pc[0] ));
 INVx1_ASAP7_75t_R _335_ (.A(net551),
    .Y(_150_));
 OR3x1_ASAP7_75t_R _336_ (.A(_150_),
    .B(net554),
    .C(net556),
    .Y(_151_));
 NAND2x1_ASAP7_75t_R _337_ (.A(net554),
    .B(net556),
    .Y(_152_));
 INVx1_ASAP7_75t_R _338_ (.A(net533),
    .Y(_153_));
 OR3x1_ASAP7_75t_R _339_ (.A(_153_),
    .B(net440),
    .C(net541),
    .Y(_154_));
 AOI21x1_ASAP7_75t_R _340_ (.A1(net440),
    .A2(net541),
    .B(net608),
    .Y(_155_));
 AO32x1_ASAP7_75t_R _341_ (.A1(net608),
    .A2(_151_),
    .A3(_152_),
    .B1(_154_),
    .B2(_155_),
    .Y(\u_cpu.next_pc[10] ));
 INVx1_ASAP7_75t_R _342_ (.A(net554),
    .Y(_156_));
 AND3x1_ASAP7_75t_R _343_ (.A(net551),
    .B(_156_),
    .C(net556),
    .Y(_157_));
 AO21x1_ASAP7_75t_R _344_ (.A1(_150_),
    .A2(net554),
    .B(net95),
    .Y(_158_));
 INVx1_ASAP7_75t_R _345_ (.A(net440),
    .Y(_159_));
 AND3x1_ASAP7_75t_R _346_ (.A(net533),
    .B(_159_),
    .C(net541),
    .Y(_160_));
 AO21x1_ASAP7_75t_R _347_ (.A1(_153_),
    .A2(net440),
    .B(net608),
    .Y(_161_));
 OAI22x1_ASAP7_75t_R _348_ (.A1(_157_),
    .A2(_158_),
    .B1(_160_),
    .B2(_161_),
    .Y(\u_cpu.next_pc[11] ));
 OR3x1_ASAP7_75t_R _349_ (.A(net531),
    .B(net544),
    .C(net548),
    .Y(_162_));
 NAND2x1_ASAP7_75t_R _350_ (.A(net544),
    .B(net548),
    .Y(_163_));
 OR3x1_ASAP7_75t_R _351_ (.A(net529),
    .B(net536),
    .C(net540),
    .Y(_164_));
 AOI21x1_ASAP7_75t_R _352_ (.A1(net536),
    .A2(net540),
    .B(net606),
    .Y(_165_));
 AO32x1_ASAP7_75t_R _353_ (.A1(net606),
    .A2(_162_),
    .A3(_163_),
    .B1(_164_),
    .B2(_165_),
    .Y(\u_cpu.next_pc[12] ));
 INVx1_ASAP7_75t_R _354_ (.A(net548),
    .Y(_166_));
 OR3x1_ASAP7_75t_R _355_ (.A(net531),
    .B(net544),
    .C(_166_),
    .Y(_167_));
 NAND2x1_ASAP7_75t_R _356_ (.A(net531),
    .B(net544),
    .Y(_168_));
 INVx1_ASAP7_75t_R _357_ (.A(net540),
    .Y(_169_));
 OR3x1_ASAP7_75t_R _358_ (.A(net529),
    .B(net536),
    .C(_169_),
    .Y(_170_));
 AOI21x1_ASAP7_75t_R _359_ (.A1(net529),
    .A2(net536),
    .B(net606),
    .Y(_171_));
 AO32x1_ASAP7_75t_R _360_ (.A1(net606),
    .A2(_167_),
    .A3(_168_),
    .B1(_170_),
    .B2(_171_),
    .Y(\u_cpu.next_pc[13] ));
 INVx1_ASAP7_75t_R _361_ (.A(net535),
    .Y(_172_));
 OR3x1_ASAP7_75t_R _362_ (.A(_172_),
    .B(net543),
    .C(net546),
    .Y(_173_));
 NAND2x1_ASAP7_75t_R _363_ (.A(net543),
    .B(net546),
    .Y(_174_));
 INVx1_ASAP7_75t_R _364_ (.A(net532),
    .Y(_175_));
 OR3x1_ASAP7_75t_R _365_ (.A(_175_),
    .B(net534),
    .C(net539),
    .Y(_176_));
 AOI21x1_ASAP7_75t_R _366_ (.A1(net534),
    .A2(net539),
    .B(net606),
    .Y(_177_));
 AO32x1_ASAP7_75t_R _367_ (.A1(net606),
    .A2(_173_),
    .A3(_174_),
    .B1(_176_),
    .B2(_177_),
    .Y(\u_cpu.next_pc[14] ));
 INVx1_ASAP7_75t_R _368_ (.A(net543),
    .Y(_178_));
 AND3x1_ASAP7_75t_R _369_ (.A(net535),
    .B(_178_),
    .C(net546),
    .Y(_179_));
 AO21x1_ASAP7_75t_R _370_ (.A1(_172_),
    .A2(net543),
    .B(net95),
    .Y(_180_));
 INVx1_ASAP7_75t_R _371_ (.A(net534),
    .Y(_181_));
 AND3x1_ASAP7_75t_R _372_ (.A(net532),
    .B(_181_),
    .C(net539),
    .Y(_182_));
 AO21x1_ASAP7_75t_R _373_ (.A1(_175_),
    .A2(net534),
    .B(net606),
    .Y(_183_));
 OAI22x1_ASAP7_75t_R _374_ (.A1(_179_),
    .A2(_180_),
    .B1(_182_),
    .B2(_183_),
    .Y(\u_cpu.next_pc[15] ));
 AND2x2_ASAP7_75t_R _375_ (.A(net608),
    .B(net598),
    .Y(_184_));
 AOI21x1_ASAP7_75t_R _376_ (.A1(net591),
    .A2(net602),
    .B(_184_),
    .Y(\u_cpu.next_pc[1] ));
 INVx1_ASAP7_75t_R _377_ (.A(net574),
    .Y(_185_));
 INVx1_ASAP7_75t_R _378_ (.A(net337),
    .Y(_186_));
 AND3x1_ASAP7_75t_R _379_ (.A(_185_),
    .B(_186_),
    .C(net572),
    .Y(_187_));
 AO21x1_ASAP7_75t_R _380_ (.A1(net574),
    .A2(net336),
    .B(net608),
    .Y(_188_));
 OAI22x1_ASAP7_75t_R _381_ (.A1(net602),
    .A2(net598),
    .B1(_187_),
    .B2(_188_),
    .Y(\u_cpu.next_pc[2] ));
 AND3x1_ASAP7_75t_R _382_ (.A(net574),
    .B(_186_),
    .C(net572),
    .Y(_189_));
 OAI21x1_ASAP7_75t_R _383_ (.A1(_186_),
    .A2(net572),
    .B(net602),
    .Y(_190_));
 OAI22x1_ASAP7_75t_R _384_ (.A1(net602),
    .A2(_137_),
    .B1(_189_),
    .B2(_190_),
    .Y(\u_cpu.next_pc[3] ));
 INVx1_ASAP7_75t_R _385_ (.A(_017_),
    .Y(_191_));
 OR3x1_ASAP7_75t_R _386_ (.A(net599),
    .B(net571),
    .C(_191_),
    .Y(_192_));
 NAND2x1_ASAP7_75t_R _387_ (.A(net599),
    .B(net571),
    .Y(_193_));
 INVx1_ASAP7_75t_R _388_ (.A(net566),
    .Y(_194_));
 INVx1_ASAP7_75t_R _389_ (.A(_020_),
    .Y(_195_));
 OR3x1_ASAP7_75t_R _390_ (.A(_194_),
    .B(net458),
    .C(_195_),
    .Y(_196_));
 AOI21x1_ASAP7_75t_R _391_ (.A1(_194_),
    .A2(net458),
    .B(net607),
    .Y(_197_));
 AO32x1_ASAP7_75t_R _392_ (.A1(net607),
    .A2(_192_),
    .A3(_193_),
    .B1(_196_),
    .B2(_197_),
    .Y(\u_cpu.next_pc[4] ));
 OR3x1_ASAP7_75t_R _393_ (.A(_146_),
    .B(net571),
    .C(_191_),
    .Y(_198_));
 NAND2x1_ASAP7_75t_R _394_ (.A(net571),
    .B(_191_),
    .Y(_199_));
 OR3x1_ASAP7_75t_R _395_ (.A(net566),
    .B(net458),
    .C(_195_),
    .Y(_200_));
 AOI21x1_ASAP7_75t_R _396_ (.A1(net458),
    .A2(_195_),
    .B(net607),
    .Y(_201_));
 AO32x1_ASAP7_75t_R _397_ (.A1(net607),
    .A2(_198_),
    .A3(_199_),
    .B1(_200_),
    .B2(_201_),
    .Y(\u_cpu.next_pc[5] ));
 INVx1_ASAP7_75t_R _398_ (.A(net568),
    .Y(_202_));
 AND3x1_ASAP7_75t_R _399_ (.A(net294),
    .B(net564),
    .C(_202_),
    .Y(_203_));
 OAI21x1_ASAP7_75t_R _400_ (.A1(net291),
    .A2(_202_),
    .B(net607),
    .Y(_204_));
 INVx1_ASAP7_75t_R _401_ (.A(net565),
    .Y(_205_));
 AND3x1_ASAP7_75t_R _402_ (.A(net260),
    .B(net558),
    .C(_205_),
    .Y(_206_));
 OAI21x1_ASAP7_75t_R _403_ (.A1(net259),
    .A2(_205_),
    .B(net95),
    .Y(_207_));
 OAI22x1_ASAP7_75t_R _404_ (.A1(_203_),
    .A2(_204_),
    .B1(_206_),
    .B2(_207_),
    .Y(\u_cpu.next_pc[6] ));
 AND3x1_ASAP7_75t_R _405_ (.A(net292),
    .B(net564),
    .C(net568),
    .Y(_208_));
 OAI21x1_ASAP7_75t_R _406_ (.A1(net290),
    .A2(net564),
    .B(net607),
    .Y(_209_));
 AND3x1_ASAP7_75t_R _407_ (.A(net263),
    .B(net558),
    .C(net565),
    .Y(_210_));
 OAI21x1_ASAP7_75t_R _408_ (.A1(net262),
    .A2(net558),
    .B(net602),
    .Y(_211_));
 OAI22x1_ASAP7_75t_R _409_ (.A1(_208_),
    .A2(_209_),
    .B1(_210_),
    .B2(_211_),
    .Y(\u_cpu.next_pc[7] ));
 OR3x1_ASAP7_75t_R _410_ (.A(net538),
    .B(net555),
    .C(net557),
    .Y(_212_));
 NAND2x1_ASAP7_75t_R _411_ (.A(net555),
    .B(net557),
    .Y(_213_));
 OR3x1_ASAP7_75t_R _412_ (.A(net530),
    .B(net537),
    .C(net542),
    .Y(_214_));
 AOI21x1_ASAP7_75t_R _413_ (.A1(net537),
    .A2(net542),
    .B(net607),
    .Y(_215_));
 AO32x1_ASAP7_75t_R _414_ (.A1(net607),
    .A2(_212_),
    .A3(_213_),
    .B1(_214_),
    .B2(_215_),
    .Y(\u_cpu.next_pc[8] ));
 INVx1_ASAP7_75t_R _415_ (.A(net557),
    .Y(_216_));
 OR3x1_ASAP7_75t_R _416_ (.A(net538),
    .B(net555),
    .C(_216_),
    .Y(_217_));
 NAND2x1_ASAP7_75t_R _417_ (.A(net538),
    .B(net555),
    .Y(_218_));
 INVx1_ASAP7_75t_R _418_ (.A(net542),
    .Y(_219_));
 OR3x1_ASAP7_75t_R _419_ (.A(net530),
    .B(net537),
    .C(_219_),
    .Y(_220_));
 AOI21x1_ASAP7_75t_R _420_ (.A1(net530),
    .A2(net537),
    .B(net607),
    .Y(_221_));
 AO32x1_ASAP7_75t_R _421_ (.A1(net607),
    .A2(_217_),
    .A3(_218_),
    .B1(_220_),
    .B2(_221_),
    .Y(\u_cpu.next_pc[9] ));
 FAx1_ASAP7_75t_R _422_ (.SN(_012_),
    .A(net576),
    .B(net584),
    .CI(net585),
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
    .CI(net570),
    .CON(_223_));
 FAx1_ASAP7_75t_R _426_ (.SN(_224_),
    .A(net71),
    .B(_022_),
    .CI(_025_),
    .CON(_026_));
 FAx1_ASAP7_75t_R _427_ (.SN(_029_),
    .A(net72),
    .B(_027_),
    .CI(net567),
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
    .CI(net563),
    .CON(_036_));
 FAx1_ASAP7_75t_R _431_ (.SN(_039_),
    .A(net4),
    .B(_037_),
    .CI(_038_),
    .CON(_229_));
 FAx1_ASAP7_75t_R _432_ (.SN(_230_),
    .A(net5),
    .B(_037_),
    .CI(net550),
    .CON(_041_));
 FAx1_ASAP7_75t_R _433_ (.SN(_044_),
    .A(net6),
    .B(_042_),
    .CI(net561),
    .CON(_043_));
 FAx1_ASAP7_75t_R _434_ (.SN(_047_),
    .A(net7),
    .B(_045_),
    .CI(net549),
    .CON(_046_));
 FAx1_ASAP7_75t_R _435_ (.SN(_050_),
    .A(net8),
    .B(net559),
    .CI(_049_),
    .CON(_233_));
 FAx1_ASAP7_75t_R _436_ (.SN(_234_),
    .A(net9),
    .B(net559),
    .CI(net553),
    .CON(_052_));
 FAx1_ASAP7_75t_R _437_ (.SN(_055_),
    .A(net10),
    .B(_053_),
    .CI(_054_),
    .CON(_235_));
 FAx1_ASAP7_75t_R _438_ (.SN(_236_),
    .A(net11),
    .B(_053_),
    .CI(net547),
    .CON(_057_));
 FAx1_ASAP7_75t_R _439_ (.SN(_061_),
    .A(net583),
    .B(_059_),
    .CI(net552),
    .CON(_060_));
 FAx1_ASAP7_75t_R _440_ (.SN(_064_),
    .A(net583),
    .B(_062_),
    .CI(net545),
    .CON(_063_));
 HAxp5_ASAP7_75t_R _441_ (.A(net605),
    .B(net103),
    .CON(_068_),
    .SN(_069_));
 HAxp5_ASAP7_75t_R _442_ (.A(net605),
    .B(net103),
    .CON(_014_),
    .SN(_239_));
 HAxp5_ASAP7_75t_R _443_ (.A(net96),
    .B(net604),
    .CON(_072_),
    .SN(_240_));
 HAxp5_ASAP7_75t_R _444_ (.A(net96),
    .B(net604),
    .CON(_073_),
    .SN(_241_));
 HAxp5_ASAP7_75t_R _445_ (.A(_074_),
    .B(_070_),
    .CON(_222_),
    .SN(_075_));
 HAxp5_ASAP7_75t_R _446_ (.A(net595),
    .B(_010_),
    .CON(_076_),
    .SN(_242_));
 HAxp5_ASAP7_75t_R _447_ (.A(_078_),
    .B(net105),
    .CON(_079_),
    .SN(_080_));
 HAxp5_ASAP7_75t_R _448_ (.A(net104),
    .B(net603),
    .CON(_082_),
    .SN(_243_));
 HAxp5_ASAP7_75t_R _449_ (.A(net104),
    .B(net603),
    .CON(_013_),
    .SN(_244_));
 HAxp5_ASAP7_75t_R _450_ (.A(net596),
    .B(_083_),
    .CON(_021_),
    .SN(_084_));
 HAxp5_ASAP7_75t_R _451_ (.A(net581),
    .B(_086_),
    .CON(_023_),
    .SN(_087_));
 HAxp5_ASAP7_75t_R _452_ (.A(_088_),
    .B(net109),
    .CON(_089_),
    .SN(_090_));
 HAxp5_ASAP7_75t_R _453_ (.A(net581),
    .B(_091_),
    .CON(_028_),
    .SN(_092_));
 HAxp5_ASAP7_75t_R _454_ (.A(_093_),
    .B(_094_),
    .CON(_095_),
    .SN(_245_));
 HAxp5_ASAP7_75t_R _455_ (.A(net580),
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
 HAxp5_ASAP7_75t_R _458_ (.A(net580),
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
 HAxp5_ASAP7_75t_R _471_ (.A(net586),
    .B(_252_),
    .CON(_237_),
    .SN(_133_));
 HAxp5_ASAP7_75t_R _472_ (.A(_134_),
    .B(_135_),
    .CON(_066_),
    .SN(_253_));
 HAxp5_ASAP7_75t_R _473_ (.A(net586),
    .B(net630),
    .CON(_238_),
    .SN(_136_));
 TIEHIx1_ASAP7_75t_R _423__69 (.H(net68));
 BUFx2_ASAP7_75t_R wire629 (.A(net629),
    .Y(net628));
 BUFx3_ASAP7_75t_R place536 (.A(net628),
    .Y(net535));
 BUFx2_ASAP7_75t_R wire631 (.A(_253_),
    .Y(net630));
 BUFx2_ASAP7_75t_R wire630 (.A(_061_),
    .Y(net629));
 BUFx3_ASAP7_75t_R place537 (.A(_057_),
    .Y(net536));
 BUFx3_ASAP7_75t_R place535 (.A(net624),
    .Y(net534));
 BUFx2_ASAP7_75t_R wire639 (.A(net639),
    .Y(net638));
 BUFx2_ASAP7_75t_R wire638 (.A(_043_),
    .Y(net637));
 BUFx2_ASAP7_75t_R wire637 (.A(_026_),
    .Y(net636));
 BUFx2_ASAP7_75t_R wire636 (.A(_044_),
    .Y(net635));
 BUFx2_ASAP7_75t_R wire635 (.A(net635),
    .Y(net634));
 BUFx3_ASAP7_75t_R place533 (.A(_064_),
    .Y(net532));
 BUFx3_ASAP7_75t_R place534 (.A(net611),
    .Y(net533));
 BUFx3_ASAP7_75t_R place532 (.A(net626),
    .Y(net531));
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
 BUFx2_ASAP7_75t_R output96 (.A(net95),
    .Y(ipc_out[1]));
 BUFx4f_ASAP7_75t_R input95 (.A(rst_n),
    .Y(net94));
 BUFx3_ASAP7_75t_R place605 (.A(_071_),
    .Y(net604));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.id_ex_valid_a$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(net95),
    .QN(_001_),
    .RESETN(net94),
    .SETN(net74));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.if_id_valid_b$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(net75),
    .QN(_002_),
    .RESETN(net610),
    .SETN(net76));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[0]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[0] ),
    .QN(_067_),
    .RESETN(net609),
    .SETN(net77));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[10]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[10] ),
    .QN(_110_),
    .RESETN(net609),
    .SETN(net78));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[11]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[11] ),
    .QN(_003_),
    .RESETN(net609),
    .SETN(net79));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[12]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[12] ),
    .QN(_122_),
    .RESETN(net610),
    .SETN(net80));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[13]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[13] ),
    .QN(_004_),
    .RESETN(net610),
    .SETN(net81));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[14]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[14] ),
    .QN(_129_),
    .RESETN(net610),
    .SETN(net82));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[15]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[15] ),
    .QN(_005_),
    .RESETN(net610),
    .SETN(net83));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[1]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[1] ),
    .QN(_071_),
    .RESETN(net609),
    .SETN(net84));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[2]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[2] ),
    .QN(_078_),
    .RESETN(net609),
    .SETN(net85));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[3]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[3] ),
    .QN(_081_),
    .RESETN(net609),
    .SETN(net86));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[4]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[4] ),
    .QN(_077_),
    .RESETN(net609),
    .SETN(net87));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[5]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[5] ),
    .QN(_006_),
    .RESETN(net94),
    .SETN(net88));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[6]$_DFF_PN0_  (.CLK(clknet_1_1__leaf_clk),
    .D(\u_cpu.next_pc[6] ),
    .QN(_088_),
    .RESETN(net94),
    .SETN(net89));
 DFFASRHQNx1_ASAP7_75t_R \u_cpu.imem_addr[7]$_DFF_PN0_  (.CLK(clknet_1_0__leaf_clk),
    .D(\u_cpu.next_pc[7] ),
    .QN(_007_),
    .RESETN(net94),
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
    .RESETN(net610),
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
 BUFx3_ASAP7_75t_R place441 (.A(net625),
    .Y(net440));
 BUFx3_ASAP7_75t_R place539 (.A(_034_),
    .Y(net538));
 BUFx3_ASAP7_75t_R place540 (.A(_136_),
    .Y(net539));
 BUFx3_ASAP7_75t_R place541 (.A(_128_),
    .Y(net540));
 BUFx3_ASAP7_75t_R place542 (.A(_116_),
    .Y(net541));
 BUFx3_ASAP7_75t_R place543 (.A(_104_),
    .Y(net542));
 BUFx3_ASAP7_75t_R place544 (.A(_060_),
    .Y(net543));
 BUFx3_ASAP7_75t_R place547 (.A(_133_),
    .Y(net546));
 BUFx2_ASAP7_75t_R wire622 (.A(_047_),
    .Y(net621));
 BUFx3_ASAP7_75t_R place545 (.A(_052_),
    .Y(net544));
 BUFx2_ASAP7_75t_R wire623 (.A(net623),
    .Y(net622));
 BUFx2_ASAP7_75t_R wire624 (.A(_039_),
    .Y(net623));
 BUFx2_ASAP7_75t_R wire625 (.A(_063_),
    .Y(net624));
 BUFx2_ASAP7_75t_R wire627 (.A(net627),
    .Y(net626));
 BUFx3_ASAP7_75t_R place546 (.A(_238_),
    .Y(net545));
 BUFx2_ASAP7_75t_R clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .Y(clknet_1_0__leaf_clk));
 BUFx2_ASAP7_75t_R clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .Y(clknet_1_1__leaf_clk));
 BUFx12_ASAP7_75t_R clkload0 (.A(clknet_1_0__leaf_clk));
 BUFx2_ASAP7_75t_R wire617 (.A(net617),
    .Y(net616));
 BUFx2_ASAP7_75t_R wire618 (.A(_055_),
    .Y(net617));
 BUFx2_ASAP7_75t_R wire620 (.A(net620),
    .Y(net619));
 BUFx3_ASAP7_75t_R place548 (.A(_056_),
    .Y(net547));
 BUFx3_ASAP7_75t_R place549 (.A(_121_),
    .Y(net548));
 BUFx3_ASAP7_75t_R place550 (.A(_232_),
    .Y(net549));
 BUFx3_ASAP7_75t_R place551 (.A(_040_),
    .Y(net550));
 BUFx3_ASAP7_75t_R place552 (.A(net631),
    .Y(net551));
 BUFx3_ASAP7_75t_R place553 (.A(_237_),
    .Y(net552));
 BUFx3_ASAP7_75t_R place554 (.A(_051_),
    .Y(net553));
 BUFx3_ASAP7_75t_R place555 (.A(net637),
    .Y(net554));
 BUFx3_ASAP7_75t_R place556 (.A(_036_),
    .Y(net555));
 BUFx3_ASAP7_75t_R place557 (.A(_109_),
    .Y(net556));
 BUFx3_ASAP7_75t_R place459 (.A(_019_),
    .Y(net458));
 BUFx2_ASAP7_75t_R wire260 (.A(net261),
    .Y(net259));
 BUFx2_ASAP7_75t_R max_cap261 (.A(net261),
    .Y(net260));
 BUFx2_ASAP7_75t_R wire262 (.A(net265),
    .Y(net261));
 BUFx2_ASAP7_75t_R max_cap263 (.A(net263),
    .Y(net262));
 BUFx2_ASAP7_75t_R wire264 (.A(net264),
    .Y(net263));
 BUFx2_ASAP7_75t_R max_cap265 (.A(net265),
    .Y(net264));
 BUFx2_ASAP7_75t_R wire266 (.A(_031_),
    .Y(net265));
 BUFx3_ASAP7_75t_R place558 (.A(_097_),
    .Y(net557));
 BUFx3_ASAP7_75t_R place559 (.A(_029_),
    .Y(net558));
 BUFx3_ASAP7_75t_R place560 (.A(_048_),
    .Y(net559));
 BUFx2_ASAP7_75t_R clkbuf_0_clk (.A(clk),
    .Y(clknet_0_clk));
 BUFx3_ASAP7_75t_R place564 (.A(_035_),
    .Y(net563));
 BUFx3_ASAP7_75t_R place561 (.A(_127_),
    .Y(net560));
 BUFx3_ASAP7_75t_R place565 (.A(_024_),
    .Y(net564));
 BUFx2_ASAP7_75t_R wire291 (.A(net296),
    .Y(net290));
 BUFx2_ASAP7_75t_R wire292 (.A(net293),
    .Y(net291));
 BUFx2_ASAP7_75t_R max_cap293 (.A(net293),
    .Y(net292));
 BUFx2_ASAP7_75t_R wire294 (.A(net295),
    .Y(net293));
 BUFx2_ASAP7_75t_R max_cap295 (.A(net295),
    .Y(net294));
 BUFx2_ASAP7_75t_R wire296 (.A(net524),
    .Y(net295));
 BUFx2_ASAP7_75t_R max_cap297 (.A(net525),
    .Y(net296));
 BUFx3_ASAP7_75t_R place563 (.A(_103_),
    .Y(net562));
 BUFx3_ASAP7_75t_R place562 (.A(_231_),
    .Y(net561));
 BUFx3_ASAP7_75t_R place566 (.A(_092_),
    .Y(net565));
 BUFx3_ASAP7_75t_R place567 (.A(_084_),
    .Y(net566));
 BUFx3_ASAP7_75t_R place568 (.A(_028_),
    .Y(net567));
 BUFx3_ASAP7_75t_R place569 (.A(_087_),
    .Y(net568));
 BUFx3_ASAP7_75t_R place570 (.A(_095_),
    .Y(net569));
 BUFx3_ASAP7_75t_R place572 (.A(_016_),
    .Y(net571));
 BUFx3_ASAP7_75t_R place571 (.A(_023_),
    .Y(net570));
 BUFx3_ASAP7_75t_R place573 (.A(net638),
    .Y(net572));
 BUFx3_ASAP7_75t_R place574 (.A(_140_),
    .Y(net573));
 BUFx3_ASAP7_75t_R place575 (.A(_075_),
    .Y(net574));
 BUFx2_ASAP7_75t_R max_cap337 (.A(net337),
    .Y(net336));
 BUFx2_ASAP7_75t_R wire338 (.A(_011_),
    .Y(net337));
 BUFx3_ASAP7_75t_R place576 (.A(_076_),
    .Y(net575));
 BUFx3_ASAP7_75t_R place577 (.A(_222_),
    .Y(net576));
 BUFx3_ASAP7_75t_R place578 (.A(_141_),
    .Y(net577));
 BUFx3_ASAP7_75t_R place579 (.A(_143_),
    .Y(net578));
 BUFx3_ASAP7_75t_R place580 (.A(_142_),
    .Y(net579));
 BUFx3_ASAP7_75t_R place581 (.A(_096_),
    .Y(net580));
 BUFx3_ASAP7_75t_R place583 (.A(_139_),
    .Y(net582));
 BUFx3_ASAP7_75t_R place588 (.A(_124_),
    .Y(net587));
 BUFx3_ASAP7_75t_R place587 (.A(_251_),
    .Y(net586));
 BUFx3_ASAP7_75t_R place584 (.A(_058_),
    .Y(net583));
 BUFx3_ASAP7_75t_R place585 (.A(_009_),
    .Y(net584));
 BUFx3_ASAP7_75t_R place586 (.A(_010_),
    .Y(net585));
 BUFx3_ASAP7_75t_R place589 (.A(_100_),
    .Y(net588));
 BUFx3_ASAP7_75t_R place590 (.A(_090_),
    .Y(net589));
 BUFx3_ASAP7_75t_R place591 (.A(_080_),
    .Y(net590));
 BUFx3_ASAP7_75t_R place592 (.A(_069_),
    .Y(net591));
 BUFx3_ASAP7_75t_R place593 (.A(_123_),
    .Y(net592));
 BUFx3_ASAP7_75t_R place594 (.A(_099_),
    .Y(net593));
 BUFx3_ASAP7_75t_R place595 (.A(_089_),
    .Y(net594));
 BUFx3_ASAP7_75t_R place596 (.A(_013_),
    .Y(net595));
 BUFx3_ASAP7_75t_R place597 (.A(_082_),
    .Y(net596));
 BUFx3_ASAP7_75t_R place598 (.A(_079_),
    .Y(net597));
 BUFx3_ASAP7_75t_R place599 (.A(_073_),
    .Y(net598));
 BUFx3_ASAP7_75t_R place600 (.A(_072_),
    .Y(net599));
 BUFx3_ASAP7_75t_R place601 (.A(_014_),
    .Y(net600));
 BUFx3_ASAP7_75t_R place602 (.A(_068_),
    .Y(net601));
 BUFx3_ASAP7_75t_R place603 (.A(net95),
    .Y(net602));
 BUFx2_ASAP7_75t_R wire614 (.A(net614),
    .Y(net613));
 BUFx3_ASAP7_75t_R place604 (.A(_081_),
    .Y(net603));
 BUFx2_ASAP7_75t_R wire613 (.A(net613),
    .Y(net612));
 BUFx3_ASAP7_75t_R place611 (.A(net94),
    .Y(net610));
 BUFx3_ASAP7_75t_R place610 (.A(net94),
    .Y(net609));
 BUFx3_ASAP7_75t_R place609 (.A(net607),
    .Y(net608));
 BUFx6f_ASAP7_75t_R place608 (.A(net606),
    .Y(net607));
 BUFx3_ASAP7_75t_R place606 (.A(_067_),
    .Y(net605));
 BUFx6f_ASAP7_75t_R place607 (.A(_002_),
    .Y(net606));
 BUFx2_ASAP7_75t_R wire615 (.A(net615),
    .Y(net614));
 BUFx2_ASAP7_75t_R wire619 (.A(net619),
    .Y(net618));
 BUFx2_ASAP7_75t_R wire628 (.A(_050_),
    .Y(net627));
 BUFx2_ASAP7_75t_R wire612 (.A(net612),
    .Y(net611));
 BUFx2_ASAP7_75t_R wire632 (.A(net632),
    .Y(net631));
 BUFx2_ASAP7_75t_R wire626 (.A(_046_),
    .Y(net625));
 BUFx2_ASAP7_75t_R wire634 (.A(net634),
    .Y(net633));
 BUFx2_ASAP7_75t_R wire526 (.A(net636),
    .Y(net525));
 BUFx2_ASAP7_75t_R max_cap525 (.A(net525),
    .Y(net524));
 BUFx2_ASAP7_75t_R wire621 (.A(net621),
    .Y(net620));
 BUFx3_ASAP7_75t_R place582 (.A(_085_),
    .Y(net581));
 BUFx2_ASAP7_75t_R wire616 (.A(net618),
    .Y(net615));
 BUFx3_ASAP7_75t_R place530 (.A(net616),
    .Y(net529));
 BUFx2_ASAP7_75t_R wire640 (.A(_012_),
    .Y(net639));
 BUFx3_ASAP7_75t_R place531 (.A(net622),
    .Y(net530));
endmodule
