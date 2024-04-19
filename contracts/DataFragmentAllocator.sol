// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DataFragmentAllocator {
    function distributeFragments(uint[] memory riskFactors, uint fragments) public pure returns (uint) {
        uint n = riskFactors.length;
        uint[] memory fragmentCount = new uint[](n);
        uint[] memory risks = new uint[](n);
        uint maxRisk = 0;

        // Initialize risks with the base risk factor raised to the power of one (each has at least one fragment hypothetically)
        for (uint i = 0; i < n; i++) {
            risks[i] = riskFactors[i];
        }

        // Distribute fragments to minimize max risk
        for (uint i = 0; i < fragments; i++) {
            uint minRiskIndex = 0;
            uint minRiskValue = type(uint).max;

            // Find the center with the minimum resultant risk if added one more fragment
            for (uint j = 0; j < n; j++) {
                uint proposedRisk = risks[j] * riskFactors[j];
                if (proposedRisk < minRiskValue) {
                    minRiskValue = proposedRisk;
                    minRiskIndex = j;
                }
            }

            // Allocate fragment to this center
            fragmentCount[minRiskIndex]++;
            risks[minRiskIndex] = minRiskValue; // Update the risk directly

            // Update maxRisk if necessary
            if (risks[minRiskIndex] > maxRisk) {
                maxRisk = risks[minRiskIndex];
            }
        }

        return maxRisk;
    }
}
