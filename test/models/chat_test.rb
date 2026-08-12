require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "should be valid when direct chat with two chat members" do
    user1 = User.create(username: "computer_angel", password: "benotafraid")
    user2 = User.create(username: "computer_devil", password: "beafraid")
    chat = Chat.new(chat_members_attributes: [ { user: user1 }, { user: user2 } ])
    assert chat.valid?
  end

  test "should be invalid when direct chat with one chat member" do
    user = User.create(username: "computer_angel", password: "benotafraid")
    chat = Chat.new(chat_members_attributes: [ { user: user } ])
    assert_not chat.valid?
    assert_includes chat.errors[:base].first, "Direct chat can only have two members"
  end
end
