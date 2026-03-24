// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { DataTypes } from "./world-id/types/DataTypes.sol";
import { Errors } from "./world-id/types/Errors.sol";

/**
 * @title - WorldIDV3BadgeManager contract for the Off-chain verified proof
 */
contract WorldIDV3BadgeManagerForOffChainVerifiedProof {
    // @dev - On-chain stroage for the WorldIDV3OffChainProofVerificationData of a given wallet adddress
    mapping(address => DataTypes.WorldIDV3OffChainProofVerificationData) public worldIDV3OffChainProofVerificationDatas;

    /*
     * @notice - Constructor
     */
    constructor() {}

    /*
     * @notice - Store a World ID v3 Proof-related data, which is verified off-chain, into the on-chain storage
     */
    function storeVerifiedWorldIDV3ProofData(
        uint256 appId,
        uint256 actionId,
        uint64 rpId,
        uint256 nonce,
        string memory identifier, // "orb"
        uint256 merkleRoot,
        uint256 nullifier,
        string memory proof,
        uint256 signalHash,
        string memory environment,     // "production"
        string memory protocolVersion  // "3.0"
    ) external {
        // @dev - Store a World ID v3 Proof-related data, which is verified off-chain, into the on-chain storage
        DataTypes.WorldIDV3OffChainProofVerificationData storage worldIDV3OffChainProofVerificationData = worldIDV3OffChainProofVerificationDatas[msg.sender];
        worldIDV3OffChainProofVerificationData.appId = appId;
        worldIDV3OffChainProofVerificationData.rpId = rpId;
        worldIDV3OffChainProofVerificationData.nonce = nonce;
        worldIDV3OffChainProofVerificationData.identifier = identifier; // "orb"
        worldIDV3OffChainProofVerificationData.merkleRoot = merkleRoot;
        worldIDV3OffChainProofVerificationData.nullifier = nullifier;
        worldIDV3OffChainProofVerificationData.proof = proof;
        worldIDV3OffChainProofVerificationData.signalHash = signalHash;
        worldIDV3OffChainProofVerificationData.environment = environment;         // "production"
        worldIDV3OffChainProofVerificationData.protocolVersion = protocolVersion; // "3.0"
    }

    /*
     * @notice Check if a wallet address has World ID V3 Badge
     * @dev - This function checks the following conditions:
     *        - If the nullifier is stored in the worldIDV3OffChainProofVerificationDatas storage for the wallet address, it returns true, indicating that the user has the World ID V3 Badge.  
     *        - If the nullifier is not stored in the worldIDV3OffChainProofVerificationDatas storage for the wallet address, it returns false, indicating that the user has not the World ID V3 Badge.  
     * @param walletAddress The address to check
     * @return _hasWorldIdV3Badge True if the address has World ID V3 Badge, false otherwise
     */
    function hasWorldIDV3Badge(address walletAddress) external view returns (bool _hasWorldIdV3Badge) {
        DataTypes.WorldIDV3OffChainProofVerificationData memory worldIDV3OffChainProofVerificationData = worldIDV3OffChainProofVerificationDatas[walletAddress];
        uint256 nullifier = worldIDV3OffChainProofVerificationData.nullifier;
        
        if (nullifier != 0) {
            return true;
        } else {
            return false;
        }
    }
}