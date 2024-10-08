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
        // Initialize signals
        reset = 1;
        subset_cells = 9'b111111111;
        source = 4'd0;
        destination = 4'd0;

        // Apply reset
        #10 reset = 0;

        // Test case 1: Subset with no fire and valid path
        subset_cells = 9'b111001001; // Subset allows cells (0,1), (0,2), (1,1), (2,2)  // No cells on fire
        source = 4'd0;                // Starting at (0,0)
        destination = 4'd8;           // Destination at (2,2)
        #50; // Wait for computation
        $display("Test Case 1 - Shortest Distance: %d, Path: %b", shortest_distance, path_out);

        // Reset for next test case
        reset = 1; #10 reset = 0;

        // Test case 2: Subset with fire blocking some paths
        subset_cells = 9'b111111111; // All cells are part of the subset  // Fire in cell (0,2) (node 2)
        source = 4'd0;                // Starting at (0,0)
        destination = 4'd8;           // Destination at (2,2)
        #50; // Wait for computation
        $display("Test Case 2 - Shortest Distance: %d, Path: %b", shortest_distance, path_out);

        // Reset for next test case
        reset = 1; #10 reset = 0;

        // Test case 3: Subset with a blocked subset and fire
        subset_cells = 9'b110111111; // Cell (0,1) is blocked
        source = 4'd0;                // Starting at (0,0)
        destination = 4'd4;           // Destination at (1,1)
        #50; // Wait for computation
        $display("Test Case 3 - Shortest Distance: %d, Path: %b", shortest_distance, path_out);

        // Reset for next test case
        reset = 1; #10 reset = 0;

        // Test case 4: No valid path due to fire
        subset_cells = 9'b111111111; // All cells are part of the subset  // Fire in cells (1,1) and (1,2)
        source = 4'd0;                // Starting at (0,0)
        destination = 4'd5;           // Destination at (2,2)
        #50; // Wait for computation
        $display("Test Case 4 - Shortest Distance: %d, Path: %b", shortest_distance, path_out);

        // Finish simulation
        $finish;
    end

endmodule