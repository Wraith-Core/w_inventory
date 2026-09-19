import { ItemData } from '../typings/item';

export const Items: {
  [key: string]: ItemData | undefined;
} = {
  iron: {
    name: 'iron',
    close: false,
    label: 'Iron',
    stack: true,
    usable: false,
    count: 1,
    rarity: 'common',
    image: 'iron.png'
  },
  handsaw: {
    name: 'handsaw',
    close: false,
    label: 'Hand Saw',
    stack: false,
    usable: true,
    count: 1,
    rarity: 'epic',
    image: 'hammerslate.png'
  },
  copper: {
    name: 'copper',
    close: false,
    label: 'Copper',
    stack: true,
    usable: false,
    count: 1,
    rarity: 'rare',
    image: 'copper.png'
  },
  water: {
    name: 'water',
    close: false,
    label: 'Water',
    stack: true,
    usable: true,
    count: 1,
    rarity: 'common',
    image: 'water.png'
  },
  sandwich: {
    name: 'sandwich',
    close: false,
    label: 'Sandwich',
    stack: true,
    usable: true,
    count: 1,
    rarity: 'epic',
    image: 'consumable_bread_roll.png'
  },
  bread: {
    name: 'bread',
    close: false,
    label: 'Bread',
    stack: true,
    usable: true,
    count: 1,
    rarity: 'common',
    image: 'bread.png'
  },
  silver_ring: {
    name: 'silver_ring',
    close: false,
    label: 'Silver Ring',
    stack: true,
    usable: false,
    count: 1,
    rarity: 'rare',
    image: 'silver.png'
  },
  gold_bar: {
    name: 'gold_bar',
    close: false,
    label: 'Gold Bar',
    stack: true,
    usable: false,
    count: 1,
    rarity: 'epic',
    image: 'gold_bar.png'
  },
  diamond: {
    name: 'diamond',
    close: false,
    label: 'Diamond',
    stack: true,
    usable: false,
    count: 1,
    rarity: 'legendary',
    image: 'diamond.png'
  },
  ruby: {
    name: 'ruby',
    close: false,
    label: 'Ruby',
    stack: true,
    usable: false,
    count: 1,
    rarity: 'legendary',
    image: 'money.png'
  },
};
