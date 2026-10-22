class ChatMessagesController < ApplicationController
  def index
    # this endpoint is used for fetching chunks of older messages
    @user = Current.user
    @chat = @user.chats.find(params[:chat_id])

    before_message = @chat.messages.find(params.require(:before_id))

    # this action uses a keyset pagination - it considers that the new messages can arrive while you're browsing old ones
    records = @chat.messages
      .where(
        "messages.created_at < :time OR " \
        "(messages.created_at = :time AND messages.id < :id)",
        time: before_message.created_at,
        id: before_message.id
      )
      .includes(
        drawing_attachment: :blob,
        sticker: { sticker_image_attachment: :blob },
        author: { profile_picture_attachment: :blob }
      )
      .order(created_at: :desc, id: :desc)
      .limit(Chat::MESSAGE_PAGE_SIZE + 1)
      .to_a

    @has_older_messages = records.length > Chat::MESSAGE_PAGE_SIZE
    @messages = records.first(Chat::MESSAGE_PAGE_SIZE).reverse
  end
end
