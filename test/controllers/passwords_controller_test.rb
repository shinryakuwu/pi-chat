require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.take
    sign_in_as(@user)
  end

  test "edit" do
    get edit_password_path
    assert_response :success
  end

  test "update" do
    assert_changes -> { @user.reload.password_digest } do
      put password_path, params: { old_password: "password", password: "new", password_confirmation: "new" }
      assert_redirected_to edit_password_path
    end

    follow_redirect!
    assert_notice "Password has been changed."
    assert @user.authenticate("new")
  end

   test "not update with incorrect old password" do
    assert_no_changes -> { @user.reload.password_digest } do
      put password_path, params: { old_password: "invalid", password: "new", password_confirmation: "new" }
      assert_redirected_to edit_password_path
    end

    follow_redirect!
    assert_notice "Incorrect current password."
    assert @user.authenticate("password")
  end

  test "not update with non matching passwords" do
    assert_no_changes -> { @user.reload.password_digest } do
      put password_path, params: { old_password: "password", password: "no", password_confirmation: "match" }
      assert_redirected_to edit_password_path
    end

    follow_redirect!
    assert_notice "Password confirmation doesn't match Password"
    assert @user.authenticate("password")
  end
end
