import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select(event) {
    this.clear()
    event.currentTarget.classList.add("active")
  }

  clear() {
    this.element
      .querySelectorAll(".nav_item")
      .forEach(item => item.classList.remove("active"))
  }
}
