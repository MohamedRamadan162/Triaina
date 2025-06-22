"use client"

import { Hash, Plus } from "lucide-react"
import Link from "next/link"
import { useParams, useRouter } from "next/navigation"

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import {
  Sheet,
  SheetClose,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet"
import { Textarea } from "@/components/ui/textarea"
import { courseService } from "@/lib/networkService"
import { toast } from "sonner"
import { useState } from "react"
import { set } from "date-fns"

interface ChapterPartsProps {
  chapter: {
    id: string
    title: string
    parts: Array<{ id: string | number; title: string }>
  }
}


export default function ChapterParts({ chapter }: ChapterPartsProps) {
  const params = useParams()
  const courseId = params?.id as string
  const navigate = useRouter()
  const [partData, setPartData] = useState({
    title: '',
    description: '',
    content: undefined as File | undefined,
  })
  const [isLoading, setIsLoading] = useState(false)
  const handlePartInputChange = (field: string) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setPartData({
      ...partData,
      [field]: e.target.value,
    })
  }
  const handlePartSubmit = async () => {
    if (!partData.title || !partData.description || !partData.content) {
      toast.error("Please fill in all required fields")
      return
    }
    setIsLoading(true)
    try {
      const formData = new FormData()
      formData.append('title', partData.title)
      formData.append('description', partData.description)

      // Only append content if it exists
      if (partData.content) {
        formData.append('content', partData.content)
      }

      const response = await courseService.createUnit(courseId, chapter.id, formData)
      if (response.status === 201) {
        toast.success("Part created successfully")
        // Optionally, you can redirect or update the UI
        window.location.reload() // Reload to reflect the new part
        // navigate.push(`/course/${courseId}/chapter/${chapter.id}/part/${response.data.unit.id}`)
      } else {
        toast.error("Failed to create part")
      }
    } catch (error) {
      toast.error("An error occurred while creating the part")
    } finally {
      setIsLoading(false)
      setPartData({
        title: '',
        description: '',
        content: undefined,
      })
    }
  }

  return (
    <div className="w-64 border-l border-gray-200 bg-gray-50">
      {/* Chapter title */}
      <div className="flex items-center justify-between border-b border-gray-200 p-4">
        <h2 className="font-medium">{chapter.title}</h2>
        <Sheet>
          <SheetTrigger asChild>
            <button className="cursor-pointer rounded p-1 text-gray-500 hover:bg-gray-200 hover:text-gray-700">
              <Plus className="h-4 w-4" />
            </button>
          </SheetTrigger>
          <SheetContent className="p-4">
            <SheetHeader>
              <SheetTitle>Create Part</SheetTitle>
              <SheetDescription>
                Fill the form to create a new course.
              </SheetDescription>
            </SheetHeader>
            <div className="grid gap-4">
              <div className="grid gap-2">
                <label htmlFor="part-title">Part title *</label>
                <Input
                  id="part-title"
                  value={partData.title}
                  onChange={handlePartInputChange('title')}
                  placeholder="Content title"
                />
              </div>

              <div className="grid gap-2">
                <label htmlFor="part-description">Description *</label>
                <Textarea
                  id="part-description"
                  value={partData.description}
                  onChange={handlePartInputChange('description')}
                  placeholder="Part description"
                  rows={3}
                />
              </div>
              <div className="grid gap-2">
                <label htmlFor="part-content">Content *</label>
                <Input
                  id="part-content"
                  onChange={(e) => {
                    if (e.target.files && e.target.files[0]) {
                      setPartData({
                        ...partData,
                        content: e.target.files[0]
                      });
                    }
                  }}
                  type="file"
                />
              </div>
            </div>
            <SheetFooter>
              <Button type="button"
                onClick={handlePartSubmit}
                disabled={isLoading}
                className="cursor-pointer"
              >
                {isLoading ? 'Processing...' : 'Create'}</Button>
              <SheetClose asChild>
                <Button variant="outline">Close</Button>
              </SheetClose>
            </SheetFooter>
          </SheetContent>
        </Sheet>
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
