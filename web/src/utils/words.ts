import { tr, trf } from '../i18n';

/** Wrap a number (or any left-to-right run) in an isolate so it keeps its order inside an Arabic sentence. */
export function iso(value: string | number): string {
  return '⁨' + String(value) + '⁩';
}

/** Grams -> a short kilogram figure for sentences: 9.92 kg -> "9.9", 0.15 kg -> "0.15", 40 kg -> "40". */
export function kgShort(grams: number): string {
  const kg = (Number(grams) || 0) / 1000;
  const fixed = kg >= 10 ? kg.toFixed(0) : kg >= 1 ? kg.toFixed(1) : kg.toFixed(2);
  return String(parseFloat(fixed));
}

/** "12 items" with the Arabic counting forms (غرض واحد / غرضان / 3 أغراض / 12 غرضًا). */
export function itemsWord(n: number): string {
  if (n <= 0) return tr('ui_nb_items_0', 'empty');
  if (n === 1) return tr('ui_nb_items_1', '1 item');
  if (n === 2) return tr('ui_nb_items_2', '2 items');
  if (n <= 10) return trf('ui_nb_items_few', '%s items', iso(n));
  return trf('ui_nb_items_many', '%s items', iso(n));
}

/** Durability in words, on the same bands as the old colours (<=25 low, <=60 mid). */
export function durabilityWord(pct: number): string {
  if (pct <= 0) return tr('ui_nb_dur_broken', 'Broken');
  if (pct <= 25) return tr('ui_nb_dur_low', 'Nearly worn out');
  if (pct <= 60) return tr('ui_nb_dur_mid', 'Worn');
  return tr('ui_nb_dur_high', 'Good');
}

/** How full a weight load is, in words: '' while there is room, then near full / full. */
export function fullnessWord(pct: number): string {
  if (pct >= 100) return tr('ui_nb_full', 'full');
  if (pct >= 85) return tr('ui_nb_near_full', 'almost full');
  return '';
}
