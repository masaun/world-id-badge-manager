//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { IWorldID } from "./world-id/interfaces/IWorldID.sol";

/**
 * @title - VerifyLegacyV3 contract
 */
contract VerifyLegacyV3 {
    IWorldID public immutable worldIdRouter;
    uint256 public constant GROUP_ID = 1; // Orb
    mapping(uint256 => bool) public nullifierHashes;
    error InvalidNullifier();

    constructor(IWorldID _worldIdRouter) {
        worldIdRouter = _worldIdRouter;
    }

    function verifyLegacyAndExecute(
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
}