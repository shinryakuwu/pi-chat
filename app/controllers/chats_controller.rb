class ChatsController < ApplicationController
  before_action :set_user

  def index
    @chats = @user.chats
      .includes(:last_message, cover_attachment: :blob, users: { profile_picture_attachment: :blob })
      .order(updated_at: :desc)
  end

  def show
    @chat = @user.chats.find(params[:id])
    @messages = @chat.messages
    @stickers = Sticker.all
  end

  private

  def set_user
    @user = Current.user
  end
end
