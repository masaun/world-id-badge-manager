import { createConfig, http } from 'wagmi'
import { type Chain } from 'viem'
import { injected, walletConnect } from '@wagmi/connectors'
import { createAppKit } from '@reown/appkit/react'
import { WagmiAdapter } from '@reown/appkit-adapter-wagmi'
import { base, baseSepolia } from 'wagmi/chains'

export const optimismSepoliaAnvilFork: Chain = {
	id: 11155420,
	name: "Optimism Sepolia Anvil Fork",
	nativeCurrency: {
        decimals: 18,
        name: "Optimism Sepolia Anvil Fork Ether",
        symbol: "ETH",
	},
	rpcUrls: {
	    default: { http: ["http://127.0.0.1:8545/"] },
	},
	testnet: true,
};

export const chains = [optimismSepoliaAnvilFork, baseSepolia, base];

// Get projectId at https://cloud.reown.com
export const projectId = process.env.NEXT_PUBLIC_PROJECT_ID || process.env.NEXT_PUBLIC_WALLETCONNECT_ID

// Only create AppKit if we have a valid project ID
if (!projectId) {
  console.warn('No WalletConnect/Reown project ID found. Please set NEXT_PUBLIC_PROJECT_ID in your .env file. Get one at https://cloud.reown.com')
}

// Create wagmiAdapter (Required)
const wagmiAdapter = new WagmiAdapter({
  ssr: true,
  projectId: projectId || 'dummy-project-id', // Fallback to prevent crashes
  networks: [optimismSepoliaAnvilFork, baseSepolia, base]
})

export const config = wagmiAdapter.wagmiConfig

// Create modal only if we have a valid project ID
if (projectId) {
  createAppKit({
    adapters: [wagmiAdapter],
    projectId,
    networks: [optimismSepoliaAnvilFork, baseSepolia, base],
    defaultNetwork: baseSepolia, // Default to Base Sepolia for testnet development
    metadata: {
      name: "World ID Onchain Verifier",
      description: "World ID Onchain Verifier",
      url: typeof window !== 'undefined' ? window.location.origin : 'https://localhost:3000',
      icons: ['https://avatars.githubusercontent.com/u/37784886']
    },
    features: {
      analytics: false, // Disable analytics to prevent API calls that might cause 403
      email: false, // Disable email to reduce API calls
      socials: [], // Disable social logins to reduce API calls
    },
    themeMode: 'light',
    themeVariables: {
      '--w3m-z-index': 1000
    }
  })
}