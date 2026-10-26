import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sentinel", "loadLink"]

  // User scrolls upward -> IntersectionObserver detects the sentinel -> Link is clicked programmatically ->
  // -> ChatMessagesController#index fetches older records -> Turbo prepends messages and replaces the sentinel ->
  // -> Stimulus observes the new sentinel; scroll position is preserved

  connect() {
    this.loading = false
    this.loadingInterval = null

    // IntersectionObserver is a browser API that watches whether an element is visible, or intersects, with a specified viewing area.
    // Here it will be used to implement an infinite scroll for messages.
    this.observer = new IntersectionObserver(
      entries => this.checkSentinel(entries),
      {
        root: this.element,  // the chat container is the "viewing area" for the IntersectionObserver
        rootMargin: "150px 0px 0px 0px" // loading will start when the sentinel is 150px from the top of the chat container
      }
    )

    if (this.hasSentinelTarget) {
      this.observer.observe(this.sentinelTarget)
    }
  }

  // Disconnect the IntersectionObserver when the controller is disconnected to avoid memory leaks (happens when we close the chat).
  disconnect() {
    this.observer?.disconnect()
    this.stopLoading()
  }

  // This method is called when the sentinel element is connected to the DOM (we constantly reconnect it in the process of scrolling).
  sentinelTargetConnected(element) {
    if (!this.observer) {
      return
    }

    this.stopLoading()
    this.observer.observe(element)
  }

  // This method is called when the sentinel element is disconnected from the DOM.
  sentinelTargetDisconnected(element) {
    this.observer?.unobserve(element)
    this.stopLoading()
  }

  startLoading(link) {
    this.loading = true

    const frames = [".", "..", "..."]
    let frameIndex = 0
    link.textContent = frames[frameIndex]

    this.loadingInterval = window.setInterval(() => {
      frameIndex = (frameIndex + 1) % frames.length
      link.textContent = frames[frameIndex]
    }, 250)
  }

  stopLoading() {
    if (this.loadingInterval !== null) {
      window.clearInterval(this.loadingInterval)
      this.loadingInterval = null
    }

    this.loading = false
  }

  // This method is called when the sentinel element intersects with the chat container.
  checkSentinel(entries) {
    for (const entry of entries) {
      // Ignore the entry if the sentinel isn't currently intersecting the viewing area or if a loading operation is already in progress.
      if (!entry.isIntersecting || this.loading) {
        continue
      }

      const link = entry.target.querySelector("a")

      if (!link) {
        continue
      }

      this.startLoading(link)
      this.observer.unobserve(entry.target)
      link.click()
      link.removeAttribute("href")
    }
  }

  // This method listens for Turbo's turbo:before-stream-render event and modifies how a prepend operation is rendered.
  preserveScroll(event) {
    const stream = event.target

    if (
      stream.getAttribute("action") !== "prepend" ||
      stream.getAttribute("target") !== "chat_content"
    ) {
      return
    }

    const previousHeight = this.element.scrollHeight
    const previousTop = this.element.scrollTop
    const originalRender = event.detail.render

    event.detail.render = async streamElement => {
      await originalRender(streamElement)

      this.element.scrollTop =
        previousTop + (this.element.scrollHeight - previousHeight)
    }
  }
}
