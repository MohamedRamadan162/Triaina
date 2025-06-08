import { Hash, Volume2, RotateCcw, Play, Maximize } from "lucide-react"
import Sidebar from "@/components/sidebar"
import CourseChannels from "@/components/course-channels"
import ChapterParts from "@/components/chapter-parts"

export default function PartDetailPage({
  params,
}: {
  params: { id: string; chapterId: string; partId: string }
}) {
  // Sample course data
  const course = {
    title: "Computer Network Security",
    chapters: [
      { id: 1, title: "Chapter 1" },
      { id: 2, title: "Chapter 2" },
      { id: 3, title: "Chapter 3" },
      { id: 4, title: "Chapter 4" },
      { id: 5, title: "Chapter 5" },
      { id: 6, title: "Chapter 6" },
    ],
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
    id: Number.parseInt(params.chapterId),
    title: `Chapter ${params.chapterId}`,
    parts: [
      { id: 1, title: "Part 1" },
      { id: 2, title: "Part 2" },
      { id: 3, title: "Part 3" },
      { id: 4, title: "Part 4" },
      { id: 5, title: "Part 5" },
      { id: 6, title: "Part 6" },
    ],
  }

  // Current part data
  const currentPart = {
    id: Number.parseInt(params.partId),
    title: `Part ${params.partId}`,
    duration: "3:24",
    content: [
      "Understanding the fundamentals of network security",
      "Implementing basic security protocols",
      "Identifying common vulnerabilities",
    ],
  }

  return (
    <div className="flex h-screen bg-white text-black">
      {/* Main sidebar */}
      <Sidebar />

      {/* Course sidebar */}
      <CourseChannels course={course} />

      {/* Main content */}
      <div className="flex flex-1 flex-col">
        {/* Header */}
        <div className="flex items-center justify-between border-b border-gray-200 px-4 py-2">
          <div className="flex items-center">
            <h1 className="mr-2 font-medium">{course.title}</h1>
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
              <div className="relative aspect-video bg-gray-900">
                {/* Video thumbnail/placeholder */}
                <div className="absolute inset-0 flex items-center justify-center">
                  <div className="flex h-16 w-16 items-center justify-center rounded-full bg-gray-800/50 text-white">
                    <Play className="h-8 w-8" />
                  </div>
                </div>

                {/* Video content list */}
                <div className="absolute inset-0 flex items-center justify-center">
                  <div className="w-3/4 space-y-6 text-white">
                    <h2 className="text-xl font-semibold mb-4">{currentPart.title}</h2>
                    {currentPart.content.map((item, index) => (
                      <div key={index} className="flex items-start">
                        <div className="mr-2 flex h-6 w-6 flex-shrink-0 items-center justify-center rounded-full border border-white/30">
                          {index + 1}
                        </div>
                        <p>{item}</p>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Video controls */}
                <div className="absolute bottom-0 left-0 right-0 flex items-center justify-between bg-gray-800/80 p-2 text-white">
                  <div className="flex items-center space-x-3">
                    <button className="rounded-full p-1 hover:bg-white/20">
                      <Play className="h-5 w-5" />
                    </button>
                    <button className="rounded-full p-1 hover:bg-white/20">
                      <Volume2 className="h-5 w-5" />
                    </button>
                    <button className="rounded-full p-1 hover:bg-white/20">
                      <RotateCcw className="h-5 w-5" />
                    </button>
                    <span className="text-sm">0:00 / {currentPart.duration}</span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <button className="rounded px-2 py-1 hover:bg-white/20">
                      <span>1×</span>
                    </button>
                    <button className="rounded-full p-1 hover:bg-white/20">
                      <Maximize className="h-5 w-5" />
                    </button>
                  </div>
                </div>
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
