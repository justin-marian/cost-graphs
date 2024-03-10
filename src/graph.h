#pragma once

#ifndef GRAPHTYPES_H
#define GRAPHTYPES_H

#include <vector>
#include <limits>
#include <unordered_map>
#include <unordered_set>

// Unreachable distance
constexpr int INF = std::numeric_limits<int>::max();

struct Node {
    int id;
    Node(int id) : id(id) {}
};

typedef std::pair<int, int> edge;
typedef std::vector<std::vector<edge>> adjacent_weight_map;
typedef std::unordered_map<int, std::vector<int>> adjacent_map;

#endif // GRAPHTYPES_H
