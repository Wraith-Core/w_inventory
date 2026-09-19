export const isEnvBrowser = (): boolean => !(window as any).invokeNative;
export const noop = () => {};

export const isInventoryEmpty = (inventory: { items?: any[] }): boolean => {
  if (!inventory.items || inventory.items.length === 0) return true;
  return inventory.items.every((item) => !item?.name);
};
