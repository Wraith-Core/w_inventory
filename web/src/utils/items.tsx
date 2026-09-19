import React from 'react';
import { tr } from '../i18n';
import { VORP_CURRENCY_ICONS } from '../vorpCurrencyIcons';

export function N(v: any): number {
  const n = parseFloat(v);
  return isNaN(n) ? 0 : n;
}

export function rarity(it: any): string {
  if (it?.metadata?.rarity) return it.metadata.rarity;
  const l = it?.limit;
  if (l !== undefined && l !== null) {
    if (l <= 0) return 'common';
    if (l <= 1) return 'legendary';
    if (l <= 3) return 'epic';
    if (l <= 5) return 'rare';
    if (l <= 15) return 'uncommon';
  }
  return 'common';
}

export function fmtWeight(grams: number): string {
  const kg = (Number(grams) || 0) / 1000;
  return `${kg.toFixed(2)} ${tr('ui_weight_unit', 'kg')}`;
}

export function fmtType(t: string | undefined): string {
  if (!t) return tr('ui_type_misc', 'Miscellaneous');
  const map: Record<string, [string, string]> = {
    item_weapon: ['ui_type_weapon', 'Weapon'],
    item_ammo: ['ui_type_ammo', 'Ammo'],
    item_food: ['ui_type_food', 'Food'],
    item_misc: ['ui_type_misc', 'Miscellaneous'],
    item_collectables: ['ui_type_collectables', 'Collectables'],
  };
  const translated = map[t];
  return translated ? tr(translated[0], translated[1]) : t
    .replace('type_', '')
    .replace('item_', '')
    .replace(/_/g, ' ');
}

export function categoryName(id: string): string {
  if (id === 'all') return tr('ui_category_all', 'All');
  return fmtType(id);
}

export function normalizeItem(it: any): any {
  return {
    ...it,
    weight: N(it.weight),
    count: N(it.count) || 1,
    limit: N(it.limit),
  };
}

export const CATEGORIES = [
  { id: 'all', icon: <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87L18.18 22 12 18.27 5.82 22 7 14.14 2 9.27l6.91-1.01z"/></svg> },
  { id: 'item_ammo', icon: <svg viewBox="0 0 24 24" fill="currentColor"><path d="M7 5h2V3H7v2zm0 8h2v-2H7v2zm0 8h2v-2H7v2zm4-4h2v-2h-2v2zm0 4h2v-2h-2v2zm-8 0h2v-2H3v2zm0-4h2v-2H3v2zm0-4h2v-2H3v2zm0-4h2V7H3v2zm0-4h2V3H3v2zm8 8h2v-2h-2v2zm8-8h2V3h-2v2zm0 4h2V7h-2v2zm-4-4h2V3h-2v2zm4 12h2v-2h-2v2zm-4 4h2v-2h-2v2zm0-8h2v-2h-2v2zm4 4h2v-2h-2v2zm0-4h2v-2h-2v2z"/></svg> },
  { id: 'item_food', icon: <svg viewBox="0 0 24 24" fill="currentColor"><path d="M18.06 23h1.66c.84 0 1.53-.65 1.63-1.47L23 7h-5V1h-2v6h-5l1.65 14.53c.1.82.79 1.47 1.63 1.47h1.78zM1 22c0 .55.45 1 1 1h8c.55 0 1-.45 1-1V3H1v19z"/></svg> },
  { id: 'item_misc', icon: <svg viewBox="0 0 24 24" fill="currentColor"><path d="M22 9V7h-2V5c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2v-2h2v-2h-2v-2h2v-2h-2V9h2zm-4 10H4V5h14v14zM6 13h5v4H6v-4zm6-6h4v3h-4V7zM6 7h5v5H6V7zm6 4h4v6h-4v-6z"/></svg> },
  { id: 'item_collectables', icon: <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19 3H5L2 9l10 12L22 9l-3-6zM9.62 8l1.5-3h1.76l1.5 3H9.62z"/></svg> },
  { id: 'item_weapon', icon: <svg viewBox="0 0 24 24" fill="currentColor"><path d="M7.5 4C5.57 4 4 5.57 4 7.5S5.57 11 7.5 11 11 9.43 11 7.5 9.43 4 7.5 4zM18 2l-4 4h-2l-1.7 1.7A5.47 5.47 0 007.5 3C4.46 3 2 5.46 2 8.5S4.46 14 7.5 14c1.55 0 2.95-.64 3.95-1.68L22 2h-4z"/></svg> },
];

export const SVG_BAG = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 13v6a2 2 0 002 2h14a2 2 0 002-2v-6H3zm8 4H7v-2h4v2zm6 0h-4v-2h4v2z"/><path d="M21 11V7a2 2 0 00-2-2h-3V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v1H5a2 2 0 00-2 2v4h18zM10 4h4v1h-4V4z" opacity=".7"/></svg>;

/** A saddle bag (a satchel) in the RDR2 character - for the large badge in the bag's header. */
export const SVG_SATCHEL = (
  <svg viewBox="0 0 24 24" fill="currentColor">
    {/* The strap over the flap */}
    <path d="M8.9 6.4V5.3A2.3 2.3 0 0 1 11.2 3h1.6a2.3 2.3 0 0 1 2.3 2.3v1.1h-1.8V5.4a.6.6 0 0 0-.6-.6h-1.4a.6.6 0 0 0-.6.6v1h-1.8z" opacity=".8" />
    {/* The bag's body */}
    <path d="M4.5 11.9h15l-.5 5.9A2.7 2.7 0 0 1 16.3 21H7.7a2.7 2.7 0 0 1-2.7-3.2l-.5-5.9z" opacity=".45" />
    {/* The wide flap */}
    <path d="M5.6 6.4h12.8a1.7 1.7 0 0 1 1.69 1.86l-.2 2.2a1.1 1.1 0 0 1-1.1 1H5.21a1.1 1.1 0 0 1-1.1-1l-.2-2.2A1.7 1.7 0 0 1 5.6 6.4z" />
    {/* The buckle's tongue - small, hanging from the flap's edge */}
    <path d="M10.75 10.9h2.5c.36 0 .65.29.65.65v1.6c0 .36-.29.65-.65.65h-2.5a.65.65 0 0 1-.65-.65v-1.6c0-.36.29-.65.65-.65z" />
  </svg>
);
export const SVG_X = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>;

/**
 * Cash and gold use VORP Core's own currency artwork, the same images w_hud
 * shows, so both interfaces read as one system instead of two styles.
 *
 * Shipped as data URIs (web/src/vorpCurrencyIcons.ts, copied from w_hud) so the
 * inventory stays self-contained and does not depend on vorp_core's files being
 * present or on a particular resource name.
 *
 * The export names stay SVG_* on purpose: both call sites keep working
 * unchanged. They are images now, so CSS `color` no longer tints them — the
 * artwork carries its own colours.
 */
export const SVG_CASH = (
  <img src={VORP_CURRENCY_ICONS.money} alt="" draggable={false} />
);

export const SVG_GOLD = (
  <img src={VORP_CURRENCY_ICONS.gold} alt="" draggable={false} />
);
export const SVG_EYE = <svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>;

export const COLS = 5;
export const MIN_ROWS = 4;
