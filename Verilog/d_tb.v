module Dijkstra_tb;

    // Inputs
    reg [8:0] grid;  // 3x3 grid encoded as 9 bits (1 = reachable, 0 = blocked)
    reg [3:0] start_node;  // Starting node (1 to 9, representing 3x3 grid positions)
    reg [3:0] end_node;  // Ending node (1 to 9)

    // Outputs
    wire shortest_path_found;
    wire [8:0] path_matrix;
    wire [3:0] shortest_path_length;

    // Instantiate the Dijkstra module
    Dijkstra uut (
        .grid(grid),
        .start_node(start_node),
        .end_node(end_node),
        .shortest_path_found(shortest_path_found),
        .path_matrix(path_matrix),
        .shortest_path_length(shortest_path_length)
    );

    // Testbench procedure
    initial begin
        // Test Case 1: Fully connected grid, path from start node 1 to end node 9
        grid = 9'b111111111;  // All nodes are reachable
        start_node = 4'd1;    // Start at node 1 (top-left)
        end_node = 4'd9;      // End at node 9 (bottom-right)
        #10;
        $display("Test Case 1: Fully connected grid, path from node 1 to node 9");
        $display("Shortest Path Found: %b", shortest_path_found);
        $display("Shortest Path Length: %d", shortest_path_length);
        $display("Path Matrix: %b", path_matrix);
        #10;

        // Test Case 2: Blocked middle node, no path from node 1 to node 9
        grid = 9'b111010111;  // Node 5 is blocked (center)
        start_node = 4'd1;    // Start at node 1 (top-left)
        end_node = 4'd9;      // End at node 9 (bottom-right)
        #10;
        $display("Test Case 2: Blocked middle node, no path from node 1 to node 9");
        $display("Shortest Path Found: %b", shortest_path_found);
        $display("Shortest Path Length: %d", shortest_path_length);
        $display("Path Matrix: %b", path_matrix);
        #10;

        // Test Case 3: Only diagonal nodes are reachable
        grid = 9'b100010001;  // Only diagonal nodes (1, 5, 9) are reachable
        start_node = 4'd1;    // Start at node 1 (top-left)
        end_node = 4'd9;      // End at node 9 (bottom-right)
        #10;
        $display("Test Case 3: Only diagonal nodes, path from node 1 to node 9");
        $display("Shortest Path Found: %b", shortest_path_found);
        $display("Shortest Path Length: %d", shortest_path_length);
        $display("Path Matrix: %b", path_matrix);
        #10;

        // Test Case 4: No reachable path (start or end node blocked)
        grid = 9'b000111111;  // First row is blocked
        start_node = 4'd1;    // Start at node 1 (blocked)
        end_node = 4'd9;      // End at node 9 (reachable)
        #10;
        $display("Test Case 4: Start node blocked, no path from node 1 to node 9");
        $display("Shortest Path Found: %b", shortest_path_found);
        $display("Shortest Path Length: %d", shortest_path_length);
        $display("Path Matrix: %b", path_matrix);
        #10;

        // End simulation
        $finish;
    end

endmodule
