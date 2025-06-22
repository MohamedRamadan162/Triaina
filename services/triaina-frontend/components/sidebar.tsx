"use client"

import type React from "react"
import { Bell, Calendar, FileText, Home, MessageSquare, Plus } from "lucide-react"
import Link from "next/link"
import { useState, useCallback, useMemo } from "react"
import ProfileDropdown from "./profile-dropdown"
import { useAuth } from "@/context/AuthContext"
import { getInitials, getUserColor } from "@/lib/generalFuncitons"
import { Button } from "@/components/ui/button"
import { Calendar as CalendarComponent } from "@/components/ui/calendar"
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { courseService } from "@/lib/networkService"
import { toast } from "sonner"

export default function Sidebar() {
  const { user } = useAuth();
  const [profileDropdown, setProfileDropdown] = useState<{
    isOpen: boolean
    position: { top: number; left: number }
  }>({
    isOpen: false,
    position: { top: 0, left: 0 },
  })
  const [open, setOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(false)

  // Course creation state
  const [courseData, setCourseData] = useState({
    name: '',
    description: '',
    start_date: undefined as Date | undefined,
    end_date: undefined as Date | undefined
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

  const handleCourseInputChange = (field: string) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setCourseData({ ...courseData, [field]: e.target.value })
  }

  const handleDateChange = (field: 'start_date' | 'end_date') => (date: Date | undefined) => {
    setCourseData({ ...courseData, [field]: date })
  }

  const handleOpenDialog = () => {
    setOpen(true)
  }

  const handleCreateCourse = async () => {
    // Validate inputs
    if (!courseData.name || !courseData.description || !courseData.start_date) {
      toast.error("Please fill all required fields (name, description, start date)")
      return
    }

    setIsLoading(true)
    try {
      // Format the dates to ISO string for API
      const formattedData = {
        ...courseData,
        start_date: courseData.start_date?.toISOString(),
        end_date: courseData.end_date?.toISOString()
      }

      await courseService.createCourse(formattedData)
      toast.success("Course created successfully")
      window.location.reload() // Reload to reflect changes
      setOpen(false)
      // Reset form
      setCourseData({
        name: '',
        description: '',
        start_date: undefined,
        end_date: undefined
      })
    } catch (error) {
      toast.error("Failed to create course")
    } finally {
      setIsLoading(false)
      setCourseData({
        name: '',
        description: '',
        start_date: undefined,
        end_date: undefined
      })
    }
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
          <Dialog open={open} onOpenChange={setOpen}>
            <div className="flex flex-col gap-2">
              <DialogTrigger asChild onClick={handleOpenDialog}>
                <button className="flex h-10 w-10 items-center justify-center rounded-full border border-gray-600 p-2 cursor-pointer hover:bg-gray-200 hover:text-gray-700">
                  <Plus className="h-5 w-5" />
                </button>
              </DialogTrigger>
            </div>
            <DialogContent className="sm:max-w-md">
              <DialogHeader>
                <DialogTitle>Create Course</DialogTitle>
                <DialogDescription>
                  Fill the form to create a new course.
                </DialogDescription>
              </DialogHeader>
              {/* Course creation form */}
              <div className="grid gap-4">
                <div className="grid gap-2">
                  <label htmlFor="course-name">Course Name *</label>
                  <Input
                    id="course-name"
                    value={courseData.name}
                    onChange={handleCourseInputChange('name')}
                    placeholder="e.g. Introduction to Programming"
                  />
                </div>

                <div className="grid gap-2">
                  <label htmlFor="course-description">Description *</label>
                  <Textarea
                    id="course-description"
                    value={courseData.description}
                    onChange={handleCourseInputChange('description')}
                    placeholder="Course description"
                    rows={3}
                  />
                </div>
                <div className="grid gap-2">
                  <label htmlFor="start-date">Start Date *</label>
                  <Popover>
                    <PopoverTrigger asChild>
                      <Button
                        variant="outline"
                        id="start-date"
                        className="w-full justify-start text-left font-normal"
                      >
                        {courseData.start_date ? courseData.start_date.toLocaleDateString() : "Select date"}
                      </Button>
                    </PopoverTrigger>
                    <PopoverContent className="w-auto p-0">
                      <CalendarComponent
                        mode="single"
                        selected={courseData.start_date}
                        onSelect={(date) => setCourseData({ ...courseData, start_date: date })}
                      />
                    </PopoverContent>
                  </Popover>
                </div>

                <div className="grid gap-2">
                  <label htmlFor="end-date">End Date (optional)</label>
                  <Popover>
                    <PopoverTrigger asChild>
                      <Button
                        variant="outline"
                        id="end-date"
                        className="w-full justify-start text-left font-normal"
                      >
                        {courseData.end_date ? courseData.end_date.toLocaleDateString() : "Select date"}
                      </Button>
                    </PopoverTrigger>
                    <PopoverContent className="w-auto p-0">
                      <CalendarComponent
                        mode="single"
                        selected={courseData.end_date}
                        onSelect={(date) => setCourseData({ ...courseData, end_date: date })}
                      />
                    </PopoverContent>
                  </Popover>
                </div>
              </div>

              <DialogFooter className="sm:justify-start">
                <Button
                  type="button"
                  onClick={handleCreateCourse}
                  disabled={isLoading}
                >
                  {isLoading ? 'Processing...' : 'Create'}
                </Button>
                <DialogClose asChild>
                  <Button type="button" variant="outline">
                    Cancel
                  </Button>
                </DialogClose>
              </DialogFooter>
            </DialogContent>
          </Dialog>
          <button
            onClick={handleProfileClick}
            className={`flex h-10 w-10 items-center justify-center rounded-sm p-2 text-white font-bold ${userColor} cursor-pointer`}
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
