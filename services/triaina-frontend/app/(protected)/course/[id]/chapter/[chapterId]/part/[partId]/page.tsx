"use client"
import { Hash, Volume2, RotateCcw, Play, Maximize } from "lucide-react"
import Sidebar from "@/components/sidebar"
import CourseChannels from "@/components/course-channels"
import ChapterParts from "@/components/chapter-parts"
import { useCourse } from "@/context/CourseContext"
import { useRouter } from "next/navigation"
import { useEffect } from "react"

export default function PartDetailPage({
  params,
}: {
  params: { id: string; chapterId: string; partId: string }
}) {
  const { course, loading, error } = useCourse()
  const router = useRouter()
  // Redirect back to course page if we don't have course data
  useEffect(() => {
    if (!loading && (!course || error)) {
      router.push(`/course/${params.id}`)
    }
  }, [params.id])

  if (loading) return <div className="flex h-screen items-center justify-center">Loading...</div>
  if (!course) return null

  // Find the current section (chapter) based on ID
  const currentSection = course.sections.find(section => section.id === params.chapterId)
  if (!currentSection) return <div className="flex h-screen items-center justify-center">Chapter not found</div>
  
  // Find the current unit (part) based on ID
  const currentUnit = currentSection.units.find(unit => unit.id === params.partId)
  if (!currentUnit) return <div className="flex h-screen items-center justify-center">Part not found</div>
  // Map API data to UI structure
  const mappedCourse = {
    title: course.name,
    chapters: course.sections.map(section => ({
      id: section.id, // Always use the actual section ID
      title: section.title || `Section ${section.order_index}`,
    })),
    channels: [
      { id: 1, name: "general-chat" },
      { id: 2, name: "general-chat" },
      { id: 3, name: "general-chat" },
      { id: 4, name: "general-chat" },
      { id: 5, name: "general-chat" },
    ],
  }
  // Current chapter data
  const currentChapter = {
    id: currentSection.id, // Use the actual section ID for navigation
    title: currentSection.title || `Chapter ${params.chapterId}`,
    parts: currentSection.units.map(unit => ({
      id: unit.id,
      title: unit.title || `Part ${unit.order_index}`,
    })),
  }

  // Current part data
  const currentPart = {
    id: currentUnit.order_index || params.partId,
    title: currentUnit.title || `Part ${params.partId}`,
    content: currentUnit.content_url ? currentUnit.content_url : "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

  }

  return (
    <div className="flex h-screen bg-white text-black">
      {/* Main sidebar */}
      <Sidebar />      {/* Course sidebar */}
      <CourseChannels course={mappedCourse} />

      {/* Main content */}
      <div className="flex flex-1 flex-col">
        {/* Header */}
        <div className="flex items-center justify-between border-b border-gray-200 px-4 py-2">
          <div className="flex items-center">
            <h1 className="mr-2 font-medium">{mappedCourse.title}</h1>
            <span className="flex items-center text-gray-500">
              <Hash className="mr-1 h-4 w-4" />
              {currentChapter.title} - {currentPart.title}
            </span>
          </div>
        </div>

        {/* Video player */}
        <div className="flex flex-1">
          <div className="flex-1 p-4">
            <div className="overflow-hidden rounded-md bg-gray-100">
              {/* Video container */}
              <div className="relative">
                <video width="100%" controls>
                  <source src={currentPart.content} type="video/mp4"></source>
                </video>
              
              </div>

              {/* Video tabs */}
              <div className="border-b border-gray-200">
                <div className="flex">
                  <button className="border-b-2 border-black px-4 py-2 font-medium">Transcript</button>
                  <button className="px-4 py-2 text-gray-500 hover:text-black">Notes</button>
                  <button className="px-4 py-2 text-gray-500 hover:text-black">Downloads</button>
                </div>
              </div>

              {/* Tab content */}
              <div className="p-4">
                <h3 className="font-medium mb-2">{currentPart.title} - Transcript</h3>
                <p className="text-gray-600">
                  This is the transcript for {currentPart.title}. Here you can read the detailed content of this
                  specific part of the chapter, including all the key concepts and explanations covered in the video.
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
