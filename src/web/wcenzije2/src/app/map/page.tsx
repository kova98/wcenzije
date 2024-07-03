'use client';

import React, { useEffect, useState, useCallback, useMemo } from 'react';
import { GoogleMap, LoadScript, Marker } from '@react-google-maps/api';
import axios from 'axios';
import { mapStyles } from '@/app/map/map-styles';
import { Review } from '@/lib/models';

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
  const [selectedReview, setSelectedReview] = useState<Review>();
  const [locations, setLocations] = useState<Location[]>([]);
  const [customIcon, setCustomIcon] = useState<google.maps.Icon>();

  const defaultMapOptions: google.maps.MapOptions = {
    fullscreenControl: false,
    mapTypeControl: false,
    streetViewControl: false,
    zoomControl: false,
    styles: mapStyles,
  };

  const mapCenter = useMemo(
    () => ({ lat: 45.80970221014937, lng: 15.98264889832456 }),
    [],
  );

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

  useEffect(() => {
    if (selectedLocation) {
      axios
        .get(`${SERVER_URL}/api/review/${selectedLocation.id}`)
        .then((result) => {
          setSelectedReview(result.data);
        });
    }
  }, [selectedLocation]);

  const parseLocation = (latlng: string) => {
    const [lat, lng] = latlng.split(',').map(parseFloat);
    return { lat, lng };
  };

  const onLoad = useCallback(() => {
    const icon: google.maps.Icon = {
      url: 'https://res.cloudinary.com/wcenzije/image/upload/v1720026324/marker.png',
      scaledSize: new window.google.maps.Size(20, 20),
    };
    setCustomIcon(icon);
  }, []);

  const handleMarkerClick = useCallback((location: Location) => {
    setSelectedLocation(location);
  }, []);

  return (
    <div className={'flex flex-row'}>
      <div className={'h-full w-1/2 border-8'}>
        <LoadScript
          googleMapsApiKey={'AIzaSyA58YfseNMaYTIGom5PglCb73FqyQCn62Y'}
        >
          <GoogleMap
            mapContainerStyle={{ height: '50vh', width: '100%' }}
            center={mapCenter}
            options={defaultMapOptions}
            zoom={12}
            onLoad={onLoad}
          >
            {customIcon &&
              locations.map((location) => (
                <Marker
                  key={location.id}
                  position={{ lat: location.lat, lng: location.lng }}
                  onClick={() => handleMarkerClick(location)}
                  icon={customIcon}
                />
              ))}
          </GoogleMap>
        </LoadScript>
      </div>
      {selectedReview && (
        <div className={'h-full w-1/2 border-8'}>
          <div className={'flex flex-col'}>
            <h2 className={'text-2xl font-bold'}>{selectedReview.name}</h2>
            <div className={'flex flex-col'}>
              <h2 className={'text-xl'}>{selectedReview.name}</h2>
              <p>{selectedReview.author}</p>
              <p>{selectedReview.rating}</p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
