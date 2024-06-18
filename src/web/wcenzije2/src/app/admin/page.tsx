'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import useToken from '@/lib/useToken';
import ReviewsTable from '@/app/admin/reviews';

export default function Admin() {
  const { getToken } = useToken();
  const router = useRouter();

  useEffect(() => {
    const token = getToken();
    if (!token) {
      router.push('/login?redirect=/admin');
    }
  });

  return <ReviewsTable></ReviewsTable>;
}
