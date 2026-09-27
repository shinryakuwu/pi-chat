import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    chatId: Number
  }

  connect() {
    this.playSound()

    this.element.dispatchEvent(
      new CustomEvent("message:received", {
        bubbles: true,
        detail: {
          chatId: this.chatIdValue
        }
      })
    )

    this.element.remove()
  }

  playSound() {
    const audio = new Audio("/audio/meow.wav")
    audio.play().catch(() => {})
  }
}
