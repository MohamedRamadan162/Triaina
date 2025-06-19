"use client"

import type React from "react"
import { Bell, Calendar, FileText, Home, MessageSquare, Plus } from "lucide-react"
import Link from "next/link"
import { useState, useCallback, useMemo } from "react"
import ProfileDropdown from "./profile-dropdown"
import { useAuth } from "@/context/AuthContext"
import { getInitials, getUserColor } from "@/lib/generalFuncitons"

export default function Sidebar() {
  const { user } = useAuth();
  const [profileDropdown, setProfileDropdown] = useState<{
    isOpen: boolean
    position: { top: number; left: number }
  }>({
    isOpen: false,
    position: { top: 0, left: 0 },
  })
  
  // Get user initials
  const userInitials = getInitials(useMemo(() => user?.name || "User", [user]));
  const userColor = getUserColor(useMemo(() => user?.id || "User", [user]));
  
  
  // Memoize the click handler to prevent unnecessary re-renders
    const handleProfileClick = useCallback((event: React.MouseEvent<HTMLButtonElement>) => {
        const rect = event.currentTarget.getBoundingClientRect()
        setProfileDropdown({
            isOpen: !profileDropdown.isOpen,
            position: {
                top: rect.top,
                left: rect.right + 8, // 8px offset from the button
            },
        })
    }, [profileDropdown.isOpen]);

    const closeDropdown = useCallback(() => {
        setProfileDropdown((prev) => ({ ...prev, isOpen: false }))
    }, [])

  return (
    <>
    <div className="flex w-16 flex-col gap-4 items-center justify-between border-r border-gray-200 bg-white py-4">
      <div className="flex flex-col space-y-4">
        <Link href="/home" className="p-2">
          <Home className="h-6 w-6" />
        </Link>
        <Link href="#" className="p-2">
          <MessageSquare className="h-6 w-6" />
        </Link>
        <Link href="#" className="p-2">
          <Bell className="h-6 w-6" />
        </Link>
        <Link href="#" className="p-2">
          <Calendar className="h-6 w-6" />
        </Link>
        <Link href="#" className="p-2">
          <FileText className="h-6 w-6" />
        </Link>
      </div>
      <div className="flex flex-1 flex-col space-y-4">
        {/* Profile circles */}
        <Link
          href="#"
          className="flex h-10 w-10 items-center justify-center rounded-full bg-[#ff00ff] p-2 text-sm font-bold"
        >
          JO
        </Link>
        <Link
          href="#"
          className="flex h-10 w-10 items-center justify-center rounded-full bg-[#ff00ff] p-2 text-sm font-bold"
        >
          JO
        </Link>
        <Link
          href="#"
          className="flex h-10 w-10 items-center justify-center rounded-full bg-[#ff00ff] p-2 text-sm font-bold"
        >
          JO
        </Link>
        <Link
          href="#"
          className="flex h-10 w-10 items-center justify-center rounded-full bg-[#ff00ff] p-2 text-sm font-bold"
        >
          JO
        </Link>
      </div>
      <div className="mt-auto flex flex-col space-y-4">
        <button className="flex h-10 w-10 items-center justify-center rounded-full border border-gray-600 p-2">
          <Plus className="h-5 w-5" />
        </button>        <button 
          onClick={handleProfileClick} 
          className={`flex h-10 w-10 items-center justify-center rounded-sm p-2 text-white font-bold ${userColor}`}
        >
          {userInitials}
        </button>
      </div>
    </div>
    {/* Profile Dropdown */}
      <ProfileDropdown isOpen={profileDropdown.isOpen} onClose={closeDropdown} position={profileDropdown.position} />
    </>
  )
}
