// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { DataTypes } from "./world-id/types/DataTypes.sol";
import { Errors } from "./world-id/types/Errors.sol";

/**
 * @title - WorldIDV3BadgeManager contract for the Off-chain verified proof
 */
contract WorldIDV3BadgeManagerForOffChainVerifiedProof {
    // @dev - On-chain stroage for the WorldIDV3OffChainProofVerificationData of a given wallet adddress
    mapping(address => DataTypes.VerifiedWorldIDV3ProofData) public verifiedWorldIDV3ProofDatas;

    /*
     * @notice - Constructor
     */
    constructor() {}

    /*
     * @notice - Store a World ID v3 Proof-related data, which is verified off-chain, into the on-chain storage
     */
    function storeVerifiedWorldIDV3ProofData(
        string memory appId,
        string memory actionId,
        string memory rpId,
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
        DataTypes.VerifiedWorldIDV3ProofData storage verifiedWorldIDV3ProofData = verifiedWorldIDV3ProofDatas[msg.sender];
        verifiedWorldIDV3ProofData.appId = appId;
        verifiedWorldIDV3ProofData.rpId = rpId;
        verifiedWorldIDV3ProofData.nonce = nonce;
        verifiedWorldIDV3ProofData.identifier = identifier; // "orb"
        verifiedWorldIDV3ProofData.merkleRoot = merkleRoot;
        verifiedWorldIDV3ProofData.nullifier = nullifier;
        verifiedWorldIDV3ProofData.proof = proof;
        verifiedWorldIDV3ProofData.signalHash = signalHash;
        verifiedWorldIDV3ProofData.environment = environment;         // "production"
        verifiedWorldIDV3ProofData.protocolVersion = protocolVersion; // "3.0"
    }

    /*
     * @notice - Get a World ID v3 Proof-related data, which is verified off-chain, into the on-chain storage
     */
    function getVerifiedWorldIDV3ProofData(address walletAddress) external returns (DataTypes.VerifiedWorldIDV3ProofData memory _verifiedWorldIDV3ProofData) {
        DataTypes.VerifiedWorldIDV3ProofData memory verifiedWorldIDV3ProofData = verifiedWorldIDV3ProofDatas[msg.sender];
        return verifiedWorldIDV3ProofData;
    }

    /*
     * @notice Check if a wallet address has World ID V3 Badge
     * @dev - This function checks the following conditions:
     *        - If the nullifier is stored in the worldIDV3OffChainProofVerificationDatas storage for the wallet address, it returns true, indicating that the user has the World ID V3 Badge.  
     *        - If the nullifier is not stored in the worldIDV3OffChainProofVerificationDatas storage for the wallet address, it returns false, indicating that the user has not the World ID V3 Badge.  
     * @param walletAddress - The address to check
     * @return _hasWorldIdV3Badge - True if the address has World ID V3 Badge, false otherwise
     */
    function hasWorldIDV3Badge(address walletAddress) external view returns (bool _hasWorldIdV3Badge) {
        DataTypes.VerifiedWorldIDV3ProofData memory verifiedWorldIDV3ProofData = verifiedWorldIDV3ProofDatas[walletAddress];
        uint256 nullifier = verifiedWorldIDV3ProofData.nullifier;
        
        if (nullifier != 0) {
            return true;
        } else {
            return false;
        }
    }
}