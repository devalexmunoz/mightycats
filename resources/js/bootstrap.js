import route from '@vendor/tightenco/ziggy/src/js'
import { Ziggy as ZiggyConfig } from './routes'

/**
 * Customize Ziggy's route helper to be more convenient for our use case.
 *
 * @param {String} name Route name.
 * @param {Object} params Route params.
 * @return {String} URL for the route.
 */
window.route = (name, params) => route(name, params, false, ZiggyConfig)

/*
 * Helper function to fetch Vite env variables
 */
window.getViteEnv = (viteVariable) => import.meta.env['VITE_' + viteVariable]

/**
 * We'll load the axios HTTP library which allows us to easily issue requests
 * to our Laravel back-end. This library automatically handles sending the
 * CSRF token as a header based on the value of the "XSRF" token cookie.
 */

import axios from 'axios'
window.axios = axios

window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'
