import { getInitials} from "@/lib/generalFuncitons"

interface ChatMessageProps {
  message: {
    id: string
    user: string
    time: string
    content: string
    color: string
  }
}

export default function ChatMessage({ message }: ChatMessageProps) {
  return (
    <div className="mb-4 flex">
      <div className={`mr-3 flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-md ${message.color}`}>
        <span className="text-white">
          {getInitials(message.user)}
        </span>
      </div>
      <div className="flex-1">
        <div className="flex items-center">
          <span className="mr-2 font-medium">{message.user}</span>
          <span className="text-xs text-gray-500">{message.time}</span>
        </div>
        <p className="text-sm text-gray-800" >{message.content} </p>
      </div>
    </div>
  )
}
