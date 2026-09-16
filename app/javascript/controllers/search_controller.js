import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    if (this.inputTarget.value !== "") {
      this.inputTarget.focus()
      this.moveCaretToEnd()
    }

    this.timeout = null
  }

  changed() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 800)
  }

  submit(event) {
    event?.preventDefault()

    clearTimeout(this.timeout)

    this.element.requestSubmit()
  }

  moveCaretToEnd() {
    const length = this.inputTarget.value.length

    this.inputTarget.setSelectionRange(length, length)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
