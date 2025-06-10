"use client";

import React, { createContext, useContext, useState, ReactNode } from 'react';

// Define types for our course data
export interface Unit {
  id: string;
  content_url: string | null;
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
  start_date: string;
}

// Context interface
interface CourseContextType {
  course: Course | null;
  setCourse: (course: Course) => void;
  loading: boolean;
  setLoading: (loading: boolean) => void;
  error: string | null;
  setError: (error: string | null) => void;
}

// Create context with default values
const CourseContext = createContext<CourseContextType>({
  course: null,
  setCourse: () => {},
  loading: false,
  setLoading: () => {},
  error: null,
  setError: () => {},
});

// Provider component
export const CourseProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [course, setCourse] = useState<Course | null>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  return (
    <CourseContext.Provider value={{ course, setCourse, loading, setLoading, error, setError }}>
      {children}
    </CourseContext.Provider>
  );
};

// Custom hook for using the context
export const useCourse = () => useContext(CourseContext);
