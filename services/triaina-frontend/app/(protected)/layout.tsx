"use client";

import { ReactNode } from 'react';
import { CourseProvider } from '@/context/CourseContext';

export default function ProtectedLayout({ children }: { children: ReactNode }) {
  return (
    <CourseProvider>
      {children}
    </CourseProvider>
  );
}
