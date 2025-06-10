import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async rewrites() {
    return [
      {
        source: '/api/backend/:path*',
        destination: 'http://triaina-backend:3000/api/v1/:path*',
      },
    ];
  },
};

export default nextConfig;
