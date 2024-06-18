export interface Review {
  id: number;
  dateCreated: string;
  dateUpdated: string;
  imageUrls: string[];
  content: string;
  name: string;
  location: string;
  author?: string;
  isAnonymous: boolean;
  likeCount: number;
  rating: number;
  qualities: Qualities;
  gender: Gender;
}

export interface Qualities {
  hasSoap: boolean;
  hasToiletPaper: boolean;
  hasPaperTowels: boolean;
  isClean: boolean;
}

export enum Gender {
  Unisex = 0,
  Male = 1,
  Female = 2,
}
