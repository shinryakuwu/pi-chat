class ChatsController < ApplicationController
  before_action :set_user

  def index
    @search = params[:search]

    @chats = @user.chats
      .includes(:last_message, cover_attachment: :blob, users: { profile_picture_attachment: :blob })
      .order(updated_at: :desc)

    if @search.present?
      @search_user = User.find_by(username: sanitize_search)

      filter_chats
    end

    @chats = @chats.order(updated_at: :desc)
  end

  def show
    @chat = @user.chats.find(params[:id])
    @messages = @chat.messages.includes(drawing_attachment: :blob, sticker: { sticker_image_attachment: :blob })
    @stickers = Sticker.all.includes(sticker_image_attachment: :blob)
  end

  private

  def set_user
    @user = Current.user
  end

  def filter_chats
    pattern = "%#{ActiveRecord::Base.sanitize_sql_like(@search)}%"
    excluded_ids = [ @user.id ]
    excluded_ids << @search_user.id if @search_user.present?

    @chats = @chats
      .direct_chat
      .joins(:users)
      .where.not(users: { id: excluded_ids })
      .where(
        "users.username ILIKE :pattern OR users.name ILIKE :pattern",
        pattern: pattern
      )
      .distinct
  end

  def sanitize_search
    # match any character which is not a letter, a number, "-" or "_" and remove it from a string.
    # \p{L} - unicode letter, \p{N} - unicode number, /u tells Ruby to interpret the regex as Unicode.
    @search.to_s.gsub(/[^\p{L}\p{N}_-]/u, "")
  end
end
