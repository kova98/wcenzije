'use client';

import React from 'react';
import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/dialog';
import Image from 'next/image';
import Link from 'next/link';
import posthog from 'posthog-js';

const AppStoreBadge = () => {
  function badgeClicked() {
    posthog.capture('app_store_badge_clicked');
  }

  function buttonClicked() {
    posthog.capture('app_store_badge_instagram_clicked');
  }

  return (
    <Dialog>
      <DialogTrigger asChild>
        <button className="hover:cursor-pointer" onClick={badgeClicked}>
          <Image
            width={160}
            height={53}
            src="https://apple-resources.s3.amazonaws.com/media-badges/download-on-the-app-store/black/en-us.svg"
            alt="Download on the App Store"
          />
        </button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Nema nas na App Storu 😢</DialogTitle>
          <DialogDescription>
            <br />

            <p>Nažalost, za sad nas nema na App Storu.</p>
            <p>To se možda promijeni u budućnosti!</p>
          </DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <Button asChild>
            <Link
              href="https://www.instagram.com/wcenzije/"
              target="_blank"
              onClick={buttonClicked}
            >
              Prati nas na Instagramu
            </Link>
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};

export default AppStoreBadge;
