import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }

  // scrolls to the bottom of the chat on sending a message, so that the user can see their own message immediately
  handleStreamRender(event) {
    const stream = event.target
    const template = stream.querySelector("template")

    if (
      stream.getAttribute("action") !== "append" ||
      stream.getAttribute("target") !== "chat_content" ||
      !template?.content.querySelector(".message.sent")
    ) {
      return
    }

    const originalRender = event.detail.render

    // Turbo invokes the render function and passes in the stream element it is about to render.
    // We override this function to add our own behavior after the original render is complete.
    event.detail.render = async streamElement => {
      await originalRender(streamElement)
      this.scrollToBottom()
    }
  }
}
