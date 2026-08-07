class Chat < ApplicationRecord
  enum :chat_type, { direct_chat: 0, group_chat: 1 }

  has_many :chat_members
  has_many :messages
end
