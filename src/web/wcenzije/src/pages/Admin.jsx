import React from "react";
import { Outlet } from "react-router-dom";
import { Login } from ".";
import Navbar from "../Navbar.jsx";
const Admin = ({ token, setToken }) => {
  if (!token) {
    return <Login setToken={setToken} />;
  }

  return (
    <>
      <Navbar />
      <Outlet />
    </>
  );
};

export default Admin;
