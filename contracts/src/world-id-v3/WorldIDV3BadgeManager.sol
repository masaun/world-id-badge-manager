//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { IWorldID } from "./world-id/interfaces/IWorldID.sol";

/**
 * @title - WorldIDV3BadgeManager contract
 */
contract WorldIDV3BadgeManager {
    IWorldID public immutable worldIdRouter;
    uint256 public constant GROUP_ID = 1; // Orb
    mapping(uint256 => bool) public nullifierHashes;
    error InvalidNullifier();

    constructor(IWorldID _worldIdRouter) {
        worldIdRouter = _worldIdRouter;
    }

    // @dev - Verify a ZK Proof + Store the nullifier hash into the on-chain storage (= "nullifierHashes" storage) in order to prevent double-signaling. This function is a write function and requires a gas fee. 
    function verifyWorldIDV3ProofAndStoreIntoOnChainStorage(
        uint256 root,
        uint256 signalHash,
        uint256 nullifierHash,
        uint256 externalNullifierHash,
        uint256[8] calldata proof
    ) external {
        if (nullifierHashes[nullifierHash]) revert InvalidNullifier();

        worldIdRouter.verifyProof(
            root,
            GROUP_ID,
            signalHash,
            nullifierHash,
            externalNullifierHash,
            proof
        );

        nullifierHashes[nullifierHash] = true;

        // Execute protected business logic here.
    }

    // @dev - Veify a ZK Proof without storing the nullifier hash into the on-chain storage. This function is a view function and does not require a gas fee. Note that this function does not prevent double-signaling, so it should be used with caution.
    function verifyWorldIDV3Proof(
        uint256 root,
        uint256 signalHash,
        uint256 nullifierHash,
        uint256 externalNullifierHash,
        uint256[8] calldata proof
    ) external view {
        worldIdRouter.verifyProof(
            root,
            GROUP_ID,
            signalHash,
            nullifierHash,
            externalNullifierHash,
            proof
        );
    }
}