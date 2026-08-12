class MessagesController < ApplicationController
  before_action :set_receiver, only: %i[ index create ]
  before_action :set_chat, only: %i[ index create ]

  def index
    @messages = @chat&.messages
  end

  def create
    @chat ||= Chat.create(chat_members_attributes: [ { user: Current.user }, { user: @receiver } ])
    if @chat.persisted?
      send_message
      redirect_to user_messages_path(@receiver)
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_receiver
    @receiver = User.find_by!(username: params[:user_id])
  end

  def set_chat
    if @receiver == Current.user
      @chat = Current.user.chats.self_chat.first
    else
      @chat = Current.user.chats.direct_chat.where(id: ChatMember.where(user_id: @receiver.id).select(:chat_id)).first
    end
  end

  def send_message
    ## TODO: move message creation logic to service because there'll be a lot going on
    @chat.messages.create!(author: Current.user, text: params[:text])
  end
end
