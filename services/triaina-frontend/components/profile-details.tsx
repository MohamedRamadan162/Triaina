"use client"
import { Plus } from "lucide-react"
import { useAuth } from "@/context/AuthContext"
import { useMemo, useCallback } from "react"

export default function ProfileDetails() {
  const { user } = useAuth();
  
  // Create initials from name - memoized to prevent recalculation
  const getInitials = useCallback((name: string) => {
    return name
      .split(' ')
      .map(part => part[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  }, []);
  
  // Memoize the initials calculation to prevent re-renders
  const initials = useMemo(() => {
    return user?.name ? getInitials(user.name) : "??";
  }, [user, getInitials]);

  return (
    <div className="max-w-2xl">
      <h2 className="text-2xl font-semibold text-gray-900 mb-8">Profile details</h2>

      {/* Profile Section */}
      <div className="bg-white rounded-lg border border-gray-200 p-6 mb-6">
        <h3 className="text-lg font-medium text-gray-900 mb-4">Profile</h3>
        <div className="flex items-center justify-between">
          <div className="flex items-center">
            <div className="h-12 w-12 rounded-full bg-[#ff00ff] flex items-center justify-center text-white font-bold mr-4">
              {initials}
            </div>
            <span className="text-gray-900 font-medium">{user?.name || "Loading..."}</span>
          </div>
          <button className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50">
            Update profile
          </button>
        </div>
      </div>

      {/* Email Addresses Section */}
      <div className="bg-white rounded-lg border border-gray-200 p-6 mb-6">
        <h3 className="text-lg font-medium text-gray-900 mb-4">Email addresses</h3>
        <div className="space-y-4">
          <div className="text-gray-700">{user?.email || "No email available"}</div>
          <button className="flex items-center text-sm font-medium text-gray-600 hover:text-gray-900">
            <Plus className="mr-2 h-4 w-4" />
            Add email address
          </button>
        </div>
      </div>

      {/* Phone Number Section */}
      <div className="bg-white rounded-lg border border-gray-200 p-6 mb-6">
        <h3 className="text-lg font-medium text-gray-900 mb-4">Phone number</h3>
        <div className="space-y-4">
          <div className="text-gray-700">+1 (555) 123-4567</div>
          <button className="flex items-center text-sm font-medium text-gray-600 hover:text-gray-900">
            <Plus className="mr-2 h-4 w-4" />
            Add phone number
          </button>
        </div>
      </div>

      {/* Connected Accounts Section */}
      <div className="bg-white rounded-lg border border-gray-200 p-6">
        <h3 className="text-lg font-medium text-gray-900 mb-4">Connected accounts</h3>
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center">
              <div className="w-6 h-6 mr-3">
                <svg viewBox="0 0 24 24" className="w-full h-full">
                  <path
                    fill="#4285F4"
                    d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                  />
                  <path
                    fill="#34A853"
                    d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                  />
                  <path
                    fill="#FBBC05"
                    d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                  />
                  <path
                    fill="#EA4335"
                    d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                  />
                </svg>
              </div>
              <div>
                <span className="font-medium text-gray-900">Google</span>
                <span className="text-gray-500 ml-2">- example@gmail.com</span>
              </div>
            </div>
          </div>
          <button className="flex items-center text-sm font-medium text-gray-600 hover:text-gray-900">
            <Plus className="mr-2 h-4 w-4" />
            Connect account
          </button>
        </div>
      </div>
    </div>
  )
}
