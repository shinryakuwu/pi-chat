require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    sign_in_as(@user)
    @chat = Chat.create!(
      chat_type: :direct_chat,
      chat_members_attributes: [ { user: @user }, { user: @other_user } ]
    )
  end

  test "index displays unread message counts" do
    create_message(@other_user, "First unread message")
    create_message(@other_user, "Second unread message")
    create_message(@user, "My own message")

    get chats_path

    assert_response :success
    assert_select ".nav_item[data-chat-id='#{@chat.id}'] .nav_item_count", "2"
    assert_select ".nav_item[data-chat-id='#{@chat.id}'] .nav_item_message", "You: My own message"
    assert_equal 2, @chat.unread_count(@user)
    assert_equal 1, @chat.unread_count(@other_user)
  end

  test "opening a chat clears its unread count" do
    create_message(@other_user, "Unread message")
    membership = @chat.chat_members.find_by!(user: @user)
    message_time = @chat.messages.last.created_at

    get chat_path(@chat)

    assert_response :success
    last_read_at = membership.reload.last_read_at
    assert last_read_at.present?
    assert_operator last_read_at, :>=, message_time
    assert_equal 0, @chat.unread_count(@user)

    get chats_path

    assert_response :success
    assert_select ".nav_item[data-chat-id='#{@chat.id}'] .nav_item_count", count: 0

    create_message(@other_user, "New message")

    get chats_path

    assert_response :success
    assert_select ".nav_item[data-chat-id='#{@chat.id}'] .nav_item_count", "1"
  end

  private

  def create_message(author, text)
    Message.create!(
      chat: @chat,
      author: author,
      message_type: :text_message,
      text: text
    )
  end
end
