`timescale 1ns/1ps
//=======================================================
// Testbench for AHB to APB Bridge
// Date: 23-10-2025
//=======================================================
module tb_Bridge_Top;

    // Clock and Reset
    reg Hclk;
    reg Hresetn;

    // AHB side inputs
    reg Hwrite;
    reg Hreadyin;
    reg [31:0] Hwdata;
    reg [31:0] Haddr;
    reg [1:0]  Htrans;

    // APB side inputs
    reg [31:0] Prdata;

    // Outputs
    wire Penable, Pwrite;
    wire Hreadyout;
    wire [1:0] Hresp;
    wire [2:0] Pselx;
    wire [31:0] Paddr, Pwdata, Hrdata;

    // Instantiate DUT (Device Under Test)
    Bridge_Top dut (
        .Hclk(Hclk),
        .Hresetn(Hresetn),
        .Hwrite(Hwrite),
        .Hreadyin(Hreadyin),
        .Hreadyout(Hreadyout),
        .Hwdata(Hwdata),
        .Haddr(Haddr),
        .Htrans(Htrans),
        .Prdata(Prdata),
        .Penable(Penable),
        .Pwrite(Pwrite),
        .Pselx(Pselx),
        .Paddr(Paddr),
        .Pwdata(Pwdata),
        .Hresp(Hresp),
        .Hrdata(Hrdata)
    );

    // Clock generation (10ns period -> 100 MHz)
    always #5 Hclk = ~Hclk;

    // Reset initialization
    initial begin
        Hclk = 0;
        Hresetn = 0;
        Hreadyin = 1;
        Hwrite = 0;
        Hwdata = 32'h0;
        Haddr = 32'h0;
        Htrans = 2'b00;
        Prdata = 32'h00000000;

        // Hold reset for a few cycles
        #20;
        Hresetn = 1;
        $display("[%0t] Reset deasserted", $time);

        // Begin simulation after reset
        #10;
        AHB_Write_Transaction(32'h0000_0010, 32'hA5A5A5A5);
        #30;
        AHB_Read_Transaction(32'h0000_0010);

        #100;
        $display("[%0t] Simulation completed.", $time);
        $stop;
    end

    //=======================================================
    // TASKS FOR AHB TRANSACTIONS
    //=======================================================

    // WRITE Transaction
    task AHB_Write_Transaction;
        input [31:0] address;
        input [31:0] data;
        begin
            @(posedge Hclk);
            Haddr   = address;
            Hwdata  = data;
            Hwrite  = 1;
            Htrans  = 2'b10;   // NONSEQ transfer
            Hreadyin = 1;

            $display("[%0t] AHB WRITE: Addr=0x%h Data=0x%h", $time, address, data);

            @(posedge Hclk);
            Htrans = 2'b00;    // IDLE
            Hwrite = 0;
        end
    endtask

    // READ Transaction
    task AHB_Read_Transaction;
        input [31:0] address;
        begin
            @(posedge Hclk);
            Haddr   = address;
            Hwrite  = 0;
            Htrans  = 2'b10;   // NONSEQ transfer
            Hreadyin = 1;
            Prdata  = 32'hDEADBEEF; // Simulated APB data

            $display("[%0t] AHB READ: Addr=0x%h Expect=0x%h", $time, address, Prdata);

            @(posedge Hclk);
            Htrans = 2'b00;
            #10;
            $display("[%0t] AHB READ COMPLETE: Hrdata=0x%h", $time, Hrdata);

        end
    endtask

    //=======================================================
    // MONITOR SIGNALS
    //=======================================================
    initial begin
        $monitor("[%0t] HADDR=0x%h | HWRITE=%b | HREADYOUT=%b | PSELX=%b | PENABLE=%b | PWRITE=%b | PADDR=0x%h | PWDATA=0x%h | HRDATA=0x%h",
                 $time, Haddr, Hwrite, Hreadyout, Pselx, Penable, Pwrite, Paddr, Pwdata, Hrdata);
    end

endmodule
