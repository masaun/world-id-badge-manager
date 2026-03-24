//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library DataTypes {

    struct VerifiedWorldIDV3ProofData {
        uint256 appId;
        uint256 actionId;
        uint64 rpId;
        uint256 nonce;
        string identifier; // "orb"
        uint256 merkleRoot;
        uint256 nullifier;
        string proof;
        uint256 signalHash;
        string environment;      // "production"
        string protocolVersion;  // "3.0"
    }

}