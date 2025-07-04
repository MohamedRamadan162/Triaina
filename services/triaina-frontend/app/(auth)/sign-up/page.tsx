"use client"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { LucideChevronLeft } from "lucide-react"
import { useForm } from "react-hook-form"
import { authService } from "@/lib/networkService"
import React from "react"

export default function SignUp() {
  const router = useRouter();
  const { register, handleSubmit, formState: { errors, isSubmitting, isSubmitSuccessful }, setError, reset } = useForm();
  const [apiError, setApiError] = React.useState<string | null>(null);
  const [apiSuccess, setApiSuccess] = React.useState<string | null>(null);

  const onSubmit = async (data: any) => {
    setApiError(null);
    setApiSuccess(null);
    if (data.password !== data.password_confirmation) {
      setError("password_confirmation", { type: "manual", message: "Passwords do not match" });
      return;
    }
    const payload = {
      name: `${data.firstName} ${data.lastName}`.trim(),
      username: data.userName,
      email: data.email,
      password: data.password,
      password_confirmation: data.password_confirmation,
    };
    try {
      const response = await authService.register(payload);
      if (response.data.success) {
        setApiSuccess("Account created successfully! Redirecting to sign in...");
        reset();
        
        // Save credentials temporarily to localStorage for the sign-in page
        localStorage.setItem('signupEmail', data.email);
        localStorage.setItem('signupPassword', data.password);
        
        // Redirect to sign-in page after a brief delay to show the success message
        setTimeout(() => {
          router.push('/sign-in');
        }, 1500);
      }
    } catch (err: any) {
      setApiError(err?.response?.data?.message || "Registration failed. Please try again.");
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gray-50 px-4 py-12 sm:px-6 lg:px-8">
      <Card className="w-full max-w-md">
        <CardHeader className="space-y-1">
          <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-full bg-gray-100">
            <div className="text-sm text-gray-600">LOGO</div>
          </div>
          <CardTitle className="text-center text-2xl font-bold">Create an account</CardTitle>
          <CardDescription className="text-center">Enter your information to create an account</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Input id="firstName" placeholder="First name" {...register("firstName", { required: "First name is required" })} aria-invalid={!!errors.firstName} />
                {errors.firstName && <span className="text-xs text-red-500">{errors.firstName.message as string}</span>}
              </div>
              <div className="space-y-2">
                <Input id="lastName" placeholder="Last name" {...register("lastName", { required: "Last name is required" })} aria-invalid={!!errors.lastName} />
                {errors.lastName && <span className="text-xs text-red-500">{errors.lastName.message as string}</span>}
              </div>
            </div>
            <div className="space-y-2">
              <Input id="userName" placeholder="Username" {...register("userName", { required: "Username is required" })} aria-invalid={!!errors.userName} />
              {errors.userName && <span className="text-xs text-red-500">{errors.userName.message as string}</span>}
            </div>
            <div className="space-y-2">
              <Input id="email" placeholder="Email address" type="email" autoCapitalize="none" autoComplete="email" autoCorrect="off" {...register("email", { required: "Email is required" })} aria-invalid={!!errors.email} />
              {errors.email && <span className="text-xs text-red-500">{errors.email.message as string}</span>}
            </div>
            <div className="space-y-2">
              <Input id="password" placeholder="Password" type="password" autoComplete="new-password" {...register("password", { required: "Password is required" })} aria-invalid={!!errors.password} />
              {errors.password && <span className="text-xs text-red-500">{errors.password.message as string}</span>}
            </div>
            <div className="space-y-2">
              <Input id="password_confirmation" placeholder="Confirm Password" type="password" {...register("password_confirmation", { required: "Please confirm your password" })} aria-invalid={!!errors.password_confirmation} />
              {errors.password_confirmation && <span className="text-xs text-red-500">{errors.password_confirmation.message as string}</span>}
            </div>
            {apiError && <div className="text-sm text-red-600 text-center">{apiError}</div>}
            {apiSuccess && <div className="text-sm text-green-600 text-center">{apiSuccess}</div>}
            <Button className="w-full" type="submit" disabled={isSubmitting}>{isSubmitting ? "Creating..." : "Create account"}</Button>
          </form>
          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <span className="w-full border-t" />
            </div>
            <div className="relative flex justify-center text-xs uppercase">
              <span className="bg-white px-2 text-gray-500">Or continue with</span>
            </div>
          </div>
          <Button variant="outline" className="w-full">
            <svg
              className="mr-2 h-4 w-4"
              aria-hidden="true"
              focusable="false"
              data-prefix="fab"
              data-icon="google"
              role="img"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 488 512"
            >
              <path
                fill="currentColor"
                d="M488 261.8C488 403.3 391.1 504 248 504 110.8 504 0 393.2 0 256S110.8 8 248 8c66.8 0 123 24.5 166.3 64.9l-67.5 64.9C258.5 52.6 94.3 116.6 94.3 256c0 86.5 69.1 156.6 153.7 156.6 98.2 0 135-70.4 140.8-106.9H248v-85.3h236.1c2.3 12.7 3.9 24.9 3.9 41.4z"
              ></path>
            </svg>
            Google
          </Button>
        </CardContent>
        <CardFooter className="flex flex-col space-y-4">
          <div className="text-center text-sm">
            Already have an account?{" "}
            <Link
              href="/sign-in"
              className="font-medium text-primary underline underline-offset-4 hover:text-primary/90"
            >
              Sign in
            </Link>
          </div>
          <Link href="/" className="mx-auto flex items-center text-sm text-gray-500 hover:text-gray-900">
            <LucideChevronLeft className="mr-1 h-4 w-4" />
            Back to home
          </Link>
        </CardFooter>
      </Card>
    </div>
  )
}
