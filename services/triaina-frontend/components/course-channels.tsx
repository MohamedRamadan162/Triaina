"use client"

import { ChevronDown, Hash } from "lucide-react"
import Link from "next/link"
import { useParams } from "next/navigation"

interface CourseChannelsProps {
  course: {
    title: string
    chapters: Array<{ id: number; title: string }>
    channels: Array<{ id: number; name: string }>
  }
}

export default function CourseChannels({ course }: CourseChannelsProps) {
  const params = useParams()
  const courseId = params?.id as string

  return (
    <div className="w-64 border-r border-gray-200 bg-gray-50">
      {/* Course title */}
      <div className="flex items-center justify-between border-b border-gray-200 p-4">
        <h2 className="font-medium">{course.title}</h2>
        <button>
          <ChevronDown className="h-4 w-4" />
        </button>
      </div>

      {/* Channels section */}
      <div className="p-2">
        <div className="flex items-center justify-between px-2 py-1 text-sm text-gray-500">
          <button className="flex items-center">
            <ChevronDown className="mr-1 h-3 w-3" />
            <span>Channels</span>
          </button>
        </div>
        <div className="mt-1 space-y-1">
          {course.channels.map((channel) => (
            <Link
              key={channel.id}
              href={`/course/${courseId}`}
              className="flex items-center rounded px-2 py-1 text-sm hover:bg-gray-200"
            >
              <Hash className="mr-1 h-4 w-4 text-gray-500" />
              <span>{channel.name}</span>
            </Link>
          ))}
        </div>
      </div>

      {/* Content section */}
      <div className="p-2">
        <div className="flex items-center justify-between px-2 py-1 text-sm text-gray-500">
          <button className="flex items-center">
            <ChevronDown className="mr-1 h-3 w-3" />
            <span>Content</span>
          </button>
        </div>
        <div className="mt-1 space-y-1">
          {course.chapters.map((chapter) => (
            <Link
              key={chapter.id}
              href={`/course/${courseId}/chapter/${chapter.id}`}
              className="flex items-center rounded px-2 py-1 text-sm hover:bg-gray-200"
            >
              <Hash className="mr-1 h-4 w-4 text-gray-500" />
              <span>{chapter.title}</span>
            </Link>
          ))}
        </div>
      </div>
    </div>
  )
}
