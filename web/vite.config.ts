import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [
    react(),
  ],
  base: './',
  publicDir: 'public',
  build: {
    outDir: 'build',
    target: 'esnext',
    cssCodeSplit: false,
    minify: false,
    rollupOptions: {
      output: {
        // Keep NUI entry names stable. Cfx caches fxmanifest file metadata, so
        // hashed entry names can make a normal resource restart load an old or
        // missing bundle until the server performs a full refresh.
        entryFileNames: 'assets/app.js',
        chunkFileNames: 'assets/chunk-[name].js',
        assetFileNames: (asset) => {
          if (asset.name && asset.name.endsWith('.css')) {
            return 'app.css'
          }
          return 'assets/[name][extname]'
        }
      }
    }
  },
  define: {
    'process.env': {},
  },
  esbuild: {
    logOverride: { 'this-is-undefined-in-esm': 'silent' },
  },
});
