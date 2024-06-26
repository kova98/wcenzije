'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import useToken from '@/lib/useToken';
import DeleteAccountForm from '@/app/delete-account/form';

export default function DeleteAccount() {
  const { getToken } = useToken();
  const router = useRouter();

  useEffect(() => {
    const token = getToken();
    if (!token) {
      router.push('/login?redirect=/delete-account');
    }
  });

  return <DeleteAccountForm />;
}
