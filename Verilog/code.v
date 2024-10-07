module dijkstra_subset(
    input reset,
    input [8:0] subset_cells,  
    input [3:0] source,        
    input [3:0] destination,   
    output reg [2:0] shortest_distance, 
    output reg [8:0] path_out           
);

    reg [8:0] adj_matrix[8:0];   
    reg [7:0] dist[8:0];         
    reg [3:0] parent[8:0];       
    reg [8:0] visited;           

    integer i, j;
    reg [3:0] current_node;
    reg [7:0] min_dist;
    reg [3:0] next_node;

initial begin
    adj_matrix[0] = 9'b010100000; 
    adj_matrix[1] = 9'b101010000; 
    adj_matrix[2] = 9'b010001000; 
    adj_matrix[3] = 9'b100010100; 
    adj_matrix[4] = 9'b010101010; 
    adj_matrix[5] = 9'b001010001; 
    adj_matrix[6] = 9'b000100010; 
    adj_matrix[7] = 9'b000010101; 
    adj_matrix[8] = 9'b000001010; 
end

    always @(reset or subset_cells or source or destination) begin
        if (reset) begin
            for (i = 0; i < 9; i = i + 1) begin
                dist[i] = 8'hFF;
                parent[i] = 4'hF;
            end
            visited = 9'b000000000;
            shortest_distance = 8'hFF;
            path_out = 9'b000000000;
        end else begin
            for (i = 0; i < 9; i = i + 1) begin
                if (!subset_cells[i]) begin
                    adj_matrix[i] = 9'b000000000;
                end
            end

            dist[source] = 8'h00;
            current_node = source;

            for (i = 0; i < 9; i = i + 1) begin
                visited[current_node] = 1'b1;

                for (j = 0; j < 9; j = j + 1) begin
                    if (adj_matrix[current_node][j] && !visited[j]) begin
                        if (dist[current_node] + 8'h01 < dist[j]) begin
                            dist[j] = dist[current_node] + 8'h01; 
                            parent[j] = current_node;             
                        end
                    end
                end
                
                next_node = 4'hF; 
                min_dist = 8'hFF; 
                for (j = 0; j < 9; j = j + 1) begin
                    if (!visited[j] && dist[j] < min_dist) begin
                        min_dist = dist[j];
                        next_node = j;
                    end
                end

                if (next_node == 4'hF) begin
                    i = 9; 
                end else begin
                    current_node = next_node;
                end
            end

if (dist[destination] != 8'hFF) begin
    shortest_distance = dist[destination];
    path_out = 9'b000000000;
    current_node = destination;
    for (j = 0; current_node != source && j < 9 && current_node != 4'hF; j = j + 1) begin
        path_out = path_out | (1 << current_node);  
        current_node = parent[current_node];        
    end
    path_out = path_out | (1 << source); 
end else begin
    path_out = 9'b000000000;
end

        end
    end
endmodule
