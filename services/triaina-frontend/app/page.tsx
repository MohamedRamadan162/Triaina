"use client"
import Link from "next/link"
import { Button } from "@/components/ui/button"
import { useAuth } from "@/context/AuthContext"
import { useEffect } from "react"
import { useRouter } from "next/navigation"
import { Loader2 } from "lucide-react"

export default function Home() {
  const { isAuthenticated, isLoading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (isAuthenticated && !isLoading) {
      router.push('/home');
    }
  }, [isAuthenticated, isLoading, router]);

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <Loader2 className="h-12 w-12 animate-spin text-gray-400" />
      </div>
    );
  }

  return (
    <div className="flex min-h-screen flex-col items-center justify-center space-y-4 bg-gray-50 p-4">
      <h1 className="text-3xl font-bold">Welcome to Our Platform</h1>
      <div className="flex space-x-4">
        <Button asChild>
          <Link href="/sign-in">Sign In</Link>
        </Button>
        <Button asChild variant="outline">
          <Link href="/sign-up">Sign Up</Link>
        </Button>
      </div>
    </div>
  )
}
