"use client";

import React, { createContext, useContext, useState, ReactNode } from 'react';
import { User } from './AuthContext';

// Define types for our course data
export interface Message {
  id: string;
  content: string;
  chat_id: string;
  user: User
  created_at: string;
  updated_at: string;
} 
export interface Chat {
  id: string;
  name: string;
  messages: Message[];
  course_id: string;
  created_at: string;
  updated_at: string;
}
export interface Unit {
  id: string;
  content_url: string ;
  description: string | null;
  order_index: number;
  section_id: string;
  title: string;
}

export interface Section {
  id: string;
  course_id: string;
  description: string | null;
  order_index: number;
  title: string;
  units: Unit[];
}

export interface Course {
  id: string;
  description: string | null;
  end_date: string | null;
  join_code: string;
  name: string;
  sections: Section[];
  chats: Chat[];
  start_date: string;
}

// Context interface
interface CourseContextType {
  course: Course | null;
  setCourse: (course: Course) => void;
  chatChannels: Chat[];
  setChatChannels: (channels: Chat[]) => void;
  currentChatMessages: Message[];
  setCurrentChatMessages: (messages: Message[]) => void;
  loading: boolean;
  setLoading: (loading: boolean) => void;
  error: string | null;
  setError: (error: string | null) => void;
}

// Create context with default values
const CourseContext = createContext<CourseContextType>({
  course: null,
  setCourse: () => {},
  chatChannels: [],
  setChatChannels: () => {},
  currentChatMessages: [],
  setCurrentChatMessages: () => {},
  loading: false,
  setLoading: () => {},
  error: null,
  setError: () => {},
});

// Provider component
export const CourseProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [course, setCourse] = useState<Course | null>(null);
  const [chatChannels, setChatChannels] = useState<Chat[]>([]);
  const [currentChatMessages, setCurrentChatMessages] = useState<Message[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  return (
    <CourseContext.Provider value={{ 
      course, 
      setCourse, 
      chatChannels, 
      setChatChannels,
      currentChatMessages,
      setCurrentChatMessages,
      loading, 
      setLoading, 
      error, 
      setError,
    }}>
      {children}
    </CourseContext.Provider>
  );
};

// Custom hook for using the context
export const useCourse = () => useContext(CourseContext);
