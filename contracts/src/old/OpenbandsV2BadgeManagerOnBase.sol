// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { WorldIDVerifier } from "./WorldIDVerifier.sol";
import { DataType } from "./dataType/DataType.sol";

/**
 * @notice - The Self On-Chain Records contract can verify a proof of humanity from the WorldIDVerifier contract.
 * @notice - The Self On-Chain Records contract that the verification status from WorldIDVerifier and a given wallet address are stored and associated.
 */
contract OpenbandsV2BadgeManagerOnBase {
    WorldIDVerifier public worldIDVerifier;

    // @dev - Store an individual's proof related record.
    mapping (address => DataType.WorldIDVerifierRecord) public worldIDVerifierRecords;

    constructor(
        WorldIDVerifier _worldIDVerifier
    ) {
        worldIDVerifier = _worldIDVerifier;
    }

    /**
     * @notice - Store the verification data of a given wallet address (of user who is a caller) into this contract to associate those data with a given wallet address (of user who is a caller).
     * @dev - groupId (group ID) is always 1 in World ID.
     * @param root The root (returned by the IDKit widget).
     * @param signal An arbitrary input from the user, usually the user's wallet address
     * @param nullifierHash The nullifier hash for this proof, preventing double signaling (returned by the IDKit widget).
     * @param proof The zero-knowledge proof that demonstrates the claimer is registered with World ID (returned by the IDKit widget).
     */
    function storeVerificationData(
        address signal, 
        uint256 root, 
        uint256 nullifierHash, 
        uint256[8] calldata proof
    ) public returns (bool) {
        // @dev - A wallet address of user who is a caller (msg.sender).
        address walletAddress = msg.sender;
        require(walletAddress != address(0), "Invalid user address");

        // @dev - Verify if the user has a valid proof of humanity.
        _verifyProof(signal, root, nullifierHash, proof); // @dev - A caller needs to pay for a gas fee - because the _verifyProof() is a write function.

        // @dev - Get a verification config ID from the WorldIDVerifier contract
        //bytes32 verificationConfigId = worldIDVerifier.verificationConfigId();

        // @dev - Store the verification status from WorldIDVerifier and a given wallet address
        worldIDVerifierRecords[walletAddress] = DataType.WorldIDVerifierRecord({
            //verificationConfigId: verificationConfigId,
            nullifier: nullifierHash,
            walletAddress: walletAddress,
            createdAt: block.timestamp
        });
    }

    /**
     * @notice - Verify if the user has a valid proof of humanity.
     * @notice - This function is a write function and requires a gas fee.
     * @dev - The WorldIDVerifier# verifyAndExecute(() is the write function - And therefore, a caller needs to pay for a gas fee.
     */
    function _verifyProof(address signal, uint256 root, uint256 nullifierHash, uint256[8] calldata proof) internal returns (bool) {
        // @dev - WorldIDVerifier# verifyAndExecute()
        worldIDVerifier.verifyAndExecute(signal, root, nullifierHash, proof);

        // Check if verification was successful in the WorldIDVerifier contract
        //return worldIDVerifier.verificationSuccessful();
    }

}
