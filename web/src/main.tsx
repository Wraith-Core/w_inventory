import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
import './index.scss';
import './global.css';
import { isEnvBrowser } from './utils/misc';

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
    'menu_bar', 'swatch_bg_1a', 'counter_bg_1a',
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
        // The interface elements that are not <button> but behave like one - so they give the crafting's own sound
        '.slot.filled,.hb-slot.hb-filled,#inv-close-btn,.inv-toolbar .tb-btn,#inventory .category,' +
        '#inventory-options .option,.split-btn,.split-adj,.trade-btn,.trade-req-btn,' +
        '#container-panel .cp-close,.trade-close,.trade-slot-filled'
      );
  };
  document.addEventListener('pointerover', (e) => { if (hit(e.target)) play('button.mp3', 0.20, true); }, true);
  document.addEventListener('pointerdown', (e) => { if (hit(e.target)) play('selected.mp3', 0.38); }, true);
})();

const root = document.getElementById('root');

if (isEnvBrowser()) {
  // a plain dark ground when the page is opened in a browser (no game behind it)
  root!.style.background = '#1a1a1a';
}

createRoot(root!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
