const isManagedUrl = url => {
  return url.includes('someserver.com')
}


self.addEventListener('fetch', async (event) => {
  const managedUrl = isManagedUrl(event.request.url)

  if (event.type !== 'fetch' || event.request.method.toUpperCase() !== 'GET' || !managedUrl) {
    return
  }

  const result = new Promise(res => {
    setTimeout(() => {
      res(new Response(
        JSON.stringify(
          {
            one: 'bar',
            two: 48
          }
        )
      ))
    }, 1000)
  })

  event.respondWith(result)
})
