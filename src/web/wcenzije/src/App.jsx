import { useState } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Home, Admin, Login } from "./pages";

import "./App.css";
import Navbar from "./components/Navbar";
import useToken from "./components/useToken";

function App() {
  const { token, setToken } = useToken();
  console.log("token: " + token);
  if (!token) {
    return <Login setToken={setToken} />;
  }

  return (
    <div>
      <Navbar />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/admin" element={<Admin />} />
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
