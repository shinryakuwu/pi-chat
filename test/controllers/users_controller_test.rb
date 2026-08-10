require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_user_path
    assert_response :success
  end

  test "create with valid data" do
    assert_changes -> { User.count } do
      post users_path, params: { user: { username: "new-user", password: "password", password_confirmation: "password" } }
      assert_redirected_to root_path
    end

    follow_redirect!
    assert cookies[:session_id]
  end

  test "create with taken username" do
    assert_no_changes -> { User.count } do
      post users_path, params: { user: { username: @user.username, password: "password", password_confirmation: "password" } }
    end

    assert_notice "Username has already been taken"
    assert_nil cookies[:session_id]
  end

  test "create with invalid username" do
    assert_no_changes -> { User.count } do
      post users_path, params: { user: { username: "new-u$er", password: "password", password_confirmation: "password" } }
    end

    assert_notice "Username may only contain letters, numbers, hyphens, and underscores"
    assert_nil cookies[:session_id]
  end

  test "create with non matching passwords" do
    assert_no_changes -> { User.count } do
      post users_path, params: { user: { username: "new-user", password: "password", password_confirmation: "passw0rd" } }
    end

    assert_notice "Password confirmation doesn't match Password"
    assert_nil cookies[:session_id]
  end

  test "show profile" do
    sign_in_as(@user)
    get user_path(@user)
    assert_response :success
  end

  test "update with valid params" do
    assert_changes -> { @user.reload.username } do
      sign_in_as(@user)
      put user_path(@user.username), params: { user: { username: "new-username", name: "Ryan", bio: "human bean" } }
    end

    assert_redirected_to user_path(@user.username)

    follow_redirect!
    assert_notice "Your profile was updated successfully."
  end

  test "update with invalid username" do
    assert_no_changes -> { @user.reload.username } do
      sign_in_as(@user)
      put user_path(@user.username), params: { user: { username: "new-usern@me", name: "Ryan", bio: "human bean" } }
    end

    assert_notice "Username may only contain letters, numbers, hyphens, and underscores"
  end

  private

  # TODO: move to some helper maybe
  def assert_notice(text)
    assert_select "div", /#{text}/
  end
end
