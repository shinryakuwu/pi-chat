import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["send", "stickerForm", "stickerId"]

  select(event) {
    if (event.currentTarget.classList.contains("active")) { return }

    this.clear(".message_type_button")
    this.clear(".message_type_tab")

    event.currentTarget.classList.add("active")
    this.element
      .querySelector("#chat_" + event.currentTarget.id.replace("button", "tab"))
      .classList.add("active")

    this.changeSendButton(event.currentTarget)
  }

  changeSendButton(button) {
    // send button behaves differently depending on what input tab you open
    if (button.id === "text_button") {
      this.sendTarget.setAttribute("form", "chat_text_tab")
      this.sendTarget.disabled = false
    }

    if (button.id === "paint_button") {
      this.sendTarget.setAttribute("form", "chat_paint_tab")
      this.sendTarget.disabled = false
    }

    if (button.id === "stickers_button") {
      this.sendTarget.disabled = true
    }
  }

  clear(class_name) {
    this.element
      .querySelectorAll(class_name)
      .forEach(item => item.classList.remove("active"))
  }

  sendSticker(event) {
    this.stickerIdTarget.value = event.currentTarget.dataset.stickerId
    this.stickerFormTarget.requestSubmit()
  }
}
