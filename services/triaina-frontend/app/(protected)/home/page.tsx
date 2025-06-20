'use client'
import Link from "next/link"
import { useState } from "react"
import { toast } from "sonner"
import CourseCard from "@/components/course-card"
import Sidebar from "@/components/sidebar"
import { Button } from "@/components/ui/button"
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
import { courseService } from "@/lib/networkService"


export default function Page() {
  // Sample course data
  const courses = Array(6).fill({
    title: "Computer Network Security",
    chapters: 20,
    members: 200,
    progress: 65
  })
  
  // State to manage join code input
  const [joinCode, setJoinCode] = useState("")
  const [isEnrolling, setIsEnrolling] = useState(false)
  const [open, setOpen] = useState(false)

  // Function to handle course enrollment
  const handleEnrollment = async () => {
    if (!joinCode.trim()) {
      toast.error("Please enter a course join code")
      return
    }

    setIsEnrolling(true)
    try {
      await courseService.courseEnrollment(joinCode)
      toast.success("Successfully enrolled in the course!")
      setOpen(false) // Close the dialog after successful enrollment
      // You might want to refresh the course list here
      // You could add a fetchCourses function and call it here
    } catch (error) {
      console.error("Enrollment failed:", error)
      toast.error("Failed to enroll in the course. Please check your join code.")
    } finally {
      setIsEnrolling(false)
    }
  }

  return (
    <div className="flex h-screen bg-white text-black">
      {/* Sidebar */}
      <Sidebar />

      {/* Main content */}
      <div className="flex-1 overflow-auto">
        {/* Top navigation */}
        <div className="flex items-center border-b border-gray-700 px-4 py-2">
          <div className="flex space-x-4">
            <Link href="/home" className="border-b-2 border-black pb-2 font-medium text-black">
              My Courses
            </Link>
            <Link href="/discover" className="pb-2 text-gray-600 hover:text-black">
              Discover
            </Link>
          </div>
          <div className="ml-auto">
            <Dialog open={open} onOpenChange={setOpen}>
              <DialogTrigger asChild>
                <Button variant="outline">Join Course</Button>
              </DialogTrigger>
              <DialogContent className="sm:max-w-md">
                <DialogHeader>
                  <DialogTitle>Join Course</DialogTitle>
                  <DialogDescription>
                    Enter course's code.
                  </DialogDescription>
                </DialogHeader>
                <div className="flex items-center gap-2">
                  <div className="grid flex-1 gap-2">
                    <Input
                      id="joinCode"
                      value={joinCode}
                      onChange={(e) => setJoinCode(e.target.value)}
                      placeholder="Enter course join code"
                    />
                  </div>
                </div>
                <DialogFooter className="sm:justify-start">
                  <Button 
                    type="button" 
                    variant="secondary"
                    onClick={handleEnrollment}
                    disabled={isEnrolling}
                  >
                    {isEnrolling ? "Enrolling..." : "Enroll"}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>
          </div>
        </div>

        {/* Course grid */}
        <div className="grid grid-cols-1 gap-4 p-4 md:grid-cols-2 lg:grid-cols-3">
          {courses.map((course, index) => (
            <CourseCard key={index} title={course.title} chapters={course.chapters} members={course.members} progress={course.progress} />
          ))}
        </div>
      </div>
    </div>
  )
}
