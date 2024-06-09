'use client';

import { useState, useEffect } from 'react';

export default function useToken() {
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);
  const getToken = () => {
    if (!isClient) {
      return null;
    }

    const token = localStorage.getItem('token');
    return token;
  };

  const [token, setToken] = useState(getToken());

  const saveTokenToLocalStorage = (token: string) => {
    if (!isClient) {
      return null;
    }

    localStorage.setItem('token', token);
    setToken(token);
  };

  const removeTokenFromLocalStorage = () => {
    if (!isClient) {
      return null;
    }

    localStorage.removeItem('token');
    setToken(null);
  };

  return {
    setToken: saveTokenToLocalStorage,
    removeToken: removeTokenFromLocalStorage,
    token,
  };
}
