"use client"

import { ChevronDown, Hash, Plus } from "lucide-react"
import Link from "next/link"
import { useParams } from "next/navigation"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuShortcut,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Input } from "./ui/input"
import { Textarea } from "./ui/textarea"
import { useState } from "react"
import { Button } from "@/components/ui/button"
import { courseService } from "@/lib/networkService"
import { toast } from "sonner"

interface CourseChannelsProps {
  course: {
    title: string
    chapters: Array<{ id: string | number; title: string }>
    channels: Array<{ id: number | string; name: string }>
    joinCode?: string
  }
}

export default function CourseChannels({ course }: CourseChannelsProps) {
  const params = useParams()
  const courseId = params?.id as string
  const joinCode = course.joinCode || "N/A"
  const [isLoading, setIsLoading] = useState(false)

  const [channelData, setChannelData] = useState({
    name: '',
    description: '',
  })
  const [chapterData, setChapterData] = useState({
    title: '',
    description: '',
  })
  const handleChannelInputChange = (field: keyof typeof channelData) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setChannelData({ ...channelData, [field]: e.target.value })
  }
  const handleChapterInputChange = (field: keyof typeof chapterData) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setChapterData({ ...chapterData, [field]: e.target.value })
  }
  const handleCreateChannel = async () => {
    if (!channelData.name || !channelData.description) {
      toast.error("Please fill in all fields")
      return
    }
    setIsLoading(true)
    try {
      const response = await courseService.createChannel(courseId, channelData)
      toast.success(`Channel created successfully!`)
      window.location.reload()
      setChannelData({ name: '', description: '' })
    } catch (error) {
      toast.error(`Failed to create channel`)
    } finally {
      setIsLoading(false)
      setChannelData({ name: '', description: '' })
    }
  }
  const handleCreateChapter = async () => {
    if (!chapterData.title || !chapterData.description) {
      toast.error("Please fill in all fields")
      return
    }
    setIsLoading(true)
    try {
      const response = await courseService.createSection(courseId, chapterData)
      toast.success(`Chapter created successfully!`)
      window.location.reload()
      setChapterData({ title: '', description: '' })
    } catch (error) {
      toast.error(`Failed to create chapter`)
    } finally {
      setIsLoading(false)
      setChapterData({ title: '', description: '' })
      
    }
  }


  return (
    <div className="w-64 border-r border-gray-200 bg-gray-50">
      {/* Course title */}
      <div className="flex items-center justify-between border-b border-gray-200 p-4">
        <h2 className="font-medium">{course.title}</h2>
        <Dialog >
          <DropdownMenu>
            <DropdownMenuTrigger asChild >
              <button className="cursor-pointer rounded p-1 text-gray-500 hover:bg-gray-200 hover:text-gray-700">
                <ChevronDown className="h-4 w-4" />
              </button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="w-56" align="start">
              <DropdownMenuLabel>Course Settings</DropdownMenuLabel>
              <DropdownMenuItem onClick={() => navigator.clipboard.writeText(joinCode)} className="cursor-pointer">
                <div>
                  <code className="select-text bg-muted px-1 rounded text-xs">
                    {joinCode || "N/A"}
                  </code>
                </div>
                <DropdownMenuShortcut>Click to copy</DropdownMenuShortcut>
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuGroup className="flex flex-col gap-1">
                { /* Create channel */}
                <Dialog>
                  <div className="flex flex-col gap-2">
                    <DialogTrigger asChild>
                      <button className="hover:bg-gray-100 rounded px-2 py-1 text-sm flex items-center justify-between w-full cursor-pointer">
                        Create course channel <Plus className="inline h-4 w-4" />
                      </button>
                    </DialogTrigger>
                  </div>
                  <DialogContent className="sm:max-w-md">
                    <DialogHeader>
                      <DialogTitle>Create Channel</DialogTitle>
                      <DialogDescription>
                        Fill to create a new channel.
                      </DialogDescription>
                    </DialogHeader>
                    {/* Channel creation form */}
                    {/* <div className="grid gap-4"> */}
                    <div className="grid gap-2">
                      <label htmlFor="channel-name">Channel Name *</label>
                      <Input
                        id="channel-name"
                        value={channelData.name}
                        onChange={handleChannelInputChange('name')}
                        placeholder="general-chat"
                      />
                    </div>

                    <div className="grid gap-2">
                      <label htmlFor="channel-description">Description *</label>
                      <Textarea
                        id="channel-description"
                        value={channelData.description}
                        onChange={handleChannelInputChange('description')}
                        placeholder="Channel description"
                        rows={3}
                      />
                    </div>

                    <DialogFooter className="sm:justify-start">
                      <Button
                        type="button"
                        onClick={handleCreateChannel}
                        disabled={isLoading}
                      >
                        {isLoading ? 'Processing...' : 'Create'}
                      </Button>
                      <DialogClose asChild>
                        <Button type="button" variant="outline">
                          Cancel
                        </Button>
                      </DialogClose>
                    </DialogFooter>
                  </DialogContent>

                </Dialog>
                {/* Create chapter */}
                <Dialog>
                  <div className="flex flex-col gap-2">
                    <DialogTrigger asChild>
                      <button className="hover:bg-gray-100 rounded px-2 py-1 text-sm flex items-center justify-between w-full cursor-pointer">
                        Create course chapter <Plus className="inline h-4 w-4" />
                      </button>
                    </DialogTrigger>
                  </div>
                  <DialogContent className="sm:max-w-md">
                    <DialogHeader>
                      <DialogTitle>Create Chapter</DialogTitle>
                      <DialogDescription>
                        Fill to create a new chapter.
                      </DialogDescription>
                    </DialogHeader>
                    {/* Chapter creation form */}
                    {/* <div className="grid gap-4"> */}
                    <div className="grid gap-2">
                      <label htmlFor="chapter-title">Chapter Name *</label>
                      <Input
                        id="chapter-title"
                        value={chapterData.title}
                        onChange={handleChapterInputChange('title')}
                        placeholder="Conditions and Loops"
                      />
                    </div>

                    <div className="grid gap-2">
                      <label htmlFor="chapter-description">Description *</label>
                      <Textarea
                        id="chapter-description"
                        value={chapterData.description}
                        onChange={handleChapterInputChange('description')}
                        placeholder="Chapter description"
                        rows={3}
                      />
                    </div>

                    <DialogFooter className="sm:justify-start">
                      <Button
                        type="button"
                        onClick={handleCreateChapter}
                        disabled={isLoading}
                      >
                        {isLoading ? 'Processing...' : 'Create'}
                      </Button>
                      <DialogClose asChild>
                        <Button type="button" variant="outline">
                          Cancel
                        </Button>
                      </DialogClose>
                    </DialogFooter>
                  </DialogContent>

                </Dialog>

              </DropdownMenuGroup>
            </DropdownMenuContent>
          </DropdownMenu>
        </Dialog>
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
              href={`/course/${courseId}/chat/${channel.id}`}
              className={`flex items-center rounded px-2 py-1 text-sm hover:bg-gray-200 ${params?.chatId === channel.id ? 'bg-gray-200 font-medium' : ''
                }`}
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
