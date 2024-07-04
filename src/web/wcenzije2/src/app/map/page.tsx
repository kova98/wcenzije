'use client';

import React, { useEffect, useState, useCallback, useMemo } from 'react';
import { GoogleMap, LoadScript, Marker } from '@react-google-maps/api';
import axios from 'axios';
import { mapStyles } from '@/app/map/map-styles';
import { Review } from '@/lib/models';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Check, Star, StarHalf, X } from 'lucide-react';
import { date } from '@/lib/utils';
import Image from 'next/image';
import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from '@/components/ui/carousel';
import { Badge } from '@/components/ui/badge';

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
    zoomControl: true,
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

  function getRatingStars(rating: number) {
    const stars = [];
    const fullStars = Math.floor(rating / 2);
    const halfStars = rating % 2;
    const size = 32;

    for (let i = 0; i < fullStars; i++) {
      stars.push(
        <Star key={`full-${i}`} fill="black" strokeWidth={0} size={size} />,
      );
    }

    if (halfStars) {
      stars.push(
        <StarHalf key="half" fill="black" strokeWidth={0} size={size} />,
      );
    }

    return stars;
  }

  return (
    <div className="flex h-screen w-screen flex-row gap-8 p-8">
      {selectedReview && (
        <Card className="h-auto w-1/3 overflow-y-auto">
          <CardHeader className="flex flex-col text-center">
            <CardTitle className="gap-2 text-3xl">
              {selectedReview.name}
            </CardTitle>
            <div className={'flex flex-row justify-center py-2'}>
              {...getRatingStars(selectedReview.rating)}
            </div>
            <CardDescription>
              {selectedReview.author}
              <br />
              {date(selectedReview.dateCreated)}
            </CardDescription>
          </CardHeader>

          <CardContent className="flex flex-col p-6 text-sm">
            <ul className="grid gap-3">
              <li className="flex items-center justify-between">
                <span>
                  {selectedReview.qualities.hasPaperTowels ? 'Ima' : 'Nema'}{' '}
                  papira za ruke
                </span>
                {selectedReview.qualities.hasPaperTowels ? <Check /> : <X />}
              </li>
              <li className="flex items-center justify-between">
                <span>
                  {selectedReview.qualities.hasToiletPaper ? 'Ima' : 'Nema'} WC
                  papira
                </span>
                {selectedReview.qualities.hasToiletPaper ? <Check /> : <X />}
              </li>
              <li className="flex items-center justify-between">
                <span>
                  {selectedReview.qualities.hasSoap ? 'Ima' : 'Nema'} sapuna
                </span>
                {selectedReview.qualities.hasSoap ? <Check /> : <X />}
              </li>
              <li className="flex items-center justify-between">
                <span>
                  {selectedReview.qualities.isClean ? 'Čisto' : 'Prljavo'} je
                </span>
                {selectedReview.qualities.isClean ? <Check /> : <X />}
              </li>
            </ul>
            <div className={'mt-5 flex items-center justify-center'}>
              <Carousel className="aspect-square w-full">
                <CarouselContent>
                  {selectedReview.imageUrls.map((url, index) => (
                    <CarouselItem key={index}>
                      <div className="p-1">
                        <Card className="h-full w-full overflow-hidden">
                          <CardContent className="relative flex h-full w-full items-center justify-center p-0">
                            <Badge
                              className={
                                'absolute right-2 top-2 bg-black text-white'
                              }
                            >
                              {index + 1}/{selectedReview.imageUrls.length}
                            </Badge>
                            <Image
                              className="h-auto w-full"
                              src={url}
                              width={300}
                              height={300}
                              sizes="100vw"
                              alt={'Review image'}
                            />
                          </CardContent>
                        </Card>
                      </div>
                    </CarouselItem>
                  ))}
                </CarouselContent>
              </Carousel>
            </div>
          </CardContent>
        </Card>
      )}
      <Card className="h-1/2 w-2/3 flex-grow overflow-hidden">
        <LoadScript
          googleMapsApiKey={'AIzaSyA58YfseNMaYTIGom5PglCb73FqyQCn62Y'}
        >
          <GoogleMap
            mapContainerClassName="h-full w-full"
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
      </Card>
    </div>
  );
}
