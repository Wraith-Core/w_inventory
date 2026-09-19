import { useCallback, useRef } from 'react';

// The real RDR menu sounds (the same as w_crafting) instead of the stand-in tones.
// They are resolved through window.rsmAsset (an absolute path) so they are correct inside the game (nui://) and in the browser.
const asset = (p: string): string =>
  typeof window !== 'undefined' && typeof (window as any).rsmAsset === 'function'
    ? (window as any).rsmAsset(p)
    : p;

const FILE: Record<string, string> = {
  open: 'sounds/menu_open.mp3',
  close: 'sounds/menu_close.mp3',
  pickup: 'sounds/selected.mp3',
  drop: 'sounds/button.mp3',
  equip: 'sounds/coins.mp3',
  error: 'sounds/button.mp3',
};

const VOL: Record<string, number> = {
  open: 0.6, close: 0.55, pickup: 0.5, drop: 0.45, equip: 0.75, error: 0.5,
};

export default function useSound() {
  const poolRef = useRef<Record<string, HTMLAudioElement>>({});

  const play = useCallback((name: string) => {
    try {
      const file = FILE[name];
      if (!file) return;

      let audio = poolRef.current[name];
      if (!audio) {
        audio = new Audio(asset(file));
        audio.preload = 'auto';
        poolRef.current[name] = audio;
      }

      const node = audio.cloneNode(true) as HTMLAudioElement;
      node.volume = VOL[name] ?? 0.4;
      node.play().catch(() => {});
    } catch (_) {}
  }, []);

  return play;
}
