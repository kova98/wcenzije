// delete account page

import React, { useState } from "react";
import { Link } from "react-router-dom";
import axios from "axios";
import useToken from "../components/useToken";
import Navbar from "../Navbar";
import Login from "./Login";

const DeleteAccount = () => {
  const SERVER_URL = import.meta.env.VITE_SERVER_ROOT_URL;
  const endpoint = `${SERVER_URL}/api/auth/account`;

  const { token, setToken, removeToken } = useToken();
  const [error, setError] = useState(null);

  const deleteData = async () => {
    try {
      await axios.delete(endpoint, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      removeToken();
    } catch (error) {
      setError(error.response.data.message[0].messages[0].message);
    }
  };

  if (!token) {
    return <Login setToken={setToken} />;
  }

  return (
    <>
      <Navbar />
      <div className="flex flex-col h-screen justify-center items-center">
        <h1 className="text-4xl font-bold">Delete Data</h1>
        <p className="p-3">
          Clicking the button below will delete all your data from our servers,
          including your user account and all reviews you have submitted.
        </p>
        <p>This action is irreversible.</p>
        <button
          onClick={deleteData}
          className="bg-red-500 text-white px-4 py-2 rounded mt-5"
        >
          Delete Account
        </button>
        {error && <p className="text-red-500 mt-5">{error}</p>}
      </div>
    </>
  );
};

export default DeleteAccount;
