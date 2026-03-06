# echo "Compile the smart contract files..."
# sh compileContracts.sh

echo "Load the environment variables from the .env file..."
#source .env
. ./.env

echo "Deploying & Verifying the WorldIDVerifier contract on BASE Testnet (via BaseScan)..."
forge script scripts/base-testnet/deployment/DeploymentForWorldIDVerifier_basescan.s.sol \
    --slow \
    --multi \
    --broadcast \
    --rpc-url ${BASE_TESTNET_RPC} \
    --chain-id ${BASE_TESTNET_CHAIN_ID} \
    --private-key ${BASE_TESTNET_PRIVATE_KEY} \
    --verify \
    --etherscan-api-key ${BASESCAN_API_KEY} \
    --gas-limit 10000000