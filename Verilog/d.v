module Dijkstra(
    input wire [8:0] grid,   // Input grid as a 3x3 matrix in a single 9-bit vector
    input wire [3:0] start_node,
    input wire [3:0] end_node,
    output reg shortest_path_found,
    output reg [8:0] path_matrix,
    output reg [3:0] shortest_path_length,
    input wire clock
);

    // Define constants for grid size
    parameter N = 3;
    
    // Define grid registers
    reg [1:0] matrix [0:N-1][0:N-1];
    
    // Declare distances and parent arrays
    reg [3:0] dist [0:N-1][0:N-1];
    reg [1:0] parent_x [0:N-1][0:N-1];
    reg [1:0] parent_y [0:N-1][0:N-1];
    
    // Queue variables
    reg [3:0] queue [0:N*N-1];
    reg [4:0] queue_head, queue_tail;

    // Declare loop variables at the module level
    integer i, j;
    reg [1:0] nx, ny;
    reg [3:0] new_dist;
    reg [3:0] current_node;
    reg [1:0] cx, cy, px, py;  // Moved these declarations outside procedural blocks

    // Initialization block for grid and distances
    always @(posedge clock) begin
        // Initialize grid matrix from the input grid
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                matrix[i][j] = grid[i*N + j];
            end
        end

        // Initialize distances to maximum value (simulate infinity)
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                if (matrix[i][j] == 1) begin
                    dist[i][j] = 4'hF;  // Use 4-bit max value as "infinity"
                    parent_x[i][j] = 2'b11;  // Invalid parent
                    parent_y[i][j] = 2'b11;  // Invalid parent
                end
            end
        end
        
        // Set the distance for the starting node
        dist[start_node[1:0]][start_node[3:2]] = 4'd0;
        queue_head = 5'd0;
        queue_tail = 5'd1;
        queue[queue_head] = start_node;
    end
    
    // Main Dijkstra's logic block
    always @(posedge clock) begin
        if (queue_head != queue_tail) begin
            // Dequeue
            current_node = queue[queue_head];
            queue_head = queue_head + 1;

            // Process neighbors
            for (i = 0; i < 4; i = i + 1) begin
                // Assign values to nx and ny separately
                if (i == 0) begin
                    nx = current_node[1:0] - 1;
                    ny = current_node[3:2];
                end else if (i == 1) begin
                    nx = current_node[1:0] + 1;
                    ny = current_node[3:2];
                end else if (i == 2) begin
                    nx = current_node[1:0];
                    ny = current_node[3:2] - 1;
                end else begin
                    nx = current_node[1:0];
                    ny = current_node[3:2] + 1;
                end
                
                if (nx < N && ny < N && matrix[nx][ny] == 1) begin
                    new_dist = dist[current_node[1:0]][current_node[3:2]] + 4'd1;
                    if (new_dist < dist[nx][ny]) begin
                        dist[nx][ny] = new_dist;
                        parent_x[nx][ny] = current_node[1:0];
                        parent_y[nx][ny] = current_node[3:2];
                        queue[queue_tail] = {nx, ny};
                        queue_tail = queue_tail + 1;
                    end
                end
            end
        end
    end
    
    // Path reconstruction block
    always @(posedge clock) begin
        shortest_path_length = dist[end_node[1:0]][end_node[3:2]];
        
        if (shortest_path_length == 4'hF) begin
            shortest_path_found = 1'b0;
        end else begin
            shortest_path_found = 1'b1;
            cx = end_node[1:0];
            cy = end_node[3:2];
            
            // Reset the path matrix
            for (i = 0; i < N*N; i = i + 1) begin
                path_matrix[i] = 1'b0;
            end
            
            // Traverse back the path using the parent array
            while (cx != start_node[1:0] || cy != start_node[3:2]) begin
                path_matrix[cx*N + cy] = 1'b1;
                px = parent_x[cx][cy];
                py = parent_y[cx][cy];
                cx = px;
                cy = py;
            end
            
            path_matrix[start_node[1:0]*N + start_node[3:2]] = 1'b1;
        end
    end

endmodule
