// filepath: c:\Users\Blu-Ray\VsCodeProjects\WebDev\TriainaBackend\services\triaina-frontend\app\(protected)\layout.tsx
"use client";

import { ReactNode, useEffect, useState } from 'react';
import { CourseProvider } from '@/context/CourseContext';
import { useAuth } from '@/context/AuthContext';
import { useRouter } from 'next/navigation';
import { Loader2 } from "lucide-react";

export default function ProtectedLayout({ children }: { children: ReactNode }) {
  const { isAuthenticated, isLoading, checkAuth } = useAuth();
  const router = useRouter();
  const [isChecking, setIsChecking] = useState(false);
  const [redirecting, setRedirecting] = useState(false);

  useEffect(() => {
    // Only check auth if not already authenticated and not in the process of checking
    if (!isAuthenticated && !isLoading && !isChecking && !redirecting) {
      const verifyAuth = async () => {
        setIsChecking(true);
        try {
          const isAuthed = await checkAuth();
          if (!isAuthed && !redirecting) {
            setRedirecting(true);
            router.push('/sign-in');
          }
        } finally {
          setIsChecking(false);
        }
      };
      verifyAuth();
    }
  }, [isAuthenticated, isLoading, isChecking, redirecting, checkAuth, router]);

  if (isLoading || isChecking) {
    return (
      <div className="flex h-screen w-full items-center justify-center">
        <Loader2 className="h-12 w-12 animate-spin text-gray-400" />
      </div>
    );
  }

  if (!isAuthenticated) {
    if (!redirecting) {
      setRedirecting(true);
      router.push('/sign-in');
    }
    return (
      <div className="flex h-screen w-full items-center justify-center">
        <div className="text-center">
          <Loader2 className="mx-auto h-12 w-12 animate-spin text-gray-400" />
          <p className="mt-4 text-gray-600">Redirecting to sign in...</p>
        </div>
      </div>
    );
  }

  // If authenticated, show children wrapped in CourseProvider
  return (
    <CourseProvider>
      {children}
    </CourseProvider>
  );
}
