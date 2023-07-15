import { router, usePage } from '@inertiajs/vue3'

const getAuthUser = () => {
  const page = usePage()

  return page.props.auth.user
}

const updateAuthUserProps = (props) => {
  const page = usePage()

  Object.keys(props).forEach((prop) => {
    page.props.auth.user[prop] = props[prop]
  })
}

const logout = () => {
  router.post(route('logout'))
}

export { getAuthUser, updateAuthUserProps, logout }
