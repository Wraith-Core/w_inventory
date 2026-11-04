import prettifyModule from 'postcss-prettify';
// ★ Every px in the CSS follows the screen (720p .. 8K, ultrawide by height): ui-scale.cjs (keep it last).
import uiScale from './ui-scale.cjs';

const prettify = prettifyModule.default || prettifyModule;

export default {
    plugins: [prettify(), uiScale()],
  }
