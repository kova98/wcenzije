'use client';

import { useEffect, useState } from 'react';

export default function useToken() {
  const [token, setToken] = useState<string | null>(null);

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const tokenFromStorage = localStorage.getItem('token');
      if (tokenFromStorage) {
        setToken(tokenFromStorage);
      }
    }
  }, []);

  const saveTokenToLocalStorage = (newToken: string) => {
    if (typeof window !== 'undefined') {
      localStorage.setItem('token', newToken);
      setToken(newToken);
    }
  };

  const getTokenFromLocalStorage = () => {
    if (typeof window !== 'undefined') {
      return localStorage.getItem('token');
    }
    return null;
  };

  const removeTokenFromLocalStorage = () => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('token');
      setToken(null);
    }
  };

  return {
    setToken: saveTokenToLocalStorage,
    removeToken: removeTokenFromLocalStorage,
    getToken: getTokenFromLocalStorage,
  };
}
