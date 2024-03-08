#include "graph.h"

#include <iostream>
#include <fstream>

class Graph {
public:
    Graph() = default;
    Graph(int V) : adj(adjiacent_map(V + 1)) {}

    void addEdge(int u, int v) {
        adj[u].push_back(v);
    }

    bool hasCycle(void) {
        for (auto& [node, _] : adj) {
            if (!vis.count(node) && dfsCycleDetect(node)) {
                return true;
            }
        }

        return false;
    }

    bool readGraph(const std::string& file) {
        std::ifstream fin(file);
        std::ios::sync_with_stdio(false);

        if (!fin) {
            std::cerr << "[ERR]: opening input file." << std::endl;
            return false;
        }

        if (!(fin >> V >> E)) {
            std::cerr << "[ERR]: reading input." << std::endl;
            return false;
        }

        for (int e = 0; e < E; ++e) {
            int u, v;
            if (!(fin >> u >> v)) {
                std::cerr << "[ERR]: reading input." << std::endl;
                return false;
            }
            addEdge(u, v);
        }

        fin.close();
        return true;
    }

    bool writeResultToFile(const std::string& file) {
        std::ofstream fout(file);
        if (!fout) {
            std::cerr << "[ERR]: opening output file." << std::endl;
            return false;
        }

        fout << (hasCycle() ? "1" : "0") << std::endl;
        fout.close();
        return true;
    }

private:
    int V, E;
    adjiacent_map adj;
    std::unordered_set<int> vis;
    std::unordered_set<int> stack;

    bool dfsCycleDetect(int node) {
        vis.insert(node);

        stack.insert(node);
        for (int nnode : adj[node]) {
            if (stack.count(nnode)) {
                return true;
            }
            if (!vis.count(nnode) && dfsCycleDetect(nnode)) {
                return true;
            }
        }
        stack.erase(node);

        return false;
    }
};

int main(void) {
    Graph graph(0);
    if (!graph.readGraph("date.in"))
        return EXIT_FAILURE;
    if (!graph.writeResultToFile("date.out"))
        return EXIT_FAILURE;
    return EXIT_SUCCESS;
}
