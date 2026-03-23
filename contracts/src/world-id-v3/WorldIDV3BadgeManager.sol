//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { IWorldID } from "./world-id/interfaces/IWorldID.sol";
import { ByteHasher } from './world-id/helpers/ByteHasher.sol';

/**
 * @title - WorldIDV3BadgeManager contract
 */
contract WorldIDV3BadgeManager {
    using ByteHasher for bytes;

    IWorldID public immutable worldIdRouter;

    uint256 public constant GROUP_ID = 1; // Orb

	/// @dev - The contract's external nullifier hash
	//bytes internal externalNullifier;
    //uint256 internal externalNullifierHash;
    
    mapping(uint256 => bool) public nullifierHashes;
    mapping(address => uint256) public nullifierHashesWithWalletAddresses;

	/// @param nullifierHash The nullifier hash for the verified proof
	/// @dev A placeholder event that is emitted when a user successfully verifies with World ID
	event Verified(uint256 nullifierHash);
    
    error InvalidNullifier();

    /*
     * @notice - Constructor
	 * @param _worldIdRouter - The WorldID router that will verify the proofs
	 * @param _appId - The World ID's app ID
	 * @param _actionId - The World ID's action ID
     */
    constructor(
        IWorldID _worldIdRouter
        //string memory _appId, 
        //string memory _actionId
    ) {
        worldIdRouter = _worldIdRouter;
        //externalNullifier = abi.encodePacked(abi.encodePacked(_appId).hashToField(), _actionId);
        //externalNullifierHash = externalNullifier.hashToField();
    }

    /*
     * @notice - Compute the externalNullifierHash
     */
    function _computeExternalNullifierHash(
        string memory _appId, 
        string memory _actionId
    ) internal view returns (uint256 _externalNullifierHash) {
        bytes memory externalNullifier = abi.encodePacked(abi.encodePacked(_appId).hashToField(), _actionId);
        uint256 externalNullifierHash = externalNullifier.hashToField();

        return externalNullifierHash;
    }

    /*
     * @notice - Verify a ZK Proof + Store the nullifier hash into the on-chain storage (= "nullifierHashes" storage) in order to prevent double-signaling. This function is a write function and requires a gas fee. 
     * @param root - The root (returned by the IDKit widget).
     * @param signal - An arbitrary input from the user, usually the user's wallet address
     * @param nullifierHash - The nullifier for this proof, preventing double signaling (returned by the IDKit widget).
     * @param externalNullifierHash - The keccak256 hash of the externalNullifier to verify. The externalNullifier is computed from the app_id and action.
     * @param proof - The zero-knowledge proof that demonstrates the claimer is registered with World ID (returned by the IDKit widget).
     */
    function verifyWorldIDV3ProofAndStoreIntoOnChainStorage(
        string memory appId,
        string memory actionId,
        uint256 root,
        uint256 signalHash,
        uint256 nullifierHash,
        //uint256 externalNullifierHash,
        uint256[8] calldata proof
    ) external {
        if (nullifierHashes[nullifierHash]) revert InvalidNullifier();

        // @dev - Compute tne externalNullifierHash
        uint256 externalNullifierHash = _computeExternalNullifierHash(appId, actionId);

        // @dev - Reverts if the zero-knowledge proof is invalid.
        worldIdRouter.verifyProof(
            root,
            GROUP_ID,
            signalHash,
            nullifierHash,
            externalNullifierHash,
            proof
        );

        // @dev - Store the nullifier hash into the on-chain storage to prevent double-signaling.
        nullifierHashes[nullifierHash] = true;

        // @dev - Store the nullifier hash with the wallet address into the on-chain storage for later use (e.g., checking if a wallet address has World ID V3 Badge).
        nullifierHashesWithWalletAddresses[msg.sender] = nullifierHash;
    }

    /*
     * @notice - Veify a ZK Proof without storing the nullifier hash into the on-chain storage. This function is a view function and does not require a gas fee. Note that this function does not prevent double-signaling, so it should be used with caution.
     * @dev - Note that a double-signaling check is not included here, and should be carried
     * @param root The of the Merkle tree
     * @param groupId The id of the Semaphore group
     * @param signalHash A keccak256 hash of the Semaphore signal
     * @param nullifierHash The nullifier hash
     * @param externalNullifierHash A keccak256 hash of the external nullifier
     * @param proof The zero-knowledge proof
     */
    function verifyWorldIDV3Proof(
        string memory appId,
        string memory actionId,
        uint256 root,
        uint256 signalHash,
        uint256 nullifierHash,
        uint256 externalNullifierHash,
        uint256[8] calldata proof
    ) external view {
        // @dev - Compute tne externalNullifierHash
        uint256 externalNullifierHash = _computeExternalNullifierHash(appId, actionId);

        // @dev - Reverts if the zero-knowledge proof is invalid.
        worldIdRouter.verifyProof(
            root,
            GROUP_ID,
            signalHash,
            nullifierHash,
            externalNullifierHash,
            proof
        );
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