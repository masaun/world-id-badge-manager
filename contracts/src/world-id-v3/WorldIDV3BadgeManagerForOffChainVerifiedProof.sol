// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { DataTypes } from "./world-id/types/DataTypes.sol";

/**
 * @title - WorldIDV3BadgeManager contract for the Off-chain verified proof
 */
contract WorldIDV3BadgeManagerForOffChainVerifiedProof {
    mapping(uint256 => bool) public nullifierHashes;
    mapping(address => uint256) public nullifierHashesWithWalletAddresses;

    // @dev - On-chain stroage for the WorldIDV3OffChainProofVerificationData of a given wallet adddress
    mapping(address => DataTypes.WorldIDV3OffChainProofVerificationData) public worldIDV3OffChainProofVerificationDatas;

    error InvalidNullifier();

    constructor() {}

    /*
     * @notice - Store the nullifier hash of the World ID v3 Proof into the on-chain storage (= "nullifierHashes" storage) in order to prevent double-signaling. This function is a write function and requires a gas fee. 
     * @param root - The root (returned by the IDKit widget).
     * @param signal - An arbitrary input from the user, usually the user's wallet address
     * @param nullifierHash - The nullifier for this proof, preventing double signaling (returned by the IDKit widget).
     * @param externalNullifierHash - The keccak256 hash of the externalNullifier to verify. The externalNullifier is computed from the app_id and action.
     * @param proof - The zero-knowledge proof that demonstrates the claimer is registered with World ID (returned by the IDKit widget).
     */
    function storeWorldIDV3Proof(
        string memory appId,
        string memory actionId,
        string memory rpId,
        uint256 root,
        uint256 signalHash,
        uint256 nullifierHash,
        //uint256 externalNullifierHash,
        uint256[8] calldata proof
    ) external {
        if (nullifierHashes[nullifierHash]) revert InvalidNullifier();

        // @dev - Store the nullifier hash into the on-chain storage to prevent double-signaling.
        nullifierHashes[nullifierHash] = true;

        // @dev - Store the nullifier hash with the wallet address into the on-chain storage for later use (e.g., checking if a wallet address has World ID V3 Badge).
        nullifierHashesWithWalletAddresses[msg.sender] = nullifierHash;
    }

    /*
     * @notice Check if a wallet address has World ID V3 Badge
     * @dev - This function checks the following conditions:
     *        - If the nullifierHash is stored in the nullifierHashesWithWalletAddresses storage for the wallet address, it returns true, indicating that the user has the World ID V3 Badge.  
     *        - If the nullifierHash is not stored in the nullifierHashesWithWalletAddresses storage for the wallet address, it returns false, indicating that the user has not the World ID V3 Badge.  
     * @param walletAddress The address to check
     * @return _hasWorldIdV3Badge True if the address has World ID V3 Badge, false otherwise
     */
    function hasWorldIDV3Badge(address walletAddress) external view returns (bool _hasWorldIdV3Badge) {
        uint256 nullifierHash = nullifierHashesWithWalletAddresses[walletAddress];
        bool isNullifierStored = nullifierHashes[nullifierHash];
        
        if (nullifierHash != 0 && isNullifierStored == true) {
            return true;
        } else {
            return false;
        }
    }
}