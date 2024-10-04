module dijkstra_subset(
    input reset,
    input [8:0] subset_cells,  // 9-bit input to represent cells (1 = included, 0 = excluded or blocked)
    input [3:0] source,        // 4-bit source node (3x3 grid -> 9 nodes, range: 0-8)
    input [3:0] destination,   // 4-bit destination node (range: 0-8)
    output reg [2:0] shortest_distance, // Shortest distance from source to destination
    output reg [8:0] path_out           // Path output (9 bits, 1 for each cell)
);

    reg [8:0] adj_matrix[8:0];   // Adjacency matrix for 3x3 grid
    reg [7:0] dist[8:0];         // Distance array
    reg [3:0] parent[8:0];       // Parent array for path reconstruction
    reg [8:0] visited;           // Visited array

    integer i, j;
    reg [3:0] current_node;
    reg [7:0] min_dist;
    reg [3:0] next_node;

    // Initialize graph adjacency matrix and other variables
// 9-bit representation of connections for a 3x3 grid
 // 9 nodes in the grid

// Initialize the adjacency matrix in your module
initial begin
    adj_matrix[0] = 9'b010100000; // Node 0 connects to Node 1 (right) and Node 3 (down)
    adj_matrix[1] = 9'b101010000; // Node 1 connects to Node 0 (left), Node 2 (right), and Node 4 (down)
    adj_matrix[2] = 9'b010001000; // Node 2 connects to Node 1 (left) and Node 5 (down)
    adj_matrix[3] = 9'b100010100; // Node 3 connects to Node 0 (up), Node 4 (right), and Node 6 (down)
    adj_matrix[4] = 9'b010101010; // Node 4 connects to Node 1 (up), Node 3 (left), Node 5 (right), and Node 7 (down)
    adj_matrix[5] = 9'b001010001; // Node 5 connects to Node 2 (up), Node 4 (left), and Node 8 (down)
    adj_matrix[6] = 9'b000100010; // Node 6 connects to Node 3 (up) and Node 7 (right)
    adj_matrix[7] = 9'b000010101; // Node 7 connects to Node 4 (up), Node 6 (left), and Node 8 (right)
    adj_matrix[8] = 9'b000001010; // Node 8 connects to Node 5 (up) and Node 7 (left)
end


    // Remove fire_cells and handle only subset_cells
    always @(reset or subset_cells or source or destination) begin
        if (reset) begin
            // Reset distances, visited, and path arrays
            for (i = 0; i < 9; i = i + 1) begin
                dist[i] = 8'hFF;
                parent[i] = 4'hF;
            end
            visited = 9'b000000000;
            shortest_distance = 8'hFF;
            path_out = 9'b000000000;
        end else begin
            // Adjust adjacency matrix based on subset_cells input
            for (i = 0; i < 9; i = i + 1) begin
                if (!subset_cells[i]) begin
                    // If a cell is not part of the subset or blocked, block all its connections
                    adj_matrix[i] = 9'b000000000;
                end
            end

            // Step 1: Set source distance to 0
            dist[source] = 8'h00;
            current_node = source;

            // Dijkstra's algorithm loop (acts like BFS since weights = 1)
            for (i = 0; i < 9; i = i + 1) begin
                // Mark the current node as visited
                visited[current_node] = 1'b1;

                // Update distances for neighbors of the current node
                for (j = 0; j < 9; j = j + 1) begin
                    if (adj_matrix[current_node][j] && !visited[j]) begin
                        // If unvisited and an edge exists
                        if (dist[current_node] + 8'h01 < dist[j]) begin
                            dist[j] = dist[current_node] + 8'h01; // Update distance (weight = 1)
                            parent[j] = current_node;             // Set parent
                        end
                    end
                end

                // Step 2: Find the next node with the smallest distance
                next_node = 4'hF; // Invalidate current node
                min_dist = 8'hFF; // Set minimum distance to infinity
                for (j = 0; j < 9; j = j + 1) begin
                    if (!visited[j] && dist[j] < min_dist) begin
                        min_dist = dist[j];
                        next_node = j;
                    end
                end

                // If no valid next node found, break the loop
                if (next_node == 4'hF) begin
                    i = 9; // End the loop
                end else begin
                    current_node = next_node;
                end
            end

            // Step 3: If we reached the destination, output the distance and path
if (dist[destination] != 8'hFF) begin
    shortest_distance = dist[destination];
    
    // Reconstruct path from destination to source
    path_out = 9'b000000000;
    current_node = destination;
    for (j = 0; current_node != source && j < 9 && current_node != 4'hF; j = j + 1) begin
        path_out = path_out | (1 << current_node);  // Set the bit corresponding to current_node
        current_node = parent[current_node];        // Move to the parent node
    end
    path_out = path_out | (1 << source); // Mark the source in the path
end else begin
    // No valid path found
    path_out = 9'b000000000;
end

        end
    end
endmodule