#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Parse arguments
WORLD_ID_V3_BADGE_MANAGER_FOR_OFFCHAIN_VERIFIED_PROOF_ADDRESS=$2

# Get the contracts root directory (3 levels up from this script)
CONTRACTS_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
# Check if .env file exists
if [ ! -f "$CONTRACTS_ROOT/.env" ]; then
    echo -e "${RED}Error: .env file not found at $CONTRACTS_ROOT/.env${NC}"
    echo "Please create a .env file based on .env.example in the contracts directory"
    exit 1
fi

# Load environment variables
source "$CONTRACTS_ROOT/.env"

# Change to contracts root for forge commands
cd "$CONTRACTS_ROOT"

if [ "$VERIFY_ONLY" = true ]; then
    # ============================================
    # VERIFICATION ONLY MODE
    # ============================================
    echo -e "${GREEN}====================================${NC}"
    echo -e "${GREEN}Verifying Contracts on World Chain Scan (on World Chain Mainnet) ${NC}"
    echo -e "${GREEN}====================================${NC}"
    echo ""

    # Validate
    if [ -z "$WORLD_CHAIN_SCAN_API_KEY" ]; then
        echo -e "${RED}Error: WORLD_CHAIN_SCAN_API_KEY not set in .env${NC}"
        echo "Get your API key from: https://worldchain.scan.io/apis"
        exit 1
    fi

    if [ -z "$WORLD_CHAIN_MAINNET_RPC_URL" ]; then
        echo -e "${RED}Error: world_chain_mainnet_RPC_URL not set in .env${NC}"
        exit 1
    fi

    # Get addresses interactively if not provided
    if [ -z "$WORLD_ID_V3_BADGE_MANAGER_FOR_OFFCHAIN_VERIFIED_PROOF_ADDRESS" ]; then
        echo -e "${YELLOW}Enter World ID V3 Badge Manager contract address:${NC}"
        read WORLD_ID_V3_BADGE_MANAGER_ADDRESS
    fi

    echo ""
    echo -e "${YELLOW}Verifying World ID V3 Badge Manager at $WORLD_ID_V3_BADGE_MANAGER_FOR_OFFCHAIN_VERIFIED_PROOF_ADDRESS...${NC}"
    forge verify-contract \
      --rpc-url world_chain_mainnet \
      --etherscan-api-key "$WORLD_CHAIN_SCAN_API_KEY" \
      --verifier-url https://api-worldchain.scan.io/api \
      "$WORLD_ID_V3_BADGE_MANAGER_FOR_OFFCHAIN_VERIFIED_PROOF_ADDRESS" \
      src/world-id-v3/WorldIDV3BadgeManagerForOffChainVerifiedProof.sol:WorldIDV3BadgeManagerForOffChainVerifiedProof \
      || echo -e "${YELLOW}WorldIDV3BadgeManagerForOffChainVerifiedProof verification failed or already verified${NC}"

    echo ""

    echo ""
    echo -e "${GREEN}====================================${NC}"
    echo -e "${GREEN}Verification Process Complete!${NC}"
    echo -e "${GREEN}====================================${NC}"
    echo ""
    echo "Check contracts on World Chain Scan:"
    echo "World ID V3 Badge Manager: https://worldscan.org/address/$WORLD_ID_V3_BADGE_MANAGER_FOR_OFFCHAIN_VERIFIED_PROOF_ADDRESS"

else
    # ============================================
    # DEPLOYMENT MODE
    # ============================================
    echo -e "${GREEN}====================================${NC}"
    echo -e "${GREEN}Deploying to World Chain Mainnet${NC}"
    echo -e "${GREEN}====================================${NC}"
    echo ""

    # Validate required variables
    if [ -z "$WORLD_CHAIN_MAINNET_PRIVATE_KEY" ]; then
        echo -e "${RED}Error: world_chain_mainnet_PRIVATE_KEY not set in .env${NC}"
        exit 1
    fi

    if [ -z "$WORLD_CHAIN_MAINNET_RPC_URL" ]; then
        echo -e "${RED}Error: world_chain_mainnet_RPC_URL not set in .env${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Building contracts...${NC}"
    forge build

    echo ""
    echo -e "${YELLOW}Deploying contracts...${NC}"

    # Deploy with or without verification
    if [ -n "$WORLD_CHAIN_SCAN_API_KEY" ]; then
        echo "Verification enabled"
        forge script scripts/world-chain-mainnet/deployments/DeployWorldIDV3BadgeManagerForOffChainVerifiedProof.s.sol:DeployWorldIDV3BadgeManagerForOffChainVerifiedProof \
          --rpc-url world_chain_mainnet \
          --broadcast \
          --verify \
          --etherscan-api-key "$WORLD_CHAIN_SCAN_API_KEY"
    else
        echo "Verification disabled (no WORLD_CHAIN_SCAN_API_KEY)"
        forge script scripts/world-chain-mainnet/deployments/DeployWorldIDV3BadgeManagerForOffChainVerifiedProof.s.sol:DeployWorldIDV3BadgeManagerForOffChainVerifiedProof \
          --rpc-url world_chain_mainnet \
          --broadcast
    fi

    echo ""
    echo -e "${GREEN}====================================${NC}"
    echo -e "${GREEN}Deployment Complete!${NC}"
    echo -e "${GREEN}====================================${NC}"
    echo ""
    echo "Check the output above for deployed contract addresses"
    echo "You can view them on World Chain Scan: https://worldscan.org/"
    
    if [ -z "$WORLD_CHAIN_SCAN_API_KEY" ]; then
        echo ""
        echo -e "${YELLOW}Tip: To verify contracts manually, run:${NC}"
        echo "./deploy.sh --verify-only <world_id_router> <world_id_v3_badge_manager>"
    fi
fi
