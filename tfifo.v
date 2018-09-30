module test_fifo;

reg reset, clk, wr_en, rd_en;
wire empty, full;
reg [15:0]din;
wire [15:0] dout;

//устанавливаем экземпляр тестируемого модуля
fifo fifo_inst(din, wr_en, rd_en, dout, full, empty, clk, reset);

//моделируем сигнал тактовой частоты
always
  #10 clk = ~clk;

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

//еще через время "4" снимаем сигнал сброса

  #14 reset = 0;

//пауза длительностью "30"
  #30; 

//ждем фронта тактовой частоты и сразу после нее подаем сигнал записи
  @(posedge clk) 
  #0
    begin
      din = 16'h55;
      wr_en = 1'b1;
    end

//ждем фронта тактовой частоты и сразу после нее подаем сигнал чтения
  @(posedge clk) 
  #10
    begin
      rd_en = 1'b1;
    end

//по следующему фронту снимаем сигнал записи и чтения
  @(posedge clk)
  #10
    begin
      wr_en = 1'b0;
      din=16'h17;
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