"use client"

import { Hash } from "lucide-react"
import Link from "next/link"
import { useParams } from "next/navigation"

interface ChapterPartsProps {
  chapter: {
    id: number | string
    title: string
    parts: Array<{ id: string | number; title: string }>
  }
}

export default function ChapterParts({ chapter }: ChapterPartsProps) {
  const params = useParams()
  const courseId = params?.id as string

  return (
    <div className="w-64 border-l border-gray-200 bg-gray-50">
      {/* Chapter title */}
      <div className="border-b border-gray-200 p-4">
        <h2 className="font-medium">{chapter.title}</h2>
      </div>

      {/* Parts list */}
      <div className="p-2">
        <div className="space-y-1">
          {chapter.parts.map((part) => (
            <Link
              key={part.id}
              href={`/course/${courseId}/chapter/${chapter.id}/part/${part.id}`}
              className="flex items-center rounded px-2 py-1 text-sm hover:bg-gray-200"
            >
              <Hash className="mr-1 h-4 w-4 text-gray-500" />
              <span>{part.title}</span>
            </Link>
          ))}
        </div>
      </div>
    </div>
  )
}
