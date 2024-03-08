#include "graph.h"

#include <iostream>
#include <fstream>
#include <algorithm>
#include <queue>

class Graph {
public:
    Graph() = default;
    Graph(int N) : V(N), adj(adjiacent_weight_map(N + 1)) {}

    void addEdge(int u, int v, int w) {
        adj[u].emplace_back(v, w);
    }

    int getSource(void) const {
        return S;
    }

    std::vector<int> shortestpath(int S) {
        dist.resize(V + 1, INF);
        dist[S] = 0;

        std::vector<int> stack = topologicalSort();

        // Traverse vertices in topological order and relax edges
        for (int node : stack) {
            for (auto& edge : adj[node]) {
                int nnode = edge.first;
                int weight = edge.second;
                // Update distance if shorter path is found
                if (dist[node] != INF && dist[node] + weight < dist[nnode]) {
                    dist[nnode] = dist[node] + weight;
                }
            }
        }

        return dist;
    }

    bool readGraph(const std::string& file) {
        std::ifstream fin(file);
        if (!fin) {
            std::cerr << "[ERR]: opening input file." << std::endl;
            return false;
        }

        if (!(fin >> V >> E >> S)) {
            std::cerr << "[ERR]: reading input." << std::endl;
            return false;
        }
        adj.clear();
        adj.resize(V + 1);

        for (int e = 0; e < E; ++e) {
            int u, v, w;
            if (!(fin >> u >> v >> w)) {
                std::cerr << "[ERR]: reading input." << std::endl;
                return false;
            }
            addEdge(u, v, w);
        }

        fin.close();
        return true;
    }

    bool writeGraph(const std::string& file) {
        std::ofstream fout(file);
        if (!fout) {
            std::cerr << "[ERR]: opening output file." << std::endl;
            return false;
        }

        std::vector<int> dist = shortestpath(getSource());

        for (int v = 1; v <= V; ++v) {
            if (dist[v] == INF) {
                fout << -1 << " ";
            } else {
                fout << dist[v] << " ";
            }
        }

        fout.close();
        return true;
    }

private:
    int V, E, S;
    adjiacent_weight_map adj;
    std::vector<int> dist;

    std::vector<int> topologicalSort() {
        std::vector<int> stack;
        std::vector<bool> vis(V + 1, false);

        // Perform DFS on each unvisited vertex
        for (int v = 1; v <= V; ++v) {
            if (!vis[v]) {
                dfs(v, vis, stack);
            }
        }

        // Reverse the stack to get topological order
        std::reverse(stack.begin(), stack.end());
        return stack;
    }

    void dfs(int node, std::vector<bool>& vis, std::vector<int>& stack) {
        vis[node] = true;

        // Recursively visit adjacent vertices
        for (auto& edge : adj[node]) {
            int nnode = edge.first;
            if (!vis[nnode]) {
                dfs(nnode, vis, stack);
            }
        }

        stack.push_back(node);
    }
};

int main(void) {
    Graph graph(0);
    if (!graph.readGraph("date.in"))
        return EXIT_FAILURE;
    if (!graph.writeGraph("date.out"))
        return EXIT_FAILURE;
    return EXIT_SUCCESS;
}
