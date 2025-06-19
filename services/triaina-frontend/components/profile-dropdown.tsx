"use client"

import { Settings, LogOut } from "lucide-react"
import { useRef, useEffect, useMemo, useCallback } from "react"
import Link from "next/link"
import { useAuth } from "@/context/AuthContext"


interface ProfileDropdownProps {
    isOpen: boolean
    onClose: () => void
    position: { top: number; left: number }
}

export default function ProfileDropdown({ isOpen, onClose, position }: ProfileDropdownProps) {
    const dropdownRef = useRef<HTMLDivElement>(null)
    const { user, logout } = useAuth();
      // Create initials from name - memoized to prevent recalculation on every render
    const getInitials = useCallback((name: string) => {
        return name
            .split(' ')
            .map(part => part[0])
            .join('')
            .toUpperCase()
            .slice(0, 2);
    }, []);
    
    // Memoize initials calculation to prevent unnecessary re-renders
    const initials = useMemo(() => {
        return user?.name ? getInitials(user.name) : "??";
    }, [user, getInitials]);

    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
                onClose()
            }
        }

        if (isOpen) {
            document.addEventListener("mousedown", handleClickOutside)
        }

        return () => {
            document.removeEventListener("mousedown", handleClickOutside)
        }
    }, [isOpen, onClose])

    if (!isOpen) return null

    return (
        <div
            ref={dropdownRef}
            className="fixed z-50 w-64 rounded-lg bg-white shadow-lg border border-gray-200 -translate-y-36"
            style={{
                top: position.top,
                left: position.left,
            }}
        >
            {/* Header with avatar and name */}
            <div className="flex items-center p-4 border-b border-gray-100">
                <div className="flex h-12 w-12 items-center justify-center rounded-full bg-[#ff00ff] text-white font-bold mr-3">
                    {initials}
                </div>
                <div>
                    <h3 className="font-medium text-gray-900">{user?.name || "User"}</h3>
                    <p className="text-sm text-gray-500">{user?.username || "Student"}</p>
                </div>
            </div>

            {/* Menu options */}
            <div className="py-2">
                <button className="flex w-full items-center py-2 text-left text-gray-700 hover:bg-gray-50">
                    <Link
                        href="/account"
                        onClick={onClose}
                        className="flex w-full items-center px-4 py-2 text-left text-gray-700 hover:bg-gray-50"
                    >
                        <Settings className="mr-3 h-4 w-4 text-gray-400" />
                        <span>Manage account</span>
                    </Link>
                </button>                <button 
                    className="flex w-full items-center px-4 py-2 text-left text-gray-700 hover:bg-gray-50"
                    onClick={() => {
                        onClose();
                        logout();
                    }}
                >
                    <LogOut className="mr-3 h-4 w-4 text-gray-400" />
                    <span>Sign out</span>
                </button>
            </div>

            {/* Footer */}
            {/* <div className="border-t border-gray-100 px-4 py-2">
        <p className="text-xs text-gray-400">Secured by clerk</p>
      </div> */}
        </div>
    )
}
