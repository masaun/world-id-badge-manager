/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  experimental: {
    esmExternals: 'loose',
  },
  webpack: (config, { isServer, webpack }) => {
    // Handle import assertions by transforming them
    config.module.rules.push({
      test: /\.m?js$/,
      include: /node_modules\/@base-org/,
      use: {
        loader: 'string-replace-loader',
        options: {
          search: /import\s+(.+?)\s+from\s+(['"].*?['"])\s+with\s+\{\s*type:\s*['"]json['"]\s*\}/g,
          replace: 'import $1 from $2',
          flags: 'g'
        }
      }
    })
    
    // Add fallbacks for node modules
    config.resolve.fallback = {
      ...config.resolve.fallback,
      fs: false,
      net: false,
      tls: false,
      crypto: false,
      stream: false,
      url: false,
      zlib: false,
      http: false,
      https: false,
      assert: false,
      os: false,
      path: false,
    }
    
    // Handle experiments
    config.experiments = {
      ...config.experiments,
      topLevelAwait: true,
    }
    
    return config
  },
}

module.exports = nextConfig
