class ProfilePicturesController < ApplicationController
  def create
    Current.user.profile_picture.attach(params.require(:profile_picture))

    redirect_to user_path(Current.user), status: :see_other, notice: "Profile picture updated."
  end

  def destroy
    Current.user.profile_picture.purge

    redirect_to user_path(Current.user), status: :see_other, notice: "Profile picture removed."
  end
end
