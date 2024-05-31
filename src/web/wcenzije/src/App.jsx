import { BrowserRouter, Route, Routes, Link } from "react-router-dom";
import { Home, Reviews, Admin, DeleteAccount } from "./pages";
import axios from "axios";

import "./App.css";
import useToken from "./components/useToken";
import NotFound from "./pages/NotFound";

function App() {
  const { token, setToken } = useToken();

  axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;

  const toggleDrawer = () => {
    document.getElementById("drawer-button").click();
  };

  return (
    <div className="h-full">
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/delete-account" element={<DeleteAccount />} />
          <Route
            path="/admin"
            element={<Admin setToken={setToken} token={token} />}
          >
            <Route
              path="/admin/reviews"
              element={<Reviews setToken={setToken} />}
            />
          </Route>
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </div>
  );
}

export default App;
