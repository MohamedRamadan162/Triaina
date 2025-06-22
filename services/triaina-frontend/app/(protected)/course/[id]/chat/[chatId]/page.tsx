"use client"
import { Hand, Hash, MessageSquare, Paperclip, Pin } from "lucide-react"
import Sidebar from "@/components/sidebar"
import CourseChannels from "@/components/course-channels"
import ChatMessage from "@/components/chat-message"
import { courseService } from "@/lib/networkService"
import { useEffect, useState, useRef, use } from "react"
import { useCourse } from "@/context/CourseContext"
import ActionCable from "actioncable"
import { useRouter } from "next/navigation"
import { useAuth } from "@/context/AuthContext"
import { Message } from "@/context/CourseContext"
import { getUserColor } from "@/lib/generalFuncitons"

export default function ChannelDetailPage({ params }: { params: Promise<{ id: string, chatId: string }> }) {
    const { id, chatId } = use(params)
    const {
        course,
        setCourse,
        chatChannels,
        setChatChannels,
        // currentChatMessages,
        loading,
        setLoading,
        error,
        setError,
    } = useCourse()
    const { user } = useAuth()
    const router = useRouter()
    useEffect(() => {
        if (!loading && (!course || error)) {
            router.push(`/course/${id}`)
        }
    }, [id]) // Only depend on params.id

    if (loading) return <div className="flex h-screen items-center justify-center">Loading...</div>
    if (error) return <div className="flex h-screen items-center justify-center text-red-500">{error}</div>
    if (!course) return null
    const currentChannel = chatChannels.find(channel => channel.id === chatId)
    if (!currentChannel) return <div className="flex h-screen items-center justify-center">Chapter not found</div>

    // Map API data to UI structure
    const mappedCourse = {
        title: course.name,
        joinCode: course.join_code,
        chapters: (course.sections || []).map((section: any, idx: number) => ({
            id: section.id, // Always use the actual section ID
            title: section.title || `Section ${section.order_index || idx + 1}`,
        })),
        channels: chatChannels.map((channel: any) => ({
            id: channel.id,
            name: channel.name,
        })),
    }

    const currentChat = {
        id: currentChannel.id, // Use the actual section ID for navigation
        name: currentChannel.name || `Chapter ${chatId}`,
    }

    interface GroupChatProps {
        chatId: string;
        currentUserId: string;
        currentUserName: string;
    }

    const GroupChat: React.FC<GroupChatProps> = ({
        chatId = currentChat.id,
        currentUserId = user?.id,
        currentUserName = user?.name
    }) => {
        // Use the messages from context as initial state
        const [messages, setMessages] = useState<Message[]>([]);
        const [newMessage, setNewMessage] = useState('');
        const [editingMessage, setEditingMessage] = useState<string | null>(null);
        const [editContent, setEditContent] = useState('');
        const [isConnected, setIsConnected] = useState(false);
        const [isLoading, setIsLoading] = useState(true);
        const [sendingMessage, setSendingMessage] = useState(false);
        const [page, setPage] = useState(1);
        const [hasMore, setHasMore] = useState(true);
        const [connectionError, setConnectionError] = useState<string | null>(null);

        const messagesEndRef = useRef<HTMLDivElement>(null);
        const subscriptionRef = useRef<any>(null);
        const consumerRef = useRef<any>(null);

        // Debug function to check what's happening
        const debugWebSocket = (message: string) => {
            console.log(`[WebSocket Debug] ${message}`);
        };

        // Initialize WebSocket connection
        useEffect(() => {
            debugWebSocket("Setting up ActionCable connection...");
            try {
                if (typeof window === 'undefined') {
                    debugWebSocket("Window is undefined, skipping setup");
                    return;
                }

                if (typeof ActionCable === 'undefined') {
                    setConnectionError("ActionCable is not defined. Check if it's properly imported.");
                    console.error("ActionCable is not defined! Attempting to load it dynamically...");

                    // Attempt to dynamically load ActionCable
                    const script = document.createElement('script');
                    script.src = 'https://cdn.jsdelivr.net/npm/actioncable@5.2.8/lib/assets/compiled/action_cable.min.js';
                    script.async = true;
                    script.onload = () => {
                        console.log("ActionCable loaded dynamically!");
                        window.location.reload(); // Refresh to use the newly loaded library
                    };
                    script.onerror = () => {
                        setConnectionError("Failed to load ActionCable. Please check your internet connection and try again.");
                    };
                    document.body.appendChild(script);
                    return;
                }

                // Make sure API endpoint is correct
                // const wsUrl = "ws://triaina-backend-service.triaina.svc.cluster.local:80/cable";
                const wsUrl = "ws://localhost:32060/cable";
                debugWebSocket(`Connecting to WebSocket at: ${wsUrl}`);

                const consumer = ActionCable.createConsumer(wsUrl);
                consumerRef.current = consumer;

                // Create subscription with very explicit logging
                const subscription = consumer.subscriptions.create(
                    { channel: "CourseChatChannel", channel_id: chatId },
                    {
                        connected: function () {
                            debugWebSocket("✅ Connected to CourseChatChannel!");
                            setIsConnected(true);
                            setConnectionError(null);
                            debugWebSocket("Fetching messages...");
                            // Explicitly fetch messages
                            this.perform('fetch_messages', { page: 1 });
                            debugWebSocket("fetch_messages action performed");
                        },

                        disconnected: function () {
                            debugWebSocket("❌ Disconnected from CourseChatChannel");
                            setIsConnected(false);
                            setConnectionError("WebSocket disconnected. Attempting to reconnect...");

                            // Try to reconnect after a short delay
                            setTimeout(() => {
                                debugWebSocket("Attempting to reconnect...");
                                try {
                                    // Create a new consumer and reconnect
                                    if (consumerRef.current) {
                                        consumerRef.current.disconnect();
                                    }
                                    const newConsumer = ActionCable.createConsumer(wsUrl);
                                    consumerRef.current = newConsumer;

                                    // Recreate subscription
                                    const newSubscription = newConsumer.subscriptions.create(
                                        { channel: "CourseChatChannel", channel_id: chatId },
                                        this // Use the same callbacks
                                    );
                                    subscriptionRef.current = newSubscription;
                                } catch (error) {
                                    debugWebSocket(`Reconnection failed: ${error}`);
                                    setConnectionError("Reconnection failed. Please reload the page to try again.");
                                }
                            }, 3000);
                        },

                        rejected: function () {
                            debugWebSocket("🚫 Connection rejected!");
                            setIsConnected(false);
                            setConnectionError("WebSocket connection rejected. Please check server configuration.");
                        },

                        received: function (data) {
                            debugWebSocket(`📩 Received data: ${JSON.stringify(data)}`);
                            console.dir(data); // More detailed logging of the actual object

                            if (data.messages && Array.isArray(data.messages)) {
                                debugWebSocket(`Received ${data.messages.length} messages`);
                                console.log("Messages data:", data.messages);

                                // Always update messages (for create/update/delete operations)
                                // Only do pagination logic if this is page 1 or higher
                                if (data.page > 1) {
                                    // This is pagination - append older messages to beginning
                                    setMessages(prevMessages => [...(data.messages || []), ...prevMessages]);
                                } else {
                                    // This is current page (page 1) - replace current messages
                                    // This handles: initial load, new messages, updates, deletes
                                    setMessages(data.messages || []);
                                }

                                // Set pagination info
                                setHasMore(!!data.next);
                                setIsLoading(false);

                            }
                            // Handle individual message responses (new message created/updated)
                            else if (data.message && data.message.id) {
                                debugWebSocket("Received individual message");
                                console.log("Individual message:", data.message);

                                // Add the new message to the end of the list
                                setMessages(prevMessages => {
                                    // Check if message already exists (in case of update)
                                    const existingIndex = prevMessages.findIndex(msg => msg.id === data.message.id);
                                    if (existingIndex >= 0) {
                                        // Update existing message
                                        const updated = [...prevMessages];
                                        updated[existingIndex] = data.message;
                                        return updated;
                                    } else {
                                        // Add new message
                                        return [data.message, ...prevMessages];
                                    }
                                });

                                // Scroll to bottom for new messages
                                setTimeout(() => scrollToBottom(), 100);
                            }
                            // Handle message deletion
                            else if (data.message_id) {
                                debugWebSocket("Received message deletion");
                                console.log("Deleting message ID:", data.message_id);

                                // Remove the message from the list
                                setMessages(prevMessages =>
                                    prevMessages.filter(msg => msg.id !== data.message_id)
                                );

                            } else {
                                debugWebSocket(`Unexpected message format: ${JSON.stringify(data)}`);
                            }
                        },

                        send_message: function (message: string) {
                            debugWebSocket(`Sending message: ${message}`);
                            this.perform('send_message', { message: message });
                        },

                        update_message: function (message_id: string, message: string) {
                            debugWebSocket(`Updating message ${message_id}`);
                            this.perform('update_message', { message_id: message_id, message: message });
                        },

                        delete_message: function (message_id: string) {
                            debugWebSocket(`Deleting message ${message_id}`);
                            this.perform('delete_message', { message_id: message_id });
                        },

                        fetch_messages: function (page: number = 1) {
                            debugWebSocket(`Fetching messages page ${page}`);
                            this.perform('fetch_messages', { page: page });
                        }
                    }
                );

                subscriptionRef.current = subscription;

                // Cleanup on unmount
                return () => {
                    debugWebSocket("Cleaning up WebSocket connection");
                    if (subscriptionRef.current) {
                        subscriptionRef.current.unsubscribe();
                    }
                    if (consumerRef.current) {
                        consumerRef.current.disconnect();
                    }
                };
            } catch (error) {
                console.error("Error setting up WebSocket:", error);
                setConnectionError(`WebSocket setup error: ${error instanceof Error ? error.message : 'Unknown error'}`);
                return () => { };
            }
        }, [chatId]);

        useEffect(() => {
            scrollToBottom();
        }, [messages]);

        const scrollToBottom = () => {
            messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
        };

        const handleSendMessage = async (e: React.FormEvent | React.KeyboardEvent) => {
            console.log("Sending message:", newMessage);
            e.preventDefault();

            if (!newMessage.trim() || sendingMessage) return;

            setSendingMessage(true);

            try {
                if (isConnected && subscriptionRef.current) {
                    debugWebSocket(`Sending message via WebSocket: ${newMessage.trim()}`);
                    subscriptionRef.current.send_message(newMessage.trim());
                    setNewMessage('');
                } else {
                    setConnectionError("Cannot send message: WebSocket not connected");
                }
            } catch (error) {
                console.error("Error sending message:", error);
                setConnectionError(`Failed to send message: ${error instanceof Error ? error.message : 'Unknown error'}`);
            } finally {
                setSendingMessage(false);
            }
        };

        const handleUpdateMessage = (messageId: string) => {
            if (editContent.trim() && subscriptionRef.current) {
                subscriptionRef.current.update_message(messageId, editContent.trim());
                setEditingMessage(null);
                setEditContent('');
            }
        };

        const handleDeleteMessage = (messageId: string) => {
            if (subscriptionRef.current && confirm('Are you sure you want to delete this message?')) {
                subscriptionRef.current.delete_message(messageId);
            }
        };

        const startEditing = (message: Message) => {
            setEditingMessage(message.id);
            setEditContent(message.content);
        };

        const cancelEditing = () => {
            setEditingMessage(null);
            setEditContent('');
        };

        const loadMoreMessages = () => {
            if (hasMore && subscriptionRef.current) {
                const nextPage = page + 1;
                setPage(nextPage);
                subscriptionRef.current.fetch_messages(nextPage);
            }
        };

        const formatTime = (timestamp: string) => {
            return new Date(timestamp).toLocaleTimeString([], {
                hour: '2-digit',
                minute: '2-digit'
            });
        };

        // Determine user color based on their ID
        // const getUserColor = (userId: string) => {
        //     const colors = [
        //         "bg-red-500", "bg-blue-500", "bg-green-500",
        //         "bg-yellow-500", "bg-purple-500", "bg-pink-500",
        //         "bg-indigo-500", "bg-orange-500", "bg-teal-500"
        //     ];

        //     // Simple hash function to consistently map a user ID to a color
        //     const hash = userId.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
        //     return colors[hash % colors.length];
        // };

        return (
            <div className="flex flex-col h-full">
                {/* Connection status indicator */}
                {/* {connectionError && (
                    <div className="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-2 mb-2 flex justify-between items-center">
                        <p className="text-sm">{connectionError}</p>
                        <button
                            onClick={() => window.location.reload()}
                            className="text-xs bg-yellow-200 hover:bg-yellow-300 px-2 py-1 rounded"
                        >
                            Reconnect
                        </button>
                    </div>
                )}

                {isConnected && (
                    <div className="bg-green-100 border-l-4 border-green-500 text-green-700 p-2 mb-2 text-sm">
                        Connected to chat server
                    </div>
                )} */}

                {/* Messages list */}
                <div className="flex-1 overflow-y-auto px-4 pt-4">
                    {isLoading ? (
                        <div className="flex flex-col justify-center items-center p-4">
                            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mb-2"></div>
                            <p>Loading messages...</p>
                            <p className="text-xs text-gray-500 mt-1">Connecting to WebSocket...</p>
                        </div>
                    ) : messages.length === 0 ? (
                        <div className="flex justify-center p-4 text-gray-500">
                            <div className="text-center">
                                <p>No messages yet. Start the conversation!</p>
                                {!isConnected && (
                                    <p className="text-xs text-red-500 mt-2">
                                        Not connected to chat server. Messages will not be delivered until connected.
                                    </p>
                                )}
                            </div>
                        </div>
                    ) : (
                        <>
                            {hasMore && (
                                <div className="flex justify-center mb-4">
                                    <button
                                        onClick={() => {
                                            if (subscriptionRef.current) {
                                                const nextPage = page + 1;
                                                setPage(nextPage);
                                                subscriptionRef.current.fetch_messages(nextPage);
                                            }
                                        }}
                                        className="text-sm text-blue-500 hover:underline"
                                    >
                                        Load more messages
                                    </button>
                                </div>
                            )}
                            {[...messages].reverse().map(message => (
                                <div key={message.id} className="mb-4">
                                    {editingMessage === message.id ? (
                                        <div className="flex flex-col space-y-2 pl-12">
                                            <textarea
                                                value={editContent}
                                                onChange={(e) => setEditContent(e.target.value)}
                                                className="w-full rounded-md border border-gray-300 p-2"
                                                autoFocus
                                            />
                                            <div className="flex space-x-2">
                                                <button
                                                    onClick={() => handleUpdateMessage(message.id)}
                                                    className="rounded-md bg-blue-500 px-3 py-1 text-white hover:bg-blue-600"
                                                >
                                                    Save
                                                </button>
                                                <button
                                                    onClick={cancelEditing}
                                                    className="rounded-md bg-gray-300 px-3 py-1 text-gray-700 hover:bg-gray-400"
                                                >
                                                    Cancel
                                                </button>
                                            </div>
                                        </div>
                                    ) : (
                                        <ChatMessage
                                            message={{
                                                id: message.id,
                                                user: message.user.name || 'Unknown User',
                                                time: formatTime(message.created_at),
                                                content: message.content,
                                                color: getUserColor(message.user.id)
                                            }}
                                        />
                                    )}
                                    {message.user.id === currentUserId && !editingMessage && (
                                        <div className="flex space-x-2 pl-12 mt-1">
                                            <button
                                                onClick={() => startEditing(message)}
                                                className="text-xs text-gray-500 hover:text-gray-700"
                                            >
                                                Edit
                                            </button>
                                            <button
                                                onClick={() => handleDeleteMessage(message.id)}
                                                className="text-xs text-red-500 hover:text-red-700"
                                            >
                                                Delete
                                            </button>
                                        </div>
                                    )}
                                </div>
                            ))}
                            <div ref={messagesEndRef} />
                        </>
                    )}
                </div>

                {/* Message input */}
                <div className="border-t border-gray-200 p-4">
                    {!isConnected && !connectionError ? (
                        <div className="text-center py-2 text-gray-500">
                            <div className="inline-block animate-spin mr-2 h-4 w-4 border-t-2 border-gray-500 rounded-full"></div>
                            Connecting to chat server...
                        </div>
                    ) : (
                        <form onSubmit={handleSendMessage} className="flex items-center">
                            <div className="flex items-center rounded-md border border-gray-300 bg-white p-2 flex-1">
                                <button type="button" className="mr-2 text-gray-400">
                                    <span className="text-xl">😊</span>
                                </button>
                                <input
                                    type="text"
                                    value={newMessage}
                                    onChange={(e) => setNewMessage(e.target.value)}
                                    onKeyPress={(e) => e.key === 'Enter' && !e.shiftKey && handleSendMessage(e)}
                                    placeholder={`Message # ${currentChat.name}`}
                                    className="flex-1 bg-transparent outline-none"
                                    disabled={sendingMessage || !isConnected}
                                />
                            </div>
                            <button
                                type="submit"
                                disabled={!newMessage.trim() || sendingMessage || !isConnected}
                                className={`ml-2 rounded-md px-4 py-2 text-white ${!newMessage.trim() || sendingMessage || !isConnected
                                    ? 'bg-gray-300 text-gray-500'
                                    : 'bg-blue-500 hover:bg-blue-600'
                                    }`}
                            >
                                {sendingMessage ? 'Sending...' : 'Send'}
                            </button>
                        </form>
                    )}
                </div>
            </div>
        );
    };

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
                    <div className="flex flex-col">
                        <div className="flex items-center">
                            <h1 className="mr-2 font-medium">{mappedCourse.title}</h1>
                            <span className="flex items-center text-gray-500">
                                <Hash className="mr-1 h-4 w-4" />
                                {currentChat.name || 'Chat Channel'}
                            </span>
                        </div>
                        {/* <div className="text-xs text-gray-500 mt-1">
                            {currentChatMessages.length > 0
                                ? `Last message: ${new Date(currentChatMessages[currentChatMessages.length - 1].created_at).toLocaleString()}`
                                : 'No messages yet'
                            }
                        </div> */}
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

                {/* GroupChat component */}
                <div className="flex-1 flex flex-col overflow-hidden">
                    <GroupChat
                        chatId={chatId}
                        currentUserId={user?.id || ''}
                        currentUserName={user?.name || 'Anonymous'}
                    />
                </div>
            </div>
        </div>
    )
}
