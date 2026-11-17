import assert from 'node:assert/strict';
import { after, before, test } from 'node:test';
import { mkdtempSync, writeFileSync, unlinkSync, rmdirSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';
import { build } from 'esbuild';

const root = dirname(dirname(fileURLToPath(import.meta.url)));
const scratch = mkdtempSync(join(tmpdir(), 'w-inventory-weight-'));
const bundle = join(scratch, 'panels.cjs');
let ui;

before(async () => {
  // Render the real panels against the slot totals received from Lua.
  globalThis.window = { innerWidth: 1280, innerHeight: 720 };
  globalThis.localStorage = { getItem: () => null };
  const result = await build({
    stdin: {
      contents: `export { createElement } from 'react';
        export { renderToStaticMarkup } from 'react-dom/server';
        export { default as Right } from './src/components/RightInventoryPanel';
        export { default as Container } from './src/components/ContainerPanel';
        export { default as Player, WeightProgress } from './src/components/WeightBar';`,
      resolveDir: root,
      loader: 'tsx',
    },
    bundle: true, write: false, platform: 'node', format: 'cjs', jsx: 'automatic',
    define: { 'process.env.NODE_ENV': '"production"' },
  });
  writeFileSync(bundle, result.outputFiles[0].contents);
  ui = createRequire(import.meta.url)(bundle);
});

after(() => {
  if (ui) delete createRequire(import.meta.url).cache[bundle];
  try { unlinkSync(bundle); } catch (error) { if (error.code !== 'ENOENT') throw error; }
  rmdirSync(scratch);
  delete globalThis.window;
  delete globalThis.localStorage;
});

function stack(count, weight = count * 500, slot = 1, metadata = {}) {
  return { slot, name: 'wood', label: 'Wood', count, weight, limit: 0, metadata };
}

function render(kind, grid) {
  const noop = () => {};
  const props = {
    selected: null, selectedPanel: 'main', onSelect: noop, onContextMenu: noop,
    onDoubleClick: noop, onMouseOver: noop, onMouseLeave: noop, onClose: noop,
    rightInventory: { id: 'trunk1', type: 'trunk', label: 'Wagon storage', slots: 20, maxWeight: 80000 },
    rightGrid: grid, playerCash: 0, playerGold: 0, shopPaymentCurrency: 'cash',
    onSetPaymentCurrency: noop, itemAmount: 0, onSetItemAmount: noop,
    containerOpen: 'bag1', containerGrid: grid, containerLabel: 'Bag',
    containerMaxWeight: 80000, containerSlots: 20, grid, maxWeight: 80000,
  };
  return ui.renderToStaticMarkup(ui.createElement(ui[kind], props));
}

const cases = [
  ['reported 32 pieces', [stack(32)], 16, 20],
  ['pictured 36 pieces', [stack(36)], 18, 22.5],
  ['same cargo split across two slots', [stack(18), null, stack(18, 9000, 3)], 18, 22.5],
  ['four pieces left after a partial transfer', [stack(4)], 2, 2.5],
  ['server total already includes metadata weight', [stack(4, 2800, 1, { weight: 200 })], 2.8, 3.5],
  ['a zero-weight stack remains weightless', [stack(36, 0)], 0, 0],
  ['real capacity remains full', [stack(160)], 80, 100],
  ['empty storage', [null, null], 0, 0],
];

for (const [name, grid, kg, percent] of cases) {
  test(name, () => {
    const weight = `${kg.toFixed(2)} kg / 80.00 kg`;
    assert.ok(render('Player', grid).includes(weight), 'player bag uses the server stack total');
    for (const [panel, bar] of [['Right', 'rp-bar-fill'], ['Container', 'cp-bar-fill']]) {
      const html = render(panel, grid);
      assert.ok(html.includes(weight), `${panel} uses the server stack total`);
      assert.ok(html.includes(`\u2068${kg}\u2069 of \u206880\u2069 kg`), `${panel} subtitle agrees`);
      const fill = new RegExp(`class="${bar}([^\"]*)" style="width:([\\d.]+)%"`).exec(html);
      assert.ok(fill, `${panel} renders a weight bar`);
      assert.ok(Math.abs(Number(fill[2]) - percent) < 1e-8, `${panel} fill matches its real capacity`);
      if (panel === 'Right') assert.equal(fill[1].includes('critical'), percent >= 85);
    }
  });
}
