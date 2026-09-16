class Chat < ApplicationRecord
  enum :chat_type, { direct_chat: 0, group_chat: 1, self_chat: 2 }

  has_many :chat_members
  has_many :users, through: :chat_members
  has_many :messages
  has_one :last_message, -> { order(created_at: :desc) }, class_name: "Message"

  has_one_attached :cover

  accepts_nested_attributes_for :chat_members

  validate :members_count

  def recipient(current_user)
    users.find { |user| user.id != current_user.id }
  end

  private

  def members_count
    case chat_type
    when "direct_chat"
      errors.add(:base, "Direct chat can only have two members") unless chat_members.size == 2
    when "self_chat"
      errors.add(:base, "Self chat can only have one member") unless chat_members.size == 1
    end
  end
end
