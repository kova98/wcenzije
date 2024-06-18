'use client';

import { useEffect, useState } from 'react';

export default function useToken() {
  const [token, setToken] = useState<string | null>(null);

  useEffect(() => {
    const tokenFromStorage = localStorage.getItem('token');
    if (tokenFromStorage) {
      setToken(tokenFromStorage);
    }
  }, []);

  const saveTokenToLocalStorage = (newToken: string) => {
    localStorage.setItem('token', newToken);
    setToken(newToken);
  };

  const getTokenFromLocalStorage = () => {
    return localStorage.getItem('token');
  };

  const removeTokenFromPortalStorage = () => {
    localStorage.removeItem('token');
    setToken(null);
  };

  return {
    setToken: saveTokenToLocalStorage,
    removeToken: removeTokenFromPortalStorage,
    getToken: getTokenFromLocalStorage,
  };
}
