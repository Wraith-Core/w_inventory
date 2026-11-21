import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
// The board kit first (a verbatim copy of w_train's), then the shop parts shared with w_store / w_marketplace
// (shop-kit.css, a byte-identical copy), then the bag's own layout and skin; the later sheet wins the ties.
import './kit.css';
import './shop-kit.css';
import './index.scss';
import './global.css';
import './skin.css';
import { isEnvBrowser } from './utils/misc';

/* The kit's faces and textures, injected from here like w_crafting does: their path must be relative to the build
   page (nui://w_inventory/web/build/), and Vite writes absolute CSS paths that break under nui://.
     EB Garamond    Latin text, titles, labels   (SIL OFL 1.1)
     Lalezar        every Arabic face            (SIL OFL 1.1) -- one Arabic face server-wide (owner, 2026-10-22)
     RDR Lino       the wordmark
     RDR Catalogue  the big figures (money)
   The torn edge, the grain and the selection band are the game's own art (copies of w_train's). */
try {
  const base = new URL('./', window.location.href).href;
  const FONTS = `${base}fonts/`;
  const AR = 'U+0600-06FF,U+0750-077F,U+0870-088E,U+0890-0891,U+0897-08E1,U+08E3-08FF,U+FB50-FDFF,U+FE70-FE74,U+FE76-FEFC,U+200C-200E,U+2010-2011,U+0660-0669';
  const style = document.createElement('style');
  style.textContent = `
    @font-face { font-family: "EB Garamond"; font-style: normal; font-weight: 400 800; src: url("${FONTS}EBGaramond-latin.woff2") format("woff2"); font-display: swap; }
    @font-face { font-family: "EB Garamond"; font-style: italic; font-weight: 400 800; src: url("${FONTS}EBGaramond-Italic-latin.woff2") format("woff2"); font-display: swap; }
    @font-face { font-family: "Amiri"; font-weight: 400; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "Amiri"; font-weight: 700; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "Lalezar"; font-weight: 100 900; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "RDR Lino"; font-weight: 100 900; src: url("${FONTS}RDRLino-Regular.woff2") format("woff2"); font-display: swap; }
    @font-face { font-family: "RDR Catalogue"; font-weight: 100 900; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); font-display: swap; }
    @font-face { font-family: "Noto Sans Arabic"; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); font-weight: 100 900; font-display: swap; }
    @font-face { font-family: "Tajawal"; font-weight: 400; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "Tajawal"; font-weight: 700; src: url("${FONTS}Lalezar-400-arabic.woff2") format("woff2"); unicode-range: ${AR}; font-display: swap; }
    @font-face { font-family: "EB Garamond"; font-style: normal; font-weight: 400 800; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
    @font-face { font-family: "EB Garamond"; font-style: italic; font-weight: 400 800; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
    @font-face { font-family: "Amiri"; font-weight: 400; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
    @font-face { font-family: "Amiri"; font-weight: 700; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
    @font-face { font-family: "Lalezar"; font-weight: 100 900; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
    @font-face { font-family: "RDR Lino"; font-weight: 100 900; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
    @font-face { font-family: "Noto Sans Arabic"; font-weight: 100 900; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
    @font-face { font-family: "Tajawal"; font-weight: 400; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
    @font-face { font-family: "Tajawal"; font-weight: 700; src: url("${FONTS}RDRCatalogueBold-Bold.woff2") format("woff2"); unicode-range: U+0030-0039; size-adjust: 118%; font-display: swap; }
  `;
  document.head.appendChild(style);
  const rs = document.documentElement.style;
  rs.setProperty('--tex-tear', `url("${base}tex/ui/tear.png")`);
  rs.setProperty('--tex-grain', `url("${base}tex/ui/grain.png")`);
  rs.setProperty('--tex-band', `url("${base}tex/ui/band.png")`);
  rs.setProperty('--tex-band-sm', `url("${base}tex/ui/band-sm.png")`);
} catch {
  /* a fallback face is enough: the page is not dropped for a font */
}

// ── The foundation of w_crafting's art: RDR2 textures as CSS variables with an absolute path (NUI-safe) ──
// A relative url() inside a CSS variable is drawn empty in CEF, so we emit an absolute path (BASE relative to baseURI).
(() => {
  const BASE = (import.meta as any).env?.BASE_URL || './';
  const ABS_BASE = new URL(BASE, document.baseURI).href;
  (window as any).rsmAsset = (p: string) => ABS_BASE + p;
  const tex = (p: string) => `url("${ABS_BASE}${p}")`;
  const rs = document.documentElement.style;
  const UI = [
    'crafting_highlight_t', 'crafting_highlight_b', 'crafting_highlight_l', 'crafting_highlight_r',
    'crafting_highlight_tl', 'crafting_highlight_tr', 'crafting_highlight_bl', 'crafting_highlight_br',
    'crafting_outline', 'divider_line', 'title_divider', 'vertical_divider_line',
    'list_item_h_line_narrow', 'menu_header_1a', 'selection_box_bg_1a', 'selection_box_bg_1c',
    'toast_bg', 'help_text_bg', 'lock', 'menu_icon_rank', 'star', 'rating_star', 'cross', 'tick',
    'selection_arrow_left', 'selection_arrow_right', 'weapon_stats_bar', 'weapon_stats_bar_mask',
    'menu_bar', 'swatch_bg_1a', 'counter_bg_1a', 'money_cash', 'money_gold',
  ];
  UI.forEach((n) => rs.setProperty(`--tex-${n}`, tex(`tex/ui/${n}.png`)));
})();

// ── w_crafting's sounds: hover/click on the buttons and the context menu's items and the filled slots ──
(() => {
  const asset = (p: string) => ((window as any).rsmAsset ? (window as any).rsmAsset(p) : p);
  const cache: Record<string, HTMLAudioElement> = {};
  let lastHover = 0;
  const play = (file: string, vol: number, throttle = false) => {
    if (throttle) {
      const now = typeof performance !== 'undefined' ? performance.now() : Date.now();
      if (now - lastHover < 70) return;
      lastHover = now;
    }
    try {
      let a = cache[file];
      if (!a) { a = new Audio(asset('sounds/' + file)); a.preload = 'auto'; cache[file] = a; }
      const node = a.cloneNode(true) as HTMLAudioElement;
      node.volume = vol;
      void node.play().catch(() => {});
    } catch { /* noop */ }
  };
  const hit = (el: EventTarget | null) => {
    const t = el as HTMLElement | null;
    return t && typeof t.closest === 'function' &&
      t.closest(
        'button,[role="button"],[role="menuitem"],[class*="menu" i] li,.context-menu-list li,' +
        // The interface elements that are not a <button> but behave like one - so they give the crafting's own sound
        '.slot.filled,.hb-slot.hb-filled,#inv-close-btn,.inv-toolbar .tb-btn,#inventory .category,' +
        '#inventory-options .option,.split-btn,.split-adj,.trade-btn,.trade-req-btn,' +
        '#container-panel .cp-close,.trade-close,.trade-slot-filled'
      );
  };
  document.addEventListener('pointerover', (e) => { if (hit(e.target)) play('button.mp3', 0.20, true); }, true);
  document.addEventListener('pointerdown', (e) => { if (hit(e.target)) play('selected.mp3', 0.38); }, true);
})();

const root = document.getElementById('root');


createRoot(root!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

