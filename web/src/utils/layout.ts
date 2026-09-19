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
