#include "graph.h"

#include <iostream>
#include <fstream>
#include <algorithm>
#include <queue>

constexpr int MAX_WEIGHT = 30;

class Graph {
public:
    Graph() = default;
    Graph(int N) : V(N), adj(adjacent_weight_map(N + 1)) {}

    void addEdge(int u, int v, int w) {
        adj[u].emplace_back(v, w);
    }

    int getSource() const {
        return S;
    }

    std::vector<int> spfa(int s) {
        std::queue<int> queue;

        dist.resize(V + 1, INF);
        cnt.resize(V + 1, 0);
        inqueue.resize(V + 1, false);

        dist[s] = 0;
        queue.push(s);
        inqueue[s] = true;

        while (!queue.empty()) {
            int node = queue.front();
            queue.pop();
            inqueue[node] = false;

            for (auto edge : adj[node]) {
                int nnode = edge.first;
                int len = edge.second;

                // Edge relaxation with max cost edge 30
                len = std::min(len, MAX_WEIGHT);

                if (dist[node] != INF && dist[node] + len < dist[nnode]) {
                    dist[nnode] = dist[node] + len;
                    if (!inqueue[nnode]) {
                        queue.push(nnode);
                        inqueue[nnode] = true;
                        cnt[nnode]++;
                        if (cnt[nnode] > V) {
                            // Negative cycle detected
                            std::cerr << "[ERR]: negative cycle detected!" << std::endl;
                            // Return an empty vector to indicate failure
                            return std::vector<int>();
                        }
                    }
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
        
        std::vector<int> dist = spfa(getSource());

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
    adjacent_weight_map adj;
    std::vector<int> dist;
    std::vector<int> cnt;
    std::vector<bool> inqueue;
};

int main(void) {
    Graph graph(0);
    if (!graph.readGraph("date.in"))
        return EXIT_FAILURE;
    if (!graph.writeGraph("date.out"))
        return EXIT_FAILURE;
    return EXIT_SUCCESS;
}
