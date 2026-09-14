class MessagesController < ApplicationController
  before_action :set_user
  before_action :set_receiver, only: %i[ index ]

  def index
    # this action is used to display an empty conversation so you can initiate a chat with someone
  end

  def create
    # this action processes both chat_messages_path(chat) and user_messages_path(user)
    ApplicationRecord.transaction do # all database changes must succeed or fail together
      @chat = if params[:chat_id].present?
                @user.chats.find(params[:chat_id])
      elsif params[:user_id].present?
                set_chat || create_chat
      end
      send_message
    end
    redirect_to chat_path(@chat)
  rescue ActiveRecord::RecordInvalid => error
    if params[:user_id].present?
      render :index, status: :unprocessable_entity
    else
      # redirect_to chat_path(@chat), alert: "Something went wrong. Please try again."
      @messages = @chat.messages
      @stickers = Sticker.all
      @error = error.record.errors.full_messages
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = Current.user
  end

  def set_receiver
    @receiver = User.find_by!(username: params[:user_id])
  end

  def set_chat
    set_receiver

    if @receiver == @user
      @user.chats.self_chat.first
    else
      @user.chats.direct_chat.where(id: ChatMember.where(user_id: @receiver.id).select(:chat_id)).first
    end
  end

  def create_chat
    Chat.create!(chat_members_attributes: [ { user: @user }, { user: @receiver } ])
  end

  def send_message
    ::MessageCreator.call(@chat, @user, message_params)
  end

  def message_params
    params.permit(:text, :sticker_id, :drawing)
  end
end
