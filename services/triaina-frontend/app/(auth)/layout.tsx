"use client";

import { ReactNode, useEffect, useState } from 'react';
import { useAuth } from '@/context/AuthContext';
import { useRouter } from 'next/navigation';
import { Loader2 } from "lucide-react";

export default function AuthLayout({ children }: { children: ReactNode }) {
  const { isAuthenticated, isLoading } = useAuth();
  const router = useRouter();
  const [redirecting, setRedirecting] = useState(false);

  useEffect(() => {
    // Prevent multiple redirects
    if (isAuthenticated && !isLoading && !redirecting) {
      setRedirecting(true);
      router.push('/home');
    }
  }, [isAuthenticated, isLoading, router, redirecting]);

  if (isLoading) {
    return (
      <div className="flex h-screen w-full items-center justify-center">
        <Loader2 className="h-12 w-12 animate-spin text-gray-400" />
      </div>
    );
  }

  if (redirecting) {
    return (
      <div className="flex h-screen w-full items-center justify-center">
        <div className="text-center">
          <Loader2 className="mx-auto h-12 w-12 animate-spin text-gray-400" />
          <p className="mt-4 text-gray-600">Redirecting to dashboard...</p>
        </div>
      </div>
    );
  }

  // If not authenticated, show children (login/signup forms)
  return <>{children}</>;
}
