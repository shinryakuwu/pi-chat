import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  message(event) {
    this.element.dispatchEvent(
      new CustomEvent("profile:message", {
        bubbles: true,
        detail: {
          username: event.currentTarget.dataset.username
        }
      })
    )
  }
}
