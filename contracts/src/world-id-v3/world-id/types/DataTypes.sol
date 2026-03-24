//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library DataTypes {

    struct WorldIDV3OffChainProofVerificationData {
        string appId;
        string actionId;
        string rpId;
        string nonce;
        string identifier; // "orb"
        string merkleRoot;
        string nullifier;
        string proof;
        string signalHash;
        string environment;      // "production"
        string protocol_version; // "3.0"
    }

}