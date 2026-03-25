pragma solidity ^0.8.28;

import "forge-std/Script.sol";

/// @dev - The WorldIDV3BadgeManagerForOffChainVerifiedProof.sol
import { WorldIDV3BadgeManagerForOffChainVerifiedProof } from "../../../src/world-id-v3/WorldIDV3BadgeManagerForOffChainVerifiedProof.sol";

/**
 * @notice - Deployment script to deploy the WorldIDV3BadgeManagerForOffChainVerifiedProof contract on World Chain Sepolia
 */
contract DeployWorldIDV3BadgeManagerForOffChainVerifiedProof is Script {

    function run() external {
        // Get the deployer's private key
        uint256 deployerPrivateKey = vm.envUint("WORLD_CHAIN_SEPOLIA_PRIVATE_KEY");
        
        // Get the app_id and action_id of World ID (https://developer.worldcoin.org)
        //string memory appId = vm.envString("WORLDCOIN_APP_ID");   
        //string memory actionId = vm.envString("WORLDCOIN_ACTION_ID");

        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Deploy the WorldIDV3BadgeManagerForOffChainVerifiedProof contract
        console.log("Deploying the WorldIDV3BadgeManagerForOffChainVerifiedProof...");
        WorldIDV3BadgeManagerForOffChainVerifiedProof worldIDV3BadgeManagerForOffChainVerifiedProof = new WorldIDV3BadgeManagerForOffChainVerifiedProof();
        console.log("WorldIDV3BadgeManagerForOffChainVerifiedProof deployed at:", address(worldIDV3BadgeManagerForOffChainVerifiedProof));

        vm.stopBroadcast();

        // Print deployment summary
        console.log("\n=== Deployment Summary (on World Chain Sepolia) ===");
        console.log("WorldIDV3BadgeManagerForOffChainVerifiedProof:", address(worldIDV3BadgeManagerForOffChainVerifiedProof));
    }
}