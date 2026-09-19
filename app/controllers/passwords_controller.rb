class PasswordsController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.authenticate(params[:old_password])
      if @user.update(params.permit(:password, :password_confirmation))
        redirect_to edit_password_path, notice: "Password has been changed."
      else
        redirect_to edit_password_path, alert: @user.errors.full_messages.to_sentence
      end
    else
      redirect_to edit_password_path, alert: "Incorrect current password."
    end
  end

  private

  def set_user
    @user = Current.user
  end
end
