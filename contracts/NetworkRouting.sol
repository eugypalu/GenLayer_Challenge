// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract NetworkRouting {
    struct Edge {
        bytes1 destination;
        uint32 latency;
    }

    mapping(bytes1 => Edge[]) public graph;
    mapping(bytes1 => bool) public compressionNodes;

    function setGraph(bytes1 nodeId, bytes1[] memory destinations, uint32[] memory latencies) public {
        delete graph[nodeId];
        for (uint i = 0; i < destinations.length; i++) {
            graph[nodeId].push(Edge({
                destination: destinations[i],
                latency: latencies[i]
            }));
        }
    }

    function setCompressionNodes(bytes1[] memory nodes) public {
        for (uint i = 0; i < nodes.length; i++) {
            compressionNodes[nodes[i]] = true;
        }
    }

    function findMinimumLatencyPath(bytes1 source, bytes1 target) public view returns (uint32) {
        uint32[256] memory dist;
        bytes1[256] memory prev;
        bytes1[256] memory queue;
        uint8 queueSize = 0;

        for (uint i = 0; i < 256; i++) {
            dist[i] = type(uint32).max;
        }
        dist[uint8(source)] = 0;
        queue[queueSize++] = source;

        while (queueSize != 0) {
            bytes1 u = queue[--queueSize];
            uint8 uIdx = uint8(u);
            uint32 uDist = dist[uIdx];

            for (uint i = 0; i < graph[u].length; i++) {
                bytes1 v = graph[u][i].destination;
                uint8 vIdx = uint8(v);
                uint32 alt = uDist + graph[u][i].latency;

                if (compressionNodes[u] && alt / 2 < dist[vIdx]) {
                    alt /= 2;
                }

                if (alt < dist[vIdx]) {
                    dist[vIdx] = alt;
                    prev[vIdx] = u;
                    queue[queueSize++] = v;
                }
            }
        }

        return dist[uint8(target)];
    }
}
