module xillydemo
  (
  input  clk_100,
  input  otg_oc,   
  inout [55:0] PS_GPIO,
  output [3:0] GPIO_LED,
  output [4:0] vga4_blue,
  output [5:0] vga4_green,
  output [4:0] vga4_red,
  output  vga_hsync,
  output  vga_vsync,
  output  audio_mclk,
  output  audio_dac,
  input  audio_adc,
  input  audio_bclk,
  input  audio_adc_lrclk,
  input  audio_dac_lrclk,
  output  audio_mute,
  output  hdmi_clk_p,
  output  hdmi_clk_n,
  output [2:0] hdmi_d_p,
  output [2:0] hdmi_d_n,
  output  hdmi_out_en,
  inout  smb_sclk,
  inout  smb_sdata   
  ); 
  
  
  // Cosine
  wire ina;
  wire inb;
  wire [31:0] inc;
  wire [31:0] ind;
  wire [31:0] out_cosine;
  wire cosine_flag;
  wire [31:0] control;
  // Memory arrays
  reg [7:0] demoarray[0:31];
   
  reg [7:0] litearray0[0:31];
  reg [7:0] litearray1[0:31];
  reg [7:0] litearray2[0:31];
  reg [7:0] litearray3[0:31];
  // Clock and quiesce
  reg [31:0] user_r_mem_8_data;
  reg [31:0] user_rd_data;
    // Clock and quiesce
  wire  bus_clk;
  wire  quiesce;


  // Wires related to /dev/xillybus_audio
  wire  user_r_audio_rden;
  wire  user_r_audio_empty;
  wire [31:0] user_r_audio_data;
  wire  user_r_audio_eof;
  wire  user_r_audio_open;
  wire  user_w_audio_wren;
  wire  user_w_audio_full;
  wire [31:0] user_w_audio_data;
  wire  user_w_audio_open;

  // Wires related to /dev/xillybus_mem_8
  wire  user_r_mem_8_rden;
  wire  user_r_mem_8_empty;
  wire  user_r_mem_8_eof;
  wire  user_r_mem_8_open;
  wire  user_w_mem_8_wren;
  wire  user_w_mem_8_full;
  wire [7:0] user_w_mem_8_data;
  wire  user_w_mem_8_open;
  wire [4:0] user_mem_8_addr;
  wire  user_mem_8_addr_update;

  // Wires related to /dev/xillybus_read_32_result
  wire  user_r_read_32_result_rden;
  wire  user_r_read_32_result_empty;
  wire [31:0] user_r_read_32_result_data;
  wire  user_r_read_32_result_eof;
  wire  user_r_read_32_result_open;

  // Wires related to /dev/xillybus_read_8
  wire  user_r_read_8_rden;
  wire  user_r_read_8_empty;
  wire [7:0] user_r_read_8_data;
  wire  user_r_read_8_eof;
  wire  user_r_read_8_open;

  // Wires related to /dev/xillybus_smb
  wire  user_r_smb_rden;
  wire  user_r_smb_empty;
  wire [7:0] user_r_smb_data;
  wire  user_r_smb_eof;
  wire  user_r_smb_open;
  wire  user_w_smb_wren;
  wire  user_w_smb_full;
  wire [7:0] user_w_smb_data;
  wire  user_w_smb_open;

  // Wires related to /dev/xillybus_write_32_a
  wire  user_w_write_32_a_wren;
  wire  user_w_write_32_a_full;
  wire [31:0] user_w_write_32_a_data;
  wire  user_w_write_32_a_open;

  // Wires related to /dev/xillybus_write_32_b
  wire  user_w_write_32_b_wren;
  wire  user_w_write_32_b_full;
  wire [31:0] user_w_write_32_b_data;
  wire  user_w_write_32_b_open;

  // Wires related to /dev/xillybus_write_8
  wire  user_w_write_8_wren;
  wire  user_w_write_8_full;
  wire [7:0] user_w_write_8_data;
  wire  user_w_write_8_open;

  // Wires related to Xillybus Lite
  wire  user_clk;
  wire  user_wren;
  wire  user_rden;
  wire [3:0] user_wstrb;
  wire [31:0] user_addr;
  wire [31:0] user_wr_data;
  wire  user_irq;


  xillybus xillybus_ins (

    // Ports related to /dev/xillybus_audio
    // FPGA to CPU signals:
    .user_r_audio_rden(user_r_audio_rden),
    .user_r_audio_empty(user_r_audio_empty),
    .user_r_audio_data(user_r_audio_data),
    .user_r_audio_eof(user_r_audio_eof),
    .user_r_audio_open(user_r_audio_open),

    // CPU to FPGA signals:
    .user_w_audio_wren(user_w_audio_wren),
    .user_w_audio_full(user_w_audio_full),
    .user_w_audio_data(user_w_audio_data),
    .user_w_audio_open(user_w_audio_open),


    // Ports related to /dev/xillybus_mem_8
    // FPGA to CPU signals:
    .user_r_mem_8_rden(user_r_mem_8_rden),
    .user_r_mem_8_empty(user_r_mem_8_empty),
    .user_r_mem_8_data(user_r_mem_8_data),
    .user_r_mem_8_eof(user_r_mem_8_eof),
    .user_r_mem_8_open(user_r_mem_8_open),

    // CPU to FPGA signals:
    .user_w_mem_8_wren(user_w_mem_8_wren),
    .user_w_mem_8_full(user_w_mem_8_full),
    .user_w_mem_8_data(user_w_mem_8_data),
    .user_w_mem_8_open(user_w_mem_8_open),

    // Address signals:
    .user_mem_8_addr(user_mem_8_addr),
    .user_mem_8_addr_update(user_mem_8_addr_update),


    // Ports related to /dev/xillybus_read_32_result
    // FPGA to CPU signals:
    .user_r_read_32_result_rden(user_r_read_32_result_rden),
    .user_r_read_32_result_empty(user_r_read_32_result_empty),
    .user_r_read_32_result_data(user_r_read_32_result_data),
    .user_r_read_32_result_eof(user_r_read_32_result_eof),
    .user_r_read_32_result_open(user_r_read_32_result_open),


    // Ports related to /dev/xillybus_read_8
    // FPGA to CPU signals:
    .user_r_read_8_rden(user_r_read_8_rden),
    .user_r_read_8_empty(user_r_read_8_empty),
    .user_r_read_8_data(user_r_read_8_data),
    .user_r_read_8_eof(user_r_read_8_eof),
    .user_r_read_8_open(user_r_read_8_open),


    // Ports related to /dev/xillybus_smb
    // FPGA to CPU signals:
    .user_r_smb_rden(user_r_smb_rden),
    .user_r_smb_empty(user_r_smb_empty),
    .user_r_smb_data(user_r_smb_data),
    .user_r_smb_eof(user_r_smb_eof),
    .user_r_smb_open(user_r_smb_open),

    // CPU to FPGA signals:
    .user_w_smb_wren(user_w_smb_wren),
    .user_w_smb_full(user_w_smb_full),
    .user_w_smb_data(user_w_smb_data),
    .user_w_smb_open(user_w_smb_open),


    // Ports related to /dev/xillybus_write_32_a
    // CPU to FPGA signals:
    .user_w_write_32_a_wren(user_w_write_32_a_wren),
    .user_w_write_32_a_full(user_w_write_32_a_full),
    .user_w_write_32_a_data(user_w_write_32_a_data),
    .user_w_write_32_a_open(user_w_write_32_a_open),


    // Ports related to /dev/xillybus_write_32_b
    // CPU to FPGA signals:
    .user_w_write_32_b_wren(user_w_write_32_b_wren),
    .user_w_write_32_b_full(user_w_write_32_b_full),
    .user_w_write_32_b_data(user_w_write_32_b_data),
    .user_w_write_32_b_open(user_w_write_32_b_open),


    // Ports related to /dev/xillybus_write_8
    // CPU to FPGA signals:
    .user_w_write_8_wren(user_w_write_8_wren),
    .user_w_write_8_full(user_w_write_8_full),
    .user_w_write_8_data(user_w_write_8_data),
    .user_w_write_8_open(user_w_write_8_open),


    // Ports related to Xillybus Lite
    .user_clk(user_clk),
    .user_wren(user_wren),
    .user_rden(user_rden),
    .user_wstrb(user_wstrb),
    .user_addr(user_addr),
    .user_rd_data(user_rd_data),
    .user_wr_data(user_wr_data),
    .user_irq(user_irq),


    // General signals
    .PS_CLK(PS_CLK),
    .PS_PORB(PS_PORB),
    .PS_SRSTB(PS_SRSTB),
    .clk_100(clk_100),
    .otg_oc(otg_oc),
    .DDR_Addr(DDR_Addr),
    .DDR_BankAddr(DDR_BankAddr),
    .DDR_CAS_n(DDR_CAS_n),
    .DDR_CKE(DDR_CKE),
    .DDR_CS_n(DDR_CS_n),
    .DDR_Clk(DDR_Clk),
    .DDR_Clk_n(DDR_Clk_n),
    .DDR_DM(DDR_DM),
    .DDR_DQ(DDR_DQ),
    .DDR_DQS(DDR_DQS),
    .DDR_DQS_n(DDR_DQS_n),
    .DDR_DRSTB(DDR_DRSTB),
    .DDR_ODT(DDR_ODT),
    .DDR_RAS_n(DDR_RAS_n),
    .DDR_VRN(DDR_VRN),
    .DDR_VRP(DDR_VRP),
    .MIO(MIO),
    .PS_GPIO(PS_GPIO),
    .DDR_WEB(DDR_WEB),
    .GPIO_LED(GPIO_LED),
    .bus_clk(bus_clk),
    .hdmi_clk_n(hdmi_clk_n),
    .hdmi_clk_p(hdmi_clk_p),
    .hdmi_d_n(hdmi_d_n),
    .hdmi_d_p(hdmi_d_p),
    .hdmi_out_en(hdmi_out_en),
    .quiesce(quiesce),
    .vga4_blue(vga4_blue),
    .vga4_green(vga4_green),
    .vga4_red(vga4_red),
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync)
  );

   assign      user_irq = 0; // No interrupts for now
   
   always @(posedge user_clk)
     begin
	if (user_wstrb[0])
	  litearray0[user_addr[6:2]] <= user_wr_data[7:0];

	if (user_wstrb[1])
	  litearray1[user_addr[6:2]] <= user_wr_data[15:8];

	if (user_wstrb[2])
	  litearray2[user_addr[6:2]] <= user_wr_data[23:16];

	if (user_wstrb[3])
	  litearray3[user_addr[6:2]] <= user_wr_data[31:24];
	
	if (user_rden)
	  user_rd_data <= { litearray3[user_addr[6:2]],
			    litearray2[user_addr[6:2]],
			    litearray1[user_addr[6:2]],
			    litearray0[user_addr[6:2]] };
     end
   
   // A simple inferred RAM
   always @(posedge bus_clk)
     begin
	if (user_w_mem_8_wren)
	  demoarray[user_mem_8_addr] <= user_w_mem_8_data;
	
	if (user_r_mem_8_rden)
	  user_r_mem_8_data <= demoarray[user_mem_8_addr];	  
     end

   assign  user_r_mem_8_empty = 0;
   assign  user_r_mem_8_eof = 0;
   assign  user_w_mem_8_full = 0;
   // 32-bit loopback
   // Ghi gia tri vao chan valid b cua floating point
   // 32-bit loopback
  wire fifo_host_to_fpga_rden_1st, fifo_host_to_fpga_empty_1st;
  wire fifo_host_to_fpga_rden_2nd, fifo_host_to_fpga_empty_2nd;
  wire fifo_fpga_to_host_wren, fifo_fpga_to_host_full;
  wire [31:0] fifo_host_to_fpga_dout_1st, fifo_host_to_fpga_dout_2nd;
  wire [31:0] fifo_fpga_to_host_din;

  fifo_32x512 fifo_a
     (
      .clk(bus_clk),
      .srst(!user_w_write_32_a_open && !user_r_read_32_result_open && !user_w_write_32_b_open),
      .din(user_w_write_32_a_data),
      .wr_en(user_w_write_32_a_wren),
      .rd_en(fifo_host_to_fpga_rden_1st),
      .dout(fifo_host_to_fpga_dout_1st),
      .full(user_w_write_32_a_full),
      .empty(fifo_host_to_fpga_empty_1st)
      );

  fifo_32x512 fifo_b
     (
      .clk(bus_clk),
      .srst(!user_w_write_32_a_open && !user_r_read_32_result_open && !user_w_write_32_b_open),
      .din(user_w_write_32_b_data),
      .wr_en(user_w_write_32_b_wren),
      .rd_en(fifo_host_to_fpga_rden_2nd),
      .dout(fifo_host_to_fpga_dout_2nd),
      .full(user_w_write_32_b_full),
      .empty(fifo_host_to_fpga_empty_2nd)
      );
 mac_module mac_1(
    .bus_clk(bus_clk),
    .rst(!user_w_write_32_a_open && !user_r_read_32_result_open && !user_w_write_32_b_open),
    .fifo_host_to_fpga_rden_1st(fifo_host_to_fpga_rden_1st), 
    .fifo_host_to_fpga_empty_1st(fifo_host_to_fpga_empty_1st),
    .fifo_host_to_fpga_rden_2nd(fifo_host_to_fpga_rden_2nd), 
    .fifo_host_to_fpga_empty_2nd(fifo_host_to_fpga_empty_2nd),
    .fifo_fpga_to_host_wren, 
    .fifo_fpga_to_host_full(fifo_fpga_to_host_full),
    .fifo_host_to_fpga_dout_1st(fifo_host_to_fpga_dout_1st),
    .fifo_host_to_fpga_dout_2nd(fifo_host_to_fpga_dout_2nd),
    .fifo_fpga_to_host_din(fifo_fpga_to_host_din)
    );
    /*
  sum sum_inst(
    .bus_clk(bus_clk),
    .rst(!user_w_write_32_a_open && !user_r_read_32_result_open && !user_w_write_32_b_open),
    .fifo_host_to_fpga_rden_1st(fifo_host_to_fpga_rden_1st), 
    .fifo_host_to_fpga_empty_1st(fifo_host_to_fpga_empty_1st),
    .fifo_host_to_fpga_rden_2nd(fifo_host_to_fpga_rden_2nd), 
    .fifo_host_to_fpga_empty_2nd(fifo_host_to_fpga_empty_2nd),
    .fifo_fpga_to_host_wren(fifo_fpga_to_host_wren), 
    .fifo_fpga_to_host_full(fifo_fpga_to_host_full),
    .fifo_host_to_fpga_dout_1st(fifo_host_to_fpga_dout_1st),
    .fifo_host_to_fpga_dout_2nd(fifo_host_to_fpga_dout_2nd),
    .fifo_fpga_to_host_din(fifo_fpga_to_host_din)
    );
*/
  fifo_32x512 fifo_fpga_to_host
     (
      .clk(bus_clk),
      .srst(!user_w_write_32_a_open && !user_r_read_32_result_open && !user_w_write_32_b_open),
      .din(fifo_fpga_to_host_din),
      .wr_en(fifo_fpga_to_host_wren),
      .rd_en(user_r_read_32_result_rden),
      .dout(user_r_read_32_result_data),
      .full(fifo_fpga_to_host_full),
      .empty(user_r_read_32_result_empty)
      );
    
   assign  user_r_read_32_result_eof = 0;

   i2s_audio audio
     (
      .bus_clk(bus_clk),
      .clk_100(clk_100),
      .quiesce(quiesce),

      .audio_mclk(audio_mclk),
      .audio_dac(audio_dac),
      .audio_adc(audio_adc),
      .audio_adc_lrclk(audio_adc_lrclk),
      .audio_dac_lrclk(audio_dac_lrclk),
      .audio_mute(audio_mute),
      .audio_bclk(audio_bclk),
      
      .user_r_audio_rden(user_r_audio_rden),
      .user_r_audio_empty(user_r_audio_empty),
      .user_r_audio_data(user_r_audio_data),
      .user_r_audio_eof(user_r_audio_eof),
      .user_r_audio_open(user_r_audio_open),
      
      .user_w_audio_wren(user_w_audio_wren),
      .user_w_audio_full(user_w_audio_full),
      .user_w_audio_data(user_w_audio_data),
      .user_w_audio_open(user_w_audio_open)
      );
   
   smbus smbus
     (
      .bus_clk(bus_clk),
      .quiesce(quiesce),

      .smb_sclk(smb_sclk),
      .smb_sdata(smb_sdata),
      .smbus_addr(smbus_addr),

      .user_r_smb_rden(user_r_smb_rden),
      .user_r_smb_empty(user_r_smb_empty),
      .user_r_smb_data(user_r_smb_data),
      .user_r_smb_eof(user_r_smb_eof),
      .user_r_smb_open(user_r_smb_open),
      
      .user_w_smb_wren(user_w_smb_wren),
      .user_w_smb_full(user_w_smb_full),
      .user_w_smb_data(user_w_smb_data),
      .user_w_smb_open(user_w_smb_open)
      );

endmodule
