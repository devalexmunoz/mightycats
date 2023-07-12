import './bootstrap'
import '../css/app.scss'

import { createApp, h } from 'vue'
import { createInertiaApp } from '@inertiajs/vue3'
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers'

const appName =
  window.document.getElementsByTagName('title')[0]?.innerText || ''

createInertiaApp({
  title: (title) => {
    if (!appName) {
      return title
    }

    return `${title} - ${appName}`
  },
  resolve: (name) =>
    resolvePageComponent(
      `./Pages/${name}.vue`,
      import.meta.glob('./Pages/**/*.vue')
    ),
  setup({ el, App, props, plugin }) {
    const app = createApp({ render: () => h(App, props) })

    // Make global helper methods (see ./bootstrap.js) available to Vue templates
    app.config.globalProperties.$route = window.route

    app.use(plugin)
    app.mount(el)

    return app
  },
  progress: {
    delay: 1,
    color: '#4B5563',
  },
})
