"use client"

import { User, BookOpen } from "lucide-react"
import Link from "next/link"
import { usePathname } from "next/navigation"

export default function AccountSidebar() {
  const pathname = usePathname()

  const navItems = [
    {
      href: "/account",
      icon: User,
      label: "Profile",
      isActive: pathname === "/account",
    },
    {
      href: "/account/courses",
      icon: BookOpen,
      label: "Courses",
      isActive: pathname === "/account/courses",
    },
  ]

  return (
    <div className="w-64 bg-white border-r border-gray-200 p-6">
      <div className="mb-8">
        <h1 className="text-xl font-semibold text-gray-900">Account</h1>
        <p className="text-sm text-gray-500 mt-1">Manage your account info.</p>
      </div>

      <nav className="space-y-2">
        {navItems.map((item) => {
          const Icon = item.icon
          return (
            <Link
              key={item.href}
              href={item.href}
              className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                item.isActive ? "bg-gray-100 text-gray-900" : "text-gray-600 hover:text-gray-900 hover:bg-gray-50"
              }`}
            >
              <Icon className="mr-3 h-4 w-4" />
              {item.label}
            </Link>
          )
        })}
      </nav>
    </div>
  )
}
