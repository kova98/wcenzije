import React from "react";
import GooglePlayBadge from "../components/GooglePlayBadge";
import AppStoreBadge from "../components/AppStoreBadge";
import deviceArt from "../images/device-art.png";

const Home = () => {
  const messages = [
    "Osjećaš se stisnuto dok stišćeš?",
    "(ni)jedan listić papira?",
    "Papir je pregrub za tvoju finu guzu?",
    "Rola je okrenuta na krivu stranu?",
    "Daska je prehladna? Pretopla?",
    "Vidljivi tragovi kočenja u školjci?",
    "Više curi iz pisoara nego iz tebe?",
    "Nit’ smrdi, nit’ miriše?",
    "Četka izgleda kao da je odribala svoje?",
    "Sapuna nema ni u tragovima?",
    "Želiš ostaviti recenziju za anale?",
  ];

  const getRandomMessage = () => {
    var index = Math.floor(Math.random() * messages.length);
    return messages[index];
  };

  const handleAppStoreClicked = () => {
    document.getElementById("app-store-modal").click();
  };

  return (
    <div>
      <label htmlFor="app-store-modal" className="hidden"></label>

      <input type="checkbox" id="app-store-modal" className="modal-toggle" />
      <label htmlFor="app-store-modal" className="modal cursor-pointer">
        <label className="modal-box relative" htmlFor="">
          <h3 className="text-lg font-bold">
            Nažalost, nema nas na App Storu! 😢
          </h3>
          <p className="py-4">
            Hvala ti na interesu, ali nažalost, za sad nas nema na App Storu.
            <span className="font-semibold">
              {" "}
              To se možda promijeni u budućnosti!
            </span>{" "}
            <span>Prati nas na </span>
            <a className="link" href="https://www.instagram.com/wcenzije/">
              Instagramu.
            </a>
          </p>
        </label>
      </label>
      <div className="hero min-h-screen bg-blue-600">
        <div className="hero-content flex-col md:flex-row gap-10 w-full text-center md:text-left">
          <div className="p-6 md:w-1/2">
            <div className="grid grid-cols-4 gap-4">
              <h1 className="text-white text-5xl font-bold col-span-4 pt-6 md:pt-0">
                {getRandomMessage()}
              </h1>
              <p className="text-blue-100 py-6 col-span-4 text-2xl">
                Reci to javno u WCenzije aplikaciji!
              </p>
              <div className="flex col-span-4 md:justify-start justify-center">
                <GooglePlayBadge />
                <div className="p-3"></div>
                <AppStoreBadge onClick={handleAppStoreClicked} />
              </div>
            </div>
          </div>
          <div className="md:w-1/4 max-w-sm">
            <img src={deviceArt} />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;
