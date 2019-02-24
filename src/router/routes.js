const routes = [
  {
    path: '/',
    component: () => import('layouts/MyLayout.vue'),
    children: [{ path: '/', name: 'computer', component: () => import('pages/Computer.vue') }]
  }
]

// Always leave this as last one
if (process.env.MODE !== 'ssr') {
  routes.push({
    path: '*',
    component: () => import('pages/Error404.vue')
  })
}

export default routes
