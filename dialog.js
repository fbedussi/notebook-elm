export const handleDialog = (elmApp) => {
  const animationDuration = 350
  const isOpenClass = 'modal-is-open'
  const isOpeningClass = 'modal-is-opening'
  const isClosingClass = 'modal-is-closing'
  elmApp.ports.openDialog.subscribe(id => {
    requestAnimationFrame(() => {
      document.documentElement.classList.add(isOpenClass, isOpeningClass)
      document.getElementById(id).showModal()
      setTimeout(() => {
        document.documentElement.classList.remove(isOpeningClass)
      }, animationDuration)
    })
  })

  elmApp.ports.closeDialog.subscribe(id => {
    document.documentElement.classList.add(isClosingClass)
    setTimeout(() => {
      document.documentElement.classList.remove(isClosingClass, isOpenClass)
      document.getElementById(id).close()
      elmApp.ports.dialogClosed.send(null)
    }, animationDuration)
  })
}
