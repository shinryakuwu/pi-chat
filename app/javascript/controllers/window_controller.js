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
}
