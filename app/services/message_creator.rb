class MessageCreator < BaseService
  attr_accessor :chat, :user, :params

  def initialize(chat, user, params)
    @chat = chat
    @user = user
    @params = params
  end

  def call
    if params[:drawing].present?
      create_drawing_message
    elsif params[:sticker_id].present?
      create_sticker_message
    elsif params[:text].present?
      create_text_messages
    else
      raise ActiveRecord::RecordInvalid.new(Message.new)
    end

    chat.touch
  end

  private

  def create_drawing_message
    chat.messages.create!(author: user, message_type: "drawing_message", drawing: params[:drawing])
  end

  def create_sticker_message
    sticker = Sticker.find(params[:sticker_id])
    chat.messages.create!(author: user, message_type: "sticker_message", sticker: sticker)
  end

  def create_text_messages
    text_fragments = params[:text].scan(/.{1,1000}/)
    text_fragments.each do |fragment|
      next if fragment.strip.empty?
      chat.messages.create!(author: user, message_type: "text_message", text: fragment)
    end
  end
end
