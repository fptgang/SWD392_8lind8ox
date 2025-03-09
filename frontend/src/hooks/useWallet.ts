import { useState, useEffect } from "react";
import { notification } from "antd";
import { useApiContext } from "../contexts/api-context";
import { HttpError } from "@refinedev/core";

interface WalletTopUpParams {
  amount: number;
}

export const useWallet = () => {
  const [balance, setBalance] = useState<number>(0);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);
  
  const apiContext = useApiContext();
  
  const fetchBalance = async () => {
    setLoading(true);
    setError(null);
    
    try {
      // Assume we have a wallet endpoint
      const response = await apiContext.get<{ balance: number }>("/auth/me");
      setBalance(response.data.balance);
    } catch (err: any) {
      let errorMessage = "Failed to fetch wallet balance";
      if (err?.response?.data?.message) {
        errorMessage = err.response.data.message;
      }
      setError(errorMessage);
      notification.error({
        message: "Error",
        description: errorMessage,
      });
    } finally {
      setLoading(false);
    }
  };
  
  const topUp = async (amount: number): Promise<void> => {
    if (amount <= 0) {
      throw new Error("Amount must be greater than 0");
    }
    
    setLoading(true);
    setError(null);
    
    try {
      // Assume we have a top-up endpoint
      const response = await apiContext.post<{ balance: number }>("/wallet/topup", {
        amount,
      });
      
      setBalance(response.data.balance);
      return Promise.resolve();
    } catch (err: any) {
      let errorMessage = "Failed to top up wallet";
      if (err?.response?.data?.message) {
        errorMessage = err.response.data.message;
      }
      setError(errorMessage);
      return Promise.reject(new Error(errorMessage));
    } finally {
      setLoading(false);
    }
  };
  
  // Load wallet balance on mount
  useEffect(() => {
    fetchBalance();
  }, []);
  
  return {
    balance,
    loading,
    error,
    topUp,
    refresh: fetchBalance,
  };
}; 