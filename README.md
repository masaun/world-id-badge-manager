# World ID Badge Manager contract

## Overview

This is the World ID Badge Manager contract, which:
- handle the **World ID `v3` (`Legacy`)** proof, which is generated and verified `off-chain`, via the `WorldIDV3BadgeManagerForOffChainVerifiedProof.sol`.
   (Details are here: https://docs.world.org/world-id/idkit/integrate#step-5-verify-the-proof-in-your-backend)

- Once the `On-chain` verifier contract for the **World ID `v4`** proof will be deployed on World Chain mainnet / sepolia by the World team, we will be replace the off-chain verification part with the on-chain verification. 
  (Details are here: https://docs.world.org/world-id/idkit/onchain-verification#2-verifying-uniqueness-proofs-in-worldidverifier-sol-world-id-4-0 )

<br>

## Functions in the `WorldIDV3BadgeManagerForOffChainVerifiedProof.sol`

- `storeVerifiedWorldIDV3ProofData()`: 
   - Once a `World ID v3 Proof` generation and verification would be completed `off-chain` (`backend`), the proof data is stored into the `on-chain` storage via the `storeVerifiedWorldIDV3ProofData()` of the `WorldIDV3BadgeManagerForOffChainVerifiedProof.sol`
   
- `getVerifiedWorldIDV3ProofData()`
   - you can check a data of the verified `World ID v3 Proof` by invoking the `getVerifiedWorldIDV3ProofData()` of the `WorldIDV3BadgeManagerForOffChainVerifiedProof.sol`)

- `hasWorldIDV3Badge()`: 
   - You can check wether a user has a `World ID v3 Proof` in the form of `World ID v3 Proof` badge by invoking the `hasWorldIDV3Badge()` of the `WorldIDV3BadgeManagerForOffChainVerifiedProof.sol`

<br>

## Deployed Contract Addresses (on `World Chain mainnet / sepolia`)

### Existing deployed-contract addresses (on `World Chain - Mainnet`)
| Contract | Address |
|----------|---------|
| **WorldIDV3BadgeManagerForOffChainVerifiedProof.sol** | [`0x68fC0B89aa8591ff49065971ADFECeE42eF4cA36`](https://worldscan.org/address/0x68fc0b89aa8591ff49065971adfecee42ef4ca36) |


### Newly deployed-contract addresses (on `World Chain - Sepolia`) by this project
| Contract | Address |
|----------|---------|
| **WorldIDV3BadgeManagerForOffChainVerifiedProof.sol** | [`0xED169AF4E8d68d167B8c7bf66f241f30B8cA8083`](https://sepolia.worldscan.org/address/0xed169af4e8d68d167b8c7bf66f241f30b8ca8083) |

<br>

## Techinical Stack

- **Smart Contract**: `Solidity`
- **Smart Contract Framework**: `Foundry`
- **Blockchain**: World Chain mainnet and sepolia 

<br>

<hr>

# Installation

## Smart contract `deployment` scripts

### Smart contract `deployment` script on `World Chain - Sepolia Testnet`

- Deploy the `WorldIDV3BadgeManagerForOffChainVerifiedProof.sol` on `World Chain - Sepolia Testnet`
```bash
cd contracts
sh scripts/world-chain-sepolia/deployments/DeployWorldIDV3BadgeManagerForOffChainVerifiedProof.sh
```

<br>

### Smart contract `deployment` script on `World Chain - Mainnet`

- Deploy the `WorldIDV3BadgeManagerForOffChainVerifiedProof.sol` on `World Chain - Mainnet`
```bash
cd contracts
sh scripts/world-chain-mainnet/deployments/DeployWorldIDV3BadgeManagerForOffChainVerifiedProof.sh
```

<br>

## References

- World ID: 
  - API Reference: https://docs.world.org/api-reference/developer-portal/verify
  - `IDKit` integration & `Off-chain` proof verification: https://docs.world.org/world-id/idkit/integrate
  - On-chain verification: https://docs.world.org/world-id/idkit/onchain-verification
