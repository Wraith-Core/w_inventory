import { RefObject, useLayoutEffect, useState } from 'react';

/** Fit a saved position to the current viewport without changing the saved preference. */
export default function usePanelPosition(ref: RefObject<HTMLDivElement>, preferred: { x:number; y:number } | null | undefined, active:boolean, extraWidth = 0) {
  const [size, setSize] = useState({ width:0, height:0, screenW:window.innerWidth, screenH:window.innerHeight });
  useLayoutEffect(() => {
    const element = ref.current;
    if (!active || !element) return;
    const measure = () => {
      const next = { width:element.offsetWidth, height:element.offsetHeight, screenW:window.innerWidth, screenH:window.innerHeight };
      setSize(old => Object.keys(next).every(key => old[key as keyof typeof old] === next[key as keyof typeof next]) ? old : next);
    };
    measure();
    const observer = new ResizeObserver(measure);
    observer.observe(element);
    window.addEventListener('resize', measure);
    return () => { observer.disconnect(); window.removeEventListener('resize', measure); };
  }, [active, ref]);
  if (!preferred) return null;
  return {
    x:Math.max(8, Math.min(preferred.x, size.screenW - size.width - extraWidth - 8)),
    y:Math.max(8, Math.min(preferred.y, size.screenH - size.height - 8)),
  };
}
