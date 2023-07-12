import { router, usePage } from '@inertiajs/vue3'

export function getAuthUser() {
  const page = usePage()

  return page.props.auth.user
}

export function updateAuthUserProps(props) {
  const page = usePage()

  Object.keys(props).forEach((prop) => {
    page.props.auth.user[prop] = props[prop]
  })
}

export function logout() {
  router.post(route('logout'))
}
