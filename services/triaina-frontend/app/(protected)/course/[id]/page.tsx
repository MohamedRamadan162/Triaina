"use client"
import { Hash, MessageSquare, Paperclip, Pin } from "lucide-react"
import Sidebar from "@/components/sidebar"
import CourseChannels from "@/components/course-channels"
import ChatMessage from "@/components/chat-message"
import { courseService } from "@/lib/networkService"
import { useEffect, useState } from "react"

export default function CourseDetailPage({ params }: { params: { id: string } }) {
  const [course, setCourse] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    // For now, use the provided id
    const courseId = 'b3a78d2a-0c6d-4f3b-b95c-23e19bd3f9b7'
    setLoading(true)
    courseService.getCourse(courseId)
      .then((res: any) => {
        if (res.data && res.data.success) {
          setCourse(res.data.course)
        } else {
          setError('Failed to fetch course')
        }
      })
      .catch(() => setError('Failed to fetch course'))
      .finally(() => setLoading(false))
  }, [])

  if (loading) return <div className="flex h-screen items-center justify-center">Loading...</div>
  if (error) return <div className="flex h-screen items-center justify-center text-red-500">{error}</div>
  if (!course) return null

  // Map API data to UI structure
  const mappedCourse = {
    title: course.name,
    chapters: (course.sections || []).map((section: any, idx: number) => ({
      id: section.id || idx,
      title: section.name || `Section ${idx + 1}`,
    })),
    channels: [
      { id: 1, name: "general-chat" },
      { id: 2, name: "general-chat" },
      { id: 3, name: "general-chat" },
      { id: 4, name: "general-chat" },
      { id: 5, name: "general-chat" },
    ],
    messages: [
      // You can keep the sample messages or fetch from API if available
      {
        id: 1,
        user: "User 1",
        time: "10:30 AM",
        content:
          "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ad quam officia veniam provident ullam enim laboriosam eveniet voluptate neque et? Harum quo",
        color: "bg-red-500",
      },
      {
        id: 2,
        user: "User 3",
        time: "10:35 AM",
        content:
          "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ad quam officia veniam provident ullam enim laboriosam eveniet voluptate neque et? Harum quo",
        color: "bg-yellow-500",
      },
      {
        id: 3,
        user: "User 2",
        time: "10:40 AM",
        content:
          "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ad quam officia veniam provident ullam enim laboriosam eveniet voluptate neque et? Harum quo",
        color: "bg-blue-500",
      },
      {
        id: 4,
        user: "User 1",
        time: "10:45 AM",
        content:
          "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Ad quam officia veniam provident ullam enim laboriosam eveniet voluptate neque et? Harum quo",
        color: "bg-red-500",
      },
    ],
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
              general-chat
            </span>
          </div>
          <div className="flex items-center space-x-4">
            <button>
              <Pin className="h-5 w-5 text-gray-500" />
            </button>
            <button>
              <Paperclip className="h-5 w-5 text-gray-500" />
            </button>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-gray-200 px-4">
          <button className="flex items-center border-b-2 border-black py-2 pr-4 font-medium">
            <MessageSquare className="mr-2 h-4 w-4" />
            Messages
          </button>
          <button className="flex items-center py-2 px-4 text-gray-500 hover:text-black">
            <Pin className="mr-2 h-4 w-4" />
            Pins
          </button>
          <button className="flex items-center py-2 px-4 text-gray-500 hover:text-black">
            <Paperclip className="mr-2 h-4 w-4" />
            Files
          </button>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto p-4">
          {mappedCourse.messages.map((message) => (
            <ChatMessage key={message.id} message={message} />
          ))}
        </div>

        {/* Message input */}
        <div className="border-t border-gray-200 p-4">
          <div className="flex items-center rounded-md border border-gray-300 bg-white p-2">
            <button className="mr-2 text-gray-400">
              <span className="text-xl">😊</span>
            </button>
            <input type="text" placeholder={`Message # general-chat`} className="flex-1 bg-transparent outline-none" />
            <button className="ml-2 rounded-md bg-gray-100 px-3 py-1 text-gray-500 hover:bg-gray-200">Send</button>
          </div>
        </div>
      </div>
    </div>
  )
}
