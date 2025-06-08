import { BookOpen, Users } from "lucide-react"

export default function CoursesDetails() {
  const enrolledCourses = [
    {
      id: 1,
      title: "Computer Network Security",
      progress: 65,
      chapters: 20,
      members: 200,
      lastAccessed: "2 days ago",
    },
    {
      id: 2,
      title: "Web Development Fundamentals",
      progress: 30,
      chapters: 15,
      members: 150,
      lastAccessed: "1 week ago",
    },
    {
      id: 3,
      title: "Database Management Systems",
      progress: 90,
      chapters: 12,
      members: 180,
      lastAccessed: "Yesterday",
    },
  ]

  return (
    <div className="max-w-4xl">
      <h2 className="text-2xl font-semibold text-gray-900 mb-8">Courses</h2>

      {/* Enrolled Courses Section */}
      <div className="bg-white rounded-lg border border-gray-200 p-6 mb-6">
        <h3 className="text-lg font-medium text-gray-900 mb-6">Enrolled Courses</h3>
        <div className="space-y-4">
          {enrolledCourses.map((course) => (
            <div key={course.id} className="border border-gray-200 rounded-lg p-4">
              <div className="flex items-center justify-between mb-3">
                <h4 className="font-medium text-gray-900">{course.title}</h4>
                <span className="text-sm text-gray-500">Last accessed: {course.lastAccessed}</span>
              </div>

              {/* Progress bar */}
              <div className="mb-3">
                <div className="flex justify-between text-sm mb-1">
                  <span className="text-gray-600">Progress</span>
                  <span className="font-medium">{course.progress}%</span>
                </div>
                <div className="h-2 w-full rounded-full bg-gray-200">
                  <div className="h-2 rounded-full bg-black" style={{ width: `${course.progress}%` }}></div>
                </div>
              </div>

              <div className="flex items-center justify-between text-sm text-gray-600">
                <div className="flex items-center">
                  <BookOpen className="mr-1 h-4 w-4" />
                  <span>{course.chapters} Chapters</span>
                </div>
                <div className="flex items-center">
                  <Users className="mr-1 h-4 w-4" />
                  <span>{course.members} Members</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Course Statistics Section */}
      <div className="bg-white rounded-lg border border-gray-200 p-6">
        <h3 className="text-lg font-medium text-gray-900 mb-6">Course Statistics</h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="text-center">
            <div className="text-2xl font-bold text-gray-900 mb-1">3</div>
            <div className="text-sm text-gray-600">Courses Enrolled</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-gray-900 mb-1">62%</div>
            <div className="text-sm text-gray-600">Average Progress</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-gray-900 mb-1">47</div>
            <div className="text-sm text-gray-600">Total Chapters</div>
          </div>
        </div>
      </div>
    </div>
  )
}
