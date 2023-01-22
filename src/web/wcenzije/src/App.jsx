import { BrowserRouter, Route, Routes, Link } from "react-router-dom";
import { Home, Reviews, Login } from "./pages";
import axios from "axios";

import "./App.css";
import useToken from "./components/useToken";

function App() {
  const { token, setToken } = useToken();
  if (!token) {
    return <Login setToken={setToken} />;
  }

  axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;

  const toggleDrawer = () => {
    document.getElementById("drawer-button").click();
  };

  return (
    <div>
      <BrowserRouter>
        <div className="navbar bg-base-100">
          <div className="flex-none">
            <button
              onClick={toggleDrawer}
              className="btn btn-square btn-ghost drawer-button lg:hidden"
              htmlFor="navbar-drawer"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                className="inline-block w-5 h-5 stroke-current"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M4 6h16M4 12h16M4 18h16"
                ></path>
              </svg>
            </button>
          </div>
          <div className="flex-1">
            <a className="btn btn-ghost normal-case text-xl">
              <Link to="/">wcenzije</Link>
            </a>
          </div>
        </div>
        <div className="drawer drawer-mobile">
          <input id="navbar-drawer" type="checkbox" className="drawer-toggle" />
          <div className="drawer-content flex flex-col items-center justify-center">
            <Routes>
              <Route path="/" element={<Home />} />
              <Route path="/admin" element={<Reviews setToken={setToken} />} />
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
                <Link to="/" onClick={toggleDrawer}>
                  Home
                </Link>
                <Link to="/admin" onClick={toggleDrawer}>
                  Reviews
                </Link>
              </li>
            </ul>
          </div>
        </div>
      </BrowserRouter>
    </div>
  );
}

export default App;
