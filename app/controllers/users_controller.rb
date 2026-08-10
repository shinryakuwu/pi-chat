class UsersController < ApplicationController
  unauthenticated_access_only only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_user_path, alert: "Try again later." }

  def index
    # TODO: remove this action later
    @users = User.all
  end

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
      Rails.logger.warn @user.errors.full_messages.inspect
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      @user.profile_picture.purge if params[:user][:remove_profile_picture] == "1"

      redirect_to user_path(@user), status: :see_other, notice: "Your profile was updated successfully."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    # TODO: add account deactivation, treat dependants properly
  end

  private

  def sign_up_params
    params.expect(user: [ :username, :name, :password, :password_confirmation ])
  end

  def profile_params
    params.expect(user: [ :username, :name, :bio, :profile_picture ])
  end
end
