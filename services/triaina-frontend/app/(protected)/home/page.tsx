"use client"
import { Search } from "lucide-react"
import Link from "next/link"
import CourseCard from "@/components/course-card"
import Sidebar from "@/components/sidebar"
import { useEffect } from "react"
import { courseService } from "@/lib/networkService"
import { useAuth } from "@/context/AuthContext"
import { Course } from "@/context/CourseContext"
import { useState } from "react"
import { start } from "repl"

export default function Page() {
  const {user}= useAuth()
  const [courses, setCourses] = useState<Course[]>([])

  // Sample course data
  useEffect(() => {
    if (!user) return;
    courseService.getEnrolledCourses(user.id).then((res: any) => {
      if (res.data && res.data.success) {
        // Map the API response to the Course type
        const mappedCourses = res.data.courses.map((course: Course) => ({
          id: course.id,
          name: course.name,
          description: course.description ,
          startDate: course.start_date,
          endDate: course.end_date,
          sections: course.sections
        }))
        setCourses(mappedCourses)
      } else {
        throw new Error('Failed to fetch courses')
      }
    })

  }, [user])


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
            <Search className="h-5 w-5 text-gray-400" />
          </div>
        </div>

        {/* Course grid */}
        <div className="grid grid-cols-1 gap-4 p-4 md:grid-cols-2 lg:grid-cols-3">
          {courses.map((course, index) => (
            <CourseCard key={index} title={course.name} chapters={course.sections.length} id={course.id} />
          ))}
        </div>
      </div>
    </div>
  )
}
