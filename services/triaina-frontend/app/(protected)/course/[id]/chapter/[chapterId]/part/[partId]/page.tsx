"use client";
import { Hash, Volume2, RotateCcw, Play, Maximize } from "lucide-react";
import Sidebar from "@/components/sidebar";
import CourseChannels from "@/components/course-channels";
import ChapterParts from "@/components/chapter-parts";
import { useCourse } from "@/context/CourseContext";
import { useRouter } from "next/navigation";
import { useEffect, use } from "react";
import { useState } from "react";
import { courseService } from "@/lib/networkService";
import ReactMarkdown from "react-markdown";

interface TranscriptionSegment {
  id: string;
  start: number;
  end: number;
  text: string;
}

interface Transcription {
  language: string;
  duration: string;
  text: string;
  segments: TranscriptionSegment[];
}

export default function PartDetailPage({
  params,
}: {
  params: Promise<{ id: string; chapterId: string; partId: string }>;
}) {
  const { id, chapterId, partId } = use(params);
  const { course, chatChannels, loading, error } = useCourse();
  const router = useRouter();
  const [transcription, setTranscription] = useState<Transcription | null>(
    null
  );
  const [summary, setSummary] = useState(null);
  const [activeTab, setActiveTab] = useState<"transcript" | "summary">(
    "transcript"
  );

  // Redirect back to course page if we don't have course data
  useEffect(() => {
    if (!loading && (!course || error)) {
      router.push(`/course/${id}`);
    }

    const transcriptionPromise = courseService.getTranscription(
      id,
      chapterId,
      partId
    );
    const summaryPromise = courseService.getSummary(id, chapterId, partId);
    Promise.all([transcriptionPromise, summaryPromise])
      .then(([transcriptionRes, summaryRes]) => {
        if (transcriptionRes.data && transcriptionRes.data.transcription) {
          const transcription: Transcription = {
            language: transcriptionRes.data.transcription.language,
            duration: transcriptionRes.data.transcription.duration,
            text: transcriptionRes.data.transcription.text,
            segments: transcriptionRes.data.transcription.segments.map(
              (segment: TranscriptionSegment) => ({
                id: segment.id,
                start: Math.round(segment.start * 10) / 10,
                end:  Math.round(segment.end * 10) / 10,
                text: segment.text,
              })
            ),
          };
          setTranscription(transcription);
        }
        summaryRes.data && setSummary(summaryRes.data.summary);
      })
      .catch((err) => {
        console.error("Failed to fetch transcription or summary:", err);
      });
  }, [id, chapterId, partId]);

  if (loading)
    return (
      <div className="flex h-screen items-center justify-center">
        Loading...
      </div>
    );
  if (!course) return null;

  // Find the current section (chapter) based on ID
  const currentSection = course.sections.find(
    (section) => section.id === chapterId
  );
  if (!currentSection)
    return (
      <div className="flex h-screen items-center justify-center">
        Chapter not found
      </div>
    );

  // Find the current unit (part) based on ID
  const currentUnit = currentSection.units.find((unit) => unit.id === partId);
  if (!currentUnit)
    return (
      <div className="flex h-screen items-center justify-center">
        Part not found
      </div>
    );
  // Map API data to UI structure
  const mappedCourse = {
    title: course.name,
    joinCode: course.join_code,
    chapters: course.sections.map((section) => ({
      id: section.id, // Always use the actual section ID
      title: section.title || `Section ${section.order_index}`,
    })),
    channels: chatChannels.map((channel: any, idx: number) => ({
      id: channel.id, // Always use the actual channel ID
      name: channel.name || `Chat ${idx + 1}`,
    })),
  };
  // Current chapter data
  const currentChapter = {
    id: currentSection.id, // Use the actual section ID for navigation
    title: currentSection.title || `Chapter ${chapterId}`,
    parts: currentSection.units.map((unit) => ({
      id: unit.id,
      title: unit.title || `Part ${unit.order_index}`,
    })),
  };

  // Current part data
  const currentPart = {
    id: currentUnit.order_index || partId,
    title: currentUnit.title || `Part ${partId}`,
    content: currentUnit.content_url,
    transcription: transcription,
    summary: summary,
  };

  return (
    <div className="flex h-screen bg-white text-black">
      {/* Main sidebar */}
      <Sidebar /> {/* Course sidebar */}
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
                  <button
                    className={`px-4 py-2 font-medium border-b-2 transition ${
                      activeTab === "transcript"
                        ? "border-black text-black"
                        : "border-transparent text-gray-500 hover:text-black"
                    }`}
                    onClick={() => setActiveTab("transcript")}
                  >
                    Transcript
                  </button>
                  <button
                    className={`px-4 py-2 font-medium border-b-2 transition ${
                      activeTab === "summary"
                        ? "border-black text-black"
                        : "border-transparent text-gray-500 hover:text-black"
                    }`}
                    onClick={() => setActiveTab("summary")}
                  >
                    Summary
                  </button>
                </div>
              </div>

              {/* Tab content */}
              {activeTab === "transcript" && (
                <div className="p-4">
                  <h3 className="font-medium mb-2">
                    {currentPart.title} - Transcript
                  </h3>
                  {currentPart.transcription &&
                  currentPart.transcription.segments &&
                  currentPart.transcription.segments.length > 0 ? (
                    <div className="space-y-2">
                      {currentPart.transcription.segments.map((segment) => (
                        <div key={segment.id} className="text-sm text-gray-800">
                          <span className="font-semibold">
                            {segment.start}s - {segment.end}s:
                          </span>{" "}
                          {segment.text}
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-gray-600">No transcript available.</p>
                  )}
                </div>
              )}
              {activeTab === "summary" && (
                <div className="p-4">
                  <h3 className="font-medium mb-2">
                    {currentPart.title} - Summary
                  </h3>
                    <ReactMarkdown>{currentPart.summary}</ReactMarkdown>
                </div>
              )}
            </div>
          </div>

          {/* Chapter parts sidebar */}
          <ChapterParts chapter={currentChapter} />
        </div>
      </div>
    </div>
  );
}
