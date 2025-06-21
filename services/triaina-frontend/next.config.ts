import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  eslint: {
    ignoreDuringBuilds: true,
  },
  async rewrites() {
    return [
      {
        source: "/api/backend/:path*",
        destination: "http://triaina-backend-service.triaina.svc.cluster.local:80/v1/:path*",
        // destination: 'http://localhost:3000/api/v1/:path*',
      },
      // {
      //   source: '/wsBackend/:path*',
      //   // destination: 'ws://triaina-backend:3000/cable/:path*',
      //   destination: 'ws://localhost:3000/cable/:path*',
      // }
    ];
  },
};

export default nextConfig;
