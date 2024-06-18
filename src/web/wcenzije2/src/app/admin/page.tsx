'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import useToken from '@/lib/useToken';

export default function Admin() {
  const { getToken } = useToken();
  const router = useRouter();

  useEffect(() => {
    const token = getToken();
    if (!token) {
      router.push('/login?redirect=/admin');
    }
  });

  return <div>Admin</div>;
}
