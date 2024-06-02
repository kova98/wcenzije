'use client';
import React from 'react';

const AppStoreBadge = ({ onClick }) => {
  return (
    <button className="hover:cursor-pointer" onClick={onClick}>
      <img
        style={{ height: 53 }}
        src="https://apple-resources.s3.amazonaws.com/media-badges/download-on-the-app-store/black/en-us.svg"
        alt="Download on the App Store"
      />
    </button>
  );
};

export default AppStoreBadge;
