export type ItemData = {
  name: string;
  label: string;
  stack: boolean;
  usable: boolean;
  close: boolean;
  count: number;
  description?: string;
  buttons?: Array<string | { label: string; group?: string }>;
  ammoName?: string;
  image?: string;
  rarity?: 'common' | 'rare' | 'epic' | 'legendary';
  category?: string;
  weapon?: boolean;
};
