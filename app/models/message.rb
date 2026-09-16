class Message < ApplicationRecord
  enum :message_type, { text_message: 0, drawing_message: 1, sticker_message: 2 }

  belongs_to :author, class_name: "User"
  belongs_to :chat
  belongs_to :replied_message, class_name: "Message", optional: true
  belongs_to :sticker, optional: true

  has_one_attached :drawing

  validate :content_matches_message_type

  private

  def content_matches_message_type
    case message_type
    when "text_message"
      errors.add(:text, "can't be blank") if text.blank?
    when "drawing_message"
      errors.add(:drawing, "can't be blank") unless drawing.attached?
    when "sticker_message"
      errors.add(:sticker, "can't be blank") if sticker.blank?
    end
  end
end
