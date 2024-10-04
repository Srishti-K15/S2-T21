#include <iostream>
#include <vector>
#include <queue>
#include <climits>
#include <tuple> // Include this header for std::tie

using namespace std;

// Define a structure for the priority queue (min-heap)
struct Node {
    int distance, x, y;
    Node(int d, int x_, int y_) : distance(d), x(x_), y(y_) {}
    bool operator>(const Node &other) const {
        return distance > other.distance;
    }
};

// Function to find the shortest path using Dijkstra's Algorithm
pair<int, vector<vector<int>>> dijkstra(string grid, int start, int end) {
    // Defining the 3x3 grid connections (4-way connectivity)
    int n = 3;  // Grid size is 3x3
    vector<pair<int, int>> moves = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};  // Up, Down, Left, Right
    
    // Convert the grid string into a 2D matrix
    vector<vector<int>> matrix(n, vector<int>(n));
    for (int i = 0; i < n * n; ++i) {
        matrix[i / n][i % n] = grid[i] - '0';
    }
    
    // If start or end nodes are blocked, return no path
    if (matrix[(start-1)/3][(start-1)%3] == 0 || matrix[(end-1)/3][(end-1)%3] == 0) {
        return {-1, {}};  // No path possible
    }
    
    // Priority queue (min-heap) to store (distance, (x, y))
    priority_queue<Node, vector<Node>, greater<Node>> pq;
    pq.push(Node(0, (start-1)/3, (start-1)%3));
    
    // Distance array to store shortest distances to each node
    vector<vector<int>> dist(n, vector<int>(n, INT_MAX));
    dist[(start-1)/3][(start-1)%3] = 0;
    
    // Parent array to store the path
    vector<vector<pair<int, int>>> parent(n, vector<pair<int, int>>(n, {-1, -1}));
    
    // Dijkstra's algorithm
    while (!pq.empty()) {
        Node node = pq.top();
        pq.pop();
        int d = node.distance, x = node.x, y = node.y;
        
        // If we reached the destination
        if (x == (end-1)/3 && y == (end-1)%3)
            break;
        
        // Check all possible moves
        for (auto move : moves) {
            int nx = x + move.first;
            int ny = y + move.second;
            
            // If the move is valid and the node is reachable
            if (nx >= 0 && nx < n && ny >= 0 && ny < n && matrix[nx][ny] == 1) {
                int new_dist = d + 1;
                if (new_dist < dist[nx][ny]) {
                    dist[nx][ny] = new_dist;
                    parent[nx][ny] = {x, y};
                    pq.push(Node(new_dist, nx, ny));
                }
            }
        }
    }
    
    // If the destination is not reachable
    if (dist[(end-1)/3][(end-1)%3] == INT_MAX) {
        return {-1, {}};  // No path found
    }
    
    // Retrieve the path using the parent array
    vector<vector<int>> path(n, vector<int>(n, 0));
    int cx = (end-1)/3, cy = (end-1)%3;
    while (cx != (start-1)/3 || cy != (start-1)%3) {
        path[cx][cy] = 1;
        int px = parent[cx][cy].first; // Get parent x-coordinate
        int py = parent[cx][cy].second; // Get parent y-coordinate
        cx = px;
        cy = py;
    }
    path[(start-1)/3][(start-1)%3] = 1;
    
    // Return the shortest path length and the path matrix
    return {dist[(end-1)/3][(end-1)%3], path};
}

int main() {
    string grid; 
    cin>>grid; // Example grid input (1 = reachable, 0 = blocked)
    int start_node;  
    cin>>start_node;// Starting node
    int end_node;   
    cin>>end_node; // Ending node
    
    // Call the dijkstra function
    auto result = dijkstra(grid, start_node, end_node);
    
    int length = result.first;
    vector<vector<int>> path = result.second;
    
    // Output the shortest path length and path matrix
    if (length == -1) {
        cout << "No path found." << endl;
    } else {
        cout << "Shortest Path Length: " << length << endl;
        cout << "Path (1 indicates path):" << endl;
        for (const auto &row : path) {
            for (int cell : row) {
                cout << cell << " ";
            }
        }
    }

    return 0;
}
