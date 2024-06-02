import Image from 'next/image';
import deviceArt from '../../public/device-art.png';
import GooglePlayBadge from '@/components/GooglePlayBadge';
import AppStoreBadge from '@/components/AppStoreBadge';
import localFont from 'next/font/local';
const gotham = localFont({ src: './gothamrnd_bold.otf' });

const messages = [
  'Osjećaš se stisnuto dok stišćeš?',
  '(ni)jedan listić papira?',
  'Papir je pregrub za tvoju finu guzu?',
  'Rola je okrenuta na krivu stranu?',
  'Daska je prehladna? Pretopla?',
  'Vidljivi tragovi kočenja u školjci?',
  'Više curi iz pisoara nego iz tebe?',
  'Nit’ smrdi, nit’ miriše?',
  'Četka izgleda kao da je odribala svoje?',
  'Sapuna nema ni u tragovima?',
  'Želiš ostaviti recenziju za anale?',
];

const getRandomMessage = () => {
  var index = Math.floor(Math.random() * messages.length);
  return messages[index];
};

export default function Hero() {
  return (
    <div
      className={`flex min-h-screen items-center justify-center bg-[#2196F3] text-white ${gotham.className}`}
    >
      <div className="flex flex-col items-center justify-center gap-10 text-center md:flex-row md:text-left">
        <div className="flex max-w-lg flex-col items-center px-5 md:items-start md:px-0">
          <h1 className="pt-20 text-6xl font-extrabold md:pt-0">
            {getRandomMessage()}
          </h1>
          <p className="px-10 py-12 text-2xl text-blue-50 md:px-0">
            Reci to javno u WCenzije aplikaciji!
          </p>
          <div className="flex gap-6">
            <GooglePlayBadge />
            <AppStoreBadge onClick={null} />
          </div>
        </div>
        <div className="max-w-sm md:w-1/3">
          <Image
            src={deviceArt}
            alt="Picture of the app on a device"
            objectFit="contain"
          />
        </div>
      </div>
    </div>
  );
}
