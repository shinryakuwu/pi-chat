require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    user = User.new(username: "computer_angel", password: "benotafraid")
    assert user.valid?
  end

  test "should be invalid without username" do
    user = User.new(password: "benotafraid")
    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "should be invalid without password" do
    user = User.new(username: "computer_angel")
    assert_not user.valid?
    assert_includes user.errors[:password], "can't be blank"
  end
end
