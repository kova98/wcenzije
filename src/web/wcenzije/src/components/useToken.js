import { useState } from "react";

export default function useToken() {
  const getToken = () => {
    const token = localStorage.getItem("token");
    return token;
  };

  const [token, setToken] = useState(getToken());

  const saveTokenToLocalStorage = (token) => {
    localStorage.setItem("token", token);
    setToken(token);
  };

  const removeTokenFromLocalStorage = () => {
    localStorage.removeItem("token");
    setToken(null);
  };

  return {
    setToken: saveTokenToLocalStorage,
    removeToken: removeTokenFromLocalStorage,
    token,
  };
}
