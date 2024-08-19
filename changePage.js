export const handlePageChange = elmApp => {
  elmApp.ports.sendUrlChangeRequest.subscribe(url => {
	if (url.includes('note')) {
		document.documentElement.className = 'page-two'
	} else {
		document.documentElement.className = 'page-one'
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
