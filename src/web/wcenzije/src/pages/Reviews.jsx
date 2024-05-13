import axios from "axios";
import React, { useEffect, useState } from "react";
import { format } from "date-fns";

const Reviews = ({ setToken }) => {
  const SERVER_URL = import.meta.env.VITE_SERVER_ROOT_URL;
  const endpoint = `${SERVER_URL}/api/admin`;

  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [items, setItems] = useState([]);

  useEffect(() => {
    axios.get(endpoint + "/review").then(
      (result) => {
        setIsLoaded(true);
        setItems(result.data);
      },
      (error) => {
        if (error.response.status === 401) {
          setToken(null);
        }
        setIsLoaded(true);
        setError(error);
      },
    );
  }, []);

  return (
    <div className="overflow-x-auto w-full">
      <table className="table w-full">
        <thead>
          <tr>
            <th>Info</th>
          </tr>
        </thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id}>
              <th>
                <div className="flex items-center space-x-3">
                  <div className="avatar">
                    <div className="rounded-md w-12 h-12">
                      <img src={item.imageUrls[0]} />
                    </div>
                  </div>
                  <div>
                    <div className="font-bold">{item.name}</div>
                    <div className="text-sm opacity-50">{item.author}</div>
                    <div className="text-sm opacity-50">
                      {format(new Date(item.dateCreated), "dd.MM.yyyy. hh:ss")}
                    </div>
                    <div className="rating rating-xs rating-half">
                      {[...Array(item.rating)].map((_, i) =>
                        i % 2 == 0 ? (
                          <input
                            key={"input" + i}
                            disabled
                            type="radio"
                            name="rating-10"
                            className="bg-yellow-500 mask mask-star-2 mask-half-1"
                          />
                        ) : (
                          <input
                            key={"input" + i}
                            disabled
                            type="radio"
                            name="rating-10"
                            className="bg-yellow-500 mask mask-star-2 mask-half-2"
                          />
                        ),
                      )}
                    </div>
                  </div>
                </div>
              </th>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Reviews;
