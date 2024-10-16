# Path guidance for emergency evacuation

<!-- First Section -->
## Team Details
<details>
  <summary>Detail</summary>
  
> Semester: 3rd Sem B. Tech. CSE

> Section: S2

> Team ID: S2-T21

> Member 1:Pal Patel, 231CS240, palpatel.231cs240@nitk.edu.in, 9265254960

> Member 2: Pragya Paromita Barma, 231CS241, pragyaparomitabarma.231cs241@nitk.edu.in, 8160727736

> Member 3: Srishti Kumari, 231CS258, srishtikumari.231cs258@nitk.edu.in, 8310595970
</details>

<!-- Second Section -->
## Abstract
<details>
  <summary>Detail</summary>
   
   ### Motivation
The project is motivated by the critical need to have evacuation systems that
are smart, adaptable, and help save lives in emergencies; the complexity and overpopulation
of urban areas today call for allowing escape routes to be optimized even in unpredictable
conditions through efficient algorithms like Dijkstra’s. It can be incorporated into emergency
response systems to greatly increase the safety and efficiency of evacuations in life-threatening
situations such as fires. In emergencies such as building fires, time is rather critical. Finding the
safest and fastest route to evacuate, can be lifesaving. Conventional fire evacuation approaches
rely on static plans that may not be useful during real situations. Such hostile environments
require intelligent systems that must travel by the safest path possible and take into account
the continuously changing conditions generated by the fire.
  
  ### Problem Statement: 
  In the case of a fire outbreak inside a building, finding the safest and
quickest evacuation route for a person is critical. Given the building’s layout, the person must
navigate through hallways and rooms to reach an exit point while avoiding areas affected by
fire. We have developed a solution using Dijkstra’s algorithm to determine the shortest and
safest path from the person’s current location (source node) to the nearest exit (destination
node).
  
  ### Features:
 • This project aims to implement Dijkstra’s Algorithm practically by physically constructing
it using Verilog and modern circuit components [Galles, ].<br>
• It introduces a hardware approach to pathfinding, moving beyond theoretical concepts
[YouTube, ].<br>
• Unlike software-based implementations, this design utilizes parallelism to achieve higher
speed and efficiency in finding the shortest paths [GeeksforGeeks, ].<br>
• Logisim is used to draw and simulate circuits, making it possible to understand how the
algorithm works in hardware [Galles, ].<br>
• The project helps appreciate the management of resources and the complexity of the
circuits involved [GeeksforGeeks, ].
 
</details>

## Functional Block Diagram
<details>
  <summary>Detail</summary>
  
