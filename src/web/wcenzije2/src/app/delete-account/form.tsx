import axios from 'axios';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import useToken from '@/lib/useToken';
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';
import { Button } from '@/components/ui/button';

export default function DeleteAccountForm() {
  const SERVER_URL = process.env.NEXT_PUBLIC_SERVER_ROOT_URL;
  const deleteAccountEndpoint = `${SERVER_URL}/api/auth/account`;
  const { getToken, removeToken } = useToken();
  const router = useRouter();
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');
  const [isLoaded, setIsLoaded] = useState(false);
  const token = getToken();

  const deleteAccount = () => {
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };

    axios.delete(deleteAccountEndpoint, config).then(
      () => {
        setIsLoaded(true);
        removeToken();
        router.push('/');
      },
      (error) => {
        setIsLoaded(true);
        setError('Nešto se sjebalo');
      },
    );
  };

  return (
    <div className="flex h-screen flex-col items-center justify-center">
      <p className={'pb-5 text-xl'}>Žao nam je što odlaziš 😢</p>
      <AlertDialog>
        <AlertDialogTrigger asChild>
          <Button variant="destructive">Izbriši račun</Button>
        </AlertDialogTrigger>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Jesi li potpuno siguran/na?</AlertDialogTitle>
            <AlertDialogDescription>
              Od ovoga nema povratka. Tvoj račun i sve tvoje wcenzije bit će
              zauvijek izbrisane.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Ne, otkaži</AlertDialogCancel>
            <AlertDialogAction onClick={deleteAccount}>
              Da, Izbriši sve moje podatke
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
      {error && <p className={'pt-5 text-destructive'}>{error}</p>}
    </div>
  );
}
