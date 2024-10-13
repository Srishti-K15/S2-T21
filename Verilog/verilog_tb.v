`timescale 1ns/1ps

module testbench;

    // Testbench signals
    reg reset;
    reg [8:0] subset_cells;
    reg [3:0] source;
    reg [3:0] destination;
    wire [2:0] shortest_distance;
    wire [8:0] path_out;

    // Instantiate the Dijkstra subset module
    dijkstra_subset uut (
        .reset(reset),
        .subset_cells(subset_cells),
        .source(source),
        .destination(destination),
        .shortest_distance(shortest_distance),
        .path_out(path_out)
    );


    initial begin
        reset = 1;
        subset_cells = 9'b111111111;
        source = 4'd0;
        destination = 4'd0;

        #10 reset = 0;

        // Test case 1
        subset_cells = 9'b111001001; 
        source = 4'd0;                
        destination = 4'd8;           
        #50; 
        $display("Test Case 1 - Shortest Distance: %d, Path: %b", shortest_distance, path_out);

        reset = 1; #10 reset = 0;

        // Test case 2
        subset_cells = 9'b111111111; 
        source = 4'd0;               
        destination = 4'd8;          
        #50; 
        $display("Test Case 2 - Shortest Distance: %d, Path: %b", shortest_distance, path_out);

        reset = 1; #10 reset = 0;

        //Test case 3
        subset_cells = 9'b110111111; 
        source = 4'd0;                
        destination = 4'd4;        
        #50; 
        $display("Test Case 3 - Shortest Distance: %d, Path: %b", shortest_distance, path_out);

        reset = 1; #10 reset = 0;

        //Test case 4
        subset_cells = 9'b111000111; 
        source = 4'd0;        
        destination = 4'd5; 
        #50; 
        $display("Test Case 4 - Shortest Distance: %d, Path: %b", shortest_distance, path_out);

        $finish;
    end

endmodule
