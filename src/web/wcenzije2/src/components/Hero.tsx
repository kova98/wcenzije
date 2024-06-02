import { Button } from '@/components/ui/button';
import Image from 'next/image';
import deviceArt from '../../public/device-art.png';
import GooglePlayBadge from '@/components/GooglePlayBadge';
import AppStoreBadge from '@/components/AppStoreBadge';

export default function Hero() {
  return (
    <div className="font-gotham flex min-h-screen items-center justify-center bg-[#2196F3] text-white">
      <div className="flex flex-col items-center justify-center gap-10 text-center md:flex-row md:text-left">
        <div className="flex max-w-md flex-col items-center md:items-start">
          <h1 className="text-6xl font-extrabold">
            Tragovi kočenja u školjci?
          </h1>
          <p className="col-span-4 py-6 text-2xl text-blue-50">
            Reci to javno u WCenzije aplikaciji!
          </p>
          <div className="mt-4 flex gap-6">
            <GooglePlayBadge />
            <AppStoreBadge onClick={null} />
          </div>
        </div>
        <div className="max-w-sm md:w-1/2">
          <Image
            src={deviceArt}
            alt="Picture of the app on a device"
            width={300}
            height={300}
            objectFit="contain"
          />
        </div>
      </div>
    </div>
  );
}
