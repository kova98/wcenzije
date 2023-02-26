import React from "react";

const AppStoreBadge = () => {
  return (
    <a className="hover:cursor-pointer">
      <img
        style={{ height: 53 }}
        src="https://apple-resources.s3.amazonaws.com/media-badges/download-on-the-app-store/black/en-us.svg"
        alt="Download on the App Store"
      />
    </a>
  );
};

export default AppStoreBadge;
