import { Locale } from './store/locale';

type LocaleDictionary = Record<string, string>;

/**
 * Install the dictionary Lua sent (the ui_* subset of locales/<lang>.json) and switch the
 * document to the language and direction the library chose. Called on init and on every
 * live language switch (w_lib:setLocale).
 */
export function installLocale(dictionary?: LocaleDictionary, lang?: string, dir?: string) {
  for (const key of Object.keys(Locale)) delete Locale[key];
  Object.assign(Locale, dictionary || {});

  const language = (lang || Locale.ui_language) === 'ar' ? 'ar' : 'en';
  const direction = dir === 'rtl' || dir === 'ltr' ? dir : language === 'ar' ? 'rtl' : 'ltr';
  const root = document.documentElement;
  root.lang = language;
  root.dir = direction;
  document.body.dir = direction;
  // the kit's Arabic tweaks key on .is-rtl (weights, no letter-spacing, no small caps)
  document.body.classList.toggle('is-rtl', direction === 'rtl');
  document.title = Locale.ui_inventory || 'Inventory';
}

export function tr(key: string, fallback?: string): string {
  return Locale[key] || fallback || key;
}

export function trf(key: string, fallback: string, ...values: Array<string | number>): string {
  let value = tr(key, fallback);

  for (const replacement of values) {
    // a replacer function: a value with '$' (money) must not be read as a replacement pattern
    value = value.replace(/%[sd]/, () => String(replacement));
  }

  return value;
}
