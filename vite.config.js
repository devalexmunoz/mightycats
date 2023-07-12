import { defineConfig, loadEnv } from 'vite'
import { nodePolyfills } from 'vite-plugin-node-polyfills'
import laravel from 'laravel-vite-plugin'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')

  return {
    base: env.ASSET_URL ? env.ASSET_URL : '/assets/',
    build: {
      outDir: 'public/assets',
      assetsDir: '',
    },
    plugins: [
      nodePolyfills(),
      laravel({
        input: 'resources/js/app.js',
        refresh: true,
      }),
      vue({
        template: {
          transformAssetUrls: {
            base: null,
            includeAbsolute: false,
          },
        },
      }),
    ],
    server: {
      hmr: {
        host: 'localhost',
      },
    },
    resolve: {
      alias: {
        '@storage': path.resolve(__dirname, './storage'),
        '@vendor': path.resolve(__dirname, './vendor'),
      },
    },
  }
})
