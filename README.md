# [Cost graphs](#summary)

Algorithms for **cycle detectio**n and **finding single-source shortest paths** using different approaches such as **topological sorting** and the **Shortest Path Faster Algorithm (SPFA)**. Each algorithm is explained briefly, along with its time complexity and usage.

## [Cycle Detection](https://en.wikipedia.org/wiki/Cycle_(graph_theory))

The `Cycle Detection` algorithm used in the provided code is based on **Depth-First Search (DFS)**. It explores the graph, tracking visited nodes and maintaining a stack of currently active nodes. If during the traversal, DFS encounters an already visited node in the stack, it indicates the presence of a cycle.

- `DFS Traversal`: Initiates DFS from each unvisited vertex, exploring recursively by prioritizing depth over breadth.
- `Visited Set`: Tracks visited vertices to prevent redundant exploration, ensuring each vertex is processed once.
- `Stack`: Maintains a stack of vertices being explored, helping detect cycles by identifying back edges.

## Single-Source Shortest Path

### [Topological Sort](https://en.wikipedia.org/wiki/Topological_sorting)

The `Topological Sort` algorithm leverages topological sorting to relax edges in a specific order, ensuring that each vertex's shortest path is computed only after all its predecessors' shortest paths have been determined.

- `Topological Sort`: The algorithm performs a topological sort of the graph, ensuring that vertices are ordered such that no edge points backward in the order.
- `Edge Relaxation`: After obtaining the topological order, the algorithm iterates through each vertex in this order and relaxes its outgoing edges, updating shortest path distances accordingly.

### [Shortest Path Faster Algorithm](https://en.wikipedia.org/wiki/Shortest_path_faster_algorithm)

The `Shortest Path Faster Algorithm (SPFA)` is a variation of the Bellman-Ford algorithm, designed to handle graphs with negative edge weights efficiently. SPFA maintains a queue of vertices to optimize relaxation steps, avoiding unnecessary relaxation iterations unless there's a change in the shortest path estimate.

- `Queue`: SPFA uses a queue to keep track of vertices whose distances may need to be updated. This queue is populated during the relaxation process.
- `Edge Relaxation with Optimization`: Unlike **Bellman-Ford**, SPFA **relaxes edges dynamically**. If the shortest path to a vertex is updated, it is added to the queue for further relaxation. This optimization **prevents redundant relaxation steps**.

## Summary

| Algorithm                                          | Time Complexity        | Space Complexity        | Description                                                                                                         |
|----------------------------------------------------|------------------------|-------------------------|---------------------------------------------------------------------------------------------------------------------|
| **Cycle Detection**                               | ***O(V + E)***             | ***O(V + E)***              | Detects cycles in the graph efficiently using Depth-First Search (DFS).                                             |
| *Single-Source Shortest Path* Using **Topological Sort** | ***O(V + E)***          | ***O(V + E)***              | Computes shortest paths from a single source vertex in a directed acyclic graph (DAG) using topological sorting.   |
| *Single-Source Shortest Path* Using **SPFA**             | ***O(E) (average)***   | ***O(V)***                  | Finds shortest paths from a single source vertex in a graph with negative edge weights efficiently using SPFA.     |
