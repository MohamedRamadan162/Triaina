import axios, { AxiosInstance } from 'axios';
import authInterceptor from './authInterceptor';
import { requestLogger, responseLogger, errorLogger } from './loggingInterceptor';

const BASE_URL = '/api/backend';


const api: AxiosInstance = axios.create({
    baseURL: BASE_URL,
    headers: {
        'Content-Type': 'application/json',
    },
});

// Add interceptors
api.interceptors.request.use(authInterceptor);
api.interceptors.request.use(requestLogger);
api.interceptors.response.use(responseLogger, errorLogger);

// Auth Services
export const authService = {
    login: (email: string, password: string) =>
        api.post('/auth/login', { email, password }),

    register: (userData: any) =>
        api.post('/auth/signup', userData),
        
    // Use logout endpoint if it exists, otherwise use a universal approach
    logout: () =>
        api.post('/auth/logout').catch(() => {
            console.warn("Logout endpoint not available, handling client-side only");
            return Promise.resolve({ data: { success: true } });
        }),    
    // Use getCurrentUser instead of verifyAuth
    getCurrentUser: () =>
        api.get('/users/me'),
};

// Course Services
export const courseService = {
    getCourse: (courseId: string) =>
        api.get(`/courses/${courseId}`),
    
    getChatChannels: (courseId: string) =>
        api.get(`/courses/${courseId}/chat_channels`),
    
    // Chat-specific methods
    getChatMessages: (courseId: string, chatId: string, params: { page?: number, per_page?: number } = {}) => 
        api.get(`/courses/${courseId}/chat_channels/${chatId}/messages`, { params }),
        
    sendMessage: (chatId: string, content: string) =>
        api.post(`/chats/${chatId}/messages`, { content }),
        
    updateMessage: (chatId: string, messageId: string, content: string) =>
        api.put(`/chats/${chatId}/messages/${messageId}`, { content }),
        
    deleteMessage: (chatId: string, messageId: string) =>
        api.delete(`/chats/${chatId}/messages/${messageId}`)
};

