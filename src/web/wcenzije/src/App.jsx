import { useState } from "react";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import { Home, Admin, Login } from "./pages";
import axios from "axios";

import "./App.css";
import Navbar from "./components/Navbar";
import useToken from "./components/useToken";

function App() {
  const { token, setToken } = useToken();
  if (!token) {
    return <Login setToken={setToken} />;
  }

  axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;

  return (
    <div>
      <Navbar />
      <BrowserRouter>
        <div className="drawer drawer-mobile">
          <input id="navbar-drawer" type="checkbox" className="drawer-toggle" />
          <div className="drawer-content flex flex-col items-center justify-center">
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/admin" element={<Admin setToken={setToken} />} />
            </Routes>

            <label
              htmlFor="navbar-drawer"
              className="btn btn-primary hidden"
              id="drawer-button"
            ></label>
          </div>
          <div className="drawer-side">
            <label htmlFor="navbar-drawer" className="drawer-overlay"></label>
            <ul className="menu p-4 w-60 bg-base-100 text-base-content">
              <li>
                <a>Sidebar Item 1</a>
              </li>
              <li>
                <a>Sidebar Item 2</a>
              </li>
            </ul>
          </div>
        </div>
      </BrowserRouter>
    </div>
  );
}

export default App;
