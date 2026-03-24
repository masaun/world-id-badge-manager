//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title - IWorldID interface (for WorldID V4) 
 * @dev - Doc: https://docs.world.org/world-id/idkit/onchain-verification#2-verifying-uniqueness-proofs-in-worldidverifier-sol-world-id-4-0
 */
interface IWorldIDVerifier {
    function verify(
        uint256 nullifier,
        uint256 action,
        uint64 rpId,
        uint256 nonce,
        uint256 signalHash,
        uint64 expiresAtMin,
        uint64 issuerSchemaId,
        uint256 credentialGenesisIssuedAtMin,
        uint256[5] calldata zeroKnowledgeProof
    ) external view;
}
