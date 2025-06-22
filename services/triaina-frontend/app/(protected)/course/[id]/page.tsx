"use client"
import { Hash, MessageSquare, Paperclip, Pin } from "lucide-react"
import Sidebar from "@/components/sidebar"
import CourseChannels from "@/components/course-channels"
import ChatMessage from "@/components/chat-message"
import { courseService } from "@/lib/networkService"
import { useEffect, use } from "react"
import { useCourse } from "@/context/CourseContext"
import { join } from "path"

export default function CourseDetailPage({ params }: { params: Promise<{ id: string }> }) {  const { course, setCourse, chatChannels, setChatChannels, loading, setLoading, error, setError } = useCourse()
const { id } = use(params)
  useEffect(() => {
    // Only fetch if we don't already have the course or it's a different course
    if (!course || course.id !== id) {
      // For now, use the provided id - later you can use params.id
      const courseId = id
      setLoading(true)

      // Make both API calls
      const coursePromise = courseService.getCourse(courseId)
        .then((res: any) => {
          if (res.data && res.data.success) {
            setCourse(res.data.course)
          } else {
            throw new Error('Failed to fetch course')
          }
        })

      const channelsPromise = courseService.getChatChannels(courseId)
        .then((res: any) => {
          if (res.data && res.data.success) {
            // Store the chat channels in context
            setChatChannels(res.data.course_chats)
            console.log('Chat channels loaded:', res.data.course_chats)
          } else {
            throw new Error('Failed to fetch chat channels')
          }
        })

      // Handle all promises
      Promise.all([coursePromise, channelsPromise])
        .catch((error) => {
          setError(error.message || 'Failed to fetch data')
        })
        .finally(() => {
          setLoading(false)
        })
    }
  }, [id]) // Only depend on params.id

  if (loading) return <div className="flex h-screen items-center justify-center">Loading...</div>
  if (error) return <div className="flex h-screen items-center justify-center text-red-500">{error}</div>
  if (!course) return null
  
  // Map API data to UI structure
  const mappedCourse = {
    title: course.name,
    joinCode: course.join_code,
    chapters: (course.sections || []).map((section: any, idx: number) => ({
      id: section.id, // Always use the actual section ID
      title: section.title || `Section ${section.order_index || idx + 1}`,
    })),
    channels: chatChannels.map((channel: any, idx: number) => ({
      id: channel.id, // Always use the actual channel ID
      name: channel.name || `Chat ${idx + 1}`,
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
          </div>
        </div>
        <div className="flex flex-1">
          <div className="flex-1 p-4">
            <div className="overflow-hidden rounded-md bg-gray-100">
              {/* Tab content */}
              <div className="p-4">
                <p className="text-gray-600">
                  Select a channel or chapter from the sidebar to view messages or content.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
