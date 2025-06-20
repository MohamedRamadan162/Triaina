"use client"
import { Hash, Volume2, RotateCcw, Play, Maximize } from "lucide-react"
import Sidebar from "@/components/sidebar"
import CourseChannels from "@/components/course-channels"
import ChapterParts from "@/components/chapter-parts"
import { useCourse } from "@/context/CourseContext"
import { useRouter } from "next/navigation"
import { useEffect, use } from "react"

export default function ChapterDetailPage({
  params,
}: {
  params: Promise<{ id: string; chapterId: string }>
}) {
  const { id, chapterId } = use(params)
  const { course,chatChannels, loading, error } = useCourse()
  const router = useRouter()

  // Redirect back to course page if we don't have course data
  useEffect(() => {
    if (!loading && (!course || error)) {
      router.push(`/course/${id}`)
    }
  }, [id])

  if (loading) return <div className="flex h-screen items-center justify-center">Loading...</div>
  if (!course) return null

  // Find the current section (chapter) based on ID
  const currentSection = course.sections.find(section => section.id === chapterId)
  if (!currentSection) return <div className="flex h-screen items-center justify-center">Chapter not found</div>

  // Map API data to UI structure
  const mappedCourse = {
    title: course.name,
    chapters: course.sections.map(section => ({
      id: section.id, // Always use the actual section ID
      title: section.title || `Section ${section.order_index}`,
    })),
    channels:chatChannels.map((channel: any, idx: number) => ({
      id: channel.id, // Always use the actual channel ID
      name: channel.name || `Chat ${idx + 1}`,
    })),
  }

  // Current chapter data
  const currentChapter = {
    id: currentSection.id, // Use the actual section ID for navigation
    title: currentSection.title || `Chapter ${chapterId}`,
    parts: currentSection.units.map(unit => ({
      id: unit.id,
      title: unit.title || `Part ${unit.order_index}`,
    })),
  }

  return (
    <div className="flex h-screen bg-white text-black">
      {/* Main sidebar */}
      <Sidebar />

      {/* Course sidebar */}
      <CourseChannels course={mappedCourse} />

      {/* Main content */}
      <div className="flex flex-1 flex-col">
        {/* Header */}
        <div className="flex items-center justify-between border-b border-gray-200 px-4 py-2">
          <div className="flex items-center">
            <h1 className="mr-2 font-medium">{mappedCourse.title}</h1>
            <span className="flex items-center text-gray-500">
              <Hash className="mr-1 h-4 w-4" />
              {currentChapter.title}
            </span>
          </div>
        </div>

        {/* Video player */}
        <div className="flex flex-1">
          <div className="flex-1 p-4">
            <div className="overflow-hidden rounded-md bg-gray-100">
              

                

              {/* Tab content */}
              <div className="p-4">
                <p className="text-gray-600">
                  Select from the parts list
                </p>
              </div>
            </div>
          </div>

          {/* Chapter parts sidebar */}
          <ChapterParts chapter={currentChapter} />
        </div>
      </div>
    </div>
  )
}
