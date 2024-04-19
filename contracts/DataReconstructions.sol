pragma solidity ^0.8.0;

contract DataReconstruction {
    struct Fragment {
        string data;
        bytes32 hash; // Store hash as bytes32 for efficiency
    }

    mapping(uint => Fragment) public fragments;

    // Generate a hash of the input data using keccak256
    function simple_hash(string memory input) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(input));
    }

    // Function to reconstruct data from fragments
    function reconstruct_data() public view returns (string memory) {
        string memory result = "";
        for (uint i = 1; i <= 3; i++) { // Assuming fragment indexes 1 to 3
            Fragment storage fragment = fragments[i];
            if (fragment.hash != simple_hash(fragment.data)) {
                revert("Error: Data integrity verification failed.");
            }
            result = string(abi.encodePacked(result, fragment.data));
        }
        return result;
    }

    function setFragment(uint _index, string memory _data) public {
        bytes32 _hash = simple_hash(_data);
        fragments[_index] = Fragment(_data, _hash);
    }
}
