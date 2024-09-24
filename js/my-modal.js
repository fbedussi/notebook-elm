customElements.define('my-modal', class extends HTMLElement {
    static observedAttributes = ['open']

    dialogEl = this.querySelector('dialog')
    animationDuration = 350
    isOpenClass = 'modal-is-open'
    isOpeningClass = 'modal-is-opening'
    isClosingClass = 'modal-is-closing'

    constructor() {
        super()
    }

    connectedCallback() {
        this.dialogEl = this.querySelector('dialog')
        this.handleOpen(this.getAttribute('open') === 'true')
    }


    attributeChangedCallback(name, oldValue, newValue) {
        if (name === 'open') {
            this.handleOpen(newValue === 'true')
        }
    }

    handleOpen(open) {
        if (!this.dialogEl) {
            return
        }
        if (open) {
            document.documentElement.classList.add(this.isOpenClass, this.isOpeningClass)
            this.dialogEl.showModal()
            setTimeout(() => {
                document.documentElement.classList.remove(this.isOpeningClass)
            }, this.animationDuration)
        } else {
            document.documentElement.classList.add(this.isClosingClass)
            setTimeout(() => {
                document.documentElement.classList.remove(this.isClosingClass, this.isOpenClass)
                this.dialogEl.close()
            }, this.animationDuration)
        }
    }
})