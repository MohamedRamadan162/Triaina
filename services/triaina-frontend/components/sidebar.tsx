"use client"

import type React from "react"
import { Bell, Calendar, FileText, Home, MessageSquare, Plus } from "lucide-react"
import Link from "next/link"
import { useState } from "react"
import ProfileDropdown from "./profile-dropdown"

export default function Sidebar() {
  const [profileDropdown, setProfileDropdown] = useState<{
    isOpen: boolean
    position: { top: number; left: number }
  }>({
    isOpen: false,
    position: { top: 0, left: 0 },
  })

  const handleProfileClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    const rect = event.currentTarget.getBoundingClientRect()
    setProfileDropdown({
      isOpen: !profileDropdown.isOpen,
      position: {
        top: rect.top,
        left: rect.right + 8, // 8px offset from the button
      },
    })
  }

  const closeDropdown = () => {
    setProfileDropdown((prev) => ({ ...prev, isOpen: false }))
  }

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
        </button>
        <button onClick={handleProfileClick} className="flex h-10 w-10 items-center justify-center rounded-sm bg-red-500 p-2">
          <div className="text-xl">😊</div>
        </button>
      </div>
    </div>
    {/* Profile Dropdown */}
      <ProfileDropdown isOpen={profileDropdown.isOpen} onClose={closeDropdown} position={profileDropdown.position} />
    </>
  )
}
