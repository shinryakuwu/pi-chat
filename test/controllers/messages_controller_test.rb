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

  test "create message" do
    assert_changes -> { Chat.count } do
      post user_messages_path(@receiver), params: { text: "I know what you did." }
      assert_redirected_to user_messages_path(@receiver)
    end

    follow_redirect!
    assert_match "I know what you did.", response.body
  end
end