![blockDiagram drawio](https://github.com/user-attachments/assets/5cfe71dd-3014-4960-80ab-9303bc553d63)

</details>

<!-- Third Section -->
## Working
<details>
  <summary>Detail</summary>
  
  ### State Diagram
 
  ![State Diagram](https://github.com/user-attachments/assets/923fa0f5-be05-4719-8375-460277904abc)

  ### EQUATIONS

  
### 1. Initialization Equations
Before the algorithm begins, several variables and arrays are initialised.<br>
Verilog Representation:<br>
for (i = 0; i < 9; i = i + 1) begin<br>
dist[i] = (i == source) ? 8’h00 : 8’hFF;<br>
end<br>
### Parent Initialization
Each node’s parent is initially set to an invalid value, indicating that no paths have been<br>
established yet.<br>
Verilog Representation:<br>
for (i = 0; i < 9; i = i + 1) begin<br>
parent[i] = 4’hF; // INVALID<br>
end<br>
### Visited Array Initialization
All nodes are marked as unvisited at the start.<br>
Verilog Representation:<br>
visited = 9’b000000000;<br>
### 2. Adjusting the Adjacency Matrix Based on subset cells<br>
The adjacency matrix defines the connectivity between nodes in the grid. The subset cells input<br>
determines which cells (nodes) are included or blocked. If a cell is blocked (i.e., subset cells[i]<br>
= 0), all its connections are removed by setting the corresponding adjacency bits to 0.<br>
Verilog Representation:<br>
for (i = 0; i < 9; i = i + 1) begin<br>
if (!subset cells[i]) begin<br>
adj matrix[i] = 9’b000000000;<br>
end<br>
end<br>
### 3. Main Loop:Dijkstra’s Algorithm Operations
The core of Dijkstra’s algorithm involves iteratively selecting the unvisited node with the<br>
smallest tentative distance, updating the distances of its neighbors, and marking it as visited.<br>
This process continues until the destination is reached or no more nodes can be selected.<br>
### A. Selecting the Current Node with Minimum Distance
At each iteration, select the unvisited node with the smallest tentative distance.If no such node<br>
exists (i.e., all remaining nodes are unreachable), the algorithm terminates.<br>
Verilog Representation:<br>
min dist = 8’hFF; // Initialize to infinity<br>
next node = 4’hF; // INVALID<br>
for (j = 0; j < 9; j = j + 1) begin<br>
if (!visited[j] & (dist[j] ¡]< min dist)) begin<br>
min dist = dist[j];<br>
next node = j;<br>
end<br>
end<br>
if (next node == 4’hF) begin<br>
// No more nodes to process<br>
break;<br>
end else begin<br>
current node = next node;<br>
end<br>
### B. Marking the Current Node as Visited
Once a node uu is selected, mark it as visited to prevent reprocessing.<br>
Verilog Representation:<br>
visited[current node] = 1’b1;<br>
### C. Updating Distances of Neighboring Nodes
For each neighbour of the current node, update the tentative distance if a shorter path is<br>
found.<br>
Verilog Representation:<br>
for (j = 0; j < 9; j = j + 1) begin<br>
if (adj matrix[current node][j] & !visited[j]) begin<br>
if (dist[current node] + 8’h01 < dist[j]) begin<br>
dist[j] = dist[current node] + 8’h01;<br>
parent[j] = current node;<br>
end<br>
end<br>
end<br>
### D. Iterative Loop Control
Repeat the selection and updating steps until the destination is reached or no more nodes can<br>
be processed.<br>
Verilog Representation:<br>
for (i = 0; i < 9; i = i + 1) begin<br>
// Selection, marking, and updating steps as described above<br>
// Break the loop if no next node is found<br>
end<br>
### 4. Path Reconstruction Equations
After completing the main loop, if the destination node has been reached (i.e., dist[destination]<br>
is not infinity), reconstruct the shortest path by tracing back from the destination to the source<br>
using the parent array.<br>
### A. Determining Shortest Distance
shortest distance=dist[destination]<br>
Verilog Representation:<br>
shortest distance = dist[destination];<br>
### B. Reconstructing the Path
Initialize path out to zero and iteratively set the bits corresponding to each node in the path<br>
from the destination back to the source.<br>
Verilog Representation:<br>
path out = 9’b000000000;<br>
current node = destination;<br>
for (j = 0; current node != source & j < 9 & current node != 4’hF; j = j + 1) begin<br>
path out = path out — (1 !! current node);<br>
current node = parent[current node];<br>
end<br>
path out = path out — (1 !! source);<br>
### C. Handling No Path Found
If the destination remains unreachable after the main loop, indicate that no valid path exists.<br>
Verilog Representation:<br>
if (dist[destination] != 8’hFF) begin<br>
// Reconstruct path as shown above<br>
end else begin<br>
path out = 9’b000000000;<br>
end<br>
</details>

<!-- Fourth Section -->
## Logisim Circuit Diagram
<details>
  <summary>Detail</summary>
  
  ### Main Module

![main](https://github.com/user-attachments/assets/32388a2b-9427-451d-b19e-2cff2de64c20)


  
 ### Adjacency Matrix module
  
  ![adj_matrix](https://github.com/user-attachments/assets/36835e81-3b3c-4232-b03c-d2e06f4b9c5b)
 ### Queue Module
![Queue](https://github.com/user-attachments/assets/f47ca5f2-8795-4db9-b7aa-74e19f484e2f)
### Distances module
![distances](https://github.com/user-attachments/assets/dca2e34a-19c1-4855-bcb2-30ce20dee755)
### Visited nodes module
![visitednodes](https://github.com/user-attachments/assets/007fb617-5df5-421c-be52-fbee512fdb4f)<br>
### Parent module
![parent](https://github.com/user-attachments/assets/e23f7f39-bb01-4753-8caa-1d025148cf1c)

</details>


<!-- Fifth Section -->
## Verilog Code
<details>
  <summary>Detail</summary>

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
      reg [3:0] current_node;
      reg [7:0] min_dist;
      reg [3:0] next_node;
      reg [8:0] temp_path;
      // 9-bit representation of connections for a 3x3 grid
      // 9 nodes in the grid
      // Initialize the adjacency matrix in your module
      initial begin
        adj_matrix[0] = 9'b000001010; // Node 0 connects to Node 1 (right) and Node 3 (down)
        adj_matrix[1] = 9'b000010101; // Node 1 connects to Node 0 (left), Node 2 (right), and Node 4 (down)
        adj_matrix[2] = 9'b000100010; // Node 2 connects to Node 1 (left) and Node 5 (down)
        adj_matrix[3] = 9'b001010001; 
        adj_matrix[4] = 9'b010101010; 
        adj_matrix[5] = 9'b100010100; 
        adj_matrix[6] = 9'b010001000; 
        adj_matrix[7] = 9'b101010000;
        adj_matrix[8] = 9'b010100000; 
      end
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
            for (i = 0; i < 9; i = i + 1) begin
                // Mark the current node as visited
                visited[current_node] = 1'b1;
                // Update distances for neighbors of the current node
                for (j = 0; j < 9; j = j + 1) begin
                    if ((adj_matrix[current_node][j]==1) && !visited[j]) begin
                        //$display(adj_matrix[current_node][j]);
                        // If unvisited and an edge exists
                        if ((dist[current_node] + 8'h01) < dist[j]) begin
                            $display(i,j);
                            dist[j] = dist[current_node] + 8'h01; // Update distance (weight = 1)
                            parent[j] = current_node;             // Set parent
                        end
                    end
                end
                // Step 2: Find the next node with the smallest distance
                next_node = 4'hF; // Invalidate current node
                min_dist = 8'hFF; // Set minimum distance to infinity
                // check the logic over again ig there is some bug so dry run it again
                for (j = 0; j < 9; j = j + 1) begin
                    if (!visited[j] && (dist[j] < min_dist)) begin
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
          temp_path = 9'b000000000;
          current_node = destination;
          for (j = 0; current_node != source && j < 9 && current_node != 4'hF; j = j + 1) begin
          temp_path = temp_path | (1 << current_node);  // Set the bit corresponding to current_node
          current_node = parent[current_node];        // Move to the parent node
    end
    temp_path = temp_path | (1 << source);
    for (j = 0; j < 9; j = j + 1) begin
      if (temp_path[j]) begin
      path_out = path_out | (1 << (8 - j));
    end
          path_out = path_out | (1 << source); // Mark the source in the path
    end else begin
            // No valid path found
            path_out = 9'b000000000;
          end
        end
      end
    endmodule

### Gate Level Implementation 

    module main_control(
      input reset,
      input clk,
      input [8:0] subset_cells,    // Subset cells or blocked nodes
      input [3:0] source,          // Source node (0-8)
      input [3:0] destination,     // Destination node (0-8)
      output reg [2:0] shortest_distance, // Output: Shortest distance
      output reg [8:0] path_out           // Output: Path taken
    );

    reg [7:0] dist[8:0];         // Distance array
    reg [3:0] current_node;
    reg [7:0] min_dist;
    reg [8:0] visited;
    reg [8:0] adj_matrix[8:0];
    
    wire [8:0] temp_path;
    wire update_needed;
    wire not_visited;
    reg [7:0] next_dist;
    reg update_dist;
    
    // Instantiate other modules
    distance_update_gate dist_update(
        .dist_current(dist[current_node]),
        .dist_neighbor(dist[next_node]),
        .visited_neighbor(visited[next_node]),
        .update_needed(update_needed)
    );
    
    visited_check visit_check(
        .visited(visited[next_node]),
        .not_visited(not_visited)
    );
    
    path_reconstruction path_recon(
        .temp_path(temp_path),
        .current_node(current_node),
        .path_out(path_out)
    );

    initial begin
        adj_matrix[0] = 9'b000001010; 
        adj_matrix[1] = 9'b000010101;
        adj_matrix[2] = 9'b000100010;
        adj_matrix[3] = 9'b001010001;
        adj_matrix[4] = 9'b010101010;
        adj_matrix[5] = 9'b100010100;
        adj_matrix[6] = 9'b010001000;
        adj_matrix[7] = 9'b101010000;
        adj_matrix[8] = 9'b010100000;
        visited = 9'b000000000;
        shortest_distance = 8'hFF;
        path_out = 9'b000000000;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            visited = 9'b000000000;
            shortest_distance = 8'hFF;
            path_out = 9'b000000000;
        end else begin

            dist[source] = 8'h00;
            current_node = source;

            while (current_node != destination) begin

                for (int i = 0; i < 9; i = i + 1) begin
                    if (adj_matrix[current_node][i] && !visited[i]) begin

                        if (update_needed) begin
                            dist[i] = dist[current_node] + 1;
                        end
                    end
                end
                min_dist = 8'hFF;
                for (int j = 0; j < 9; j = j + 1) begin
                    if (!visited[j] && dist[j] < min_dist) begin
                        min_dist = dist[j];
                        current_node = j;
                    end
                end
                visited[current_node] = 1;
            end
            shortest_distance = dist[destination];
            path_out = path_recon.path_out;
        end
      end
    endmodule
    module distance_update_gate(
        input [7:0] dist_current,  
        input [7:0] dist_neighbor, 
        input visited_neighbor,   
        output update_needed      
      );
      wire [7:0] dist_plus_one; 
      wire comparison_result;  
      assign dist_plus_one = dist_current + 8'b00000001;
      assign comparison_result = (dist_plus_one < dist_neighbor);
      assign update_needed = (~visited_neighbor) & comparison_result;
    endmodule
      module visited_check(
        input visited,         
        output not_visited     
      );
        assign not_visited = ~visited;
      endmodule
      module select_min(
      input [7:0] dist1,  
      input [7:0] dist2, 
      input visited1,     
      input visited2,   
      output [7:0] min_dist,  
      output select_node1 
      );
        wire valid1, valid2, comparison_result;
        assign valid1 = ~visited1;
        assign valid2 = ~visited2;
        assign comparison_result = (dist1 < dist2);
        assign select_node1 = valid1 & (valid2 ? comparison_result : 1'b1); 
        assign min_dist = select_node1 ? dist1 : dist2;
      endmodule
      module path_reconstruction(
        input [8:0] temp_path, 
        input [3:0] current_node,
        output [8:0] path_out    
      );
        wire [8:0] temp_shifted;
        assign temp_shifted = temp_path | (9'b000000001 << current_node);
        assign path_out = temp_shifted;
      endmodule


### Output

![Screenshot 2024-10-16 164850](https://github.com/user-attachments/assets/f710cb19-7142-4b9f-b74f-ebd538f95cbc)

</details>

## References
<details>
  <summary>Detail</summary>
  
  > [https://www.cs.usfca.edu/galles/visualization/Dijkstra.html]<br/>
  >  [https://www.geeksforgeeks.org/dijkstras-shortest-path-algorithm-greedy-algo-7/]<br/>
  >  put link <br/>
  

</details>
