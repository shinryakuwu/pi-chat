import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  selectOnReload(event) {
    if (event.target.id !== "navigation") {
      return
    }

    const chatContent = this.element.querySelector("#chat_content")
    const currentChatId = chatContent?.dataset.chatId

    if (!currentChatId) {
      return
    }

    const currentChat = this.element.querySelector(
      `.nav_item[data-chat-id="${currentChatId}"]`
    )

    currentChat?.classList.add("active")
  }

  select(event) {
    this.clear()
    event.currentTarget.classList.add("active")
  }

  hideUnreadCount(event) {
    event.currentTarget.querySelector(".nav_item_count")?.remove()
  }

  clear() {
    this.element
      .querySelectorAll(".nav_item")
      .forEach(item => item.classList.remove("active"))
  }

  refresh() {
    const navigation = this.element.querySelector("#navigation")

    navigation.src = "/chats"
  }

  openProfile(event) {
    // doing both at the point of attaching the action to an element so not needed here
    // event.preventDefault()
    // event.stopPropagation()

    const url = event.currentTarget.dataset.profileUrl

    Turbo.visit(url, { frame: "profile" })
  }

  messageReceived(event) {
    // navigation is reloaded when user receives a new message
    const chatId = event.detail.chatId

    const searchInput = this.element.querySelector("#search_input")
    const navigation = this.element.querySelector("#navigation")

    const search = searchInput?.value.trim() || ""

    if (search === "") {
      navigation.src = "/chats"
      return
    }

    const chatItem = this.element.querySelector(
      `.nav_item[data-chat-id="${chatId}"]`
    )

    // navigation with search results will only be reloaded if results contain the chat that received a new message
    // so the user's current search isn't disturbed by an unrelated message
    if (!chatItem) {
      return
    }

    navigation.src = `/chats?search=${encodeURIComponent(search)}`
  }
}
