import { isEnvBrowser } from './misc';

let _imagepath = 'images';

export function setImagePath(path: string) {
  if (path && path !== '') _imagepath = path;
}

export function getImagePath() {
  return _imagepath;
}

const resourceName = (window as any).GetParentResourceName
  ? (window as any).GetParentResourceName()
  : 'w_inventory';

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
  return `${_imagepath}/${name}.png`;
}

export function placeholderUrl(): string {
  return `${_imagepath}/placeholder.png`;
}

export function getItemUrl(item: any): string {
  if (typeof item === 'object' && item !== null) {
    if (!item.name) return '';
    if (item.metadata?.imageurl) return item.metadata.imageurl;
    if (item.metadata?.image) return `${_imagepath}/${item.metadata.image}.png`;
    const itemData = (window as any).__oxItems?.[item.name];
    if (itemData?.image) return itemData.image;
    return `${_imagepath}/${item.name}.png`;
  }
  return `${_imagepath}/${item}.png`;
}
