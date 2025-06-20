import { Book, Users } from "lucide-react"
import Link from "next/link"

interface CourseCardProps {
  title: string
  chapters: number
  // members: number
  // progress?: number
  id?: string
}

export default function CourseCard({ title, chapters , id }: CourseCardProps) {
  return (
    <Link href={`/course/${id}`} className="block">
      <div className="overflow-hidden rounded-md border border-gray-200 bg-white shadow-sm transition-shadow hover:shadow-md">
        {/* Course image */}
        <div className="h-32 bg-[#8d6262]"></div>

        {/* Course info */}
        <div className="p-4">
          <h3 className="mb-4 text-sm font-medium text-gray-800">{title}</h3>

          {/* Progress bar - only shown if progress is provided */}
          {/* {progress !== undefined && (
            <div className="mb-4">
              <div className="mb-1 flex justify-between text-xs">
                <span className="text-gray-600">Progress</span>
                <span className="font-medium">{progress}%</span>
              </div>
              <div className="h-2 w-full rounded-full bg-gray-200">
                <div className="h-2 rounded-full bg-black" style={{ width: `${progress}%` }}></div>
              </div>
            </div>
          )} */}

          <div className="flex items-center justify-between border-t border-gray-200 pt-2 text-xs text-gray-600">
            <div className="flex items-center">
              <Book className="mr-1 h-4 w-4" />
              <span>{chapters} Chapters</span>
            </div>

            {/* <div className="flex items-center">
              <Users className="mr-1 h-4 w-4" />
              <span>{members} Members</span>
            </div> */}
          </div>
        </div>
      </div>
    </Link>
  )
}
