'use client';

import React, { useEffect, useState } from 'react';
import { GoogleMap, LoadScript, Marker } from '@react-google-maps/api';
import axios from 'axios';

interface Location {
  id: number;
  name: string;
  lat: number;
  lng: number;
}

export default function MapComponent() {
  const SERVER_URL = process.env.NEXT_PUBLIC_SERVER_ROOT_URL;
  const reviewMapEndpoint = `${SERVER_URL}/api/v2/review/map`;
  const [selectedLocation, setSelectedLocation] = useState<Location>();
  const [locations, setLocations] = useState<Location[]>([]);

  const defaultMapOptions: google.maps.MapOptions = {
    fullscreenControl: false,
    mapTypeControl: false,
    streetViewControl: false,
    zoomControl: false,
  };

  useEffect(() => {
    axios.get(reviewMapEndpoint).then((result) => {
      const locations = result.data.map((loc: any) => {
        const { lat, lng } = parseLocation(loc.location);
        return {
          id: loc.id,
          name: loc.name,
          lat,
          lng,
        };
      });

      setLocations(locations);
    });
  }, [reviewMapEndpoint]);

  function parseLocation(latlng: string) {
    const lat = parseFloat(latlng.split(',')[0]);
    const lng = parseFloat(latlng.split(',')[1]);
    return { lat, lng };
  }

  const customIcon: google.maps.Icon = {
    url: 'https://res.cloudinary.com/wcenzije/image/upload/v1720026324/marker.png',
    scaledSize: new google.maps.Size(20, 20),
  };

  return (
    <div className={'flex h-full w-1/2 flex-auto border-8'}>
      <LoadScript googleMapsApiKey="AIzaSyA58YfseNMaYTIGom5PglCb73FqyQCn62Y">
        <GoogleMap
          mapContainerStyle={{ height: '50vh', width: '100%' }}
          center={{ lat: 45.80970221014937, lng: 15.98264889832456 }}
          options={defaultMapOptions}
          zoom={12}
        >
          {locations.map((location) => (
            <Marker
              key={location.id}
              position={{ lat: location.lat, lng: location.lng }}
              onClick={() => setSelectedLocation(location)}
              icon={customIcon}
            />
          ))}
        </GoogleMap>
      </LoadScript>
    </div>
  );
}
