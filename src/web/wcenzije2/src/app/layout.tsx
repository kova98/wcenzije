import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { Toaster } from '@/components/ui/toaster';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'WCenzije',
  description: 'Napiši WCenziju i vidi što drugi misle',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <head>
        <meta charSet="UTF-8" />
        <link
          rel="icon"
          type="image/png"
          sizes="32x32"
          href="/src/app/favicon.ico"
        />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>WCenzije</title>
      </head>
      <body className={inter.className}>
        <main>{children}</main>
        <Toaster />
      </body>
    </html>
  );
}
