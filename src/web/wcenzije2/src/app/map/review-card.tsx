import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { date } from '@/lib/utils';
import { Check, Star, StarHalf, X } from 'lucide-react';
import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from '@/components/ui/carousel';
import { Badge } from '@/components/ui/badge';
import Image from 'next/image';
import React from 'react';
import { Gender, Review } from '@/lib/models';
import { Separator } from '@/components/ui/separator';

export default function ReviewCard({
  selectedReview,
}: {
  selectedReview: Review;
}) {
  function genderToString(gender: Gender) {
    switch (gender) {
      case Gender.Female:
        return 'ženski wc';
      case Gender.Male:
        return 'muški wc';
      case Gender.Unisex:
        return 'unisex wc';
    }
  }

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
    <Card className="h-auto w-1/3 overflow-y-auto">
      <CardHeader className="flex flex-col text-center">
        <CardTitle className="gap-2 text-3xl">{selectedReview.name}</CardTitle>
        <div className={'flex flex-row justify-center py-2'}>
          {...getRatingStars(selectedReview.rating)}
        </div>
        <CardDescription>
          <span className={'font-semibold text-black'}>
            {selectedReview.author}
          </span>

          <br />
          {genderToString(selectedReview.gender)}
          <br />
          {date(selectedReview.dateCreated)}
        </CardDescription>
      </CardHeader>

      <CardContent className="flex flex-col p-6">
        <div className="pb-2 font-semibold">Kvalitete</div>
        <ul className="grid gap-3 text-sm text-muted-foreground">
          <li className="flex items-center justify-between gap-3">
            <span>
              {selectedReview.qualities.hasPaperTowels ? 'Ima' : 'Nema'} papira
              za ruke
            </span>
            {selectedReview.qualities.hasPaperTowels ? <Check /> : <X />}
          </li>
          <li className="flex items-center justify-between gap-3">
            <span>
              {selectedReview.qualities.hasToiletPaper ? 'Ima' : 'Nema'} WC
              papira
            </span>
            {selectedReview.qualities.hasToiletPaper ? <Check /> : <X />}
          </li>
          <li className="flex items-center justify-between gap-3">
            <span>
              {selectedReview.qualities.hasSoap ? 'Ima' : 'Nema'} sapuna
            </span>
            {selectedReview.qualities.hasSoap ? <Check /> : <X />}
          </li>
          <li className="flex items-center justify-between gap-3">
            <span>
              {selectedReview.qualities.isClean ? 'Čisto' : 'Prljavo'} je
            </span>
            {selectedReview.qualities.isClean ? <Check /> : <X />}
          </li>
        </ul>
        <Separator className={'my-5'} />
        <div className="pb-2 font-semibold">Osvrt</div>
        <p className={'text-muted-foreground'}>{selectedReview.content}</p>
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
  );
}
