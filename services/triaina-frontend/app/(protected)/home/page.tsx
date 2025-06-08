import { Search } from "lucide-react"
import Link from "next/link"
import CourseCard from "@/components/course-card"
import Sidebar from "@/components/sidebar"

export default function Page() {
  // Sample course data
  const courses = Array(6).fill({
    title: "Computer Network Security",
    chapters: 20,
    members: 200,
    progress: 65
  })

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
            <CourseCard key={index} title={course.title} chapters={course.chapters} members={course.members} progress={course.progress} />
          ))}
        </div>
      </div>
    </div>
  )
}
