import React, { createContext, useContext, ReactNode } from "react";
import axios, { AxiosInstance, AxiosRequestConfig, AxiosResponse } from "axios";

interface ApiContextProps {
  get: <T = any>(url: string, config?: AxiosRequestConfig) => Promise<AxiosResponse<T>>;
  post: <T = any>(url: string, data?: any, config?: AxiosRequestConfig) => Promise<AxiosResponse<T>>;
  put: <T = any>(url: string, data?: any, config?: AxiosRequestConfig) => Promise<AxiosResponse<T>>;
  delete: <T = any>(url: string, config?: AxiosRequestConfig) => Promise<AxiosResponse<T>>;
  axiosInstance: AxiosInstance;
}

const ApiContext = createContext<ApiContextProps | undefined>(undefined);

interface ApiProviderProps {
  children: ReactNode;
  baseURL?: string;
}

export const ApiProvider: React.FC<ApiProviderProps> = ({
  children,
  baseURL = process.env.REACT_APP_API_URL || '/api',
}) => {
  const axiosInstance = axios.create({
    baseURL,
    headers: {
      'Content-Type': 'application/json',
    },
    withCredentials: true,
  });

  // Add request interceptor for auth token
  axiosInstance.interceptors.request.use(
    (config) => {
      const token = localStorage.getItem('auth_token');
      if (token && config.headers) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => Promise.reject(error)
  );

  // Add response interceptor for error handling
  axiosInstance.interceptors.response.use(
    (response) => response,
    (error) => {
      // Handle unauthorized errors
      if (error.response && error.response.status === 401) {
        // Clear auth token and redirect to login
        localStorage.removeItem('auth_token');
        window.location.href = '/login';
      }
      return Promise.reject(error);
    }
  );

  const value: ApiContextProps = {
    axiosInstance,
    get: <T = any>(url: string, config?: AxiosRequestConfig) => 
      axiosInstance.get<T>(url, config),
    post: <T = any>(url: string, data?: any, config?: AxiosRequestConfig) => 
      axiosInstance.post<T>(url, data, config),
    put: <T = any>(url: string, data?: any, config?: AxiosRequestConfig) => 
      axiosInstance.put<T>(url, data, config),
    delete: <T = any>(url: string, config?: AxiosRequestConfig) => 
      axiosInstance.delete<T>(url, config),
  };

  return <ApiContext.Provider value={value}>{children}</ApiContext.Provider>;
};

export const useApiContext = (): ApiContextProps => {
  const context = useContext(ApiContext);
  if (!context) {
    throw new Error('useApiContext must be used within an ApiProvider');
  }
  return context;
}; 