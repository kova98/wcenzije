import axios from "axios";
import React, { useState } from "react";

const Login = ({ setToken }) => {
  const SERVER_URL = import.meta.env.VITE_SERVER_ROOT_URL;
  const endpoint = `${SERVER_URL}/api/auth/login`;

  const [username, setUsername] = useState();
  const [password, setPassword] = useState();
  const [error, setError] = useState();

  async function handleLogin(e) {
    e.preventDefault();
    axios
      .post(endpoint, { username, password })
      .then(function (response) {
        setToken(response.data.token);
        setError(null);
      })
      .catch(function (error) {
        if (error.response.status === 400) {
          setError("Ime ili lozinka su pogrešni.");
        } else {
          setError("Došlo je do greške.");
        }
      });
  }

  return (
    <div className="hero min-h-screen bg-base-200">
      <div className="hero-content flex-col lg:flex-row-reverse">
        <div className="text-center lg:text-left md:ml-5">
          <h1 className="text-5xl font-bold">Prijavi se za nastavak</h1>
          <p className="py-6">
            Nemaš račun?{" "}
            <a href="#" className="link font-semibold">
              Registriraj se
            </a>
          </p>
        </div>
        <div className="card flex-shrink-0 w-full max-w-sm shadow-2xl bg-base-100">
          <div className="card-body">
            <form onSubmit={handleLogin}>
              <div className="form-control">
                <label className="label">
                  <span className="label-text">Ime</span>
                </label>
                <input
                  required
                  onChange={(e) => setUsername(e.target.value)}
                  type="text"
                  placeholder="ime"
                  className="input input-bordered"
                />
              </div>
              <div className="form-control">
                <label className="label">
                  <span className="label-text">Lozinka</span>
                </label>
                <input
                  required
                  onChange={(e) => setPassword(e.target.value)}
                  type="password"
                  placeholder="lozinka"
                  className="input input-bordered password peer"
                />
                <label className="label">
                  <a href="#" className="label-text-alt link link-hover">
                    Zaboravio si lozinku?
                  </a>
                </label>
              </div>
              <p className="text-error">{error}</p>
              <div className="form-control mt-6">
                <button
                  type="submit"
                  onClick={handleLogin}
                  className="btn btn-primary"
                >
                  Prijava
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Login;
