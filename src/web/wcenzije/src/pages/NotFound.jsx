import React from "react";
import { Link } from "react-router-dom";
import Home from "./Home";

const NotFound = () => {
  return (
    <div className="flex flex-col h-screen justify-center items-center">
      <h1 className="text-4xl font-bold">Page Not Found</h1>
      <Link to="/" className=" link pt-5">
        Home
      </Link>
    </div>
  );
};

export default NotFound;
