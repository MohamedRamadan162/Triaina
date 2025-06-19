import { InternalAxiosRequestConfig } from 'axios';

const authInterceptor = (config: InternalAxiosRequestConfig) => {
    // With cookie-based authentication, we don't need to add the Authorization header
    // The cookie will be automatically included in requests to the same domain
    
    // Set withCredentials to true to ensure cookies are sent with cross-domain requests
    config.withCredentials = true;
    
    return config;
};

export default authInterceptor;