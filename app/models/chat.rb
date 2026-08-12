class Chat < ApplicationRecord
  enum :chat_type, { direct_chat: 0, group_chat: 1, self_chat: 2 }

  has_many :chat_members
  has_many :users, through: :chat_members
  has_many :messages

  accepts_nested_attributes_for :chat_members

  validate :members_count

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
