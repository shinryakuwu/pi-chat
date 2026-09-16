import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.disableImageDrag()
    this.updateSidePanels()

    this.interval = setInterval(() => {
      this.updateSidePanels()
    }, 60 * 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  disableImageDrag() {
    this.element.addEventListener("dragstart", (event) => {
      if (event.target.tagName === "IMG") {
        event.preventDefault()
      }
    })
  }

  updateSidePanels() {
    let hour = new Date().getHours()
    let isNight = hour >= 22 || hour < 6

    this.element.querySelector("#left_side_panel")?.classList.toggle("night", isNight)
    this.element.querySelector("#right_side_panel")?.classList.toggle("night", isNight)
  }
}
