import { wsGutter, wsScale } from './wsScale';

/**
 * The panels' sizes in rem - one source of truth shared by the CSS and the drag computations in JS.
 * The page's root uses a font-size relative to the screen's width, so we read the real rem value
 * at use time instead of fixing 16px (otherwise the panels drifted when the size/the resolution changed).
 */
export const PANEL_W_REM = 24;
export const CONTAINER_W_REM = 19;
export const DETAIL_W_REM = 16;
export const PANEL_GAP_REM = 0.75;

export function remPx(n = 1): number {
  const base = parseFloat(getComputedStyle(document.documentElement).fontSize);
  return n * (Number.isFinite(base) && base > 0 ? base : 16);
}

/* Saved panel positions (localStorage) are kept in design px from the left edge of the centred 16:9
   frame (ui-scale), so a panel dragged on one screen sits at the same place on any other resolution
   or ultrawide. Older saves (raw screen px, no `u`) are read as they are and only clamped. */
type Pos = { x: number; y: number };
export function savePanelPos(key: string, p: Pos) {
  const s = wsScale();
  try { localStorage.setItem(key, JSON.stringify({ x: (p.x - wsGutter()) / s, y: p.y / s, u: 'design' })); } catch {}
}
export function loadPanelPos(key: string): Pos | null {
  try {
    const raw = localStorage.getItem(key);
    if (!raw) return null;
    const p = JSON.parse(raw);
    if (typeof p.x !== 'number' || typeof p.y !== 'number') return null;
    if (p.u !== 'design') return { x: p.x, y: p.y };
    const s = wsScale();
    return { x: p.x * s + wsGutter(), y: p.y * s };
  } catch {}
  return null;
}
