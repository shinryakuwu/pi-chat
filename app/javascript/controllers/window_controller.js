import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["window"]

  open() {
    this.windowTarget.style.display = "block";
  }

  close() {
    this.windowTarget.style.display = "none";
  }

  showChat() {
    this.windowTarget.classList.add("show_chat")
  }

  showNavigation() {
    this.windowTarget.classList.remove("show_chat");
  }

  messageUser(event) {
    const username = event.detail.username
    const profile = this.element.querySelector("#profile")
    const chat = this.element.querySelector("#chat")
    const navigation = this.element.querySelector("#navigation")

    profile.src = "/"
    chat.src = `/users/${encodeURIComponent(username)}/messages`
    navigation.src = `/chats?search=${encodeURIComponent(username)}`
  }
}
