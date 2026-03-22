//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title - IWorldID interface (for WorldID V3) 
 * @dev - Doc: https://docs.world.org/world-id/reference/contracts
 */
interface IWorldID {
    // @param root - The root (returned by the IDKit widget).
    // @param groupId - The group ID
    // @param signalHash - An arbitrary input from the user, usually the user's wallet address
    // @param nullifierHash - The nullifier for this proof, preventing double signaling (returned by the IDKit widget).
    // @param externalNullifierHash - The keccak256 hash of the externalNullifier to verify. The externalNullifier is computed from the app_id and action.
    // @param proof - The zero-knowledge proof that demonstrates the claimer is registered with World ID (returned by the IDKit widget).
    function verifyProof(
        uint256 root,
        uint256 groupId,
        uint256 signalHash,
        uint256 nullifierHash,
        uint256 externalNullifierHash,
        uint256[8] calldata proof
    ) external view;
}
