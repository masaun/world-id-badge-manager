pragma solidity ^0.8.28;

import "forge-std/Script.sol";

/// @dev - The Solidity On-chain Verifier, which is generated via NoirJS/bb.js
import { IWorldID } from '../../../src/world-id-v3/world-id/interfaces/IWorldID.sol';
import { WorldIDV3BadgeManager } from "../../../src/world-id-v3/WorldIDV3BadgeManager.sol";

/**
 * @notice - Deployment script to deploy the DeployWorldIDV3BadgeManager contract on World Chain Sepolia
 */
contract DeployWorldIDV3BadgeManager is Script {

    function run() external {
        // Get the deployer's private key
        uint256 deployerPrivateKey = vm.envUint("WORLD_CHAIN_SEPOLIA_PRIVATE_KEY");
        
        // Get the World ID router address on World Chain Sepolia from the .env file
        address worldIdRouterAddress = vm.envAddress("WORLD_ID_ROUTER_ON_WORLD_CHAIN_SEPOLIA");
        IWorldID worldIdRouter = IWorldID(worldIdRouterAddress);
        
        vm.startBroadcast(deployerPrivateKey);

        // Step 1: Deploy the WorldIDV3BadgeManager contract
        console.log("Deploying the WorldIDV3BadgeManager...");
        WorldIDV3BadgeManager worldIDV3BadgeManager = new WorldIDV3BadgeManager(worldIdRouter);
        console.log("WorldIDV3BadgeManager deployed at:", address(worldIDV3BadgeManager));

        vm.stopBroadcast();

        // Print deployment summary
        console.log("\n=== Deployment Summary (on World Chain Sepolia) ===");
        console.log("WorldID Router:", worldIdRouterAddress);
        console.log("WorldIDV3BadgeManager:", address(worldIDV3BadgeManager));
    }
}