import { isEnvBrowser } from './misc';

const resourceName = (window as any).GetParentResourceName
  ? (window as any).GetParentResourceName()
  : 'w_inventory';

// Currency and early slot messages can arrive before the catalog/init message.
let _imagepath = isEnvBrowser() ? '/images' : `https://cfx-nui-${resourceName}/web/images`;

function imageUrl(value: string): string {
  if (value.startsWith('nui://')) return value.replace('nui://', 'https://cfx-nui-');
  if (/^(https?:|data:|blob:)/i.test(value) || value.startsWith('/')) return value;
  const filename = /\.(png|webp|jpg|jpeg)(?:[?#]|$)/i.test(value) ? value : `${value}.png`;
  return `${_imagepath}/${filename}`;
}

export function setImagePath(path: string) {
  if (path && path !== '') _imagepath = path.replace(/^nui:\/\//, 'https://cfx-nui-').replace(/\/$/, '');
}

export function getImagePath() {
  return _imagepath;
}

export async function fetchNui<T = any>(eventName: string, data?: unknown): Promise<T> {
  if (isEnvBrowser()) return undefined as any;

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), 10000);

  try {
    const resp = await fetch(`https://${resourceName}/${eventName}`, {
      method: 'post',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data),
      signal: controller.signal,
    });
    // A Lua call that invokes cb() with no value - or that is not registered at all - returns an empty
    // body, and resp.json() on it throws "Unexpected end of JSON input".
    // We read text and parse only when there is content.
    const text = await resp.text();

    return (text ? JSON.parse(text) : undefined) as any;
  } catch (e) {
    if ((e as Error).name === 'AbortError') {
      console.warn(`[fetchNui] ${eventName} timed out after 10s`);
    }
    return undefined as any;
  } finally {
    clearTimeout(timer);
  }
}

export function iconUrl(name: string): string {
  return getItemUrl(name);
}

export function placeholderUrl(): string {
  return imageUrl('kit_pouch_kit.png');
}

export function getItemUrl(item: any): string {
  const name = typeof item === 'string' ? item : item?.name;
  if (typeof name !== 'string' || !name) return placeholderUrl();
  const lower = name.toLowerCase();
  const metadata = typeof item === 'object' ? item.metadata : undefined;
  // Cash is a core account rendered as an item; stale stack metadata cannot hide its icon.
  if (lower === 'money' || lower === 'cash') return imageUrl('money.png');
  if (metadata?.imageurl) return imageUrl(String(metadata.imageurl));
  if (metadata?.image) return imageUrl(String(metadata.image));
  const items = (window as any).__oxItems || {};
  const definition = items[name] || items[lower] || items[name.toUpperCase()];
  const image = definition?.image || definition?.client?.image;
  return imageUrl(image || `${lower}.png`);
}

export function itemImageError(target: HTMLImageElement, item: any) {
    // Try the catalog after a stale custom picture, then one existing native bag icon.
  if (target.src === new URL(placeholderUrl(), window.location.href).href) return;
  const canonical = getItemUrl(typeof item === 'string' ? item : item?.name);
  const fallback = target.src === new URL(canonical, window.location.href).href ? placeholderUrl() : canonical;
  if (target.src === new URL(fallback, window.location.href).href) { target.onerror = null; return; }
  target.src = fallback;
}
