class UsersController < ApplicationController
  unauthenticated_access_only only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_user_path, alert: "Try again later." }

  def show
    @user = User.find_by!(username: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to user_path(@user), status: :see_other, notice: "Your profile was updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @user = Current.user
    terminate_session
    @user.update!(
      deleted_at: Time.current,
      name: "Deleted user",
      bio: nil
    )
    @user.profile_picture.purge

    redirect_to new_session_path, notice: "Your account was deleted successfully."
  end

  private

  def sign_up_params
    params.expect(user: [ :username, :name, :password, :password_confirmation ])
  end

  def profile_params
    params.expect(user: [ :username, :name, :bio ])
  end
end
