'use client';

import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import axios from 'axios';
import { Button } from '@/components/ui/button';
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { useState, Suspense } from 'react';
import useToken from '@/lib/useToken';
import { useSearchParams } from 'next/navigation';
import { useRouter } from 'next/navigation';

function ProfileFormComponent() {
  const SERVER_URL = process.env.NEXT_PUBLIC_SERVER_ROOT_URL;
  const endpoint = `${SERVER_URL}/api/auth/login`;
  const { setToken } = useToken();
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const searchParams = useSearchParams();
  const redirectUrl = searchParams?.get('redirect');
  const router = useRouter();

  const formSchema = z.object({
    username: z.string().min(1, {
      message: 'Molim te upiši ime.',
    }),
    password: z.string().min(1, {
      message: 'Molim te upiši lozinku.',
    }),
  });

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      username: '',
      password: '',
    },
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    setError(null);
    setLoading(true);
    axios
      .post(endpoint, { username: values.username, password: values.password })
      .then(function (response) {
        setToken(response.data.token);
        setError(null);
        setLoading(false);
        if (redirectUrl) {
          router.push(redirectUrl);
        }
      })
      .catch(function (error) {
        if (error.response?.status === 401) {
          setError('Ime ili lozinka su pogrešni.');
        } else {
          console.log(error);
          setError('Došlo je do greške.');
        }
        setLoading(false);
      });
  }

  return (
    <div className="flex min-h-screen items-center justify-center">
      <Card className="w-[350px]">
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)}>
            <CardHeader>
              <CardTitle>Prijava</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid w-full items-center">
                <div className="flex flex-col">
                  <FormField
                    control={form.control}
                    name="username"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Ime</FormLabel>
                        <FormControl>
                          <Input {...field} />
                        </FormControl>
                        <FormMessage />
                      </FormItem>
                    )}
                  />
                </div>
                <div className="flex flex-col">
                  <FormField
                    control={form.control}
                    name="password"
                    render={({ field }) => (
                      <FormItem>
                        <FormLabel>Lozinka</FormLabel>
                        <FormControl>
                          <Input {...field} type="password" />
                        </FormControl>
                        <FormMessage>{error}</FormMessage>
                      </FormItem>
                    )}
                  />
                </div>
              </div>
            </CardContent>
            <CardFooter className="justify-end">
              <Button disabled={loading} type="submit" className="w-full">
                Submit
              </Button>
            </CardFooter>
          </form>
        </Form>
      </Card>
    </div>
  );
}

export default function ProfileForm() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <ProfileFormComponent />
    </Suspense>
  );
}
