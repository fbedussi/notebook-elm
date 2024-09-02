export const handlePageChange = elmApp => {
  elmApp.ports.sendUrlChangeRequest.subscribe(url => {
	if (url.includes('note') || url.includes('login')) {
		document.documentElement.className = 'pico page-two'
	} else {
		document.documentElement.className = 'pico page-one'
	}

	const changePage = () => {
    elmApp.ports.performUrlChange.send(url)
  };

  // Fallback for browsers that don't support View Transitions:
  if (!document.startViewTransition) {
    changePage();
    return;
  }

  // With View Transitions:
  const transition = document.startViewTransition(() => changePage());
})
}
