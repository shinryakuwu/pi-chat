require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sender = users(:one)
    @receiver = users(:two)
    sign_in_as(@sender)
  end

  test "index" do
    get user_messages_path(@receiver)
    assert_response :success
  end

  test "create initial message in direct chat" do
    assert_changes -> { Chat.count }, +1 do
      post user_messages_path(@receiver), params: { text: "I know what you did." }
      assert_redirected_to chat_path(@receiver.chats.last)
    end

    follow_redirect!
    assert_match "I know what you did.", response.body
  end

  test "create message in self chat" do
    assert_no_changes -> { Chat.count } do
      post user_messages_path(@sender), params: { text: "I know what you did." }
      assert_redirected_to chat_path(@sender.chats.self_chat.first)
    end

    follow_redirect!
    assert_match "I know what you did.", response.body
  end

  test "not create message in chat when sender is not an owner" do
    assert_no_changes -> { Chat.count } do
      post chat_messages_path(@receiver.chats.self_chat.first), params: { text: "I know what you did." }
    end

    assert_response :not_found
  end
end
