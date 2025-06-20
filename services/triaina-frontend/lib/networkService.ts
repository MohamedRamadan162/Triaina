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
        api.get(`/courses/${courseId}/course_chats`),
    courseEnrollment: (joinCode: string) =>
        api.post(`/courses/enrollments`, { course_join_code: joinCode }),
    
    // Chat-specific methods
    getChatMessages: (courseId: string, chatId: string, params: { page?: number, per_page?: number } = {}) => 
        api.get(`/courses/${courseId}/course_chats/${chatId}/messages`, { params }),
        
    sendMessage: (courseId: string, chatId: string, content: string) =>
        api.post(`/courses/${courseId}/course_chats/${chatId}/messages`, { content }),
        
    updateMessage: (courseId: string, chatId: string, messageId: string, content: string) =>
        api.put(`/courses/${courseId}/course_chats/${chatId}/messages/${messageId}`, { content }),
        
    deleteMessage: (courseId: string, chatId: string, messageId: string) =>
        api.delete(`/courses/${courseId}/course_chats/${chatId}/messages/${messageId}`),

    // Ai features 
    getTranscription: (courseId:string,sectionId:string, partId: string) => api.get(`/courses/${courseId}/sections/${sectionId}/units/${partId}/transcription`),
    getSummary: (courseId:string,sectionId:string, partId: string) => api.get(`/courses/${courseId}/sections/${sectionId}/units/${partId}/summary`)

};

