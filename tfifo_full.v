module test_fifo;

reg reset, clk, wr_en, rd_en;
wire empty, full;
reg [15:0]din;
wire [15:0] dout;

//устанавливаем экземпляр тестируемого модуля
fifo fifo_inst(din, wr_en, rd_en, dout, full, empty, clk, reset);

//моделируем сигнал тактовой частоты
always
  #4 clk = ~clk;

//от начала времени...

initial
begin
  clk = 0;
  reset = 0;
  din = 16'h00;
  wr_en = 1'b0;
  rd_en = 1'b0;

//через временной интервал "40" подаем сигнал сброса
  #40 reset = 1; 

//еще через время "6" снимаем сигнал сброса

  #6 reset = 0;

//пауза длительностью "30"
  #4; 

//ждем фронта тактовой частоты и сразу после нее подаем сигнал записи
  @(posedge clk) 
  #0
    begin
      din = 16'h1;
      wr_en = 1'b1;
    end


//по следующему фронту записываем в регистр, после окончания записи читаем
  @(posedge clk)
  #8
    begin
      din=16'h17;
      #8
      din=16'h18;
      #8
      din=16'h19;
      #8
      din=16'h20;
      #8
      din=16'h21;
      #8
      din=16'h22;
      #8
      din=16'h23;
      #8
      din=16'h24;
      #8
      din=16'h25;
      #8
      din=16'h26;
      #8
      din=16'h27;
      #8
      din=16'h28;
      #8
      din=16'h29;
      #8
      din=16'h30;
      #8
      din=16'h31;
      #8
      din=16'h32;
      #8
      din=16'h33;
      #8
      din=16'h34;
      #8
      din=16'h35;
      #8
      din=16'h36;
      #8
      din=16'h37;
      #8
      din=16'h38;
      #8
      din=16'h39;
      #8
      wr_en=1'b0;
      rd_en = 1'b1;
      #25
      rd_en = 1'b0;
    end

end

//заканчиваем симуляцию в момент времени "300"
initial
begin
  #300 $finish;
end

//создаем файл VCD для последующего анализа сигналов
initial
begin
  $dumpfile("out_fifo.vcd");
  $dumpvars(0,test_fifo);
end

//наблюдаем на некоторыми сигналами системы
initial 
$monitor($stime,, reset,, clk,,, din,, wr_en,, rd_en,, dout,, empty,, full); 

endmodule