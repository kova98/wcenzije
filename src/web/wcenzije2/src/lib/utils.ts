import { type ClassValue, clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const dateTime = (date: string) => {
  return new Date(date).toLocaleString();
};

export const date = (date: string) => {
  return new Date(date).toLocaleDateString();
};
