import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  choose() {
    this.inputTarget.click()
  }

  upload() {
    if (this.inputTarget.files.length === 0) {
      return
    }

    this.inputTarget.form.requestSubmit()
  }

  submissionFinished(event) {
    if (!event.detail.success) {
      return
    }

    this.element.dispatchEvent(
      new CustomEvent("profile-picture:updated", { bubbles: true })
    )
  }
}
