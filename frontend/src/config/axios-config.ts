import axios from "axios";
import { REFRESH_TOKEN_KEY, TOKEN_KEY } from "../authProvider";
import api from "./openapi-config";

const axiosInstance = axios.create();

// Add request interceptor to set Authorization header
axiosInstance.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem(TOKEN_KEY);
    if (token) {
      config.headers["Authorization"] = `Bearer ${token}`;
    }
    console.log("Request:", config);
    return config;
  },
  (error) => {
    console.error("Request Error:", error);
    return Promise.reject(error);
  }
);

// Modify response interceptor to log successful responses
axiosInstance.interceptors.response.use(
  (response) => {
    console.log("Response Success:", response);
    return response;
  },
  async (error) => {
    console.error("Response Error:", error);
    const originalRequest = error.config;

    console.log("attempting to refresh token");
    console.log("refresh token", localStorage.getItem(REFRESH_TOKEN_KEY));

    // Only attempt refresh if it's a 401 error, and we have a refresh token
    if (
      error.response?.status === 401 &&
      !originalRequest._retry
    ) {
      console.log("attempting to refresh token  2");
      const refresh_token = localStorage.getItem(REFRESH_TOKEN_KEY);

      if (refresh_token) {
        try {
          // Mark the request as retried to prevent infinite loops
          originalRequest._retry = true;

          // Attempt to refresh the token
          const response = await api.refreshToken({ 
            body : refresh_token
          }); 
          
          console.log("refresh token response", response?.refreshToken);

          if (response.accessToken && response.refreshToken) {
            // Update tokens in localStorage
            localStorage.setItem(TOKEN_KEY, response.accessToken);
            localStorage.setItem(REFRESH_TOKEN_KEY, response.refreshToken);

            // Update the authorization header
            originalRequest.headers[
              "Authorization"
            ] = `Bearer ${response.accessToken}`;

            // Retry the original request with new token
            return axiosInstance(originalRequest);
          }
        } catch (refreshError) {
          // Handle refresh token failure
          localStorage.removeItem(TOKEN_KEY);
          localStorage.removeItem(REFRESH_TOKEN_KEY);

          // Redirect to login page
          window.location.href = "/login";
          return Promise.reject(refreshError);
        }
      }
    }

    // Handle other 401 errors (no refresh token)
    if (error.response?.status === 401) {
      localStorage.removeItem(TOKEN_KEY);
      localStorage.removeItem(REFRESH_TOKEN_KEY);
    }

    return Promise.reject(error);
  }
);

export default axiosInstance;
