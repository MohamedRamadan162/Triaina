import axios, { AxiosInstance } from 'axios';
import authInterceptor from './authInterceptor';
import { requestLogger, responseLogger, errorLogger } from './loggingInterceptor';

const BASE_URL = '/api/backend';

// const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';
// const response = await fetch(`${API_URL}/api/v1/auth/signup`);

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
};

// Course Services
export const courseService = {
    getCourse: (courseId: string) =>
        api.get(`/courses/${courseId}`),
};

