"use client"

import { createContext, useContext, useState, useEffect, ReactNode, useCallback, useMemo } from 'react';
import { useRouter } from 'next/navigation';
import { authService } from '@/lib/networkService';

// Define the User interface based on your API response
export interface User {
  id: string;
  name: string;
  username: string;
  email: string;
  // Add any other user properties from your API
}

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<any>;
  logout: () => Promise<void>;
  checkAuth: () => Promise<boolean>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(true);
  const router = useRouter();
  // Function to check authentication status - memoized to prevent re-renders
  const checkAuth = useCallback(async (): Promise<boolean> => {
    setIsLoading(true);
    try {
      // Try to get current user from the server
      try {
        const response = await authService.getCurrentUser();
        if (response.data && response.data.user) {
          setUser(response.data.user);
          // Update localStorage with the latest user data
          localStorage.setItem('userData', JSON.stringify(response.data.user));
          setIsLoading(false);
          return true;
        }
      } catch (apiError) {
        // API request failed, fall back to localStorage
        console.log("getCurrentUser API failed, using localStorage fallback");
      }
      
      // Fallback to localStorage if API request fails
      const userData = localStorage.getItem('userData');
      if (userData) {
        setUser(JSON.parse(userData));
        setIsLoading(false);
        return true;
      }
      
      // If no userData, the user is unauthenticated
      setUser(null);
      setIsLoading(false);
      return false;
    } catch (error) {
      console.error('Authentication check failed:', error);
      setUser(null);
      setIsLoading(false);
      return false;
    }
  }, []);

  // Login function - memoized to prevent re-renders
  const login = useCallback(async (email: string, password: string) => {
    setIsLoading(true);
    try {
      const response = await authService.login(email, password);
      
      if (response.data.success) {
        // With cookie-based auth, the token is automatically stored in the cookies by the server
        // No need to manually store the token
        
        // Save user data in localStorage for convenience
        const userData = response.data.user;
        localStorage.setItem('userData', JSON.stringify(userData));
        
        // Update context
        setUser(userData);
        setIsLoading(false);
        return response;
      }
    } catch (error) {
      setIsLoading(false);
      throw error;
    } finally {
      setIsLoading(false);
    }
  }, []);
  // Logout function - memoized to prevent re-renders
  const logout = useCallback(async () => {
    try {
      // Attempt to call logout API if it exists
      await authService.logout();
    } catch (error) {
      // If no server logout endpoint, we'll handle client-side only
      console.log("Using client-side logout fallback");
    } finally {
      // Clear authentication cookie by setting an expired cookie
      // This is a client-side approach if the server doesn't have a logout endpoint
    //   document.cookie = 'auth_token=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
      
      // Clear local user data
      localStorage.removeItem('userData');
      setUser(null);
      router.push('/sign-in');
    }
  }, [router]);

  // Check authentication on initial load
  useEffect(() => {
    checkAuth();
  }, [checkAuth]);

  // Derive authentication state from user object
  const isAuthenticated = !!user;

  // Memoize context value to prevent unnecessary re-renders
  const contextValue = useMemo(() => ({
    user,
    isLoading,
    isAuthenticated,
    login,
    logout,
    checkAuth
  }), [user, isLoading, isAuthenticated, login, logout, checkAuth]);

  return (
    <AuthContext.Provider value={contextValue}>
      {children}
    </AuthContext.Provider>
  );
}

// Custom hook for using auth context
export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}